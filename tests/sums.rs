use cerune_lang::{compile, compile_to_ir, run_vm};
#[path = "support/sum_cases.rs"]
mod sum_cases;

#[test]
fn examples_preserve_values_order_copies_and_branch_control() {
    for &(source, expected) in sum_cases::CASES {
        assert_eq!(run_vm(source).unwrap(), expected);
    }
}

#[test]
fn invalid_enums_patterns_and_constructors_are_rejected() {
    for (source, message) in [
        ("enum E {}", "at least one variant"),
        ("enum E { A, A }", "duplicate variant"),
        ("enum E { A { x: i64, x: i64 } }", "duplicate payload"),
        ("enum E { A { x: infer } }", "explicit"),
        ("enum E { A { x: i64 = 1 } }", "expected"),
        (
            "enum E { A, B } x: E = E::A {}; match x { E::A {} => {} }",
            "non-exhaustive",
        ),
        ("enum E { A } x: E = E::A {}; match x {}", "requires every"),
        (
            "enum E { A } x: E = E::A {}; match x { E::A {} => {}, E::A {} => {} }",
            "duplicate match",
        ),
        (
            "enum E { A } enum F { A } x: E = E::A {}; match x { E::A {} => {}, F::A {} => {} }",
            "same enum",
        ),
        ("enum E { A } match 1 { E::A {} => {} }", "match subject"),
        ("enum E { A } enum F { A } x: E = F::A {};", "type mismatch"),
        ("enum E { A { x: string } } x: E = E::A { x: 1 };", "A.x"),
        ("enum E { A } x: E = E::Z {};", "unknown variant"),
        ("enum E { A { x: i64 } } x: E = E::A {};", "missing payload"),
        ("enum E { A } x: E = E::A { x: 1 };", "unknown payload"),
        (
            "enum E { A { x: i64 } } x: E = E::A { x: 1, x: 2 };",
            "duplicate payload",
        ),
        (
            "enum E { A { x: i64 } } x: E = E::A { x: 1 }; match x { E::A {} => {} }",
            "missing pattern",
        ),
        (
            "enum E { A } x: E = E::A {}; match x { E::A { x: y } => {} }",
            "unknown payload",
        ),
        (
            "enum E { A { x: i64 } } x: E = E::A { x: 1 }; match x { E::A { x: a, x: b } => {} }",
            "duplicate pattern field",
        ),
        (
            "enum E { A { x: i64, y: i64 } } x: E = E::A { x: 1, y: 2 }; match x { E::A { x: a, y: a } => {} }",
            "duplicate pattern binding",
        ),
        (
            "enum E { A { x: i64 } } x: E = E::A { x: 1 }; match x { E::A { x: n } => { n = 2; } }",
            "immutable",
        ),
        (
            "enum E { A { x: i64 } } x: E = E::A { x: 1 }; match x { E::A { x: n } => {} } print(n);",
            "unknown binding",
        ),
        (
            "enum E { A } x: E = E::A {}; y: E = E { ..x };",
            "Enum::Variant",
        ),
        (
            "enum E { A } x: E = E::A {}; y: E = E::A { ..x };",
            "product update",
        ),
        (
            "enum E { A { x: i64 } } x: E = E::A { x: 1 }; print(x.x);",
            "no field",
        ),
        (
            "enum E { A } x: E = E::A {}; print(x == x);",
            "cannot apply",
        ),
        ("enum E { A { next: E }, B }", "infinite size"),
        (
            "enum E { A { next: E }, B } x: E = E::B {};",
            "infinite size",
        ),
        (
            "const n: i64 = 1; enum E { A { x: i64 } } match (E::A { x: 2 }) { E::A { x: n } => {} }",
            "conflicts with a constant",
        ),
    ] {
        let error = compile(source).unwrap_err();
        assert!(error.message().contains(message), "{source}\n{error:?}");
        assert!(error.primary_span().is_some());
    }
}

#[test]
fn ir_exposes_tag_map_and_source_positions() {
    let source = "// 日本語\r\nenum E { None, Some { text: string } }\nx: E = E::Some { text: \"data\" };\nmatch x { E::Some { text: word } => { print(word); }, E::None {} => {} }";
    let program = compile_to_ir(source).unwrap();
    assert_eq!(
        program.type_definitions[0].variants.as_ref().unwrap(),
        &["None", "Some"]
    );
    let text = cerune_lang::ir::text::emit(&program);
    assert!(text.contains("enum %E@0 tags [None=0, Some=1]"), "{text}");
    assert!(text.contains("$tag") && text.contains("$Some$text"));
    assert!(text.contains("[generated]") && text.contains("[explicit]"));
    let bytecode = cerune_lang::bytecode::lower(&program).unwrap();
    assert!(cerune_lang::bytecode::format_program(&bytecode).contains("generated"));
    let capture = program.statements.iter().find(|s| matches!(&s.kind, cerune_lang::ir::StatementKind::Binding { name, .. } if name.starts_with("$match"))).unwrap();
    assert_eq!(&source[capture.span.start()..capture.span.end()], "x");
    let bad = "enum E { A { text: string } } x: E = E::A { text: 123 };";
    let error = compile(bad).unwrap_err();
    let span = error.primary_span().unwrap();
    assert_eq!(&bad[span.start()..span.end()], "123");
}

#[test]
fn inactive_defaults_do_not_run_or_make_constants_effectful() {
    let source = r#"
        fn bad() -> i64 { print("unexpected"); return 1 / 0; }
        type P { x: i64 = bad(), y: i64, }
        enum E { Yes { p: P }, No }
        const NONE: E = E::No {};
        match NONE { E::No {} => { print("none"); }, E::Yes { p: _ } => { print("unexpected"); } }
    "#;
    assert_eq!(run_vm(source).unwrap(), "none\n");
}

#[test]
fn inactive_storage_has_a_bounded_expansion() {
    let error = compile("enum E { A { data: [u8; 100001] }, B } x: E = E::B {};").unwrap_err();
    assert!(error.message().contains("expansion limit"), "{error:?}");
}
