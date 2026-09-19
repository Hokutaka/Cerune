# モジュールを使う例

[English](README.en.md)

| ファイル | 型・表現 | 確認内容 |
| --- | --- | --- |
| [constant_settings.ceru](constant_settings.ceru) | `pub const`・構造体・非公開定数 | 設定値と補正値をコンパイル時に評価 |
| [constants.ceru](constants.ceru) | 定数のimportとコピー | `129 → 12 → 10 → 99`、最後に`設定\0\r\n`を表示 |
| [values.ceru](values.ceru) | `u64`・`string`・product・公開関数 | 公開型の既定値と、公開関数から呼ぶ非公開補助関数 |
| [main.ceru](main.ceru) | `values::Reading`・固定配列・コピー・短絡評価 | 最大u64、再代入後の独立性、文字列バイトと等値比較、実行しない右辺 |
| [single.ceru](single.ceru) | 同じ処理を一つのファイルで表現 | 分割前後で値と出力順が変わらないこと |
| [product_update.ceru](product_update.ceru) | 公開型の更新式 | 元の値を保持し、ラベルを引き継ぐ |
| [product_update_failure.ceru](product_update_failure.ceru) | 元の値の構築中にゼロ除算 | 後続フィールドを実行せず、定義ファイルの失敗位置を報告 |
| [failure.ceru](failure.ceru) | 正常呼び出し後のゼロ除算 | 停止前の出力と、`values.ceru`の除算への出自 |
| [array_update.ceru](array_update.ceru) | 配列代入の左辺検査と公開関数の呼び出し | 添字が範囲外なら右辺の関数を実行しない |

```sh
cargo run -- run examples/modules/main.ceru
cargo run -- run examples/modules/single.ceru
cargo run -- run examples/modules/failure.ceru --diagnostic-format runtime-v1
cargo run -- emit-sources examples/modules/main.ceru -o target/module-sources.json
```

`main.ceru`と`single.ceru`のstdoutをエスケープ表記すると、`18446744073709551615\n2\n観測\0\r\n\ntrue\nfalse\n計算\n5\n`です。`values.ceru`を読んだだけでは`announce`は実行されず、`divide`を実際に呼んだときだけ「計算」が出ます。

`product_update.ceru`は`計算\n42\n5\n観測\0\r\n\n`を出力します。`product_update_failure.ceru`は`開始\n計算\n`の後に`division-by-zero`・`file=2`で停止し、後続の`amount`は評価しません。

`failure.ceru`は意図した失敗例です。先行出力`開始\n計算\n5\n計算\n`の後、終了コード1になり、`code=division-by-zero`と`file=2`を記録します。人向け診断では`values.ceru:17:12`、本文では`value / divisor`に対応します。NodeIdとバイト位置は編集・改行方式により変わります。成功・意図した停止・想定外の失敗は分けて確認します。

`array_update.ceru`も意図した失敗例で、`添字\n`の後に`array-index-out-of-bounds`・`file=1`を報告します。入口ファイルの`[1]`で止まるため、右辺の`divide`は実行されず「計算」は出ません。

`cerune emit-c`、`emit-llvm`、`emit-qbe`、`emit-wat`、`emit-asm`、`emit-obj`にも同じ入口を渡せます。LLVM/QBE/ネイティブオブジェクトのターゲット指定は従来通り必要です。`cargo test --test modules --test source_files -- --nocapture`で構文・公開範囲と、利用可能な生成経路の実行結果を確認できます。

ここにある部品・失敗例はルートの正常example一括実行とは別に扱います。[モジュールの規則](../../docs/design/modules.ja.md)と[CLI](../../docs/reference/cli.ja.md)も参照してください。
