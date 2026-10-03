# Dynamic array examples

[日本語](README.md)

Run with IR Executor, VM, generated C, or LLVM. QBE, WAT, ASM, and native objects are pending.

| Example | Checks |
| --- | --- |
| [readings.ceru](readings.ceru) | Return a range of records, edit a copy, and total its values |
| [window.ceru](window.ceru) | Choose a runtime-sized range; update the returned array independently |
| [copy.ceru](copy.ceru) | Independent copies, ranges and emptiness, updates, display/equality/iteration |
| [nested.ceru](nested.ceru) | Nesting, string NUL/CR/LF, functions/enums/match, reassignment during iteration |

```sh
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru
cargo run --quiet -- run-vm examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-ir examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-bytecode examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-c examples/dynamic_arrays/window.ceru -o window.c
clang -std=c11 window.c -o window
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru --array-heap-limit 24
```

The final command intentionally stops: the original three elements use 24 bytes, leaving no storage for `saved`. The default budget succeeds. Generated IR exposes copy loops, allocation, and release.

Build generated C with an external C compiler, then run `./window` on Linux or `.\window.exe` on Windows. Copy/release loops remain visible in both IR and generated C.

Generate and execute LLVM (Linux x86-64):

```sh
cargo run --quiet -- emit-llvm examples/dynamic_arrays/readings.ceru --target x86_64-unknown-linux-gnu --annotate-origins -o readings.ll
clang readings.ll -o readings
./readings
```

On Windows, use target `x86_64-pc-windows-msvc`, then `clang readings.ll -o readings.exe` and `.\readings.exe`. The selected range stays `[{valid: false, value: 0}, {valid: true, value: 20}]`; the edited copy contains 15 and 20 and prints a total of 35.
