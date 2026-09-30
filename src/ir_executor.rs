//! 完成済みのCerune IRを直接実行します。命令列や別のIRへ変換しません。
mod value;
use crate::{
    ir::{self, Expr, ExprKind as E, Statement, StatementKind as S},
    runtime::{
        FailureCode, RuntimeFailure,
        numeric::{self, Number},
        string_heap::{HeapError, StringHeap},
    },
    source::Span,
    types::IntegerType,
};
use std::collections::HashMap;
use value::Value;

/// IR上の要素と、その由来となるソース位置です。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Origin {
    pub node_id: ir::NodeId,
    pub span: Span,
}
/// 言語の異常停止と、不正なIRによる内部問題を区別します。
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ErrorKind {
    Runtime(FailureCode),
    InvalidIr(&'static str),
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ExecutionError {
    kind: ErrorKind,
    origin: Option<Origin>,
    output: String,
}
impl ExecutionError {
    pub fn kind(&self) -> &ErrorKind {
        &self.kind
    }
    pub const fn origin(&self) -> Option<Origin> {
        self.origin
    }
    pub fn output(&self) -> &str {
        &self.output
    }
    pub fn runtime_failure(&self) -> Option<RuntimeFailure> {
        match (&self.kind, self.origin) {
            (ErrorKind::Runtime(code), Some(origin)) => Some(RuntimeFailure {
                code: *code,
                node_id: origin.node_id,
                span: origin.span,
            }),
            _ => None,
        }
    }
    pub fn diagnostic(&self) -> crate::diagnostic::Diagnostic {
        let message = match self.kind {
            ErrorKind::Runtime(code) => format!("runtime error: {}", code.name()),
            ErrorKind::InvalidIr(reason) => format!("invalid Cerune IR: {reason}"),
        };
        match self.origin {
            Some(origin) => crate::diagnostic::Diagnostic::new(message, origin.span),
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
    origin: Option<Origin>,
}
type Result<T> = std::result::Result<T, Fault>;
impl Fault {
    fn invalid(reason: &'static str) -> Self {
        Self {
            kind: ErrorKind::InvalidIr(reason),
            origin: None,
        }
    }
    fn failure(code: FailureCode) -> Self {
        Self {
            kind: ErrorKind::Runtime(code),
            origin: None,
        }
    }
    fn at(mut self, node_id: ir::NodeId, span: Span) -> Self {
        // 既に失敗した子の式・関数の出自は上書きしません。
        if self.origin.is_none() {
            self.origin = Some(Origin { node_id, span });
        }
        self
    }
}
fn heap_error(e: HeapError) -> Fault {
    match e {
        HeapError::AllocationSizeOverflow => Fault::failure(FailureCode::AllocationSizeOverflow),
        HeapError::AllocationLimitExceeded => Fault::failure(FailureCode::AllocationLimitExceeded),
        HeapError::AllocationFailed => Fault::failure(FailureCode::AllocationFailed),
        HeapError::InvalidStringOwnership => Fault::invalid("invalid string ownership"),
    }
}
struct Binding {
    value: Value,
    mutable: bool,
    initializer: Option<ir::NodeId>,
}
type Frame = HashMap<ir::BindingId, Binding>;
enum Flow {
    Next,
    Break,
    Continue,
    Return(Option<Value>),
}
struct Executor<'a> {
    program: &'a ir::Program,
    output: String,
    heap: StringHeap,
}

/// 共通フロントエンドが構築したIRを、新しい実行状態で直接実行します。
/// IRは変更しません。失敗時にも、それまでの出力と元の式の位置を保持します。
pub fn run(program: &ir::Program) -> std::result::Result<String, ExecutionError> {
    let mut executor = Executor {
        program,
        output: String::new(),
        heap: StringHeap::new(program.string_heap_limit),
    };
    match executor.entry() {
        Ok(()) => {
            #[cfg(test)]
            executor.heap.assert_empty();
            Ok(executor.output)
        }
        Err(error) => Err(ExecutionError {
            kind: error.kind,
            origin: error.origin,
            output: executor.output,
        }),
    }
}
impl Executor<'_> {
    fn entry(&mut self) -> Result<()> {
        let program = self.program;
        match self.body(&program.statements, &mut Frame::new())? {
            Flow::Next => {}
            _ => return Err(Fault::invalid("control flow escaped the entry body")),
        }
        if let Some(main) = program
            .function_definitions
            .iter()
            .find(|f| f.name == "main")
        {
            if !main.parameters.is_empty() || main.return_type != ir::ReturnType::Void {
                return Err(Fault::invalid(
                    "main must have no parameters and return void",
                ));
            }
            self.call(main.id, vec![])?;
        }
        Ok(())
    }
    fn call(&mut self, id: ir::FunctionId, arguments: Vec<Value>) -> Result<Option<Value>> {
        let program = self.program;
        let f = program
            .function_definitions
            .get(id.0)
            .filter(|f| f.id == id)
            .ok_or_else(|| Fault::invalid("unknown function"))?;
        if f.parameters.len() != arguments.len() {
            return Err(Fault::invalid("incorrect argument count"));
        }
        let mut frame = Frame::new();
        for (p, value) in f.parameters.iter().zip(arguments) {
            value.check(&p.ty)?;
            if frame
                .insert(
                    p.id,
                    Binding {
                        value,
                        mutable: false,
                        initializer: None,
                    },
                )
                .is_some()
            {
                return Err(Fault::invalid("duplicate parameter binding"));
            }
        }
        let result = match self.body(&f.body, &mut frame)? {
            Flow::Next => None,
            Flow::Return(value) => value,
            _ => return Err(Fault::invalid("loop control escaped a function")),
        };
        match (&f.return_type, &result) {
            (ir::ReturnType::Void, None) => {}
            (ir::ReturnType::Value(ty), Some(value)) => value.check(ty)?,
            _ => return Err(Fault::invalid("return value does not match the function")),
        }
        Ok(result)
    }
    fn arguments(&mut self, args: &[Expr], frame: &mut Frame) -> Result<Vec<Value>> {
        args.iter().map(|e| self.expr(e, frame)).collect()
    }
    fn body(&mut self, body: &[Statement], frame: &mut Frame) -> Result<Flow> {
        for s in body {
            match self.statement(s, frame)? {
                Flow::Next => {}
                flow => return Ok(flow),
            }
        }
        Ok(Flow::Next)
    }
    fn statement(&mut self, s: &Statement, frame: &mut Frame) -> Result<Flow> {
        self.statement_inner(s, frame)
            .map_err(|e| e.at(s.id, s.span))
    }
    fn statement_inner(&mut self, s: &Statement, frame: &mut Frame) -> Result<Flow> {
        match &s.kind {
            S::Binding {
                id,
                mutable,
                ty,
                value,
                ..
            } => {
                let value = self.expr(value, frame)?;
                value.check(ty)?;
                if frame.get(id).is_some_and(|b| b.initializer != Some(s.id)) {
                    return Err(Fault::invalid("duplicate binding"));
                }
                frame.insert(
                    *id,
                    Binding {
                        value,
                        mutable: *mutable,
                        initializer: Some(s.id),
                    },
                );
            }
            S::Assignment { target, value } => {
                self.assignment(s, target, value, frame)?;
            }
            S::StringManage { value, retain } => {
                let value = self.expr(value, frame)?.string()?;
                self.heap.manage(&value, *retain).map_err(heap_error)?;
            }
            S::Write { value, quoted } => {
                let text = self.expr(value, frame)?.text()?;
                if *quoted {
                    write_quoted(&mut self.output, &text)
                } else {
                    self.output.push_str(&text);
                }
            }
            S::Print { value } => {
                let text = self.expr(value, frame)?.text()?;
                self.output.push_str(&text);
                self.output.push('\n');
            }
            S::Call {
                function_id,
                arguments,
                ..
            } => {
                let args = self.arguments(arguments, frame)?;
                if self.call(*function_id, args)?.is_some() {
                    return Err(Fault::invalid("value returned to a void call"));
                }
            }
            S::Return { value } => {
                return Ok(Flow::Return(
                    value.as_ref().map(|e| self.expr(e, frame)).transpose()?,
                ));
            }
            S::If {
                condition,
                then_body,
                else_body,
            } => {
                let condition = self.expr(condition, frame)?.boolean()?;
                return self.body(if condition { then_body } else { else_body }, frame);
            }
            S::While { condition, body } => {
                while self.expr(condition, frame)?.boolean()? {
                    match self.body(body, frame)? {
                        Flow::Next | Flow::Continue => {}
                        Flow::Break => break,
                        flow @ Flow::Return(_) => return Ok(flow),
                    }
                }
            }
            S::For {
                initializer,
                condition,
                update,
                body,
            } => {
                if !matches!(self.statement(initializer, frame)?, Flow::Next) {
                    return Err(Fault::invalid("invalid for initializer"));
                }
                while self.expr(condition, frame)?.boolean()? {
                    match self.body(body, frame)? {
                        Flow::Next | Flow::Continue => {}
                        Flow::Break => break,
                        flow @ Flow::Return(_) => return Ok(flow),
                    }
                    if !matches!(self.statement(update, frame)?, Flow::Next) {
                        return Err(Fault::invalid("invalid for update"));
                    }
                }
            }
            S::Break => return Ok(Flow::Break),
            S::Continue => return Ok(Flow::Continue),
        }
        Ok(Flow::Next)
    }
    fn assignment(
        &mut self,
        s: &Statement,
        target: &ir::AssignmentTarget,
        value: &Expr,
        frame: &mut Frame,
    ) -> Result<()> {
        let binding = frame
            .get(&target.id)
            .ok_or_else(|| Fault::invalid("assignment to unknown binding"))?;
        if !binding.mutable {
            return Err(Fault::invalid("assignment to immutable binding"));
        }
        binding.value.check(&target.root_ty)?;
        let mut path = vec![];
        // 各添字の評価・検査を完了してから、次の添字や右辺へ進みます。
        for projection in &target.projections {
            let ir::AssignmentProjection::Index {
                index,
                element,
                length,
                span,
            } = projection;
            let index = self.expr(index, frame)?.integer(IntegerType::I64)?;
            let root = &frame
                .get(&target.id)
                .ok_or_else(|| Fault::invalid("unknown assignment root"))?
                .value;
            let current = at_path(root, &path)?;
            current.check(&ir::Type::Array {
                element: Box::new(element.clone()),
                length: *length,
            })?;
            let index = checked_index(index, *length).map_err(|e| e.at(s.id, *span))?;
            path.push(index);
        }
        let replacement = self.expr(value, frame)?;
        replacement.check(&target.ty)?;
        let root = &mut frame
            .get_mut(&target.id)
            .ok_or_else(|| Fault::invalid("unknown assignment root"))?
            .value;
        let destination = at_path_mut(root, &path)?;
        replacement.check(&destination.ty())?;
        *destination = replacement;
        Ok(())
    }
    fn expr(&mut self, e: &Expr, frame: &mut Frame) -> Result<Value> {
        let value = self
            .expr_inner(e, frame)
            .map_err(|error| error.at(e.id, e.span))?;
        value.check(&e.ty).map_err(|error| error.at(e.id, e.span))?;
        Ok(value)
    }
    fn expr_inner(&mut self, e: &Expr, frame: &mut Frame) -> Result<Value> {
        Ok(match &e.kind {
            E::Boolean(v) => Value::Bool(*v),
            E::String(v) => Value::String(v.clone().into()),
            E::Integer(v) => {
                let ir::Type::Integer(t) = e.ty else {
                    return Err(Fault::invalid("integer literal type"));
                };
                if !t.contains(*v) {
                    return Err(Fault::invalid("integer literal out of range"));
                }
                Value::Number(Number::Integer(*v, t))
            }
            E::Float { text } => Value::Number(match e.ty {
                ir::Type::F32 => Number::F32(
                    text.parse()
                        .map_err(|_| Fault::invalid("invalid f32 literal"))?,
                ),
                ir::Type::F64 => Number::F64(
                    text.parse()
                        .map_err(|_| Fault::invalid("invalid f64 literal"))?,
                ),
                _ => return Err(Fault::invalid("float literal type")),
            }),
            E::Variable { id, .. } => frame
                .get(id)
                .ok_or_else(|| Fault::invalid("read of unknown binding"))?
                .value
                .clone(),
            E::Constant { value, .. } => self.expr(value, frame)?,
            E::StringConcat { left, right } => {
                let left = self.expr(left, frame)?.string()?;
                let right = self.expr(right, frame)?.string()?;
                Value::String(self.heap.concat(&left, &right).map_err(heap_error)?)
            }
            E::StringByteLength { value } => {
                let value = self.expr(value, frame)?.string()?;
                Value::Number(Number::Integer(value.len() as i128, IntegerType::I64))
            }
            E::ArrayLength { value } => {
                let Value::Array { values, .. } = self.expr(value, frame)? else {
                    return Err(Fault::invalid("array_len of non-array"));
                };
                Value::Number(Number::Integer(values.len() as i128, IntegerType::I64))
            }
            E::ConvertInteger {
                value, from, to, ..
            } => {
                let v = self.expr(value, frame)?.integer(*from)?;
                if !to.contains(v) {
                    return Err(Fault::failure(FailureCode::IntegerConversionOutOfRange));
                }
                Value::Number(Number::Integer(v, *to))
            }
            E::ConvertNumeric {
                value,
                from,
                to,
                mode,
                ..
            } => {
                if value::numeric_type(&value.ty) != Some(*from) {
                    return Err(Fault::invalid("conversion source type"));
                }
                let v = self.expr(value, frame)?.number()?;
                Value::Number(
                    numeric::convert_with_mode(v, *from, *to, *mode)
                        .map_err(value::numeric_error)?,
                )
            }
            E::Logical { op, left, right } => {
                let left = self.expr(left, frame)?.boolean()?;
                Value::Bool(match op {
                    ir::LogicalOp::And => left && self.expr(right, frame)?.boolean()?,
                    ir::LogicalOp::Or => left || self.expr(right, frame)?.boolean()?,
                })
            }
            E::Unary { op, value } => {
                let value = self.expr(value, frame)?;
                value::unary(*op, value)?
            }
            E::Binary { op, left, right } => {
                let left = self.expr(left, frame)?;
                let right = self.expr(right, frame)?;
                value::binary(*op, left, right)?
            }
            E::Array(elements) => {
                let ir::Type::Array { element, length } = &e.ty else {
                    return Err(Fault::invalid("array literal type"));
                };
                if *length != elements.len() {
                    return Err(Fault::invalid("array literal length"));
                }
                let mut values = Vec::with_capacity(elements.len());
                for item in elements {
                    let v = self.expr(item, frame)?;
                    v.check(element)?;
                    values.push(v);
                }
                Value::Array {
                    element: *element.clone(),
                    values,
                }
            }
            E::Index { base, index } => {
                let base = self.expr(base, frame)?;
                let index = self.expr(index, frame)?.integer(IntegerType::I64)?;
                let Value::Array { values, .. } = base else {
                    return Err(Fault::invalid("index of non-array"));
                };
                values[checked_index(index, values.len())?].clone()
            }
            E::Construct {
                type_id,
                base,
                fields,
                ..
            } => {
                let def = self
                    .program
                    .type_definitions
                    .get(type_id.0)
                    .filter(|d| d.id == *type_id)
                    .ok_or_else(|| Fault::invalid("unknown product type"))?;
                let mut values = if let Some(base) = base {
                    let base = self.expr(base, frame)?;
                    base.check(&ir::Type::Named(*type_id))?;
                    let Value::Aggregate { fields, .. } = base else {
                        return Err(Fault::invalid("product base"));
                    };
                    fields.into_iter().map(Some).collect::<Vec<_>>()
                } else {
                    vec![None; def.fields.len()]
                };
                for field in fields {
                    let value = self.expr(&field.value, frame)?;
                    let expected = def
                        .fields
                        .get(field.id.0)
                        .ok_or_else(|| Fault::invalid("unknown constructor field"))?;
                    value.check(&expected.ty)?;
                    let slot = values
                        .get_mut(field.id.0)
                        .ok_or_else(|| Fault::invalid("invalid product base layout"))?;
                    *slot = Some(value);
                }
                let fields = values
                    .into_iter()
                    .map(|v| v.ok_or_else(|| Fault::invalid("missing constructor field")))
                    .collect::<Result<Vec<_>>>()?;
                Value::Aggregate {
                    type_id: *type_id,
                    fields,
                }
            }
            E::FieldAccess {
                type_id,
                field_id,
                base,
                ..
            } => {
                let base = self.expr(base, frame)?;
                base.check(&ir::Type::Named(*type_id))?;
                let Value::Aggregate { fields, .. } = base else {
                    return Err(Fault::invalid("field of non-product"));
                };
                fields
                    .get(field_id.0)
                    .ok_or_else(|| Fault::invalid("unknown product field"))?
                    .clone()
            }
            E::Call {
                function_id,
                arguments,
                ..
            } => {
                let args = self.arguments(arguments, frame)?;
                self.call(*function_id, args)?
                    .ok_or_else(|| Fault::invalid("void call used as a value"))?
            }
            E::Let { .. } | E::Conditional { .. } => {
                return Err(Fault::invalid("IR must have completed common expansion"));
            }
        })
    }
}
fn checked_index(index: i128, length: usize) -> Result<usize> {
    usize::try_from(index)
        .ok()
        .filter(|i| *i < length)
        .ok_or_else(|| Fault::failure(FailureCode::ArrayIndexOutOfBounds))
}
fn at_path<'a>(mut current: &'a Value, path: &[usize]) -> Result<&'a Value> {
    for i in path {
        let Value::Array { values, .. } = current else {
            return Err(Fault::invalid("invalid array path"));
        };
        current = values
            .get(*i)
            .ok_or_else(|| Fault::invalid("invalid checked index"))?;
    }
    Ok(current)
}
fn at_path_mut<'a>(mut current: &'a mut Value, path: &[usize]) -> Result<&'a mut Value> {
    for i in path {
        let Value::Array { values, .. } = current else {
            return Err(Fault::invalid("invalid array path"));
        };
        current = values
            .get_mut(*i)
            .ok_or_else(|| Fault::invalid("invalid checked index"))?;
    }
    Ok(current)
}
fn write_quoted(output: &mut String, text: &str) {
    output.push('"');
    for ch in text.chars() {
        match ch {
            '"' => output.push_str("\\\""),
            '\\' => output.push_str("\\\\"),
            '\0' => output.push_str("\\0"),
            '\n' => output.push_str("\\n"),
            '\r' => output.push_str("\\r"),
            '\t' => output.push_str("\\t"),
            ch if ch < ' ' || ch == '\x7f' => output.push_str(&format!("\\u{{{:02x}}}", ch as u32)),
            _ => output.push(ch),
        }
    }
    output.push('"');
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn explicit_cleanup_releases_every_successful_example() {
        for entry in std::fs::read_dir("examples").unwrap() {
            let path = entry.unwrap().path();
            if path.extension().is_some_and(|e| e == "ceru") {
                let source = std::fs::read_to_string(path).unwrap();
                run(&crate::compile_to_ir(&source).unwrap()).unwrap();
            }
        }
    }

    #[test]
    fn allocation_failure_preserves_original_expression_and_prior_output() {
        let source = r#"print("before"); print(concat("a","b")); print("bad");"#;
        let program = crate::compile_to_ir(source).unwrap();
        let mut executor = Executor {
            program: &program,
            output: String::new(),
            heap: StringHeap::new(program.string_heap_limit),
        };
        executor.heap.fail_next_allocation();
        let error = executor.entry().unwrap_err();
        assert_eq!(
            error.kind,
            ErrorKind::Runtime(FailureCode::AllocationFailed)
        );
        assert_eq!(executor.output, "before\n");
        let origin = error.origin.unwrap();
        assert_eq!(
            &source[origin.span.start()..origin.span.end()],
            r#"concat("a","b")"#
        );
        executor.heap.assert_empty();
        assert_eq!(run(&program).unwrap(), "before\nab\nbad\n");
    }
}
