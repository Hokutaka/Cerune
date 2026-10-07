//! 型付きMIRの局所値・命令・CFGを直接実行します。
//! HIR実行器やbytecode/VMの実行には委譲しません。
use crate::{
    ir,
    mir::{self, InstructionKind as I, Operation as O, TerminatorKind as T},
    runtime::{
        FailureCode, RuntimeFailure,
        array_heap::{ArrayError, ArrayHeap, ArrayValue},
        numeric::{self, Number},
        string_heap::{HeapError, StringHeap},
        value::{self, Value},
    },
    types::IntegerType,
};

/// emit-mir内の関数・ブロック・命令を識別します。Noneは入口の本体です。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Location {
    pub function: Option<ir::FunctionId>,
    pub block: mir::BlockId,
    pub instruction: mir::InstructionId,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ErrorKind {
    Validation(Box<mir::Error>),
    Runtime(FailureCode),
    InvalidMir(&'static str),
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ExecutionError {
    kind: ErrorKind,
    origin: Option<mir::SourceOrigin>,
    location: Option<Location>,
    output: String,
}
impl ExecutionError {
    pub fn kind(&self) -> &ErrorKind {
        &self.kind
    }
    pub fn origin(&self) -> Option<mir::SourceOrigin> {
        self.origin
    }
    pub fn location(&self) -> Option<Location> {
        self.location
    }
    pub fn output(&self) -> &str {
        &self.output
    }
    pub fn runtime_failure(&self) -> Option<RuntimeFailure> {
        match (&self.kind, self.origin) {
            (ErrorKind::Runtime(code), Some(o)) => Some(RuntimeFailure {
                code: *code,
                node_id: o.node_id,
                span: o.span,
            }),
            _ => None,
        }
    }
    pub fn diagnostic(&self) -> crate::diagnostic::Diagnostic {
        if let ErrorKind::Validation(e) = &self.kind {
            return e.diagnostic();
        }
        let message = match &self.kind {
            ErrorKind::Runtime(code) => format!("runtime error: {}", code.name()),
            ErrorKind::InvalidMir(reason) => format!("invalid Cerune MIR: {reason}"),
            ErrorKind::Validation(_) => unreachable!(),
        };
        match self.origin {
            Some(o) => crate::diagnostic::Diagnostic::new(message, o.span),
            None => crate::diagnostic::Diagnostic::without_span(message),
        }
    }
}
impl std::fmt::Display for ExecutionError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.diagnostic().message())
    }
}
impl std::error::Error for ExecutionError {}

