# Cerune examples

[日本語](README.md)

This directory contains programs that can be read and executed with the current Cerune language. Each example demonstrates a different piece of syntax or method of computation in a small program.

Four [expected-failure examples](runtime_failures/README.en.md) separately demonstrate retained output and the source expression where execution stops.

The [file-origin example](source_files/README.en.md) uses the Rust API to validate the foundation for modules, parsing type/function definitions separately and comparing origins. These API components are outside the batch runner below. The [module examples](modules/README.en.md) use actual imports and provide a type table, modular/single-file programs, and a failure example.

## Run all examples

From the repository root, run the following command to display each example's name, output, status, and a final summary:

```powershell
.\scripts\run-examples.ps1
```

Use `-Pattern "matrix*.ceru"` to select examples. Use `-SkipBuild` to reuse an already built Cerune executable.

For WSL / Bash, use the following commands. WSL also needs its own Rust development environment.

```bash
bash scripts/run-examples.sh
bash scripts/run-examples.sh --pattern 'matrix*.ceru' --skip-build
```

The `.sh` script defaults to `target/unix/debug/cerune`, separate from Windows artifacts. It respects `CARGO_TARGET_DIR` when set. Use `--skip-build` only after building into the same output directory.

The runner checks each example's exit status. Use `cargo test --test examples` to compare expected output, or `bash scripts/test.sh` to run fmt, Clippy, and all test targets together.

## Find examples by type

Cerune supports eight integer kinds, `f32`/`f64`, `bool`, `string`, fixed arrays, products, and sums. The VM, C, LLVM, QBE, WAT, Windows/Linux ASM, and native objects support the same language features.

`u64_values.ceru` is compared against known output across the routes; [native_values.ceru](native_values.ceru) checks mixed arguments and value passing on Windows/Linux. For machine-code generation, execution, and observation, see the [explicit external-tool procedure](../docs/design/native-code.en.md) and [internal encoder design](../docs/design/native-encoder.en.md).

### Signed integers: negative and positive values

| Type | Range | Example | What to observe |
| --- | --- | --- | --- |
| `i8` | −128 through 127 | [sensor_calibration.ceru](sensor_calibration.ceru) | widening a small negative correction to `i16` before arithmetic |
| `i16` | −32768 through 32767 | [sensor_calibration.ceru](sensor_calibration.ceru) | signed readings, widened to `i32` for aggregation |
| `i32` | −2147483648 through 2147483647 | [maximum_subarray.ceru](maximum_subarray.ceru) | adding and comparing positive and negative changes |
| `i64` | −9223372036854775808 through 9223372036854775807 | [integer_limits.ceru](integer_limits.ceru) | minimum, maximum, and a check before overflow |

### Unsigned integers: nonnegative values and bits

| Type | Range | Example | What to observe |
| --- | --- | --- | --- |
| `u8` | 0 through 255 | [color_blending.ceru](color_blending.ceru), [bit_flags.ceru](bit_flags.ceru) | color channels and setting, clearing, or toggling eight bits |
| `u16` | 0 through 65535 | [color_blending.ceru](color_blending.ceru) | widening `u8` colors before addition, then converting the average back |
| `u32` | 0 through 4294967295 | [population_statistics.ceru](population_statistics.ceru) | values around three billion, widened to `i64` for aggregation |
| `u64` | 0 through 18446744073709551615 | [u64_values.ceru](u64_values.ceru), [packet_counter.ceru](packet_counter.ceru) | maximum, high bit, unsigned comparison/division, functions, arrays, copies, and exact conversions |

Run the u64 example with:

```sh
cargo run -- run examples/u64_values.ceru
```

Its first output lines are `u64`, `18446744073709551615`, `9223372036854775808`, and `0`. Reassigning the original binding preserves its copy, and the high bit remains part of a positive number. The [u64 design](../docs/design/u64.en.md) explains each target representation.

Out-of-range integer arithmetic stops instead of wrapping. Types do not mix implicitly: use explicit conversions such as `i64(value)` or `convert<i64>(value)`. Compare both spellings in [integer_conversions.ceru](integer_conversions.ceru). Integers without type information default to `i64`; array indices also use `i64`. Bit widths describe value ranges; generated targets currently store even small integers in 64-bit locations.

### Floating point: fractions and precision

| Type | Representation | Example | What to observe |
| --- | --- | --- | --- |
| `f32` | 32-bit floating point | [floating_point.ceru](floating_point.ceru), [logistic_map.ceru](logistic_map.ceru) | rounding and computation differences from `f64` |
| `f64` | 64-bit floating point | [floating_point.ceru](floating_point.ceru), [small_values.ceru](small_values.ceru) | small-value display and arithmetic rounding; floats without type information default to `f64` |

