# Fixed-array iteration

[日本語](array-iteration.ja.md)

## Syntax and values

```cerune
values: [i64; 3] = [4, 7, 9];
for (value: infer in values) { print(value); }
for (index: i64, mut value: infer in values) {
    value = value + index;
    print(value);
}
print(values[1]); // 7: changing an element binding does not write back
```

| Area | Rule |
| --- | --- |
| Subject | Fixed array; evaluate the complete expression once on entry and save an independent copy |
| Order | Ascending indices from zero to length minus one |
| Element | Fresh value copy per iteration; immutable by default, optionally `mut` |
| Index | Optional first binding; `i64` or `infer`, always immutable |
| Types | Every binding requires an explicit type or `infer`; the subject determines the element type, without implicit numeric conversion |
| Scope | Index and element exist only in the body; duplicate declarations in the same body are diagnosed |
| Control | `continue` advances to the next element; `break` exits the innermost loop; `return` exits the function |

`in` is reserved. `for (value: u8 in [1])` is a type error because the subject is `[i64; 1]`; specify its type with e.g. `[1u8]`. Bindings may shadow outer variables, but not constants or import aliases. Evaluate the subject in the scope before introducing the new bindings.

## Rationale

Arrays are values in Cerune. Iteration follows this rule: updating the original array inside the body does not change the captured sequence. `mut` permits changing the extracted value, rather than obtaining a reference to the original element. Existing counted `for` loops and array assignment remain available for updating the original.

Complete subject construction, including calls, elements, and defaults in their existing evaluation order, before entering the body. An immediate `break` does not skip this evaluation. Subject failure prevents body execution; body failure prevents subsequent iterations. Existing short-circuit rules remain intact.

## Shared expansion and observation

The frontend expands iteration into:

1. An immutable binding holding the subject array.
2. An immutable binding holding `array_len` of that copy.
3. An existing `for` with an internal cursor starting at zero, index/element bindings at the start of the body, and an increment in the update clause.

Cerune IR exposes generated bindings named `$for_in_snapshot_*`, `$for_in_length_*`, and `$for_in_cursor_*`. Source code cannot spell these names; file ID and header position determine them. Types, binding IDs, conditions, indexing, and updates remain visible without a separate iterator runtime.

NodeIds are assigned after expansion; subject and body retain their original Spans, including file identity. Generated control expressions point to the header, and element access/bindings point to their declarations. Failures in the subject or body record the original failing expression and prior output. Observing internal control does not grant source code or external tools authority to change it.

## Validation and scope

[Aggregation/search](../../examples/array_iteration.ceru) and [element values](../../examples/array_iteration_values.ceru) are checked against known output across VM, C, LLVM, QBE, WAT, Windows/Linux ASM, and native objects. Cases cover raw string bytes, numbers, nesting, products, sums, copies, scopes, and loop control. Failure cases distinguish subject evaluation from body failures.

The [observation fixture](../../tests/fixtures/observation/array-iteration/) records the source and generated representations. This feature introduces no new allocation mechanism: each route retains its existing array-copy and storage model. Optimizations may eliminate copies/checks only while preserving evaluation order and independent values.

Only existing positive-length fixed arrays are supported. Empty arrays, string iteration, slices, references, destructuring patterns, and an iterator protocol are outside this feature. Return checking remains conservative: a `return` inside the body alone does not establish that a function returns on every path.
