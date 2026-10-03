//! 最小の証明実験を生成します。Ceruneの公開emit-leanではありません。
#[path = "../experiments/lean/emit.rs"]
mod experiment;

fn main() {
    let program = cerune_lang::compile_to_ir(experiment::SOURCE).expect("compile example");
    let directory = std::path::Path::new("target/lean-verification");
    std::fs::create_dir_all(directory).unwrap();
    let generated = experiment::emit(&program).expect("emit experimental function");
    std::fs::write(directory.join("Generated.lean"), &generated).unwrap();
    std::fs::write(
        directory.join("Verified.lean"),
        format!("{generated}\n{}", experiment::PROPERTIES),
    )
    .unwrap();
    std::fs::write(
        directory.join("increment.ceir"),
        cerune_lang::ir::text::emit(&program),
    )
    .unwrap();
    std::fs::write(directory.join("lean-toolchain"), experiment::TOOLCHAIN).unwrap();
    println!("Generated target/lean-verification/{{Generated,Verified}}.lean and increment.ceir");
}
