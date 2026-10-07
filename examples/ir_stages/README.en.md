# Observing IR stages

[日本語](README.md)

| Example | What to observe | Output |
| --- | --- | --- |
| [owned_values.ceru](owned_values.ceru) | Independent dynamic-array arguments, immutable strings, cleanup through continue | Original array, decorated array, `["反復"]` |
| [control_flow.ceru](control_flow.ceru) | Short circuit skips a call; for-continue enters the update and break enters the exit | Two lines: `2`, `4` |

Run the same source and inspect both representations with these commands.

```sh
cargo run --quiet -- run examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/control_flow.ceru
cargo run --quiet -- run-mir examples/ir_stages/owned_values.ceru
cargo run --quiet -- run-vm examples/ir_stages/control_flow.ceru
cargo run --quiet -- emit-ir examples/ir_stages/control_flow.ceru
cargo run --quiet -- emit-mir examples/ir_stages/control_flow.ceru -o target/control_flow.mir.txt
```

At `i=0`, `accept` is skipped. At `i=1`, continue enters the update. Only `i=2` calls `accept` and prints `2`. At `i=3`, break skips the update. The final total is `4`.

In MIR, `bbN` identifies a block, `%N` a typed local/temporary, and `iN` an instruction within a function. Follow jump/branch and `derived=short-circuit-rhs`, `derived=for-update`, `derived=loop-exit` to inspect control flow. Each operation retains `hir=#N source=N bytes=A..B` to locate its input IR and source span. Emitting MIR does not execute the program.

For array copies and allocation failure, see [lowering_order.ceru](../dynamic_arrays/lowering_order.ceru). `run-mir` uses the [independent MIR executor](../../docs/design/mir-executor.en.md). Native migration, SSA and optimization remain unimplemented. See the [stage design](../../docs/design/ir-stages.en.md) for types and validation limits.
