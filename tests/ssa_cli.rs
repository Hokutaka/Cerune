use std::process::{Command, Output};
fn cli(command: &str, file: &str, options: &[&str]) -> Output {
    Command::new(env!("CARGO_BIN_EXE_cerune"))
        .arg(command)
        .arg(file)
        .args(options)
        .output()
        .unwrap()
}
#[test]
fn explicit_ssa_execution_preserves_output_failure_records_and_rendered_diagnostics() {
    for file in [
        "examples/ir_stages/ssa_values.ceru",
        "examples/ir_stages/owned_values.ceru",
        "examples/modules/main.ceru",
        "examples/modules/failure.ceru",
        "examples/runtime_failures/call_sequence.ceru",
        "examples/dynamic_arrays/lowering_order.ceru",
    ] {
        for budget in ["0", "47", "48", "1024"] {
            for diagnostics in [false, true] {
                let mut opts = vec!["--array-heap-limit", budget, "--string-heap-limit", "1024"];
                if diagnostics {
                    opts.extend(["--diagnostic-format", "runtime-v1"]);
                }
                let baseline = cli("run-mir", file, &opts);
                opts.push("--ssa");
                let actual = cli("run-mir", file, &opts);
                assert_eq!(actual.status, baseline.status, "{file} {budget}");
                assert_eq!(actual.stdout, baseline.stdout, "{file} {budget}");
                assert_eq!(actual.stderr, baseline.stderr, "{file} {budget}");
            }
        }
    }
    let actual = cli("run-mir", "examples/ir_stages/ssa_values.ceru", &["--ssa"]);
    assert!(actual.status.success());
    assert_eq!(actual.stdout, b"14\n16\n20\n10\n");
}
#[test]
fn emit_ssa_matches_api_and_retains_original_mir_without_executing() {
    for file in [
        "examples/ir_stages/ssa_values.ceru",
        "examples/ir_stages/owned_values.ceru",
        "examples/modules/failure.ceru",
    ] {
        let mut hir = cerune_lang::modules::load(std::path::Path::new(file))
            .unwrap()
            .to_ir()
            .unwrap();
        hir.array_heap_limit = 48;
        hir.string_heap_limit = 123;
        let mir = cerune_lang::mir::lower(&hir).unwrap();
        let p = cerune_lang::mir::ssa::construct(&mir).unwrap();
        let baseline = cli(
            "emit-mir",
            file,
            &["--array-heap-limit", "48", "--string-heap-limit", "123"],
        );
        let actual = cli(
            "emit-mir",
            file,
            &[
                "--ssa",
                "--array-heap-limit",
                "48",
                "--string-heap-limit",
                "123",
            ],
        );
        assert!(baseline.status.success());
        assert!(actual.status.success());
        assert!(actual.stderr.is_empty());
        assert_eq!(
            baseline.stdout,
            cerune_lang::mir::text::emit(&mir).as_bytes()
        );
        assert_eq!(
            actual.stdout,
            cerune_lang::mir::ssa::text::emit(&p).unwrap().as_bytes()
        );
        assert!(
            String::from_utf8(actual.stdout)
                .unwrap()
                .contains(std::str::from_utf8(&baseline.stdout).unwrap())
        );
    }
}
#[test]
fn unsupported_routes_duplicates_and_extra_values_are_rejected() {
    let file = "examples/ir_stages/ssa_values.ceru";
    for route in [
        "check",
        "run",
        "run-ir",
        "run-vm",
        "emit-ir",
        "emit-sources",
        "emit-bytecode",
        "emit-c",
        "emit-llvm",
        "emit-qbe",
        "emit-wat",
    ] {
        let out = cli(route, file, &["--ssa"]);
        assert!(!out.status.success(), "{route}");
        assert!(out.stdout.is_empty());
    }
    for route in ["run-mir", "emit-mir", "emit-asm", "emit-obj"] {
        for opts in [
            vec!["--ssa", "--ssa"],
            vec!["--ssa", "false"],
            vec!["--ssa", "--passes", "fold"],
        ] {
            let out = cli(route, file, &opts);
            assert!(!out.status.success(), "{route} {opts:?}");
            assert!(out.stdout.is_empty());
        }
    }
    let out = Command::new(env!("CARGO_BIN_EXE_cerune"))
        .arg("--help")
        .output()
        .unwrap();
    let help = String::from_utf8(out.stdout).unwrap();
    assert!(help.contains("run-mir <file> [--ssa]"));
    assert!(help.contains("emit-mir <file> [--ssa]"));
    assert!(help.contains("observe <file> [--ssa]"));
    assert!(!help.contains("\\n"));
}
