//! IRの値。集約値は独立したコピー、不変文字列の内容だけは共有します。
use super::{Fault, Result};
use crate::{
    ir::{self, BinaryOp as B, UnaryOp as U},
    runtime::{
        FailureCode as Code,
        numeric::{self, Number},
        string_heap::StringValue,
    },
    types::{IntegerType, NumericType},
};

#[derive(Debug, Clone)]
pub(super) enum Value {
    DynamicArray {
        element: ir::Type,
        storage: crate::runtime::array_heap::ArrayValue<Value>,
    },
    Bool(bool),
    String(StringValue),
    Number(Number),
    Aggregate {
        type_id: ir::TypeId,
        fields: Vec<Value>,
    },
    Array {
        element: ir::Type,
        values: Vec<Value>,
    },
}
impl Value {
    pub(super) fn ty(&self) -> ir::Type {
        match self {
            Self::DynamicArray { element, .. } => ir::Type::DynamicArray {
                element: Box::new(element.clone()),
            },
            Self::Bool(_) => ir::Type::Bool,
            Self::String(_) => ir::Type::String,
            Self::Number(Number::Integer(_, t)) => ir::Type::Integer(*t),
            Self::Number(Number::F32(_)) => ir::Type::F32,
            Self::Number(Number::F64(_)) => ir::Type::F64,
            Self::Aggregate { type_id, .. } => ir::Type::Named(*type_id),
            Self::Array { element, values } => ir::Type::Array {
                element: Box::new(element.clone()),
                length: values.len(),
            },
        }
    }
    pub(super) fn check(&self, ty: &ir::Type) -> Result<()> {
        if &self.ty() == ty {
            Ok(())
        } else {
            Err(Fault::invalid("value does not match the IR type"))
        }
    }
    pub(super) fn boolean(self) -> Result<bool> {
        if let Self::Bool(v) = self {
            Ok(v)
        } else {
            Err(Fault::invalid("expected bool"))
        }
    }
    pub(super) fn integer(self, ty: IntegerType) -> Result<i128> {
        if let Self::Number(Number::Integer(v, t)) = self
            && t == ty
            && t.contains(v)
        {
            Ok(v)
        } else {
            Err(Fault::invalid("expected a valid integer"))
        }
    }
    pub(super) fn string(self) -> Result<StringValue> {
        if let Self::String(v) = self {
            Ok(v)
        } else {
            Err(Fault::invalid("expected string"))
        }
    }
    pub(super) fn text(self) -> Result<String> {
        Ok(match self {
            Self::Bool(v) => v.to_string(),
            Self::String(v) => v.text(),
            Self::Number(Number::Integer(v, _)) => v.to_string(),
            Self::Number(Number::F32(v)) => crate::runtime::float_output::f32(v),
            Self::Number(Number::F64(v)) => crate::runtime::float_output::f64(v),
            _ => {
                return Err(Fault::invalid(
                    "aggregate display must use common IR expansion",
                ));
            }
        })
    }
    pub(super) fn number(self) -> Result<Number> {
        if let Self::Number(v) = self {
            Ok(v)
        } else {
            Err(Fault::invalid("expected numeric value"))
        }
    }
}

pub(super) fn numeric_error(error: numeric::Error) -> Fault {
    use numeric::NumericConversionFailure as N;
    match error {
        numeric::Error::NumericConversionFailed { reason, .. } => Fault::failure(match reason {
            N::OutOfRange => Code::ConversionOutOfRange,
            N::Inexact => Code::ConversionInexact,
            N::NotFinite => Code::ConversionNotFinite,
            N::NaN => Code::ConversionNaN,
            N::NegativeZero => Code::ConversionNegativeZero,
        }),
        _ => Fault::invalid("invalid numeric conversion in IR"),
    }
}

pub(super) fn unary(op: U, value: Value) -> Result<Value> {
    match (op, value) {
        (U::Not, Value::Bool(v)) => Ok(Value::Bool(!v)),
        (U::BitNot, Value::Number(Number::Integer(v, t))) => Ok(Value::Number(Number::Integer(
            v ^ if t.is_signed() { -1 } else { t.maximum() },
            t,
        ))),
        (U::Negate, Value::Number(Number::Integer(v, t))) if t.is_signed() => {
            if !t.contains(-v) {
                return Err(Fault::failure(Code::IntegerOverflow));
            }
            Ok(Value::Number(Number::Integer(-v, t)))
        }
        (U::Negate, Value::Number(Number::F32(v))) => Ok(Value::Number(Number::F32(-v))),
        (U::Negate, Value::Number(Number::F64(v))) => Ok(Value::Number(Number::F64(-v))),
        _ => Err(Fault::invalid("invalid unary operator for this type")),
    }
}

