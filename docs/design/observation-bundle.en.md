# Observation bundle

[日本語](observation-bundle.ja.md)

## Purpose and scope

The first implementation of [#60](https://github.com/Hokutaka/Cerune/issues/60) saves HIR, non-SSA MIR, and annotated Native ASM from one frontend invocation. The manifest is an index, not a new IR.

Use `cerune observe <file> [--ssa] --target <triple> -o <new-directory>`. An explicit Windows/Linux x86-64 target is required. Existing heap-budget options apply.

| File | Contents |
| --- | --- |
| `manifest.json` | `cerune-observation-v1`, Cerune version, target, both heap budgets, optimization passes (currently empty), no-execution status, relative artifact paths |
| `sources.json` | File names, exact text, and SourceIds in the existing `emit-sources` format |
| `program.ceir` | Completed HIR |
| `program.mir.txt` | MIR lowered and validated once from the same HIR |
| `program.origins.s` | ASM from that MIR, annotated with HIR origins and MIR→LIR correspondence |

## Selecting SSA

`--ssa` constructs SSA from the same non-optimized MIR and adds two files. The original four artifacts remain byte-identical to the default bundle.

| Added file | Contents |
| --- | --- |
| `program.ssa.txt` | Same observation text as `emit-mir --ssa`, with separate complete original-MIR and SSA sections |
| `program.ssa-map.txt` | `Cerune SSA mapping v0.1`: functions, parameters, values/slots, blocks, instructions, terminators, edge transfers, and retained unreachable records |

Value IDs are scoped by function; instruction indexes by block. Record then/else separately even with the same target, identifying incoming values, destination arguments, and original locals. Original instruction IDs and origins refer back to the original MIR snapshot. The mapping is neither a semantic-preservation proof nor a loading format.

SSA manifests use `cerune-observation-v2`; the default retains existing v1 output.

| v2 additions | Contents |
| --- | --- |
| `transformations` | Zero-based order, `kind=representation`, versioned `pass=scalar-ssa-v1`, `options={}`, artifact keys for input `mir`, output `ssa`, and mapping `ssa_mapping` |
| `artifact_inputs` | Each generated artifact's input. Currently `assembly` comes from `mir`, not SSA |
| Additional `artifacts` keys | `ssa` and `ssa_mapping`, referencing the files above |

`optimization_passes` stays empty and `executed` stays false. SSA→MIR/Native integration follows later; currently the bundle presents baseline Native output alongside SSA.

## One compilation

Read entry/imports once and run the common frontend once. Pass the resulting HIR and MIR snapshots to generation rather than collecting repeated CLI invocations. Do not reinterpret types, names, or ownership rules, or optimize implicitly.

The same version, input names/text, target, and heap budgets produce identical contents. Do not record timestamps, output-directory names, or environment variables. Bundles include input names and text. Different input path spellings need not produce identical bytes.

## Saving and failures

The parent directory must exist. The output must be a new directory; never overwrite existing files, directories, or symlinks. Generate all artifacts in memory before writing, then write the manifest last.

Report write failures as failures. A directory without a manifest is not a complete bundle. Ordinary write failures clean up only files created by this operation. Forced termination or cleanup failures can leave an incomplete directory; this is not a transaction or crash-durability guarantee.

## Execution and distribution

Do not run the program, launch external tools, or link. No repeated external effects or record/replay from [#104](https://github.com/Hokutaka/Cerune/issues/104) are introduced. This is not a completed `build`/`release` artifact and adds no IR/MIR loader.

Objects, disassembly, bytecode, C/LLVM/QBE/WAT, Lean, execution results, and optimization comparisons remain future extensions. Omission is neither generation failure nor implemented coverage. Individual `emit-*` commands remain available.

## Validation

Use the [IR-stage examples](../../examples/ir_stages/README.en.md) to compare each file byte-for-byte with individual emits using identical options. Check both targets, multiple files, string bytes, heap budgets, determinism, input errors, and output collisions. Observing a program that would trap must not execute it.
