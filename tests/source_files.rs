#[path = "support/crash_dialogs.rs"]
mod crash_dialogs;
#[path = "support/process.rs"]
mod process;

use cerune_lang::{
    ast, bytecode, codegen,
    diagnostic::{Diagnostic, render},
    ir, lexer, parser, run_bytecode,
    source::{SourceId, SourceMap, Span},
};
use std::{
    ffi::OsString,
    fs,
    path::{Path, PathBuf},
    process::{Command, Output},
    time::Duration,
};

const LIBRARY: &str = include_str!("../examples/source_files/values.ceru");
const MAIN: &str = include_str!("../examples/source_files/main.ceru");
const FAILURE: &str = include_str!("../examples/source_files/failure.ceru");

fn split(entry: &str) -> (SourceMap, ir::Program) {
    let mut sources = SourceMap::new();
    let library = sources.add("values.ceru", LIBRARY);
    let entry = sources.add("entry.ceru", entry);
    let mut ast = ast::Program { items: Vec::new() };
    for id in [library, entry] {
        ast.items.extend(
            parser::parse(lexer::lex_source(sources.get(id).unwrap()).unwrap())
                .unwrap()
                .items,
        );
    }
    (sources, ir::builder::build(&ast).unwrap())
}

#[test]
fn file_positions_preserve_bytes_and_do_not_alias_equal_offsets_or_names() {
    let mut sources = SourceMap::new();
    let a = sources.add("same.ceru", "// 日本語\r\nprint(\"e\u{301}\0\r\n\");");
    let b = sources.add("same.ceru", "// 日本語\r\nprint(\"é\0\r\n\");");
    assert_ne!(a, b);
    assert_eq!(sources.files().count(), 2);
    let offset = sources.get(a).unwrap().text().find("print").unwrap();
    let span = Span::in_source(a, offset, offset + 5);
    assert_ne!(span, span.with_source(b));
    let (file, position) = sources.resolve(span).unwrap();
    assert_eq!(file.id(), a);
    assert_eq!((position.line(), position.column()), (2, 1));
    assert_eq!(sources.slice(span), Some("print"));
    assert!(sources.get(a).unwrap().text().contains("e\u{301}\0\r\n"));
    assert!(sources.get(b).unwrap().text().contains("é\0\r\n"));
    assert!(sources.resolve(Span::in_source(a, 4, 5)).is_none()); // UTF-8の途中
    assert!(sources.resolve(Span::in_source(a, 0, 999)).is_none());
    assert!(sources.resolve(Span::empty(0)).is_none());
    let end = sources.get(a).unwrap().text().len();
    assert!(sources.resolve(Span::in_source(a, end, end)).is_some());
}

#[test]
fn lex_parse_and_semantic_errors_identify_the_right_file() {
    for text in ["print(\"\\q\");", "print(1 + );", "print(unknown);"] {
        let mut sources = SourceMap::new();
        sources.add("decoy.ceru", "print(0);");
        let id = sources.add("計算\n\u{1b}.ceru", format!("// 日本語\r\n{text}"));
        let error = cerune_lang::compile_source(sources.get(id).unwrap()).unwrap_err();
        let span = error.primary_span().unwrap();
        assert_eq!(span.source_id(), id);
        let rendered = render::render_compact_with_sources(&error, &sources);
        assert!(rendered.contains(r"計算\n\u{1b}.ceru:2:"), "{rendered}");
        assert!(!rendered.contains("decoy"));
        // 単一ソース用rendererへ別の本文を渡しても、それを位置解決には使いません。
        assert!(render::render_compact(&error, "wrong").contains("file=2 byte"));
        assert!(
            render::render_compact_with_sources(&error, &SourceMap::new()).contains("file=2 byte")
        );
    }
    let mut sources = SourceMap::new();
    let a = sources.add("a", "print(");
    let b = sources.add("b", "1);");
    let mut tokens = lexer::lex_source(sources.get(a).unwrap()).unwrap();
    tokens.pop();
    tokens.extend(lexer::lex_source(sources.get(b).unwrap()).unwrap());
    assert!(
        parser::parse(tokens)
            .unwrap_err()
            .message()
            .contains("different source files")
    );
}

