# SSA construction and representation API example

[日本語](README.md) · [Design](../../docs/design/mir-ssa.en.md)

This Rust API example builds non-optimized MIR from Cerune source, retains that snapshot, and constructs SSA. It does not execute the program. Direct SSA execution and public CLI support follow later.

```sh
cargo run --quiet --example ssa_model -- examples/ir_stages/ssa_values.ceru
cargo run --quiet --example ssa_model -- examples/ir_stages/owned_values.ceru
cargo test --test ssa_construction --test mir_ssa
```

Without arguments, `cargo run --quiet --example ssa_model` validates and prints these hand-authored fixtures.

| Fixture | What to inspect |
| --- | --- |
| branch | Values arriving at a merge block along distinct edges |
| parallel-loop | Swapped values on the backedge; retained unreachable MIR |
| residual-slots | Index checks before array stores; string slots; Japanese, NUL, CR/LF, and non-normalized text |

`parallel-loop` is an infinite loop used for structural validation and is not executed. The runnable Cerune baseline is [ssa_values.ceru](../../examples/ir_stages/ssa_values.ceru); IR/MIR/VM print `14 / 16 / 20 / 10`.

Output separates `original-mir` and `ssa`. The former contains unchanged original MIR; in the latter, `vN` identifies an SSA value and `slotN` identifies residual original storage. Follow `original-local`, `original-block`, and `mir-iN` back to original definitions. Unreachable blocks remain as references to original MIR records. `construction=scalar-ssa-v1` marks automatic construction; `manual` marks hand-authored input. Neither performs optimization.

Structural validation checks definitions, dominance, edge types, slot initialization, preceding index checks, and origins. Construction tests check original snapshots, operations, edges, origins, and determinism across all runnable examples. A separate data-flow check verifies that reads and edge arguments use the latest definitions, rejecting well-typed stale substitutions too. These checks are not formal proofs of SSA execution or heap lifetimes.
