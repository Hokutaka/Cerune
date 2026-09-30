# Study: direct execution of Source / AST

[日本語](ast-executor-study.ja.md)

Baseline: `9214509`, after merging PR #75 (2026-09-30). **Recommendation: do not adopt an AST Executor now or make it a prerequisite for further language features.** It is feasible in principle, but an additional execution boundary currently brings substantial duplication in type resolution, expansion, ownership, and origins. This study neither authorizes implementation nor finalizes a new specification.

The IR Executor supports current language features, has completed validation, and is merged into master. This study changes no executor, frontend implementation, or language semantics.

## Source input versus AST execution

`run-ir file.ceru` already accepts source, but executes completed Cerune IR. Another source-input command that delegates to the same executor would not be an independent AST execution route.

An AST Executor first needs a precise choice of input:

| Candidate input | Comparison value | Main cost |
| --- | --- | --- |
| Parsed AST | Potentially compare before and after generic, match, and iteration expansion | Missing resolved types, references, and constant values; source constructs need execution semantics |
| Common-expanded AST plus semantic information | Compare construction of typed IR from AST | No complete per-expression annotations, ownership plan, or cross-stage origin mapping |
| Representation after all common expansion and ownership processing | Overlaps the existing reference route | Completed Cerune IR already occupies this role |

“AST Executor → IR Executor → VM → compiled routes” describes a comparison order, not a runtime pipeline feeding one executor's result to another. These would be execution branches from different stages of the same source.

## What the AST contains

In [ast.rs](../../src/ast.rs), `Expr` and `Stmt` contain `kind` and `Span`. The AST preserves operators, argument/field source order, control structures, type annotations, integer digits and suffixes, float text and optional suffixes, and decoded strings. Type references represent names, array shapes, and unresolved named lengths. It retains enum, match, generic-call, and array-iteration syntax.

It does not attach resolved types to every expression, BindingIds to every reference, NodeIds to all nodes, resolved call/field IDs, frozen constant values, or retain/release operations. Nor is it a fully lossless syntax tree preserving comments, whitespace, and original string escape spelling. SourceMap retains the exact source text.

`compile(source)` checks the program but returns the original AST. A validated AST is not the same as an AST annotated with everything required for execution.

[SemanticModel](../../src/semantic.rs) contains type/field/function definitions and IDs, constant types, binding information, and type-query APIs. Some original generic-call expressions can be queried, providing useful reusable infrastructure. However, it is not a complete per-scope table of resolved expressions and references. `analyze` does not return the expanded AST it constructed internally. Queries require the appropriate visible bindings and expected type.

For example, evaluating the expression in `x: f32 = 0.1 + 0.2;` without its expected type would select f64 for unsuffixed float literals. Reusing the type rules still requires supplying their context correctly. Unexecuted branches must also receive the existing static checks; checking only branches reached at runtime would change the language.

## Processing before completed IR

The following are dependencies, not a strictly single-pass pipeline: array-length resolution invokes IR construction for the constants it needs.

| Stage / implementation | Current responsibility | Reuse and obstacles |
| --- | --- | --- |
| [Module resolution](../../src/modules/resolve.rs) | Imports, pub, collisions, dependency names in common AST | Reusable, but the resolved AST is already different from the original per-file syntax |
| [Generic expansion](../../src/generics.rs) | Specialization for explicit types/lengths and origins | Reusable AST transformation; sharing it does not independently validate specialization |
| [Named array lengths](../../src/array_lengths.rs) | Dependencies, cycles, positive sizes, use sites | Evaluates required constants through existing IR construction, not AST-only evaluation |
| [Enum / match expansion](../../src/sums.rs) | Tags/payloads, exhaustiveness, guards, bindings, Let/Conditional | Reusable AST transformation; executing original matches requires their branching/copy semantics separately |
| [Semantic analysis](../../src/semantic.rs) | Types, scope, mutability, calls, recursion restrictions | Rules can be shared, but the API does not annotate all results on original AST nodes |
| [IR builder](../../src/ir/builder.rs) | Contextual types, BindingId/NodeId, references, builtins, default-field evaluation order | Resolution and construction are coupled; an AST consumer would need shared resolved results |
| [Array iteration](../../src/iteration.rs) | One snapshot copy, indexed for-loop, update on continue | The builder uses a reusable AST expansion; direct for-in execution must preserve the same contract |
| [Constant evaluation](../../src/ir/builder/constants.rs) | Evaluation, diagnostics, freezing static values | Currently IR → Bytecode → VM; a reusing frontend must disclose this compile-time dependency |
| [Aggregate expansion](../../src/ir/aggregates.rs) | Equality, display, match-derived expressions become copies/functions/loops | Operates on IR, not directly on AST |
| [Ownership expansion](../../src/ir/ownership.rs) | Retention/release for arguments, returns, temporaries, scopes, and branches | Operates on IR; dropping Rust AST-runtime values would not alone reproduce its contract |

