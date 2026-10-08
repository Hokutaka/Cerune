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
    let mir = cerune_lang::mir::lower(&program).unwrap();
    let generated = experiment::emit_with_mir(&program, &mir).unwrap();
    assert!(generated.contains("theorem translation_correct"));
    assert!(generated.contains("theorem mir_translation_correct"));
    assert_eq!(
        cerune_lang::mir_executor::run(&mir).unwrap(),
        "1\n42\n255\n"
    );
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
    let mir = cerune_lang::mir::lower(&program).unwrap();
    fs::write(
        directory.join("increment.mir.txt"),
        cerune_lang::mir::text::emit(&mir),
    )
    .unwrap();
    let generated = experiment::emit_with_mir(&program, &mir).unwrap();
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

    // MIRの有限領域の証明はLean標準のpropextだけに依存します。sorryや独自公理は拒否します。
    for theorem in [
        "mir_translation_correct",
        "mir_increment_exact",
        "mir_overflow_detected",
    ] {
        assert!(
            log.contains(&format!(
                "'CeruneProof.{theorem}' depends on axioms: [propext]"
            )),
            "{log}"
        );
    }

    // 生成された定義を実行し、256入力すべてをIR・MIR・VM・既知の期待値と照合します。
    let executable = directory.join("Execute.lean");
    fs::write(
        &executable,
        format!("{generated}\ndef main : IO Unit := do\n  for input in List.range 256 do\n    IO.println (CeruneProof.render (CeruneProof.generated input))\n    IO.println (CeruneProof.renderMir (CeruneProof.evalMir CeruneProof.mirReference input))\n"),
    ).unwrap();
    let output = run(&executable, true);
    assert!(output.status.success(), "{output:?}");
    assert!(output.stderr.is_empty(), "{output:?}");
    let lean_output = String::from_utf8(output.stdout).unwrap();
    let lines: Vec<_> = lean_output.lines().collect();
    assert_eq!(lines.len(), 512, "{lean_output}");
    let function = experiment::SOURCE.split("\nprint(").next().unwrap();
    for (input, pair) in lines.as_chunks::<2>().0.iter().enumerate() {
        let actual = pair[0];
        assert_eq!(actual, pair[1], "Lean HIR/MIR at input {input}");
        let source = format!("{function}\nprint(increment({input}));");
        let program = compile_to_ir(&source).unwrap();
        let direct = ir_executor::run(&program);
        let mir_result =
            cerune_lang::mir_executor::run(&cerune_lang::mir::lower(&program).unwrap());
        let vm = run_bytecode(&bytecode::lower(&program).unwrap());
        if input < 255 {
            let expected = format!("{}\n", input + 1);
            assert_eq!(direct.unwrap(), expected);
            assert_eq!(mir_result.unwrap(), expected);
            assert_eq!(vm.unwrap(), expected);
            assert_eq!(actual, format!("ok {}", input + 1));
        } else {
            let direct = direct.unwrap_err();
            let vm = vm.unwrap_err();
            let failure = direct.runtime_failure().unwrap();
            assert_eq!(failure.code, FailureCode::IntegerOverflow);
            assert_eq!(vm.runtime_failure(), Some(failure));
            let mir_error = mir_result.unwrap_err();
            assert_eq!(mir_error.runtime_failure(), Some(failure));
            assert_eq!(mir_error.output(), "");
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

    // HIRを固定してRustのMIR snapshotだけを改変し、再生成された定理が失敗するか確認します。
    for name in ["Value", "Origin", "Source", "Span", "Return"] {
        let changed = changed_mir(&mir, name);
        let bad = experiment::emit_with_mir(&program, &changed).unwrap();
        assert_ne!(generated, bad);
        let path = directory.join(format!("RejectedMir{name}.lean"));
        fs::write(&path, bad).unwrap();
        fs::write(
            directory.join(format!("RejectedMir{name}.mir.txt")),
            cerune_lang::mir::text::emit(&changed),
        )
        .unwrap();
        let output = run(&path, false);
        assert!(!output.status.success(), "invalid MIR {name} accepted");
        let errors = String::from_utf8_lossy(&output.stdout);
        assert!(
            errors.contains("error:") && errors.contains("decide") && errors.contains("false"),
            "expected a false correspondence, not an infrastructure failure: {output:?}"
        );
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
    check_branch_proofs(&directory, &run);
}

fn changed_mir(original: &cerune_lang::mir::Program, change: &str) -> cerune_lang::mir::Program {
    use cerune_lang::{
        ir::BinaryOp,
        mir::{InstructionKind as I, Operation as O, Origin, TerminatorKind},
    };
    let mut program = original.clone();
    let f = program
        .functions
        .iter_mut()
        .find(|f| f.name == "increment")
        .unwrap();
    let block = &mut f.blocks[f.entry.0];
    match change {
        "Value" => {
            let i = block
                .instructions
                .iter_mut()
                .find(|i| {
                    matches!(
                        i.kind,
                        I::Assign {
                            value: O::Literal(_),
                            ..
                        }
                    )
                })
                .unwrap();
            let I::Assign {
                value: O::Literal(cerune_lang::mir::Literal::Integer(n)),
                ..
            } = &mut i.kind
            else {
                unreachable!()
            };
            *n = 2;
        }
        "Origin" | "Source" | "Span" => {
            let i = block
                .instructions
                .iter_mut()
                .find(|i| {
                    matches!(
                        i.kind,
                        I::Assign {
                            value: O::Binary {
                                op: BinaryOp::Add,
                                ..
                            },
                            ..
                        }
                    )
                })
                .unwrap();
            let mut origin = i.origin.source().unwrap();
            if change == "Origin" {
                origin.node_id.0 += 1000;
            } else if change == "Source" {
                let mut sources = cerune_lang::source::SourceMap::new();
                let other = sources.add("different.ceru", "");
                origin.span = origin.span.with_source(other);
            } else {
                origin.span = cerune_lang::source::Span::in_source(
                    origin.span.source_id(),
                    origin.span.start() + 1,
                    origin.span.end(),
                );
            }
            i.origin = Origin::Source(origin);
        }
        "Return" => block.terminator.kind = TerminatorKind::Return(Some(f.parameters[0])),
        "Order" => block.instructions.swap(0, 2),
        "Unsupported" => {
            let i = block
                .instructions
                .iter_mut()
                .find(|i| {
                    matches!(
                        i.kind,
                        I::Assign {
                            value: O::Binary { .. },
                            ..
                        }
                    )
                })
                .unwrap();
            let I::Assign {
                value: O::Binary { op, .. },
                ..
            } = &mut i.kind
            else {
                unreachable!()
            };
            *op = BinaryOp::Subtract;
        }
        _ => panic!("unknown mutation"),
    }
    program
}

#[test]
fn mir_export_uses_the_supplied_snapshot_and_rejects_unsupported_or_invalid_mir() {
    let hir = compile_to_ir(experiment::SOURCE).unwrap();
    let mir = cerune_lang::mir::lower(&hir).unwrap();
    let before = mir.clone();
    let valid = experiment::emit_with_mir(&hir, &mir).unwrap();
    for mutation in ["Value", "Origin", "Source", "Span", "Return"] {
        let changed = changed_mir(&mir, mutation);
        cerune_lang::mir::validate(&changed).unwrap();
        assert_ne!(valid, experiment::emit_with_mir(&hir, &changed).unwrap());
    }
    assert_eq!(before, mir);
    for mutation in ["Order", "Unsupported"] {
        assert!(experiment::emit_with_mir(&hir, &changed_mir(&mir, mutation)).is_err());
    }
}

#[test]
fn branch_example_executes_and_export_rejects_cycles_and_unsupported_conditions() {
    let hir = compile_to_ir(experiment::branch::SOURCE).unwrap();
    let mir = cerune_lang::mir::lower(&hir).unwrap();
    let before = mir.clone();
    let generated = experiment::branch::emit(&hir, &mir).unwrap();
    let expected = "1\n127\n129\n130\n255\n";
    assert_eq!(ir_executor::run(&hir).unwrap(), expected);
    assert_eq!(cerune_lang::mir_executor::run(&mir).unwrap(), expected);
    assert_eq!(
        run_bytecode(&bytecode::lower(&hir).unwrap()).unwrap(),
        expected
    );
    for mutation in ["Targets", "Eager", "Comparison", "FailureOrigin"] {
        let changed = changed_branch_mir(&mir, mutation);
        cerune_lang::mir::validate(&changed).unwrap();
        assert_ne!(generated, experiment::branch::emit(&hir, &changed).unwrap());
    }
    assert_eq!(mir, before);
    let cyclic = changed_branch_mir(&mir, "Cycle");
    cerune_lang::mir::validate(&cyclic).unwrap();
    assert!(
        experiment::branch::emit(&hir, &cyclic)
            .unwrap_err()
            .contains("cyclic MIR")
    );
    let unsupported = experiment::branch::SOURCE.replace("value < 128", "value == 128");
    let hir = compile_to_ir(&unsupported).unwrap();
    let mir = cerune_lang::mir::lower(&hir).unwrap();
    assert!(
        experiment::branch::emit(&hir, &mir)
            .unwrap_err()
            .contains("unsupported HIR condition")
    );
}

fn changed_branch_mir(
    original: &cerune_lang::mir::Program,
    change: &str,
) -> cerune_lang::mir::Program {
    use cerune_lang::{
        ir::BinaryOp,
        mir::{InstructionKind as I, Operation as O, Origin, TerminatorKind as T},
    };
    let mut program = original.clone();
    let f = program
        .functions
        .iter_mut()
        .find(|f| f.name == "choose")
        .unwrap();
    match change {
        "Targets" => {
            let t = &mut f
                .blocks
                .iter_mut()
                .filter(|b| matches!(b.terminator.kind, T::Branch { .. }))
                .nth(1)
                .unwrap()
                .terminator
                .kind;
            let T::Branch {
                then_block,
                else_block,
                ..
            } = t
            else {
                unreachable!()
            };
            std::mem::swap(then_block, else_block);
        }
        "Eager" => {
            let t = &mut f.blocks[f.entry.0].terminator.kind;
            let T::Branch { then_block, .. } = *t else {
                unreachable!()
            };
            *t = T::Jump(then_block);
        }
        "Comparison" => {
            let i = f.blocks[f.entry.0]
                .instructions
                .iter_mut()
                .find(|i| {
                    matches!(
                        i.kind,
                        I::Assign {
                            value: O::Binary {
                                op: BinaryOp::Less,
                                ..
                            },
                            ..
                        }
                    )
                })
                .unwrap();
            let I::Assign {
                value: O::Binary { left, right, .. },
                ..
            } = &mut i.kind
            else {
                unreachable!()
            };
            std::mem::swap(left, right);
        }
        "FailureOrigin" => {
            let i = f
                .blocks
                .iter_mut()
                .flat_map(|b| &mut b.instructions)
                .filter(|i| {
                    matches!(
                        i.kind,
                        I::Assign {
                            value: O::Binary {
                                op: BinaryOp::Add,
                                ..
                            },
                            ..
                        }
                    )
                })
                .last()
                .unwrap();
            let mut origin = i.origin.source().unwrap();
            origin.node_id.0 += 1000;
            i.origin = Origin::Source(origin);
        }
        "Cycle" => {
            let last = cerune_lang::mir::BlockId(f.blocks.len() - 1);
            f.blocks[last.0].terminator.kind = T::Jump(last);
        }
        _ => panic!("unknown branch mutation"),
    }
    program
}

fn check_branch_proofs(directory: &Path, run: &impl Fn(&Path, bool) -> std::process::Output) {
    let hir = compile_to_ir(experiment::branch::SOURCE).unwrap();
    let mir = cerune_lang::mir::lower(&hir).unwrap();
    let generated = experiment::branch::emit(&hir, &mir).unwrap();
    fs::write(
        directory.join("branch.ceir"),
        cerune_lang::ir::text::emit(&hir),
    )
    .unwrap();
    fs::write(
        directory.join("branch.mir.txt"),
        cerune_lang::mir::text::emit(&mir),
    )
    .unwrap();
    fs::write(directory.join("BranchGenerated.lean"), &generated).unwrap();
    let verified = format!(
        "{generated}\n{}\n\
        example : CeruneProof.evalMirWithFuel CeruneProof.mirReference 0 0 = .exhausted := by rfl\n\
        example : CeruneProof.evalMir ⟨0, 0, []⟩ 0 = .exhausted := by rfl\n\
        example : CeruneProof.evalMirWithFuel ⟨0, 0, []⟩ 1 0 = .invalid := by rfl\n",
        experiment::branch::PROPERTIES
    );
    let file = directory.join("BranchVerified.lean");
    fs::write(&file, &verified).unwrap();
    let output = run(&file, false);
    assert!(
        output.status.success() && output.stderr.is_empty(),
        "{output:?}"
    );
    let log = String::from_utf8_lossy(&output.stdout);
    assert!(
        !log.contains("warning:") && !log.contains("error:"),
        "{log}"
    );
    for theorem in ["branch_translation_correct", "mir_branch_expected"] {
        assert!(
            log.contains(&format!(
                "'CeruneProof.{theorem}' depends on axioms: [propext]"
            )),
            "{log}"
        );
    }
    assert!(
        log.contains("'CeruneProof.branch_expected' does not depend on any axioms"),
        "{log}"
    );

    let file = directory.join("BranchExecute.lean");
    fs::write(&file, format!("{generated}\ndef main : IO Unit := do\n  for input in List.range 256 do\n    IO.println (CeruneProof.render (CeruneProof.evalBranch CeruneProof.branchReference input))\n    IO.println (CeruneProof.renderMir (CeruneProof.evalMir CeruneProof.mirReference input))\n")).unwrap();
    let output = run(&file, true);
    assert!(
        output.status.success() && output.stderr.is_empty(),
        "{output:?}"
    );
    let text = String::from_utf8(output.stdout).unwrap();
    let lines: Vec<_> = text.lines().collect();
    assert_eq!(lines.len(), 512, "{text}");
    let function = experiment::branch::SOURCE.split("\nprint(").next().unwrap();
    for (input, pair) in lines.as_chunks::<2>().0.iter().enumerate() {
        assert_eq!(pair[0], pair[1], "Lean HIR/MIR at input {input}");
        let hir = compile_to_ir(&format!("{function}\nprint(choose({input}));")).unwrap();
        let direct = ir_executor::run(&hir);
        let mir = cerune_lang::mir_executor::run(&cerune_lang::mir::lower(&hir).unwrap());
        let vm = run_bytecode(&bytecode::lower(&hir).unwrap());
        if input < 254 {
            let value = input + if input < 127 { 1 } else { 2 };
            let expected = format!("{value}\n");
            assert_eq!(direct.unwrap(), expected);
            assert_eq!(mir.unwrap(), expected);
            assert_eq!(vm.unwrap(), expected);
            assert_eq!(pair[0], format!("ok {value}"));
        } else {
            let direct = direct.unwrap_err();
            let mir = mir.unwrap_err();
            let vm = vm.unwrap_err();
            let failure = direct.runtime_failure().unwrap();
            assert_eq!(failure.code, FailureCode::IntegerOverflow);
            assert_eq!(mir.runtime_failure(), Some(failure));
            assert_eq!(vm.runtime_failure(), Some(failure));
            assert_eq!(direct.output(), "");
            assert_eq!(mir.output(), "");
            assert_eq!(vm.vm_error().output(), "");
            assert_eq!(
                pair[0],
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

    // HIRは固定し、分岐先・短絡・条件・停止位置だけをMIR側で壊します。
    for name in ["Targets", "Eager", "Comparison", "FailureOrigin"] {
        let changed = changed_branch_mir(&mir, name);
        let bad = experiment::branch::emit(&hir, &changed).unwrap();
        assert_ne!(generated, bad);
        let path = directory.join(format!("RejectedBranch{name}.lean"));
        fs::write(&path, bad).unwrap();
        fs::write(
            directory.join(format!("RejectedBranch{name}.mir.txt")),
            cerune_lang::mir::text::emit(&changed),
        )
        .unwrap();
        assert_false_proof(run(&path, false));
    }
    let path = directory.join("RejectedBranchProperty.lean");
    let bad = verified.replacen("input < 127", "input < 128", 1);
    assert_ne!(verified, bad);
    fs::write(&path, bad).unwrap();
    assert_false_proof(run(&path, false));

    // ||でも、選ばれない右辺を評価しない対応を検査します。
    let source = experiment::branch::SOURCE.replace(
        "value < 128 && value + 128 < 255",
        "127 < value || value + 128 < 255",
    );
    let hir = compile_to_ir(&source).unwrap();
    let mir = cerune_lang::mir::lower(&hir).unwrap();
    let path = directory.join("BranchOrVerified.lean");
    fs::write(&path, experiment::branch::emit(&hir, &mir).unwrap()).unwrap();
    let output = run(&path, false);
    assert!(
        output.status.success() && output.stderr.is_empty(),
        "{output:?}"
    );
}

fn assert_false_proof(output: std::process::Output) {
    assert!(!output.status.success(), "invalid branch proof accepted");
    let errors = String::from_utf8_lossy(&output.stdout);
    assert!(
        errors.contains("error:") && errors.contains("decide") && errors.contains("false"),
        "expected a false proposition, not an infrastructure failure: {output:?}"
    );
}
