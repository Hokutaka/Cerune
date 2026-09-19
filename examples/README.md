# Ceruneサンプル

[English](README.en.md)

このディレクトリには、現在のCeruneで読んで実行できるプログラムを置きます。それぞれの例は、別の構文や計算方法を小さく示します。

[意図した停止の例](runtime_failures/README.md)には、停止前の出力と失敗する式を追う4例を分けて置いています。

[ファイルごとの出自の例](source_files/README.md)は、モジュール化の土台を検証するRust API用サンプルです。型・関数を別々に解析して出自を比較します。この部品は下記の一括実行対象に含めません。実際にimportを使う例は[modules](modules/README.md)にあり、型別の表と単一ファイル版・分割版・失敗例を比較できます。

## まとめて実行

リポジトリのルートから次を実行すると、すべてのサンプルについて名前、実行結果、成否、最後の集計を表示します。

```powershell
.\scripts\run-examples.ps1
```

`-Pattern "matrix*.ceru"`で対象を絞れます。`-SkipBuild`を指定すると、既にbuildされているCeruneを使います。

WSL / Bashでは次を使います。WSL側にもRustの開発環境が必要です。

```bash
bash scripts/run-examples.sh
bash scripts/run-examples.sh --pattern 'matrix*.ceru' --skip-build
```

`.sh`側は既定で`target/unix/debug/cerune`を使い、Windowsの生成物と分離します。`CARGO_TARGET_DIR`を指定した場合はその出力先を使います。`--skip-build`は、同じ出力先へ一度ビルドした後に指定してください。

一括実行は各サンプルの終了状態を確認します。期待する出力まで照合するには`cargo test --test examples`、fmt・clippy・全テストをまとめて実行するには`bash scripts/test.sh`を使います。

## 型から探す

8種類の整数型、`f32`・`f64`、`bool`、`string`、固定長配列、構造体を使えます。既存7経路（VM・C・LLVM・QBE・WAT・Windows x64直接アセンブリ・Linux x86-64直接アセンブリ）に`u64`まで実装しています。`u64_values.ceru`は全7経路で既知の期待出力と比較しています。[native_values.ceru](native_values.ceru)はWindows/Linuxの混在引数と値の受け渡しを確認する例です。機械語を含むオブジェクトと実行ファイルの生成・実行・観測には、[明示した外部ツールを使う手順](../docs/design/native-code.ja.md)を用意しています。[自前エンコーダ](../docs/design/native-encoder.ja.md)でも同じ言語機能を実行できます。

### 符号付き整数：負数と正数

| 型 | 数値範囲 | サンプル | 確認すること |
| --- | --- | --- | --- |
| `i8` | −128〜127 | [sensor_calibration.ceru](sensor_calibration.ceru) | 小さな負の補正量を、計算前に`i16`へ広げる |
| `i16` | −32768〜32767 | [sensor_calibration.ceru](sensor_calibration.ceru) | 正負の測定値を保持し、集計時には`i32`へ広げる |
| `i32` | −2147483648〜2147483647 | [maximum_subarray.ceru](maximum_subarray.ceru) | 正負の増減を足し、大小を比較する |
| `i64` | −9223372036854775808〜9223372036854775807 | [integer_limits.ceru](integer_limits.ceru) | 最小値・最大値と、桁あふれ前の判定 |

### 符号なし整数：非負の数とビット列

| 型 | 数値範囲 | サンプル | 確認すること |
| --- | --- | --- | --- |
| `u8` | 0〜255 | [color_blending.ceru](color_blending.ceru)、[bit_flags.ceru](bit_flags.ceru) | 色の値と、8個のビットの設定・解除・反転 |
| `u16` | 0〜65535 | [color_blending.ceru](color_blending.ceru) | `u8`の色を加算前に広げ、平均を求めて戻す |
| `u32` | 0〜4294967295 | [population_statistics.ceru](population_statistics.ceru) | 30億前後の値を保持し、集計時には`i64`へ広げる |
| `u64` | 0〜18446744073709551615 | [u64_values.ceru](u64_values.ceru), [packet_counter.ceru](packet_counter.ceru) | 最大値、最上位ビット、符号なし比較・除算、関数・配列・コピー、正確な変換 |

u64の例は次のコマンドで実行できます。

```sh
cargo run -- run examples/u64_values.ceru
```

