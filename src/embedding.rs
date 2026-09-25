use std::sync::Arc;

use crate::{
    ExecutionError,
    bytecode::{BytecodeProgram, ReturnType, Type},
    vm,
};

/// Cerune VMの埋め込み実行で、ホストとの境界を通過する値です。
///
/// VM内部の値表現とは独立した公開型です。
/// 最初の実装では`f64`だけを扱います。
#[derive(Debug, Clone, PartialEq)]
#[non_exhaustive]
pub enum HostValue {
    F64(f64),
}

/// 生成済みbytecode内で解決された関数を表します。
///
/// 元の`BytecodeProgram`を共有所有するため、別のprogramと
/// 解決済み関数を誤って組み合わせることはできません。
///
/// VM内部の数値IDは公開せず、永続的な関数識別子としても扱いません。
#[derive(Debug, Clone)]
pub struct ResolvedFunction {
    program: Arc<BytecodeProgram>,
    function_id: usize,
    parameter_count: usize,
}

/// 関数名の解決に失敗した理由です。
#[derive(Debug, Clone, PartialEq, Eq)]
#[non_exhaustive]
pub enum FunctionResolutionError {
    NotFound { name: String },
    Ambiguous { name: String, matches: usize },
    UnsupportedParameterType { name: String, index: usize },
    UnsupportedReturnType { name: String },
}

/// 生成済みbytecodeから関数名を解決します。
///
/// 現在のHost Value境界で扱える`f64`引数と、`f64`または`void`の
/// 戻り値を持つ関数だけを解決します。
///
/// 解決後の`ResolvedFunction`は、同じbytecodeを再コンパイルせずに
/// 繰り返し実行できます。
pub fn resolve_function(
    program: Arc<BytecodeProgram>,
    name: &str,
) -> Result<ResolvedFunction, FunctionResolutionError> {
    let function_id = {
        let mut matches = program
            .functions
            .iter()
            .enumerate()
            .filter(|(_, function)| function.name == name);

        let Some((function_id, _)) = matches.next() else {
            return Err(FunctionResolutionError::NotFound {
                name: name.to_owned(),
            });
        };

        let additional_matches = matches.count();
        if additional_matches != 0 {
            return Err(FunctionResolutionError::Ambiguous {
                name: name.to_owned(),
                matches: additional_matches + 1,
            });
        }

        function_id
    };

    let function = &program.functions[function_id];

    for index in 0..function.parameter_count {
        let Some(slot) = function.slots.get(index) else {
            return Err(FunctionResolutionError::UnsupportedParameterType {
                name: name.to_owned(),
                index,
            });
        };

        if &slot.ty != &Type::F64 {
            return Err(FunctionResolutionError::UnsupportedParameterType {
                name: name.to_owned(),
                index,
            });
        }
    }

    match &function.return_type {
        ReturnType::Void | ReturnType::Value(Type::F64) => {}
        _ => {
            return Err(FunctionResolutionError::UnsupportedReturnType {
                name: name.to_owned(),
            });
        }
    }

    let parameter_count = function.parameter_count;

    Ok(ResolvedFunction {
        program,
        function_id,
        parameter_count,
    })
}

/// 埋め込み関数実行の正常終了結果です。
#[derive(Debug, Clone, PartialEq)]
pub struct FunctionExecution {
    return_value: Option<HostValue>,
    output: String,
}

impl FunctionExecution {
    /// 関数の戻り値を返します。
    pub fn return_value(&self) -> Option<&HostValue> {
        self.return_value.as_ref()
    }

    /// 関数実行中に生成された出力を返します。
    pub fn output(&self) -> &str {
        &self.output
    }
}

/// 埋め込み関数を呼び出せなかった理由です。
#[derive(Debug, Clone, PartialEq, Eq)]
#[non_exhaustive]
pub enum FunctionInvocationError {
    InvalidArgumentCount { expected: usize, actual: usize },
    UnsupportedReturnValue,
    Execution(ExecutionError),
}

/// 解決済み関数を、ホスト値の引数で実行します。
///
/// ソースのコンパイルと関数名の解決は行いません。
/// 呼び出しごとに必要なのはHost ValueからVM Valueへの変換と、
/// 既存VM関数frameの実行だけです。
pub fn invoke_function(
    function: &ResolvedFunction,
    arguments: &[HostValue],
) -> Result<FunctionExecution, FunctionInvocationError> {
    if arguments.len() != function.parameter_count {
        return Err(FunctionInvocationError::InvalidArgumentCount {
            expected: function.parameter_count,
            actual: arguments.len(),
        });
    }

    let vm_arguments = arguments.iter().map(host_value_to_vm).collect();
    let program = function.program.as_ref();

    let (return_value, output) = vm::execute_function(program, function.function_id, vm_arguments)
        .map_err(|vm_error| {
            FunctionInvocationError::Execution(ExecutionError::from_vm_error(program, vm_error))
        })?;

    let return_value = match return_value {
        None => None,
        Some(vm::Value::F64(value)) => Some(HostValue::F64(value)),
        Some(_) => return Err(FunctionInvocationError::UnsupportedReturnValue),
    };

    Ok(FunctionExecution {
        return_value,
        output,
    })
}

