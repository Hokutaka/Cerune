# Lean verification experiment / Lean検証実験

公開backendの前段階です。実際の完成済みHIRと、そこからloweringしたMIRのu8関数`increment`・`choose`・`advance`を検証します。呼出側のprintや他の関数は証明対象に含めません。[設計](../../docs/design/lean-verification.ja.md)。

This precedes a public backend. It verifies the u8 functions `increment`, `choose`, and `advance` from actual completed HIR and its lowered MIR, not printing callers or other functions. [Design](../../docs/design/lean-verification.en.md).

## ファイル / Files

証明・入力・生成ツールはここにまとめます。`examples/`はCeruneの実行サンプル一覧として保ちます。
Proofs, inputs, and generation tools live here; `examples/` remains the Cerune program list.

| File | 内容 / Purpose |
| --- | --- |
| [increment.ceru](increment.ceru) | checked u8の加算 / Checked u8 increment |
| [Model.lean](Model.lean) | HIRの引数・定数・加算・overflowと出自 / HIR expression semantics |
| [MirModel.lean](MirModel.lean) | 独立した型付き局所値・命令列・CFGの評価 / Independent typed locals, instructions, and CFG semantics |
| [branch.ceru](branch.ceru)・[BranchModel.lean](BranchModel.lean) | if・短絡とそのHIR参照モデル / If/short-circuit fixture and HIR reference model |
| [branch.rs](branch.rs)・[BranchProperties.lean](BranchProperties.lean) | HIRの分岐を写す生成器と独立した仕様 / HIR branch exporter and independent properties |
| [emit.rs](emit.rs) | HIRから参照項と直接Lean定義を別々に生成 / HIR reference terms and direct Lean code |
| [mir.rs](mir.rs) | 渡されたMIR snapshotを写す。HIRから再構成しない / Exports the supplied MIR snapshot, without rebuilding it from HIR |
| [Properties.lean](Properties.lean) | 生成器と独立した仕様とHIR/MIRへの移送 / Independent properties and transfer to HIR/MIR |
| [loop.ceru](loop.ceru)・[LoopModel.lean](LoopModel.lean) | 4回の加算と、構造化while・可変局所値のHIR評価 / Four increments and structured HIR while/local semantics |
| [loops.rs](loops.rs)・[LoopProperties.lean](LoopProperties.lean) | 評価上限を明示する生成器と独立仕様 / Exporter with explicit bounds and independent specification |
| [main.rs](main.rs)・[lean-toolchain](lean-toolchain) | 開発ツールと固定Lean版 / Development tool and pinned checker |

## 実行 / Commands

リポジトリのルートから実行します。実行例の出力は`1 → 42 → 255`です。
Run from the repository root; the example prints `1 → 42 → 255`.

`branch.ceru`は`1 → 127 → 129 → 130 → 255`を出力します。`value < 128 && value + 128 < 255`により、128以上ではoverflowする右辺を省きます。全入力の仕様は次のとおりです。

`branch.ceru` prints `1 → 127 → 129 → 130 → 255`. The condition `value < 128 && value + 128 < 255` skips an overflowing RHS for inputs ≥128. The complete input specification follows.

| 入力 / Input | 結果 / Result |
| --- | --- |
| 0–126 | `input + 1` |
| 127–253 | `input + 2` |
| 254–255 | else側`value + 2`でoverflow / Overflow at the else addition |

`loop.ceru`は`4 → 5 → 254 → 255`を出力します。`advance`は値を4回増やし、入力0〜251では`input + 4`、252〜255では`current + 1`の途中でoverflowします。

`loop.ceru` prints `4 → 5 → 254 → 255`. `advance` increments four times: inputs 0–251 return `input + 4`; inputs 252–255 overflow during `current + 1`.

`Cargo --example lean_verification`は開発用Rustツールの名前です。通常のCerune実行にはLean不要です。`+toolchain`はelan用で、直接Leanを使う場合は固定版を事前に用意し`CERUNE_TEST_LEAN`へパスを渡せます。テストは自動インストールしません。

`Cargo --example lean_verification` names a Rust development tool, not a language backend. Normal Cerune execution needs no Lean. The `+toolchain` form uses elan; a preinstalled matching binary can be selected with `CERUNE_TEST_LEAN`. Tests never auto-install Lean.

```sh
cargo run --quiet -- run experiments/lean/increment.ceru
cargo run --quiet -- run-mir experiments/lean/increment.ceru
cargo run --quiet -- run-vm experiments/lean/increment.ceru
cargo run --quiet -- run experiments/lean/branch.ceru
cargo run --quiet -- run-mir experiments/lean/branch.ceru
cargo run --quiet -- run-vm experiments/lean/branch.ceru
cargo run --quiet -- run experiments/lean/loop.ceru
cargo run --quiet -- run-mir experiments/lean/loop.ceru
cargo run --quiet -- run-vm experiments/lean/loop.ceru
cargo run --quiet --example lean_verification
lean +leanprover/lean4:v4.34.1 target/lean-verification/Verified.lean
lean +leanprover/lean4:v4.34.1 target/lean-verification/BranchVerified.lean
lean +leanprover/lean4:v4.34.1 target/lean-verification/LoopVerified.lean
cargo test --test lean_verification
cargo test --test lean_verification -- --include-ignored
```

