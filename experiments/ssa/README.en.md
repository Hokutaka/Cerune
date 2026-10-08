# SSA representation API example

[日本語](README.md) · [Design](../../docs/design/mir-ssa.en.md)

This Rust API example validates hand-authored SSA and displays it alongside original MIR. Automatic SSA construction from Cerune source and SSA execution are not implemented.

```sh
cargo run --quiet --example ssa_model
cargo test --test mir_ssa
```

It prints the following fixtures.

| Fixture | What to inspect |
| --- | --- |
| branch | Values arriving at a merge block along distinct edges |
| parallel-loop | Swapped values on the backedge; retained unreachable MIR |
| residual-slots | Index checks before array stores; string slots; Japanese, NUL, CR/LF, and non-normalized text |

`parallel-loop` is an infinite loop used for structural validation and is not executed. Printing it does not establish correct execution of parallel transfers. The runnable Cerune baseline remains [ssa_values.ceru](../../examples/ir_stages/ssa_values.ceru).

`vN` identifies an SSA value; `slotN` identifies residual original-MIR storage. Follow `original-local`, `original-block`, and `mir-iN` to inspect the original definitions. Observation text separates `original-mir` and `ssa`; unreachable records refer to original MIR. Validation does not mutate snapshots, and printing rejects invalid inputs too.

Checks cover definitions, dominance, edge types, slot initialization, preceding index checks, and origin mappings. They do not prove equivalence of operation contents/edge selection or heap lifetime safety.
