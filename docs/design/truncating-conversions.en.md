# Truncating conversions

[日本語](truncating-conversions.ja.md)

`trunc<T>(value)` explicitly discards the fractional part when converting a float to an integer. `convert<T>` and `T(value)` remain exact. No implicit conversion or environment-dependent rounding policy is added.

## Contract

- Inputs are `f32` or `f64`; destinations are any of the eight integer types. Integer inputs and float destinations are rejected at compile time.
- Evaluate the input once, check finiteness, truncate toward zero, then check the integer range.
- `-3.7 → -3`, `-0.9 → 0`, and `-0.0 → 0`. This differs from flooring negative values.
- `255.9 → u8 255` and `-128.9 → i8 -128` succeed: the range applies after truncation.
- NaN and either infinity stop with `conversion-not-finite`; out-of-range results stop with `conversion-out-of-range`. Preserve the reason, source location, and prior output.
- Literal parsing and arithmetic retain their existing floating-point precision. The input is the evaluated value, not an ideal infinitely precise number.

Constants and functions with explicit type arguments follow the same rules. Evaluation order, short-circuiting, and independent array copies are preserved. Other rounding policies and saturation are covered by [rounding conversions](rounding-conversions.en.md). Integer bit truncation remains separate.

## Representation and emission

`ConversionMode::Exact` or `Rounded { rounding: Truncate, overflow: Checked }` is retained from the AST, separately from source spelling in `ConversionSyntax`. IR and bytecode show `convert.exact` or `convert.trunc`. Each backend receives the types and mode without reinterpreting source syntax.

The VM truncates before checking bounds. Native backends use equivalent floating-point comparisons before conversion. The upper bound is always exclusive `maximum+1`. The lower bound is normally exclusive `minimum-1`; for `i64` it is inclusive `minimum` because `minimum-1` cannot be distinguished in `f64` and no representable value lies between them. Inputs in `f32` are widened exactly to `f64` for these checks.

Prechecks prevent out-of-range C casts, LLVM poison, or built-in Wasm traps from replacing language diagnostics. See [C11 draft 6.3.1.4](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) for float-to-integer ranges and [LLVM LangRef](https://llvm.org/docs/LangRef.html#fptoui-to-instruction) for toward-zero conversion and out-of-range behavior.

C uses a checked cast, LLVM uses `fptosi/fptoui`, QBE uses `dtosi/dtoui`, WAT uses `i64.trunc_f64_s/u`, and ASM/the internal encoder use SSE2 conversions. For the upper half of `u64`, x86 subtracts `2^63`, converts as signed, and restores the high bit. Existing explicit OS/target selection remains unchanged.

## Validation

| Example or test | Coverage |
| --- | --- |
| [truncating_conversions.ceru](../../examples/truncating_conversions.ceru) | Signs, boundaries, u64, exact conversions, constants, type arguments |
| [truncating_evaluation_order.ceru](../../examples/truncating_evaluation_order.ceru) | Single evaluation, short-circuiting, copies |
| [Shared value cases](../../tests/support/truncation_cases.rs) | Both float types to every integer type and boundaries across routes |
| [Shared failure cases](../../tests/support/runtime_cases.rs) | Range, NaN, infinities, prior output and origins |
| [Observation fixture](../../tests/fixtures/observation/truncating-conversions/source.ceru) | IR, bytecode, C, LLVM, QBE, WAT, ASM, and VM output |
