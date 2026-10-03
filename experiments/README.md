# Verification experiments / 検証実験

言語本体・通常のCerune実行サンプルとは分けて、外部ツールによる検証を置きます。
各フォルダに対象範囲、必要なツール、実行手順を記録します。

External-tool verification lives separately from the language implementation and ordinary Cerune examples. Each folder documents scope, tools, and commands.

| Experiment | 内容 / Purpose |
| --- | --- |
| [lean](lean/README.md) | IRと生成Leanの対応、プログラムの性質、IR・VMとの実行比較 / Correspondence, program properties, execution comparisons |

GitHubのLanguagesはソースの言語集計で、必要な実行環境の一覧ではありません。
検証用のLean、CJS補助ツール、生成物の比較用fixtureは[.gitattributes](../.gitattributes)で集計対象から外します。
証明や観測結果をレビューできるよう、diffを隠す設定は使いません。
将来のLean emitter本体はRust実装として集計し、比較用のLeanファイルは検証側へ置きます。

GitHub Languages reports source-language statistics, not runtime requirements.
[.gitattributes](../.gitattributes) excludes Lean verification files, CJS helpers, and generated-output comparison fixtures from statistics while keeping their diffs visible.
A future Lean emitter implemented in Rust remains implementation code; Lean comparison files belong to verification.
