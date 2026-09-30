use cerune_lang::{diagnostic::Diagnostic, modules::Compilation};
use std::{env, fs, path::PathBuf, process};

fn main() {
    if let Err(error) = run() {
        eprintln!("cerune: {error}");
        process::exit(1);
    }
}

fn run() -> Result<(), String> {
    let mut args = env::args().skip(1);

    let Some(command) = args.next() else {
        print_help();
        return Ok(());
    };

    let (rest, string_heap_limit) = parse_string_heap_limit(args.collect(), &command)?;
    let mut args = rest.into_iter();
    match command.as_str() {
        // コードの構文チェック
        "check" => {
            let input = required_path(args.next(), "missing input file")?;

            reject_extra(args)?;

            let source = read_source(&input)?;

            render_compilation_result(cerune_lang::semantic::check(&source.program), &source)?;

            println!("OK {}", input.display());

            Ok(())
        }

        // 依存ファイルと正確な本文を明示的に出力します。
        "emit-sources" => {
            let input = required_path(args.next(), "missing input file")?;
            let rest: Vec<String> = args.collect();
            let output =
                parse_output_option(&rest, "cerune emit-sources <file> [-o <sources.json>]")?;
            let source = read_source(&input)?;
            ir_for(&source, string_heap_limit)?;
            write_or_print(output, source.source_manifest())
        }

        // Cerune IR 生成
        "emit-ir" => {
            let input = required_path(args.next(), "missing input file")?;

            let rest: Vec<String> = args.collect();

            let output = parse_output_option(&rest, "cerune emit-ir <file> [-o <output.ceir>]")?;

            let source = read_source(&input)?;

            let ir = render_compilation_result(
                Ok(cerune_lang::ir::text::emit(&ir_for(
                    &source,
                    string_heap_limit,
                )?)),
                &source,
            )?;

            write_or_print(output, ir)
        }

        // C コード生成
        "emit-c" => {
            let input = required_path(args.next(), "missing input file")?;

            let rest: Vec<String> = args.collect();

            let output = parse_output_option(&rest, "cerune emit-c <file> [-o <output.c>]")?;

            let source = read_source(&input)?;

            let c = render_compilation_result(
                cerune_lang::codegen::emit_c(&ir_for(&source, string_heap_limit)?),
                &source,
            )?;

            write_or_print(output, c)
        }

        // LLVM コード生成
        "emit-llvm" => {
            let input = required_path(args.next(), "missing input file")?;

            let rest: Vec<String> = args.collect();

            let (output, target, annotate_origins) =
                parse_native_options(&rest, "emit-llvm", "ll")?;
            let target = match target.as_deref() {
                None => None,
                Some(value) => Some(cerune_lang::codegen::llvm::Target::parse(value).ok_or_else(|| {
                    format!("unsupported LLVM target `{value}`; expected x86_64-unknown-linux-gnu or x86_64-pc-windows-msvc")
                })?),
            };

            let source = read_source(&input)?;

            let llvm = render_compilation_result(
                cerune_lang::codegen::llvm::emit_llvm_with_options(
                    &ir_for(&source, string_heap_limit)?,
                    cerune_lang::codegen::llvm::Options {
                        target,
                        annotate_origins,
                    },
                ),
                &source,
            )?;

            write_or_print(output, llvm)
        }

        // WAT コード生成
        "emit-wat" => {
            let input = required_path(args.next(), "missing input file")?;

            let rest: Vec<String> = args.collect();

            let output = parse_output_option(&rest, "cerune emit-wat <file> [-o <output.wat>]")?;

            let source = read_source(&input)?;

            let wat = render_compilation_result(
                cerune_lang::codegen::emit_wat(&ir_for(&source, string_heap_limit)?),
                &source,
            )?;

            write_or_print(output, wat)
        }

        // QBE コード生成
        "emit-qbe" => {
            let input = required_path(args.next(), "missing input file")?;

            let rest: Vec<String> = args.collect();

            let (output, target, _) = parse_native_options(&rest, "emit-qbe", "ssa")?;
            let target = match target.as_deref() {
                None => None,
                Some(value) => Some(cerune_lang::codegen::qbe::Target::parse(value).ok_or_else(
                    || {
                        format!(
                            "unsupported QBE target `{value}`; expected x86_64-unknown-linux-gnu"
                        )
                    },
                )?),
            };

            let source = read_source(&input)?;

            let qbe = render_compilation_result(
                cerune_lang::codegen::qbe::emit_qbe_with_target(
                    &ir_for(&source, string_heap_limit)?,
                    target,
                ),
                &source,
            )?;

            write_or_print(output, qbe)
        }

        // Direct Assembly コード生成
        "emit-asm" => {
            let input = required_path(args.next(), "missing input file")?;

            let rest: Vec<String> = args.collect();

            let (output, target, annotate_origins) = parse_native_options(&rest, "emit-asm", "s")?;
            let target = match target.as_deref() {
                None => cerune_lang::codegen::x86_64::Target::X86_64PcWindowsMsvc,
                Some(value) => cerune_lang::codegen::x86_64::Target::parse(value).ok_or_else(|| format!("unsupported assembly target `{value}`; expected x86_64-unknown-linux-gnu or x86_64-pc-windows-msvc"))?,
            };

            let source = read_source(&input)?;

            let asm = render_compilation_result(
                if annotate_origins {
                    cerune_lang::codegen::x86_64::emit_asm_with_origins(
                        &ir_for(&source, string_heap_limit)?,
                        target,
                    )
                } else {
                    cerune_lang::codegen::x86_64::emit_asm(
                        &ir_for(&source, string_heap_limit)?,
                        target,
                    )
                },
                &source,
            )?;

            write_or_print(output, asm)
        }

        // バイナリは出力先とターゲットを必須にし、端末へ暗黙に書き出しません。
        "emit-obj" => {
            let input = required_path(args.next(), "missing input file")?;
            let rest: Vec<String> = args.collect();
            let (output, target, origins) = parse_native_options(&rest, "emit-obj", "o")?;
            let output = output.ok_or("emit-obj requires -o <output.o>")?;
            let target = target.ok_or("emit-obj requires an explicit --target")?;
            let target = cerune_lang::codegen::x86_64::Target::parse(&target)
                .ok_or("unsupported native object target")?;
            let source = read_source(&input)?;
            let bytes = render_compilation_result(
                cerune_lang::codegen::x86_64::emit_object(
                    &ir_for(&source, string_heap_limit)?,
                    target,
                    origins,
                ),
                &source,
            )?;
            fs::write(&output, bytes)
                .map_err(|e| format!("failed to write {}: {e}", output.display()))
        }

        // Cerune Bytecode 生成
        "emit-bytecode" => {
            let input = required_path(args.next(), "missing input file")?;

            let rest: Vec<String> = args.collect();

            let output =
                parse_output_option(&rest, "cerune emit-bytecode <file> [-o <output.cebc>]")?;

            let source = read_source(&input)?;

            let bytecode = render_compilation_result(
                cerune_lang::bytecode::lower(&ir_for(&source, string_heap_limit)?)
                    .map(|program| cerune_lang::bytecode::format_program(&program)),
                &source,
            )?;

            write_or_print(output, bytecode)
        }

        // 同じ完成済みIRから、明示された実行経路を選びます。
        "run" | "run-ir" | "run-vm" => {
            let input = required_path(args.next(), "missing input file")?;
            let rest: Vec<_> = args.collect();
            let runtime_format = match rest.as_slice() {
                [] => false,
                [flag, format] if flag == "--diagnostic-format" && format == "runtime-v1" => true,
                _ => {
                    return Err(format!(
                        "usage: cerune {command} <file> [--diagnostic-format runtime-v1]"
                    ));
                }
            };

            let source = read_source(&input)?;

            let ir = ir_for(&source, string_heap_limit)?;
            let output = if command != "run-vm" {
                cerune_lang::ir_executor::run(&ir).map_err(|error| {
                    print!("{}", error.output());
                    if runtime_format && let Some(failure) = error.runtime_failure() {
                        return failure.record();
                    }
                    source.render(&error.diagnostic())
                })?
            } else {
                let bytecode =
                    render_compilation_result(cerune_lang::bytecode::lower(&ir), &source)?;
                cerune_lang::run_bytecode(&bytecode).map_err(|error| {
                    print!("{}", error.vm_error().output());
                    if runtime_format && let Some(failure) = error.runtime_failure() {
                        return failure.record();
                    }
                    source.render_execution(&error)
                })?
            };

            print!("{output}");

            Ok(())
        }

        "--version" | "-V" | "version" => {
            println!("cerune {}", env!("CARGO_PKG_VERSION"));

            Ok(())
        }

        "--help" | "-h" | "help" => {
            print_help();
            Ok(())
        }

        other => Err(format!("unknown command `{other}`")),
    }
}

