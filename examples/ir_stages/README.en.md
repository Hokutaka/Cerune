# Observing IR stages

[日本語](README.md)

| Example | What to observe | Output |
| --- | --- | --- |
| [native_calls.ceru](native_calls.ceru) | MIR→Native, seven mixed arguments, continue/break, main call | Header, arguments for i=0 and 2, result `4` |
| [owned_values.ceru](owned_values.ceru) | Independent dynamic-array arguments, immutable strings, cleanup through continue | Original array, decorated array, `["反復"]` |
| [control_flow.ceru](control_flow.ceru) | Short circuit skips a call; for-continue enters the update and break enters the exit | Two lines: `2`, `4` |

Run the same source and inspect both representations with these commands.

```sh
cargo run --quiet -- run examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/owned_values.ceru
cargo run --quiet -- run-vm examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/native_calls.ceru
cargo run --quiet -- emit-mir examples/ir_stages/native_calls.ceru -o target/native_calls.mir.txt
cargo run --quiet -- emit-asm examples/ir_stages/native_calls.ceru --target x86_64-unknown-linux-gnu --annotate-origins -o target/native_calls.s
cargo run --quiet -- emit-obj examples/ir_stages/native_calls.ceru --target x86_64-unknown-linux-gnu --annotate-origins -o target/native_calls.o
cargo run --quiet -- emit-ir examples/ir_stages/control_flow.ceru
cargo run --quiet -- emit-mir examples/ir_stages/control_flow.ceru -o target/control_flow.mir.txt
```

`native_calls` prints the header `MIR → Native`, then `0, 18446744073709551615, 7, 9, 4`, followed by `2, 18446744073709551615, 7, 9, 4`, one value per line. ASM `cerune-mir` annotations point back to MIR block/instruction IDs. For Windows output, select `x86_64-pc-windows-msvc` instead. Emitting an object does not link or execute it.

In `control_flow`, at `i=0`, `accept` is skipped. At `i=1`, continue enters the update. Only `i=2` calls `accept` and prints `2`. At `i=3`, break skips the update. The final total is `4`.

In MIR, `bbN` identifies a block, `%N` a typed local/temporary, and `iN` an instruction within a function. Follow jump/branch and `derived=short-circuit-rhs`, `derived=for-update`, `derived=loop-exit` to inspect control flow. Each operation retains `hir=#N source=N bytes=A..B` to locate its input IR and source span. Emitting MIR does not execute the program.

For array copies and allocation failure, see [lowering_order.ceru](../dynamic_arrays/lowering_order.ceru). `run-mir` uses the [independent MIR executor](../../docs/design/mir-executor.en.md). [Native now consumes MIR](../../docs/design/native-mir.en.md). SSA and optimization remain unimplemented. See the [stage design](../../docs/design/ir-stages.en.md) for types and validation limits.
