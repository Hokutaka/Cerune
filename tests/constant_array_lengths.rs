use cerune_lang::{compile, compile_to_ir, run_vm};

#[test]
fn lengths_share_existing_constant_semantics_and_array_identity() {
    let source = r#"
        const COUNT: i64 = BASE + 1;
        const BASE: i64 = 2;
        const SIZES: [i64; 2] = [2, 3];
        const ROWS: u8 = u8(SIZES[0]);
        const COLUMNS: i64 = array_len([4, 5, 6]);
        type Grid { data: [[i64; COLUMNS]; ROWS] }
        const GRID: Grid = Grid { data: [[1, 2, 3], [4, 5, 6]] };
        fn sum(values: [i64; COUNT]) -> i64 {
            mut result: i64 = 0;
            for (v: infer in values) { result = result + v; }
            return result;
        }
        values: [i64; COUNT] = [7, 8, 9];
        literal: [i64; 3] = values;
        print(sum(literal));
        for (row: [i64; COUNT] in GRID.data) { print(sum(row)); }
    "#;
    assert_eq!(run_vm(source).unwrap(), "24\n6\n15\n");
}

#[test]
fn used_defaults_and_aggregate_constants_can_supply_lengths() {
    let source = r#"
        fn runtime() -> i64 { print("runtime"); return 99; }
        type Size { n: i64 = 2, ignored: i64 = runtime() }
        const SETTINGS: Size = Size { ignored: 0 };
        const UPDATED: Size = Size { ..SETTINGS, n: 3 };
        const COUNT: i64 = UPDATED.n;
        enum Choice { Data { values: [i64; COUNT] }, Empty }
        const EMPTY: Choice = Choice::Empty {};
        a: [string; COUNT] = ["a", "b", "c"];
        print(array_len(a));
        match EMPTY { Choice::Empty {} => { print("empty"); }, Choice::Data { values: x } => { print(array_len(x)); } }
    "#;
    assert_eq!(run_vm(source).unwrap(), "3\nempty\n");
    assert_eq!(run_vm("type Size { n: i64 = 2, marker: bool } const N: i64 = (Size { marker: true }).n; a: [i64; N] = [1, 2]; print(array_len(a));").unwrap(), "2\n");
}

#[test]
fn all_integer_constant_types_are_lengths_without_numeric_coercion() {
    for ty in ["i8", "u8", "i16", "u16", "i32", "u32", "i64", "u64"] {
        assert_eq!(
            run_vm(&format!(
                "const N: {ty} = 2; a: [bool; N] = [true, false]; print(array_len(a));"
            ))
            .unwrap(),
            "2\n"
        );
    }
}

#[test]
fn invalid_lengths_and_cycles_fail_before_execution() {
    for (source, reason) in [
        ("const N: i64 = 0; a: [i64; N] = [1];", "greater than zero"),
        ("const N: i64 = -1; a: [i64; N] = [1];", "greater than zero"),
        (
            "const N: u64 = 18446744073709551615; type T { a: [i64; N] }",
            "too large",
        ),
        (
            "const N: bool = true; type T { a: [i64; N] }",
            "integer type",
        ),
        ("const N: f64 = 2.0; type T { a: [i64; N] }", "integer type"),
        (
            "const N: string = \"2\"; type T { a: [i64; N] }",
            "integer type",
        ),
        ("N: i64 = 2; a: [i64; N] = [1, 2];", "constant"),
        (
            "fn size() -> i64 { return 2; } const N: i64 = size(); type T { a: [i64; N] }",
            "function calls",
        ),
        (
            "const N: i64 = 1 / 0; type T { a: [i64; N] }",
            "division-by-zero",
        ),
        (
            "const A: i64 = B; const B: i64 = A; type T { a: [i64; A] }",
            "cyclic",
        ),
        (
            "const N: i64 = array_len(DATA); const DATA: [i64; N] = [1];",
            "cyclic",
        ),
        (
            "type T { a: [i64; N] } const N: i64 = array_len((T { a: [1] }).a);",
            "cyclic",
        ),
        ("const N: i64 = 2; a: [i64; N] = [1];", "length mismatch"),
        ("const N: i64 = 100001; type T { a: [i64; N] }", "storage"),
        ("type T { a: [[i64; 1000]; 1000] }", "storage"),
    ] {
        for error in [
            compile(source).unwrap_err(),
            compile_to_ir(source).unwrap_err(),
        ] {
            assert!(error.message().contains(reason), "{source}: {error:?}");
            assert!(error.primary_span().is_some());
        }
    }
    for source in [
        "const N: i64 = 2; a: [i64; N + 1] = [1, 2, 3];",
        "a: [i64; array_len([1])] = [1];",
    ] {
        assert!(compile(source).is_err());
    }
}

