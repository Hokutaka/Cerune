# QBE Windows ABIの調査（2026-10-03）

このフォルダは、QBE `amd64_win` の浮動小数点スタック引数について行った
処理系の切り分け調査を保存するためのものです。

Ceruneの実行exampleではありません。

QBE upstreamへの問い合わせ本文は [UPSTREAM.md](UPSTREAM.md)、
再現・対照実験のコマンドは [COMMANDS.md](COMMANDS.md) に保存しています。

2026-10-03、QBEのメーリングリストへ問い合わせを送信済みです。
現時点では、upstreamから確認された不具合とは扱いません。

## 結論

**QBE単体の最小ILで現象を再現でき、`amd64_win` のcallee側ABI loweringが強い原因候補として残りました。**

確認できた範囲は次のとおりです。

- Cerune、文字列、所有権、独自の集約ABI、`printf`、可変長引数を除いた5行のQBE ILでも再現する。
- 同じILを `amd64_sysv` と `amd64_win` にそのまま渡して比較できる。
- QBE 1.3と、2026-10-03 UTC時点の公式masterの両方で同じ現象を確認した。
- `amd64_win` ではQBE自体は終了コード0でassemblyを生成するが、浮動小数点比較命令のoperandに整数レジスタが現れ、assemblerが拒否する。
- 失敗はリンクや実行より前のassemble段階で起きる。
- LinuxホストでビルドしたQBEでも、WindowsホストでビルドしたQBEでも同じWindows向けassemblyを生成した。
- ABI loweringのdebug出力では、`s` のparameterが `l` のcopyへ変化している。

この結果からQBE側の調査が妥当と考えていますが、
ILの妥当性とサポート範囲を含む最終判断はupstreamに確認します。

## 版と環境