fn render_compilation_result<T>(
    result: Result<T, Diagnostic>,
    source: &Compilation,
) -> Result<T, String> {
    result.map_err(|diagnostic| source.render(&diagnostic))
}

fn ir_for(
    source: &Compilation,
    string_heap_limit: u64,
) -> Result<cerune_lang::ir::Program, String> {
    let mut program = render_compilation_result(source.to_ir(), source)?;
    program.string_heap_limit = string_heap_limit;
    Ok(program)
}

fn parse_string_heap_limit(args: Vec<String>, command: &str) -> Result<(Vec<String>, u64), String> {
    let mut rest = Vec::new();
    let mut limit = None;
    let mut args = args.into_iter();
    while let Some(arg) = args.next() {
        if arg != "--string-heap-limit" {
            rest.push(arg);
            continue;
        }
        if !matches!(
            command,
            "run"
                | "run-ir"
                | "run-vm"
                | "emit-ir"
                | "emit-bytecode"
                | "emit-c"
                | "emit-llvm"
                | "emit-qbe"
                | "emit-wat"
                | "emit-asm"
                | "emit-obj"
        ) {
            return Err(format!("--string-heap-limit is not supported by {command}"));
        }
        if limit.is_some() {
            return Err("duplicate --string-heap-limit".into());
        }
        let text = args
            .next()
            .ok_or("missing byte count after --string-heap-limit")?;
        let value = text
            .parse::<u64>()
            .ok()
            .filter(|n| *n <= i64::MAX as u64)
            .filter(|_| !text.is_empty() && text.bytes().all(|b| b.is_ascii_digit()))
            .ok_or(
                "--string-heap-limit expects a decimal byte count from 0 to 9223372036854775807",
            )?;
        limit = Some(value);
    }
    Ok((
        rest,
        limit.unwrap_or(cerune_lang::ir::DEFAULT_STRING_HEAP_LIMIT),
    ))
}

