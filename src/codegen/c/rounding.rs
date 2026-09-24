use super::conversion::type_name;
use crate::{
    codegen::NumericConversion,
    types::{IntegerType, NumericType, RoundingMode},
};
use std::fmt::Write;

fn integer(value: i128, ty: IntegerType) -> String {
    if ty == IntegerType::U64 {
        format!("UINT64_C({value})")
    } else if value == i64::MIN as i128 {
        "(-INT64_C(9223372036854775807) - INT64_C(1))".into()
    } else {
        format!("INT64_C({value})")
    }
}

pub(super) fn emit(c: NumericConversion, output: &mut String) {
    let NumericType::Integer(ty) = c.to else {
        unreachable!()
    };
    let min = integer(ty.minimum(), ty);
    let max = integer(ty.maximum(), ty);
    let result = type_name(c.to);
    writeln!(output, "static {result} {}({} value, const char *origin) {{\n    /* policy: {} */\n    double number = (double)value;", c.helper(), type_name(c.from), c.mode.name()).unwrap();
    if c.mode.saturates() {
        writeln!(output, "    (void)origin;\n    if (isnan(number)) return 0;\n    if (isinf(number)) return number > 0.0 ? {max} : {min};").unwrap();
    } else {
        output.push_str(
            "    if (!isfinite(number)) cerune_runtime_fail(\"conversion-not-finite\", origin);\n",
        );
    }
    // |x| >= 2^52の有限f64は整数です。小さい入力だけ安全なi64変換で整数部を求めます。
    output.push_str("    /* round finite input; values at or beyond 2^52 are integral */\n    if (number > -4503599627370496.0 && number < 4503599627370496.0) {\n        int64_t whole = (int64_t)number;\n");
    if c.mode.rounding() != Some(RoundingMode::Truncate) {
        output.push_str("        double fraction = number - (double)whole;\n");
        let (up, down) = match c.mode.rounding().unwrap() {
            RoundingMode::Floor => ("0", "fraction < 0.0"),
            RoundingMode::Ceil => ("fraction > 0.0", "0"),
            RoundingMode::Round => ("fraction >= 0.5", "fraction <= -0.5"),
            RoundingMode::TiesEven => (
                "fraction > 0.5 || (fraction == 0.5 && whole % 2 != 0)",
                "fraction < -0.5 || (fraction == -0.5 && whole % 2 != 0)",
            ),
            RoundingMode::Truncate => unreachable!(),
        };
        writeln!(output, "        int64_t delta = (({up}) ? 1 : 0) - (({down}) ? 1 : 0);\n        whole += delta;").unwrap();
        // 偶数判定は変更前の整数部に対して行います。正負の半端は同時には成立しません。
    }
    output.push_str("        number = (double)whole;\n    }\n    /* apply range policy after rounding, then convert */\n");
    if c.mode.saturates() {
        writeln!(
            output,
            "    if (number < {}.0) return {min};\n    if (number >= {}.0) return {max};",
            ty.minimum(),
            ty.maximum() + 1
        )
        .unwrap();
    } else {
        writeln!(output, "    if (number < {}.0 || number >= {}.0) cerune_runtime_fail(\"conversion-out-of-range\", origin);", ty.minimum(), ty.maximum() + 1).unwrap();
    }
    writeln!(output, "    return ({result})number;\n}}\n").unwrap();
}
