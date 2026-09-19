# Module examples

[日本語](README.md)

| File | Types and expressions | Checks |
| --- | --- | --- |
| [constant_settings.ceru](constant_settings.ceru) | `pub const`, structs, private constants | Evaluate shared settings and calibration values at compilation |
| [constants.ceru](constants.ceru) | Imported constants and copies | Print `129 → 12 → 10 → 99`, then `設定\0\r\n` |
| [values.ceru](values.ceru) | `u64`, `string`, product, public functions | Public type defaults and private helpers called by public functions |
| [main.ceru](main.ceru) | `values::Reading`, fixed arrays, copies, short circuiting | Maximum u64, independent reassignment, string bytes/equality, skipped right operand |
| [single.ceru](single.ceru) | The same computation in one file | Identical values and output order before and after splitting |
| [product_update.ceru](product_update.ceru) | Update a public type | Preserve the original and inherit its label |
| [product_update_failure.ceru](product_update_failure.ceru) | Division by zero while constructing the base | Skip subsequent fields and report the definition-file failure |
| [failure.ceru](failure.ceru) | Successful call followed by division by zero | Prior output and the definition-file division origin |
| [array_update.ceru](array_update.ceru) | Array assignment target check and a public function call | An invalid index prevents evaluation of the right-hand call |

```sh
cargo run -- run examples/modules/main.ceru
cargo run -- run examples/modules/single.ceru
cargo run -- run examples/modules/failure.ceru --diagnostic-format runtime-v1
cargo run -- emit-sources examples/modules/main.ceru -o target/module-sources.json
```

`main.ceru` and `single.ceru` produce `18446744073709551615\n2\n観測\0\r\n\ntrue\nfalse\n計算\n5\n` in escaped-byte notation. Loading `values.ceru` does not execute `announce`; only an evaluated call to `divide` prints `計算`.

`product_update.ceru` outputs `計算\n42\n5\n観測\0\r\n\n`. `product_update_failure.ceru` stops with `division-by-zero` and `file=2` after `開始\n計算\n`, without evaluating the subsequent `amount` field.

The failure example intentionally exits with code 1 after `開始\n計算\n5\n計算\n`, reporting `code=division-by-zero` and `file=2`. Human-readable diagnostics identify `values.ceru:17:12`, the expression `value / divisor`. NodeIds and byte ranges may change with edits and line endings. Distinguish success, expected failure, and unexpected failure.

`array_update.ceru` intentionally reports `array-index-out-of-bounds` and `file=1` after `添字\n`. It stops at `[1]` in the entry file, so the right-hand `divide` is not evaluated and `計算` is not printed.

The same entry works with `emit-c`, `emit-llvm`, `emit-qbe`, `emit-wat`, `emit-asm`, and `emit-obj`. Existing LLVM/QBE/native-object target requirements still apply. `cargo test --test modules --test source_files -- --nocapture` checks module rules and available execution routes.

These components and failure examples are separate from the root normal-example batch runner. See the [module design](../../docs/design/modules.en.md) and [CLI reference](../../docs/reference/cli.en.md).
