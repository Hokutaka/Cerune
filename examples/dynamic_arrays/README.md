# 動的配列の例

[English](README.en.md)

IR Executor・VMで実行できます。C・LLVM・QBE・WAT・ASM・native objectは未対応です。

| 例 | 確認すること |
| --- | --- |
| [copy.ceru](copy.ceru) | 独立コピー、範囲・空配列、要素更新、表示・比較・反復 |
| [nested.ceru](nested.ceru) | 入れ子、文字列のNUL・CR/LF、関数・enum・match、反復中の再代入 |

```sh
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru
cargo run --quiet -- run-vm examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-ir examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-bytecode examples/dynamic_arrays/copy.ceru
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru --array-heap-limit 24
```

最後のコマンドは、元の3要素が24バイトを使い、`saved`用のコピー領域が足りないため意図的に停止します。既定予算では成功します。コピーのループと確保・解放は生成IRで確認できます。
