pub(super) use crate::ir::string_usage::first_string_span;

pub(super) fn string_heap_limit(program: &crate::ir::Program) -> Option<u64> {
    program
        .function_definitions
        .iter()
        .any(|f| {
            matches!(
                f.lowering,
                Some(crate::ir::LoweringKind::OwnershipExpression)
            )
        })
        .then_some(program.string_heap_limit)
}
