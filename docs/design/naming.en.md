# Cerune naming and migration

[日本語](naming.ja.md) | English

The language is renamed from Primer to Cerune. Derived from Cerulean, the name is shared by the language, CLI, and intermediate representation. The design priority of observability, language semantics, evaluation order, value copying, and string bytes are unchanged.

## Name mapping

| Component | Previous name | New name |
| --- | --- | --- |
| Language / GitHub repository | Primer | Cerune |
| CLI | `primer` | `cerune` |
| Cargo package / Rust crate | `primer-lang` / `primer_lang` | `cerune-lang` / `cerune_lang` |
| Source files | `.prim` | `.ceru` |
| Shared intermediate representation | Primer IR / `.pir` | Cerune IR / `.ceir` |
| Bytecode text output | `.pbc` | `.cebc` |
| Diagnostic prefix | `primer:` | `cerune:` |
| WAT host import module | `primer` | `cerune` |
| Source manifest JSON schema | `primer-sources-v1` | `cerune-sources-v1` |
| Native observation JSON schema | `primer-native-observation-v1` | `cerune-native-observation-v1` |
| Generated symbol prefix | `primer` | `cerune` |
| Validation tool environment variables | `PRIMER_TEST_*` | `CERUNE_TEST_*` |
| Observation script CLI selection | `--primer` | `--cerune` |
| Observation script internal encoder selection | `--encoder primer` | `--encoder cerune` |

The `.ceir` extension denotes Cerune IR: the shared, resolved representation independent of any output route, distinct from LLVM IR's `.ll`. The `.cebc` output is also currently text for inspection. This rename does not add a file loader for IR or bytecode.

C `.c`, LLVM `.ll`, QBE `.ssa`, WAT `.wat`, assembly `.s`, and COFF/ELF object formats are unchanged. The structural versions of IR and bytecode, and the `runtime-v1` diagnostic format, remain unchanged.

## Migrating existing code and tools

This early-development rename does not provide compatibility aliases for the old CLI or schema names.

1. Rename source files to `.ceru` and update imports, for example `import "./values.ceru" as values;`. Imports require relative `.ceru` paths. No extension restriction is added for an input file passed directly to the CLI.
2. Install `cerune` with `cargo install --path .`, then update commands and extensions in scripts and editor settings. A previously installed `primer` remains a separate executable; remove it with `cargo uninstall primer-lang` when it is no longer needed.
3. Change the WAT host import object to `cerune`. Regenerate artifacts and update diagnostic and observation JSON consumers using the table above. JSON information fields and failure codes are unchanged.
4. Pass `--cerune <executable>` to the native observation script. Select the internal encoder with `--encoder cerune`.

After editing source files, regenerate source manifests and artifacts together. Observed source names and positions describe the actual inputs. Keep historical artifacts with their original sources and tool version.

```sh
cerune run examples/modules/main.ceru
cerune emit-ir examples/modules/main.ceru -o main.ceir
cerune emit-bytecode examples/modules/main.ceru -o main.cebc
```

Rename validation compares example stdout byte for byte before and after the change, and checks that generated code and diagnostics match apart from the names above. Execution comparisons across routes continue to check failure codes, source locations, and output produced before failure.
