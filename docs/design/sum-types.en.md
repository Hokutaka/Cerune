# Sum types and exhaustive branching

[日本語](sum-types.ja.md)

**Status: implemented**

## Purpose and syntax

Represent a found value and a missing entry as alternatives of one type. Success values and failure reasons can likewise use distinct variants.

```cerune
enum Lookup { Found { text: string }, Missing, }
fn lookup(key: string) -> Lookup {
    if key == "sky" { return Lookup::Found { text: "空" }; }
    return Lookup::Missing {};
}
match lookup("sky") {
    Lookup::Found { text: value } => { print(value); },
    Lookup::Missing {} => { print("未登録"); },
}
```

| Item | Contract |
| --- | --- |
| Type | Nominal value type declared with `enum`; at least one variant |
| Construction | `Enum::Variant { field: value }`; empty variants still require `{}` |
| Payloads | Named, explicitly typed fields containing numbers, bools, strings, arrays, products, or sums |
| Branching | `match` is a statement; list every variant exactly once and bind each field or discard it with `field: _` |
| Bindings | Immutable copies scoped to the arm, not references into the subject |
| Values | Supported in variables, arguments, returns, arrays, products, and constants |
| Modules | `pub enum` exposes all variants and fields; importers use `alias::Enum::Variant` |

Constructors evaluate supplied fields once in source order. Enum payload fields cannot declare defaults. An explicitly constructed product payload follows the ordinary product-default rules.

A match evaluates and copies its subject once and executes only the selected arm. Reassigning the original mutable binding inside an arm does not change extracted values. A return exits its function; break and continue target the enclosing loop. Return analysis accepts a match whose every arm guarantees a return.

Parenthesize constructors used directly as subjects: `match (Lookup::Missing {}) { ... }`. This uses the existing block-condition disambiguation rule.

## Checks and failures

Missing or duplicate variants, mixed enum types, subject/pattern type mismatches, and missing, duplicate, or incorrectly typed fields are compile errors. Public enum payloads cannot contain private types. Recursive value types are rejected because their size would be infinite.

Programs can return a value such as `Error { ... }` to represent a recoverable failure. Match does not catch runtime stops such as overflow or division by zero. Failure while evaluating a subject or payload prevents subsequent evaluation and preserves the existing reason, expression span, and prior output.

Whole-enum printing/equality, direct field access, and product updates on enums are unsupported. Extract values with match. Guards, whole-arm wildcards, nested patterns, match expressions, implicit error propagation, generics, and built-in Option/Result types are not introduced.

## Shared representation and observation

After module name resolution, the shared frontend expands enums into tagged products. Every route consumes the same typed IR.

- `emit-ir` shows variant/tag mappings such as `enum %Lookup@0 tags [Found=0, Missing=1]`.
- Internal `$tag` and `$Found$text` storage, subject copies, tag comparisons, and branches remain visible. Source identifiers cannot contain `$`, preventing user-name collisions.
- IR/bytecode mark tag and inactive initialization fields as `[generated]`/`generated`, distinct from explicit source fields and defaults. Fields materialized from evaluated constants are also marked generated.
- Types, fields, constructor values, subject expressions, pattern bindings, and arm operations retain source positions. Generated comparisons use their pattern's location. Observation exposes no API for externally changing tags or values.
- The initial layout is an `i64` tag plus the **sum of every variant's payload storage**. Fields do not overlap as a union. No dynamic allocation is introduced; layout and tag values are not a stable ABI.
- Inactive storage uses typed zero initialization without executing user defaults or functions. Source patterns cannot extract those internal values. Expansion is limited to 100,000 nodes per constructor; reaching a named-type traversal depth of 128 is diagnosed.

Overlapping payload storage is a possible later optimization after validating copies, lifetimes, target layouts, and observation mappings. The current representation prioritizes traceability and identical value semantics across routes.

## Examples and validation

| Example | Coverage |
| --- | --- |
| [sum_lookup.ceru](../../examples/sum_lookup.ceru) | Present/absent values, string/u64, constants, arrays, functions |
| [sum_divide.ceru](../../examples/sum_divide.ceru) | Return success/zero-divisor/overflow alternatives and continue after handling them |
| [sum_values.ceru](../../examples/sum_values.ceru) | Product/array copies, constructor order, reassignment during an arm, no inactive defaults |
| [modules/sum_lookup.ceru](../../examples/modules/sum_lookup.ceru) | Public enum/constants/functions; construction and branching by an importer |

Known output is compared through the VM, unoptimized/optimized C and LLVM, QBE, WAT, Windows/Linux ASM, and the native object encoder. Tests cover nested matches, returning arms, loop control, short circuiting, NUL/CR/LF, unnormalized Unicode, and failure in selected arms or subject evaluation.