#[test]
fn runtime_origin_points_into_the_function_definition_and_keeps_prior_output() {
    let (sources, ir) = split(FAILURE);
    let error = run_bytecode(&bytecode::lower(&ir).unwrap()).unwrap_err();
    assert_eq!(error.vm_error().output(), "開始\n計算\n5\n計算\n");
    let failure = error.runtime_failure().unwrap();
    assert_eq!(failure.code.name(), "division-by-zero");
    assert_eq!(sources.slice(failure.span), Some("value / divisor"));
    assert_eq!(
        sources.resolve(failure.span).unwrap().0.name(),
        "values.ceru"
    );
    assert!(failure.record().contains(" file=1 bytes="));
    assert!(!failure.record().contains("values.ceru"));
    let text = cerune_lang::vm::render::render_compact_with_sources(
        error.vm_error(),
        &sources,
        failure.span,
    );
    assert!(text.contains("values.ceru:13:12"), "{text}");
    let diagnostic = Diagnostic::new("test", failure.span);
    assert!(
        render::render_compact_with_sources(&diagnostic, &sources).contains("values.ceru:13:12")
    );
}

#[test]
fn named_ir_and_annotations_keep_file_ids_without_embedding_paths() {
    let mut sources = SourceMap::new();
    let id = sources.add("private/path.ceru", "print(1 / 0);");
    let program = cerune_lang::compile_source_to_ir(sources.get(id).unwrap()).unwrap();
    assert_eq!(program.statements[0].span.source_id(), id);
    let llvm = codegen::llvm::emit_llvm_with_options(
        &program,
        codegen::llvm::Options {
            target: Some(codegen::llvm::Target::X86_64UnknownLinuxGnu),
            annotate_origins: true,
        },
    )
    .unwrap();
    let asm = codegen::x86_64::emit_asm_with_origins(
        &program,
        codegen::x86_64::Target::X86_64UnknownLinuxGnu,
    )
    .unwrap();
    for text in [llvm, asm] {
        assert!(text.contains("file=1 bytes"));
        assert!(!text.contains("private/path"));
    }
    assert_eq!(Span::new(0, 1).source_id(), SourceId::ANONYMOUS);
}

struct Workspace(PathBuf);

#[test]
fn simultaneous_source_workspaces_do_not_share_files_even_with_the_same_clock_value() {
    let barrier = std::sync::Arc::new(std::sync::Barrier::new(16));
    let handles: Vec<_> = (0..16)
        .map(|index| {
            let barrier = barrier.clone();
            std::thread::spawn(move || {
                barrier.wait();
                let workspace = Workspace::at_stamp(0);
                fs::write(workspace.0.join("marker"), index.to_string()).unwrap();
                (workspace, index)
            })
        })
        .collect();
    let workspaces: Vec<_> = handles
        .into_iter()
        .map(|handle| handle.join().unwrap())
        .collect();
    let paths: std::collections::BTreeSet<_> = workspaces.iter().map(|(w, _)| &w.0).collect();
    assert_eq!(paths.len(), 16);
    for (workspace, index) in &workspaces {
        assert_eq!(
            fs::read_to_string(workspace.0.join("marker")).unwrap(),
            index.to_string()
        );
    }
}

