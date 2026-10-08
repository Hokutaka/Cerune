//! 公開backendではなく、選択した純粋なu8関数だけのtranslation validation実験です。
use cerune_lang::{
    ir::{self, BinaryOp, Expr, ExprKind, ReturnType, StatementKind, Type},
    types::IntegerType,
};

#[path = "branch.rs"]
pub mod branch;
#[path = "mir.rs"]
mod mir_experiment;

/// HIRの証明と独立したMIRモデルの対応証明を同じファイルへ出力します。
pub fn emit_with_mir(
    program: &ir::Program,
    mir: &cerune_lang::mir::Program,
) -> Result<String, String> {
    Ok(format!(
        "{}\n{}",
        emit(program)?,
        mir_experiment::emit(program, mir)?
    ))
}

pub const MODEL: &str = include_str!("Model.lean");
pub const PROPERTIES: &str = include_str!("Properties.lean");
pub const SOURCE: &str = include_str!("increment.ceru");
pub const TOOLCHAIN: &str = include_str!("lean-toolchain");

fn origin(expr: &Expr) -> String {
    format!(
        "⟨{}, {}, {}, {}⟩",
        expr.id.0,
        expr.span.source_id().index(),
        expr.span.start(),
        expr.span.end()
    )
}

// 対象の関数以外を証明済みとはしません。全プログラムを受け付けるAPIではありません。
pub fn selected_expression(program: &ir::Program) -> Result<(&Expr, ir::BindingId), String> {
    let f = program
        .function_definitions
        .iter()
        .find(|f| f.name == "increment")
        .ok_or("missing increment function")?;
    let [parameter] = f.parameters.as_slice() else {
        return Err("experiment requires exactly one u8 parameter".into());
    };
    if parameter.ty != Type::Integer(IntegerType::U8)
        || f.return_type != ReturnType::Value(Type::Integer(IntegerType::U8))
        || f.lowering.is_some()
    {
        return Err("experiment requires an ordinary u8 -> u8 function".into());
    }
    let [statement] = f.body.as_slice() else {
        return Err("experiment requires a single return statement".into());
    };
    let StatementKind::Return { value: Some(value) } = &statement.kind else {
        return Err("experiment requires a returned expression".into());
    };
    validate(value, parameter.id)?;
    Ok((value, parameter.id))
}

fn validate(expr: &Expr, parameter: ir::BindingId) -> Result<(), String> {
    if expr.ty != Type::Integer(IntegerType::U8) {
        return Err(format!("unsupported type at node {}", expr.id.0));
    }
    match &expr.kind {
        ExprKind::Integer(n) if (0..=255).contains(n) => Ok(()),
        ExprKind::Variable { id, .. } if *id == parameter => Ok(()),
        ExprKind::Binary {
            op: BinaryOp::Add,
            left,
            right,
        } => {
            validate(left, parameter)?;
            validate(right, parameter)
        }
        _ => Err(format!("unsupported expression at node {}", expr.id.0)),
    }
}

// 参照表現と生成定義は別々に出力します。後者はevalを呼び出しません。
fn reference(expr: &Expr) -> String {
    match &expr.kind {
        ExprKind::Integer(n) => format!("(.literal {n})"),
        ExprKind::Variable { .. } => ".arg".into(),
        ExprKind::Binary { left, right, .. } => {
            format!(
                "(.add {} {} {})",
                origin(expr),
                reference(left),
                reference(right)
            )
        }
        _ => unreachable!("validated experiment expression"),
    }
}

fn generated(expr: &Expr) -> String {
    match &expr.kind {
        ExprKind::Integer(n) => format!("(pure {n})"),
        ExprKind::Variable { .. } => "(pure input)".into(),
        ExprKind::Binary { left, right, .. } => format!(
            "(do let a ← {}; let b ← {}; if a + b ≤ 255 then pure (a + b) else throw (.integerOverflow {}))",
            generated(left),
            generated(right),
            origin(expr)
        ),
        _ => unreachable!("validated experiment expression"),
    }
}

pub fn emit(program: &ir::Program) -> Result<String, String> {
    let (expr, _) = selected_expression(program)?;
    Ok(format!(
        "{MODEL}\nnamespace CeruneProof\n\
         -- completed IR function: increment; caller statements are outside the proof\n\
         def rootOrigin : Origin := {}\n\
         def reference : Expr := {}\n\
         def generated (input : Nat) : Result := {}\n\
         theorem translation_correct (x : Fin 256) :\n\
         eval reference x.val = generated x.val := by rfl\n\
         end CeruneProof\n",
        origin(expr),
        reference(expr),
        generated(expr)
    ))
}
