# QBE Windows ABIの調査（2026-10-03）

このフォルダは処理系の切り分け資料です。Ceruneの実行exampleではありません。上流への送信はしていません。送付候補の英文は[UPSTREAM.md](UPSTREAM.md)、再現手順は[COMMANDS.md](COMMANDS.md)です。

## 結論

**QBE単体の最小ILで再現し、上流にILの妥当性も含めて確認する価値があります。** 観測結果は`amd64_win`のcallee側ABI loweringを強い原因候補として示します。ただし、本家の確認を受けた不具合とは扱いません。

- Cerune、文字列、所有権、独自の集約ABI、printf、可変長引数を除いた5行のILでも再現しました。
- 同じファイルを`amd64_sysv`と`amd64_win`に渡しました。入力の書き換えはありません。
- 1.3と調査時点の公式masterの両方で再現しました。
- QBEの終了コードは0ですが、Windows用生成ASMの浮動小数点命令に整数レジスタが現れ、assemblerが拒否します。リンクより前の失敗です。
- Linuxホスト版でもWindowsホスト版でも同じASMを生成しました（比較時はASMテキストのCRLF/LFだけを揃えました）。

## 版と環境

| 項目 | 確認値 |
| --- | --- |
| QBE 1.3 / `v1.3` | `c0818978acec60ebb6167fade60fb7012cbf20ca` |
| 公式master、2026-10-03 UTC取得 | `e786f06032fefa2e3790d6b1c9e31ed138f475a6` |
| 取得元 | [公式案内](https://c9x.me/compile/code.html)の `git://c9x.me/qbe.git` |
| 1.3 archive SHA-256 | `d587905d620dc5e1d2bfa7c2cc642b9b837aa89a3188c6e37b53d756cf66e320` |
| Linuxホスト | WSL Ubuntu、GCC 9.4.0でQBEをビルド |
| Windowsホスト | MinGW-w64 i686 GCC 8.1.0でQBEをビルド |
| Linux上の検査 | Clang / llvm-mc 10.0.0、GNU as 2.34 |
| Windows上の検査・実行 | Clang 22.1.8、`x86_64-pc-windows-msvc`、MSVC CRT・リンカ |

両QBE版は未改変です。既存の1.3ビルドに使った47個のC/Hファイルは、公式v1.3の内容とバイト単位で一致しました。原因を探るためのクラス変更実験だけは、別の一時ソースコピーで行いました。Cerune本体やCIが使うQBEには適用していません。

## 最小ILと同一入力の比較

[callee-only.ssa](inputs/callee-only.ssa):

```text
export function w $check(l %a, l %b, l %c, l %d, s %value) {
@start
    %ok =w ceqs %value, s_1.5
    ret %ok
}
```

入力フォルダを作業ディレクトリにし、`qbe`を比較する版の実行ファイルに置き換えます。

```sh
qbe -t amd64_sysv -o linux.s callee-only.ssa
qbe -t amd64_win -o windows.s callee-only.ssa
cc -c linux.s -o linux.o
clang --target=x86_64-pc-windows-msvc -c windows.s -o windows.obj
qbe -t amd64_win -d PA callee-only.ssa 2> windows-lowering.txt
```

Linux生成は`ucomiss ...,%xmm0`。Windows生成は以下です。

```asm
movq 40(%rsp), %rax
ucomiss "Lfp0"(%rip), %rax
```

Windows Clang 22とLinux Clang 10 / llvm-mcのCOFF生成はいずれも`invalid operand for instruction`で失敗しました。GNU `as --64 windows.s -o syntax.o`も`operand type mismatch for 'ucomiss'`で拒否しました。GNU asはELFの命令構文検査として使ったもので、Windowsのリンク・実行検証とは区別します。

[記録した生成ASMと診断](observed/)ではパスを短くし、テキストの改行をLFに統一し、末尾の空行を除いています。命令、定数、エラー内容は変更していません。両版の同名最小ケースのASMは一致しました。

## 対照実験

以下は1.3とmasterで同じ結果です。Windowsの「assemble拒否」は未実行であり、実行結果の不一致と混同しません。

| 入力・条件 | amd64_sysv | amd64_win |
| --- | --- | --- |
| [f32の第4引数](inputs/f32-arg4.ssa) | 実行・終了0 | 実行・終了0 |
| [f32の第5引数](inputs/f32-arg5.ssa) | 実行・終了0 | `ucomiss ..., %rax`をassemble拒否 |
| [f64の第4引数](inputs/f64-arg4.ssa) | 実行・終了0 | 実行・終了0 |
| [f64の第5引数](inputs/f64-arg5.ssa) | 実行・終了0 | `ucomisd ..., %rax`をassemble拒否 |
| [9個のf32](inputs/f32-nine-floats.ssa) / [f64](inputs/f64-nine-floats.ssa) | スタック引数でも実行・終了0 | assemble拒否（Linux上のCOFF検査） |
| QBE caller → C callee（動的に得た第5引数） | f32・f64とも終了0 | f32・f64とも終了0 |
| [同等のC](inputs/equivalent.c)をWindows Clangで生成 | — | XMMを使い実行・終了0 |

呼び出す側の比較には[f32-caller.ssa](inputs/f32-caller.ssa)と[f32-callee.c](inputs/f32-callee.c)、[f64版](inputs/f64-caller.ssa)と[C](inputs/f64-callee.c)を使いました。Cのvolatile値を返す関数から値を得て、単なる定数の特殊処理だけを検査しないようにしています。

実行可能なILの期待値は、比較結果1を`1 - result`で終了コード0にするものです。stdout/stderrを使わないため、文字コードやCRTの改行処理は関与しません。

## ILの妥当性と責任範囲

[QBE IL文書](https://c9x.me/compile/doc/il.html)のbase type、関数引数、比較、callの規則を照合しました。最小例は固定個数の通常引数で、`s` / `d`の値を同じ型で比較し、`w`を返します。呼び出し付きの例も定義とcallの引数型を一致させ、戻り値を受け取っています。この範囲で仕様違反は見つけていません。parserとSSA検査を通ることだけを正当性の証明とはしていません。

元のCerune `function_arguments.ceru`のSSAでも、問題の関数定義とcallは同じ12引数の型列を持ちます。集約戻り値の保存先は先頭の明示的な`l`引数で、後方の`s` / `d`を受け渡しています。Linux向けに保存済みの同じSSAをWindowsへlowerすると、同じ関数内で`ucomiss ..., %r11` / `ucomisd ..., %rax`が生成されました。この試験ではLinux用runtimeを含む全プログラムをWindowsでリンクしません。最小例でruntimeと集約ABIを除去しても現象が残ることを別に確認しました。これはCeruneの全ILの妥当性を証明するものではありません。

[Windows x64 ABI](https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170)では第5引数以降はスタックです。SysVではこの例の浮動小数点引数はXMMに置かれます。配置の差そのものは正常です。問題候補は、Windowsのスタックから読んだ値が浮動小数点クラスを失う点です。9個の浮動小数点引数ではSysVもスタックを使い、正常でした。

## loweringで観測したこと

`-d PA`の表示は次のように変わりました。

```text
After parsing:      %value =s par
After ABI lowering: %value =l copy S-12
                    %ok =w ceqs %value, s_1.500000
```

公式両版の`amd64/winabi.c`の`APS_InlineOnStack`内（非aggregate側、679行）には`emit(Ocopy, Kl, instr->to, SLOT(-slot_offset), R);`があります。

masterの独立した一時コピーで、この1か所だけ`Kl`から`instr->cls`へ変える実験を行うと、`%value =s copy S-12`、`movss 40(%rsp), %xmm0`になりました。f32・f64の第4/5引数、QBE caller → C calleeの6実行例はWindowsで終了0でした。

これは原因位置を絞る実験です。aggregate、可変長引数、上流の全テストを含む修正の十分性は未検証で、正式なパッチ案とはしません。上流には未改変版での最小再現を中心に確認します。

## 別件：inf表記の読み取り

[nonfinite-spelling.ssa](inputs/nonfinite-spelling.ssa)の`d_inf`は、Linuxホスト版QBEでは両ターゲットとも読め、上記のMinGW GCC 8でビルドしたWindowsホスト版では**両ターゲットとも**読み取りエラーになりました。両QBE版で同じです。

QBEを除いた[scanf-inf.c](inputs/scanf-inf.c)でも、`sscanf("inf", "%lf", ...)`の結果は次のとおりでした。

| C処理系 | 変換数 / 正の巨大値判定 |
| --- | --- |
| Windows MinGW GCC 8.1.0 | 0 / 0 |
| Windows Clang 22.1.8 + MSVC CRT | 1 / 1 |
| Linux GCC 9.4.0 | 1 / 1 |

QBEの`parse.c`はこの入力で`fscanf`を使います。`d_inf`は文書で明示された通常の科学表記と同じ保証があるとは判断しません。[ビット定数版](inputs/nonfinite-bits.ssa)は全組み合わせで読み取れました。この件は`amd64_win`の生成問題とは分け、今回の上流確認には含めません。ホストCRTの表記差としてCeruneが文書化されたビット定数を出す方針には根拠があります。

## 現在の扱い

- 上流への確認用英文・最小入力・生成ASM・診断を用意しました。**未送信**です。
- PR #84は未マージです。今回、Ceruneの実行実装と暫定的なビット受け渡し処理は変更していません。
- 一次資料との照合と実験からはQBE側の調査が妥当ですが、最終判断はILの使い方・サポート範囲を含めて上流に確認します。
