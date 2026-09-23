# Module examples

[日本語](README.md)

Compare imported modules with a single-file program. This directory is outside the root normal-example batch runner.

## Successful examples

| Entry | Types and expressions | Checks |
| --- | --- | --- |
| [main.ceru](main.ceru) | `values::Reading`, arrays, copies, short circuiting | Maximum u64, independent copies, string bytes/equality, skipped right operand |
| [single.ceru](single.ceru) | The same program in one file | Identical values and output order after splitting |
| [sum_lookup.ceru](sum_lookup.ceru) | `values::Lookup::Found`, `match` | `空\0\r\n`, missing entry, directly constructed text |
| [constant_array_lengths.ceru](constant_array_lengths.ceru) | Public constants in type lengths | `共有サイズ → 6 → 15`, then `保持\0\r\n` |
| [generic_functions.ceru](generic_functions.ceru) | Public functions with explicit types/lengths | Shared-type string bytes, private sizes, maximum u64 |
| [constants.ceru](constants.ceru) | Imported constants and copies | Print `129 → 12 → 10 → 99`, then `設定\0\r\n` |
| [product_update.ceru](product_update.ceru) | Update a public type | Preserve the original and inherit its label |

```sh
cargo run -- run examples/modules/main.ceru
cargo run -- run examples/modules/single.ceru
cargo run -- emit-sources examples/modules/main.ceru -o target/module-sources.json
```

`\0`, `\r`, and `\n` denote NUL, CR, and LF.

| Entry | stdout |
| --- | --- |
| `main.ceru` / `single.ceru` | `18446744073709551615\n2\n観測\0\r\n\ntrue\nfalse\n計算\n5\n` |
| `product_update.ceru` | `計算\n42\n5\n観測\0\r\n\n` |

## Expected stops

These exit with code 1 in the VM. Check the reason, location, and prior output together.

| Entry | stdout before stopping | Reason, location, and skipped work |
| --- | --- | --- |
| [failure.ceru](failure.ceru) | `開始\n計算\n5\n計算\n` | `division-by-zero`, `file=2`: `value / divisor` at `values.ceru:17:12` |
| [product_update_failure.ceru](product_update_failure.ceru) | `開始\n計算\n` | `division-by-zero`, `file=2` while constructing the base; skip the subsequent `amount` field |
| [array_update.ceru](array_update.ceru) | `添字\n` | `array-index-out-of-bounds`, `file=1` at `[1]`; skip the right-hand `divide` call and its `計算` output |

```sh
cargo run -- run examples/modules/failure.ceru --diagnostic-format runtime-v1
```

NodeIds and byte ranges change with edits and line endings. Distinguish expected stops from unexpected failures.

## Imported components

| File | Definitions |
| --- | --- |
| [values.ceru](values.ceru) | Public product with `u64`/`string` fields and defaults, public functions, private helpers |
| [lookup_values.ceru](lookup_values.ceru) | `pub enum`, constants, and functions returning present/absent values |
| [generic_arrays.ceru](generic_arrays.ceru) | Public generic functions, type/constant, and a private implementation size |
| [dimensions.ceru](dimensions.ceru) | Public row/column counts and a private constant determining a public type length |
| [constant_settings.ceru](constant_settings.ceru) | `pub const`, products, private constants; settings and calibration evaluated at compilation |

Loading `values.ceru` alone does not execute `announce`. Only an evaluated call to `divide` prints `計算`.

## Generated output and checks

Pass the same entry to `emit-c`, `emit-llvm`, `emit-qbe`, `emit-wat`, `emit-asm`, or `emit-obj`. LLVM, QBE, and objects require explicit targets. Also select the ASM target explicitly; omission uses the fixed Windows default.

```sh
cargo test --test modules --test source_files -- --nocapture
```

This checks syntax, visibility, and available execution routes. See the [module rules](../../docs/design/modules.en.md) and [CLI](../../docs/reference/cli.en.md).