| 項目 | 確認値 |
| --- | --- |
| QBE 1.3 / `v1.3` | `c0818978acec60ebb6167fade60fb7012cbf20ca` |
| 公式master、2026-10-03 UTC取得 | `e786f06032fefa2e3790d6b1c9e31ed138f475a6` |
| 取得元 | [QBE公式案内](https://c9x.me/compile/code.html) の `git://c9x.me/qbe.git` |
| QBE 1.3 archive SHA-256 | `d587905d620dc5e1d2bfa7c2cc642b9b837aa89a3188c6e37b53d756cf66e320` |
| Linuxホスト | WSL Ubuntu、GCC 9.4.0でQBEをビルド |
| Windowsホスト（初期調査） | MinGW-w64 i686 GCC 8.1.0でQBEをビルド |
| Linux上の検査 | Clang / llvm-mc 10.0.0、GNU as 2.34 |
| Windows上の検査・実行 | Clang 22.1.8、`x86_64-pc-windows-msvc`、MSVC CRT・リンカ |

両QBE版は未改変です。

既存の1.3ビルドに使った47個のC/Hファイルは、
公式v1.3の内容とバイト単位で一致しました。

原因位置を絞るためのクラス変更実験だけは、
別の一時ソースコピーで行いました。
Cerune本体やCIが使用するQBEには適用していません。

## 最小IL

[callee-only.ssa](inputs/callee-only.ssa):

```text
export function w $check(l %a, l %b, l %c, l %d, s %value) {
@start
    %ok =w ceqs %value, s_1.5
    ret %ok
}
```

このILにはfrontend runtime、aggregate、varargs、allocation、external callはありません。

同じ入力をそのまま両targetに渡します。

```sh
qbe -t amd64_sysv -o linux.s callee-only.ssa
qbe -t amd64_win -o windows.s callee-only.ssa

cc -c linux.s -o linux.o
clang --target=x86_64-pc-windows-msvc -c windows.s -o windows.obj

qbe -t amd64_win -d PA callee-only.ssa 2> windows-lowering.txt
```

`amd64_sysv` では次のようにXMM registerが使われます。

```asm
ucomiss ".Lfp0"(%rip), %xmm0
```

`amd64_win` では次のassemblyが生成されます。

```asm
movq 40(%rsp), %rax
ucomiss "Lfp0"(%rip), %rax
```

Windows Clang 22、およびLinux上のClang 10 / llvm-mcによるCOFF生成は、
この `ucomiss` operandを不正として拒否しました。

GNU `as --64 windows.s -o syntax.o` でも、

```text
operand type mismatch for 'ucomiss'
```

となります。

GNU asはWindows object生成の確認ではなく、
x86-64命令operandの独立した構文検査として使用しています。

失敗するWindowsケースはassemble段階で停止するため、
リンク・実行には到達しません。

[保存した生成ASMと診断](observed/)では、
パスを短縮し、テキストの改行をLFへ統一し、末尾の空行を除いています。
命令、定数、診断内容は変更していません。

1.3とmasterで保存した同名の最小ケースのassemblyは一致しました。

## ABI loweringで観測したこと

`-d PA` の出力では、parameterのclassが次のように変化します。

```text
After parsing:
    %value =s par
    %ok =w ceqs %value, s_1.500000

After ABI lowering:
    %value =l copy S-12
    ...
    %ok =w ceqs %value, s_1.500000
```

parse直後には `%value` は `s` ですが、
Windows ABI lowering後には `l` のcopyとして表現されています。

一方、後続の `ceqs` は `%value` を引き続きsingle-precision floating-point値として使用します。

最終的なassemblyではこの差が、

```asm
movq 40(%rsp), %rax
ucomiss "Lfp0"(%rip), %rax
```

として現れます。

公式1.3とmasterの `amd64/winabi.c` では、
`APS_InlineOnStack` の非aggregate側に次の処理があります。

```c
emit(Ocopy, Kl, instr->to, SLOT(-slot_offset), R);
```

masterの独立した一時ソースコピーで、この1か所だけ

```c
Kl
```

を

```c
instr->cls
```

へ変更すると、

```text
%value =s copy S-12
```

となり、assemblyも

```asm
movss 40(%rsp), %xmm0
```

へ変化しました。

この実験では、f32 / f64 の第4・第5引数と、
QBE caller → C calleeの小さいcontrol caseがWindowsで終了コード0になりました。

ただし、これは原因位置を絞るための実験です。

aggregate、varargs、upstreamの全テストを含めた修正の十分性は確認しておらず、
正式なpatch案とは扱いません。

## 手元でのWindows再確認

2026-10-03、公式 `qbe-1.3.tar.xz` をWindows上で改めて取得し、
SHA-256が次の公式値と一致することを確認しました。

```text
d587905d620dc5e1d2bfa7c2cc642b9b837aa89a3188c6e37b53d756cf66e320
```

そのarchiveからMSYS2 / MinGW64上でQBE 1.3をビルドし、
最小 `callee-only.ssa` を手動で再実行しました。

`amd64_win` では次のassemblyを確認しました。

```asm
movq 40(%rsp), %rax
ucomiss "Lfp0"(%rip), %rax
```

同じWindows環境のGNU assemblerは、

```text
Error: operand type mismatch for 'ucomiss'
```

として拒否しました。

同じ実行で取得したABI lowering dumpでも、

```text
After parsing:
    %value =s par

After ABI lowering:
    %value =l copy S-12
```

を確認しました。

さらに、同じQBE binaryと同じILを `amd64_sysv` に渡した場合は、

```asm
ucomiss ".Lfp0"(%rip), %xmm0
```

が生成されました。

[![Windows host manual reproduction](observed/qbe-win64-manual-check.png?v=20261003)](observed/qbe-win64-manual-check.png)

*クリックすると原寸で表示できます。*

この手動確認は、upstream問い合わせの中核となる最小再現を
作者自身のWindows環境で再確認したものです。

問い合わせに含めた全control caseを手動で再実行したものではありません。

## 対照実験

以下はQBE 1.3とmasterで同じ結果です。

| 入力・条件 | `amd64_sysv` | `amd64_win` |
| --- | --- | --- |
| [f32の第4引数](inputs/f32-arg4.ssa) | 実行・終了0 | 実行・終了0 |
| [f32の第5引数](inputs/f32-arg5.ssa) | 実行・終了0 | `ucomiss ..., %rax` をassemble拒否 |
| [f64の第4引数](inputs/f64-arg4.ssa) | 実行・終了0 | 実行・終了0 |
| [f64の第5引数](inputs/f64-arg5.ssa) | 実行・終了0 | `ucomisd ..., %rax` をassemble拒否 |
| [9個のf32](inputs/f32-nine-floats.ssa) / [f64](inputs/f64-nine-floats.ssa) | スタック引数を含め実行・終了0 | assemble拒否 |
| QBE caller → C callee（動的に得た第5引数） | f32・f64とも終了0 | f32・f64とも終了0 |
| [同等のC](inputs/equivalent.c)をWindows Clangで生成 | — | XMMを使い実行・終了0 |

Windows側でassemble拒否となるケースは、
実行結果が異なるのではなく、実行ファイルの生成前に停止します。

QBE caller → C calleeの比較には、

- [f32-caller.ssa](inputs/f32-caller.ssa)
- [f32-callee.c](inputs/f32-callee.c)
- [f64-caller.ssa](inputs/f64-caller.ssa)
- [f64-callee.c](inputs/f64-callee.c)

を使用しました。

C側では `volatile` 値を返す関数から値を取得し、
単なる定数の特殊処理だけを検査しないようにしています。

実行可能なILでは、比較結果1に対して `1 - result` を返し、
正常時の終了コードを0にしています。

stdout / stderrを使用しないため、
文字コードやCRTの改行処理はこの比較に関与しません。

## ILの妥当性と責任範囲

[QBE IL文書](https://c9x.me/compile/doc/il.html)のbase type、
関数引数、比較、callの規則を照合しました。

最小例は固定個数の通常引数で、
`s` / `d` の値を同じ型として比較し、`w` を返します。

呼び出しを含むcontrol caseでも、
関数定義とcallの引数型を一致させ、戻り値を受け取っています。

この範囲では仕様違反を見つけていません。

ただし、parserやSSA検査を通ることだけを
ILの妥当性の証明とは扱いません。
そのためupstreamにもILの使い方とサポート範囲を含めて確認しています。

元のCerune `function_arguments.ceru` から生成したSSAでも、
問題の関数定義とcallは同じ12引数の型列を持ちます。

集約戻り値の保存先は先頭の明示的な `l` 引数で、
後方の `s` / `d` を受け渡しています。

Linux向けに保存した同じSSAをWindows targetへlowerすると、
同じ関数内で

```asm
ucomiss ..., %r11
ucomisd ..., %rax
```

が生成されました。

この試験では、Linux用runtimeを含むプログラム全体を
Windowsでリンクしたわけではありません。

その後、Cerune runtimeや集約ABIを除去した最小QBE ILでも
同じ現象が残ることを確認しました。

したがって、この調査はCeruneが生成するすべてのQBE ILの妥当性を
証明するものではありません。

[Windows x64 ABI](https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170)
では、第5引数以降はスタック上に配置されます。

今回の最小例でWindowsとSysVの引数配置が異なること自体は正常です。

問題候補は、Windows側でスタックから読み込まれた
浮動小数点parameterが浮動小数点classを保持していない点です。

9個の浮動小数点引数を使うcontrol caseでは、
SysV側でもスタック引数が発生しますが正常に実行できました。

## 別件：`inf` 表記の読み取り

[nonfinite-spelling.ssa](inputs/nonfinite-spelling.ssa) の `d_inf` は、
Linuxホスト版QBEでは両targetとも読み取れました。

一方、MinGW GCC 8でビルドしたWindowsホスト版QBEでは、
両targetとも読み取りエラーになりました。

この結果はQBE 1.3とmasterで同じです。

QBEを除いた [scanf-inf.c](inputs/scanf-inf.c) でも、
`sscanf("inf", "%lf", ...)` の結果に処理系差がありました。

| C処理系 | 変換数 / 正の巨大値判定 |
| --- | --- |
| Windows MinGW GCC 8.1.0 | 0 / 0 |
| Windows Clang 22.1.8 + MSVC CRT | 1 / 1 |
| Linux GCC 9.4.0 | 1 / 1 |

QBEの `parse.c` はこの入力の読み取りに `fscanf` を使用します。

`d_inf` が、QBE文書で明示されている通常の科学表記と
同じ移植性保証を持つとは判断していません。

[ビット定数版](inputs/nonfinite-bits.ssa) は
確認した全組み合わせで読み取れました。

この件は `amd64_win` のcode generation問題とは分離し、
今回のupstream問い合わせには含めていません。

Ceruneが非有限値について文書化されたビット定数表現を使用する方針には、
このホストCRT差も根拠の一つとしてあります。

## 現在の扱い

- QBE upstreamのメーリングリストへ、2026-10-03に問い合わせを送信済みです。
- 問い合わせ本文は [UPSTREAM.md](UPSTREAM.md) に保存しています。
- upstreamからの確認前なので、現時点では「QBEの確認済みbug」とは表現しません。
- PR #84は未マージです。
- Cerune本体やCIのQBEへ、調査中の `Kl -> instr->cls` 変更は適用していません。
- Windows上で最小再現の中核は作者自身でも手動再確認しました。
- upstreamから返答やpatchがあれば、最小reproducerとCerune側の関連testで再検証します。