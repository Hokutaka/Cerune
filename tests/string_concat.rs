use cerune_lang::{bytecode, compile, compile_to_ir, compile_to_ir_text, vm};
#[path = "support/concat_cases.rs"]
mod cases;

fn run(source: &str, limit: u64) -> Result<String, vm::VmError> {
    let mut program = compile_to_ir(source).unwrap();
    program.string_heap_limit = limit;
    vm::run(&bytecode::lower(&program).unwrap())
}
#[test]
fn examples_and_nested_values_match_known_bytes() {
    for &(source, expected) in cases::CASES {
        assert_eq!(run(source, 65536).unwrap(), expected);
    }
}
#[test]
fn releases_on_scope_loop_return_break_continue_and_condition() {
    let source = r#"
        fn value() -> string { v:string=concat("a","b"); return v; }
        for (mut i:i64=0; i<1000; i=i+1) {
            s:string=value();
            if i < 999 { continue; }
            print(s);
        }
        mut i:i64=0;
        while concat("a","b") == "ab" {
            s:string=value();
            i=i+1;
            if i==1000 { break; }
        }
        print(concat("a","b"));
    "#;
    assert_eq!(run(source, 2).unwrap(), "ab\nab\n");
}
#[test]
fn shared_values_count_once_but_old_and_new_coexist() {
    let source =
        r#"mut s:string=concat("a","b"); saved:string=s; s=concat(s,"c"); print(saved); print(s);"#;
    assert_eq!(run(source, 5).unwrap(), "ab\nabc\n");
    let error = run(source, 4).unwrap_err();
    assert_eq!(error.kind(), vm::VmErrorKind::AllocationLimitExceeded);
    let source = r#"print(concat("", "")); print("static");"#;
    assert_eq!(run(source, 0).unwrap(), "\nstatic\n");
}
#[test]
fn failure_preserves_output_original_span_and_skips_right_operand() {
    let source = r#"fn right()->string{print("bad");return "";} print("before"); print(concat(concat("a","b"),right()));"#;
    let mut ir = compile_to_ir(source).unwrap();
    ir.string_heap_limit = 1;
    let code = bytecode::lower(&ir).unwrap();
    let error = vm::run(&code).unwrap_err();
    assert_eq!(error.output(), "before\n");
    assert_eq!(error.kind(), vm::VmErrorKind::AllocationLimitExceeded);
    let instructions = match error.function_id() {
        Some(id) => &code.functions[id].instructions,
        None => &code.instructions,
    };
    let bytecode::InstructionOrigin::Source { span, .. } =
        instructions[error.instruction_index()].origin
    else {
        panic!()
    };
    assert_eq!(&source[span.start()..span.end()], r#"concat("a","b")"#);
}
#[test]
fn constant_result_is_static_and_ir_exposes_ownership() {
    assert_eq!(
        run(r#"const S:string=concat("日","本"); print(S);"#, 0).unwrap(),
        "日本\n"
    );
    let text = compile_to_ir_text(
        r#"mut s:string=concat("a","b"); saved:string=s; s=concat(s,"c"); print(saved); print(s);"#,
    )
    .unwrap();
    for expected in [
        "string.concat.allocate-copy",
        "string.retain",
        "string.release",
        "ownership-replace",
        "string-heap-limit=67108864",
    ] {
        assert!(text.contains(expected), "{expected}");
    }
}
#[test]
fn concat_requires_exactly_two_strings_and_is_reserved() {
    for source in [
        "print(concat());",
        "print(concat(\"a\"));",
        "print(concat(\"a\",1));",
        "fn concat()->string{return \"\";}",
    ] {
        assert!(compile(source).is_err(), "{source}");
    }
}
#[test]
fn array_checks_precede_later_indices_and_rhs() {
    let source = r#"fn next()->i64{print("bad");return 0;} fn rhs()->string{print("bad");return concat("a","b");} mut a:[[string;1];1]=[[""]]; a[1][next()]=rhs();"#;
    let error = run(source, 2).unwrap_err();
    assert_eq!(
        error.kind(),
        vm::VmErrorKind::ArrayIndexOutOfBounds {
            index: 1,
            length: 1
        }
    );
    assert_eq!(error.output(), "");
}

#[test]
fn cli_budget_validation_precedes_artifact_writes() {
    use std::{fs, process::Command};
    let dir = std::env::temp_dir().join(format!(
        "cerune-concat-options-{}-{}",
        std::process::id(),
        std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap()
            .as_nanos()
    ));
    fs::create_dir(&dir).unwrap();
    let source = dir.join("source.ceru");
    let artifact = dir.join("output.c");
    fs::write(&source, r#"const S:string=concat("a","b");print(S);"#).unwrap();
    fs::write(&artifact, "preserve").unwrap();
    for options in [
        vec!["--string-heap-limit"],
        vec!["--string-heap-limit", "-1"],
        vec!["--string-heap-limit", "1.5"],
        vec!["--string-heap-limit", "9223372036854775808"],
        vec!["--string-heap-limit", "0", "--string-heap-limit", "1"],
    ] {
        let result = Command::new(env!("CARGO_BIN_EXE_cerune"))
            .arg("emit-c")
            .arg(&source)
            .arg("-o")
            .arg(&artifact)
            .args(options)
            .output()
            .unwrap();
        assert!(!result.status.success());
        assert!(result.stdout.is_empty());
        assert_eq!(fs::read_to_string(&artifact).unwrap(), "preserve");
    }
    let result = Command::new(env!("CARGO_BIN_EXE_cerune"))
        .arg("run")
        .arg(&source)
        .args(["--string-heap-limit", "0"])
        .output()
        .unwrap();
    assert!(result.status.success());
    assert_eq!(result.stdout, b"ab\n");
    assert!(result.stderr.is_empty());
    fs::remove_dir_all(dir).unwrap();
}

#[test]
fn owned_arguments_release_on_return_and_preserve_failure_order() {
    let (source, expected) = cases::OWNED_ARGUMENTS;
    let mut program = compile_to_ir(source).unwrap();
    program.string_heap_limit = 22;
    assert_eq!(cerune_lang::ir_executor::run(&program).unwrap(), expected);
    assert_eq!(run(source, 22).unwrap(), expected);
    for (limit, prior) in [
        (15, "[\"保存\"]\n[\"変更\"]\n左\n"),
        (19, "[\"保存\"]\n[\"変更\"]\n左\n右\n"),
    ] {
        program.string_heap_limit = limit;
        let direct = cerune_lang::ir_executor::run(&program).unwrap_err();
        let vm = run(source, limit).unwrap_err();
        assert_eq!(direct.output(), prior);
        assert_eq!(vm.output(), prior);
        assert_eq!(vm.kind(), vm::VmErrorKind::AllocationLimitExceeded);
        let failure = direct.runtime_failure().unwrap();
        assert_eq!(
            failure.code,
            cerune_lang::runtime::FailureCode::AllocationLimitExceeded
        );
        assert_eq!(
            &source[failure.span.start()..failure.span.end()],
            "concat(label, \"!\")"
        );
    }

    // 未使用の引数もcalleeが解放し、返却した所有だけを呼び出し元に残します。
    let source = include_str!("fixtures/observation/owned-arguments/source.ceru");
    assert_eq!(run(source, 2).unwrap(), "cd\n");
    let mut program = compile_to_ir(source).unwrap();
    program.string_heap_limit = 2;
    assert_eq!(cerune_lang::ir_executor::run(&program).unwrap(), "cd\n");
}

#[test]
fn reads_do_not_generate_aggregate_retains_but_value_copies_do() {
    use cerune_lang::ir::{LoweringKind, StatementKind, Type};
    let source = r#"mut a:[string;1]=[concat("a","b")];
        print(array_len(a)); print(a[0]); print(a); print(a==a);"#;
    let program = compile_to_ir(source).unwrap();
    assert!(program.statements.iter().any(|s| matches!(
        &s.kind,
        StatementKind::Binding {
            borrowed: true,
            ty: Type::Array { .. },
            ..
        }
    )));
    assert!(
        !program
            .function_definitions
            .iter()
            .any(|f| f.lowering == Some(LoweringKind::OwnershipRetain))
    );
    assert_eq!(run(source, 2).unwrap(), "1\nab\n[\"ab\"]\ntrue\n");
    assert_eq!(
        cerune_lang::ir_executor::run(&program).unwrap(),
        "1\nab\n[\"ab\"]\ntrue\n"
    );

    let copied = format!("{source} saved:[string;1]=a; a[0]=\"changed\"; print(saved); print(a);");
    let program = compile_to_ir(&copied).unwrap();
    assert!(
        program
            .function_definitions
            .iter()
            .any(|f| f.lowering == Some(LoweringKind::OwnershipRetain))
    );
    assert_eq!(
        run(&copied, 2).unwrap(),
        "1\nab\n[\"ab\"]\ntrue\n[\"ab\"]\n[\"changed\"]\n"
    );
}

#[test]
fn projections_preserve_the_existing_budget_and_returned_value_lifetime() {
    for (source, limit, expected) in [
        (cases::BORROWED_READS.0, 30, cases::BORROWED_READS.1),
        (cases::PROJECTED_TEMPORARIES, 6, "true\n"),
        (
            r#"fn make()->[string;1]{return [concat("a","b")];}
            for(mut i:i64=0;i<1000;i=i+1) {
                value:string=make()[0];
                if i==999 {print(value);}
            }"#,
            2,
            "ab\n",
        ),
    ] {
        let mut program = compile_to_ir(source).unwrap();
        program.string_heap_limit = limit;
        assert_eq!(run(source, limit).unwrap(), expected);
        assert_eq!(cerune_lang::ir_executor::run(&program).unwrap(), expected);
    }
    let source = cases::BORROWED_READS.0;
    let error = run(source, 29).unwrap_err();
    assert_eq!(error.kind(), vm::VmErrorKind::AllocationLimitExceeded);
    assert_eq!(
        error.output(),
        "束縛\n2\n日本\n[\"日本\", \"二\"]\ntrue\n一時\n2\n抽出\n日本\n左\n右\n"
    );
    let mut program = compile_to_ir(source).unwrap();
    program.string_heap_limit = 29;
    let error = cerune_lang::ir_executor::run(&program).unwrap_err();
    let failure = error.runtime_failure().unwrap();
    assert_eq!(
        &source[failure.span.start()..failure.span.end()],
        "concat(\"棚\", \"\")"
    );
}
