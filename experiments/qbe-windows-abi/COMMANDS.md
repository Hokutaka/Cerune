# Reproduction commands

Start in `experiments/qbe-windows-abi`. Set `QBE` to an absolute path to an **unmodified** tested QBE binary. All generated files go under the repository's ignored `target` directory.

## Build the two Linux-host versions

The official repository is `git://c9x.me/qbe.git`. In separate checkouts under `target`, use these exact revisions:

```sh
git checkout --detach c0818978acec60ebb6167fade60fb7012cbf20ca # v1.3
make CC=cc CFLAGS='-std=c99 -O2' -j2
# In a different checkout:
git checkout --detach e786f06032fefa2e3790d6b1c9e31ed138f475a6 # observed master
make CC=cc CFLAGS='-std=c99 -O2' -j2
```

## Minimal assembly rejection, runnable on Linux

```sh
out=../../target/qbe-abi-repro
mkdir -p "$out"
"$QBE" -t amd64_sysv -o "$out/linux.s" inputs/callee-only.ssa
"$QBE" -t amd64_win -o "$out/windows.s" inputs/callee-only.ssa
cc -c "$out/linux.s" -o "$out/linux.o"
clang --target=x86_64-pc-windows-msvc -c "$out/windows.s" -o "$out/windows.obj"
# Expected observation: the last command fails at ucomiss.
llvm-mc --triple=x86_64-pc-windows-msvc --filetype=obj "$out/windows.s" -o "$out/windows-mc.obj"
as --64 "$out/windows.s" -o "$out/windows-syntax.o"
# The as command is an ELF instruction check, not a Windows object/link test.
"$QBE" -t amd64_win -d PA inputs/callee-only.ssa 2> "$out/windows-lowering.txt"
```

## Full SysV execution and C callee control

```sh
"$QBE" -t amd64_sysv -o "$out/f32-sysv.s" inputs/f32-arg5.ssa
cc "$out/f32-sysv.s" -o "$out/f32-sysv"
"$out/f32-sysv"
echo $? # expected 0
"$QBE" -t amd64_sysv -o "$out/f32-caller-sysv.s" inputs/f32-caller.ssa
cc "$out/f32-caller-sysv.s" inputs/f32-callee.c -o "$out/f32-caller-sysv"
"$out/f32-caller-sysv"
echo $? # expected 0
```

Repeat with `f64` instead of `f32`. The `arg4` and `nine-floats` files are additional controls, built like `arg5`.

## Windows-target generation and execution

Generate on either host using the explicit QBE target:

```sh
"$QBE" -t amd64_win -o "$out/f32-win.s" inputs/f32-arg5.ssa
"$QBE" -t amd64_win -o "$out/f32-caller-win.s" inputs/f32-caller.ssa
```

With those files accessible on Windows, run from the experiment folder in PowerShell:

```powershell
$out = '../../target/qbe-abi-repro'
clang --target=x86_64-pc-windows-msvc "$out/f32-win.s" -o "$out/f32-win.exe"
# Expected observation: assembly fails; do not claim a linked program ran.
clang --target=x86_64-pc-windows-msvc "$out/f32-caller-win.s" inputs/f32-callee.c -o "$out/f32-caller-win.exe"
& "$out/f32-caller-win.exe"
$LASTEXITCODE # expected 0
clang --target=x86_64-pc-windows-msvc inputs/equivalent.c -o "$out/equivalent.exe"
& "$out/equivalent.exe"
$LASTEXITCODE # expected 0
```

Repeat for f64. The original investigation's native Windows QBE host was built with GCC 8.1.0 from MinGW-w64 i686. Using a Linux-host QBE to generate the Windows assembly avoids requiring that host setup and reproduces the same instruction rejection.

## Separate scanf control

```sh
cc inputs/scanf-inf.c -o "$out/scanf-inf"
"$out/scanf-inf"
```

The Linux and Windows Clang/MSVC builds print `matched=1 positive_large=1`. The investigated Windows MinGW GCC 8.1.0 build prints `matched=0 positive_large=0`. This control concerns the host CRT, not the amd64_win calling convention.