#[test]
fn ir_preserves_length_references_and_defining_expression_origins() {
    let source = "// 日本語\r\nconst N: i64 = 1 + 1;\r\na: [i64; N] = [1, 2];";
    let mut sources = cerune_lang::source::SourceMap::new();
    let file = sources.add("lengths.ceru", source);
    let program = cerune_lang::compile_source_to_ir(sources.get(file).unwrap()).unwrap();
    let definition = &program.constant_definitions[0];
    assert_eq!(sources.slice(definition.initializer.span), Some("1 + 1"));
    assert_eq!(definition.array_length_uses.len(), 1);
    assert_eq!(sources.slice(definition.array_length_uses[0]), Some("N"));
    assert!(cerune_lang::ir::text::emit(&program).contains("array-length %N@0 => 2"));
    for (text, slice) in [
        ("const N: i64 = 1 / 0; type T { x: [i64; N] }", "1 / 0"),
        ("const N: i64 = 0; type T { x: [i64; N] }", "N"),
    ] {
        let error = compile_to_ir(text).unwrap_err();
        let span = error.primary_span().unwrap();
        assert_eq!(&text[span.start()..span.end()], slice);
    }
}

#[test]
fn length_dependency_depth_is_bounded() {
    let mut source = String::from("type T { values: [i64; N0] }\n");
    for i in 0..130 {
        source.push_str(&format!("const N{i}: i64 = N{};\n", i + 1));
    }
    source.push_str("const N130: i64 = 1;");
    assert!(compile(&source).unwrap_err().message().contains("depth"));
}

#[path = "support/length_constant_cases.rs"]
mod length_constant_cases;
#[test]
fn examples_match_known_outputs() {
    for &(source, expected) in length_constant_cases::CASES {
        assert_eq!(run_vm(source).unwrap(), expected);
    }
}

#[test]
fn storage_limits_apply_equally_to_literal_constant_and_inferred_types() {
    for source in [
        "fn f(values: [i64; 100001]) -> void {}",
        "const N: i64 = 100001; fn f(values: [i64; N]) -> void {}",
        "fn f(values: [i64; 100000]) -> void { copy: infer = [values, values]; }",
        "type Row { a: [i64; 60000] } type Pair { first: Row, second: Row }",
    ] {
        assert!(
            compile(source).unwrap_err().message().contains("storage"),
            "{source}"
        );
    }
    compile("const N: i64 = 100000; fn f(values: [i64; N]) -> void {}").unwrap();
}

#[test]
fn unused_defaults_and_short_circuit_do_not_change_length_values() {
    assert_eq!(
        run_vm(
            r#"
        type Config { value: i64 = 1 / 0, size: i64 }
        const CONFIG: Config = Config { value: 0, size: 2 };
        const LENGTH: i64 = CONFIG.size;
        const SKIPPED: bool = true || 1 / 0 == 0;
        type Pair { a: [i64; LENGTH] }
        print(SKIPPED);
        print(array_len((Pair { a: [1, 2] }).a));
    "#
        )
        .unwrap(),
        "true\n2\n"
    );
    let error = compile("fn f() -> bool { return true; } const FLAG: bool = true || f(); type P { flag: bool, n: i64 } const N: i64 = (P { flag: FLAG, n: 2 }).n; type A { data: [i64; N] }").unwrap_err();
    assert!(error.message().contains("function calls"));
}

#[allow(dead_code)]
#[path = "support/runtime_cases.rs"]
mod runtime_cases;
#[test]
fn runtime_failures_keep_the_use_site_instead_of_the_length_definition() {
    for &(source, code, output, expression) in runtime_cases::CONSTANT_LENGTH_FAILURES {
        let ir = compile_to_ir(source).unwrap();
        let error =
            cerune_lang::run_bytecode(&cerune_lang::bytecode::lower(&ir).unwrap()).unwrap_err();
        let failure = error.runtime_failure().unwrap();
        assert_eq!(failure.code.name(), code);
        assert_eq!(error.vm_error().output(), output);
        assert_eq!(
            &source[failure.span.start()..failure.span.end()],
            expression
        );
    }
}

#[test]
fn semantic_model_resolves_original_ast_annotations_without_losing_names() {
    let ast = compile("const N: i64 = 2; values: [[i64; N]; N] = [[1, 2], [3, 4]];").unwrap();
    let cerune_lang::ast::StmtKind::Binding {
        type_spec: cerune_lang::ast::TypeSpec::Explicit(ty),
        ..
    } = &ast.statement(0).kind
    else {
        panic!()
    };
    assert!(matches!(
        ty.kind,
        cerune_lang::ast::TypeRefKind::ArrayConstant { .. }
    ));
    let model = cerune_lang::semantic::analyze(&ast).unwrap();
    assert_eq!(
        model.type_name(model.resolve_type_ref(ty).unwrap()),
        "[[i64; 2]; 2]"
    );
}
