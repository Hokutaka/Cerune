//! 手作りSSAまたはCeruneソースの自動変換を観測します。プログラムは実行しません。
mod fixtures;
fn main() -> Result<(), String> {
    let args = std::env::args_os().skip(1).collect::<Vec<_>>();
    match args.as_slice() {
        [] => {
            for (name, program) in [
                ("branch", fixtures::diamond()),
                ("parallel-loop", fixtures::parallel_loop()),
                ("residual-slots", fixtures::residual_slots()),
            ] {
                println!("; hand-authored fixture: {name}");
                print!(
                    "{}",
                    cerune_lang::mir::ssa::text::emit(&program).map_err(|e| format!("{e:?}"))?
                );
            }
        }
        [file] => {
            let loaded =
                cerune_lang::modules::load(std::path::Path::new(file)).map_err(|e| e.render())?;
            let hir = loaded.to_ir().map_err(|e| format!("{e:?}"))?;
            let mir = cerune_lang::mir::lower(&hir).map_err(|e| format!("{e:?}"))?;
            let ssa = cerune_lang::mir::ssa::construct(&mir).map_err(|e| format!("{e:?}"))?;
            print!(
                "{}",
                cerune_lang::mir::ssa::text::emit(&ssa).map_err(|e| format!("{e:?}"))?
            );
        }
        _ => return Err("usage: cargo run --example ssa_model -- [source.ceru]".into()),
    }
    Ok(())
}
