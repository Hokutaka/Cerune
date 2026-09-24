#[path = "support/rounding_cases.rs"]
mod cases;
#[allow(dead_code)]
#[path = "support/runtime_cases.rs"]
mod runtime_cases;
use cerune_lang::types::{
    ConversionMode, ConversionOverflow, IntegerType, NumericType, RoundingMode,
};
use cerune_lang::{
    RunError, bytecode, compile, compile_to_bytecode_text, compile_to_ir, compile_to_ir_text, ir,
    run_vm,
};

const MODES: &[(&str, RoundingMode)] = &[
    ("trunc", RoundingMode::Truncate),
    ("floor", RoundingMode::Floor),
    ("ceil", RoundingMode::Ceil),
    ("round", RoundingMode::Round),
    ("round_ties_even", RoundingMode::TiesEven),
];

#[test]
fn examples_all_types_and_boundaries_have_known_results() {
    for &(source, expected) in cases::CASES {
        assert_eq!(run_vm(source).unwrap(), expected);
    }
}

#[test]
fn rounding_and_overflow_remain_independent_and_keep_source_origins() {
    for &(name, rounding) in MODES {
        for (prefix, overflow) in [
            ("", ConversionOverflow::Checked),
            ("saturating_", ConversionOverflow::Saturating),
        ] {
            let name = format!("{prefix}{name}");
            let expression = format!("{name}<i32>(2.5f32)");
            let source = format!("// 日本語\r\nresult: infer = {expression};");
            let program = compile_to_ir(&source).unwrap();
            let ir::StatementKind::Binding { value: expr, .. } = &program.statements[0].kind else {
                panic!()
            };
            let ir::ExprKind::ConvertNumeric { mode, from, to, .. } = &expr.kind else {
                panic!()
            };
            let expected = ConversionMode::Rounded { rounding, overflow };
            assert_eq!(*mode, expected);
            assert_eq!(
                (*from, *to),
                (NumericType::F32, NumericType::Integer(IntegerType::I32))
            );
            assert_eq!(&source[expr.span.start()..expr.span.end()], expression);
            let lowered = bytecode::lower(&program).unwrap();
            let instruction = lowered
                .instructions
                .iter()
                .find(|i| matches!(i.kind, bytecode::InstructionKind::ConvertNumeric { .. }))
                .unwrap();
            let bytecode::InstructionKind::ConvertNumeric { mode, .. } = instruction.kind else {
                panic!()
            };
            assert_eq!(mode, expected);
            assert_eq!(
                instruction.origin,
                bytecode::InstructionOrigin::Source {
                    node_id: expr.id,
                    span: expr.span
                }
            );
            assert!(
                compile_to_ir_text(&source)
                    .unwrap()
                    .contains(&format!("convert.{name}.f32->i32[explicit]"))
            );
            assert!(
                compile_to_bytecode_text(&source)
                    .unwrap()
                    .contains(&format!("convert.{name} f32 -> i32"))
            );
        }
    }
}

#[test]
fn constant_evaluation_keeps_the_original_rounding_expression_and_value() {
    let source = "const COUNT: i64 = ceil<i64>(2.1); values: [i64; COUNT] = [1,2,3]; print(array_len(values));";
    let program = compile_to_ir(source).unwrap();
    let definition = &program.constant_definitions[0];
    assert!(matches!(
        definition.initializer.kind,
        ir::ExprKind::ConvertNumeric {
            mode: ConversionMode::Rounded {
                rounding: RoundingMode::Ceil,
                overflow: ConversionOverflow::Checked
            },
            ..
        }
    ));
    assert_eq!(
        &source[definition.initializer.span.start()..definition.initializer.span.end()],
        "ceil<i64>(2.1)"
    );
    assert!(matches!(definition.value.kind, ir::ExprKind::Integer(3)));
    let text = compile_to_ir_text(source).unwrap();
    assert!(text.contains("convert.ceil.f64->i64"));
    assert!(text.contains("[compile-time]"));
    assert_eq!(run_vm(source).unwrap(), "3\n");
    assert!(compile("const X: u8 = ceil<u8>(255.1);").is_err());
    assert_eq!(
        run_vm("const X: u8 = saturating_ceil<u8>(255.1); print(X);").unwrap(),
        "255\n"
    );
}

#[test]
fn invalid_types_arity_and_short_circuited_conversions_are_diagnosed() {
    for &(name, _) in MODES {
        for prefix in ["", "saturating_"] {
            let name = format!("{prefix}{name}");
            for expression in [
                format!("{name}<i64>(1)"),
                format!("{name}<f64>(1.5)"),
                format!("{name}<u8>(true)"),
                format!("{name}<u8>()"),
                format!("{name}<u8>(1.0, 2.0)"),
            ] {
                assert!(
                    compile(&format!("print({expression});")).is_err(),
                    "{expression}"
                );
            }
            assert!(compile(&format!("print(false && {name}<f64>(1.5) == 1.0);")).is_err());
        }
    }
}

#[test]
fn failure_records_keep_the_expression_and_prior_output() {
    for &(source, code, output, expression) in runtime_cases::ROUNDING_FAILURES {
        let RunError::Execution(error) = run_vm(source).unwrap_err() else {
            panic!()
        };
        let record = error.runtime_failure().unwrap();
        assert_eq!(record.code.name(), code);
        assert_eq!(error.vm_error().output(), output);
        assert_eq!(&source[record.span.start()..record.span.end()], expression);
    }
}

#[test]
fn builtin_names_remain_ordinary_names_and_generic_calls_are_distinct() {
    for &(name, _) in MODES {
        for prefix in ["", "saturating_"] {
            let name = format!("{prefix}{name}");
            assert_eq!(
                run_vm(&format!(
                    "fn {name}(v:i64)->i64{{return v;}} print({name}(7));"
                ))
                .unwrap(),
                "7\n"
            );
            assert_eq!(run_vm(&format!("fn {name}<T>(v:T)->T{{return v;}} print({name}::<i64>(8)); print({name}<i64>(2.0));")).unwrap(), "8\n2\n");
            assert_eq!(
                run_vm(&format!(
                    "{name}:i64=1; limit:i64=2; print({name} < limit);"
                ))
                .unwrap(),
                "true\n"
            );
        }
    }
}

#[test]
fn rounding_precedes_range_checks_and_saturation() {
    assert_eq!(run_vm("print(ceil<u8>(-0.9)); print(round_ties_even<u8>(-0.5)); print(round_ties_even<i8>(-128.5)); print(saturating_round<i8>(-128.5)); print(saturating_round_ties_even<u8>(255.5));").unwrap(), "0\n0\n-128\n-128\n255\n");
    assert_eq!(run_vm("print(ceil<i64>(1e-45f32)); print(floor<i64>(-1e-45f32)); print(round<i64>(0.49999997f32)); print(round<i64>(-0.49999997f32));").unwrap(), "1\n-1\n0\n0\n");
}

#[test]
fn exact_conversion_still_rejects_loss_and_negative_zero() {
    for source in [
        "print(convert<i64>(2.5));",
        "print(i64(-0.0));",
        "print(convert<u8>(256));",
    ] {
        assert!(matches!(run_vm(source), Err(RunError::Execution(_))));
    }
}
