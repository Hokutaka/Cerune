# Constants in array type lengths

[日本語](constant-array-lengths.ja.md)

## Syntax and types

```cerune
const COUNT: i64 = BASE + 1;
const BASE: i64 = 2;
fn total(values: [i64; COUNT]) -> i64 {
    mut sum: i64 = 0;
    for (value: infer in values) { sum = sum + value; }
    return sum;
}
values: [i64; 3] = [1, 2, 3];
print(total(values)); // 6
```

| Area | Rule |
| --- | --- |
| Length syntax | Positive integer literal, constant name, or `alias::COUNT` |
| Constant type | Any integer type from `i8` through `u64`; value positive and at most `i64::MAX` |
| Computation | Write it in the constant definition; `[T; COUNT + 1]` and calls inside type lengths are unsupported |
| Type identity | Compare resolved values; if COUNT is 3, `[T; COUNT]` and `[T; 3]` are the same type |
| Locations | Variables, constants, parameters, returns, product/enum fields, nested arrays, iteration element types |
| Visibility | Imported constants require `pub`; a local private constant may determine a public type's length |

Length syntax does not change index types. A `u64` length constant still produces arrays indexed with `i64`, and `array_len` still returns `i64`. The original constant's name and integer width do not participate in array type identity.

## Evaluation and dependencies

After name resolution, follow the required constants and types and use the existing constant evaluator to determine lengths. Arithmetic, conversions, `byte_len`, `array_len`, and array/product accesses retain the VM's rules. Forward/shared dependencies are allowed; cycles through types are diagnosed.

For example, `const N: i64 = array_len(DATA); const DATA: [i64; N] = [1];` is cyclic because determining DATA's type already requires N. The compiler does not infer N backwards from the initializer. References and constant-expression eligibility are checked even in short-circuited operands.

Expand only defaults required by constructions used to evaluate the length. Explicit fields, updates, and inactive enum storage do not execute unnecessary defaults. Ordinary functions cannot run at compilation. Existing validation/evaluation of unused constants remains in place.

A public type may use a local private length constant because the resulting type carries a resolved number. This grants no access to that private name from another module and does not permit private element types to leak through public signatures.

## Diagnostics, resources, and observation

- Zero, negative, noninteger, and out-of-range lengths point to the reference in the type. Failures during constant evaluation point to the failing expression in its definition.
- Unresolved type/constant dependency depth is limited to 128. Length evaluation permits 100,000 expanded expression nodes per declaration and expression depth 128.
- A value's expanded aggregate type is limited to 100,000 scalar units and type-computation depth 128. Arrays multiply by length, products sum fields, and enums include the tag and all variant storage. Empty products count as one.
- The limits apply equally to constants, literals, and `infer`. They bound compiler resources, not physical bytes or total program memory. A string counts as one scalar unit regardless of its byte length.
- Compilation failures execute no runtime statements and preserve existing output artifacts. Runtime bounds failures point to the access, rather than the length definition.

The original AST retains the name and Span; code-generation types use resolved numeric lengths. Cerune IR preserves constant definitions/results and adds `array-length %COUNT@ID => 3 [source=… bytes=…]` records for type references. Lengths are not recomputed at runtime; every route receives existing fixed-array operations. Observation metadata grants no interface for modifying constants or running arrays.

## Examples and validation

The [fixed-size aggregation example](../../examples/constant_array_lengths.ceru) covers forward references, nesting, numbers/strings/enums, functions, and copies. The [shared-dimensions example](../../examples/modules/constant_array_lengths.ceru) combines public constants with private implementation sizes.

Known outputs are compared across VM, C, LLVM, QBE, WAT, Windows/Linux ASM, and native objects. The [observation fixture](../../tests/fixtures/observation/constant-array-lengths/) fixes each representation. Tests also cover integer kinds, type identity, cycles, invalid lengths, visibility, resource limits, original files/locations, and prior output.
