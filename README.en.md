[![CI](https://github.com/Hokutaka/Cerune/actions/workflows/ci.yml/badge.svg)](https://github.com/Hokutaka/Cerune/actions/workflows/ci.yml)

# Cerune

[日本語](README.md) | English

Cerune is an experimental programming language with static typing, VM execution, and code generation in multiple formats.

## Try It

Requires Rust (rustup and Cargo).

```sh
git clone https://github.com/Hokutaka/Cerune.git
cd Cerune
cargo install --path .
cerune run examples/floating_point.ceru
```

The same addition produces different results depending on the type. Comments show the output.

```cerune
a: f32 = 0.1 + 0.2;
b: f64 = 0.1 + 0.2;
c: infer = 0.1 + 0.2;

print(a); // 0.300000012
print(b); // 0.30000000000000004
print(c); // 0.30000000000000004 (infer resolves to f64)
```

```sh
cerune emit-ir examples/floating_point.ceru
cerune emit-c examples/floating_point.ceru -o floating_point.c
```

During development, replace `cerune` with `cargo run --quiet --`.

## Capabilities

### Types

| Category | Types / operations |
| --- | --- |
| Signed integers | `i8`, `i16`, `i32`, `i64` |
| Unsigned integers | `u8`, `u16`, `u32`, `u64` |
| Floating point | `f32`, `f64` |
| Boolean | `bool` (`true` / `false`) |
| Strings | Immutable UTF-8 `string`; printing, equality, byte count with `byte_len` |

### Syntax and Operations

| Feature | Support |
| --- | --- |
| Variables | Explicit types or inference with `infer`; immutable by default, reassignable with `mut` |
| Operators | Arithmetic, remainder, comparisons, bit operations, logical negation, short-circuit evaluation |
| Numeric conversion | Explicit value-preserving conversions such as `f64(x)` / `convert<f64>(x)` |
| Structs | Named types, field access and defaults, updates that create new values, nesting, value copies |
| Sum types | `enum` variants with payloads; exhaustive `match` statements |
| Arrays | Fixed length, element counts with `array_len`, nesting, element access and updates, value copies |
| Functions | Typed parameters and returns, `void`, `return`; strings, structs, arrays, and sums can also be passed and returned |
| Entry point | Top-level statements or `fn main() -> void` (not both) |
| Control flow | `if` / `else`, `while`, `for`, `break` / `continue` |
| Constants | Typed `const`, compile-time evaluation, shared with `pub const` |
| Modules | Explicit imports, namespaces, `pub` visibility |
| Output and diagnostics | `print(expr);`, error reasons, source locations, output produced before failure |

**Arithmetic rules:** No implicit numeric conversions. Integer overflow, invalid integer division, out-of-bounds access, and conversions that cannot preserve the value stop execution. Floating-point arithmetic rounds.

**Not implemented:** Recursion, dynamic arrays, string concatenation/indexing, catching runtime stops, explicit rounding/truncation.

## Execution and Output

| Command | Result / artifact | Use / target |
| --- | --- | --- |
| `check` | Syntax and type checking | Validate Cerune source (`.ceru`) |
| `run` | VM execution | Run Cerune source (`.ceru`) |
| `emit-sources` | Source manifest (JSON) | Export loaded file names and contents |
| `emit-ir` | Cerune IR (`.ceir`) | Inspect types and operations |
| `emit-bytecode` | Bytecode text (`.cebc`) | Inspect instructions |
| `emit-c` | C (`.c`) | GCC, Clang, or another C compiler |
| `emit-llvm` | LLVM IR (`.ll`) | LLVM / Clang; Windows / Linux x86-64 |
| `emit-qbe` | QBE IR (`.ssa`) | QBE; Linux x86-64 |
| `emit-wat` | WebAssembly Text (`.wat`) | WebAssembly tools and a host |
| `emit-asm` | Assembly (`.s`) | Windows / Linux x86-64 |
| `emit-obj` | ELF / COFF object (`.o` / `.obj`) | External linker; requires `--target` and `-o` |

Text goes to stdout; use `-o` to save it. LLVM / QBE string output and LLVM checked numeric operations require `--target`. WAT uses host functions for output and diagnostics.

## Examples and Development

| Task | Command |
| --- | --- |
| Run all examples (PowerShell) | `.\scripts\run-examples.ps1` |
| Run all examples (WSL / Bash) | `bash scripts/run-examples.sh` |
| Filter examples | PowerShell: `-Pattern "matrix*.ceru"`; Bash: `--pattern 'matrix*.ceru'` |
| Check expected example output | `cargo test --test examples` |
| Run fmt, Clippy, and all tests (WSL / Bash) | `bash scripts/test.sh` |

WSL needs its own Rust installation. Shell scripts default to `target/unix` for builds.

## Documentation and Related Tools

- [Examples by type and purpose](examples/README.en.md) · [Language](docs/reference/language.en.md) · [CLI](docs/reference/cli.en.md)
- [Design docs](docs/README.md) · [Roadmap](docs/design/language-roadmap.en.md) · [Migrating from Primer](docs/design/naming.en.md)
- [Tint\*](https://github.com/Hokutaka/Tint-St.): inspect source and generated representations side by side.
- [Whitebase](https://github.com/Hokutaka/Whitebase): measure and compare Rust, C++, and Assembly operations. Cerune integration is not implemented.

[MIT License](LICENSE)
