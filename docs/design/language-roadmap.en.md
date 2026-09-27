# Language capabilities and next steps

[日本語](language-roadmap.ja.md)

As of 2026-09-23, this inventory includes modules, removal of the parameter limit, product updates, compile-time constants, sum types with match, array-length queries, array iteration, constants in array type lengths, and functions with explicit type/length parameters. “Current” means implemented; candidates are proposals awaiting design and implementation. This document does not commit to candidate syntax or adoption. See the [language reference](../reference/language.en.md) for the current specification.

## Properties Cerune should preserve

Cerune prioritizes explaining a computation's meaning and its transformation into executable representations. New features should preserve these properties:

- Explicit types, evaluation order, short-circuiting, and failure conditions. No value loss through implicit numeric conversions.
- Independent values after copying. Updates through `mut` must not secretly change another value.
- Immutable UTF-8 strings preserving Japanese text, NUL, CR, and LF without Unicode normalization.
- Observable correspondence between source, Cerune IR, and artifacts. Observation must not expose an interface for changing running state.
- Explicit targets, artifact-consuming tools, and supported capabilities. The host OS must not silently select language behavior.

## Current language capabilities

| Area | Implemented | Limits and boundaries | Runnable examples |
| --- | --- | --- | --- |
| Signed integers | `i8`, `i16`, `i32`, `i64`, arithmetic, comparisons, bit operations | Out-of-range arithmetic stops; small types currently also occupy 64-bit storage | [sensor_calibration](../../examples/sensor_calibration.ceru), [integer_limits](../../examples/integer_limits.ceru) |
| Unsigned integers | `u8`, `u16`, `u32`, `u64` | `u64` covers 0–18446744073709551615; no implicit signedness changes or wrapping | [u64_values](../../examples/u64_values.ceru), [packet_counter](../../examples/packet_counter.ceru) |
| Floating point | `f32`, `f64` | Arithmetic rounds at the selected precision; `convert` preserves values; float-to-integer rounding and saturation are explicit | [floating_point](../../examples/floating_point.ceru) |
| Booleans | `bool`, comparisons, `!`, short-circuiting `&&` and `||` | No implicit numeric conversion | [short_circuit](../../examples/short_circuit.ceru) |
| Strings | `string`, printing, `==`, `!=`, `byte_len` | No concatenation, indexing, character count, or numeric conversion | [string_byte_length](../../examples/string_byte_length.ceru), [string_lookup](../../examples/string_lookup.ceru) |
| Fixed arrays | `[T; N]`, `array_len`, `for … in`, nesting, value passing, updates through `mut` | Length belongs to the type; indices are `i64`; no dynamic lengths or slices | [array_iteration](../../examples/array_iteration.ceru), [heat_diffusion](../../examples/heat_diffusion.ceru) |
| Named product types | Fields, defaults, update expressions, nesting, value passing | No direct field assignment; construct a new value and reassign the whole binding | [product-point](../../examples/product-point.ceru), [packet_counter](../../examples/packet_counter.ceru) |
| Functions and control flow | Typed parameters/results, explicit type/length parameters, `void`, `if`/`else`, `while`/`for`, `break`/`continue`/`return` | No fixed parameter-count limit; no recursion | [function_values](../../examples/function_values.ceru), [loop_control](../../examples/loop_control.ceru) |
| Bindings and conversions | Immutable by default, `mut`, explicit `infer`, `T(value)` and `convert<T>(value)` | `infer` is not a runtime type; five float-to-integer rounding modes and explicit saturation are supported | [integer_conversions](../../examples/integer_conversions.ceru) |
| Sum types | `enum` payload variants, exhaustive `match` | No guards, match expressions, or generic Option/Result | [sum_lookup](../../examples/sum_lookup.ceru) |
| Compile-time constants | Typed `const`, dependency evaluation, array type lengths, `pub const` | No function calls or block-local declarations | [constants](../../examples/constants.ceru) |
| Modules | Explicit imports, namespaces, function/type/constant visibility | Cycles/private access diagnosed; no re-exports, module variables, or package distribution | [modules](../../examples/modules/README.en.md) |

The [example type tables](../../examples/README.en.md) list ranges and applications. Whole-array, whole-product, and whole-sum printing and equality are not implemented.

## Separate language features from output routes

These language features are supported by the VM, generated C, LLVM, QBE, WAT, Windows/Linux direct assembly, and objects from Cerune's own encoder. Windows/Linux distinguish targets; assembly/objects distinguish artifacts. Use the [route and target table](targets.en.md) when counting them.

The native encoder generates x86-64 instructions and COFF/ELF objects. It shares assembly lowering and currently reads an internal assembly representation to encode it. Linking uses external tools. A typed machine-instruction IR or an internal linker would be compiler implementation work, not new language features. See the [native encoder design](native-encoder.en.md).

Language support does not imply equal observation detail. Language check failures have comparable reasons, source locations, and prior output across all routes. LLVM/assembly origin annotations still do not promise debugging information across all routes and optimization stages.

## Proposed priorities

