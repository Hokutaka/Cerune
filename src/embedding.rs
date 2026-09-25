use crate::bytecode::BytecodeProgram;

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
/// VM内部の数値IDは公開せず、永続的な関数識別子としても扱いません。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ResolvedFunction {
    function_id: usize,
}

/// 関数名の解決に失敗した理由です。
#[derive(Debug, Clone, PartialEq, Eq)]
#[non_exhaustive]
pub enum FunctionResolutionError {
    NotFound { name: String },
    Ambiguous { name: String, matches: usize },
}

/// 生成済みbytecodeから関数名を解決します。
///
/// 解決後の`ResolvedFunction`は、同じ`BytecodeProgram`で繰り返し実行するために使います。
pub fn resolve_function(
    program: &BytecodeProgram,
    name: &str,
) -> Result<ResolvedFunction, FunctionResolutionError> {
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

    Ok(ResolvedFunction { function_id })
}

#[cfg(test)]
mod tests {
    use super::{FunctionResolutionError, resolve_function};
    use crate::compile_to_bytecode;

    #[test]
    fn resolves_function_by_name() {
        let program = compile_to_bytecode(
            r#"
            fn add(lhs: f64, rhs: f64) -> f64 {
                return lhs + rhs;
            }
            "#,
        )
        .unwrap();

        let resolved = resolve_function(&program, "add").unwrap();

        let expected_id = program
            .functions
            .iter()
            .position(|function| function.name == "add")
            .unwrap();

        assert_eq!(resolved.function_id, expected_id);
    }

    #[test]
    fn reports_missing_function() {
        let program = compile_to_bytecode(
            r#"
            fn add(lhs: f64, rhs: f64) -> f64 {
                return lhs + rhs;
            }
            "#,
        )
        .unwrap();

        assert_eq!(
            resolve_function(&program, "missing"),
            Err(FunctionResolutionError::NotFound {
                name: "missing".to_owned(),
            })
        );
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

        assert_eq!(
            resolve_function(&program, "add"),
            Err(FunctionResolutionError::Ambiguous {
                name: "add".to_owned(),
                matches: 2,
            })
        );
    }
}
