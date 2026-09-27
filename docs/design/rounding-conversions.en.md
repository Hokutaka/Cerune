# Explicit rounding and saturating integer conversions

[日本語](rounding-conversions.ja.md)

Choose rounding and out-of-range behavior explicitly when converting a float to an integer. `convert<T>` and `T(value)` remain exact. Correct results and observable source expressions, policies, and generated steps are required together.

## Operations

Inputs are `f32` or `f64`; destination `T` is any of the eight integer types. Integer inputs and floating-point destinations are compile-time errors.

| Rounding | Stop on range failure | Saturate to endpoints | `2.5` / `-2.5` |
| --- | --- | --- | --- |
| Toward zero | `trunc<T>(x)` | `saturating_trunc<T>(x)` | 2 / -2 |
| Toward negative infinity | `floor<T>(x)` | `saturating_floor<T>(x)` | 2 / -3 |
| Toward positive infinity | `ceil<T>(x)` | `saturating_ceil<T>(x)` | 3 / -2 |
| Nearest; ties away from zero | `round<T>(x)` | `saturating_round<T>(x)` | 3 / -3 |
| Nearest; ties to even | `round_ties_even<T>(x)` | `saturating_round_ties_even<T>(x)` | 2 / -2 |

The five rounding names and their numeric rules follow [Rust's floating-point functions](https://doc.rust-lang.org/std/primitive.f64.html#method.round). Those Rust functions return floats; Cerune's `<T>` operations convert to integers. This does not claim that `round` has identical semantics in every language.

Evaluate the input once and round its already evaluated floating-point value. Earlier literal/arithmetic rounding is not undone. Evaluation order, short-circuiting, and value copies are unchanged. Constants and generic functions support these operations. Names are not keywords: ordinary `floor(x)` calls, `floor < limit` comparisons, and user-defined `floor::<T>(x)` remain distinct.

## Range and special values

Range checks and saturation apply after rounding.

| Input | Checked rounding conversion | `saturating_` variant |
| --- | --- | --- |
| Finite, rounded value in range | That integer | That integer |
| Rounded value below minimum / above maximum | Stop with `conversion-out-of-range` | Minimum / maximum |
| NaN | Stop with `conversion-not-finite` | 0 |
| Positive / negative infinity | Stop with `conversion-not-finite` | Maximum / minimum |
| Either signed zero | 0 | 0 |

Saturating special values follow [Rust's float-to-integer casts](https://doc.rust-lang.org/reference/expressions/operator-expr.html#numeric-cast). Unsigned minima are zero. Integer bit truncation and rounding when changing float widths are outside these operations.

For example, `ceil<u8>(-0.9)` yields 0, but `floor<u8>(-0.1)` is out of range. `round_ties_even<i8>(-128.5)` yields -128; `round<i8>(-128.5)` rounds to -129 and fails. `saturating_round<i8>(-128.5)` yields -128. A failure while evaluating the input retains that expression's reason and location; saturation does not hide it.

## Observing generation

| Stage | Retained information |
| --- | --- |
| AST / Cerune IR | `ConversionMode::Rounded { rounding, overflow }`, source/destination types, original spelling/expression/location |
| IR text | Policies such as `convert.floor.f64->i64` and `convert.saturating_floor.f64->i64`, plus NodeIds |
| Bytecode | The same policy and types, corresponding IR NodeId and Span |
| Constant evaluation | Original initializer and evaluated value together in the IR constant definition |
| Backend IR / generated code | Typed policy, rounding, range check/saturation, and conversion instructions or helpers |
| LLVM / ASM origin annotations | Trace calls and instructions to source expressions; internal-encoder objects retain origin symbols |
| Runtime failures | Compare reasons, original expression locations, and prior output across routes |

Matching execution results alone is insufficient. The [observation fixture](../../tests/fixtures/observation/rounding-conversions/source.ceru) records IR, bytecode, all textual outputs, annotated LLVM, and both OS assemblies. Saturation returns a normal value; this feature does not add runtime branch-count tracing.

## Generated steps

After handling nonfinite values, C, LLVM, QBE, and ASM safely truncate finite inputs with `|x| < 2^52` to `i64`. Converting that integer back to `f64` exactly gives a base; subtracting it gives the fraction. Adjust the integer by 0, +1, or -1 according to policy, using the original integer's parity for ties to even. Finite `f64` values with `|x| >= 2^52` are already integral. Inputs in `f32` are widened exactly first.

Do not implement nearest rounding as `floor(x + 0.5)`: addition can round a value immediately below 0.5, and negative inputs need different rules. The decomposition uses exactly representable floating-point operations and does not delegate the rounding policy to the host rounding mode. WAT uses `floor`, `ceil`, `trunc`, and `nearest` instructions, and decomposes ties-away `round` through fractional comparisons.

The existing checked `trunc` retains its equivalent input-bound checks followed by direct conversion. See the [truncation design](truncating-conversions.en.md) for those bounds.

After rounding, check `minimum <= x < maximum+1`. An exclusive upper bound avoids the float representation of `i64`/`u64` maxima rounding upward. Saturation returns endpoints as integer constants. Apply the language policy before an out-of-range C cast, LLVM poison, or built-in Wasm trap is possible. x86-64 uses existing SSE2 instructions and the internal encoder uses the same steps.

These observable artifacts precede external compiler optimization. Origin annotations are not guaranteed to remain one-to-one after external instruction deletion or merging. Execution is compared with and without C/LLVM optimization.

## Try it

```sh
cargo run --quiet -- run examples/rounding_quantities.ceru
cargo run --quiet -- emit-ir examples/rounding_quantities.ceru
cargo run --quiet -- emit-bytecode examples/rounding_conversions.ceru
cargo run --quiet -- emit-c examples/rounding_conversions.ceru
cargo run --quiet -- emit-llvm examples/rounding_conversions.ceru --target x86_64-unknown-linux-gnu --annotate-origins
cargo run --quiet -- emit-asm examples/rounding_conversions.ceru --target x86_64-pc-windows-msvc --annotate-origins
```

Compare [rounding modes](../../examples/rounding_conversions.ceru), [cells and required quantities](../../examples/rounding_quantities.ceru), [saturation](../../examples/saturating_conversions.ceru), and [evaluation order/copies](../../examples/rounding_evaluation_order.ceru) through VM, C, LLVM, QBE, WAT, Windows/Linux ASM, and the internal encoder.
