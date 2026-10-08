//! 手作りSSAの観測、Ceruneソースの自動変換、明示指定での直接実行のAPI例です。
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
        [file] => source(file, false)?,
        [option, file] if option == "--run" => source(file, true)?,
        _ => {
            return Err(
                "usage: cargo run --example ssa_model -- [source.ceru | --run source.ceru]".into(),
            );
        }
    }
    Ok(())
}
fn source(file: &std::ffi::OsStr, execute: bool) -> Result<(), String> {
    let loaded = cerune_lang::modules::load(std::path::Path::new(file)).map_err(|e| e.render())?;
    let hir = loaded.to_ir().map_err(|e| format!("{e:?}"))?;
    let mir = cerune_lang::mir::lower(&hir).map_err(|e| format!("{e:?}"))?;
    let ssa = cerune_lang::mir::ssa::construct(&mir).map_err(|e| format!("{e:?}"))?;
    if execute {
        match cerune_lang::ssa_executor::run(&ssa) {
            Ok(output) => print!("{output}"),
            Err(e) => {
                print!("{}", e.output());
                return Err(format!(
                    "{e}; origin={:?}; location={:?}",
                    e.origin(),
                    e.location()
                ));
            }
        }
    } else {
        print!(
            "{}",
            cerune_lang::mir::ssa::text::emit(&ssa).map_err(|e| format!("{e:?}"))?
        );
    }
    Ok(())
}
