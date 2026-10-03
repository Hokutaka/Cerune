//! Lean経路の設計実験。公開backendや全言語の証明と混同しません。
#[path = "../experiments/lean/emit.rs"]
mod experiment;
#[path = "support/process.rs"]
mod process;

use cerune_lang::{bytecode, compile_to_ir, ir_executor, run_bytecode, runtime::FailureCode};
use std::{fs, path::Path, process::Command, time::Duration};

#[test]
fn experiment_uses_completed_ir_and_rejects_unsupported_expressions() {
    let program = compile_to_ir(experiment::SOURCE).unwrap();
    let generated = experiment::emit(&program).unwrap();
    assert!(generated.contains("theorem translation_correct"));
    assert_eq!(ir_executor::run(&program).unwrap(), "1\n42\n255\n");
    assert_eq!(
        run_bytecode(&bytecode::lower(&program).unwrap()).unwrap(),
        "1\n42\n255\n"
    );
    let unsupported = experiment::SOURCE.replace("value + 1", "value * 2");
    let program = compile_to_ir(&unsupported).unwrap();
    assert!(
        experiment::emit(&program)
            .unwrap_err()
            .contains("unsupported expression")
    );
    let wrong_type = experiment::SOURCE.replace("u8", "u16");
    assert!(experiment::emit(&compile_to_ir(&wrong_type).unwrap()).is_err());
    let extra_statement = experiment::SOURCE.replace("return value", "print(value); return value");
    assert!(experiment::emit(&compile_to_ir(&extra_statement).unwrap()).is_err());
}

// 通常のcargo testで未実行を成功扱いしません。専用CI jobで必ず実行します。
#[test]
#[ignore = "requires pinned Lean; cargo test --test lean_verification -- --ignored"]
fn lean_checks_correspondence_properties_execution_and_mutations() {
    let directory = Path::new(env!("CARGO_MANIFEST_DIR")).join("target/lean-verification-test");
    fs::create_dir_all(&directory).unwrap();
    let lean = std::env::var_os("CERUNE_TEST_LEAN").unwrap_or_else(|| "lean".into());
    let run = |file: &Path, execute: bool| {
        let mut command = Command::new(&lean);
        command.current_dir(Path::new(env!("CARGO_MANIFEST_DIR")).join("experiments/lean"));
        if execute {
            command.arg("--run");
        }
        command.arg(file);
        process::bounded_output(
            &mut command,
            &directory,
            "lean-check",
            Duration::from_secs(45),
        )
        .unwrap()
    };
    let mut version = Command::new(&lean);
    version
        .current_dir(Path::new(env!("CARGO_MANIFEST_DIR")).join("experiments/lean"))
        .arg("--version");
    let version = process::bounded_output(
        &mut version,
        &directory,
        "lean-version",
        Duration::from_secs(15),
    )
    .expect("install the pinned Lean toolchain before running this test");
    assert!(version.status.success());
    let expected = experiment::TOOLCHAIN.trim().split(":v").nth(1).unwrap();
    assert!(
        String::from_utf8_lossy(&version.stdout).contains(&format!("version {expected},")),
        "unexpected Lean version: {:?}",
        version
    );

    let program = compile_to_ir(experiment::SOURCE).unwrap();
    fs::write(
        directory.join("increment.ceir"),
        cerune_lang::ir::text::emit(&program),
    )
    .unwrap();
    fs::write(directory.join("lean-toolchain"), experiment::TOOLCHAIN).unwrap();
    let generated = experiment::emit(&program).unwrap();
    let verified = format!("{generated}\n{}", experiment::PROPERTIES);
    let proof = directory.join("Verified.lean");
    fs::write(&proof, &verified).unwrap();
    let output = run(&proof, false);
    assert!(output.status.success(), "{output:?}");
    let log = String::from_utf8_lossy(&output.stdout);
    assert!(output.stderr.is_empty(), "{output:?}");
    assert!(
        !log.contains("warning:") && !log.contains("error:"),
        "{log}"
    );
    for theorem in [
        "translation_correct",
        "increment_exact",
        "ir_increment_exact",
        "overflow_detected",
    ] {
        assert!(
            log.contains(&format!(
                "'CeruneProof.{theorem}' does not depend on any axioms"
            )),
            "{log}"
        );
    }

    // 生成された定義を実行し、256入力すべてをIR・VM・既知の期待値と照合します。
    let executable = directory.join("Execute.lean");
    fs::write(
        &executable,
        format!("{generated}\ndef main : IO Unit := do\n  for input in List.range 256 do\n    IO.println (CeruneProof.render (CeruneProof.generated input))\n"),
    ).unwrap();
    let output = run(&executable, true);
    assert!(output.status.success(), "{output:?}");
    assert!(output.stderr.is_empty(), "{output:?}");
    let lean_output = String::from_utf8(output.stdout).unwrap();
    let lines: Vec<_> = lean_output.lines().collect();
    assert_eq!(lines.len(), 256, "{lean_output}");
    let function = experiment::SOURCE.split("\nprint(").next().unwrap();
    for (input, actual) in lines.into_iter().enumerate() {
        let source = format!("{function}\nprint(increment({input}));");
        let program = compile_to_ir(&source).unwrap();
        let direct = ir_executor::run(&program);
        let vm = run_bytecode(&bytecode::lower(&program).unwrap());
        if input < 255 {
            let expected = format!("{}\n", input + 1);
            assert_eq!(direct.unwrap(), expected);
            assert_eq!(vm.unwrap(), expected);
            assert_eq!(actual, format!("ok {}", input + 1));
        } else {
            let direct = direct.unwrap_err();
            let vm = vm.unwrap_err();
            let failure = direct.runtime_failure().unwrap();
            assert_eq!(failure.code, FailureCode::IntegerOverflow);
            assert_eq!(vm.runtime_failure(), Some(failure));
            assert_eq!(direct.output(), "");
            assert_eq!(vm.vm_error().output(), "");
            assert_eq!(
                actual,
                format!(
                    "integer-overflow node={} source={} bytes={}..{}",
                    failure.node_id.0,
                    failure.span.source_id().index(),
                    failure.span.start(),
                    failure.span.end()
                )
            );
        }
    }

    // 偽の定理が通っていないか、正しいファイルの一箇所だけを壊して検査します。
    let generated_start = verified.find("def generated ").unwrap();
    let (prefix, body) = verified.split_at(generated_start);
    let bad_value = format!("{prefix}{}", body.replacen("(pure 1)", "(pure 2)", 1));
    let bad_origin = format!(
        "{prefix}{}",
        body.replacen(
            "throw (.integerOverflow ⟨",
            "throw (.integerOverflow ⟨9999 + ",
            1
        )
    );
    let bad_property = verified.replacen(
        "generated x.val = .ok (x.val + 1)",
        "generated x.val = .ok (x.val + 2)",
        1,
    );
    for (name, bad) in [
        ("Value", bad_value),
        ("Origin", bad_origin),
        ("Property", bad_property),
    ] {
        assert_ne!(bad, verified, "mutation was not applied");
        let path = directory.join(format!("Rejected{name}.lean"));
        fs::write(&path, bad).unwrap();
        let output = run(&path, false);
        assert!(!output.status.success(), "invalid {name} accepted");
        assert!(
            String::from_utf8_lossy(&output.stdout).contains(if name == "Property" {
                "error: Type mismatch"
            } else {
                "error: Tactic `rfl` failed"
            }),
            "expected a proof error, not an infrastructure failure: {output:?}"
        );
    }
}
