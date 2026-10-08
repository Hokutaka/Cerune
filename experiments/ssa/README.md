# SSA表現のAPI例

[English](README.en.md) · [設計](../../docs/design/mir-ssa.ja.md)

手作りのSSAを構造検証し、元MIRと並べて表示するRust API例です。CeruneソースからのSSA自動変換・SSA実行はまだありません。

```sh
cargo run --quiet --example ssa_model
cargo test --test mir_ssa
```

表示する例は次のとおりです。

| 例 | 確認すること |
| --- | --- |
| branch | 分岐の各辺から合流blockへ値を渡す |
| parallel-loop | 戻り辺で二つの値を入れ替えて渡す。未到達MIRも保持する |
| residual-slots | 配列更新の前の添字検査、文字列slot、日本語・NUL・CR/LF・非正規化の文字列 |

`parallel-loop`は構造検証用の無限loopであり、実行しません。表示だけで並列受渡しの実行が検証済みとはしません。実行可能なCeruneソースの基準例は[ssa_values.ceru](../../examples/ir_stages/ssa_values.ceru)にあります。

`vN`はSSA値、`slotN`は元MIRに残る局所領域です。`original-local`・`original-block`・`mir-iN`から元の定義を辿れます。観測テキストは`original-mir`と`ssa`を分け、未到達blockは元MIRの記録を指します。検証はsnapshotを変更せず、壊れた入力では表示も失敗します。

検査対象は定義・支配・辺の型・slotの初期化と先行する添字検査・出自対応です。演算や辺の選択が元MIRと同じ意味か、heapの寿命が安全かの証明ではありません。
