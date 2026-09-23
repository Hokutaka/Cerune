# モジュールを使う例

[English](README.en.md)

importによる分割と単一ファイル版を比較します。このディレクトリはルートの正常例の一括実行には含まれません。

## 正常に動く例

| 入口 | 型・表現 | 確認内容 |
| --- | --- | --- |
| [main.ceru](main.ceru) | `values::Reading`、配列、コピー、短絡評価 | 最大u64、コピーの独立性、文字列のバイト・等値比較、右辺の省略 |
| [single.ceru](single.ceru) | 同じ処理を単一ファイルで記述 | 分割前後で値と出力順が一致 |
| [sum_lookup.ceru](sum_lookup.ceru) | `values::Lookup::Found`、`match` | `空\0\r\n`、未登録、直接構築した文字列 |
| [constant_array_lengths.ceru](constant_array_lengths.ceru) | 型の長さへ公開定数を使用 | `共有サイズ → 6 → 15`、最後に`保持\0\r\n` |
| [constants.ceru](constants.ceru) | 定数のimportとコピー | `129 → 12 → 10 → 99`、最後に`設定\0\r\n`を表示 |
| [product_update.ceru](product_update.ceru) | 公開型の更新式 | 元の値を保持し、ラベルを引き継ぐ |

```sh
cargo run -- run examples/modules/main.ceru
cargo run -- run examples/modules/single.ceru
cargo run -- emit-sources examples/modules/main.ceru -o target/module-sources.json
```

`\0`・`\r`・`\n`はNUL・CR・LFを表します。

| 入口 | stdout |
| --- | --- |
| `main.ceru`／`single.ceru` | `18446744073709551615\n2\n観測\0\r\n\ntrue\nfalse\n計算\n5\n` |
| `product_update.ceru` | `計算\n42\n5\n観測\0\r\n\n` |

## 意図して停止する例

VMでは終了コード1になります。停止理由・位置・先行出力が一致することを確認します。

| 入口 | 停止前のstdout | 理由と位置・省略される処理 |
| --- | --- | --- |
| [failure.ceru](failure.ceru) | `開始\n計算\n5\n計算\n` | `division-by-zero`、`file=2`。`values.ceru:17:12`の`value / divisor` |
| [product_update_failure.ceru](product_update_failure.ceru) | `開始\n計算\n` | 元の値の構築中に`division-by-zero`、`file=2`。後続の`amount`を評価しない |
| [array_update.ceru](array_update.ceru) | `添字\n` | `array-index-out-of-bounds`、`file=1`の`[1]`。右辺の`divide`を呼ばず「計算」も出ない |

```sh
cargo run -- run examples/modules/failure.ceru --diagnostic-format runtime-v1
```

NodeIdとバイト位置は編集・改行方式で変わります。意図した停止と想定外の失敗は区別します。

## 読み込まれる部品

| ファイル | 定義 |
| --- | --- |
| [values.ceru](values.ceru) | `u64`・`string`を持つ公開構造体と既定値、公開関数、非公開補助関数 |
| [lookup_values.ceru](lookup_values.ceru) | `pub enum`・定数・関数。存在／不在を値で返す |
| [dimensions.ceru](dimensions.ceru) | 公開する行数・列数と、公開型の長さを定める非公開定数 |
| [constant_settings.ceru](constant_settings.ceru) | `pub const`・構造体・非公開定数。設定と補正値をコンパイル時に評価 |

`values.ceru`を読み込むだけでは`announce`は実行されません。「計算」は`divide`を実際に呼んだときに出ます。

## 生成と検証

同じ入口を`emit-c`・`emit-llvm`・`emit-qbe`・`emit-wat`・`emit-asm`・`emit-obj`へ渡せます。LLVM・QBE・オブジェクトにはターゲット指定が必要です。ASMも明示すると分かりやすくなります（省略時はWindows固定）。

```sh
cargo test --test modules --test source_files -- --nocapture
```

構文・公開範囲と、利用可能な生成経路の実行結果を確認します。詳細は[モジュールの規則](../../docs/design/modules.ja.md)・[CLI](../../docs/reference/cli.ja.md)を参照してください。
