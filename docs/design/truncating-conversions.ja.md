# 小数部分を切り捨てる変換

[English](truncating-conversions.en.md)

`trunc<T>(value)`は、浮動小数点から整数へ小数部分を捨てることをソースで指定する操作です。`convert<T>`・`T(value)`は引き続き値を正確に保持します。暗黙の変換や、実行環境によって変わる丸め方は追加しません。

## 契約

- 入力は`f32`・`f64`、変換先は全8整数型。整数入力・浮動小数点の変換先はコンパイル時に拒否します。
- 入力式を一度だけ評価し、有限性を検査してからゼロ方向に切り捨て、整数の範囲を検査します。
- `-3.7 → -3`、`-0.9 → 0`、`-0.0 → 0`。負数を下へ丸めるfloorとは異なります。
- `255.9 → u8の255`、`-128.9 → i8の-128`は成功します。検査するのは切り捨て後の範囲です。
- NaN・正負の無限大は`conversion-not-finite`、範囲外は`conversion-out-of-range`。停止理由・ソース位置・先行出力を残します。
- 浮動小数点リテラルや計算は従来の精度です。切り捨ての入力は既に評価された値であり、数学上の無限精度の値ではありません。

定数評価と型引数付き関数も同じ規則です。評価順・短絡評価・配列コピーの独立性は変えません。他の丸め方と飽和は[丸め変換](rounding-conversions.ja.md)を参照してください。整数の下位ビット切り出しは別の候補です。

## 表現と生成

ASTから`ConversionMode::Exact`または`Rounded { rounding: Truncate, overflow: Checked }`を保持します。ソースの書式`ConversionSyntax`とは分け、IR・bytecodeには`convert.exact` / `convert.trunc`が残ります。各backendも型と方針を受け取り、ソース構文を解釈し直しません。

VMは切り捨て後に範囲を調べます。生成先では、変換前の浮動小数点比較で同じ判定をします。上限は常に`最大値+1`未満です。下限は通常`最小値-1`より大きい値を許可し、`i64`だけは表現可能な最小値以上を許可します。`i64最小値-1`は`f64`で区別できず、その間に表せる値がないためです。`f32`入力は正確に`f64`へ広げて検査します。

この事前検査で、Cの範囲外キャスト、LLVMのpoison、Wasmの組み込みtrapが言語の診断を置き換えることを防ぎます。Cのfloat→整数変換の範囲は[C11草案 6.3.1.4](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf)、LLVMのゼロ方向変換と範囲外の扱いは[LangRef](https://llvm.org/docs/LangRef.html#fptoui-to-instruction)に従います。

Cは検査後のcast、LLVMは`fptosi/fptoui`、QBEは`dtosi/dtoui`、WATは`i64.trunc_f64_s/u`、ASMと自前エンコーダはSSE2の変換を使います。x86の`u64`上半分は`2^63`を引いて符号付き変換し、最上位ビットを戻します。OS・ターゲットの指定方法は既存のままです。

## 確認例

| 例・テスト | 確認内容 |
| --- | --- |
| [truncating_conversions.ceru](../../examples/truncating_conversions.ceru) | 正負・境界・u64・正確な変換との併用・定数・型引数 |
| [truncating_evaluation_order.ceru](../../examples/truncating_evaluation_order.ceru) | 一度だけの評価、短絡、コピー |
| [共通の値テスト](../../tests/support/truncation_cases.rs) | 両float型→全整数型と境界を全経路で比較 |
| [共通の停止テスト](../../tests/support/runtime_cases.rs) | 範囲・NaN・無限大、停止前の出力と出自 |
| [観測fixture](../../tests/fixtures/observation/truncating-conversions/source.ceru) | IR・bytecode・C・LLVM・QBE・WAT・ASMとVM出力 |