[measurement_statistics.ceru](measurement_statistics.ceru) and [normalized_histogram.ceru](normalized_histogram.ceru) convert between integers and floats. Explicit conversion succeeds only when it preserves the value. This is separate from rounding during ordinary floating-point arithmetic.

### Booleans and strings

| Type | Values | Example | What to observe |
| --- | --- | --- | --- |
| `bool` | `true` / `false` | [boolean_comparisons.ceru](boolean_comparisons.ceru), [short_circuit.ceru](short_circuit.ceru) | comparison, negation, and skipped evaluation through short-circuiting |
| `string` | immutable UTF-8 content | [string_values.ceru](string_values.ceru), [string_byte_length.ceru](string_byte_length.ceru) | Japanese text, equality, copies, and UTF-8 byte length rather than character count |

[string_origins.ceru](string_origins.ceru) traces string operations through Cerune IR and annotated LLVM. String content is immutable; mutable bindings can be reassigned.

### Arrays and products: combining types

| Type form | Example | What to observe |
| --- | --- | --- |
| Fixed array `[T; N]` | [fixed_arrays.ceru](fixed_arrays.ceru), [bubble_sort.ceru](bubble_sort.ceru) | indexing, element updates, and independent copies |
| Product `type Point { ... }` | [product-point.ceru](product-point.ceru), [product_arrays.ceru](product_arrays.ceru) | fields, defaults, and arrays of products |
| Nested arrays and products | [function_values.ceru](function_values.ceru), [u64_values.ceru](u64_values.ceru), [string_lookup.ceru](string_lookup.ceru) | combining numbers or strings and passing values to functions |

`infer` requests type inference; it is not a separate value type. `void` describes functions returning no value. See [floating_point.ceru](floating_point.ceru) and [functions.ceru](functions.ceru).

### Sum types: values for each alternative

| Example | Type and behavior |
| --- | --- |
| [sum_lookup.ceru](sum_lookup.ceru) | `enum Lookup`: found string/u64 payload or a missing entry |
| [sum_divide.ceru](sum_divide.ceru) | `enum Division`: success/zero-divisor/overflow values allow processing to continue |
| [sum_values.ceru](sum_values.ceru) | Array/product payloads, copies, construction order, reassignment inside an arm |
| [modules/sum_lookup.ceru](modules/sum_lookup.ceru) | Imported public enum, construction, exhaustive branching |

`cargo run -- run examples/sum_lookup.ceru` outputs `空\0\r\n\n6\n未登録\n`. Use `cargo run -- emit-ir examples/sum_lookup.ceru` to inspect variant tags, subject copies, and branches.

### Compile-time constants

| Example | What it demonstrates |
| --- | --- |
| [constants.ceru](constants.ceru) | u64 limits, strings, f32/struct/array constants, independent copies, and short circuiting |
| [modules/constants.ceru](modules/constants.ceru) | Imported public settings and a private calibration constant |

`cargo run -- run examples/constants.ceru` prints `128`, maximum u64, and the string byte length `9` first. A copied array can change to `99` while both struct constants retain `10`. Use `cargo run -- emit-ir examples/constants.ceru` to inspect initializer expressions and evaluated values.

### Product update expressions

| Example | Checks |
| --- | --- |
| [product_update.ceru](product_update.ceru) | Update u64, strings, arrays, and nested structs while preserving originals |
| [product_update_order.ceru](product_update_order.ceru) | Evaluate the base once, preserve field order, skip inherited defaults, short circuiting and loops |
| [modules/product_update.ceru](modules/product_update.ceru) | Update using imported types and functions |

```sh
cargo run -- run examples/product_update.ceru
cargo run -- run examples/product_update_order.ceru
```

The first example prints the original sequence `9223372036854775808` and updated `9223372036854775809`, then original array element `10` and updated `99`. The second starts with `base → default → replacement → 2`. The default runs only when creating the base, not during updates or copies. See the [update design](../docs/design/product-updates.en.md).

### Combining many arguments

[function_arguments.ceru](function_arguments.ceru) compares a nested seven-argument call with an eleven-argument value transfer.

| Type | What to observe |
| --- | --- |
| `i64` | `observed(1)` through `observed(7)` execute once in order; the nested call preserves the sum `28` |
| `u64` | The maximum value and high bit survive in arguments beyond the fourth |
| `f32`, `f64`, `bool` | Mixing with integers preserves `1.5`, `2.5`, and `true`; comparisons print `true` |
| `string` | Japanese text, NUL, CR, and LF pass through unchanged |
| Arrays and products | Updating a callee's array copy leaves the original unchanged; product results remain independent |

