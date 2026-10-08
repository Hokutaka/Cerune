//! 観測専用のv0.1です。元MIRとSSAを別区分で保持し、実行可能なload形式とはしません。
use super::*;
use std::fmt::Write;
impl std::fmt::Display for Operand {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Value(v) => write!(f, "v{}", v.0),
            Self::Slot(id) => write!(f, "slot{}", id.0),
        }
    }
}
fn arguments(args: &[ValueId]) -> String {
    args.iter()
        .map(|v| format!("v{}", v.0))
        .collect::<Vec<_>>()
        .join(", ")
}
fn edge(e: &Edge) -> String {
    format!("bb{}({})", e.target.0, arguments(&e.arguments))
}
pub fn emit(p: &Program) -> Result<String, mir::Error> {
    validate(p)?;
    let mut out = String::from(
        "; Cerune scalar SSA v0.1\n; residual slots; parallel edge arguments; no optimization\n; observation only: no SSA execution or loader\n",
    );
    writeln!(
        out,
        "; construction={} options=none",
        match p.construction {
            Some(Construction::ScalarSsaV1) => "scalar-ssa-v1",
            None => "manual",
        }
    )
    .unwrap();
    out.push_str("\noriginal-mir {\n");
    out.push_str(&mir::text::emit(&p.original));
    out.push_str("}\n\nssa {\n");
    for (index, f) in p.functions.iter().chain([&p.main]).enumerate() {
        let original = p.original.functions.get(index).unwrap_or(&p.original.main);
        let id = original.id.map_or("main".into(), |id| format!("@{}", id.0));
        writeln!(
            out,
            "  fn {id} {:?} entry=bb{} parameters=[{}] {{",
            original.name,
            f.entry.0,
            f.parameters
                .iter()
                .map(ToString::to_string)
                .collect::<Vec<_>>()
                .join(", ")
        )
        .unwrap();
        for (id, v) in f.values.iter().enumerate() {
            writeln!(
                out,
                "    value v{id}: {} original-local=%{}",
                mir::text::type_name(&v.ty),
                v.original_local.0
            )
            .unwrap();
        }
        for (id, l) in original
            .locals
            .iter()
            .enumerate()
            .filter(|(_, l)| !is_scalar(&l.ty))
        {
            writeln!(
                out,
                "    slot{id}: {} original-local=%{id}",
                mir::text::type_name(&l.ty)
            )
            .unwrap();
        }
        for (id, b) in f.blocks.iter().enumerate() {
            writeln!(
                out,
                "    bb{id}({}) original-block=bb{} ; {}",
                arguments(&b.arguments),
                b.original_block.0,
                mir::text::origin(original.blocks[b.original_block.0].origin)
            )
            .unwrap();
            for i in &b.instructions {
                writeln!(
                    out,
                    "      mir-i{} {} ; {}",
                    i.original_instruction.0,
                    mir::text::instruction(&i.kind),
                    mir::text::origin(i.origin)
                )
                .unwrap();
            }
            let t = &b.terminator;
            let description = match &t.kind {
                TerminatorKind::Jump(e) => format!("jump {}", edge(e)),
                TerminatorKind::Branch {
                    condition,
                    then_edge,
                    else_edge,
                } => format!(
                    "branch v{} then={} else={}",
                    condition.0,
                    edge(then_edge),
                    edge(else_edge)
                ),
                TerminatorKind::Return(v) => v.map_or("return".into(), |v| format!("return {v}")),
            };
            writeln!(
                out,
                "      mir-i{} {description} ; {}",
                t.original_instruction.0,
                mir::text::origin(t.origin)
            )
            .unwrap();
        }
        for b in &f.retained_unreachable {
            writeln!(
                out,
                "    retained original-block=bb{} reason=unreachable; see original-mir",
                b.0
            )
            .unwrap();
        }
        out.push_str("  }\n");
    }
    out.push_str("}\n");
    Ok(out)
}
