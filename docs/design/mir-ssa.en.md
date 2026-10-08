# SSA construction for MIR

[日本語](mir-ssa.ja.md) · [IR stages](ir-stages.en.md) · [Issue #94](https://github.com/Hokutaka/Cerune/issues/94)

## Status and decisions

**SSA construction, validation, execution, and CLI support are unimplemented.** This document establishes their implementation direction. Non-SSA MIR and its independent interpreter remain the baseline. The new [ssa_values.ceru](../../examples/ir_stages/ssa_values.ceru) runs on existing routes; it is not evidence of implemented SSA execution.

SSA gives each value a single definition. Source `mut` remains valid: each reassignment gets a different value ID. At a merge, the selected edge supplies values to block arguments. Select construction explicitly and preserve the input MIR.

| Decision | Direction | Reason |
| --- | --- | --- |
| Role | Optional MIR representation conversion | SSA construction alone performs no optimization |
| Merge values | Typed block arguments and edge arguments | Show which values arrive from each if, short-circuit, or loop edge |
| Initial promotion | bool, all integer types, f32/f64 locals and temporaries | Handle scalar reassignment without changing heap lifetimes |
| Other values | Retain typed slots and current operations | Keep programs with strings, fixed/dynamic arrays, and named types within the same language |
| Execution baseline | Keep non-SSA MIR; compare with evaluation that directly consumes SSA | Do not establish agreement by running HIR or the input MIR instead |
| Native | After validation, explicitly convert SSA back to non-SSA MIR for existing LIR lowering | Observe edge transfers without rewriting Native at the same time |

This is **scalar SSA with residual slots**, not Memory SSA or SSA for individual array elements. The output header and local inventory must state that slots remain. Language-feature support and the range of promoted values are separate questions.

Block arguments also appear in the [MLIR structure](https://mlir.llvm.org/docs/LangRef/#blocks). They express merge values differently from [LLVM phi instructions](https://llvm.org/docs/LangRef.html#phi-instruction). This choice does not introduce either compiler as a dependency.

## Mapping from existing implementation

The inspected code establishes the contracts to preserve.

| Current implementation | SSA treatment |
| --- | --- |
| `Assign` and empty-path `Store` in [mir/mod.rs](../../src/mir/mod.rs) | Every write to a promoted local defines a new ValueId; retain reassignment as an explicit copy |
| `Operation::Copy` | Representation read, not a deep copy or retain; do not remove during SSA construction |
| Nonempty-path `Store`, `CheckIndex` | Use residual slots and SSA indices; preserve checks, RHS evaluation, and update order |
| `Call`, checked operations, allocation, retain/release, output | Retain their block and order, types, ownership mode, and failure origins |
| [validate.rs](../../src/mir/validate.rs) | Validate original MIR types, definite initialization, and preceding index checks before construction |
| [mir_executor.rs](../../src/mir_executor.rs) | Share numeric/heap semantics where appropriate; SSA evaluates its own control and value references |
| [text.rs](../../src/mir/text.rs), [observation bundle](observation-bundle.en.md) | Preserve the original MIR format; add separate SSA snapshots and transformation mappings |

Evaluate an assignment's RHS before registering the new definition. In `x = x + 1`, the RHS refers to the old x. Function arguments provide entry definitions and retain their ownership mode. Preparing residual-slot arguments must not introduce hidden ownership copies.

An SSA value ID identifies a static definition. Revisiting an instruction in a loop produces that iteration's dynamic value; it does not mean the instruction may execute only once.

## Representation and construction

Place the new responsibilities under `mir::ssa`. Reuse types, FunctionId, SourceOrigin, and operation semantics. Use a dedicated representation distinguishing ValueId, slot references, block arguments, and edge arguments, rather than marking an unchanged `mir::Program` as SSA. Refactor shared operand types only where implementation would otherwise require duplication.

Proposed entry points follow. Rust API names will be finalized during implementation.

| Proposed entry point | Responsibility |
| --- | --- |
| `mir::ssa::construct(&mir)` | Return an independent SSA snapshot and mapping from validated MIR |
| `mir::ssa::validate(&ssa)` | Check definitions, uses, types, edges, residual slots, and origins |
| `mir::ssa::text::emit(&ssa)` | Versioned observation text, not a loading format |
| SSA evaluation | Directly evaluate SSA blocks, values, and slots under existing output/failure contracts |
| `mir::ssa::lower(&ssa)` | Return non-SSA MIR with edge arguments expanded to parallel copies, plus mappings |

Construct in the following order.

1. Validate MIR and compute CFG reachability from each function entry. Follow both edges even for constant conditions; do not fold constants.
2. Classify promoted locals and residual slots. Collect definitions, reads, and values required along edges.
3. Compute dominance (every entry-to-use path passes through the definition) and dominance frontiers. Place arguments in the iterated dominance frontier of each local's definitions where that local is live on entry. Include backedges and iterate to a fixed point.
4. Rename definitions along the dominator tree and supply arguments on each edge. Process instructions in their original order. Fix argument/local/block traversal order; numbering must not depend on hash iteration.
5. Validate the result and mapping completeness, then compare execution with baseline MIR.

Avoiding arguments for locals not live on entry prevents invented undefined values; it does not delete source computations or copies. Initially, do not simplify created arguments even when all incoming values are identical.

### Unreachable blocks

Current MIR retains unreachable statements and helper blocks, without the same initialization guarantees as reachable code. Do not invent zero, undef, or poison values to make these blocks satisfy SSA.

Convert the entry-reachable portion and retain unreachable blocks in a separate section of the same snapshot as **unconverted original MIR records**. Keep all original instructions, edges, origins, and references into the reachable portion. Mark mappings as “retained because unreachable,” distinct from deletion. Accordingly, do not call the entire snapshot fully SSA.

SSA evaluation executes only the reachable SSA section. An executable edge into the unconverted records is a validation error. A future CFG pass activating such a section must recheck initialization and convert it. Conversion back to MIR restores unreachable records too, remapping ID references.

### Edge arguments

For `jump join(a, b)`, read **both** outgoing values before simultaneously binding the destination arguments. Edge arguments are existing value IDs, never embedded expressions, calls, or slot reads. A branch transfers along the selected edge only. Keep edge identities and arguments distinct even when then/else target the same block.

Sequential assignments for a loop's `jump head(right, left)` can destroy the old values needed for a swap. When returning to non-SSA MIR, implement parallel copies using temporaries. Allocate MIR Temporary destinations for SSA definitions and block arguments. Do not misrepresent repeatedly written block arguments as Binding initializers; preserve source binding names in the mapping. If the source branches to multiple destinations, place copies in a helper block specific to the selected edge. Do not add output, allocation, retain, or release there.

## Example representation

[ssa_values.ceru](../../examples/ir_stages/ssa_values.ceru) chooses a value with if, adds 0 and 2 in a loop, and swaps two values three times in a separate loop. Existing IR/MIR/VM routes should print `14\n16\n20\n10\n`.

The following is **explanatory shorthand, not current generated output or a finalized text grammar**. It omits literal/copy operations and origin annotations. Actual SSA construction will retain the original operations.

```text
Non-SSA:
  then: total = checked_add(total, 2); jump join
  else: total = checked_add(total, 4); jump join
  join: ... use total ...

Proposed SSA:
  then: v_then = checked_add(v_seed, 2); jump join(v_then)
  else: v_else = checked_add(v_seed, 4); jump join(v_else)
  join(v_total: u8): ... use v_total ...

Loop backedge:
  head(v_left: u8, v_right: u8, v_index: u8):
    ...
    jump head(v_right, v_left, v_next_index)
```

These commands are available today.

```sh
cargo run --quiet -- run examples/ir_stages/ssa_values.ceru
cargo run --quiet -- run-mir examples/ir_stages/ssa_values.ceru
cargo run --quiet -- run-vm examples/ir_stages/ssa_values.ceru
cargo run --quiet -- emit-mir examples/ir_stages/ssa_values.ceru -o target/ssa_values.mir.txt
```

## Validation and semantic preservation

Require these structural checks.

| Check | Rejected examples |
| --- | --- |
| Unique definitions and function-local references | Duplicate ValueId, another function's value, unknown value |
| Dominance and within-block order | Using a branch-only value directly after a merge, reading a later definition first |
| Arguments and edges | Wrong argument count/type, entry/signature mismatch, unknown block |
| Initialization and residual slots | Uninitialized slot read, indexed store before checks, ownership-mode mismatch |
| Origins and mappings | Missing failing source operation, arbitrarily selecting one origin from a set |
| Unreachable section | Executable edge into an unconverted record |

A block argument is defined at block entry. Incoming arguments are used at the predecessor's terminator. Apply the same rules to self-loops rather than assuming all arguments dominate automatically. Residual slots retain existing MIR type, initialization, and index-check obligations. Structural SSA validation does not prove heap alias or lifetime safety.

Compare return values, output bytes, failure codes, NodeId/SourceId/Span, prior output, evaluation order, short circuit, and copy independence. Preserve separate logical string/array budgets and allocation/release timing. Do not change floating-point association, NaN, or negative zero. Keep unused checked operations, calls, allocations, and copies in place.

The initial conversion does not speed up programs by adding, moving, or deleting operations. Except for block-argument transfer, it should correspond to the original dynamic operation sequence. Value/block IDs may change; source failure origins must not. SSA definition history must not become an API for externally mutating runtime state.

## Observation, CLI, and implementation order

Mappings record input/output snapshots, pass name/version/options/order, and original FunctionId/BlockId/InstructionId/LocalId to SSA values/blocks/edges. Auxiliary arguments identify the merged local; incoming values identify their edges. Keep a failing operation's single source origin separate from many-to-one provenance.

`emit-mir --ssa` / `run-mir --ssa` are CLI candidates, **not available commands**. Preserve existing behavior without the option and reject it on routes that do not consume SSA. Native's selected path records conversion back from SSA too. Do not enable SSA or optimization implicitly through `release`.

Bundles keep original MIR, SSA, and mappings in separate files; Native integration also includes MIR reconstructed from SSA. Update the manifest version and record a transformation sequence distinguishing SSA construction from optimization. Final filenames/version values and integration with general pass selection belong to CLI implementation. The current v1 pass list stays empty.

Implement in these units.

| Order | Work | Completion criteria |
| --- | --- | --- |
| 1 | Representation, structural validator, deterministic text | Validate hand-built branches, loops, parallel arguments, and residual slots; reject broken definitions/edges/initialization |
| 2 | MIR→SSA and mappings | Add straight-line, branch/short-circuit, then loop conversion; preserve input snapshots, cover every operation, retain unreachable records, convert every example |
| 3 | Direct SSA evaluation, CLI, bundle | Compare HIR/MIR/SSA/VM using baseline examples and existing MIR/runtime tests, including heap budgets, prior output, and failure origins |
| 4 | SSA→MIR and Native | Observe parallel copies/helper edge blocks; compare ASM/Object execution on Windows/Linux |
| 5 | Lean correspondence and individual optimization passes | Check concrete MIR→SSA fixtures with an independent model; specify each optimization pass's preservation conditions before implementing it |

While intermediate implementations lack operations, diagnose them explicitly rather than silently falling back to input MIR execution. Public SSA execution should target current language features, including comparisons involving residual slots.

Reuse existing all-u8-input fixtures in Lean and reject mutations that exchange branch arguments, skip loop updates, sequentialize parallel transfer, or change failure origins. Distinguish completion from fuel exhaustion; do not assume identical numeric bounds after structural changes. Keep execution comparisons, finite-fixture proofs, and general transformation proofs distinct. General heap behavior, termination, and whole-compiler correctness remain unproved.