pub(super) fn binary(op: B, left: Value, right: Value) -> Result<Value> {
    right.check(&left.ty())?;
    let comparison = matches!(
        op,
        B::Equal | B::NotEqual | B::Less | B::LessEqual | B::Greater | B::GreaterEqual
    );
    match (left, right) {
        (Value::Bool(a), Value::Bool(b)) if matches!(op, B::Equal | B::NotEqual) => {
            Ok(Value::Bool(compare(op, a, b)?))
        }
        (Value::String(a), Value::String(b)) if matches!(op, B::Equal | B::NotEqual) => {
            Ok(Value::Bool(if op == B::Equal { a == b } else { a != b }))
        }
        (Value::Number(Number::Integer(a, t)), Value::Number(Number::Integer(b, _))) => {
            if comparison {
                return Ok(Value::Bool(compare(op, a, b)?));
            }
            if matches!(op, B::ShiftLeft | B::ShiftRight)
                && (b < 0 || b >= i128::from(t.bit_width()))
            {
                return Err(Fault::failure(Code::InvalidShiftCount));
            }
            let result = match op {
                B::Add => a.checked_add(b),
                B::Subtract => a.checked_sub(b),
                B::Multiply => a.checked_mul(b),
                B::Divide => {
                    if b == 0 {
                        return Err(Fault::failure(Code::DivisionByZero));
                    }
                    let result = a / b;
                    if !t.contains(result) {
                        return Err(Fault::failure(Code::DivisionOverflow));
                    }
                    Some(result)
                }
                B::Remainder => {
                    if b == 0 {
                        return Err(Fault::failure(Code::RemainderByZero));
                    }
                    Some(a % b)
                }
                B::BitAnd => Some(a & b),
                B::BitOr => Some(a | b),
                B::BitXor => Some(a ^ b),
                B::ShiftLeft => Some(a << b),
                B::ShiftRight => Some(a >> b),
                _ => return Err(Fault::invalid("invalid integer operator")),
            }
            .filter(|v| t.contains(*v))
            .ok_or_else(|| Fault::failure(Code::IntegerOverflow))?;
            Ok(Value::Number(Number::Integer(result, t)))
        }
        (Value::Number(Number::F32(a)), Value::Number(Number::F32(b))) => {
            if comparison {
                return Ok(Value::Bool(compare(op, a, b)?));
            }
            Ok(Value::Number(Number::F32(match op {
                B::Add => a + b,
                B::Subtract => a - b,
                B::Multiply => a * b,
                B::Divide => a / b,
                _ => return Err(Fault::invalid("invalid floating-point operator")),
            })))
        }
        (Value::Number(Number::F64(a)), Value::Number(Number::F64(b))) => {
            if comparison {
                return Ok(Value::Bool(compare(op, a, b)?));
            }
            Ok(Value::Number(Number::F64(match op {
                B::Add => a + b,
                B::Subtract => a - b,
                B::Multiply => a * b,
                B::Divide => a / b,
                _ => return Err(Fault::invalid("invalid floating-point operator")),
            })))
        }
        _ => Err(Fault::invalid("invalid binary operator for this type")),
    }
}
fn compare<T: PartialEq + PartialOrd>(op: B, a: T, b: T) -> Result<bool> {
    Ok(match op {
        B::Equal => a == b,
        B::NotEqual => a != b,
        B::Less => a < b,
        B::LessEqual => a <= b,
        B::Greater => a > b,
        B::GreaterEqual => a >= b,
        _ => return Err(Fault::invalid("expected comparison")),
    })
}
pub(super) fn numeric_type(ty: &ir::Type) -> Option<NumericType> {
    match ty {
        ir::Type::Integer(t) => Some(NumericType::Integer(*t)),
        ir::Type::F32 => Some(NumericType::F32),
        ir::Type::F64 => Some(NumericType::F64),
        _ => None,
    }
}