fn required_path(value: Option<String>, message: &str) -> Result<PathBuf, String> {
    value.map(PathBuf::from).ok_or_else(|| message.to_owned())
}

fn read_source(path: &std::path::Path) -> Result<Compilation, String> {
    cerune_lang::modules::load(path).map_err(|error| error.render())
}

fn reject_extra(mut args: impl Iterator<Item = String>) -> Result<(), String> {
    if let Some(extra) = args.next() {
        Err(format!("unexpected argument `{extra}`"))
    } else {
        Ok(())
    }
}

fn parse_output_option(args: &[String], usage: &str) -> Result<Option<PathBuf>, String> {
    match args {
        [] => Ok(None),

        [flag, path] if flag == "-o" || flag == "--output" => Ok(Some(PathBuf::from(path))),

        _ => Err(format!("usage: {usage}")),
    }
}

fn parse_native_options(
    args: &[String],
    route: &str,
    extension: &str,
) -> Result<(Option<PathBuf>, Option<String>, bool), String> {
    let mut output = None;
    let mut target = None;
    let mut annotate_origins = false;
    let mut args = args.iter();
    while let Some(flag) = args.next() {
        if flag == "--annotate-origins"
            && matches!(route, "emit-llvm" | "emit-asm" | "emit-obj")
            && !annotate_origins
        {
            annotate_origins = true;
            continue;
        }
        match (flag.as_str(), args.next()) {
            ("-o" | "--output", Some(path)) if output.is_none() => {
                output = Some(PathBuf::from(path));
            }
            ("--target", Some(value)) if target.is_none() => {
                target = Some(value.clone());
            }
            _ => {
                return Err(format!(
                    "usage: cerune {route} <file> [--target <triple>] [-o <output.{extension}>]"
                ));
            }
        }
    }
    Ok((output, target, annotate_origins))
}

fn write_or_print(output: Option<PathBuf>, content: String) -> Result<(), String> {
    match output {
        Some(path) => fs::write(&path, content)
            .map_err(|e| format!("failed to write {}: {e}", path.display())),

        None => {
            print!("{content}");
            Ok(())
        }
    }
}

fn print_help() {
    println!(
        "Cerune {}\n\n\
         A small experimental language with observable code generation.\n\n\
         USAGE:\n\
           cerune check <file>\n\
           cerune emit-sources <file> [-o <sources.json>]\n\
           cerune emit-ir <file> [-o <output.ceir>]\n\
           cerune emit-c <file> [-o <output.c>]\n\
           cerune emit-llvm <file> [--target <triple>] [--annotate-origins] [-o <output.ll>]\n\
           cerune emit-wat <file> [-o <output.wat>]\n\
           cerune emit-qbe <file> [--target <triple>] [-o <output.ssa>]\n\
           cerune emit-asm <file> [--target <triple>] [--annotate-origins] [-o <output.s>]\n\
           cerune emit-obj <file> --target <triple> [--annotate-origins] -o <output.o>\n\
           cerune emit-bytecode <file> [-o <output.cebc>]\n\
           cerune run <file> [--diagnostic-format runtime-v1]\n\
           cerune run-ir <file> [--diagnostic-format runtime-v1]\n\
           cerune run-vm <file> [--diagnostic-format runtime-v1]\n\
           cerune --version\n\n\
         run / run-ir: direct Cerune IR execution; run-vm: Bytecode -> VM.\n\
         run / run-ir / run-vm / emit-* (except emit-sources): --string-heap-limit <bytes>\n\
         Default: 67108864 live dynamic string bytes; compile-time budget is independent.\n",
        env!("CARGO_PKG_VERSION")
    );
}
