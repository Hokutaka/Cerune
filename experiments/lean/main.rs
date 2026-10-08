//! 最小の証明実験を生成します。Ceruneの公開emit-leanではありません。
#[path = "emit.rs"]
mod experiment;

fn main() {
    let program = cerune_lang::compile_to_ir(experiment::SOURCE).expect("compile example");
    let directory = std::path::Path::new("target/lean-verification");
    std::fs::create_dir_all(directory).unwrap();
    let mir = cerune_lang::mir::lower(&program).expect("lower MIR");
    let generated = experiment::emit_with_mir(&program, &mir).expect("emit experimental function");
    std::fs::write(
        directory.join("increment.mir.txt"),
        cerune_lang::mir::text::emit(&mir),
    )
    .unwrap();
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
    let branch = cerune_lang::compile_to_ir(experiment::branch::SOURCE).expect("compile branch");
    let branch_mir = cerune_lang::mir::lower(&branch).expect("lower branch MIR");
    let branch_generated = experiment::branch::emit(&branch, &branch_mir).expect("emit branch");
    std::fs::write(directory.join("BranchGenerated.lean"), &branch_generated).unwrap();
    std::fs::write(
        directory.join("BranchVerified.lean"),
        format!("{branch_generated}\n{}", experiment::branch::PROPERTIES),
    )
    .unwrap();
    std::fs::write(
        directory.join("branch.ceir"),
        cerune_lang::ir::text::emit(&branch),
    )
    .unwrap();
    std::fs::write(
        directory.join("branch.mir.txt"),
        cerune_lang::mir::text::emit(&branch_mir),
    )
    .unwrap();
    println!("Generated BranchGenerated.lean, BranchVerified.lean, branch.ceir and branch.mir.txt");
    println!(
        "Generated target/lean-verification/{{Generated,Verified}}.lean and increment.{{ceir,mir.txt}}"
    );
}
