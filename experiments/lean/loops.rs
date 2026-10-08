//! whileのHIRと循環MIRを、明示した異なる評価上限で検査します。
use cerune_lang::{
    ir::{self, BinaryOp, Expr, ExprKind, ReturnType, Statement, StatementKind, Type},
    types::IntegerType,
};
pub const SOURCE: &str = include_str!("loop.ceru");
pub const MODEL: &str = include_str!("LoopModel.lean");
pub const PROPERTIES: &str = include_str!("LoopProperties.lean");
// この例ではHIRは16文、MIRは11blockの訪問で正常終了します。
pub const HIR_FUEL: usize = 16;
pub const MIR_FUEL: usize = 11;

fn expression(expr: &Expr) -> Result<String, String> {
    if expr.ty != Type::Integer(IntegerType::U8) {
        return Err("loop expression must be u8".into());
    }
    match &expr.kind {
        ExprKind::Integer(n) if (0..=255).contains(n) => Ok(format!("(.literal {n})")),
        ExprKind::Variable { id, .. } => Ok(format!("(.local {})", id.0)),
        ExprKind::Binary {
            op: BinaryOp::Add,
            left,
            right,
        } => Ok(format!(
            "(.add {} {} {})",
            super::origin(expr),
            expression(left)?,
            expression(right)?
        )),
        _ => Err("unsupported HIR loop expression".into()),
    }
}
fn statements(body: &[Statement]) -> Result<String, String> {
    let result = body
        .iter()
        .map(|statement| match &statement.kind {
            StatementKind::Binding {
                id,
                ty,
                value,
                borrowed: false,
                ..
            } if *ty == Type::Integer(IntegerType::U8) => {
                Ok(format!("(.assign {} {})", id.0, expression(value)?))
            }
            StatementKind::Assignment { target, value }
                if target.projections.is_empty() && target.ty == Type::Integer(IntegerType::U8) =>
            {
                Ok(format!("(.assign {} {})", target.id.0, expression(value)?))
            }
            StatementKind::Return { value: Some(value) } => {
                Ok(format!("(.ret {})", expression(value)?))
            }
            StatementKind::While { condition, body } => {
                let ExprKind::Binary {
                    op: BinaryOp::Less,
                    left,
                    right,
                } = &condition.kind
                else {
                    return Err("loop condition must be u8 less-than".into());
                };
                if condition.ty != Type::Bool {
                    return Err("loop condition must be bool".into());
                }
                Ok(format!(
                    "(.whileLess {} {} {})",
                    expression(left)?,
                    expression(right)?,
                    statements(body)?
                ))
            }
            _ => Err("unsupported HIR loop statement".into()),
        })
        .collect::<Result<Vec<_>, String>>()?;
    Ok(format!("[{}]", result.join(", ")))
}

pub fn emit(
    hir: &ir::Program,
    mir: &cerune_lang::mir::Program,
    hir_fuel: usize,
    mir_fuel: usize,
) -> Result<String, String> {
    let f = hir
        .function_definitions
        .iter()
        .find(|f| f.name == "advance")
        .ok_or("missing advance function")?;
    let [parameter] = f.parameters.as_slice() else {
        return Err("advance requires one u8 parameter".into());
    };
    if parameter.ty != Type::Integer(IntegerType::U8)
        || f.return_type != ReturnType::Value(Type::Integer(IntegerType::U8))
        || f.lowering.is_some()
    {
        return Err("advance requires an ordinary u8 -> u8 function".into());
    }
    let body = statements(&f.body)?;
    // 仕様に使う停止出自だけをHIRから取り出します。期待値は生成しません。
    let loop_body = f
        .body
        .iter()
        .find_map(|s| match &s.kind {
            StatementKind::While { body, .. } => Some(body),
            _ => None,
        })
        .ok_or("advance fixture requires a while loop")?;
    let Some(Statement {
        kind: StatementKind::Assignment { value, .. },
        ..
    }) = loop_body.first()
    else {
        return Err("advance fixture requires an initial loop assignment".into());
    };
    if !matches!(
        value.kind,
        ExprKind::Binary {
            op: BinaryOp::Add,
            ..
        }
    ) {
        return Err("advance fixture requires a checked addition".into());
    }
    Ok(format!(
        "{}\n{MODEL}\n{}\nnamespace CeruneProof\n\
        def loopReference : LoopFunction := ⟨{}, {body}⟩\n\
        def loopFailureOrigin : Origin := {}\n\
        def hirFuel : Nat := {hir_fuel}\n\
        def mirFuel : Nat := {mir_fuel}\n\
        set_option maxRecDepth 16384 in\n\
        set_option maxHeartbeats 4000000 in\n\
        theorem loop_translation_correct : ∀ (x : Fin 256),\n\
          evalMirWithFuel mirReference mirFuel x.val = evalLoop loopReference hirFuel x.val := by decide\n\
        set_option maxRecDepth 16384 in\n\
        set_option maxHeartbeats 4000000 in\n\
        theorem loop_completed : ∀ (x : Fin 256),\n\
          isCompleted (evalLoop loopReference hirFuel x.val) = true ∧\n\
          isCompleted (evalMirWithFuel mirReference mirFuel x.val) = true := by decide\n\
        end CeruneProof\n",
        super::MODEL,
        super::mir_experiment::definition_with_cycles(hir, mir, "advance")?,
        parameter.id.0,
        super::origin(value)
    ))
}