先頭の出力は順に`u64`、`18446744073709551615`、`9223372036854775808`、`0`です。元の束縛を再代入してもコピーは保持され、最上位ビットも正の数値として扱います。[u64の設計](../docs/design/u64.ja.md)では各生成先の表現も説明しています。

整数の範囲外演算は停止し、折り返しません。型同士は暗黙に混ぜず、`i64(value)`や`convert<i64>(value)`で明示変換します。[integer_conversions.ceru](integer_conversions.ceru)で二つの表記を比較できます。型情報のない整数は`i64`になり、配列の添字も`i64`です。表のビット幅は数値の範囲を表し、現在の生成先では小さい整数も64ビット領域に格納します。

### 浮動小数点：小数と精度

| 型 | 表現 | サンプル | 確認すること |
| --- | --- | --- | --- |
| `f32` | 32ビット浮動小数点 | [floating_point.ceru](floating_point.ceru)、[logistic_map.ceru](logistic_map.ceru) | `f64`との丸め・計算結果の違い |
| `f64` | 64ビット浮動小数点 | [floating_point.ceru](floating_point.ceru)、[small_values.ceru](small_values.ceru) | 小さい値の表示と計算時の丸め。型情報のない浮動小数点は`f64` |

[measurement_statistics.ceru](measurement_statistics.ceru)と[normalized_histogram.ceru](normalized_histogram.ceru)では整数と浮動小数点を行き来します。明示変換は値を保てる場合だけ成功します。通常の浮動小数点演算で生じる丸めとは別の規則です。

### 真偽値と文字列

| 型 | 値 | サンプル | 確認すること |
| --- | --- | --- | --- |
| `bool` | `true` / `false` | [boolean_comparisons.ceru](boolean_comparisons.ceru)、[short_circuit.ceru](short_circuit.ceru) | 比較・否定と、評価を省く短絡評価 |
| `string` | 内容が不変のUTF-8文字列 | [string_values.ceru](string_values.ceru)、[string_byte_length.ceru](string_byte_length.ceru) | 日本語・等値比較・コピーと、文字数とは異なるUTF-8バイト数 |

[string_origins.ceru](string_origins.ceru)は文字列の処理をCerune IRと出自注釈付きLLVMで辿る例です。文字列の内容は不変ですが、mutな束縛への再代入はできます。

### 配列と構造体：型を組み合わせる

| 型の形 | サンプル | 確認すること |
| --- | --- | --- |
| 固定長配列 `[T; N]` | [fixed_arrays.ceru](fixed_arrays.ceru)、[bubble_sort.ceru](bubble_sort.ceru) | 添字、要素の更新、コピー後の独立性 |
| 構造体 `type Point { ... }` | [product-point.ceru](product-point.ceru)、[product_arrays.ceru](product_arrays.ceru) | フィールド・既定値と、構造体を要素にする配列 |
| 入れ子の配列・構造体 | [function_values.ceru](function_values.ceru)、[u64_values.ceru](u64_values.ceru)、[string_lookup.ceru](string_lookup.ceru) | 数値や文字列を組み合わせ、関数へ値として渡す |

`infer`は独立した値の型ではなく、型を推論する指定です。`void`は値を返さない関数の戻り方を表します。[floating_point.ceru](floating_point.ceru)と[functions.ceru](functions.ceru)で確認できます。

### 直和型：選択肢に応じた値

| サンプル | 型・確認すること |
| --- | --- |
| [sum_lookup.ceru](sum_lookup.ceru) | `enum Lookup`：文字列とu64を持つ成功、値を持たない未登録 |
| [sum_divide.ceru](sum_divide.ceru) | `enum Division`：成功値・ゼロ除算・範囲外を値で返して処理を続ける |
| [sum_values.ceru](sum_values.ceru) | 配列・構造体を持つ選択肢、コピー、構築順と分岐内の再代入 |
| [modules/sum_lookup.ceru](modules/sum_lookup.ceru) | 公開enumのimport・構築・網羅的な分岐 |

`cargo run -- run examples/sum_lookup.ceru`は`空\0\r\n\n6\n未登録\n`を出力します。`cargo run -- emit-ir examples/sum_lookup.ceru`で選択肢とタグ、対象コピー、分岐を確認できます。

### コンパイル時定数

| サンプル | 確認すること |
| --- | --- |
| [constants.ceru](constants.ceru) | u64の上限、文字列、f32・構造体・配列の定数、コピーと短絡評価 |
| [modules/constants.ceru](modules/constants.ceru) | 公開した設定値と非公開の補正定数をimportして利用 |

