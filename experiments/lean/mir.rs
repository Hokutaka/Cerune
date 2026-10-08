//! HIRからMIRを再構成せず、渡された実際のMIR snapshotをLeanへ写します。
use cerune_lang::{
    ir::{self, BinaryOp, ReturnType, Type},
    mir::{self, InstructionKind, Literal, Operation, TerminatorKind},
    types::IntegerType,
};
pub const MODEL: &str = include_str!("MirModel.lean");

pub fn definition(hir: &ir::Program, program: &mir::Program, name: &str) -> Result<String, String> {
    let hir_function = hir
        .function_definitions
        .iter()
        .find(|f| f.name == name)
        .ok_or("missing selected HIR function")?;
    mir::validate(program).map_err(|e| e.message)?;
    let function = program
        .functions
        .iter()
        .find(|f| f.id == Some(hir_function.id))
        .ok_or("missing selected MIR function")?;
    if function.name != name
        || function.lowering.is_some()
        || function.return_type != ReturnType::Value(Type::Integer(IntegerType::U8))
        || function
            .locals
            .iter()
            .any(|l| !matches!(l.ty, Type::Integer(IntegerType::U8) | Type::Bool))
    {
        return Err("MIR experiment requires an ordinary u8 function".into());
    }
    let [parameter] = function.parameters.as_slice() else {
        return Err("MIR experiment requires one parameter".into());
    };
    reject_cycles(function)?;
    if function.locals[parameter.0].ty != Type::Integer(IntegerType::U8) {
        return Err("MIR parameter must be u8".into());
    }
    let mut blocks = Vec::new();
    for block in &function.blocks {
        let result = match block.terminator.kind {
            TerminatorKind::Return(Some(local)) => format!(".ret {}", local.0),
            TerminatorKind::Jump(next) => format!(".jump {}", next.0),
            TerminatorKind::Branch {
                condition,
                then_block,
                else_block,
            } => format!(".branch {} {} {}", condition.0, then_block.0, else_block.0),
            TerminatorKind::Unreachable => ".unreachable".to_owned(),
            _ => return Err("MIR experiment requires a u8 return".into()),
        };
        let mut instructions = Vec::new();
        for instruction in &block.instructions {
            let InstructionKind::Assign { destination, value } = &instruction.kind else {
                return Err("unsupported MIR instruction in selected function".into());
            };
            let operation = match value {
                Operation::Literal(Literal::Integer(n)) if (0..=255).contains(n) => {
                    format!(".literal {n}")
                }
                Operation::Literal(Literal::Boolean(b)) => format!(".boolean {b}"),
                Operation::Binary {
                    op: BinaryOp::Less,
                    left,
                    right,
                } => format!(".less {} {}", left.0, right.0),
                Operation::Copy(local) => format!(".copy {}", local.0),
                Operation::Binary {
                    op: BinaryOp::Add,
                    left,
                    right,
                } => {
                    let origin = instruction
                        .origin
                        .source()
                        .ok_or("MIR addition has no source origin")?;
                    format!(
                        ".add ⟨{}, {}, {}, {}⟩ {} {}",
                        origin.node_id.0,
                        origin.span.source_id().index(),
                        origin.span.start(),
                        origin.span.end(),
                        left.0,
                        right.0
                    )
                }
                _ => return Err("unsupported MIR operation in selected function".into()),
            };
            instructions.push(format!(
                "⟨{}, {}, ({operation})⟩",
                instruction.id.0, destination.0
            ));
        }
        blocks.push(format!("⟨[{}], ({result})⟩", instructions.join(", ")));
    }
    Ok(format!(
        "{MODEL}\nnamespace CeruneProof\n\
         -- actual MIR function @{}; other functions and the caller are not proved\n\
         def mirReference : MirFunction := ⟨{}, {}, [{}]⟩\n\
         end CeruneProof\n",
        hir_function.id.0,
        parameter.0,
        function.entry.0,
        blocks.join(", ")
    ))
}

pub fn emit(hir: &ir::Program, program: &mir::Program) -> Result<String, String> {
    Ok(format!(
        "{}\nnamespace CeruneProof\n\
        set_option maxRecDepth 4096 in\n\
        theorem mir_translation_correct : ∀ (x : Fin 256),\n\
          evalMir mirReference x.val = .completed (eval reference x.val) := by decide\n\
        end CeruneProof\n",
        definition(hir, program, "increment")?
    ))
}

// 上限付きモデルでloopを証明済みに見せないため、未到達blockも含め循環を拒否します。
fn reject_cycles(function: &mir::Function) -> Result<(), String> {
    fn visit(function: &mir::Function, index: usize, colors: &mut [u8]) -> Result<(), String> {
        match colors[index] {
            1 => return Err("cyclic MIR is outside this proof experiment".into()),
            2 => return Ok(()),
            _ => {}
        }
        colors[index] = 1;
        for next in function.blocks[index].terminator.kind.successors() {
            visit(function, next.0, colors)?;
        }
        colors[index] = 2;
        Ok(())
    }
    let mut colors = vec![0; function.blocks.len()];
    for index in 0..colors.len() {
        visit(function, index, &mut colors)?;
    }
    Ok(())
}
