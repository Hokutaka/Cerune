//! 構造化されたHIRのifと短絡条件を参照モデルへ写します。
use cerune_lang::{
    ir::{self, BinaryOp, Expr, ExprKind, LogicalOp, ReturnType, Statement, StatementKind, Type},
    types::IntegerType,
};
pub const SOURCE: &str = include_str!("branch.ceru");
pub const MODEL: &str = include_str!("BranchModel.lean");
pub const PROPERTIES: &str = include_str!("BranchProperties.lean");

fn number(expr: &Expr, parameter: ir::BindingId) -> Result<String, String> {
    super::validate(expr, parameter)?;
    Ok(super::reference(expr))
}
fn condition(expr: &Expr, parameter: ir::BindingId) -> Result<String, String> {
    if expr.ty != Type::Bool {
        return Err("branch condition must be bool".into());
    }
    match &expr.kind {
        ExprKind::Boolean(b) => Ok(format!("(.boolean {b})")),
        ExprKind::Binary {
            op: BinaryOp::Less,
            left,
            right,
        } => Ok(format!(
            "(.less {} {})",
            number(left, parameter)?,
            number(right, parameter)?
        )),
        ExprKind::Logical { op, left, right } => Ok(format!(
            "(.{} {} {})",
            match op {
                LogicalOp::And => "andThen",
                LogicalOp::Or => "orElse",
            },
            condition(left, parameter)?,
            condition(right, parameter)?
        )),
        _ => Err("unsupported HIR condition".into()),
    }
}
fn body(statements: &[Statement], parameter: ir::BindingId) -> Result<String, String> {
    let [statement] = statements else {
        return Err("branch experiment expects one return or if per body".into());
    };
    match &statement.kind {
        StatementKind::Return { value: Some(value) } => {
            Ok(format!("(.ret {})", number(value, parameter)?))
        }
        StatementKind::If {
            condition: c,
            then_body,
            else_body,
        } => Ok(format!(
            "(.choose {} {} {})",
            condition(c, parameter)?,
            body(then_body, parameter)?,
            body(else_body, parameter)?
        )),
        _ => Err("unsupported HIR branch body".into()),
    }
}
pub fn emit(hir: &ir::Program, mir: &cerune_lang::mir::Program) -> Result<String, String> {
    let f = hir
        .function_definitions
        .iter()
        .find(|f| f.name == "choose")
        .ok_or("missing choose function")?;
    let [parameter] = f.parameters.as_slice() else {
        return Err("choose requires one u8 parameter".into());
    };
    if parameter.ty != Type::Integer(IntegerType::U8)
        || f.return_type != ReturnType::Value(Type::Integer(IntegerType::U8))
        || f.lowering.is_some()
    {
        return Err("choose requires an ordinary u8 -> u8 function".into());
    }
    let reference = body(&f.body, parameter.id)?;
    // 性質の仕様は別ファイルです。ここではelse側の停止位置だけをHIRから提供します。
    let [
        Statement {
            kind: StatementKind::If { else_body, .. },
            ..
        },
    ] = f.body.as_slice()
    else {
        return Err("choose fixture requires an outer if".into());
    };
    let [
        Statement {
            kind: StatementKind::Return { value: Some(value) },
            ..
        },
    ] = else_body.as_slice()
    else {
        return Err("choose fixture requires an else return".into());
    };
    Ok(format!(
        "{}\n{MODEL}\n{}\nnamespace CeruneProof\n\
        def branchReference : BranchBody := {reference}\n\
        def branchFailureOrigin : Origin := {}\n\
        set_option maxRecDepth 8192 in\n\
        set_option maxHeartbeats 2000000 in\n\
        theorem branch_translation_correct : ∀ (x : Fin 256),\n\
          evalMir mirReference x.val = .completed (evalBranch branchReference x.val) := by decide\n\
        end CeruneProof\n",
        super::MODEL,
        super::mir_experiment::definition(hir, mir, "choose")?,
        super::origin(value)
    ))
}
