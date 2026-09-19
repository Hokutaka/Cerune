use cerune_lang::{compile, compile_to_ir, ir, run_vm};
#[path = "support/constant_cases.rs"]
mod constant_cases;

#[test]
fn examples_cover_types_copies_short_circuit_and_float_values() {
    for &(source, expected) in constant_cases::CASES {
        assert_eq!(run_vm(source).unwrap(), expected);
    }
}

#[test]
fn unused_constants_fail_during_compilation_at_the_faulting_expression() {
    for (source, reason, expression) in [
        ("const BAD: i64 = 1 / 0;", "division-by-zero", "1 / 0"),
        ("const BAD: u8 = 255 + 1;", "integer-overflow", "255 + 1"),
        (
            "const BAD: i64 = i64(0.5);",
            "conversion-inexact",
            "i64(0.5)",
        ),
        (
            "const BAD: i64 = [1][2];",
            "array-index-out-of-bounds",
            "[1][2]",
        ),
        (
            "const BAD: i64 = LATER; const LATER: i64 = BAD;",
            "cyclic constant",
            "BAD",
        ),
        ("const BAD: bool = true || BAD;", "cyclic constant", "BAD"),
        ("x: i64 = 1; const BAD: i64 = x;", "unknown binding", "x"),
        (
            "fn f() -> i64 { print(1); return 2; } const BAD: i64 = f();",
            "function calls",
            "f()",
        ),
        (
            "fn f() -> bool { return true; } const BAD: bool = true || f();",
            "function calls",
            "f()",
        ),
        ("const BAD: i64 = true;", "expects i64", "true"),
    ] {
        for error in [
            compile(source).unwrap_err(),
            compile_to_ir(source).unwrap_err(),
        ] {
            assert!(error.message().contains(reason), "{source}: {error:?}");
            let span = error.primary_span().unwrap();
            assert_eq!(&source[span.start()..span.end()], expression, "{source}");
        }
    }
}

#[test]
fn constants_require_types_and_cannot_be_assigned_or_shadowed() {
    for (source, reason) in [
        ("const A: infer = 1;", "explicit type"),
        ("const A: i64 = 1; const A: i64 = 2;", "duplicate constant"),
        ("const A: i64 = 1; A = 2;", "cannot assign"),
        ("const A: [i64; 1] = [1]; A[0] = 2;", "cannot assign"),
        (
            "const A: i64 = 1; fn f(A: i64) -> i64 { return A; }",
            "conflicts with a constant",
        ),
        (
            "const A: i64 = 1; mut A: i64 = 2;",
            "conflicts with a constant",
        ),
        ("const A: i64 = 1; fn A() -> void {}", "conflicts"),
        ("fn f() -> void { const A: i64 = 1; }", "expected"),
    ] {
        let error = compile(source).unwrap_err();
        assert!(error.message().contains(reason), "{source}: {error:?}");
    }
}

#[test]
fn defaults_are_checked_only_when_used_by_the_constant_value() {
    let source = r#"
        fn effect() -> i64 { print("runtime"); return 4; }
        type P { x: i64 = effect(), y: i64, }
        const A: P = P { x: 1, y: 2 };
        const B: P = P { ..A, y: 3 };
        print(B.x); print(B.y);
        p: P = P { y: 0 }; print(p.x);
    "#;
    assert_eq!(run_vm(source).unwrap(), "1\n3\nruntime\n4\n");
    assert!(compile("fn f() -> i64 { return 1; } type P { x: i64 = f(), } const A: P = P { ..P { x: f() } };").unwrap_err().message().contains("function calls"));
    assert!(
        compile(
            "fn f() -> i64 { return 1; } type P { x: i64 = f(), y: i64, } const A: P = P { y: 2 };"
        )
        .unwrap_err()
        .message()
        .contains("function calls")
    );
}

#[test]
fn ir_keeps_definitions_results_and_distinct_use_site_origins() {
    let source = "// 日本語\r\nconst A: i64 = 2 + 3; print(A); print(A);";
    let mut sources = cerune_lang::source::SourceMap::new();
    let file = sources.add("constants.ceru", source);
    let program = cerune_lang::compile_source_to_ir(sources.get(file).unwrap()).unwrap();
    let definition = &program.constant_definitions[0];
    assert_eq!(sources.slice(definition.initializer.span), Some("2 + 3"));
    assert!(matches!(definition.value.kind, ir::ExprKind::Integer(5)));
    let mut ids = Vec::new();
    for statement in &program.statements {
        let ir::StatementKind::Print { value } = &statement.kind else {
            panic!()
        };
        let ir::ExprKind::Constant { id, value: literal } = &value.kind else {
            panic!()
        };
        assert_eq!(*id, 0);
        assert_eq!(sources.slice(literal.span), Some("A"));
        ids.push(literal.id);
    }
    assert_ne!(ids[0], ids[1]);
    let text = ir::text::emit(&program);
    assert!(text.contains("[compile-time]"));
    assert!(text.contains("const %A@0 =>"));
    let bytecode = cerune_lang::bytecode::lower(&program).unwrap();
    assert!(!cerune_lang::bytecode::format_program(&bytecode).contains("add.i64"));
}

#[test]
fn explicit_main_can_use_constants_and_bad_defaults_keep_definition_locations() {
    assert_eq!(
        run_vm("const A: i64 = 7; fn main() -> void { print(A); }").unwrap(),
        "7\n"
    );
    let source = "type P { x: i64 = 1 / 0, y: i64, } const A: P = P { y: 2 };";
    let error = compile(source).unwrap_err();
    let span = error.primary_span().unwrap();
    assert_eq!(&source[span.start()..span.end()], "1 / 0");
}

#[test]
fn constant_dependencies_are_bounded_and_shared_references_are_not_cycles() {
    let chain = |count: usize| {
        let mut source = String::new();
        for n in 0..count - 1 {
            source.push_str(&format!("const C{n}: i64 = C{};\n", n + 1));
        }
        source.push_str(&format!("const C{}: i64 = 7; print(C0);", count - 1));
        source
    };
    assert_eq!(run_vm(&chain(128)).unwrap(), "7\n");
    assert!(
        compile(&chain(129))
            .unwrap_err()
            .message()
            .contains("depth exceeds 128")
    );
    assert_eq!(
        run_vm(
            "const A: i64 = B + C; const B: i64 = D; const C: i64 = D; const D: i64 = 2; print(A);"
        )
        .unwrap(),
        "4\n"
    );
}

#[test]
fn folded_string_operations_keep_explicit_target_and_output_contracts() {
    let source = "const SAME: bool = \"a\" == \"a\"; print(SAME);";
    assert!(
        cerune_lang::compile_to_llvm(source)
            .unwrap_err()
            .message()
            .contains("explicit --target")
    );
    assert!(
        cerune_lang::compile_to_qbe(source)
            .unwrap_err()
            .message()
            .contains("explicit --target")
    );
    assert!(
        cerune_lang::compile_to_c(source)
            .unwrap()
            .contains("_setmode")
    );
}
