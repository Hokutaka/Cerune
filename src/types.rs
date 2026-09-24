/// Ceruneの整数型です。出力先のレジスタ幅や格納方法とは区別します。
///
/// 実装済みの種類だけを列挙し、種類を増やしたときに各出力先の対応漏れを検出します。
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum IntegerType {
    I8,
    U8,
    I16,
    U16,
    I32,
    U32,
    I64,
    U64,
}

impl IntegerType {
    /// 実装済みの整数型を決定的な順序で列挙します。
    pub const ALL: [Self; 8] = [
        Self::I8,
        Self::U8,
        Self::I16,
        Self::U16,
        Self::I32,
        Self::U32,
        Self::I64,
        Self::U64,
    ];

    pub fn from_name(name: &str) -> Option<Self> {
        Self::ALL.into_iter().find(|ty| ty.name() == name)
    }

    /// ソース、診断、Cerune IRで共通の型名を返します。
    pub const fn name(self) -> &'static str {
        match self {
            Self::I8 => "i8",
            Self::U8 => "u8",
            Self::I16 => "i16",
            Self::U16 => "u16",
            Self::I32 => "i32",
            Self::U32 => "u32",
            Self::I64 => "i64",
            Self::U64 => "u64",
        }
    }

    /// 負の整数を表せる型かどうかを返します。
    pub const fn is_signed(self) -> bool {
        match self {
            Self::I8 | Self::I16 | Self::I32 | Self::I64 => true,
            Self::U8 | Self::U16 | Self::U32 | Self::U64 => false,
        }
    }

    /// 値の範囲を決めるビット数です。出力先での格納サイズではありません。
    pub const fn bit_width(self) -> u8 {
        match self {
            Self::I8 | Self::U8 => 8,
            Self::I16 | Self::U16 => 16,
            Self::I32 | Self::U32 => 32,
            Self::I64 | Self::U64 => 64,
        }
    }

    /// この整数型で表せる最小値です。
    pub const fn minimum(self) -> i128 {
        match self {
            Self::I8 => i8::MIN as i128,
            Self::I16 => i16::MIN as i128,
            Self::I32 => i32::MIN as i128,
            Self::U8 | Self::U16 | Self::U32 | Self::U64 => 0,
            Self::I64 => i64::MIN as i128,
        }
    }

    /// この整数型で表せる最大値です。
    pub const fn maximum(self) -> i128 {
        match self {
            Self::I8 => i8::MAX as i128,
            Self::U8 => u8::MAX as i128,
            Self::I16 => i16::MAX as i128,
            Self::U16 => u16::MAX as i128,
            Self::I32 => i32::MAX as i128,
            Self::U32 => u32::MAX as i128,
            Self::I64 => i64::MAX as i128,
            Self::U64 => u64::MAX as i128,
        }
    }

    /// 格納用の値が、意味上の整数型の範囲に収まるか調べます。
    pub fn contains(self, value: impl Into<i128>) -> bool {
        let value = value.into();
        value >= self.minimum() && value <= self.maximum()
    }
}

/// 丸め方と範囲外の扱いは独立した指定です。ソースから各生成先まで保持します。
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum RoundingMode {
    Truncate,
    Floor,
    Ceil,
    Round,
    TiesEven,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum ConversionOverflow {
    Checked,
    Saturating,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum ConversionMode {
    Exact,
    Rounded {
        rounding: RoundingMode,
        overflow: ConversionOverflow,
    },
}
impl ConversionMode {
    pub const fn rounding(self) -> Option<RoundingMode> {
        match self {
            Self::Exact => None,
            Self::Rounded { rounding, .. } => Some(rounding),
        }
    }
    pub const fn saturates(self) -> bool {
        matches!(
            self,
            Self::Rounded {
                overflow: ConversionOverflow::Saturating,
                ..
            }
        )
    }
    pub fn from_name(name: &str) -> Option<Self> {
        if name == "convert" {
            return Some(Self::Exact);
        }
        let (name, overflow) = match name.strip_prefix("saturating_") {
            Some(name) => (name, ConversionOverflow::Saturating),
            None => (name, ConversionOverflow::Checked),
        };
        let rounding = match name {
            "trunc" => RoundingMode::Truncate,
            "floor" => RoundingMode::Floor,
            "ceil" => RoundingMode::Ceil,
            "round" => RoundingMode::Round,
            "round_ties_even" => RoundingMode::TiesEven,
            _ => return None,
        };
        Some(Self::Rounded { rounding, overflow })
    }
    pub const fn name(self) -> &'static str {
        use RoundingMode::*;
        let Self::Rounded { rounding, .. } = self else {
            return "exact";
        };
        match (rounding, self.saturates()) {
            (Truncate, false) => "trunc",
            (Floor, false) => "floor",
            (Ceil, false) => "ceil",
            (Round, false) => "round",
            (TiesEven, false) => "round_ties_even",
            (Truncate, true) => "saturating_trunc",
            (Floor, true) => "saturating_floor",
            (Ceil, true) => "saturating_ceil",
            (Round, true) => "saturating_round",
            (TiesEven, true) => "saturating_round_ties_even",
        }
    }
}

/// 数値変換で扱う型です。boolや集約型は含めません。
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum NumericType {
    Integer(IntegerType),
    F32,
    F64,
}

impl NumericType {
    pub const fn name(self) -> &'static str {
        match self {
            Self::Integer(ty) => ty.name(),
            Self::F32 => "f32",
            Self::F64 => "f64",
        }
    }
}

#[cfg(test)]
mod tests {
    use super::IntegerType;

    #[test]
    fn i64_has_a_signed_64_bit_range() {
        let ty = IntegerType::I64;

        assert_eq!(ty.name(), "i64");
        assert!(ty.is_signed());
        assert_eq!(ty.bit_width(), 64);
    }
}