`cargo run -- run examples/constants.ceru`の冒頭は`128`、最大u64、文字列のバイト数`9`です。コピーした配列を`99`に変えても、二つの構造体定数の値は`10`のままです。`cargo run -- emit-ir examples/constants.ceru`で定義式と評価済みの値を確認できます。

### 構造体の更新式

| サンプル | 確認すること |
| --- | --- |
| [product_update.ceru](product_update.ceru) | u64・文字列・配列・入れ子を更新し、元の値が変わらないこと |
| [product_update_order.ceru](product_update_order.ceru) | 元の値を一度だけ評価、フィールドの記述順、既定値を再評価しないこと、短絡・ループ |
| [modules/product_update.ceru](modules/product_update.ceru) | importした型・関数を使った更新 |

```sh
cargo run -- run examples/product_update.ceru
cargo run -- run examples/product_update_order.ceru
```

最初の例では元の番号`9223372036854775808`と更新後の`9223372036854775809`、元の配列要素`10`と更新後の`99`を表示します。後者の冒頭は`base → default → replacement → 2`です。`default`は元の値を作るときだけ出力され、更新やコピーで再実行されません。詳しくは[更新式の設計](../docs/design/product-updates.ja.md)を参照してください。

### 多い引数を組み合わせる

[function_arguments.ceru](function_arguments.ceru)は7引数の入れ子呼び出しと、11引数の値の受け渡しを比較します。

| 型 | 確認すること |
| --- | --- |
| `i64` | `observed(1)`〜`observed(7)`を順に一度だけ実行し、入れ子の呼び出しの後も合計は`28` |
| `u64` | 最大値と最上位ビットを、5個目以降の引数でも保持 |
| `f32`・`f64`・`bool` | 整数と混ぜても`1.5`・`2.5`・`true`を保持し、比較結果は`true` |
| `string` | 日本語・NUL・CR/LFをそのまま渡す |
| 配列・構造体 | 関数内の配列コピーを更新しても元は不変。構造体の戻り値も独立 |

`cargo run -- run examples/function_arguments.ceru`で実行できます。先頭は`引数の評価順`、`1`〜`7`、`28`です。引数数の固定上限はありませんが、個数と型は関数宣言に一致させます。[関数の設計](../docs/design/functions.ja.md)に各経路の配置と検証方法を記載しています。

## 基本と制御

| サンプル | 内容 |
| --- | --- |
| [hello.ceru](hello.ceru) | 整数に名前を付け、足し算の結果を`print`で表示する最初の例 |
| [short_circuit.ceru](short_circuit.ceru) | `&&`・`\|\|`で条件を組み合わせ、不要な割り算・配列参照・関数呼び出しを省略する |
| [conditional.ceru](conditional.ceru) | `if` / `else`とscope |
| [loop_control.ceru](loop_control.ceru) | `while`、`break`、`continue` |
| [for_sum.ceru](for_sum.ceru) | `for`と開始文の再代入 |
| [functions.ceru](functions.ceru) | 型付き関数、parameter、戻り値、`void`関数 |

## データ構造

複数の値をどうまとめ、取り出し、受け渡すかを学ぶ例です。現在は構造体（名前付きproduct type）と固定長配列を使います。

| サンプル | 内容 |
| --- | --- |
| [ring_buffer.ceru](ring_buffer.ceru) | `%`で保存位置を循環させ、直近4件の値と平均を保つ |
| [string_lookup.ceru](string_lookup.ceru) | 文字列をキーに構造体の配列を線形探索し、対応する表示や既定値を返す |
| [product-point.ceru](product-point.ceru) | 点の座標を構造体にまとめる。フィールドの既定値と読み取り |
| [fixed_arrays.ceru](fixed_arrays.ceru) | 固定長配列の要素を読み、合計と線形探索を行う。コピーした配列が独立した値であることも確認する |
| [product_arrays.ceru](product_arrays.ceru) | 構造体を配列に並べ、最も近い点を探す。配列のコピーも確認する |
| [function_values.ceru](function_values.ceru) | 構造体と入れ子の固定長配列を、関数へ値として渡して受け取る |
| [packet_counter.ceru](packet_counter.ceru) | u64の最上位ビット、u8のフラグ、不変の文字列を構造体で渡し、自前エンコーダで実行する |
| [native_values.ceru](native_values.ceru) | u64・整数・小数・文字列・構造体を混在する4引数で渡し、Windows/Linuxの実行と機械語までを辿る |

