[![CI](https://github.com/Hokutaka/Cerune/actions/workflows/ci.yml/badge.svg)](https://github.com/Hokutaka/Cerune/actions/workflows/ci.yml)

# Cerune

[日本語](README.md) | English

Cerune is an experimental language for tracing computations through types, intermediate representations, and generated code. It prioritizes observability while keeping inspection separate from interference with compiler internals.

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

| Category | Support |
| --- | --- |
| Integers | `i8`, `i16`, `i32`, `i64`; `u8`, `u16`, `u32`, `u64` |
| Other types | `bool`, `f32`, `f64`, immutable UTF-8 `string` |
| Variables and operators | Static typing, `infer`, `mut`, arithmetic, comparisons, bit operations, short-circuit evaluation, explicit numeric conversion |
| Data structures | Structs, fixed arrays, nesting, value copies, array-element updates |
| Functions and control flow | Typed functions, `return`, `if` / `else`, `while`, `for`, `break` / `continue` |
| Modules | Explicit imports, namespaces, `pub` visibility |
| Strings | Printing, equality, UTF-8 byte length, use in functions, arrays, and structs |
| Diagnostics | Compare failure reasons, source locations, and prior output across routes |

**Arithmetic rules:** No implicit numeric conversions. Integer overflow, invalid integer division, out-of-bounds access, and conversions that cannot preserve the value stop execution. Floating-point arithmetic rounds.

**Not implemented:** Recursion, dynamic arrays, string concatenation/indexing, failure recovery, explicit rounding/truncation.

## Execution and Output

A shared Cerune IR feeds each output route. External compilers and linkers are selected by the caller.

| Command | Result / artifact | Use / target |
| --- | --- | --- |
| `check` / `run` | Syntax and type checking / VM execution | Cerune source (`.ceru`) |
| `emit-ir` | Cerune IR (`.ceir`) | Inspect types and operations |
| `emit-bytecode` | Bytecode text (`.cebc`) | Inspect instructions |
| `emit-c` | C (`.c`) | GCC, Clang, or another C compiler |
| `emit-llvm` | LLVM IR (`.ll`) | LLVM / Clang; Windows / Linux x86-64 |
| `emit-qbe` | QBE IR (`.ssa`) | QBE; Linux x86-64 |
| `emit-wat` | WebAssembly Text (`.wat`) | WebAssembly tools and a host |
| `emit-asm` | Assembly (`.s`) | Windows / Linux x86-64 |
| `emit-obj` | Cerune-encoded ELF / COFF (`.o` / `.obj`) | External linker; requires `--target` and `-o` |

Text goes to stdout; use `-o` to save it. LLVM / QBE string output and LLVM checked numeric operations require `--target`. WAT uses host functions for output and diagnostics.

## Examples and Development

| Task | Command |
| --- | --- |
| Run all examples (PowerShell) | `.\scripts\run-examples.ps1` |
| Run all examples (WSL / Bash) | `bash scripts/run-examples.sh` |
| Check expected example output | `cargo test --test examples` |
| Run fmt, Clippy, and all tests (WSL / Bash) | `bash scripts/test.sh` |

WSL needs its own Rust installation. Shell scripts default to `target/unix` for builds.

## Documentation and Related Tools

- [Examples by type and purpose](examples/README.en.md) · [Language](docs/reference/language.en.md) · [CLI](docs/reference/cli.en.md)
- [Design docs](docs/README.md) · [Roadmap](docs/design/language-roadmap.en.md) · [Migrating from Primer](docs/design/naming.en.md)
- [Tint\*](https://github.com/Hokutaka/Tint-St.): inspect source and generated representations side by side.
- [Whitebase](https://github.com/Hokutaka/Whitebase): measure and compare Rust, C++, and Assembly operations. Cerune integration is not implemented.

[MIT License](LICENSE)