impl Workspace {
    fn new() -> Self {
        crash_dialogs::suppress();
        let stamp = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap()
            .as_nanos();
        Self::at_stamp(stamp)
    }
    fn at_stamp(stamp: u128) -> Self {
        use std::sync::atomic::{AtomicUsize, Ordering};
        static NEXT: AtomicUsize = AtomicUsize::new(0);
        // 同じ時刻の並列テストも分離し、既存ディレクトリを再利用しません。
        loop {
            let id = NEXT.fetch_add(1, Ordering::Relaxed);
            let path = std::env::temp_dir().join(format!(
                "cerune-source-files-{}-{stamp}-{id}",
                std::process::id()
            ));
            match fs::create_dir(&path) {
                Ok(()) => return Self(path),
                Err(error) if error.kind() == std::io::ErrorKind::AlreadyExists => continue,
                Err(error) => panic!("create test workspace: {error}"),
            }
        }
    }
    fn run(&self, command: &mut Command, label: &str) -> Output {
        process::bounded_output(command, &self.0, label, Duration::from_secs(30)).unwrap()
    }
    fn success(&self, command: &mut Command, label: &str) {
        let output = self.run(command, label);
        assert!(
            output.status.success(),
            "{label}: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }
    fn tool(&self, variable: &str, default: &str, flag: &str) -> Option<OsString> {
        let configured = std::env::var_os(variable);
        let tool = configured.clone().unwrap_or_else(|| default.into());
        let output = process::bounded_output(
            Command::new(&tool).arg(flag),
            &self.0,
            variable,
            Duration::from_secs(10),
        );
        if output.is_ok_and(|o| o.status.success()) {
            Some(tool)
        } else {
            assert!(
                configured.is_none(),
                "required tool unavailable: {variable}"
            );
            eprintln!("source-file execution skipped: {variable} unavailable");
            None
        }
    }
}
impl Drop for Workspace {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}

fn check_execution(program: &ir::Program, output: Output, route: &str) {
    let vm = run_bytecode(&bytecode::lower(program).unwrap());
    match vm {
        Ok(expected) => {
            assert!(output.status.success(), "{route}: {:?}", output.status);
            assert!(
                output.stderr.is_empty(),
                "{route}: {}",
                String::from_utf8_lossy(&output.stderr)
            );
            assert_eq!(output.stdout, expected.as_bytes(), "{route}");
        }
        Err(error) => {
            assert_eq!(
                output.stdout,
                error.vm_error().output().as_bytes(),
                "{route}"
            );
            assert_eq!(
                String::from_utf8(output.stderr)
                    .unwrap()
                    .replace("\r\n", "\n"),
                format!("cerune: {}\n", error.runtime_failure().unwrap().record()),
                "{route}"
            );
            if matches!(route, "wat" | "vm") {
                assert_eq!(output.status.code(), Some(1));
            } else {
                let illegal = matches!(route, "llvm" | "asm" | "object");
                #[cfg(unix)]
                {
                    use std::os::unix::process::ExitStatusExt;
                    assert_eq!(
                        output.status.signal(),
                        Some(if illegal { 4 } else { 6 }),
                        "{route}"
                    );
                }
                #[cfg(windows)]
                {
                    let code = output.status.code().map(|c| c as u32);
                    if illegal {
                        assert_eq!(code, Some(0xc000001d), "{route}");
                    } else {
                        assert!(matches!(code, Some(3 | 0xc0000409)), "{route}: {code:?}");
                    }
                }
            }
        }
    }
}

#[test]
fn split_and_single_file_examples_execute_identically_on_available_routes() {
    let w = Workspace::new();
    let cases = [
        (
            MAIN,
            "18446744073709551615\n2\n観測\0\r\n\nfalse\n計算\n5\n",
            None,
        ),
        (
            FAILURE,
            "開始\n計算\n5\n計算\n",
            Some(("division-by-zero", "value / divisor", "values.ceru")),
        ),
        (
            "print(\"添字\"); mut a: [u64; 1] = [0]; a[1] = divide(10, 0);",
            "添字\n",
            Some(("array-index-out-of-bounds", "[1]", "entry.ceru")),
        ),
    ];
    for (case, (entry, expected, failure)) in cases.into_iter().enumerate() {
        let (sources, split) = split(entry);
        let bytecode = bytecode::lower(&split).unwrap();
        let vm = run_bytecode(&bytecode);
        if let Some((code, expression, name)) = failure {
            let error = vm.unwrap_err();
            assert_eq!(error.vm_error().output(), expected);
            let record = error.runtime_failure().unwrap();
            assert_eq!(record.code.name(), code);
            assert_eq!(sources.slice(record.span), Some(expression));
            assert_eq!(sources.resolve(record.span).unwrap().0.name(), name);
        } else {
            assert_eq!(vm.unwrap(), expected);
        }
        let single = cerune_lang::compile_to_ir(&format!("{LIBRARY}\n{entry}")).unwrap();
        let single_vm = run_bytecode(&bytecode::lower(&single).unwrap());
        match single_vm {
            Ok(text) => {
                assert!(failure.is_none());
                assert_eq!(text, expected);
            }
            Err(error) => {
                assert_eq!(error.vm_error().output(), expected);
                assert_eq!(
                    error.runtime_failure().unwrap().code.name(),
                    failure.unwrap().0
                );
            }
        }
        for (form, program) in [("split", &split), ("single", &single)] {
            compare_routes(&w, program, None, &format!("{case}/{form}"));
        }
    }
}

fn compare_routes(w: &Workspace, program: &ir::Program, entry: Option<&Path>, label: &str) {
    let cc = w.tool("CERUNE_TEST_CC", "clang", "--version");
    let llvm = w.tool("CERUNE_TEST_LLVM_CLANG", "clang", "--version");
    let node = w.tool("CERUNE_TEST_NODE", "node", "--version");
    let qbe = if cfg!(target_os = "linux") {
        w.tool("CERUNE_TEST_QBE", "qbe", "-h")
    } else {
        None
    };
    let wat = std::env::var_os("CERUNE_TEST_WAT2WASM_JS");
    if let Some(wat) = &wat {
        assert!(Path::new(wat).is_file());
    } else {
        eprintln!("source-file WAT execution skipped: CERUNE_TEST_WAT2WASM_JS not configured");
    }
    let target = if cfg!(windows) {
        codegen::x86_64::Target::X86_64PcWindowsMsvc
    } else {
        codegen::x86_64::Target::X86_64UnknownLinuxGnu
    };
    for route in ["c", "llvm", "qbe", "asm", "object", "wat"] {
        let label = format!("{label}/{route}");
        if route == "wat" {
            if let (Some(node), Some(wat)) = (&node, &wat) {
                let input = w.0.join("program.wat");
                let wasm = w.0.join("program.wasm");
                fs::write(&input, artifact(w, program, entry, "wat", target)).unwrap();
                w.success(
                    Command::new(node).arg(wat).arg(&input).arg("-o").arg(&wasm),
                    &format!("{label}/compile"),
                );
                let output = w.run(
                    Command::new(node)
                        .arg(
                            Path::new(env!("CARGO_MANIFEST_DIR"))
                                .join("tests/support/run_wasm.cjs"),
                        )
                        .arg(wasm),
                    &format!("{label}/run"),
                );
                check_execution(program, output, route);
            }
            continue;
        }
        let compiler = if route == "llvm" {
            llvm.as_ref()
        } else {
            cc.as_ref()
        };
        let Some(compiler) = compiler else {
            continue;
        };
        if route == "qbe" && qbe.is_none() {
            continue;
        }
        let input = w.0.join(match route {
            "c" => "program.c",
            "llvm" => "program.ll",
            "object" => {
                if cfg!(windows) {
                    "program.obj"
                } else {
                    "program.o"
                }
            }
            _ => "program.s",
        });
        if route == "qbe" {
            let ssa = w.0.join("program.ssa");
            fs::write(&ssa, artifact(w, program, entry, route, target)).unwrap();
            w.success(
                Command::new(qbe.as_ref().unwrap())
                    .arg("-o")
                    .arg(&input)
                    .arg(ssa),
                &format!("{label}/lower"),
            );
        } else {
            fs::write(&input, artifact(w, program, entry, route, target)).unwrap();
        }
        for optimization in ["-O0", "-O2"] {
            let exe = w.0.join(if cfg!(windows) {
                "program.exe"
            } else {
                "program"
            });
            let mut command = Command::new(compiler);
            command.arg(optimization);
            if route == "llvm" {
                command.arg(format!("--target={}", target.triple()));
            }
            if route == "c" {
                command.args(["-std=c11", "-pedantic-errors"]);
            }
            command.arg(&input).arg("-o").arg(&exe);
            if !cfg!(windows) {
                command.arg("-lm");
            }
            w.success(&mut command, &format!("{label}/{optimization}/link"));
            check_execution(
                program,
                w.run(
                    &mut Command::new(exe),
                    &format!("{label}/{optimization}/run"),
                ),
                route,
            );
        }
    }
}

fn artifact(
    w: &Workspace,
    program: &ir::Program,
    entry: Option<&Path>,
    route: &str,
    target: codegen::x86_64::Target,
) -> Vec<u8> {
    if let Some(entry) = entry {
        let output = w.0.join("cli-artifact");
        let mut command = Command::new(env!("CARGO_BIN_EXE_cerune"));
        command
            .arg(if route == "object" {
                "emit-obj".into()
            } else {
                format!("emit-{route}")
            })
            .arg(entry)
            .arg("-o")
            .arg(&output);
        if matches!(route, "llvm" | "qbe" | "asm" | "object") {
            command.args(["--target", target.triple()]);
        }
        if matches!(route, "asm" | "object") {
            command.arg("--annotate-origins");
        }
        w.success(&mut command, &format!("cli/{route}"));
        return fs::read(output).unwrap();
    }
    match route {
        "c" => codegen::emit_c(program).unwrap().into_bytes(),
        "llvm" => codegen::llvm::emit_llvm_with_target(
            program,
            Some(codegen::llvm::Target::parse(target.triple()).unwrap()),
        )
        .unwrap()
        .into_bytes(),
        "wat" => codegen::emit_wat(program).unwrap().into_bytes(),
        "qbe" => codegen::qbe::emit_qbe_with_target(
            program,
            Some(codegen::qbe::Target::X86_64UnknownLinuxGnu),
        )
        .unwrap()
        .into_bytes(),
        "asm" => codegen::x86_64::emit_asm_with_origins(program, target)
            .unwrap()
            .into_bytes(),
        "object" => codegen::x86_64::emit_object(program, target, true).unwrap(),
        _ => unreachable!(),
    }
}

#[test]
fn module_cli_artifacts_execute_with_the_same_values_order_and_failure_origins() {
    let w = Workspace::new();
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("examples/modules");
    for (file, expected, failure) in [
        (
            "main.ceru",
            "18446744073709551615\n2\n観測\0\r\n\ntrue\nfalse\n計算\n5\n",
            None,
        ),
        ("product_update.ceru", "計算\n42\n5\n観測\0\r\n\n", None),
        (
            "product_update_failure.ceru",
            "開始\n計算\n",
            Some(("division-by-zero", 2, "value / divisor")),
        ),
        (
            "single.ceru",
            "18446744073709551615\n2\n観測\0\r\n\ntrue\nfalse\n計算\n5\n",
            None,
        ),
        (
            "failure.ceru",
            "開始\n計算\n5\n計算\n",
            Some(("division-by-zero", 2, "value / divisor")),
        ),
        (
            "array_update.ceru",
            "添字\n",
            Some(("array-index-out-of-bounds", 1, "[1]")),
        ),
    ] {
        let entry = root.join(file);
        let compilation = cerune_lang::modules::load(&entry).unwrap();
        let program = compilation.to_ir().unwrap();
        let result = run_bytecode(&bytecode::lower(&program).unwrap());
        if let Some((code, file_id, expression)) = failure {
            let error = result.unwrap_err();
            assert_eq!(error.vm_error().output(), expected);
            let failure = error.runtime_failure().unwrap();
            assert_eq!(failure.code.name(), code);
            assert_eq!(failure.span.source_id().index(), file_id);
            assert_eq!(compilation.sources.slice(failure.span), Some(expression));
        } else {
            assert_eq!(result.unwrap(), expected);
        }
        check_execution(
            &program,
            w.run(
                Command::new(env!("CARGO_BIN_EXE_cerune"))
                    .arg("run")
                    .arg(&entry)
                    .args(["--diagnostic-format", "runtime-v1"]),
                "cli/vm",
            ),
            "vm",
        );
        compare_routes(&w, &program, Some(&entry), file);
    }
}

#[test]
fn module_observation_keeps_dependency_sources_for_both_encoders() {
    let w = Workspace::new();
    let Some(node) = w.tool("CERUNE_TEST_NODE", "node", "--version") else {
        return;
    };
    let Some(cc) = w.tool("CERUNE_TEST_CC", "clang", "--version") else {
        return;
    };
    let Some(objdump) = w.tool(
        "CERUNE_TEST_OBJDUMP",
        if cfg!(windows) {
            "llvm-objdump"
        } else {
            "objdump"
        },
        "--version",
    ) else {
        return;
    };
    let root = Path::new(env!("CARGO_MANIFEST_DIR"));
    let target = if cfg!(windows) {
        "x86_64-pc-windows-msvc"
    } else {
        "x86_64-unknown-linux-gnu"
    };
    for encoder in ["external", "cerune"] {
        let directory = w.0.join(encoder);
        w.success(
            Command::new(&node)
                .arg(root.join("scripts/observe-native.cjs"))
                .arg("--source")
                .arg(root.join("examples/modules/failure.ceru"))
                .args(["--target", target, "--cerune", env!("CARGO_BIN_EXE_cerune")])
                .arg("--cc")
                .arg(&cc)
                .arg("--objdump")
                .arg(&objdump)
                .arg("--output-dir")
                .arg(&directory)
                .args(["--encoder", encoder, "--run", "--expect-trap"]),
            "module-observer",
        );
        let sources = fs::read_to_string(directory.join("sources.json")).unwrap();
        assert!(sources.contains("values.ceru"));
        assert!(sources.contains("pub fn divide"));
        let manifest = fs::read_to_string(directory.join("manifest.json")).unwrap();
        assert!(manifest.contains("expected-failure-confirmed"));
        assert!(manifest.contains("\"file\": 2"));
    }
}

#[test]
fn many_argument_cli_examples_preserve_order_copies_and_stack_values() {
    let w = Workspace::new();
    let entry = Path::new(env!("CARGO_MANIFEST_DIR")).join("examples/function_arguments.ceru");
    let program = cerune_lang::modules::load(&entry).unwrap().to_ir().unwrap();
    compare_routes(&w, &program, Some(&entry), "argument-example");

    // 両レジスタ群を別々に使い切り、もう一方の空きとスタック順序を確認します。
    // 引数ごとに異なる値を確認し、順序の取り違えを合計値で隠さないようにします。
    for (case, float_first) in [true, false].into_iter().enumerate() {
        let mut values = vec![
            ("i8", "-8"),
            ("u8", "255"),
            ("i16", "-1600"),
            ("u16", "65535"),
            ("i32", "-320000"),
            ("u32", "4294967295"),
            ("i64", "-9223372036854775808"),
            ("u64", "18446744073709551615"),
            ("bool", "true"),
            ("string", "\"観測\\0\\r\\n\""),
        ];
        let floats = vec![
            ("f32", "1.5"),
            ("f64", "2.5"),
            ("f32", "3.5"),
            ("f64", "4.5"),
            ("f32", "5.5"),
            ("f64", "6.5"),
            ("f32", "7.5"),
            ("f64", "8.5"),
            ("f32", "-0.0"),
            ("f64", "-0.0"),
        ];
        if float_first {
            values.splice(0..0, floats);
        } else {
            values.extend(floats);
        }
        let parameters = values
            .iter()
            .enumerate()
            .map(|(i, (ty, _))| format!("p{i}: {ty}"))
            .collect::<Vec<_>>()
            .join(", ");
        let arguments = values
            .iter()
            .map(|(_, value)| *value)
            .collect::<Vec<_>>()
            .join(", ");
        let checks = values
            .iter()
            .enumerate()
            .map(|(i, (ty, value))| {
                if *value == "-0.0" {
                    format!("print({ty}(1.0) / p{i} < {ty}(0.0));")
                } else {
                    format!("expected{i}: {ty} = {value}; print(p{i} == expected{i});")
                }
            })
            .collect::<String>();
        // 大きな集約引数をスタック経由で受け取り、集約戻り値の保存先も保ちます。
        let elements = vec!["9"; 600].join(", ");
        let source = format!(
            "type Row {{ value: u64, label: string, }}
            fn take({parameters}, row: Row, data: [i64; 600]) -> Row {{
                {checks} mut copy: [i64; 600] = data; copy[599] = 3;
                print(data[599]); print(copy[599]); return row;
            }}
            print(\"開始\"); original: Row = Row {{ value: 18446744073709551615, label: \"保持\" }};
            data: [i64; 600] = [{elements}];
            result: Row = take({arguments}, original, data);
            print(result.value); print(result.label); print(data[599]);"
        );
        let program = cerune_lang::compile_to_ir(&source).unwrap();
        assert_eq!(
            run_bytecode(&bytecode::lower(&program).unwrap()).unwrap(),
            format!(
                "開始\n{}9\n3\n18446744073709551615\n保持\n9\n",
                "true\n".repeat(values.len())
            )
        );
        compare_routes(&w, &program, None, &format!("argument-banks-{case}"));
    }
}

#[test]
fn many_argument_failure_preserves_prior_output_and_skips_later_arguments() {
    let w = Workspace::new();
    let source = r#"
        fn seen(value: i64) -> i64 { print(value); return value; }
        fn take(a: i64, b: i64, c: i64, d: i64, e: i64, f: i64, g: i64) -> bool {
            print("body"); return true;
        }
        print("開始");
        print(false && take(seen(1), 2, 3, 4, 5, 1 / 0, seen(7)));
        print(take(seen(1), seen(2), seen(3), seen(4), seen(5), 1 / 0, seen(7)));
    "#;
    let entry = w.0.join("arguments.ceru");
    fs::write(&entry, source).unwrap();
    let program = cerune_lang::modules::load(&entry).unwrap().to_ir().unwrap();
    let error = run_bytecode(&bytecode::lower(&program).unwrap()).unwrap_err();
    assert_eq!(error.vm_error().output(), "開始\nfalse\n1\n2\n3\n4\n5\n");
    let failure = error.runtime_failure().unwrap();
    assert_eq!(failure.code.name(), "division-by-zero");
    assert_eq!(failure.span.start(), source.rfind("1 / 0").unwrap());
    compare_routes(&w, &program, Some(&entry), "argument-failure");
}
