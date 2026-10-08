# SSA変換・観測・直接実行のAPI例

[English](README.en.md) · [設計](../../docs/design/mir-ssa.ja.md)

Ceruneソースから非最適化MIRを作り、そのsnapshotを残してSSAへ変換するRust API例です。通常は観測テキストを表示し、`--run source.ceru`を明示するとSSAを直接実行します。公開CLI・bundle連携は後続です。

```sh
cargo run --quiet --example ssa_model -- examples/ir_stages/ssa_values.ceru
cargo run --quiet --example ssa_model -- examples/ir_stages/owned_values.ceru
cargo run --quiet --example ssa_model -- --run examples/ir_stages/ssa_values.ceru
cargo run --quiet --example ssa_model -- --run examples/ir_stages/owned_values.ceru
cargo test --test ssa_construction --test mir_ssa --test ssa_executor
```

引数なしの`cargo run --quiet --example ssa_model`では、次の手作りSSAを検証・表示します。

| 例 | 確認すること |
| --- | --- |
| branch | 分岐の各辺から合流blockへ値を渡す |
| parallel-loop | 戻り辺で二つの値を入れ替えて渡す。未到達MIRも保持する |
| residual-slots | 配列更新の前の添字検査、文字列slot、日本語・NUL・CR/LF・非正規化の文字列 |

`parallel-loop`は構造検証用の無限loopであり、実行しません。実行可能なCeruneソースの基準例は[ssa_values.ceru](../../examples/ir_stages/ssa_values.ceru)です。IR・非SSA MIR・SSA・VMの出力は`14 / 16 / 20 / 10`です。

表示は`original-mir`と`ssa`に分かれます。前者は元MIRをそのまま含み、後者の`vN`はSSA値、`slotN`は元MIRに残る局所領域です。`original-local`・`original-block`・`mir-iN`から元の定義へ戻れます。未到達blockも元MIRの記録を指して残します。`construction=scalar-ssa-v1`は自動変換、`manual`は手作り入力で、最適化は行いません。

構造検証は定義・支配・辺の型・slot初期化・先行する添字検査・出自対応を確認します。変換テストでは、全実行用exampleの元snapshot・操作・辺・出自・決定性を確認し、変換処理とは別のデータフロー検査で各読取りと辺が最新の定義を使うことを照合します。型が合う古い値への置換も拒否します。直接実行テストでは、全実行用example、既存の停止例、heap予算の組合せをIR・非SSA MIR・SSA・VMで比較します。出力・停止コード・出自・先行出力と元snapshot不変を確認します。辺の同時束縛と強制確保失敗も検査します。これらは変換一般やheap寿命の形式証明ではありません。
