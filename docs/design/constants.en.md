# Compile-time constants

[日本語](constants.ja.md)

**Status: implemented**

## Syntax and purpose

Share settings, calibration values, and fixed data between files.

```cerune
const STEP: u64 = 64;
const LIMIT: u64 = STEP * 2;
fn capacity() -> u64 { return LIMIT; }
print(capacity()); // 128
```

Export a constant with `pub const LIMIT: u64 = 128;` and refer to it as `settings::LIMIT`. Constants require an explicit type; neither `infer` nor `mut const` is supported. Declarations belong at file scope and can be referenced by functions, ordinary expressions, and field defaults. Forward references to other constants are allowed.

| Area | Contract |
| --- | --- |
| Values | All integer types, f32/f64, bool, string, fixed arrays, structs, sums, and nesting |
| Expressions | Literals, constants, arithmetic/comparison/bitwise operations, explicit conversions, short circuiting, `byte_len` / `array_len`, arrays/indexing, struct construction/updates/field access |
| Rejected | Runtime variable references, ordinary function calls, output and other effects |
| Names | No assignment. Collisions with types, functions, aliases, variables, or parameters in the same file are diagnosed |
| Visibility | File-private by default. A `pub const` type cannot contain private types; its initializer may use private constants |

An ordinary immutable binding evaluates its initializer at runtime. A constant evaluates at compilation and supplies that result at each use. It adds no shared runtime variable or initialization function. Mutating an array or struct copied from a constant leaves the constant and other copies independent. Strings retain exact UTF-8, NUL, CR, and LF bytes without normalization.

## Evaluation and diagnostics

Evaluation uses the VM's numeric operations, conversions, and bounds checks. Integer overflow fails; floating-point operations round at their declared precision. Negative zero, infinities, and NaN remain values. NaN payloads and physical layout are not guaranteed.

`false && (1 / 0 == 0)` skips evaluation of its right side. Type, name, and constant-expression eligibility checks still cover the whole expression: an ordinary function call or cyclic reference is rejected even in a skipped branch. A referenced constant is independently checked and evaluated.

Unused constants are also evaluated. Division by zero, overflow, invalid conversion, and out-of-bounds access become compilation errors before any program output or artifact overwrite. Diagnostics identify the failing expression in its definition file. Failures in ordinary runtime expressions that use constants identify the use site instead.

Constants containing string expressions retain the existing explicit-target and byte-output rules after evaluation.

Dependencies need not follow declaration order. Cycles are rejected, and traversal through unevaluated dependencies is limited to 128 levels. Expansion of each constant expression, including defaults, is limited to 100,000 nodes. Struct constants evaluate only the defaults they use. Explicit fields and update expressions do not re-evaluate omitted defaults.

## Representation and implementation

1. Register types and constant names; type-check all declarations.
2. Resolve dependencies and pass only effect-free IR to the VM evaluator.
3. Keep each declaration's type, initializer, evaluated value, and Span in Cerune IR. Uses retain a constant ID and independent NodeId/Span.
4. Lower evaluated values through every route, without re-running initializer arithmetic at runtime.

`emit-ir` shows `[compile-time]` and the relationship between initializer and result. References display `const %name@ID => value`. Bytecode and generated artifacts use evaluated values. This IR mapping does not promise constant names in every target's debug format.

Ordinary functions cannot run at compilation. Compile-time functions need a separate contract for termination, effects, and resource usage. Integer constants may specify lengths such as `[i64; LIMIT]`; see [type dependencies, resource limits, and observation](constant-array-lengths.en.md). Block-local constant declarations, re-exports, and generics are also outside this increment.

## Examples and validation

- [constants.ceru](../../examples/constants.ceru): typed constants, forward references, functions, struct updates, independent copies, and short circuiting.
- [modules/constant_settings.ceru](../../examples/modules/constant_settings.ceru): public settings and a private calibration constant.
- [modules/constants.ceru](../../examples/modules/constants.ceru): consume imported constants and construct independent values.

Known output is compared across VM, C, LLVM, QBE, WAT, Windows/Linux assembly, and internal objects. C/LLVM run with and without optimization; special floating-point values and runtime failures at constant use sites are covered. Separate tests check compilation failures, visibility, diamond dependencies, unused constants, and IR origins.
