# Observation bundle

[日本語](observation-bundle.ja.md)

## Purpose and scope

The first implementation of [#60](https://github.com/Hokutaka/Cerune/issues/60) saves HIR, non-SSA MIR, and annotated Native ASM from one frontend invocation. The manifest is an index, not a new IR.

Use `cerune observe <file> --target <triple> -o <new-directory>`. An explicit Windows/Linux x86-64 target is required. Existing heap-budget options apply.

| File | Contents |
| --- | --- |
| `manifest.json` | `cerune-observation-v1`, Cerune version, target, both heap budgets, optimization passes (currently empty), no-execution status, relative artifact paths |
| `sources.json` | File names, exact text, and SourceIds in the existing `emit-sources` format |
| `program.ceir` | Completed HIR |
| `program.mir.txt` | MIR lowered and validated once from the same HIR |
| `program.origins.s` | ASM from that MIR, annotated with HIR origins and MIR→LIR correspondence |

## One compilation

Read entry/imports once and run the common frontend once. Pass the resulting HIR and MIR snapshots to generation rather than collecting repeated CLI invocations. Do not reinterpret types, names, or ownership rules, or optimize implicitly.

The same version, input names/text, target, and heap budgets produce identical contents. Do not record timestamps, output-directory names, or environment variables. Bundles include input names and text. Different input path spellings need not produce identical bytes.

## Saving and failures

The parent directory must exist. The output must be a new directory; never overwrite existing files, directories, or symlinks. Generate all artifacts in memory before writing, then write the manifest last.

Report write failures as failures. A directory without a manifest is not a complete bundle. Ordinary write failures clean up only files created by this operation. Forced termination or cleanup failures can leave an incomplete directory; this is not a transaction or crash-durability guarantee.

## Execution and distribution

Do not run the program, launch external tools, or link. No repeated external effects or record/replay from [#104](https://github.com/Hokutaka/Cerune/issues/104) are introduced. This is not a completed `build`/`release` artifact and adds no IR/MIR loader.

Objects, disassembly, bytecode, C/LLVM/QBE/WAT, Lean, execution results, SSA, and optimization comparisons remain future extensions. Omission is neither generation failure nor implemented coverage. Individual `emit-*` commands remain available.

## Validation

Use the [IR-stage examples](../../examples/ir_stages/README.en.md) to compare each file byte-for-byte with individual emits using identical options. Check both targets, multiple files, string bytes, heap budgets, determinism, input errors, and output collisions. Observing a program that would trap must not execute it.
