# Dynamic data: proposed ownership, lifetimes, and observable lowering

[日本語](dynamic-data.ja.md)

**Status: proposal, not implemented.** String concatenation, dynamic arrays, and borrowed slices are not current language features. This document sets an implementation order and acceptance criteria. Candidate syntax, CLI options, and IR operation names are separate from the language reference's current specification.

## Where to start

The recommended order is **string concatenation → owned dynamic arrays and range copies → borrowed slices**. Existing `string` can exercise runtime allocation, returns, reassignment, and release before adding another value type. Starting with borrowing would require owner lifetimes and mutation restrictions alongside copying.

| Stage | User capability | Required contract |
| --- | --- | --- |
| 1. String concatenation | Build a string from two strings; return, store in arrays, reassign | Exact bytes, retain/release, allocation failure, short circuiting, origins |
| 2. Owned dynamic arrays | Runtime lengths, empty arrays, element updates, independent range copies | Typed element copy/drop, length/capacity, checked allocation sums/products |
| 3. Borrowed slices | Read part of an owner without copying | Cannot outlive the owner; mutation/reallocation restrictions during borrowing |
| Later | Recursion and external I/O | Call storage and resource limits; I/O failure and resource cleanup |

The first implementation introduces no source pointer type, user `free`, implicit moves, GC, or observation API for externally mutating values. Generic named types are separate work.

## Changes from the current implementation

[Strings](strings.en.md) currently use copied Rust `String` values in the VM and static data references in generated code. [Fixed arrays](fixed-arrays.en.md) have type-determined sizes and independent copies. WAT linear-memory requirements are also determined during generation.

Dynamic data needs a rule for who finishes using storage, in addition to where it lives. Adding C `malloc` alone is insufficient: define meaning in shared IR and verify lifetimes/resources in every route. Storage layouts, pointer widths, and instruction sequences need not be identical.

## Ownership and copying

| Value | Meaning of copying | Initial implementation proposal |
| --- | --- | --- |
| Numbers, bools, existing fixed-size values | Existing independent value semantics | Existing copies |
| Static strings | The same immutable contents | Shared storage, never released during execution |
| Dynamic strings | The same immutable contents | Reference-counted immutable bytes, released after the final owner |
| Dynamic arrays | Updating a copy cannot change the original | Allocate independent element storage and copy elements by type |
| Borrowed slices | View the owner's storage | Separate type and lifetime rules, designed later |

String sharing relies on the absence of content mutation. Reassigning a `mut` string replaces that binding's value. Copying a dynamic array may retain its immutable string elements; replacing an element in the copied array still cannot change the original array.

Duplicating bytes for every string copy is simple but allocates during each value transfer. Retaining every allocation until execution ends accumulates dead buffers in reassignment loops. Initially, reference counting only immutable strings, with explicit retain/release in IR, is recommended. Shared mutable arrays and copy-on-write are excluded.

## First string concatenation operation

`concat(left, right)` is a candidate spelling, not currently available syntax. The proposal accepts exactly two `string` values and returns `string`. It adds no implicit number-to-text conversion or change to `+`.

1. Evaluate left and right once, in that order. A left-side failure skips the right.
2. Check the byte-length sum, required storage size, and explicit resource budget.
3. Allocate the result and copy all left bytes followed by all right bytes.
4. Seal the contents as immutable and return ownership. Preserve subsequent work and temporary-release locations in IR.

Japanese text, NUL, CR/LF, and combining characters are concatenated unchanged. No normalization, newline conversion, or terminator NUL is added. Equality, `byte_len`, standalone display, and quoted aggregate display retain their existing meaning.

Initially, a zero total length uses the static empty string; every nonempty result gets one new buffer, including concatenation with an empty string. Both arguments are still evaluated. Allocation-eliding optimizations require separate verification of observation correspondence, budgets, and failure conditions.

Constant expressions use the same concatenation rules during compilation and store the result as static text. Preserve the initializer and evaluated result in IR, with an explicit compile-time byte limit. Runtime-owned storage does not escape into compilation output.

## Lifetimes, reassignment, and termination

- Generate ownership retains when dynamic strings are stored in bindings, parameters, and results. Static bytes require no retain/release.
- Fully evaluate a reassignment's right side before replacing the binding and releasing the old value. Do not free `s` while evaluating `s = concat(s, suffix)`.
- Transfer result ownership before releasing locals, even when the returned string shares a local's storage.
- Release temporaries and bindings in reverse definition order at block exits, `return`, `break`, `continue`, and loop condition/update boundaries. Drop owned parts according to their types; enums process only the active payload.
- Reclaim partially constructed allocations at the failed execution's termination boundary. Do not invoke arbitrary source-level destructors.

VM embedding reclaims internal dynamic storage before returning a failed call to its host. This change does not implicitly expand the existing embedding API's supported value types. Native process termination lets the OS reclaim its storage. A WAT trap cannot execute subsequent release instructions; the initial contract therefore recommends discarding the failed instance instead of reusing it. Successful calls reclaim temporaries so repeated execution does not accumulate storage.

No source API exposes mutable ownership metadata or reference counts. Normal release and failure cleanup are execution contracts, not intervention through observation.

## Limits and failures

Logical lengths use `i64`, consistent with existing `byte_len` and indices. Check before converting to a target address width; never truncate high bits on wasm32. Also check headers, alignment, and element-count × stride.

| Cause | Candidate diagnostic | Origin |
| --- | --- | --- |
| Length sum or storage size exceeds representable range | `allocation-size-overflow` | Original concatenation, allocation, or copy expression |
| Explicit dynamic-data budget exceeded | `allocation-limit-exceeded` | Same |
| Target allocator reports failure after checks | `allocation-failed` | Same |

