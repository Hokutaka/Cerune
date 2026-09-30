//! VMの値とエラーだけを変換し、数値変換の意味は共通部品へ委ねます。
use super::{Value, VmErrorKind, VmResult};
use crate::{
    runtime::numeric::{self, Error, Number},
    types::{ConversionMode, NumericType},
};
pub use numeric::NumericConversionFailure;
pub(super) fn convert_with_mode(
    value: Value,
    from: NumericType,
    to: NumericType,
    mode: ConversionMode,
) -> VmResult<Value> {
    if mode != ConversionMode::Exact
        && (!matches!(from, NumericType::F32 | NumericType::F64)
            || !matches!(to, NumericType::Integer(_)))
    {
        return Err(VmErrorKind::InvalidNumericConversion { from, to });
    }
    let actual = value.ty();
    if actual != from.into() {
        return Err(VmErrorKind::TypeMismatch {
            expected: from.into(),
            actual,
        });
    }
    let value = match value {
        Value::Integer(v, t) => Number::Integer(v, t),
        Value::F32(v) => Number::F32(v),
        Value::F64(v) => Number::F64(v),
        _ => unreachable!(),
    };
    numeric::convert_with_mode(value, from, to, mode)
        .map(|v| match v {
            Number::Integer(v, t) => Value::Integer(v, t),
            Number::F32(v) => Value::F32(v),
            Number::F64(v) => Value::F64(v),
        })
        .map_err(|e| match e {
            Error::TypeMismatch { expected, actual } => VmErrorKind::TypeMismatch {
                expected: expected.into(),
                actual: actual.into(),
            },
            Error::InvalidNumericConversion { from, to } => {
                VmErrorKind::InvalidNumericConversion { from, to }
            }
            Error::NumericConversionFailed { from, to, reason } => {
                VmErrorKind::NumericConversionFailed { from, to, reason }
            }
        })
}
