# Owned dynamic arrays and range copies

[日本語](owned-arrays.ja.md)

**This is a specification proposal for the next implementation. Dynamic arrays, the operations below, and the array budget are not implemented.** The executable baseline is [fixed-array copies and lifetimes](../../examples/array_copy_lifetimes.ceru). It builds on [implemented string ownership](dynamic-data.en.md), but mutable array storage must be copied independently.

## Implementation progress

| Stage | Status |
| --- | --- |
| Argument ownership transfer | Implemented: pass caller-prepared ownership once; the callee releases it. IR distinguishes ownership from internal reading |
| Dynamic array types, reads versus value copies, and storage management | Not implemented; the next implementation step |
| Dynamic arrays across backends and the completion criteria below | Not implemented |

The first stage is validated with existing strings and fixed arrays. See [ownership across calls](dynamic-data.en.md#ownership-across-calls) and the [example](../../examples/owned_arguments.ceru). This does not mark `[T]` or the array budget as supported.

## Types and initial operations

| Proposed spelling | Meaning |
| --- | --- |
| `[T]` | An owned array with a runtime length; length is not part of its type |
| `[T; N]` | The existing fixed array, with its syntax and meaning preserved |
| `array_copy(values)` | Create a new `[T]` from a fixed or dynamic array of the same element type |
| `array_copy_range(values, start, end)` | Copy the half-open range `[start, end)` into a new `[T]` |
| `array_repeat::<T>(value, count)` | Evaluate value once and create count independent copies |
| `array_len(values)` | Return a fixed or dynamic array's element count as i64 |
| `values[index]` | Read through an i64 index; a mut array binding permits element updates |

The proposed operation names follow `array_len`. Existing example functions named `copy_range` and `append` remain ordinary functions. Reserving the new names and diagnosing collisions belongs to implementation; an existing function must not silently resolve to a builtin.

There is no implicit fixed/dynamic conversion. `[1, 2]` remains a fixed-array literal. Initially no dynamic-array literal is added. Empty values come from `array_repeat::<T>(seed, 0)` or an empty range; seed is evaluated even for zero elements. Existing restrictions on `[T; 0]` and empty literals are unchanged.

The following is **illustrative code containing unimplemented syntax**:

```text
mut values: [i64] = array_copy([10, 20, 30]);
saved: [i64] = values;
part: [i64] = array_copy_range(values, 1, 3);
values[1] = 99;
print(saved); // [10, 20, 30]
print(part);  // [20, 30]
empty: [i64] = array_repeat::<i64>(0, 0);
print(empty); // []
```

Equality compares lengths and corresponding elements of dynamic arrays with the same element type. Comparing with a fixed array requires an explicit copy; ordering comparisons are not added. Display uses `[elements, ...]`, or `[]` when empty, with existing nested-string quoting. A zero-length `for … in` skips the body.

Length ranges from 0 through i64::MAX. Initially capacity always equals length. A binding can be reassigned an array of a different length with the same `[T]` type. Append, reserve, exposed capacity, growth policy, and borrowed slices are later work.

## Value copies and observation

| Context | Generated behavior |
| --- | --- |
| Assignment, binding initialization, insertion into an array/struct/enum | Copy an existing value, including independent storage for nested dynamic arrays |
| Function arguments and returns | Pass by value; copy existing values at the boundary, with the receiving function or caller owning the result |
| A newly created temporary used for storage, argument, or return | Transfer the temporary's ownership without a second copy |
| Length, display, equality, intermediate index/field access | Do not copy the whole array to read it; evaluate the target once and keep it alive |
| `for (item: T in values)` | Create an independent snapshot at loop entry and pass each element as a value |
| `a[i] = value` | Change only that destination element; prepare the new value before releasing the old one |
| Self-assignment `a = a` | Finish copying before releasing the old value; both allocations count toward the budget |

Do not turn a binding's last use into a move: that changes allocation failures, budgets, and origins. Distinguish temporary ownership transfers from binding copies in IR. The first implementation does not use copy-on-write.

Apply the same rule recursively to fixed arrays and structs containing `[T]`. Copy and release only the active enum payload. Immutable string contents may be shared through explicit retain/release. Nested arrays in separate `array_repeat` elements must also be independent.

Evaluate and complete any argument copy from left to right, before evaluating the next argument. A failed copy skips later arguments. Transfer an argument's owned value to the callee once, without copying again on function entry. Returning a binding copies the result before releasing locals and parameters.

Match saves its subject once as an owned value and copies selected payload bindings as values. A false guard releases that arm's bindings before trying the next arm. Struct defaults and update expressions keep their existing evaluation order; overwritten fields are released after their replacements are ready.

Internal read access does not introduce source-level references or shared mutable APIs. For example, `array_len(make())` executes make, reads its owned result, then releases it. Evaluate both equality operands in their original order; only the element comparison walk may stop early.

## Ordering of ranges, updates, and failures

For `array_copy_range`, evaluate target, start, and end once from left to right. Read the target as the copy source without first making a full dynamic copy. Keep both existing and temporary sources alive until the operation finishes.

1. After all three arguments succeed, check `0 <= start <= end <= array_len(values)`.
2. Calculate and check end - start, accounting size, and target layout size.
3. Allocate the result and copy elements in ascending source-index order.
4. Transfer the result and release a temporary source.

A negative start value does not skip evaluating end if the start expression itself succeeded. A failure in end therefore precedes a range diagnostic. Empty ranges at the beginning or end are valid and allocate no result element storage.

For `array_repeat(value, count)`, evaluate value and count before checking that count is nonnegative. Both expressions run for zero elements, and temporary values are released.

For indexed assignment, evaluate and check each index before later indices or the right-hand side. In `a[bad][later()] = rhs()`, a failed first check skips both later and rhs. Do not release the previous element before right-hand evaluation and copying succeed.

| Proposed diagnostic | Cause and origin |
| --- | --- |
| `array-index-out-of-bounds` (existing) | The indexed access expression |
| `array-range-out-of-bounds` (planned) | An invalid range at the array_copy_range expression |
| `array-length-out-of-range` (planned) | A negative count at the array_repeat expression |
| `allocation-size-overflow` (existing) | An unrepresentable size product/sum, length, or layout size |
| `allocation-limit-exceeded` (existing) | An explicit array or string budget is exceeded |
| `allocation-failed` (existing) | Allocator or memory.grow failure despite passing the budget check |

An allocation introduced by copying points to the source expression requesting that copy. Generated helper nodes have unique NodeIds and preserve the original Span. Preserve earlier output, and never count an unrelated access violation or trap as a successful diagnostic.

## Budgets and lifetimes

Propose `--array-heap-limit <bytes>`, defaulting to 64 MiB and accepting decimal integers from zero through i64::MAX. Preserve the meaning of `--string-heap-limit`. Both are settings made before execution/generation and recorded in IR, bytecode, and artifacts. Initially dynamic arrays are not allowed in compile-time constants; explicitly copy fixed-array constants at runtime.

To keep pointer width and padding from changing where budget failures occur, **count live array element storage using common accounting widths**. This is not a physical-memory limit.

| Element accounting width | Bytes |
| --- | --- |
| bool, every integer, f32, f64 | 8 |
| string or dynamic-array descriptor | 16 |
| Fixed array | Length times element width |
| Struct | Sum of field widths in declaration order |
| Enum | Tag of 8 bytes plus all variants' field widths; do not allocate inactive dynamic payloads |

Charge length × width(T) per allocation, plus separate storage for nested dynamic arrays. Exclude static storage, local descriptors, and management headers. String contents count once under the existing string budget. Empty arrays cost zero. Preserve the length of zero-width element types and avoid division by zero in size checks. Check **both** common accounting size and physical target layout size; inspect high bits before narrowing to wasm32.

Old and new values coexist during reassignment. Self-assignment of three i64 elements raises the array charge from 24 to 48 bytes and back to 24 after release. Reading array_len(a) or print(a) keeps it at 24. Test this difference to prevent hidden copies or changes in failure timing.

Release bindings in reverse order at block exit, return, break, and continue; release array elements in reverse order. Track the initialized element count during partial copies so failures never read uninitialized storage. The VM reclaims all remaining allocations before returning a failure to its host. Preserve the existing native process-termination boundary and discard failed WAT instances.

## What the generation process exposes

Propose typed operations such as `array.copy.allocate-elements`, `array.copy-range`, and `array.repeat`, with final spellings settled during implementation. Common lowering expands:

- Once-only source evaluation, distinguishing reads, value copies, and temporary ownership transfers.
- Index, range, length, size, and budget checks.
- Element allocation, ascending copy loops, and initialized-element count updates.
- Type-directed processing of nested values, fields, and active enum payloads.
- String retention and release of old values, temporaries, and elements in reverse order.

Preserve correspondence between AST types, common IR, backend IR, bytecode, and artifacts. Element traversal must remain visible as ordinary common-IR loops and branches, rather than disappear into one opaque host call. Backends implement layout, allocation, load/store, and release without redefining value-copy semantics separately. Keep existing LLVM/ASM/object origin annotations.

The VM manages typed element storage per execution. C, LLVM, QBE, ASM, and native COFF/ELF use the explicit target's allocator and ABI; WAT uses private memory. Do not expose shared storage addresses through the language or observation APIs. Recursive types, dynamic arrays as external host values, borrowing, and FFI are outside this change.

## Implementation acceptance criteria

| Area | Compare |
| --- | --- |
| Basics | Empty, singleton, runtime lengths, explicit conversion, reassignment to a different length |
| Value semantics | Nested arrays, strings, structs, enums, self-assignment, independent repeated elements |
| Existing features | Parameters/returns, explicit generic type arguments, modules, comparison/display/iteration |
| Evaluation order | Target/bounds/count, short circuit, staged index checks, skipping expressions after copy failure |
| Lifetime | Block/return/break/continue, iteration snapshots, partial-copy failure |
| Budget | Same semantic failure for the same explicit limit, no read-only copies, old/new coexistence, reuse after release |
| Allocation failure | Size boundaries, fixed allocator failure, actual WAT memory.grow failure |
| Observability | Common-IR/bytecode/backend fixtures and annotations identifying the original expressions |

Compare known output bytes, diagnostics, and prior output across IR Executor, VM, generated C, LLVM, QBE, WAT, Windows/Linux ASM, and native COFF/ELF. Add C ASan/UBSan checks and verify successful cleanup and partial-failure reclamation. Only mark the feature implemented in the reference and feature tables once the routes agree.

## Executable baseline today

`array_copy_lifetimes.ceru` combines nested fixed arrays of capacity three with a used length, and copies, returns, and replaces dynamically concatenated strings. It checks survival after function locals disappear, independent nested copies, range argument order, an empty end range, invalid ranges, and short circuit. Invalid ranges return **the example's enum values**, not the proposed runtime diagnostics.

```sh
cargo run --quiet -- run examples/array_copy_lifetimes.ceru --string-heap-limit 24
cargo run --quiet -- emit-ir examples/array_copy_lifetimes.ceru
cargo run --quiet -- emit-bytecode examples/array_copy_lifetimes.ceru
cargo run --quiet -- emit-llvm examples/array_copy_lifetimes.ceru --target x86_64-unknown-linux-gnu --annotate-origins
```

It succeeds with a 24-byte string budget. The source and selection stay at `["保存", "二"]` while only the edited array becomes `["変更", "二"]`. A used length of zero still has array_len(storage) equal to three. This example does not test empty dynamic values, array allocation failures, or runtime-sized storage. Current IR exposes fixed-array value copies, traversal, and string retention/release.