Product construction must evaluate the base first, explicit fields in source order, then omitted defaults in definition order. Simply walking the type's field order changes side effects and failure order.

### Ownership and origins are significant obstacles

The string budget is observable behavior: the same source and budget must succeed or fail consistently. Copies such as `saved = s`, coexistence of old/new values in `s = concat(s, "c")`, match temporaries, and cleanup at return/break/continue affect this result.

[runtime/string_heap.rs](../../src/runtime/string_heap.rs) can be shared, but the IR ownership pass currently determines when to retain and release. A separate AST lifetime policy could match output while failing differently under a small budget. GC or Rust reference counts alone do not preserve the current live-byte contract.

AST spans identify diagnostic locations, not IR NodeIds. Generic instances and multiple generated operations can share a span. A span is not a unique cross-stage identity; constructing IR solely to borrow its node numbers would not establish an independent origin contract. Future comparisons need explicit relationships between source elements, instances, and generated elements.

## Can frontend semantics be shared without duplication?

**Partly, but the present APIs are not a ready-made foundation for a full-featured AST Executor.**

Module resolution, generic/sum/iteration AST transformations, type rules, numeric conversions, and string storage management are reusable candidates. There is no single result exposing an expanded AST together with its complete resolved information, constants, and origins. Ownership and aggregate expansion consume IR.

If a concrete need emerges, extracting resolved information associated with the same AST once could be considered. Creating a second typed representation nearly identical to existing IR solely for AST execution is not recommended. Building and executing the whole IR through IR Executor must not be presented as independent AST execution; that differs from sharing compile-time constant evaluation.

## Value and limits of stage comparison

- **Useful independence:** executing original matches, for-in loops, and constructors could expose evaluation-order, copy, or branch errors introduced before completed IR.
- **Shared blind spots:** if both routes use the same generic/match/ownership expansion, defects in those transformations remain shared. An AST Executor is not automatically an independent frontend oracle.
- **Existing coverage:** comparisons between IR Executor, VM, and compiled routes primarily test differences after completed IR. Known expected values, invalid programs, IR structure, and origin assertions test the frontend itself.
- **Performance:** separate parsing/expansion/type resolution from execution and record equal preprocessing, output, and budget conditions. Repeated runtime type queries in only the AST route would measure more than traversal strategy. No performance measurements were made in this study.

Existing checks include [IR execution](../../tests/ir_executor.rs), [observation fixtures](../../tests/observation_cli.rs), [generics](../../tests/generic_functions.rs), [sums](../../tests/sums.rs), [aggregates](../../tests/aggregate_values.rs), [iteration](../../tests/array_iteration.rs), and [ownership budgets](../../tests/string_heap_routes.rs). They cover static errors in short-circuited generic calls, iteration snapshots, prior output and failing expressions, and lifetimes under small budgets against known contracts.

## Difference from emit-sources

| Operation | Observed or executed content |
| --- | --- |
| `emit-sources` | File IDs, names, and exact text in `cerune-sources-v1`; not AST, resolved types, or runtime state |
| AST observation (candidate, unimplemented) | Syntax structure, expansion stages, resolution, and origin relationships; need not execute the program |
| AST Executor (not recommended now) | Computation, state, output, and runtime failures from a specified AST stage |
| `emit-ir` / `run-ir` | Observe / directly execute completed IR |

The [current CLI](../../src/main.rs) validates through common IR construction before emitting the source manifest. It does not invoke an executor for top-level statements or main. Compilation may include constant evaluation, so this is not an unchecked file copy either.

Actual outputs were inspected with `examples/modules/main.ceru`: `emit-sources` returns IDs/names/text for the entry file and values.ceru; `emit-ir` returns resolved types/functions, default-field expressions, and NodeIds.

## Recommended next steps

1. Keep IR Executor as the reference path for completed IR, including new features in known-expectation and cross-route comparisons.
2. To improve visibility before IR, first consider read-only observation of existing frontend transformations and origins. Define the observation needs before stable IDs or public schemas; no command name such as `emit-ast` is finalized here.
3. Reconsider AST execution when a particular frontend transformation needs independent comparison, or a concrete educational/debugging use requires it. First define which semantics are shared, which transformations are independently tested, and how ownership budgets and origins align.

No new AST, HIR, or generic executor abstraction is introduced in this study. Do not change IR Executor to accept unexpanded AST or optional ownership processing. Further language work such as dynamic arrays need not wait for an AST Executor.
