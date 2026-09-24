use super::{conversion::type_name, failure::block};
use crate::{
    codegen::NumericConversion,
    runtime::FailureCode,
    types::{IntegerType, NumericType, RoundingMode},
};
use std::fmt::Write;

pub(super) fn emit(c: NumericConversion, output: &mut String) {
    let NumericType::Integer(ty) = c.to else {
        unreachable!()
    };
    writeln!(
        output,
        "function l ${}({} %value, l %origin, l %origin_len) {{\n@start\n  # policy: {}",
        c.helper(),
        type_name(c.from),
        c.mode.name()
    )
    .unwrap();
    let input = if c.from == NumericType::F32 {
        output.push_str("  %input =d exts %value\n");
        "%input"
    } else {
        "%value"
    };
    writeln!(output, "  %bits =l cast {input}\n  %magnitude =l and %bits, 9223372036854775807\n  %nonfinite =w cugel %magnitude, 9218868437227405312\n  jnz %nonfinite, @nonfinite, @finite\n@nonfinite").unwrap();
    if c.mode.saturates() {
        writeln!(output, "  %nan =w cuod {input}, {input}\n  jnz %nan, @zero, @infinite\n@zero\n  ret 0\n@infinite\n  %positive =w cgtd {input}, d_0\n  jnz %positive, @maximum, @minimum").unwrap();
    } else {
        super::failure::call(FailureCode::ConversionNotFinite, output);
    }
    writeln!(output, "@finite\n  # round finite input; large values are already integral\n  %large_pos =w cged {input}, d_4503599627370496\n  %large_neg =w cled {input}, d_-4503599627370496\n  %large =w or %large_pos, %large_neg\n  jnz %large, @bounds, @round\n@round\n  %whole =l dtosi {input}\n  %base =d sltof %whole").unwrap();
    let rounding = c.mode.rounding().unwrap();
    if rounding != RoundingMode::Truncate {
        writeln!(output, "  %fraction =d sub {input}, %base").unwrap();
        match rounding {
            RoundingMode::Floor => output.push_str("  %up =w copy 0\n  %down =w cltd %fraction, d_0\n"),
            RoundingMode::Ceil => output.push_str("  %up =w cgtd %fraction, d_0\n  %down =w copy 0\n"),
            RoundingMode::Round => output.push_str("  %up =w cged %fraction, d_0.5\n  %down =w cled %fraction, d_-0.5\n"),
            RoundingMode::TiesEven => output.push_str("  %low_bit =l and %whole, 1\n  %odd =w cnel %low_bit, 0\n  %above_half =w cgtd %fraction, d_0.5\n  %at_half =w ceqd %fraction, d_0.5\n  %up_tie =w and %at_half, %odd\n  %up =w or %above_half, %up_tie\n  %below_half =w cltd %fraction, d_-0.5\n  %at_negative_half =w ceqd %fraction, d_-0.5\n  %down_tie =w and %at_negative_half, %odd\n  %down =w or %below_half, %down_tie\n"),
            RoundingMode::Truncate => unreachable!(),
        }
        output.push_str("  %up64 =l extuw %up\n  %down64 =l extuw %down\n  %delta =l sub %up64, %down64\n  %adjusted =l add %whole, %delta\n  %small_result =d sltof %adjusted\n");
    }
    let small = if rounding == RoundingMode::Truncate {
        "%base"
    } else {
        "%small_result"
    };
    writeln!(output, "  jmp @bounds\n@bounds\n  # range policy after rounding\n  %number =d phi @finite {input}, @round {small}\n  %below =w cltd %number, d_{}\n  %above =w cged %number, d_{}", ty.minimum(), ty.maximum()+1).unwrap();
    if c.mode.saturates() {
        writeln!(output, "  jnz %below, @minimum, @upper\n@minimum\n  ret {}\n@upper\n  jnz %above, @maximum, @convert\n@maximum\n  ret {}", ty.minimum(), ty.maximum() as i64).unwrap();
    } else {
        output.push_str(
            "  %outside =w or %below, %above\n  jnz %outside, @range_failure, @convert\n",
        );
        block("range_failure", FailureCode::ConversionOutOfRange, output);
    }
    let instruction = if ty == IntegerType::U64 {
        "dtoui"
    } else {
        "dtosi"
    };
    writeln!(
        output,
        "@convert\n  %result =l {instruction} %number\n  ret %result\n}}\n"
    )
    .unwrap();
}