生成先`target/lean-verification`に`Generated.lean`（モデル・参照項・生成関数・対応定理）、`Verified.lean`（独立した性質を追加）、`increment.ceir`、`increment.mir.txt`、`lean-toolchain`を保存します。元の表現、命令順・局所値、定理の前提を照合できます。生成関数とMIRモデルはHIRの`eval`を呼びません。

Outputs under `target/lean-verification` are `Generated.lean` (models, reference terms, generated function, correspondence), `Verified.lean` (independent properties appended), `increment.ceir`, `increment.mir.txt`, and `lean-toolchain`. Inspect source representations, instruction order/locals, and theorem assumptions together. Neither the generated function nor the MIR evaluator calls HIR `eval`.

分岐例も同じディレクトリに`BranchGenerated.lean`、`BranchVerified.lean`、`branch.ceir`、`branch.mir.txt`を保存します。HIRの構造化された条件と、MIRでのblock・jump・branchへの展開を比較できます。

The same directory also contains `BranchGenerated.lean`, `BranchVerified.lean`, `branch.ceir`, and `branch.mir.txt`, exposing structured HIR conditions alongside their MIR block/jump/branch lowering.

ループ例は`LoopGenerated.lean`、`LoopVerified.lean`、`loop.ceir`、`loop.mir.txt`を保存します。生成定義には`hirFuel = 16`、`mirFuel = 11`も残します。

The loop fixture adds `LoopGenerated.lean`, `LoopVerified.lean`, `loop.ceir`, and `loop.mir.txt`; generated definitions retain `hirFuel = 16` and `mirFuel = 11`.

## 証明とテスト / Proofs and tests

対象と依存は次のとおりです。Proof subjects and dependencies are explicit.

| 対象 / Subject | 保証 / Claim | 公理 / Axioms |
| --- | --- | --- |
| HIR→直接Lean / direct Lean | 全有効入力での対応、255未満の正確な加算とHIRへの移送、255のoverflow / Correspondence, exact addition below 255 and transfer to HIR, overflow at 255 | 既存4定理は空 / Existing four: none |
| HIR→MIR | `∀ x : Fin 256, evalMir mirReference x.val = .completed (eval reference x.val)` | `propext` |
| MIRの性質 / properties | 同じ正確な加算とoverflowを対応証明から移す / Transfer the same exact addition and overflow | `propext` |
| 分岐HIR→MIR / Branch HIR→MIR | 全256入力で`evalMir = .completed (evalBranch …)` | `propext` |
| 分岐の仕様 / Branch specification | 上の入力表をHIRで証明 / Prove the input table above for HIR | 空 / None |
| 分岐MIRの性質 / Branch MIR property | 対応定理から入力表の仕様を移す / Transfer the input-table specification through correspondence | `propext` |
| ループ対応・完了・MIRの性質 / Loop correspondence, completion, MIR property | 全入力で同じ結果になり、両経路とも明示上限内で完了 / Same result and completion within each explicit bound for every input | `propext` |
| ループの仕様 / Loop specification | 251以下は+4、252以上は指定位置のoverflow / +4 through 251, overflow at the specified origin from 252 | 空 / None |

MIRの定理は有限入力について`decide`で証明し、Lean kernelで検査します。`propext`は有限量化・等値性の決定手続きで使うLean標準の命題外延性公理です。依存を完全一致で検査し、`sorryAx`・独自公理・native評価への追加信頼は許容しません。実行結果の比較だけを証明として出力するものではありません。

The MIR theorem uses `decide` over the finite domain and is checked by Lean's kernel. `propext` is Lean's standard propositional-extensionality axiom used by finite quantification/equality decision procedures. Tests require the exact declared dependencies; `sorryAx`, custom axioms, and additional native-evaluation trust are not accepted. Runtime output comparison alone does not produce the proof.

テストは全256入力をHIR・MIR・VM・生成Lean・Lean MIRモデルと既知値で照合し、overflowのFailureCode／NodeId／SourceId／Span・空の先行出力を確認します。HIRを固定し、MIRの定数・NodeId・SourceId・Span・戻り先を改変すると対応証明が失敗します。命令順の破損や未対応操作は生成前に拒否します。既存の生成値・出自・利用者仕様の改変検査も残します。

