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
    // 各例の上限・独立仕様と観測ファイルを同じ組で保存します。
    for (stem, source_name, source, properties, hir_fuel, mir_fuel) in [
        (
            "Loop",
            "loop",
            experiment::loops::SOURCE,
            experiment::loops::PROPERTIES,
            experiment::loops::HIR_FUEL,
            experiment::loops::MIR_FUEL,
        ),
        (
            "LoopControl",
            "loop_control",
            experiment::loops::CONTROL_SOURCE,
            experiment::loops::CONTROL_PROPERTIES,
            experiment::loops::CONTROL_HIR_FUEL,
            experiment::loops::CONTROL_MIR_FUEL,
        ),
        (
            "For",
            "for_control",
            experiment::loops::FOR_SOURCE,
            experiment::loops::FOR_PROPERTIES,
            experiment::loops::FOR_HIR_FUEL,
            experiment::loops::FOR_MIR_FUEL,
        ),
        (
            "ForFailure",
            "for_update_failure",
            experiment::loops::FOR_FAILURE_SOURCE,
            experiment::loops::FOR_FAILURE_PROPERTIES,
            experiment::loops::FOR_FAILURE_HIR_FUEL,
            experiment::loops::FOR_FAILURE_MIR_FUEL,
        ),
        (
            "NestedControl",
            "nested_loop_control",
            experiment::loops::NESTED_SOURCE,
            experiment::loops::NESTED_PROPERTIES,
            experiment::loops::NESTED_HIR_FUEL,
            experiment::loops::NESTED_MIR_FUEL,
        ),
    ] {
        let hir = cerune_lang::compile_to_ir(source).expect("compile loop fixture");
        let mir = cerune_lang::mir::lower(&hir).expect("lower loop fixture");
        let generated =
            experiment::loops::emit(&hir, &mir, hir_fuel, mir_fuel).expect("emit loop fixture");
        std::fs::write(directory.join(format!("{stem}Generated.lean")), &generated).unwrap();
        std::fs::write(
            directory.join(format!("{stem}Verified.lean")),
            format!("{generated}\n{properties}"),
        )
        .unwrap();
        std::fs::write(
            directory.join(format!("{source_name}.ceir")),
            cerune_lang::ir::text::emit(&hir),
        )
        .unwrap();
        std::fs::write(
            directory.join(format!("{source_name}.mir.txt")),
            cerune_lang::mir::text::emit(&mir),
        )
        .unwrap();
        println!(
            "Generated {stem}Generated.lean, {stem}Verified.lean, {source_name}.ceir and {source_name}.mir.txt"
        );
    }
    println!("Generated BranchGenerated.lean, BranchVerified.lean, branch.ceir and branch.mir.txt");
    println!(
        "Generated target/lean-verification/{{Generated,Verified}}.lean and increment.{{ceir,mir.txt}}"
    );
}
