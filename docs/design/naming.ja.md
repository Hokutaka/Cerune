# Ceruneの命名と移行

日本語 | [English](naming.en.md)

言語名をPrimerからCeruneへ変更します。Ceruleanに由来する名前として、言語、CLI、中間表現に共通の名前を使います。可観測性を優先する設計、言語の意味、評価順、値のコピー、文字列のバイト列は変更しません。

## 名前の対応

| 対象 | 旧名 | 新名 |
| --- | --- | --- |
| 言語・GitHubリポジトリ | Primer | Cerune |
| CLI | `primer` | `cerune` |
| Cargoパッケージ / Rust crate | `primer-lang` / `primer_lang` | `cerune-lang` / `cerune_lang` |
| ソース | `.prim` | `.ceru` |
| 共通中間表現 | Primer IR / `.pir` | Cerune IR / `.ceir` |
| bytecodeのテキスト出力 | `.pbc` | `.cebc` |
| 診断の接頭辞 | `primer:` | `cerune:` |
| WATのホストimport名 | `primer` | `cerune` |
| ソース一覧JSONのschema | `primer-sources-v1` | `cerune-sources-v1` |
| ネイティブ観測JSONのschema | `primer-native-observation-v1` | `cerune-native-observation-v1` |
| 生成シンボルの接頭辞 | `primer` | `cerune` |
| 検証ツールの環境変数 | `PRIMER_TEST_*` | `CERUNE_TEST_*` |
| 観測スクリプトのCLI指定 | `--primer` | `--cerune` |
| 観測スクリプトの自前エンコーダ指定 | `--encoder primer` | `--encoder cerune` |

`.ceir`はCerune IRを表す拡張子です。LLVM IRの`.ll`と区別し、特定の出力経路に依存しない、意味と型が解決済みの共通表現に使います。`.cebc`も現在は観測用のテキストです。この改名でIRやbytecodeをファイルから読み込む機能を追加するわけではありません。

Cの`.c`、LLVMの`.ll`、QBEの`.ssa`、WATの`.wat`、アセンブリの`.s`、COFF/ELFのオブジェクト形式はそのままです。IR・bytecodeの構造上のバージョン、および診断の`runtime-v1`は維持します。

## 既存コードとツールの移行

開発初期の改名として、旧CLI名や旧schema名の互換エイリアスは設けません。

1. ソースを`.ceru`へ改名し、`import "./values.ceru" as values;`のようにimport先も更新します。importは相対パスの`.ceru`を要求します。CLIへ直接渡す入力ファイル名には拡張子制限を追加していません。
2. `cargo install --path .`で`cerune`をインストールし、スクリプトやエディタ設定のコマンド・拡張子を更新します。以前インストールした`primer`は別の実行ファイルとして残るため、使わなくなった環境では`cargo uninstall primer-lang`で削除できます。
3. WATホストのimportオブジェクトを`cerune`へ変更します。生成物は再生成し、診断や観測JSONを読むツールも上表の名前に合わせます。JSONの情報項目や停止理由は変わりません。
4. ネイティブ観測スクリプトへ`--cerune <実行ファイル>`を渡します。自前エンコーダには`--encoder cerune`を指定します。

ソースを書き換えた場合は、ソース一覧と生成物を一緒に再生成してください。観測されるソース名・位置は実際の入力に対応します。過去の生成物は、その生成時のソースとツール版を組にして保存します。

```sh
cerune run examples/modules/main.ceru
cerune emit-ir examples/modules/main.ceru -o main.ceir
cerune emit-bytecode examples/modules/main.ceru -o main.cebc
```

改名の検証では、改名前後のexampleの標準出力をバイト単位で比較し、生成コードと診断は上記の名前変更を除いて一致することを確認します。各経路の実行比較でも、停止理由・ソース位置・停止前の出力を引き続き検証します。
