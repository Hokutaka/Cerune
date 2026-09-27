use cerune_lang::{compile, compile_to_ir_text, run_vm};
#[path = "support/aggregate_cases.rs"]
mod cases;

#[test]
fn aggregate_values_match_known_outputs() {
    for &(source, expected) in cases::CASES {
        assert_eq!(run_vm(source).unwrap(), expected);
    }
}
#[test]
fn aggregate_lowering_exposes_copies_loops_fields_and_output_fragments() {
    let ir = compile_to_ir_text(cases::CASES[0].0).unwrap();
    assert!(ir.contains("$equal") && ir.contains("$left") && ir.contains("$right"));
    let ir = compile_to_ir_text(cases::CASES[1].0).unwrap();
    assert!(ir.contains("$display") && ir.contains("write.quoted") && ir.contains("$index"));
}
#[test]
fn mismatched_types_and_ordering_stay_invalid() {
    for source in [
        "print([1] == [1, 2]);",
        "print([1i64] == [1u64]);",
        "print([1] < [2]);",
        "type A { x:i64 } type B { x:i64 } print(A{x:1} == B{x:1});",
    ] {
        assert!(compile(source).is_err(), "{source}");
    }
}
#[test]
fn failed_operand_produces_no_partial_display() {
    let source = "fn bad() -> [i64; 1] { print(\"before\"); return [1 / 0]; } print(bad());";
    let cerune_lang::RunError::Execution(error) = run_vm(source).unwrap_err() else {
        panic!()
    };
    assert_eq!(error.vm_error().output(), "before\n");
    let record = error.runtime_failure().unwrap();
    assert_eq!(&source[record.span.start()..record.span.end()], "1 / 0");
}

#[test]
fn match_rejects_incomplete_unreachable_and_mistyped_arms() {
    for source in [
        "enum E { A, B } x: E = E::A {}; print(match x { E::A {} if true => 1, E::B {} => 2 });",
        "enum E { A } x: E = E::A {}; print(match x { E::A {} => 1, E::A {} if true => 2 });",
        "enum E { A } x: E = E::A {}; print(match x { E::A {} if 1 => 1, E::A {} => 2 });",
        "enum E { A, B } x: E = E::A {}; print(match x { E::A {} => 1, E::B {} => false });",
        "enum E { A { n:i64 } } x: E = E::A {n:1}; print(match x { E::A {n:n} => n }); print(n);",
        "enum E { A { n:i64 } } x: E = E::A {n:1}; print(match x { E::A {} => 1 });",
        "enum E { A } print(match 1 { E::A {} => 1 });",
    ] {
        assert!(compile(source).is_err(), "{source}");
    }
}
#[test]
fn match_supports_nested_expressions_contextual_types_and_independent_scopes() {
    let source = r#"
        enum E { A { n: i64 }, B }
        fn mark(n:i64) -> i64 { print(n); return n; }
        fn add(a:i64,b:i64,c:i64)->i64 {return a+b+c;}
        n:i64=100;
        item:E=E::A{n:3};
        print(add(mark(1), match item {
            E::A{n:x} if false => mark(9),
            E::A{n:x} => match (E::B{}) { E::A{n:n} => n, E::B{} => mark(x) + n },
            E::B{} => mark(0),
        }, mark(2)));
        small:u8=match item{ E::A{n:_}=>255, E::B{}=>0 };
        print(small);
        fn result(x:E)->i64 {
            match x { E::A{n:n} if n>0 => { return n; }, E::A{n:_} => {return 0;}, E::B{} => {return -1;} }
        }
        print(result(item));
    "#;
    assert_eq!(run_vm(source).unwrap(), "1\n3\n2\n106\n255\n3\n");
}
#[test]
fn constant_match_failure_keeps_the_inner_source_expression() {
    let source = "enum E{A,B} const X:i64=match (E::A{}){ E::A{}=>1 / 0, E::B{}=>2 };";
    let error = compile(source).unwrap_err();
    assert!(error.message().contains("division-by-zero"), "{error:?}");
    let span = error.primary_span().unwrap();
    assert_eq!(&source[span.start()..span.end()], "1 / 0");
}
#[test]
fn match_helpers_report_guard_and_result_failures_with_prior_output() {
    for &(source, code, output, expression) in runtime_cases::AGGREGATE_FAILURES {
        let cerune_lang::RunError::Execution(error) = run_vm(source).unwrap_err() else {
            panic!()
        };
        let record = error.runtime_failure().unwrap();
        assert_eq!(record.code.name(), code);
        assert_eq!(error.vm_error().output(), output);
        assert_eq!(&source[record.span.start()..record.span.end()], expression);
    }
}
#[allow(dead_code)]
#[path = "support/runtime_cases.rs"]
mod runtime_cases;

#[test]
fn nested_copy_baseline_shares_string_bytes_and_keeps_failure_origin() {
    use cerune_lang::{bytecode, compile_to_ir, vm};
    let (source, expected) = cases::CASES[7];
    let text = compile_to_ir_text(source).unwrap();
    for operation in [
        "string.concat.allocate-copy",
        "ownership-retain",
        "ownership-release",
        "for.loop",
    ] {
        assert!(text.contains(operation), "missing {operation}");
    }
    let mut ir = compile_to_ir(source).unwrap();
    ir.string_heap_limit = 24;
    assert_eq!(vm::run(&bytecode::lower(&ir).unwrap()).unwrap(), expected);

    // 元の3領域18バイトと変更用6バイトが共存する時点を検査します。
    ir.string_heap_limit = 23;
    let code = bytecode::lower(&ir).unwrap();
    let error = vm::run(&code).unwrap_err();
    assert_eq!(error.kind(), vm::VmErrorKind::AllocationLimitExceeded);
    assert_eq!(error.output(), "対象\n");
    let instructions = &code.functions[error.function_id().unwrap()].instructions;
    let bytecode::InstructionOrigin::Source { span, .. } =
        instructions[error.instruction_index()].origin
    else {
        panic!("source origin must survive ownership lowering");
    };
    assert_eq!(&source[span.start()..span.end()], r#"concat("更", "新")"#);
}
