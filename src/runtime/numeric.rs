use crate::types::NumericType;

use crate::types::IntegerType;
#[derive(Debug, Clone, Copy)]
pub(crate) enum Number {
    Integer(i128, IntegerType),
    F32(f32),
    F64(f64),
}
impl Number {
    pub(crate) fn ty(self) -> NumericType {
        match self {
            Self::Integer(_, t) => NumericType::Integer(t),
            Self::F32(_) => NumericType::F32,
            Self::F64(_) => NumericType::F64,
        }
    }
}
#[derive(Debug, Clone, Copy)]
pub(crate) enum Error {
    TypeMismatch {
        expected: NumericType,
        actual: NumericType,
    },
    InvalidNumericConversion {
        from: NumericType,
        to: NumericType,
    },
    NumericConversionFailed {
        from: NumericType,
        to: NumericType,
        reason: NumericConversionFailure,
    },
}
type NumericResult<T> = Result<T, Error>;

/// 変換先の型と、数値を保てなかった理由を分けて記録します。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum NumericConversionFailure {
    OutOfRange,
    Inexact,
    NotFinite,
    NaN,
    NegativeZero,
}

pub(crate) fn convert_with_mode(
    value: Number,
    from: NumericType,
    to: NumericType,
    mode: crate::types::ConversionMode,
) -> NumericResult<Number> {
    if mode == crate::types::ConversionMode::Exact {
        return convert(value, from, to);
    }
    if !matches!(from, NumericType::F32 | NumericType::F64)
        || !matches!(to, NumericType::Integer(_))
    {
        return Err(Error::InvalidNumericConversion { from, to });
    }
    if value.ty() != from {
        return Err(Error::TypeMismatch {
            expected: from,
            actual: value.ty(),
        });
    }
    let number = match value {
        Number::F32(n) => f64::from(n),
        Number::F64(n) => n,
        _ => unreachable!(),
    };
    let NumericType::Integer(ty) = to else {
        unreachable!()
    };
    let fail = |reason| Error::NumericConversionFailed { from, to, reason };
    if !number.is_finite() {
        if mode.saturates() {
            let result = if number.is_nan() {
                0
            } else if number.is_sign_positive() {
                ty.maximum()
            } else {
                ty.minimum()
            };
            return Ok(Number::Integer(result, ty));
        }
        return Err(fail(NumericConversionFailure::NotFinite));
    }
    use crate::types::RoundingMode;
    let number = match mode.rounding().unwrap() {
        RoundingMode::Truncate => number.trunc(),
        RoundingMode::Floor => number.floor(),
        RoundingMode::Ceil => number.ceil(),
        RoundingMode::Round => number.round(),
        RoundingMode::TiesEven => number.round_ties_even(),
    };
    if mode.saturates() {
        return Ok(Number::Integer(
            (number as i128).clamp(ty.minimum(), ty.maximum()),
            ty,
        ));
    }
    if number < ty.minimum() as f64 || number >= (ty.maximum() + 1) as f64 {
        return Err(fail(NumericConversionFailure::OutOfRange));
    }
    Ok(Number::Integer(number as i128, ty))
}

pub(crate) fn convert(value: Number, from: NumericType, to: NumericType) -> NumericResult<Number> {
    if value.ty() != from {
        return Err(Error::TypeMismatch {
            expected: from,
            actual: value.ty(),
        });
    }
    if from == to {
        return Ok(value);
    }
    let fail = |reason| Error::NumericConversionFailed { from, to, reason };
    match value {
        Number::Integer(value, _) => {
            let (result, number) = match to {
                NumericType::Integer(ty) => {
                    if !ty.contains(value) {
                        return Err(fail(NumericConversionFailure::OutOfRange));
                    }
                    return Ok(Number::Integer(value, ty));
                }
                NumericType::F32 => {
                    let result = value as f32;
                    (Number::F32(result), f64::from(result))
                }
                NumericType::F64 => {
                    let result = value as f64;
                    (Number::F64(result), result)
                }
            };
            // i64最大値は浮動小数点では2^63へ丸められます。i64へ戻す比較では見逃します。
            if number as i128 != value {
                return Err(fail(NumericConversionFailure::Inexact));
            }
            Ok(result)
        }
        Number::F32(_) | Number::F64(_) => {
            let number = match value {
                Number::F32(value) => f64::from(value),
                Number::F64(value) => value,
                _ => unreachable!(),
            };
            match to {
                NumericType::Integer(ty) => {
                    if !number.is_finite() {
                        return Err(fail(NumericConversionFailure::NotFinite));
                    }
                    if number == 0.0 && number.is_sign_negative() {
                        return Err(fail(NumericConversionFailure::NegativeZero));
                    }
                    // 上限は含まない境界にします。i64最大値をf64で比較すると上へ丸められるためです。
                    let upper = (ty.maximum() + 1) as f64;
                    if number < ty.minimum() as f64 || number >= upper {
                        return Err(fail(NumericConversionFailure::OutOfRange));
                    }
                    if number.trunc() != number {
                        return Err(fail(NumericConversionFailure::Inexact));
                    }
                    Ok(Number::Integer(number as i128, ty))
                }
                NumericType::F32 => {
                    if number.is_nan() {
                        return Err(fail(NumericConversionFailure::NaN));
                    }
                    if number.is_finite() && number.abs() > f64::from(f32::MAX) {
                        return Err(fail(NumericConversionFailure::OutOfRange));
                    }
                    let result = number as f32;
                    if f64::from(result) != number {
                        return Err(fail(NumericConversionFailure::Inexact));
                    }
                    Ok(Number::F32(result))
                }
                NumericType::F64 => {
                    if number.is_nan() {
                        return Err(fail(NumericConversionFailure::NaN));
                    }
                    Ok(Number::F64(number))
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn identity_preserves_nan_payloads_and_signed_zero_bits() {
        for bits in [0, 0x80000000, 0x7fc01234, 0xffc01234, 0x7f801234] {
            let Number::F32(result) = convert(
                Number::F32(f32::from_bits(bits)),
                NumericType::F32,
                NumericType::F32,
            )
            .unwrap() else {
                panic!()
            };
            assert_eq!(result.to_bits(), bits);
        }
        for bits in [
            0,
            0x8000000000000000,
            0x7ff8000000001234,
            0xfff8000000001234,
            0x7ff0000000001234,
        ] {
            let Number::F64(result) = convert(
                Number::F64(f64::from_bits(bits)),
                NumericType::F64,
                NumericType::F64,
            )
            .unwrap() else {
                panic!()
            };
            assert_eq!(result.to_bits(), bits);
        }
    }

    #[test]
    fn exact_float_width_changes_preserve_subnormals_and_special_value_signs() {
        for value in [
            f32::from_bits(1),
            -f32::from_bits(1),
            f32::MIN_POSITIVE,
            f32::MAX,
            -f32::MAX,
            0.0,
            -0.0,
            f32::INFINITY,
            f32::NEG_INFINITY,
        ] {
            let Number::F64(wide) =
                convert(Number::F32(value), NumericType::F32, NumericType::F64).unwrap()
            else {
                panic!()
            };
            assert_eq!(wide.to_bits(), f64::from(value).to_bits());
            let Number::F32(back) =
                convert(Number::F64(wide), NumericType::F64, NumericType::F32).unwrap()
            else {
                panic!()
            };
            assert_eq!(back.to_bits(), value.to_bits());
        }
    }
}
