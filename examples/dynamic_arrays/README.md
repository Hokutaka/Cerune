# 動的配列の例

[English](README.en.md)

IR Executor・VM・生成C・LLVMで実行できます。QBE・WAT・ASM・native objectは未対応です。

| 例 | 確認すること |
| --- | --- |
| [readings.ceru](readings.ceru) | 構造体配列の範囲を関数から返し、コピーを修正して集計 |
| [window.ceru](window.ceru) | 実行時の長さで範囲を選び、関数から返した配列だけを更新 |
| [copy.ceru](copy.ceru) | 独立コピー、範囲・空配列、要素更新、表示・比較・反復 |
| [nested.ceru](nested.ceru) | 入れ子、文字列のNUL・CR/LF、関数・enum・match、反復中の再代入 |

```sh
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru
cargo run --quiet -- run-vm examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-ir examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-bytecode examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-c examples/dynamic_arrays/window.ceru -o window.c
clang -std=c11 window.c -o window
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru --array-heap-limit 24
```

最後のコマンドは、元の3要素が24バイトを使い、`saved`用のコピー領域が足りないため意図的に停止します。既定予算では成功します。コピーのループと確保・解放は生成IRで確認できます。

生成Cは外部のCコンパイラでビルドします。上の`window`をLinuxなら`./window`、Windowsなら`.\window.exe`で実行できます。コピーと解放のループはIRと生成Cの両方で確認できます。

LLVMの生成・実行例（Linux x86-64）：

```sh
cargo run --quiet -- emit-llvm examples/dynamic_arrays/readings.ceru --target x86_64-unknown-linux-gnu --annotate-origins -o readings.ll
clang readings.ll -o readings
./readings
```

Windowsではターゲットを`x86_64-pc-windows-msvc`に変え、`clang readings.ll -o readings.exe`、`.\readings.exe`で実行します。元の範囲は`[{valid: false, value: 0}, {valid: true, value: 20}]`のまま、コピーは15と20になり、合計35を出力します。
