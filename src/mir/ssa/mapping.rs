//! SSAと元MIRの対応だけを表示します。IR本体・実行形式・意味保存の証明ではありません。
use super::*;
use std::fmt::Write;
pub fn emit(p: &Program) -> Result<String, mir::Error> {
    validate(p)?;
    let mut out = String::from(
        "; Cerune SSA mapping v0.1\n; IDs are scoped by function; instruction indexes are scoped by block\n",
    );
    for (f, original) in p
        .functions
        .iter()
        .chain([&p.main])
        .zip(p.original.functions.iter().chain([&p.original.main]))
    {
        let id = original.id.map_or("main".into(), |id| format!("@{}", id.0));
        writeln!(out, "fn {id} original-function={id} {{").unwrap();
        for (index, param) in f.parameters.iter().enumerate() {
            writeln!(
                out,
                "  parameter {index} {param} original-local=%{}",
                original.parameters[index].0
            )
            .unwrap();
        }
        for (index, v) in f.values.iter().enumerate() {
            writeln!(
                out,
                "  v{index} original-local=%{} type={}",
                v.original_local.0,
                mir::text::type_name(&v.ty)
            )
            .unwrap();
        }
        for (index, l) in original
            .locals
            .iter()
            .enumerate()
            .filter(|(_, l)| !is_scalar(&l.ty))
        {
            writeln!(
                out,
                "  slot{index} original-local=%{index} type={}",
                mir::text::type_name(&l.ty)
            )
            .unwrap();
        }
        for (index, b) in f.blocks.iter().enumerate() {
            writeln!(
                out,
                "  bb{index} original-block=bb{} {{",
                b.original_block.0
            )
            .unwrap();
            for arg in &b.arguments {
                writeln!(
                    out,
                    "    argument v{} merge-of=%{}",
                    arg.0, f.values[arg.0].original_local.0
                )
                .unwrap();
            }
            for (index, i) in b.instructions.iter().enumerate() {
                writeln!(
                    out,
                    "    instruction {index} original=mir-i{} ; {}",
                    i.original_instruction.0,
                    mir::text::origin(i.origin)
                )
                .unwrap();
            }
            writeln!(
                out,
                "    terminator original=mir-i{} ; {}",
                b.terminator.original_instruction.0,
                mir::text::origin(b.terminator.origin)
            )
            .unwrap();
            let edges: Vec<_> = match &b.terminator.kind {
                TerminatorKind::Jump(e) => vec![("jump", e)],
                TerminatorKind::Branch {
                    then_edge,
                    else_edge,
                    ..
                } => vec![("then", then_edge), ("else", else_edge)],
                TerminatorKind::Return(_) => vec![],
            };
            for (name, e) in edges {
                writeln!(
                    out,
                    "    edge {name} -> bb{} original-target=bb{} {{",
                    e.target.0, f.blocks[e.target.0].original_block.0
                )
                .unwrap();
                for (from, to) in e.arguments.iter().zip(&f.blocks[e.target.0].arguments) {
                    writeln!(
                        out,
                        "      v{} -> v{} merge-of=%{}",
                        from.0, to.0, f.values[to.0].original_local.0
                    )
                    .unwrap();
                }
                out.push_str("    }\n");
            }
            out.push_str("  }\n");
        }
        for id in &f.retained_unreachable {
            writeln!(
                out,
                "  retained original-block=bb{} reason=unreachable; see original-mir",
                id.0
            )
            .unwrap();
        }
        out.push_str("}\n");
    }
    Ok(out)
}
