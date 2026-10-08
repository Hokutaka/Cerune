# Lean verification experiment / Lean検証実験

公開backendの前段階です。実際の完成済みHIRと、そこからloweringしたMIRの`increment: u8 → u8`だけを検証します。呼出側のprintや他の関数は証明対象に含めません。[設計](../../docs/design/lean-verification.ja.md)。

This precedes a public backend. It verifies only `increment: u8 → u8` from actual completed HIR and its lowered MIR, not printing callers or other functions. [Design](../../docs/design/lean-verification.en.md).

## ファイル / Files

証明・入力・生成ツールはここにまとめます。`examples/`はCeruneの実行サンプル一覧として保ちます。
Proofs, inputs, and generation tools live here; `examples/` remains the Cerune program list.

| File | 内容 / Purpose |
| --- | --- |
| [increment.ceru](increment.ceru) | checked u8の加算 / Checked u8 increment |
| [Model.lean](Model.lean) | HIRの引数・定数・加算・overflowと出自 / HIR expression semantics |
| [MirModel.lean](MirModel.lean) | 独立した局所値・命令列・returnの評価 / Independent locals, instructions, and return semantics |
| [emit.rs](emit.rs) | HIRから参照項と直接Lean定義を別々に生成 / HIR reference terms and direct Lean code |
| [mir.rs](mir.rs) | 渡されたMIR snapshotを写す。HIRから再構成しない / Exports the supplied MIR snapshot, without rebuilding it from HIR |
| [Properties.lean](Properties.lean) | 生成器と独立した仕様とHIR/MIRへの移送 / Independent properties and transfer to HIR/MIR |
| [main.rs](main.rs)・[lean-toolchain](lean-toolchain) | 開発ツールと固定Lean版 / Development tool and pinned checker |

## 実行 / Commands

リポジトリのルートから実行します。実行例の出力は`1 → 42 → 255`です。
Run from the repository root; the example prints `1 → 42 → 255`.

`Cargo --example lean_verification`は開発用Rustツールの名前です。通常のCerune実行にはLean不要です。`+toolchain`はelan用で、直接Leanを使う場合は固定版を事前に用意し`CERUNE_TEST_LEAN`へパスを渡せます。テストは自動インストールしません。

`Cargo --example lean_verification` names a Rust development tool, not a language backend. Normal Cerune execution needs no Lean. The `+toolchain` form uses elan; a preinstalled matching binary can be selected with `CERUNE_TEST_LEAN`. Tests never auto-install Lean.

```sh
cargo run --quiet -- run experiments/lean/increment.ceru
cargo run --quiet -- run-mir experiments/lean/increment.ceru
cargo run --quiet -- run-vm experiments/lean/increment.ceru
cargo run --quiet --example lean_verification
lean +leanprover/lean4:v4.34.1 target/lean-verification/Verified.lean
cargo test --test lean_verification
cargo test --test lean_verification -- --include-ignored
```

生成先`target/lean-verification`に`Generated.lean`（モデル・参照項・生成関数・対応定理）、`Verified.lean`（独立した性質を追加）、`increment.ceir`、`increment.mir.txt`、`lean-toolchain`を保存します。元の表現、命令順・局所値、定理の前提を照合できます。生成関数とMIRモデルはHIRの`eval`を呼びません。

Outputs under `target/lean-verification` are `Generated.lean` (models, reference terms, generated function, correspondence), `Verified.lean` (independent properties appended), `increment.ceir`, `increment.mir.txt`, and `lean-toolchain`. Inspect source representations, instruction order/locals, and theorem assumptions together. Neither the generated function nor the MIR evaluator calls HIR `eval`.

## 証明とテスト / Proofs and tests

対象と依存は次のとおりです。Proof subjects and dependencies are explicit.