These codes are not implemented. Introducing them requires updating the [common failure record](runtime-diagnostics.en.md), readers, VM, and every backend together. Unexpected access violations or OS termination are not successful allocation-failure diagnostics. Preserve prior output and skip subsequent expressions.

The initial budget proposal is **64 MiB of live dynamically owned string contents**. Count shared immutable storage once and exclude static literals. Old and new values both count while a reassignment keeps them alive. An independent compile-time budget of the same size is proposed. Finalize the default and explicit configuration mechanism before implementation; the current CLI has no such setting.

This is not a bound on all physical memory. Metadata, stacks, artifacts, and hosts add costs; real allocation can fail below the budget. Do not assume identical OS free memory across routes. Cross-route failure tests use a small explicit budget rather than an observation API that changes the allocator during execution.

## Dynamic arrays versus slices

`[T]` is a candidate owned dynamic-array type, distinct from `[T; N]`. Permit length zero and construct only values satisfying `0 <= length <= capacity`. Capacity is distinct from element count; initially allocate exactly the required result length. Growth factors and reserved capacity can follow as explicit operations.

Design indexing, updates, function/aggregate passing, equality, display, and iteration together. Copies make nested mutable storage independent and retain immutable string storage as above. Expand typed copy/drop operations in shared IR. Conversion from fixed to dynamic arrays is explicit.

`copy_range(values, start, end)` is a candidate operation. Evaluate subject, start, and end once from left to right, then check `0 <= start <= end <= length`. Use the half-open interval `[start, end)`, including empty ranges at the end. The result is independently owned. Distinguish it from a borrowed slice and expose allocation/copy size in IR.

Borrowed slices need separate design. Read-only access alone does not prevent the owner from changing, reallocating, or expiring. Defer implementation until type rules cover returning a view without its owner, calls that mutate owners, and updates during borrowing. Keep string byte ranges and character boundaries separate from array slicing; do not implicitly create operations that break UTF-8.

## Required visibility of generation

This is conceptual notation, not the spelling of current IR instructions.

```text
Source concatenation
  → typed IR: concat(left, right), NodeId, Span
  → ownership expansion: evaluation → length check → budget check → allocation → byte copy → result
                         retain/release and success/failure cleanup boundaries
  → backend IR: layout, address width, calling convention, actual checks and loops
  → bytecode / C / LLVM / QBE / WAT / ASM / object
```

Relate the original operation to its expansion and mark the role and reason of generated operations. Expose allocation byte counts, static/dynamic storage, retained ownership, and final release. Future optimized-away work must remain explainable. Pointer values and runtime IDs need not agree across routes.

| Route | Required implementation changes |
| --- | --- |
| VM | Dynamic-storage management, fallible allocation, call-end cleanup |
| C / LLVM | Internal static/dynamic string distinction, retain/release, runtime for the explicit target |
| QBE / ASM / own objects | Lower the same ownership operations to instructions/relocations; record allocator linking requirements |
| WAT | Metadata in private memory, reusable allocation/release, checked memory-growth failure, post-trap instance contract |

C or OS allocators do not define Cerune value semantics. WAT does not export/import memory to give external code mutation access for allocation. External building/linking remains the artifact consumer's responsibility.

## Runnable examples today

| Example | Checks using current features | Does not yet check |
| --- | --- | --- |
| [bounded_sequence.ceru](../../examples/bounded_sequence.ceru) | Capacity four, used length, empty/full/invalid lengths, independent copies | Dynamic allocation, growth, release |
| [array_window.ceru](../../examples/array_window.ceru) | Half-open/empty/invalid ranges, evaluation order, short circuiting, independence after source updates | Runtime-allocated owned arrays or borrowing |
| [string_values.ceru](../../examples/string_values.ceru) / [aggregate_display.ceru](../../examples/aggregate_display.ceru) | Immutable string bytes and nested display | Runtime concatenation and dynamic-storage lifetimes |

The first two are **fixed-capacity examples** using ordinary types/functions. Their `copy_range` and `append` are user-defined functions, not new builtins. Unused storage remains part of the fixed array and appears when displaying the entire product. The example functions validate used lengths; the type itself does not automatically enforce the invariant.

```sh
cargo run --quiet -- run examples/bounded_sequence.ceru
cargo run --quiet -- run examples/array_window.ceru
cargo run --quiet -- emit-ir examples/array_window.ceru
cargo run --quiet -- emit-llvm examples/array_window.ceru --target x86_64-unknown-linux-gnu --annotate-origins
```

Compare known outputs across VM, C/LLVM, QBE, WAT, Windows/Linux assembly, and Cerune's COFF/ELF objects. These establish a design baseline; they do not validate unimplemented heap management.

## Acceptance criteria for the next implementation PR

1. Finalize the concatenation name/call rules, budget default/configuration, string representation, and ownership expansion.
2. Check empty strings, Japanese text, NUL, CR/LF, and non-normalized Unicode through concatenation, returns, reassignment, nested arrays, enums, and constants.
3. Verify effects/failures on either side, short circuiting, reassignment using the old value, and lifetimes across early return/break/continue.
4. Reproduce failure with small budgets and distinguish size overflow, budget exhaustion, and actual allocator failure. Allocator-failure tests use fixed internal test conditions.
5. Check balanced retain/release in loops and no remaining live allocations after execution; use C ASan/UBSan as well.
6. Compare known output, failure reasons, original locations, prior output, and ordinary/annotated artifacts across every route; update examples and both language references.
