//! QBE 1.3のWindows ABIをIR/VMと比較します。外部ツール未設定は成功扱いにしません。
use cerune_lang::{
    codegen::qbe::{self, Target},
    compile_to_ir,
};

#[test]
fn explicit_targets_select_the_abi_without_consulting_the_host() {
    let program =
        compile_to_ir("print(concat(\"日本語\\0\\r\\n\", \"!\")); print(1 / 0);").unwrap();
    let windows = qbe::emit_qbe_with_target(&program, Some(Target::X86_64PcWindowsMsvc)).unwrap();
    let linux = qbe::emit_qbe_with_target(&program, Some(Target::X86_64UnknownLinuxGnu)).unwrap();
    assert!(windows.contains("(qbe -t amd64_win)"));
    assert!(windows.contains("section \".rdata\""));
    assert!(!windows.contains("section \".rodata\""));
    assert!(windows.contains("call $_setmode(w 1, w 32768)"));
    assert!(windows.contains("call $_setmode(w 2, w 32768)"));
    assert!(windows.contains("call $_write(w 2"));
    assert!(linux.contains("(qbe -t amd64_sysv)"));
    assert!(linux.contains("section \".rodata\""));
    assert!(!linux.contains("$_setmode"));
    assert!(!linux.contains("$_write"));
    assert_eq!(
        windows,
        qbe::emit_qbe_with_target(&program, Some(Target::X86_64PcWindowsMsvc)).unwrap()
    );
    assert!(qbe::emit_qbe(&program).is_err());
    assert!(Target::parse("aarch64-pc-windows-msvc").is_none());
    assert_eq!(
        Target::parse("x86_64-pc-windows-msvc"),
        Some(Target::X86_64PcWindowsMsvc)
    );
}

#[cfg(windows)]
use string_cases::concat_cases;
#[cfg(windows)]
#[path = "support/crash_dialogs.rs"]
mod crash_dialogs;
#[cfg(windows)]
#[path = "support/process.rs"]
mod process;
#[cfg(windows)]
#[path = "support/runtime_cases.rs"]
mod runtime_cases;
#[cfg(windows)]
#[allow(dead_code)]
#[path = "support/string_cases.rs"]
mod string_cases;
#[cfg(windows)]
#[allow(dead_code)]
#[path = "support/u64_cases.rs"]
mod u64_cases;

#[cfg(windows)]
mod execution {
    use super::*;
    use cerune_lang::{bytecode, ir, ir_executor, modules, run_bytecode};
    use std::{
        ffi::OsString,
        fs,
        path::{Path, PathBuf},
        process::{Command, Output},
        time::Duration,
    };

