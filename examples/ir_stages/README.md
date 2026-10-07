# IR段階の観測

[English](README.en.md)

| Example | 確認すること | 実行結果 |
| --- | --- | --- |
| [native_calls.ceru](native_calls.ceru) | MIRからNativeへ変換。型の異なる7引数、continue／break、main呼出し | 見出しとi=0・2の引数、計算結果`4` |
| [owned_values.ceru](owned_values.ceru) | 関数へ渡す動的配列の独立性、不変文字列、continueを通る解放 | 元配列・装飾後の配列・`["反復"]` |
| [control_flow.ceru](control_flow.ceru) | 短絡で呼出しを省く。forのcontinueは更新、breakは出口へ進む | `2`、`4`の2行 |

次のコマンドで、同じソースの実行結果と変換前後を確認できます。

```sh
cargo run --quiet -- run examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/owned_values.ceru
cargo run --quiet -- run-vm examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/native_calls.ceru
cargo run --quiet -- emit-mir examples/ir_stages/native_calls.ceru -o target/native_calls.mir.txt
cargo run --quiet -- emit-asm examples/ir_stages/native_calls.ceru --target x86_64-unknown-linux-gnu --annotate-origins -o target/native_calls.s
cargo run --quiet -- emit-obj examples/ir_stages/native_calls.ceru --target x86_64-unknown-linux-gnu --annotate-origins -o target/native_calls.o
cargo run --quiet -- emit-ir examples/ir_stages/control_flow.ceru
cargo run --quiet -- emit-mir examples/ir_stages/control_flow.ceru -o target/control_flow.mir.txt
```

`native_calls`は見出し`MIR → Native`の後に、`0, 18446744073709551615, 7, 9, 4`、続いて`2, 18446744073709551615, 7, 9, 4`を1値1行で表示します。ASMの`cerune-mir`注釈からMIRのblock・命令番号へ戻れます。Windows向けに生成する場合はtargetを`x86_64-pc-windows-msvc`へ変更します。Objectの生成だけではリンク・実行しません。

`control_flow`の`i=0`では`accept`を呼ばず、`i=1`はcontinueで更新へ進み、`i=2`だけが`accept`を呼んで`2`を表示します。`i=3`は更新前に終了し、合計`4`を表示します。

MIRでは`bbN`がブロック、`%N`が型付き局所値／一時値、`iN`が関数内の命令番号です。`derived=short-circuit-rhs`、`derived=for-update`、`derived=loop-exit`とjump／branchを読むと制御の行き先が分かります。各操作の`hir=#N source=N bytes=A..B`で元のIRとファイル内の範囲へ戻れます。MIRを生成するだけではプログラムは実行されません。

配列コピーと確保失敗も確認する場合は[lowering_order.ceru](../dynamic_arrays/lowering_order.ceru)を使います。`run-mir`は[独立したMIR実行器](../../docs/design/mir-executor.ja.md)です。[NativeもMIR入力へ移行済み](../../docs/design/native-mir.ja.md)です。SSA・最適化は未実装です。型・検証範囲は[段階設計](../../docs/design/ir-stages.ja.md)に記載しています。
