# Dynamic array examples

[日本語](README.md)

Run with IR Executor or VM. C, LLVM, QBE, WAT, ASM, and native objects are pending.

| Example | Checks |
| --- | --- |
| [copy.ceru](copy.ceru) | Independent copies, ranges and emptiness, updates, display/equality/iteration |
| [nested.ceru](nested.ceru) | Nesting, string NUL/CR/LF, functions/enums/match, reassignment during iteration |

```sh
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru
cargo run --quiet -- run-vm examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-ir examples/dynamic_arrays/copy.ceru
cargo run --quiet -- emit-bytecode examples/dynamic_arrays/copy.ceru
cargo run --quiet -- run examples/dynamic_arrays/copy.ceru --array-heap-limit 24
```

The final command intentionally stops: the original three elements use 24 bytes, leaving no storage for `saved`. The default budget succeeds. Generated IR exposes copy loops, allocation, and release.