| 対象 / Subject | 保証 / Claim | 公理 / Axioms |
| --- | --- | --- |
| HIR→直接Lean / direct Lean | 全有効入力での対応、255未満の正確な加算とHIRへの移送、255のoverflow / Correspondence, exact addition below 255 and transfer to HIR, overflow at 255 | 既存4定理は空 / Existing four: none |
| HIR→MIR | `∀ x : Fin 256, evalMir mirReference x.val = some (eval reference x.val)` | `propext` |
| MIRの性質 / properties | 同じ正確な加算とoverflowを対応証明から移す / Transfer the same exact addition and overflow | `propext` |

MIRの定理は有限入力について`decide`で証明し、Lean kernelで検査します。`propext`は有限量化・等値性の決定手続きで使うLean標準の命題外延性公理です。依存を完全一致で検査し、`sorryAx`・独自公理・native評価への追加信頼は許容しません。実行結果の比較だけを証明として出力するものではありません。

The MIR theorem uses `decide` over the finite domain and is checked by Lean's kernel. `propext` is Lean's standard propositional-extensionality axiom used by finite quantification/equality decision procedures. Tests require the exact declared dependencies; `sorryAx`, custom axioms, and additional native-evaluation trust are not accepted. Runtime output comparison alone does not produce the proof.

テストは全256入力をHIR・MIR・VM・生成Lean・Lean MIRモデルと既知値で照合し、overflowのFailureCode／NodeId／SourceId／Span・空の先行出力を確認します。HIRを固定し、MIRの定数・NodeId・SourceId・Span・戻り先を改変すると対応証明が失敗します。命令順の破損や未対応操作は生成前に拒否します。既存の生成値・出自・利用者仕様の改変検査も残します。

Tests compare all 256 inputs across HIR, MIR, VM, direct Lean, the Lean MIR model, and known expectations, including overflow FailureCode/NodeId/SourceId/Span and empty prior output. With HIR fixed, changing MIR literals, NodeIds, SourceIds, spans, or returns breaks the proof. Invalid instruction order and unsupported operations are rejected before export. Existing generated-value/origin/user-specification mutation tests remain.

Lean起動テストは通常実行ではignored、専用CIでは必須です。証明・改変・MIRの観測結果は`target/lean-verification-test`に残します。
Lean execution is explicitly ignored in ordinary runs and mandatory in the dedicated CI job. Proofs, rejected mutations, and MIR observations remain in `target/lean-verification-test`.

## 未対応と信頼する部分 / Limits and trust

`Nat`は数学的な計算領域で、入力は`Fin 256`、定数は0〜255、各加算は範囲検査します。`u8`を無制限整数には変えません。MIRは一つのreturn block内のliteral/copy/addと、空のunreachable blockだけを受け付けます。モデルの`none`は不正状態、`some (.error …)`はCeruneの停止です。この区別を落とさず対応を証明します。

`Nat` is a mathematical domain: inputs are `Fin 256`, constants are 0–255, and each addition checks its range. MIR accepts literal/copy/add in one returning block plus empty unreachable blocks. Model `none` means invalid state; `some (.error …)` means a Cerune failure. The correspondence preserves this distinction.

分岐・loop・call・出力trace・heap・所有・他整数・float等は未対応です。fuelも不要な有限・純粋関数を対象にしています。次は制御フローと停止の対応を段階的に拡張します。小さな実験を最終的な言語サブセットには固定しません。

Branches, loops, calls, output traces, heap/ownership, other integers, floats, and other features are not covered. This finite pure function needs no fuel. Next, extend control-flow and failure correspondence in stages, without fixing a permanent language subset.

RustのHIR/MIRとモデルの対応、exporter、Lean kernelと明記した公理は信頼する部分に残ります。一つの実際の変換結果に対するtranslation validationであり、全loweringアルゴリズム・全処理系・Nativeの証明ではありません。

The Rust HIR/MIR-to-model correspondence, exporters, Lean kernel, and declared axioms remain trusted. This is translation validation of one actual lowering result, not proof of the general lowering algorithm, whole compiler, or Native output.