## 数値計算

| サンプル | 内容 |
| --- | --- |
| [measurement_statistics.ceru](measurement_statistics.ceru) | 整数の測定値から小数の平均・分散を求め、値を変えずに`f32`へ保存する |
| [normalized_histogram.ceru](normalized_histogram.ceru) | 整数の回数を小数の割合へ変換し、保存した割合から元の回数を復元する |
| [square_root.ceru](square_root.ceru) | 手順を展開した平方根の近似 |
| [while_square_root.ceru](while_square_root.ceru) | `while`で繰り返す平方根の近似 |
| [logistic_map.ceru](logistic_map.ceru) | `f32`と`f64`で生まれる計算結果の違い |
| [matrix_vector_product.ceru](matrix_vector_product.ceru) | 入れ子の固定長配列を使った3×3行列と3要素ベクトルの積 |
| [matrix_composition.ceru](matrix_composition.ceru) | 構造体と入れ子配列を関数で受け渡し、2×2行列の合成とベクトル変換を行う |
| [population_statistics.ceru](population_statistics.ceru) | `u32`の大きな値を`i64`へ広げて集計し、平均と最大値を構造体で返す |
| [heat_diffusion.ceru](heat_diffusion.ceru) | 棒の熱が広がる4段階の計算。更新前の配列から次の温度を求める |
| [linear_regression.ceru](linear_regression.ceru) | 5点から直線を学習し、傾き・切片・誤差の変化を追う |

## アルゴリズム

| サンプル | 内容 |
| --- | --- |
| [color_blending.ceru](color_blending.ceru) | `u8`の色を足す前に`u16`へ広げ、平均を求めて混ぜる |
| [sensor_calibration.ceru](sensor_calibration.ceru) | `i16`の測定値を`i8`の補正量で調整し、`i32`へ広げて集計する |
| [maximum_subarray.ceru](maximum_subarray.ceru) | `i32`の増減から連続区間の最大合計を求める。`u32`の位置を添字へ変換する |
| [subset_sum_bits.ceru](subset_sum_bits.ceru) | シフトとビットORで、選んだ重さから作れる合計を一度に求める |
| [euclidean_gcd.ceru](euclidean_gcd.ceru) | ユークリッドの互除法による最大公約数 |
| [fibonacci.ceru](fibonacci.ceru) | Fibonacci数列と複数の値の更新順 |
| [factorial.ceru](factorial.ceru) | `for`による階乗 |
| [collatz.ceru](collatz.ceru) | Collatz予想と条件ごとの状態遷移 |
| [prime_check.ceru](prime_check.ceru) | 試し割りによる素数判定と早期終了 |
| [integer_square_root.ceru](integer_square_root.ceru) | 二分探索による整数平方根 |
| [exponentiation_by_squaring.ceru](exponentiation_by_squaring.ceru) | 繰り返し二乗法による累乗 |
| [pythagorean_triples.ceru](pythagorean_triples.ceru) | 入れ子の`for`によるピタゴラス数の探索 |
| [bubble_sort.ceru](bubble_sort.ceru) | `mut`な固定長配列の要素をその場で入れ替えるバブルソート |
| [xor_neural_network.ceru](xor_neural_network.ceru) | 固定長配列の重みを使う小さなニューラルネットのXOR推論 |
| [coin_change.ceru](coin_change.ceru) | 少ない金額の答えを使い回して最少枚数を求め、使った硬貨も復元する動的計画法 |
| [shortest_paths.ceru](shortest_paths.ceru) | 途中で寄れる町を増やして、全組み合わせの最短距離を求める |

## 計算途中を読む

追加例では、答えに至る途中の数値も`print`しています。出力の順番は各ファイルの日本語コメントで説明しています。

- `coin_change.ceru`: 1円から6円までの最少枚数、その後に使う硬貨の3円と3円。
- `shortest_paths.ceru`: 町0から町3への距離の変化、その後に4行4列の距離表。`-1`は到達できない印です。
- `heat_diffusion.ceru`: 1段階につき5区間の温度を4回、その後に保存しておいた初期の中央温度。
- `linear_regression.ceru`: 学習前の誤差、10回ごとの学習回数・傾き・切片・誤差、最後に新しい入力3の予測値。