Tests compare all 256 inputs across HIR, MIR, VM, direct Lean, the Lean MIR model, and known expectations, including overflow FailureCode/NodeId/SourceId/Span and empty prior output. With HIR fixed, changing MIR literals, NodeIds, SourceIds, spans, or returns breaks the proof. Invalid instruction order and unsupported operations are rejected before export. Existing generated-value/origin/user-specification mutation tests remain.

分岐例でも全256入力をHIR・MIR・VM・LeanのHIR/MIRモデルと既知値で照合します。分岐先の逆転、短絡右辺の無条件実行、比較の左右逆転、停止NodeIdの改変、独立仕様の127境界の改変を拒否します。`||`への置換例の対応も検査します。

The branch fixture also compares all 256 inputs across HIR, MIR, VM, Lean HIR/MIR models, and known expectations. Checks reject swapped branch targets/comparison operands, eager RHS execution, altered failure NodeIds, and changing the independent specification's 127 boundary. A variant using `||` also checks correspondence.

ループ例も全256入力を比較します。反復回数・更新store・戻り辺・停止NodeIdを壊したMIR、条件blockで循環するMIR、独立仕様の252境界の改変を拒否します。HIR/MIRの上限を1減らす場合と両方0にする場合も拒否し、fuel不足同士の一致を成功にしません。誤変換は上限付きモデルで検査し、停止しない実行ファイルを起動しません。

The loop fixture also compares all 256 inputs. Checks reject changed iteration counts, update stores, backedges, failure NodeIds, a self-looping condition block, and the independent specification's 252 boundary. Reducing either bound by one or setting both to zero is rejected; matching exhaustion is not success. Mutations run only in bounded models, never as potentially nonterminating executables.

Lean起動テストは通常実行ではignored、専用CIでは必須です。証明・改変・MIRの観測結果は`target/lean-verification-test`に残します。
Lean execution is explicitly ignored in ordinary runs and mandatory in the dedicated CI job. Proofs, rejected mutations, and MIR observations remain in `target/lean-verification-test`.

## 未対応と信頼する部分 / Limits and trust

`Nat`は数学的な計算領域で、入力は`Fin 256`、定数は0〜255、各加算は範囲検査します。`u8`を無制限整数には変えません。MIRはu8/boolのliteral・copy・scalar store・add・less、jump・branch・return・unreachableを写します。直列・分岐のexporterは未到達blockも含めて循環CFGを拒否します。ループ実験だけは循環を許し、別々の明示上限と完了証明を要求します。

`Nat` is a mathematical domain: inputs are `Fin 256`, constants are 0–255, and each addition checks its range. MIR exports u8/bool literals, copy/scalar store/add/less, jump/branch/return/unreachable. Straight-line/branch exporters reject cyclic CFGs, including unreachable blocks. Only the loop experiment allows cycles, with separate explicit bounds and a completion proof.

非循環例のMIRモデルはblock数をfuelとします。循環がなければ経路上のblock数の上界になり、対応定理は全入力で`.completed`へ到達することも検査します。`.completed (.error …)`はCeruneの停止、`.invalid`は不正状態、`.exhausted`はfuel不足です。後二者を言語上の停止や証明成功として扱いません。

ループ例ではHIRは文（whileの条件判定を含む）の訪問数、MIRはblockの訪問数を数えます。式・block内の有限命令列はそれぞれ構造的に評価します。16と11は単位が異なり、同じfuel値や実行時間の比較ではありません。全256入力で両モデルの完了を証明しますが、任意のloopの停止性・上限を求めるアルゴリズムの証明ではありません。

for・break／continue・一般のloop停止性・call・出力trace・heap・所有・他整数・float等は未対応です。次はloop内の分岐とbreak／continueの行き先へ拡張します。小さな実験を最終的な言語サブセットには固定しません。

For acyclic fixtures, the MIR model uses block count as fuel, which bounds every path. Correspondence checks that every input reaches `.completed`. `.completed (.error …)` is a Cerune failure, `.invalid` an invalid state, and `.exhausted` insufficient fuel. The last two are neither language failures nor proof success.

The loop fixture counts HIR statement visits (including each while test) and MIR block visits. Expressions and finite block instruction lists are evaluated structurally. Bounds 16 and 11 have different units, not a shared fuel scale or time measurement. Completion is proved for all 256 inputs, not for arbitrary loops or an algorithm that discovers bounds.

For-loops, break/continue, general loop termination, calls, output traces, heap/ownership, other integers, floats, and other features are not covered. Next, extend to branches and break/continue destinations within loops, without fixing a permanent language subset.

RustのHIR/MIRとモデルの対応、exporter、Lean kernelと明記した公理は信頼する部分に残ります。個々の実際の変換結果に対するtranslation validationであり、全loweringアルゴリズム・全処理系・Nativeの証明ではありません。

The Rust HIR/MIR-to-model correspondence, exporters, Lean kernel, and declared axioms remain trusted. This is translation validation of individual actual lowering results, not proof of the general lowering algorithm, whole compiler, or Native output.