Run `cargo run -- run examples/function_arguments.ceru`. Output begins with `引数の評価順`, `1` through `7`, and `28`. There is no fixed parameter-count limit, but counts and types must match the declaration. See the [function design](../docs/design/functions.en.md) for placement and verification across routes.

## Basics and control flow

| Example | Demonstrates |
| --- | --- |
| [hello.ceru](hello.ceru) | a first example: name two integers, add them, and show the result with `print` |
| [short_circuit.ceru](short_circuit.ceru) | combining conditions with `&&`/`\|\|` to skip unnecessary division, indexing, and function calls |
| [conditional.ceru](conditional.ceru) | `if` / `else` and scope |
| [loop_control.ceru](loop_control.ceru) | `while`, `break`, and `continue` |
| [for_sum.ceru](for_sum.ceru) | `for` and assignment as its start statement |
| [functions.ceru](functions.ceru) | typed functions, parameters, results, and `void` functions |

## Data structures

These examples show how to group, access, and pass multiple values. They use structs (named product types) and fixed arrays, which are currently supported.

| Example | Demonstrates |
| --- | --- |
| [ring_buffer.ceru](ring_buffer.ceru) | cycling a storage position with `%` to keep the latest four values and their average |
| [string_lookup.ceru](string_lookup.ceru) | linear search by a string key in an array of structs, returning display text or a default |
| [product-point.ceru](product-point.ceru) | grouping point coordinates in a struct, with field defaults and access |
| [fixed_arrays.ceru](fixed_arrays.ceru) | indexing, summation, and linear search in fixed arrays, and independent values after copying |
| [product_arrays.ceru](product_arrays.ceru) | arrays of structs, nearest-point search, and array value copies |
| [function_values.ceru](function_values.ceru) | passing and returning structs and nested fixed arrays as values |
| [packet_counter.ceru](packet_counter.ceru) | Pass a high-bit u64 sequence, u8 flags, and immutable text in a product; run with the Cerune encoder |
| [native_values.ceru](native_values.ceru) | Pass u64, integers, floats, strings, and structures through four mixed arguments; follow execution and machine code on Windows/Linux |

## Numerical computation

| Example | Demonstrates |
| --- | --- |
| [measurement_statistics.ceru](measurement_statistics.ceru) | computing a fractional mean and variance from integer samples, then storing them exactly as `f32` |
| [normalized_histogram.ceru](normalized_histogram.ceru) | converting integer counts to probabilities and recovering the original counts |
| [square_root.ceru](square_root.ceru) | unrolled square-root approximation steps |
| [while_square_root.ceru](while_square_root.ceru) | repeated square-root approximation with `while` |
| [logistic_map.ceru](logistic_map.ceru) | result differences between `f32` and `f64` computation |
| [matrix_vector_product.ceru](matrix_vector_product.ceru) | multiplying a 3-by-3 matrix by a three-element vector using nested fixed arrays |
| [matrix_composition.ceru](matrix_composition.ceru) | passing structs and nested arrays through functions to compose 2-by-2 matrices and transform a vector |
| [population_statistics.ceru](population_statistics.ceru) | widening large `u32` values to `i64` for aggregation, returning average and maximum in a struct |
| [heat_diffusion.ceru](heat_diffusion.ceru) | four steps of heat diffusion along a rod, computing new temperatures from the previous array |
| [linear_regression.ceru](linear_regression.ceru) | learning a line from five points while observing slope, intercept, and loss |

## Algorithms

| Example | Demonstrates |
| --- | --- |
| [color_blending.ceru](color_blending.ceru) | widening `u8` color channels to `u16` before adding and averaging them |
| [sensor_calibration.ceru](sensor_calibration.ceru) | correcting `i16` readings with an `i8` offset, then aggregating in `i32` |
| [maximum_subarray.ceru](maximum_subarray.ceru) | maximum sum of a contiguous `i32` subarray, converting a `u32` position to an index |
| [subset_sum_bits.ceru](subset_sum_bits.ceru) | finding reachable sums together using shifts and bitwise OR |
| [euclidean_gcd.ceru](euclidean_gcd.ceru) | greatest common divisor with the Euclidean algorithm |
| [fibonacci.ceru](fibonacci.ceru) | the Fibonacci sequence and update order for multiple values |
| [factorial.ceru](factorial.ceru) | factorial with `for` |
| [collatz.ceru](collatz.ceru) | Collatz steps and conditional state transitions |
| [prime_check.ceru](prime_check.ceru) | trial-division primality testing and early exit |
| [integer_square_root.ceru](integer_square_root.ceru) | integer square root with binary search |
| [exponentiation_by_squaring.ceru](exponentiation_by_squaring.ceru) | exponentiation by squaring |
| [pythagorean_triples.ceru](pythagorean_triples.ceru) | Pythagorean triples with nested `for` loops |
| [bubble_sort.ceru](bubble_sort.ceru) | in-place bubble sort by swapping elements in a `mut` fixed array |
| [xor_neural_network.ceru](xor_neural_network.ceru) | XOR inference with a tiny neural network and fixed-array weights |
| [coin_change.ceru](coin_change.ceru) | dynamic programming for minimum coin counts, followed by reconstruction of the chosen coins |
| [shortest_paths.ceru](shortest_paths.ceru) | all-pairs shortest paths by gradually allowing more intermediate towns |

