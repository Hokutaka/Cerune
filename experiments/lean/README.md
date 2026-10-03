# Lean verification experiment / Lean検証実験

公開backendの前段階です。完成済みCerune IRから選択した`increment`関数だけを検証します。
呼出側のprintや他の関数まで証明済みとはしません。[設計](../../docs/design/lean-verification.ja.md)。

This precedes a public backend. It verifies only the selected `increment` function from completed Cerune IR, not its printing callers or other functions. [Design](../../docs/design/lean-verification.en.md).

| File | 内容 / Purpose |
| --- | --- |
| [increment.ceru](increment.ceru) | `u8`を1増やす。通常の実行例 / Increment a checked `u8` |
| [Model.lean](Model.lean) | 引数・定数・加算・overflowと出自の参照モデル / Reference model |
| [main.rs](main.rs) | Rust側の生成ツールの入口 / Rust verification-tool entry point |
| [emit.rs](emit.rs) | 実際のIRからモデルの項と直接Lean定義を別々に生成 / Experimental translation |
| [Properties.lean](Properties.lean) | 生成器と分離した性質と、IR側への移送 / Independent properties and transfer |
| [lean-toolchain](lean-toolchain) | 検証するLeanの固定版 / Pinned checker |

このフォルダに証明・入力・生成ツールをまとめ、Ceruneの実行サンプル一覧である`examples/`とは分離します。Cargoの`--example lean_verification`はこのフォルダのRustツールを起動するための開発用ターゲット名です。通常のCerune build/runにLeanは不要です。

Proofs, input, and the generator live here, separately from the Cerune program list in `examples/`. Cargo's `--example lean_verification` names the Rust development tool in this folder. Ordinary Cerune build/run does not require Lean.

リポジトリのルートから実行します。実行例の出力は`1 → 42 → 255`です。
Run from the repository root; the example prints `1 → 42 → 255`.

```sh
cargo run --quiet -- run experiments/lean/increment.ceru
cargo run --quiet -- run-vm experiments/lean/increment.ceru
cargo run --quiet --example lean_verification
lean +leanprover/lean4:v4.34.1 target/lean-verification/Verified.lean
cargo test --test lean_verification
cargo test --test lean_verification -- --ignored
```

上記の`+toolchain`表記はelan経由です。直接Lean実行ファイルを使う場合は同じ版を選び、テストへは`CERUNE_TEST_LEAN`で渡せます。テスト中の自動インストールを避けるため、固定版は事前に準備してください。

The `+toolchain` syntax uses elan. A direct Lean binary must have the same version; tests accept its path via `CERUNE_TEST_LEAN`. Install the pinned toolchain before testing.

生成先は`target/lean-verification`です。`Generated.lean`に参照項・生成関数・対応定理、`Verified.lean`にそれらと独立した性質、`increment.ceir`に元のIRを残します。定理名・文面・入力条件を確認できます。生成関数は参照モデルの`eval`を呼び出しません。

Outputs under `target/lean-verification` include the reference term, generated function and correspondence theorem in `Generated.lean`, independent properties appended in `Verified.lean`, and the input IR in `increment.ceir`. The generated function does not call the model's `eval`.

検査対象は、全有効入力での変換対応、255未満での正確な加算、IR側へ移した同じ性質、255でのoverflowです。4つの定理は追加の公理に依存しません。テストは256入力をIR・VM・生成Leanと期待値で比較し、値・出自・仕様の改変を拒否します。Leanを起動するテストは通常実行ではignoredと表示され、専用CI jobで実行します。

Checks cover correspondence for all valid inputs, exact addition below 255, transfer of that property to IR, and overflow at 255. All four theorems have empty axiom dependencies. Tests compare all 256 inputs with IR, VM, generated Lean, and known expectations, and reject value/origin/specification mutations. The Lean-invoking test is explicitly ignored in ordinary runs and executed in a dedicated CI job.

`Nat`は数学的な計算領域であり、Ceruneの`u8`を無制限整数へ変更するものではありません。入力は`Fin 256`、定数は生成前に範囲検査し、加算結果は各演算で検査します。この有限・純粋な関数にはfuelもheapも出力traceもありません。他の整数・制御・文字列・配列・float等はこの実験の対象外であり、全言語の証明とは扱いません。

`Nat` is a mathematical calculation domain: inputs are restricted to `Fin 256`, literals are validated before generation, and each addition checks its result. This finite, pure function has no fuel, heap, or output trace. Other integers, control flow, strings, arrays, floats, and other features are outside this experiment, not proven language features.

モデルとRust IRの対応、Rust生成器、Lean kernelは信頼境界に残ります。256入力の一致は接続部分のテストであり、処理系全体の証明ではありません。

The model's correspondence to Rust IR, the Rust generator, and the Lean kernel remain trust boundaries. Exhaustive testing of these 256 inputs checks the connection; it is not a whole-compiler proof.
