//! HIRからMIRを再構成せず、渡された実際のMIR snapshotをLeanへ写します。
use cerune_lang::{
    ir::{self, BinaryOp, ReturnType, Type},
    mir::{self, InstructionKind, Literal, Operation, TerminatorKind},
    types::IntegerType,
};
pub const MODEL: &str = include_str!("MirModel.lean");

pub fn emit(hir: &ir::Program, program: &mir::Program) -> Result<String, String> {
    let hir_function = hir
        .function_definitions
        .iter()
        .find(|f| f.name == "increment")
        .ok_or("missing increment function")?;
    mir::validate(program).map_err(|e| e.message)?;
    let function = program
        .functions
        .iter()
        .find(|f| f.id == Some(hir_function.id))
        .ok_or("missing MIR increment function")?;
    if function.name != "increment"
        || function.lowering.is_some()
        || function.return_type != ReturnType::Value(Type::Integer(IntegerType::U8))
        || function
            .locals
            .iter()
            .any(|l| l.ty != Type::Integer(IntegerType::U8))
    {
        return Err("MIR experiment requires an ordinary u8 function".into());
    }
    let [parameter] = function.parameters.as_slice() else {
        return Err("MIR experiment requires one parameter".into());
    };
    let mut blocks = Vec::new();
    for (index, block) in function.blocks.iter().enumerate() {
        let result = match block.terminator.kind {
            TerminatorKind::Return(Some(local)) if index == function.entry.0 => {
                format!("some {}", local.0)
            }
            TerminatorKind::Unreachable
                if index != function.entry.0 && block.instructions.is_empty() =>
            {
                "none".to_owned()
            }
            _ => {
                return Err(
                    "MIR experiment supports one returning block and empty unreachable blocks"
                        .into(),
                );
            }
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
        blocks.push(format!("⟨[{}], {result}⟩", instructions.join(", ")));
    }
    Ok(format!(
        "{MODEL}\nnamespace CeruneProof\n\
         -- actual MIR function @{}; other functions and the caller are not proved\n\
         def mirReference : MirFunction := ⟨{}, {}, [{}]⟩\n\
         set_option maxRecDepth 4096 in\n\
         theorem mir_translation_correct : ∀ (x : Fin 256),\n\
           evalMir mirReference x.val = some (eval reference x.val) := by decide\n\
         end CeruneProof\n",
        hir_function.id.0,
        parameter.0,
        function.entry.0,
        blocks.join(", ")
    ))
}