直線の学習を試すには、`rate`（1回でどれだけ動かすか）や繰り返し回数を変え、誤差の変化を比較できます。各段階の表現を見るには、たとえば次を実行します。

```powershell
cargo run --quiet -- run examples/linear_regression.ceru
cargo run --quiet -- emit-ir examples/linear_regression.ceru
cargo run --quiet -- emit-bytecode examples/linear_regression.ceru
cargo run --quiet -- emit-c examples/linear_regression.ceru
```

`integer_limits.ceru`は通常は成功します。末尾のコメントアウトした式を有効にすると、桁あふれによる停止と診断位置を確認できます。

## 現在の範囲

これらは、数値、真偽値、文字列、束縛、関数、条件分岐、ループ、名前付きproduct type、固定長配列で表現できるプログラムです。

`mut`な配列では要素を直接更新できるため、in-place sortや配列を更新する動的計画法も表現できます。再帰、動的な長さのcollectionはまだありません。

文字列のサンプルは既存7経路に対応します。LLVMとQBEには明示的なターゲットを渡し、QBEはLinux x86-64、直接アセンブリはWindows x64 / Linux x86-64、WATは出力用ホスト関数を備えたWebAssembly環境で検証します。`emit-ir`と`emit-bytecode`でも型と内容の変換を読めます。

QBE・WAT・直接アセンブリの実行比較は`cargo test --test string_routes`で確認できます。[文字列の設計](../docs/design/strings.ja.md#検証範囲)にツールの指定と検証範囲を記載しています。

例えば、文字列をキーにした検索をCへ変換できます。

```sh
cargo run --quiet -- emit-c examples/string_lookup.ceru -o target/string_lookup.c
clang -std=c11 target/string_lookup.c -o target/string_lookup
```

生成した実行ファイルをBashでは`./target/string_lookup`、Windowsでは`.\target\string_lookup.exe`で実行します。外部のCコンパイラが必要です。

LLVMの場合は、[CLIリファレンス](../docs/reference/cli.ja.md#llvmのターゲット指定)にあるWindows/Linuxのコマンド例を使ってください。`cargo test --test llvm_strings`で、文字列のVM・生成C・生成LLVMの出力をバイト単位で比較できます。`CERUNE_TEST_LLVM_CLANG`と`CERUNE_TEST_CC`を設定すると、指定したコンパイラがない場合もテスト失敗になります。

`cargo test --test c_strings`はC生成物を最適化あり・なしで実行し、VMの結果と比較します。既定のCコンパイラがない環境では実行比較をスキップしますが、`CERUNE_TEST_CC`にコンパイラを指定すると検証を必須にできます。CIではClangを必須とし、AddressSanitizerとUndefinedBehaviorSanitizerでも検査します。

`xor_neural_network.ceru`は、あらかじめ決めた重みを使う推論の例です。`linear_regression.ceru`では、勾配降下法で直線の傾きと切片をデータから学びます。XORニューラルネット自体の学習はまだ含みません。

### 文字列の変換元を辿る

`string_origins.ceru`は関数呼び出し、文字列の内容比較、短絡評価を観察する例です。出力をエスケープ表記にすると`日本語\0\ntrue\nfalse\n`です。`skipped`は出力されません。

`emit-ir`と`emit-llvm --annotate-origins`を並べると、`#7`の内容比較や`#14`の短絡評価からLLVMの呼び出し・分岐へ辿れます。[実行手順と出自注釈](../docs/reference/cli.ja.md#llvmの出自を辿る)を参照してください。

### 文字列のバイト数を確かめる

`string_byte_length.ceru`は`byte_len`を使い、UTF-8の長さ、コピー済みの値、関数・配列・既定値、評価順を確認する例です。

```sh
cargo run -- run examples/string_byte_length.ceru
cargo run -- emit-ir examples/string_byte_length.ceru
cargo run -- emit-llvm examples/string_byte_length.ceru --target x86_64-unknown-linux-gnu --annotate-origins -o string-byte-length.ll
```

出力は順に`0, 9, 3, 2, 3, 4, 7, 3, 9, left, right, 9, false, false, 6, 10`で、各値の後にLFが付きます。`left`と`right`は各一回だけ出力され、`skipped`は出力されません。C・LLVM・QBE・WAT・直接アセンブリも実行して既知の期待バイト列と比較します。小さい入力と各経路の表現は[観測fixture](../tests/fixtures/observation/string-byte-length/)で読めます。