    struct Harness {
        directory: PathBuf,
        qbe: OsString,
        clang: OsString,
    }
    impl Harness {
        fn new() -> Self {
            crash_dialogs::suppress();
            let qbe = std::env::var_os("CERUNE_TEST_QBE")
                .expect("set CERUNE_TEST_QBE to the QBE 1.3 executable");
            let clang = std::env::var_os("CERUNE_TEST_QBE_CLANG")
                .expect("set CERUNE_TEST_QBE_CLANG to Clang with the MSVC toolchain");
            let directory =
                PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("target/qbe-windows-observations");
            fs::create_dir_all(&directory).unwrap();
            Self {
                directory,
                qbe,
                clang,
            }
        }
        fn command(&self, command: &mut Command, directory: &Path, label: &str) -> Output {
            process::bounded_output(command, directory, label, Duration::from_secs(30)).unwrap()
        }
        fn success(&self, command: &mut Command, directory: &Path, label: &str) {
            let output = self.command(command, directory, label);
            assert!(
                output.status.success(),
                "{label}: {command:?}: {}",
                String::from_utf8_lossy(&output.stderr)
            );
        }
        fn compare(&self, name: &str, program: &ir::Program, expected: Option<&str>) {
            let directory = self.directory.join(name);
            fs::create_dir_all(&directory).unwrap();
            let direct = ir_executor::run(program);
            let bytecode = bytecode::lower(program).unwrap();
            let vm = run_bytecode(&bytecode);
            let (stdout, stderr, status) = match (direct, vm) {
                (Ok(direct), Ok(vm)) => {
                    assert_eq!(direct, vm, "{name}");
                    if let Some(expected) = expected {
                        assert_eq!(direct, expected, "{name}");
                    }
                    (direct, String::new(), 0)
                }
                (Err(direct), Err(vm)) => {
                    assert_eq!(direct.runtime_failure(), vm.runtime_failure(), "{name}");
                    assert_eq!(direct.output(), vm.vm_error().output(), "{name}");
                    assert!(expected.is_none(), "{name}: expected successful output");
                    let failure = direct.runtime_failure().unwrap();
                    (
                        direct.output().to_owned(),
                        format!("cerune: {}\n", failure.record()),
                        3,
                    )
                }
                pair => panic!("{name}: IR/VM disagree: {pair:?}"),
            };
            let before = ir::text::emit(program);
            fs::write(directory.join("program.ceir"), &before).unwrap();
            fs::write(
                directory.join("program.cebc"),
                bytecode::format_program(&bytecode),
            )
            .unwrap();
            let input = directory.join("program.ssa");
            let assembly = directory.join("program.s");
            let exe = directory.join("program.exe");
            let artifact =
                qbe::emit_qbe_with_target(program, Some(Target::X86_64PcWindowsMsvc)).unwrap();
            assert_eq!(
                artifact,
                qbe::emit_qbe_with_target(program, Some(Target::X86_64PcWindowsMsvc)).unwrap()
            );
            assert_eq!(ir::text::emit(program), before);
            fs::write(&input, artifact).unwrap();
            fs::write(directory.join("expected.stdout"), stdout.as_bytes()).unwrap();
            fs::write(directory.join("expected.stderr"), stderr.as_bytes()).unwrap();
            self.success(
                Command::new(&self.qbe)
                    .args(["-t", "amd64_win"])
                    .arg("-o")
                    .arg(&assembly)
                    .arg(&input),
                &directory,
                &format!("{name}/qbe"),
            );
            self.success(
                Command::new(&self.clang)
                    .arg("--target=x86_64-pc-windows-msvc")
                    .arg(&assembly)
                    .arg("-o")
                    .arg(&exe),
                &directory,
                &format!("{name}/link"),
            );
            let actual = self.command(&mut Command::new(&exe), &directory, &format!("{name}/run"));
            assert_eq!(
                actual.status.code(),
                Some(status),
                "{name}: {}",
                String::from_utf8_lossy(&actual.stderr)
            );
            // 改行・NaN・数値表示を正規化せず、観測された全バイトを比較します。
            assert_eq!(actual.stdout, stdout.as_bytes(), "{name}: stdout");
            assert_eq!(actual.stderr, stderr.as_bytes(), "{name}: stderr");
        }
    }

