#[path = "support/truncation_cases.rs"]
mod cases;
#[allow(dead_code)]
#[path = "support/runtime_cases.rs"]
mod runtime_cases;
use cerune_lang::vm::{NumericConversionFailure as Failure, VmErrorKind};
use cerune_lang::{RunError, compile, compile_to_bytecode_text, compile_to_ir_text, run_vm};

#[test]
fn truncation_examples_and_boundaries_match_known_values() {
    for &(source, expected) in cases::CASES {
        assert_eq!(run_vm(source).unwrap(), expected);
    }
}
#[test]
fn invalid_types_are_rejected_even_in_short_circuited_code() {
    for (source, reason) in [
        (
            "print(trunc<i64>(1));",
            "trunc requires an f32 or f64 value",
        ),
        (
            "print(trunc<f64>(1.5));",
            "trunc target must be an integer type",
        ),
        (
            "print(false && trunc<f32>(1.5) == 1.0);",
            "trunc target must be an integer type",
        ),
    ] {
        assert!(compile(source).unwrap_err().message().contains(reason));
    }
}
#[test]
fn explicit_policy_is_visible_and_exact_conversion_stays_exact() {
    let source = "print(trunc<i64>(1.5)); print(convert<i64>(2.0));";
    let ir = compile_to_ir_text(source).unwrap();
    assert!(ir.contains("convert.trunc.f64->i64[explicit]"));
    assert!(ir.contains("convert.exact.f64->i64[explicit]"));
    let bytecode = compile_to_bytecode_text(source).unwrap();
    assert!(bytecode.contains("convert.trunc f64 -> i64"));
    assert!(bytecode.contains("convert.exact f64 -> i64"));
    for (source, expected) in [
        ("print(convert<i64>(1.5));", Failure::Inexact),
        ("print(i64(-0.0));", Failure::NegativeZero),
    ] {
        let RunError::Execution(error) = run_vm(source).unwrap_err() else {
            panic!()
        };
        let VmErrorKind::NumericConversionFailed { reason, .. } = error.vm_error().kind() else {
            panic!()
        };
        assert_eq!(reason, expected);
    }
}
#[test]
fn failures_keep_prior_output_and_the_original_expression() {
    for &(source, code, output, expression) in runtime_cases::TRUNCATION_FAILURES {
        let RunError::Execution(error) = run_vm(source).unwrap_err() else {
            panic!()
        };
        let record = error.runtime_failure().unwrap();
        assert_eq!(record.code.name(), code);
        assert_eq!(error.vm_error().output(), output);
        let start = source.find(expression).unwrap();
        assert_eq!(
            record.span,
            cerune_lang::source::Span::new(start, start + expression.len())
        );
    }
    let source = "print(trunc<i64>(f64(1 / 0)));";
    let RunError::Execution(error) = run_vm(source).unwrap_err() else {
        panic!()
    };
    let record = error.runtime_failure().unwrap();
    assert_eq!(record.code.name(), "division-by-zero");
    let start = source.find("1 / 0").unwrap();
    assert_eq!(
        record.span,
        cerune_lang::source::Span::new(start, start + 5)
    );
}

#[test]
fn trunc_is_available_as_an_ordinary_name() {
    assert_eq!(
        run_vm("fn trunc<T>(v:T)->T { return v; } print(trunc::<i64>(4));").unwrap(),
        "4\n"
    );
    assert_eq!(
        run_vm("trunc: i64 = 1; limit: i64 = 2; print(trunc < limit);").unwrap(),
        "true\n"
    );
}
#[test]
fn every_destination_reports_range_and_nonfinite_failures() {
    for (ty, lower, upper) in [
        ("i8", "-129.0", "128.0"),
        ("u8", "-1.0", "256.0"),
        ("i16", "-32769.0", "32768.0"),
        ("u16", "-1.0", "65536.0"),
        ("i32", "-2147483649.0", "2147483648.0"),
        ("u32", "-1.0", "4294967296.0"),
        ("i64", "-9223372036854777856.0", "9223372036854775808.0"),
        ("u64", "-1.0", "18446744073709551616.0"),
    ] {
        for (value, expected) in [
            (lower, Failure::OutOfRange),
            (upper, Failure::OutOfRange),
            ("0.0/0.0", Failure::NotFinite),
            ("1.0/0.0", Failure::NotFinite),
            ("-1.0/0.0", Failure::NotFinite),
        ] {
            let source = format!("print(trunc<{ty}>({value}));");
            let RunError::Execution(error) = run_vm(&source).unwrap_err() else {
                panic!()
            };
            let VmErrorKind::NumericConversionFailed { reason, .. } = error.vm_error().kind()
            else {
                panic!()
            };
            assert_eq!(reason, expected, "{source}");
        }
    }
}
