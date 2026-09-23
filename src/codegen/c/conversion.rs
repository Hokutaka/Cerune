use crate::{codegen::NumericConversion, types::NumericType};
use std::fmt::Write;

pub(super) fn type_name(ty: NumericType) -> &'static str {
    match ty {
        NumericType::Integer(crate::types::IntegerType::U64) => "uint64_t",
        NumericType::Integer(_) => "int64_t",
        NumericType::F32 => "float",
        NumericType::F64 => "double",
    }
}

fn emit_truncation(conversion: NumericConversion, output: &mut String) {
    let NumericType::Integer(ty) = conversion.to else {
        unreachable!()
    };
    let (lower, exclusive) = conversion.integer_lower_bound();
    let compare = if exclusive { "<=" } else { "<" };
    let result = type_name(conversion.to);
    writeln!(
        output,
        "static {result} {}({} value, const char *origin) {{",
        conversion.helper(),
        type_name(conversion.from)
    )
    .unwrap();
    output.push_str("    double number = (double)value;\n    if (!isfinite(number)) cerune_runtime_fail(\"conversion-not-finite\", origin);\n");
    writeln!(output, "    if (number {compare} {lower}.0 || number >= {}.0) cerune_runtime_fail(\"conversion-out-of-range\", origin);\n    return ({result})number;\n}}\n", ty.maximum() + 1).unwrap();
}

pub(super) fn emit_support(conversion: NumericConversion, output: &mut String) {
    if conversion.truncates() {
        return emit_truncation(conversion, output);
    }
    if conversion.uses_u64() {
        return super::unsigned::emit_conversion(conversion, output);
    }
    let NumericConversion { from, to, .. } = conversion;
    writeln!(
        output,
        "static {} {}({} value, const char *origin) {{",
        type_name(to),
        conversion.helper(),
        type_name(from)
    )
    .unwrap();
    match (from, to) {
        (NumericType::Integer(_), NumericType::F32 | NumericType::F64) => {
            writeln!(
                output,
                "    {} result = ({})value;",
                type_name(to),
                type_name(to)
            )
            .unwrap();
            // 範囲検査を先に行い、Cの範囲外float-to-int変換を実行しません。
            output.push_str("    double number = (double)result;\n    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail(\"conversion-inexact\", origin);\n    if ((int64_t)number != value) cerune_runtime_fail(\"conversion-inexact\", origin);\n    return result;\n");
        }
        (NumericType::F32 | NumericType::F64, NumericType::Integer(ty)) => {
            output.push_str("    double number = (double)value;\n    if (!isfinite(number)) cerune_runtime_fail(\"conversion-not-finite\", origin);\n    if (number == 0.0 && signbit(number)) cerune_runtime_fail(\"conversion-negative-zero\", origin);\n");
            writeln!(
                output,
                "    if (number < {}.0 || number >= {}.0) cerune_runtime_fail(\"conversion-out-of-range\", origin);",
                ty.minimum(),
                ty.maximum() + 1
            )
            .unwrap();
            output.push_str("    int64_t result = (int64_t)number;\n    if ((double)result != number) cerune_runtime_fail(\"conversion-inexact\", origin);\n    return result;\n");
        }
        (NumericType::F32, NumericType::F64) => {
            output.push_str("    if (isnan(value)) cerune_runtime_fail(\"conversion-nan\", origin);\n    return (double)value;\n");
        }
        (NumericType::F64, NumericType::F32) => {
            output.push_str("    if (isnan(value)) cerune_runtime_fail(\"conversion-nan\", origin);\n    if (isinf(value)) return signbit(value) ? -INFINITY : INFINITY;\n    if (value > (double)FLT_MAX || value < -(double)FLT_MAX) cerune_runtime_fail(\"conversion-out-of-range\", origin);\n    float result = (float)value;\n    if ((double)result != value) cerune_runtime_fail(\"conversion-inexact\", origin);\n    return result;\n");
        }
        _ => unreachable!("integer and identity conversions use separate lowering"),
    }
    output.push_str("}\n\n");
}
