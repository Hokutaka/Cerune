/// Cerune VMの埋め込み実行で、ホストとの境界を通過する値です。
///
/// VM内部の値表現とは独立した公開型です。
/// 最初の実装では`f64`だけを扱います。
#[derive(Debug, Clone, PartialEq)]
#[non_exhaustive]
pub enum HostValue {
    F64(f64),
}