## Reading intermediate results

The new examples print intermediate values as well as final answers. Japanese comments in each file describe the output order.

- `coin_change.ceru`: minimum counts for amounts 1 through 6, then the selected coins, 3 and 3.
- `shortest_paths.ceru`: changes in the distance from town 0 to town 3, then the 4-by-4 distance table in row order. `-1` means unreachable.
- `heat_diffusion.ceru`: five temperatures per step for four steps, then the saved initial center temperature.
- `linear_regression.ceru`: initial loss; epoch, slope, intercept, and loss every ten epochs; then a prediction for a new input of 3.

Try changing `rate` (the size of each learning step) or the iteration count in the regression example and compare the loss. To inspect the representations at different stages, run:

```powershell
cargo run --quiet -- run examples/linear_regression.ceru
cargo run --quiet -- emit-ir examples/linear_regression.ceru
cargo run --quiet -- emit-bytecode examples/linear_regression.ceru
cargo run --quiet -- emit-c examples/linear_regression.ceru
```

`integer_limits.ceru` succeeds by default. Uncomment an expression at the end to observe an overflow stop and its diagnostic location.

## Current scope

These examples are programs expressible with numbers, booleans, strings, bindings, functions, conditionals, loops, named product types, and fixed arrays.

Elements of a `mut` array can be assigned directly, so in-place sorting and array-updating dynamic programming are expressible. Recursion and dynamically sized collections are not available yet.

The string examples support all seven existing routes. LLVM and QBE require explicit targets: QBE is validated on Linux x86-64, direct assembly on Windows x64 / Linux x86-64, and WAT in a WebAssembly environment providing the output host functions. `emit-ir` and `emit-bytecode` also expose type and content transformations.

Run QBE, WAT, and direct assembly comparisons with `cargo test --test string_routes`. [String design](../docs/design/strings.en.md#validation-scope) documents tool selection and validation scope.

For example, emit and compile the string-key lookup:

```sh
cargo run --quiet -- emit-c examples/string_lookup.ceru -o target/string_lookup.c
clang -std=c11 target/string_lookup.c -o target/string_lookup
```

Run the executable with `./target/string_lookup` in Bash or `.\target\string_lookup.exe` on Windows. An external C compiler is required.

For LLVM, use the Windows/Linux command examples in the [CLI reference](../docs/reference/cli.en.md#llvm-target-selection). `cargo test --test llvm_strings` compares VM, generated C, and generated LLVM output byte-for-byte. Setting `CERUNE_TEST_LLVM_CLANG` and `CERUNE_TEST_CC` makes unavailable selected compilers a test failure.

`cargo test --test c_strings` runs generated C with and without optimization and compares it with the VM. Execution comparisons skip when the default C compiler is unavailable; setting `CERUNE_TEST_CC` makes the selected compiler mandatory. CI requires Clang and also checks with AddressSanitizer and UndefinedBehaviorSanitizer.

`xor_neural_network.ceru` demonstrates inference with predetermined weights. `linear_regression.ceru` learns a line's slope and intercept from data using gradient descent. Training the XOR neural network itself is not included.

### Following string origins

`string_origins.ceru` demonstrates calls, string content equality, and short-circuit evaluation. Escaped output is `日本語\0\ntrue\nfalse\n`; `skipped` is never printed. Compare `emit-ir` with `emit-llvm --annotate-origins` to follow equality node #7 and short-circuit node #14 to calls and branches. See the [CLI walkthrough](../docs/reference/cli.en.md#following-llvm-origins).

### Inspecting string byte lengths

Run `cargo run -- run examples/string_byte_length.ceru` and inspect `emit-ir` or `emit-llvm --target x86_64-unknown-linux-gnu --annotate-origins` for the same input.

Output lines are `0, 9, 3, 2, 3, 4, 7, 3, 9, left, right, 9, false, false, 6, 10`, each followed by LF. The example exercises UTF-8 lengths, saved copies, calls, arrays, defaults, and evaluation order. Each of `left` and `right` is printed once; `skipped` is never printed. C, LLVM, QBE, WAT, and direct assembly are also executed against known expected bytes. See the [small observation fixture](../tests/fixtures/observation/string-byte-length/) for representations in every route.