#[derive(Debug)]
struct Fault {
    kind: ErrorKind,
    origin: Option<mir::SourceOrigin>,
    location: Option<Location>,
}
type Result<T> = std::result::Result<T, Fault>;
impl Fault {
    fn invalid(reason: &'static str) -> Self {
        Self {
            kind: ErrorKind::InvalidMir(reason),
            origin: None,
            location: None,
        }
    }
    fn failure(code: FailureCode) -> Self {
        Self {
            kind: ErrorKind::Runtime(code),
            origin: None,
            location: None,
        }
    }
    fn at(mut self, location: Location, origin: mir::Origin) -> Self {
        // 呼出し先で決まった命令と出自を、呼出し元の位置で上書きしません。
        if self.location.is_none() {
            self.location = Some(location);
            self.origin = origin.source();
        }
        self
    }
}
impl From<value::Error> for Fault {
    fn from(e: value::Error) -> Self {
        match e {
            value::Error::Invalid(s) => Self::invalid(s),
            value::Error::Runtime(c) => Self::failure(c),
        }
    }
}
impl From<ArrayError> for Fault {
    fn from(e: ArrayError) -> Self {
        match e {
            ArrayError::AllocationSizeOverflow => {
                Self::failure(FailureCode::AllocationSizeOverflow)
            }
            ArrayError::AllocationLimitExceeded => {
                Self::failure(FailureCode::AllocationLimitExceeded)
            }
            ArrayError::AllocationFailed => Self::failure(FailureCode::AllocationFailed),
            ArrayError::IndexOutOfBounds => Self::failure(FailureCode::ArrayIndexOutOfBounds),
            ArrayError::InvalidOwnership => Self::invalid("invalid array ownership"),
        }
    }
}
impl From<HeapError> for Fault {
    fn from(e: HeapError) -> Self {
        match e {
            HeapError::AllocationSizeOverflow => Self::failure(FailureCode::AllocationSizeOverflow),
            HeapError::AllocationLimitExceeded => {
                Self::failure(FailureCode::AllocationLimitExceeded)
            }
            HeapError::AllocationFailed => Self::failure(FailureCode::AllocationFailed),
            HeapError::InvalidStringOwnership => Self::invalid("invalid string ownership"),
        }
    }
}
struct Frame {
    values: Vec<Option<Value>>,
}
impl Frame {
    fn get(&self, id: mir::LocalId) -> Result<Value> {
        self.values
            .get(id.0)
            .and_then(|v| v.clone())
            .ok_or_else(|| Fault::invalid("uninitialized MIR local"))
    }
    fn set(&mut self, id: mir::LocalId, v: Value) -> Result<()> {
        *self
            .values
            .get_mut(id.0)
            .ok_or_else(|| Fault::invalid("unknown MIR local"))? = Some(v);
        Ok(())
    }
    fn arguments(&self, args: &[mir::LocalId]) -> Result<Vec<Value>> {
        args.iter().map(|v| self.get(*v)).collect()
    }
}
struct Executor<'a> {
    program: &'a mir::Program,
    output: String,
    strings: StringHeap,
    arrays: ArrayHeap<Value>,
    active: Vec<Option<ir::FunctionId>>,
}
/// コンパイラ内で構築したMIRを検証後、新しい実行状態で実行します。
/// 成功時にも論理的な領域が残っていたら内部不整合として返します。
/// 外部の不正入力に対するsandboxや、実行時間の制限を提供するAPIではありません。
pub fn run(program: &mir::Program) -> std::result::Result<String, ExecutionError> {
    mir::validate(program).map_err(|e| ExecutionError {
        origin: e.origin,
        kind: ErrorKind::Validation(Box::new(e)),
        location: None,
        output: String::new(),
    })?;
    let mut executor = Executor::new(program);
    let result = executor.entry();
    match result {
        Ok(()) => Ok(executor.output),
        Err(e) => Err(ExecutionError {
            kind: e.kind,
            origin: e.origin,
            location: e.location,
            output: executor.output,
        }),
    }
}
impl<'a> Executor<'a> {
    fn new(program: &'a mir::Program) -> Self {
        Self {
            program,
            output: String::new(),
            strings: StringHeap::new(program.string_heap_limit),
            arrays: ArrayHeap::new(program.array_heap_limit),
            active: vec![],
        }
    }
    fn entry(&mut self) -> Result<()> {
        let program = self.program;
        self.function(&program.main, vec![])?;
        if !self.strings.is_empty() || !self.arrays.is_empty() {
            return Err(Fault::invalid(
                "live owned storage after successful MIR execution",
            ));
        }
        Ok(())
    }
    fn call(&mut self, id: ir::FunctionId, args: Vec<Value>) -> Result<Option<Value>> {
        let program = self.program;
        let f = program
            .functions
            .get(id.0)
            .filter(|f| f.id == Some(id))
            .ok_or_else(|| Fault::invalid("unknown MIR function"))?;
        self.function(f, args)
    }
    fn function(&mut self, f: &mir::Function, args: Vec<Value>) -> Result<Option<Value>> {
        if self.active.contains(&f.id) {
            return Err(Fault::invalid("recursive MIR call is not supported"));
        }
        if f.parameters.len() != args.len() {
            return Err(Fault::invalid("MIR argument count"));
        }
        let mut frame = Frame {
            values: vec![None; f.locals.len()],
        };
        for (id, v) in f.parameters.iter().zip(args) {
            v.check(&f.locals[id.0].ty)?;
            frame.set(*id, v)?;
        }
        self.active.push(f.id);
        let result = self.blocks(f, &mut frame);
        self.active.pop();
        result
    }
    fn blocks(&mut self, f: &mir::Function, frame: &mut Frame) -> Result<Option<Value>> {
        let mut current = f.entry;
        loop {
            let b = f
                .blocks
                .get(current.0)
                .ok_or_else(|| Fault::invalid("unknown MIR block"))?;
            for i in &b.instructions {
                self.instruction(f, &i.kind, frame).map_err(|e| {
                    e.at(
                        Location {
                            function: f.id,
                            block: current,
                            instruction: i.id,
                        },
                        i.origin,
                    )
                })?;
            }
            let location = Location {
                function: f.id,
                block: current,
                instruction: b.terminator.id,
            };
            let fault = |e: Fault| e.at(location, b.terminator.origin);
            match &b.terminator.kind {
                T::Jump(next) => current = *next,
                T::Branch {
                    condition,
                    then_block,
                    else_block,
                } => {
                    let yes = frame
                        .get(*condition)
                        .and_then(|v| v.boolean().map_err(Into::into))
                        .map_err(fault)?;
                    current = if yes { *then_block } else { *else_block };
                }
                T::Return(v) => {
                    let result = v.map(|v| frame.get(v)).transpose().map_err(fault)?;
                    match (&f.return_type, &result) {
                        (ir::ReturnType::Void, None) => {}
                        (ir::ReturnType::Value(t), Some(v)) => {
                            v.check(t).map_err(Fault::from).map_err(fault)?
                        }
                        _ => return Err(fault(Fault::invalid("MIR return signature"))),
                    }
                    return Ok(result);
                }
                T::Unreachable => {
                    return Err(fault(Fault::invalid("reached unreachable MIR block")));
                }
            }
        }
    }
    fn instruction(&mut self, f: &mir::Function, i: &I, frame: &mut Frame) -> Result<()> {
        match i {
            I::Assign { destination, value } => {
                let ty = &f.locals[destination.0].ty;
                let v = self.operation(value, ty, frame)?;
                v.check(ty)?;
                frame.set(*destination, v)?;
            }
            I::Call {
                function,
                arguments,
                ..
            } => {
                self.call(*function, frame.arguments(arguments)?)?;
            }
            I::CheckIndex { root, path } => {
                // 最後の要素を読まず、長さで検査します。未初期化要素の読取りとは区別します。
                let mut v = frame.get(*root)?;
                for (n, id) in path.iter().enumerate() {
                    let index = checked_index(
                        frame.get(*id)?.integer(IntegerType::I64)?,
                        array_length(&v)?,
                    )?;
                    if n + 1 < path.len() {
                        v = array_get(v, index)?;
                    }
                }
            }
            I::Store { root, path, value } => {
                let indices = path
                    .iter()
                    .map(|id| {
                        usize::try_from(frame.get(*id)?.integer(IntegerType::I64)?)
                            .map_err(|_| Fault::invalid("invalid checked index"))
                    })
                    .collect::<Result<Vec<_>>>()?;
                let mut destination = frame.get(*root)?;
                set_path(&mut destination, &indices, frame.get(*value)?)?;
                frame.set(*root, destination)?;
            }
            I::Output {
                value: v,
                newline,
                quoted,
            } => {
                let text = frame.get(*v)?.text()?;
                if *quoted {
                    value::write_quoted(&mut self.output, &text);
                } else {
                    self.output.push_str(&text);
                }
                if *newline {
                    self.output.push('\n');
                }
            }
            I::ArrayInitialize { array, value } => {
                let array = dynamic(frame.get(*array)?)?;
                self.arrays.initialize(&array, frame.get(*value)?)?;
            }
            I::ArrayRetain { value } => self.arrays.retain(&dynamic(frame.get(*value)?)?)?,
            I::ArrayFree { value } => self.arrays.free(&dynamic(frame.get(*value)?)?)?,
            I::ArrayRangeCheck { length, start, end } => {
                let length = frame.get(*length)?.integer(IntegerType::I64)?;
                let start = frame.get(*start)?.integer(IntegerType::I64)?;
                let end = frame.get(*end)?.integer(IntegerType::I64)?;
                if start < 0 || start > end || end > length {
                    return Err(Fault::failure(FailureCode::ArrayRangeOutOfBounds));
                }
            }
            I::StringManage { value, retain } => self
                .strings
                .manage(&frame.get(*value)?.string()?, *retain)?,
        }
        Ok(())
    }
    fn operation(&mut self, op: &O, ty: &ir::Type, frame: &Frame) -> Result<Value> {
        Ok(match op {
            O::Literal(v) => match v {
                mir::Literal::Boolean(v) => Value::Bool(*v),
                mir::Literal::String(v) => Value::String(v.clone().into()),
                mir::Literal::Integer(v) => {
                    let ir::Type::Integer(t) = ty else {
                        return Err(Fault::invalid("integer literal type"));
                    };
                    Value::Number(Number::Integer(*v, *t))
                }
                mir::Literal::Float(v) => Value::Number(match ty {
                    ir::Type::F32 => {
                        Number::F32(v.parse().map_err(|_| Fault::invalid("f32 literal"))?)
                    }
                    ir::Type::F64 => {
                        Number::F64(v.parse().map_err(|_| Fault::invalid("f64 literal"))?)
                    }
                    _ => return Err(Fault::invalid("float literal type")),
                }),
            },
            O::Copy(v) => frame.get(*v)?,
            O::Unary { op, value: v } => value::unary(*op, frame.get(*v)?)?,
            O::Binary { op, left, right } => {
                value::binary(*op, frame.get(*left)?, frame.get(*right)?)?
            }
            O::ConvertInteger {
                value, from, to, ..
            } => {
                let n = frame.get(*value)?.integer(*from)?;
                if !to.contains(n) {
                    return Err(Fault::failure(FailureCode::IntegerConversionOutOfRange));
                }
                Value::Number(Number::Integer(n, *to))
            }
            O::ConvertNumeric {
                value: v,
                from,
                to,
                mode,
                ..
            } => Value::Number(
                numeric::convert_with_mode(frame.get(*v)?.number()?, *from, *to, *mode)
                    .map_err(value::numeric_error)?,
            ),
            O::Array(values) => {
                let ir::Type::Array { element, .. } = ty else {
                    return Err(Fault::invalid("array result type"));
                };
                Value::Array {
                    element: *element.clone(),
                    values: frame.arguments(values)?,
                }
            }
            O::Construct { ty, base, fields } => {
                let count = self
                    .program
                    .types
                    .get(ty.0)
                    .ok_or_else(|| Fault::invalid("unknown product"))?
                    .fields
                    .len();
                let mut result = if let Some(base) = base {
                    let Value::Aggregate { fields, .. } = frame.get(*base)? else {
                        return Err(Fault::invalid("product base"));
                    };
                    fields.into_iter().map(Some).collect::<Vec<_>>()
                } else {
                    vec![None; count]
                };
                for (id, v) in fields {
                    *result
                        .get_mut(id.0)
                        .ok_or_else(|| Fault::invalid("unknown field"))? = Some(frame.get(*v)?);
                }
                Value::Aggregate {
                    type_id: *ty,
                    fields: result
                        .into_iter()
                        .map(|v| v.ok_or_else(|| Fault::invalid("missing field")))
                        .collect::<Result<_>>()?,
                }
            }
            O::Field { base, field, .. } => {
                let Value::Aggregate { fields, .. } = frame.get(*base)? else {
                    return Err(Fault::invalid("field of non-product"));
                };
                fields
                    .get(field.0)
                    .cloned()
                    .ok_or_else(|| Fault::invalid("unknown field"))?
            }
            O::Index { base, index } => {
                let base = frame.get(*base)?;
                let index = checked_index(
                    frame.get(*index)?.integer(IntegerType::I64)?,
                    array_length(&base)?,
                )?;
                array_get(base, index)?
            }
            O::Call {
                function,
                arguments,
                ..
            } => self
                .call(*function, frame.arguments(arguments)?)?
                .ok_or_else(|| Fault::invalid("void call used as value"))?,
            O::ArrayLength(v) => Value::Number(Number::Integer(
                array_length(&frame.get(*v)?)? as i128,
                IntegerType::I64,
            )),
            O::StringByteLength(v) => Value::Number(Number::Integer(
                frame.get(*v)?.string()?.len() as i128,
                IntegerType::I64,
            )),
            O::StringConcat { left, right } => Value::String(
                self.strings
                    .concat(&frame.get(*left)?.string()?, &frame.get(*right)?.string()?)?,
            ),
            O::ArrayAllocate {
                length,
                element_width,
            } => {
                let ir::Type::DynamicArray { element } = ty else {
                    return Err(Fault::invalid("array allocate type"));
                };
                let length = u64::try_from(frame.get(*length)?.integer(IntegerType::I64)?)
                    .map_err(|_| Fault::failure(FailureCode::AllocationSizeOverflow))?;
                Value::DynamicArray {
                    element: *element.clone(),
                    storage: self.arrays.allocate(length, *element_width)?,
                }
            }
            O::ArrayReleaseOwner(v) => {
                Value::Bool(self.arrays.release_owner(&dynamic(frame.get(*v)?)?)?)
            }
        })
    }
}
fn dynamic(v: Value) -> Result<ArrayValue<Value>> {
    if let Value::DynamicArray { storage, .. } = v {
        Ok(storage)
    } else {
        Err(Fault::invalid("expected dynamic array"))
    }
}
fn array_length(v: &Value) -> Result<usize> {
    match v {
        Value::Array { values, .. } => Ok(values.len()),
        Value::DynamicArray { storage, .. } => Ok(storage.len()),
        _ => Err(Fault::invalid("expected array")),
    }
}
fn checked_index(index: i128, length: usize) -> Result<usize> {
    usize::try_from(index)
        .ok()
        .filter(|i| *i < length)
        .ok_or_else(|| Fault::failure(FailureCode::ArrayIndexOutOfBounds))
}
fn array_get(v: Value, index: usize) -> Result<Value> {
    match v {
        Value::Array { values, .. } => values
            .get(index)
            .cloned()
            .ok_or_else(|| Fault::invalid("invalid checked index")),
        Value::DynamicArray { storage, .. } => Ok(storage.get(index)?),
        _ => Err(Fault::invalid("expected array")),
    }
}
fn set_path(v: &mut Value, path: &[usize], replacement: Value) -> Result<()> {
    let Some((&index, rest)) = path.split_first() else {
        *v = replacement;
        return Ok(());
    };
    match v {
        Value::Array { values, .. } => set_path(
            values
                .get_mut(index)
                .ok_or_else(|| Fault::invalid("invalid checked index"))?,
            rest,
            replacement,
        ),
        Value::DynamicArray { storage, .. } => {
            let mut item = storage.get(index)?;
            set_path(&mut item, rest, replacement)?;
            storage.set(index, item)?;
            Ok(())
        }
        _ => Err(Fault::invalid("invalid array path")),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn injected_allocation_failures_keep_site_and_prior_output() {
        for (src, array, expected) in [
            (
                r#"print("before"); print(concat("a","b"));"#,
                false,
                r#"concat("a","b")"#,
            ),
            (
                r#"print("before"); a:[i64]=array_copy([1]);print(a);"#,
                true,
                "array_copy([1])",
            ),
        ] {
            let p = crate::mir::lower(&crate::compile_to_ir(src).unwrap()).unwrap();
            let mut executor = Executor::new(&p);
            if array {
                executor.arrays.fail_next_allocation();
            } else {
                executor.strings.fail_next_allocation();
            }
            let e = executor.entry().unwrap_err();
            assert_eq!(e.kind, ErrorKind::Runtime(FailureCode::AllocationFailed));
            assert_eq!(executor.output, "before\n");
            let o = e.origin.unwrap();
            assert_eq!(&src[o.span.start()..o.span.end()], expected);
            assert!(e.location.is_some());
            assert!(executor.arrays.is_empty());
            assert!(executor.strings.is_empty());
            assert!(run(&p).is_ok());
        }
    }
}
