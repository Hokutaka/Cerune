//! 自動変換前の、手作りSSA表現・検証・観測の例です。
mod fixtures;
fn main() {
    for (name, program) in [
        ("branch", fixtures::diamond()),
        ("parallel-loop", fixtures::parallel_loop()),
        ("residual-slots", fixtures::residual_slots()),
    ] {
        println!("; hand-authored fixture: {name}");
        print!(
            "{}",
            cerune_lang::mir::ssa::text::emit(&program).expect("valid SSA fixture")
        );
    }
}
