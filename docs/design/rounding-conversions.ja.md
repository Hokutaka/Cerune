# 丸め方と飽和を明示する整数変換

[English](rounding-conversions.en.md)

浮動小数点から整数へ変換するときの丸め方と、範囲外の扱いを利用者が選びます。`convert<T>`・`T(value)`は正確な変換として残します。計算結果に加えて、元の式・選択した方針・生成手順を追えることを実装の条件とします。

## 操作

入力は`f32`・`f64`、変換先`T`は全8整数型です。整数入力や浮動小数点の変換先はコンパイルエラーです。

| 丸め方 | 範囲外なら停止 | 型の端へ飽和 | `2.5` / `-2.5` |
| --- | --- | --- | --- |
| ゼロ方向 | `trunc<T>(x)` | `saturating_trunc<T>(x)` | 2 / -2 |
| 小さい整数へ | `floor<T>(x)` | `saturating_floor<T>(x)` | 2 / -3 |
| 大きい整数へ | `ceil<T>(x)` | `saturating_ceil<T>(x)` | 3 / -2 |
| 最寄り。同距離ならゼロから遠い方 | `round<T>(x)` | `saturating_round<T>(x)` | 3 / -3 |
| 最寄り。同距離なら偶数の方 | `round_ties_even<T>(x)` | `saturating_round_ties_even<T>(x)` | 2 / -2 |

丸めの数値規則と名前は[Rustの浮動小数点関数](https://doc.rust-lang.org/std/primitive.f64.html#method.round)を基準にします。ただしRustのこれらの関数は浮動小数点を返し、Ceruneの`<T>`付き操作は整数への変換です。`round`の意味が全言語で共通だという主張ではありません。

入力を一度だけ評価し、その時点の浮動小数点値を丸めます。リテラルや先行する演算の丸めを取り消すことはありません。引数の評価順・短絡評価・値コピーは従来どおりです。定数・型引数付き関数でも使用できます。操作名はキーワードにせず、通常の呼び出し`floor(x)`、比較`floor < limit`、ユーザー定義の`floor::<T>(x)`と区別します。

## 範囲と特殊値

範囲検査・飽和は丸めた後の値に対して行います。

| 入力 | 通常の丸め変換 | `saturating_`付き |
| --- | --- | --- |
| 有限で、丸めた結果が範囲内 | その整数 | その整数 |
| 丸めた結果が下限未満／上限超過 | `conversion-out-of-range`で停止 | 最小値／最大値 |
| NaN | `conversion-not-finite`で停止 | 0 |
| 正の無限大／負の無限大 | `conversion-not-finite`で停止 | 最大値／最小値 |
| 正負のゼロ | 0 | 0 |

飽和時の特殊値は[Rustのfloat→integer変換](https://doc.rust-lang.org/reference/expressions/operator-expr.html#numeric-cast)に合わせます。符号なし型の最小値は0です。整数のビット切り詰めや浮動小数点型の幅を変える丸めは、この操作には含めません。

例えば`ceil<u8>(-0.9)`は0、`floor<u8>(-0.1)`は範囲外です。`round_ties_even<i8>(-128.5)`は-128ですが、`round<i8>(-128.5)`は-129となり範囲外です。`saturating_round<i8>(-128.5)`なら-128です。入力式が先に失敗した場合は、その式の理由と位置で停止し、飽和によって失敗を隠しません。

## 生成過程の観測

| 段階 | 保持する内容 |
| --- | --- |
| AST・Cerune IR | `ConversionMode::Rounded { rounding, overflow }`、変換前後の型、元の書式・式・ソース位置 |
| IRテキスト | `convert.floor.f64->i64`、`convert.saturating_floor.f64->i64`などの方針とNodeId |
| bytecode | 同じ方針・型、対応するIRのNodeIdとSpan |
| 定数評価 | IRの`const`定義に元の初期化式と評価済みの値を併記 |
| backend IR・生成コード | 方針付きの変換、丸め・範囲検査／飽和・整数化の命令または補助関数 |
| LLVM・ASMの出自注釈 | 呼び出し元の式から生成命令を辿る注釈。自前エンコーダのオブジェクトにも出自シンボルを保持 |
| 実行時停止 | 理由・元の式の位置・停止前出力を全経路で比較 |

単に実行結果が同じだけでは完了にしません。[観測fixture](../../tests/fixtures/observation/rounding-conversions/source.ceru)には、IR・bytecode・全テキスト生成先・注釈付きLLVM・両OSのASMを保存します。飽和は通常の値を返す操作であり、分岐を通った回数などの実行時トレースは追加しません。

## 生成する手順

C・LLVM・QBE・ASMでは、非有限値を処理した後、有限な`|x| < 2^52`の入力を安全に`i64`へ切り捨てます。整数部を正確に`f64`へ戻して小数部分を求め、指定に応じて整数部を0・+1・-1だけ調整します。偶数丸めでは変更前の整数部の偶奇を使います。`|x| >= 2^52`の有限f64は既に整数なので、丸めを省略できます。`f32`は先に正確に`f64`へ広げます。

`floor(x + 0.5)`のような実装は使いません。`0.5`直前の値が加算時に丸められたり、負数の規則が変わるためです。上の分解は必要な浮動小数点計算が正確に表現でき、ホストの丸めモードに方針を委ねません。WATは`floor`・`ceil`・`trunc`・`nearest`命令を使い、`round`だけ小数部分の比較へ分解します。

既存の検査付き`trunc`は、切り捨て後の範囲判定と等価な入力境界を先に検査し、そのまま整数化する生成手順を保ちます。[切り捨て変換の設計](truncating-conversions.ja.md)に境界の導出を記載しています。

丸め後は`最小値 <= x < 最大値+1`を検査します。上限を含まない比較にすることで、`i64`・`u64`の最大値が浮動小数点で上へ丸められる問題を避けます。飽和時の端の値は整数定数から返します。Cの範囲外cast、LLVMのpoison、Wasmの組み込みtrapへ到達する前に言語の方針を適用します。x86-64は既存のSSE2命令で生成し、自前エンコーダでも同じ手順を使います。

ここで観測する生成物はCeruneが外部コンパイラへ渡す前のものです。外部の最適化で命令が削除・統合された後は、注釈が一対一に残ることを保証しません。C・LLVMは最適化前後の実行結果も比較します。

## 試す

```sh
cargo run --quiet -- run examples/rounding_quantities.ceru
cargo run --quiet -- emit-ir examples/rounding_quantities.ceru
cargo run --quiet -- emit-bytecode examples/rounding_conversions.ceru
cargo run --quiet -- emit-c examples/rounding_conversions.ceru
cargo run --quiet -- emit-llvm examples/rounding_conversions.ceru --target x86_64-unknown-linux-gnu --annotate-origins
cargo run --quiet -- emit-asm examples/rounding_conversions.ceru --target x86_64-pc-windows-msvc --annotate-origins
```

[丸め方の比較](../../examples/rounding_conversions.ceru)・[区画と必要数](../../examples/rounding_quantities.ceru)・[飽和](../../examples/saturating_conversions.ceru)・[評価順とコピー](../../examples/rounding_evaluation_order.ceru)を、VM・C・LLVM・QBE・WAT・Windows/Linux ASM・自前エンコーダで照合します。