`array_len`, array `for … in`, constant lengths `[T; COUNT]`, and [functions with type/length parameters](generic-functions.en.md) are implemented, along with [explicit rounding and saturation](rounding-conversions.en.md). Add missing features in the order below, pairing a small design with examples and cross-route comparisons. Each stage determines its syntax and adoption.

| Order | Missing feature | First contract and example |
| --- | --- | --- |
| 1 | Aggregate comparison/printing and extended branching | Comparison order and display formats for arrays/products/sums; evaluation order for match expressions/guards. Add needed operations separately |
| 2 | Dynamic data, recursion, external I/O | Define ownership, lifetimes, allocation failure, call storage, resource limits, and effects first. Introduce slices, concatenation, and files in stages |
| 3 | Module distribution | Re-exports, dependencies/versions, reproducible builds; extend explicit imports |
| Experiment | GPU numeric computation | Narrow the supported types, memory, synchronization, and diagnostics; compare independent element computations with the CPU |

Existing foundations are [common failure records](runtime-diagnostics.en.md), [file origins](source-files.en.md), [modules](modules.en.md), [constants](constants.en.md), [functions](functions.en.md), [product updates](product-updates.en.md), [sums](sum-types.en.md), and [fixed arrays](fixed-arrays.en.md). The [mixed-argument](../../examples/function_arguments.ceru) and [array-length](../../examples/array_length.ceru) examples check value passing and evaluation order.

This is not a commitment to implement everything together. GPU experiments need not await every stage. Inheritance, implicit shared mutable references, automatic GPU dispatch, and general async facilities are not prioritized without evidence from current examples.

## GPU direction

GPU execution is worth including as a future target. Observing how sequential CPU computations become parallel element computations fits Cerune's purpose. GPU generation and execution are currently unimplemented. This proposal concerns computation, not a graphics API.

### Decide types and execution contracts first

Selecting an LLVM GPU backend does not make existing programs run unchanged. NVPTX distinguishes host-launchable kernels from device functions and defines GPU address spaces. CPU output helpers also cannot simply be assumed. See the [LLVM NVPTX guide](https://llvm.org/docs/NVPTXUsage.html).

The API and hardware have not been selected:

| Candidate | Considerations |
| --- | --- |
| WebGPU / WGSL | A possible starting point for a limited 32-bit numeric experiment. WGSL runtime scalar types do not include `u64` or `f64`, so this would not support all current Cerune types |
| Vulkan / SPIR-V | Query features such as `shaderInt64` and `shaderFloat64`; do not assume 64-bit support on every device |
| LLVM NVPTX / CUDA | An NVIDIA-targeted option requiring kernel calling conventions, memory rules, and host launch/result handling |

These constraints follow from [WGSL scalar types](https://www.w3.org/TR/WGSL/#scalar-types) and [Vulkan features](https://docs.vulkan.org/spec/latest/chapters/features.html). Unsupported `u64` values must never silently become `f32`. Reject unsupported capabilities explicitly, or separately verify an implementation that preserves their meaning.

At minimum, GPU support should expose:

- Input/output element types, lengths, layouts, host/device ownership boundaries, transfers, and readback.
- The relationship between logical elements and work, dispatch bounds, and synchronization. Observation APIs must not enable external mutation during execution.
- Integer range and index checks, with a contract for recovering failure reason, source location, and logical element index.
- Floating-point rounding, operation grouping, and comparison policy. Declare any tolerance in advance without silently weakening existing CPU semantics.
- Separate compilation, transfer, kernel execution, and readback timings. Do not assume small examples become faster.

Do not equate global GPU execution order with CPU `print` order. Initially prohibit output inside kernels and explicitly print results in element order on the host after readback. See the [Vulkan compute tutorial](https://docs.vulkan.org/tutorial/latest/11_Compute_Shader.html) for synchronization requirements.

### First experiment and completion criteria

1. Choose elementwise addition/transformation with read-only input arrays and disjoint output writes. Initially require a restricted form whose ranges and indices can be checked for safety.
2. Generate for explicit types, hardware, and tools, and compare against known CPU answers. Reject unsupported types or computations whose safety is not established.
3. Before supporting general computation, implement failure reporting. Define an execution-order-independent rule for multiple failures, such as selecting the smallest logical element index.
4. Separately verify element counts not divisible by the workgroup size, bounds failures, overflow, missing capabilities, and transfer failures.
5. Then expand to matrix operations and heat diffusion. [matrix_vector_product](../../examples/matrix_vector_product.ceru) and [heat_diffusion](../../examples/heat_diffusion.ceru) are existing CPU comparison examples, not implemented GPU examples. Replacing the latter's `f64` with `f32` for a limited route would be a separately typed experiment.

The initial experiment excludes conflicting shared writes, atomics, parallel reductions, graphics, and an internal GPU machine-code encoder.

## Completion criteria for language additions

Update Japanese design rationale, matching English documentation, a small example categorized by type, known expected results, and successful/failing execution comparisons together. Distinguish normal completion, expected diagnostics/stops, unexpected failures, and unexecuted checks. A nonzero exit alone is not evidence of success.

For common language additions, preserve semantics across existing routes and verify evaluation order, short-circuiting, independent copies, string bytes, and origins. Limited experiments such as GPU support must declare their scope; do not claim full route parity while features remain unsupported.