    #[test]
    #[ignore = "requires Windows, QBE 1.3 and Clang/MSVC; mandatory in the windows-qbe CI job"]
    fn examples_values_failures_and_heap_budgets_match_ir_and_vm() {
        let h = Harness::new();
        let mut paths: Vec<_> = fs::read_dir("examples")
            .unwrap()
            .map(|e| e.unwrap().path())
            .filter(|p| p.extension().is_some_and(|e| e == "ceru"))
            .collect();
        paths.sort();
        for path in paths {
            let name = path.file_stem().unwrap().to_str().unwrap();
            let source = fs::read_to_string(&path).unwrap();
            h.compare(
                &format!("example-{name}"),
                &compile_to_ir(&source).unwrap(),
                None,
            );
        }
        // Windowsの第5引数以降でも、符号付きゼロ・非有限値・集約戻り値を保ちます。
        let floats = r#"
            fn single(a:i64,b:i64,c:i64,d:i64,v:f32)->f32 { return v; }
            fn double(a:i64,b:i64,c:i64,d:i64,v:f64)->f64 { return v; }
            type Pair { s:f32, d:f64 }
            fn pair(a:i64,b:i64,c:i64,s:f32,d:f64)->Pair { return Pair { s:s,d:d }; }
            print(single(1,2,3,4,-0.0f32));
            print(double(1,2,3,4,-0.0f64));
            p:Pair=pair(1,2,3,-0.0f32,-0.0f64); print(p.s); print(p.d);
            print(single(1,2,3,4,1.0f32/0.0f32)>0.0f32);
            print(double(1,2,3,4,-1.0f64/0.0f64)<0.0f64);
            n:f32=single(1,2,3,4,0.0f32/0.0f32); print(n!=n);
            m:f64=double(1,2,3,4,0.0f64/0.0f64); print(m!=m);
        "#;
        h.compare(
            "stack-floating-bits",
            &compile_to_ir(floats).unwrap(),
            Some("-0\n-0\n-0\n-0\ntrue\ntrue\ntrue\ntrue\n"),
        );
        for (index, &(source, expected)) in string_cases::CASES
            .iter()
            .chain(string_cases::PRODUCT_UPDATES)
            .chain(concat_cases::CASES)
            .chain(&[
                string_cases::BYTE_LENGTH,
                u64_cases::EXAMPLE,
                u64_cases::BOUNDARIES,
            ])
            .enumerate()
        {
            h.compare(
                &format!("value-{index}"),
                &compile_to_ir(source).unwrap(),
                Some(expected),
            );
        }
        for (index, &(body, code)) in runtime_cases::FAILURES.iter().enumerate() {
            let source = format!(
                "// 日本語\r\nprint(\"開始\\0\\r\\n\");\r\nprint(false && (1 / 0 == 0));\r\n{body}"
            );
            let program = compile_to_ir(&source).unwrap();
            assert_eq!(
                ir_executor::run(&program)
                    .unwrap_err()
                    .runtime_failure()
                    .unwrap()
                    .code
                    .name(),
                code
            );
            h.compare(&format!("failure-{index}-{code}"), &program, None);
        }
        for (index, (source, limit, expected)) in [
            (concat_cases::BORROWED_READS.0, 30, Some(concat_cases::BORROWED_READS.1)),
            (concat_cases::BORROWED_READS.0, 29, None),
            (concat_cases::PROJECTED_TEMPORARIES, 6, Some("true\n")),
            (concat_cases::PROJECTED_TEMPORARIES, 5, None),
            (concat_cases::OWNED_ARGUMENTS.0, 22, Some(concat_cases::OWNED_ARGUMENTS.1)),
            (concat_cases::OWNED_ARGUMENTS.0, 15, None),
            (concat_cases::OWNED_ARGUMENTS.0, 19, None),
            (string_cases::aggregate_cases::CASES[7].0, 24, Some(string_cases::aggregate_cases::CASES[7].1)),
            (string_cases::aggregate_cases::CASES[7].0, 23, None),
            (r#"fn value()->string{v:string=concat("a","b");return v;} for(mut i:i64=0;i<1000;i=i+1){s:string=value();if i<999{continue;}print(s);} print(concat("",""));"#, 2, Some("ab\n\n")),
            (r#"print("before"); mut s:string=concat("a","b"); saved:string=s; s=concat(s,"c"); print("bad");"#, 4, None),
            (r#"fn right()->string{print("bad");return "";} print("before");print(concat(concat("a","b"),right()));"#, 1, None),
        ].into_iter().enumerate() {
            let mut program = compile_to_ir(source).unwrap();
            program.string_heap_limit = limit;
            assert_eq!(ir_executor::run(&program).is_ok(), expected.is_some());
            h.compare(&format!("heap-{index}"), &program, expected);
        }
        for entry in [
            "main",
            "aggregate_match",
            "generic_arrays",
            "failure",
            "product_update_failure",
        ] {
            let compilation =
                modules::load(&PathBuf::from(format!("examples/modules/{entry}.ceru"))).unwrap();
            h.compare(
                &format!("module-{entry}"),
                &compilation.to_ir().unwrap(),
                None,
            );
        }
        // CLIにも同じ明示指定を渡し、誤ったターゲットで既存出力を壊さないことを確認します。
        let output = h.directory.join("cli.ssa");
        h.success(
            Command::new(env!("CARGO_BIN_EXE_cerune"))
                .args([
                    "emit-qbe",
                    "examples/string_origins.ceru",
                    "--target",
                    "x86_64-pc-windows-msvc",
                    "-o",
                ])
                .arg(&output),
            &h.directory,
            "cli/windows",
        );
        let before = fs::read(&output).unwrap();
        assert!(String::from_utf8_lossy(&before).contains("amd64_win"));
        for args in [
            vec![],
            vec!["--target", "invalid"],
            vec![
                "--target",
                "x86_64-pc-windows-msvc",
                "--target",
                "x86_64-unknown-linux-gnu",
            ],
        ] {
            let result = h.command(
                Command::new(env!("CARGO_BIN_EXE_cerune"))
                    .args(["emit-qbe", "examples/string_origins.ceru"])
                    .args(args)
                    .arg("-o")
                    .arg(&output),
                &h.directory,
                "cli/reject",
            );
            assert!(!result.status.success());
            assert_eq!(fs::read(&output).unwrap(), before);
        }
    }
}