fn host_value_to_vm(value: &HostValue) -> vm::Value {
    match value {
        HostValue::F64(value) => vm::Value::F64(*value),
    }
}

#[cfg(test)]
mod tests {
    use std::sync::Arc;

    use super::{
        FunctionInvocationError, FunctionResolutionError, HostValue, invoke_function,
        resolve_function,
    };
    use crate::{compile_to_bytecode, vm::VmErrorKind};

    #[test]
    fn resolves_function_by_name() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
                fn add(lhs: f64, rhs: f64) -> f64 {
                    return lhs + rhs;
                }
                "#,
            )
            .unwrap(),
        );

        let resolved = resolve_function(Arc::clone(&program), "add").unwrap();

        let expected_id = program
            .functions
            .iter()
            .position(|function| function.name == "add")
            .unwrap();

        assert_eq!(resolved.function_id, expected_id);
    }

    #[test]
    fn reports_missing_function() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
                fn add(lhs: f64, rhs: f64) -> f64 {
                    return lhs + rhs;
                }
                "#,
            )
            .unwrap(),
        );

        assert!(matches!(
            resolve_function(Arc::clone(&program), "missing"),
            Err(FunctionResolutionError::NotFound { name })
                if name == "missing"
        ));
    }

    #[test]
    fn rejects_ambiguous_function_name() {
        let mut program = compile_to_bytecode(
            r#"
            fn add(lhs: f64, rhs: f64) -> f64 {
                return lhs + rhs;
            }
            "#,
        )
        .unwrap();

        let duplicate = program.functions[0].clone();
        program.functions.push(duplicate);

        let program = Arc::new(program);

        assert!(matches!(
            resolve_function(Arc::clone(&program), "add"),
            Err(FunctionResolutionError::Ambiguous { name, matches: 2 })
                if name == "add"
        ));
    }

    #[test]
    fn rejects_unsupported_parameter_type() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
                fn identity(value: i64) -> i64 {
                    return value;
                }
                "#,
            )
            .unwrap(),
        );

        assert!(matches!(
            resolve_function(Arc::clone(&program), "identity"),
            Err(FunctionResolutionError::UnsupportedParameterType {
                name,
                index: 0,
            }) if name == "identity"
        ));
    }

    #[test]
    fn rejects_unsupported_return_type() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
                fn constant() -> i64 {
                    return 1;
                }
                "#,
            )
            .unwrap(),
        );

        assert!(matches!(
            resolve_function(Arc::clone(&program), "constant"),
            Err(FunctionResolutionError::UnsupportedReturnType { name })
                if name == "constant"
        ));
    }

    #[test]
    fn invokes_resolved_f64_function() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
                fn add(lhs: f64, rhs: f64) -> f64 {
                    return lhs + rhs;
                }
                "#,
            )
            .unwrap(),
        );

        let function = resolve_function(Arc::clone(&program), "add").unwrap();
        let execution =
            invoke_function(&function, &[HostValue::F64(1.25), HostValue::F64(2.5)]).unwrap();

        assert_eq!(execution.return_value(), Some(&HostValue::F64(3.75)));
        assert_eq!(execution.output(), "");
    }

    #[test]
    fn reports_invalid_argument_count() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
                fn add(lhs: f64, rhs: f64) -> f64 {
                    return lhs + rhs;
                }
                "#,
            )
            .unwrap(),
        );

        let function = resolve_function(Arc::clone(&program), "add").unwrap();

        assert_eq!(
            invoke_function(&function, &[HostValue::F64(1.0)]),
            Err(FunctionInvocationError::InvalidArgumentCount {
                expected: 2,
                actual: 1,
            })
        );
    }

    #[test]
    fn preserves_vm_error_origin() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
                fn pick(value: f64) -> f64 {
                    values: [f64; 1] = [value];
                    return values[1];
                }
                "#,
            )
            .unwrap(),
        );

        let function = resolve_function(Arc::clone(&program), "pick").unwrap();
        let error = invoke_function(&function, &[HostValue::F64(2.0)]).unwrap_err();

        let FunctionInvocationError::Execution(error) = error else {
            panic!("expected VM execution error");
        };

        assert_eq!(
            error.vm_error().kind(),
            VmErrorKind::ArrayIndexOutOfBounds {
                index: 1,
                length: 1,
            }
        );
        assert!(error.origin().is_some());
    }

    #[test]
    fn reuses_resolved_function_for_repeated_invocation() {
        let program = Arc::new(
            compile_to_bytecode(
                r#"
            fn add(lhs: f64, rhs: f64) -> f64 {
                return lhs + rhs;
            }
            "#,
            )
            .unwrap(),
        );

        let function = resolve_function(Arc::clone(&program), "add").unwrap();

        let first =
            invoke_function(&function, &[HostValue::F64(1.0), HostValue::F64(2.0)]).unwrap();
        let second =
            invoke_function(&function, &[HostValue::F64(10.5), HostValue::F64(20.25)]).unwrap();

        assert_eq!(first.return_value(), Some(&HostValue::F64(3.0)));
        assert_eq!(second.return_value(), Some(&HostValue::F64(30.75)));
        assert_eq!(first.output(), "");
        assert_eq!(second.output(), "");
    }
}
