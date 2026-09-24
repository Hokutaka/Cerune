use super::{
    conversion::{type_name, widen},
    failure::emit_trap,
};
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
        "define internal i64 @{}({} %value, ptr %failure) {{\nentry:\n  ; policy: {}",
        c.helper(),
        type_name(c.from),
        c.mode.name()
    )
    .unwrap();
    let input = widen(c.from, output);
    writeln!(output, "  %bits = bitcast double {input} to i64\n  %magnitude = and i64 %bits, 9223372036854775807\n  %nonfinite = icmp uge i64 %magnitude, 9218868437227405312\n  br i1 %nonfinite, label %nonfinite_input, label %finite\nnonfinite_input:").unwrap();
    if c.mode.saturates() {
        writeln!(output, "  %nan = fcmp uno double {input}, {input}\n  %positive = fcmp ogt double {input}, 0.0\n  %endpoint = select i1 %positive, i64 {}, i64 {}\n  %special = select i1 %nan, i64 0, i64 %endpoint\n  ret i64 %special", ty.maximum() as i64, ty.minimum()).unwrap();
    } else {
        emit_trap(FailureCode::ConversionNotFinite, output);
    }
    writeln!(output, "finite:\n  ; round finite input; large values are already integral\n  %large_pos = fcmp oge double {input}, 0x4330000000000000\n  %large_neg = fcmp ole double {input}, 0xC330000000000000\n  %large = or i1 %large_pos, %large_neg\n  br i1 %large, label %bounds, label %round\nround:\n  %whole = fptosi double {input} to i64\n  %base = sitofp i64 %whole to double").unwrap();
    let rounding = c.mode.rounding().unwrap();
    if rounding == RoundingMode::Truncate {
        output.push_str("  br label %bounds\nbounds:\n");
    } else {
        writeln!(output, "  %fraction = fsub double {input}, %base").unwrap();
        match rounding {
            RoundingMode::Floor => output.push_str("  %up = icmp ne i64 0, 0\n  %down = fcmp olt double %fraction, 0.0\n"),
            RoundingMode::Ceil => output.push_str("  %up = fcmp ogt double %fraction, 0.0\n  %down = icmp ne i64 0, 0\n"),
            RoundingMode::Round => output.push_str("  %up = fcmp oge double %fraction, 0.5\n  %down = fcmp ole double %fraction, -0.5\n"),
            RoundingMode::TiesEven => output.push_str("  %low_bit = and i64 %whole, 1\n  %odd = icmp ne i64 %low_bit, 0\n  %above_half = fcmp ogt double %fraction, 0.5\n  %at_half = fcmp oeq double %fraction, 0.5\n  %up_tie = and i1 %at_half, %odd\n  %up = or i1 %above_half, %up_tie\n  %below_half = fcmp olt double %fraction, -0.5\n  %at_negative_half = fcmp oeq double %fraction, -0.5\n  %down_tie = and i1 %at_negative_half, %odd\n  %down = or i1 %below_half, %down_tie\n"),
            RoundingMode::Truncate => unreachable!(),
        }
        output.push_str("  %up64 = zext i1 %up to i64\n  %down64 = zext i1 %down to i64\n  %delta = sub i64 %up64, %down64\n  %adjusted = add i64 %whole, %delta\n  %small_result = sitofp i64 %adjusted to double\n  br label %bounds\nbounds:\n");
    }
    let small = if rounding == RoundingMode::Truncate {
        "%base"
    } else {
        "%small_result"
    };
    writeln!(output, "  ; range policy after rounding\n  %rounded = phi double [ {input}, %finite ], [ {small}, %round ]\n  %below = fcmp olt double %rounded, 0x{:016X}\n  %above = fcmp oge double %rounded, 0x{:016X}", (ty.minimum() as f64).to_bits(), ((ty.maximum()+1) as f64).to_bits()).unwrap();
    if c.mode.saturates() {
        writeln!(output, "  br i1 %below, label %minimum, label %upper\nminimum:\n  ret i64 {}\nupper:\n  br i1 %above, label %maximum, label %convert\nmaximum:\n  ret i64 {}", ty.minimum(), ty.maximum() as i64).unwrap();
    } else {
        output.push_str("  %outside = or i1 %below, %above\n  br i1 %outside, label %range_failure, label %convert\nrange_failure:\n");
        emit_trap(FailureCode::ConversionOutOfRange, output);
    }
    let instruction = if ty == IntegerType::U64 {
        "fptoui"
    } else {
        "fptosi"
    };
    writeln!(
        output,
        "convert:\n  %result = {instruction} double %rounded to i64\n  ret i64 %result\n}}\n"
    )
    .unwrap();
}
