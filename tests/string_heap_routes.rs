//! 明示した小さい予算を、VMと全生成先へ同じ値で渡して検査します。
#[path = "support/aggregate_cases.rs"]
mod aggregate_cases;
#[allow(dead_code)]
#[path = "support/concat_cases.rs"]
mod concat_cases;
#[path = "support/crash_dialogs.rs"]
mod crash_dialogs;
#[path = "support/process.rs"]
mod process;
use std::{
    fs,
    path::PathBuf,
    process::{Command, Output},
    time::Duration,
};

struct Workspace(PathBuf);
impl Drop for Workspace {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}
fn output(w: &Workspace, command: &mut Command, label: &str) -> Output {
    process::bounded_output(command, &w.0, label, Duration::from_secs(30)).unwrap()
}
fn success(w: &Workspace, command: &mut Command, label: &str) -> Output {
    let result = output(w, command, label);
    assert!(
        result.status.success(),
        "{label}: {}",
        String::from_utf8_lossy(&result.stderr)
    );
    result
}
fn tool(variable: &str, fallback: &str, flag: &str) -> Option<std::ffi::OsString> {
    let configured = std::env::var_os(variable);
    let name = configured.clone().unwrap_or_else(|| fallback.into());
    if Command::new(&name)
        .arg(flag)
        .output()
        .is_ok_and(|r| r.status.success())
    {
        Some(name)
    } else {
        assert!(configured.is_none(), "{variable} unavailable");
        eprintln!("string heap route skipped: {name:?}; set {variable} to require it");
        None
    }
}
#[test]
fn budgets_cleanup_and_failure_origins_match_all_available_routes() {
    crash_dialogs::suppress();
    let stamp = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let w =
        Workspace(std::env::temp_dir().join(format!("cerune-heap-{}-{stamp}", std::process::id())));
    fs::create_dir(&w.0).unwrap();
    let cc = tool(
        "CERUNE_TEST_CC",
        if cfg!(windows) { "clang" } else { "cc" },
        "--version",
    );
    let llvm = tool("CERUNE_TEST_LLVM_CLANG", "clang", "--version");
    let qbe = if cfg!(unix) {
        tool("CERUNE_TEST_QBE", "qbe", "-h")
    } else {
        None
    };
    let node = tool("CERUNE_TEST_NODE", "node", "--version");
    let wabt = std::env::var_os("CERUNE_TEST_WAT2WASM_JS")
        .map(PathBuf::from)
        .unwrap_or_else(|| {
            PathBuf::from(env!("CARGO_MANIFEST_DIR"))
                .join("target/wasm-tools/node_modules/wabt/bin/wat2wasm")
        });
    let target = if cfg!(windows) {
        "x86_64-pc-windows-msvc"
    } else {
        "x86_64-unknown-linux-gnu"
    };
    let cerune = env!("CARGO_BIN_EXE_cerune");
    for (case, (source, limit, expected)) in [
        (concat_cases::BORROWED_READS.0, 30, Some(concat_cases::BORROWED_READS.1)),
        (concat_cases::BORROWED_READS.0, 29, None),
        (concat_cases::PROJECTED_TEMPORARIES, 6, Some("true\n")),
        (concat_cases::PROJECTED_TEMPORARIES, 5, None),
        (concat_cases::OWNED_ARGUMENTS.0, 22, Some(concat_cases::OWNED_ARGUMENTS.1)),
        (concat_cases::OWNED_ARGUMENTS.0, 15, None),
        (concat_cases::OWNED_ARGUMENTS.0, 19, None),
        (aggregate_cases::CASES[7].0, 24, Some(aggregate_cases::CASES[7].1)),
        (aggregate_cases::CASES[7].0, 23, None),
        (r#"fn value()->string{v:string=concat("a","b");return v;} for(mut i:i64=0;i<1000;i=i+1){s:string=value();if i<999{continue;}print(s);} print(concat("",""));"#, 2, Some("ab\n\n")),
        (r#"print("before"); mut s:string=concat("a","b"); saved:string=s; s=concat(s,"c"); print("bad");"#, 4, None),
        (r#"fn right()->string{print("bad");return "";} print("before");print(concat(concat("a","b"),right()));"#, 1, None),
        (r#"fn later()->i64{print("bad");return 0;} mut a:[[string;1];1]=[[concat("a","b")]];print("before");a[1][later()]=concat("x","y");"#, 2, None),
    ].into_iter().enumerate() {
        let source_path = w.0.join("source.ceru");
        fs::write(&source_path, source).unwrap();
        let budget = limit.to_string();
        let vm = output(&w, Command::new(cerune).arg("run-vm").arg(&source_path).args(["--string-heap-limit", &budget, "--diagnostic-format", "runtime-v1"]), "vm");
        if let Some(expected) = expected { assert!(vm.status.success()); assert_eq!(vm.stdout, expected.as_bytes()); }
        else { assert!(!vm.status.success()); assert!(vm.stderr.starts_with(b"cerune: runtime-v1 code=")); }
        let direct = output(&w, Command::new(cerune).arg("run-ir").arg(&source_path).args(["--string-heap-limit", &budget, "--diagnostic-format", "runtime-v1"]), "ir-executor");
        assert_eq!(direct.status.success(), vm.status.success(), "IR case {case}");
        assert_eq!(direct.stdout, vm.stdout, "IR case {case}");
        assert_eq!(direct.stderr, vm.stderr, "IR case {case}");
        for route in ["c", "llvm", "qbe", "asm", "obj", "wat"] {
            let compiler = if route == "llvm" { llvm.as_ref() } else { cc.as_ref() };
            if route == "wat" { if node.is_none() || !wabt.is_file() { continue; } }
            else if compiler.is_none() || (route == "qbe" && qbe.is_none()) { continue; }
            let input = w.0.join(match route { "c"=>"program.c", "llvm"=>"program.ll", "qbe"=>"program.ssa", "asm"=>"program.s", "obj"=>"program.o", _=>"program.wat" });
            let exe = w.0.join(if cfg!(windows) { "program.exe" } else { "program" });
            let mut emit = Command::new(cerune);
            emit.arg(format!("emit-{route}")).arg(&source_path).args(["--string-heap-limit", &budget]).arg("-o").arg(&input);
            if matches!(route, "llvm"|"qbe"|"asm"|"obj") { emit.args(["--target", target]); }
            success(&w, &mut emit, "emit");
            let repeats = if route == "wat" && expected.is_some() { 20 } else { 1 };
            let actual = if route == "wat" {
                if expected.is_some() {
                    // 1ページを上限に固定。空き領域を再利用しなければ1000反復で失敗します。
                    let text = fs::read_to_string(&input).unwrap();
                    assert!(text.contains("(memory 1)"));
                    fs::write(&input, text.replace("(memory 1)", "(memory 1 1)")).unwrap();
                }
                let wasm = w.0.join("program.wasm");
                success(&w, Command::new(node.as_ref().unwrap()).arg(&wabt).arg(&input).arg("-o").arg(&wasm), "wat-build");
                output(&w, Command::new(node.as_ref().unwrap()).arg(PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/support/run_wasm.cjs")).arg(&wasm).arg(repeats.to_string()), "wat-run")
            } else {
                let link_input = if route == "qbe" {
                    let assembly = w.0.join("qbe.s");
                    success(&w, Command::new(qbe.as_ref().unwrap()).arg("-o").arg(&assembly).arg(&input), "qbe-build");
                    assembly
                } else { input };
                let mut link = Command::new(compiler.unwrap());
                link.arg("-O2");
                if route == "llvm" { link.arg(format!("--target={target}")); }
                link.arg(&link_input).arg("-o").arg(&exe);
                if cfg!(unix) { link.arg("-lm"); }
                success(&w, &mut link, "link");
                output(&w, &mut Command::new(&exe), "native-run")
            };
            assert_eq!(actual.status.success(), vm.status.success(), "case {case}/{route}: {}", String::from_utf8_lossy(&actual.stderr));
            if !vm.status.success() && route != "wat" {
                #[cfg(unix)] {
                    use std::os::unix::process::ExitStatusExt;
                    assert_eq!(actual.status.signal(), Some(if matches!(route,"c"|"qbe"){6}else{4}), "{case}/{route}");
                }
                #[cfg(windows)] {
                    let status = actual.status.code().map(|n| n as u32);
                    if route == "c" { assert!(matches!(status,Some(3|0xc0000409))); }
                    else { assert_eq!(status,Some(0xc000001d)); }
                }
            }
            assert_eq!(actual.stdout, vm.stdout.repeat(repeats), "case {case}/{route}");
            assert_eq!(String::from_utf8(actual.stderr).unwrap().replace("\r\n","\n"), String::from_utf8(vm.stderr.clone()).unwrap().replace("\r\n","\n"), "case {case}/{route}");
        }
    }
}

#[test]
fn allocator_failures_remain_distinct_from_budget_failures() {
    crash_dialogs::suppress();
    let stamp = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let w = Workspace(
        std::env::temp_dir().join(format!("cerune-allocator-{}-{stamp}", std::process::id())),
    );
    fs::create_dir(&w.0).unwrap();
    let source = w.0.join("source.ceru");
    fs::write(&source, r#"print("before"); mut s:string="a"; for(mut i:i64=0;i<16;i=i+1){s=concat(s,s);} print("bad");"#).unwrap();
    let stub = w.0.join("allocator.c");
    fs::write(
        &stub,
        "void *oom_fn(unsigned long long size) { (void)size; return 0; }\n",
    )
    .unwrap();
    let cerune = env!("CARGO_BIN_EXE_cerune");
    let vm = output(
        &w,
        Command::new(cerune).arg("run-vm").arg(&source).args([
            "--string-heap-limit",
            "1",
            "--diagnostic-format",
            "runtime-v1",
        ]),
        "vm-failure",
    );
    assert!(!vm.status.success());
    let expected = String::from_utf8(vm.stderr)
        .unwrap()
        .replace("\r\n", "\n")
        .replace("allocation-limit-exceeded", "allocation-failed");
    let target = if cfg!(windows) {
        "x86_64-pc-windows-msvc"
    } else {
        "x86_64-unknown-linux-gnu"
    };
    let cc = tool(
        "CERUNE_TEST_CC",
        if cfg!(windows) { "clang" } else { "cc" },
        "--version",
    );
    let llvm = tool("CERUNE_TEST_LLVM_CLANG", "clang", "--version");
    let qbe = if cfg!(unix) {
        tool("CERUNE_TEST_QBE", "qbe", "-h")
    } else {
        None
    };
    let node = tool("CERUNE_TEST_NODE", "node", "--version");
    let wabt = std::env::var_os("CERUNE_TEST_WAT2WASM_JS")
        .map(PathBuf::from)
        .unwrap_or_else(|| {
            PathBuf::from(env!("CARGO_MANIFEST_DIR"))
                .join("target/wasm-tools/node_modules/wabt/bin/wat2wasm")
        });
    for route in ["c", "llvm", "qbe", "asm", "obj", "wat"] {
        if route == "wat" {
            if node.is_none() || !wabt.is_file() {
                continue;
            }
        } else if cc.is_none()
            || (route == "llvm" && llvm.is_none())
            || (route == "qbe" && qbe.is_none())
        {
            continue;
        }
        let input = w.0.join(match route {
            "c" => "program.c",
            "llvm" => "program.ll",
            "qbe" => "program.ssa",
            "asm" => "program.s",
            "obj" => "program.o",
            _ => "program.wat",
        });
        let mut emit = Command::new(cerune);
        emit.arg(format!("emit-{route}"))
            .arg(&source)
            .arg("-o")
            .arg(&input);
        if matches!(route, "llvm" | "qbe" | "asm" | "obj") {
            emit.args(["--target", target]);
        }
        success(&w, &mut emit, "emit-failure");
        let actual = if route == "wat" {
            let text = fs::read_to_string(&input).unwrap();
            assert!(text.contains("(memory 1)"));
            fs::write(&input, text.replace("(memory 1)", "(memory 1 1)")).unwrap();
            let wasm = w.0.join("program.wasm");
            success(
                &w,
                Command::new(node.as_ref().unwrap())
                    .arg(&wabt)
                    .arg(&input)
                    .arg("-o")
                    .arg(&wasm),
                "wat-build-failure",
            );
            output(
                &w,
                Command::new(node.as_ref().unwrap())
                    .arg(
                        PathBuf::from(env!("CARGO_MANIFEST_DIR"))
                            .join("tests/support/run_wasm.cjs"),
                    )
                    .arg(&wasm),
                "wat-failure",
            )
        } else {
            // テスト成果物の未定義アロケータだけを、必ず失敗する固定stubへ接続します。
            // 言語・CLI・観測APIへ注入用の設定は追加しません。
            if route == "obj" {
                let mut bytes = fs::read(&input).unwrap();
                replace_allocator_symbol(&mut bytes);
                fs::write(&input, bytes).unwrap();
            } else {
                let text = fs::read_to_string(&input).unwrap();
                let text = match route {
                    "c" => format!(
                        "void *oom_fn(unsigned long long);\n{}",
                        text.replace("malloc(", "oom_fn(")
                    ),
                    "llvm" => text.replace("@malloc(", "@oom_fn("),
                    "qbe" => text.replace("$malloc(", "$oom_fn("),
                    _ => text.replace("callq malloc", "callq oom_fn"),
                };
                fs::write(&input, text).unwrap();
            }
            let mut linked = input.clone();
            if route == "qbe" {
                linked = w.0.join("qbe.s");
                success(
                    &w,
                    Command::new(qbe.as_ref().unwrap())
                        .arg("-o")
                        .arg(&linked)
                        .arg(&input),
                    "qbe-failure-build",
                );
            }
            let exe = w.0.join(if cfg!(windows) {
                "program.exe"
            } else {
                "program"
            });
            let compiler = if route == "llvm" {
                llvm.as_ref().unwrap()
            } else {
                cc.as_ref().unwrap()
            };
            let mut link = Command::new(compiler);
            if route == "llvm" {
                link.arg(format!("--target={target}"));
            }
            link.arg("-O2").arg(&linked).arg(&stub).arg("-o").arg(&exe);
            if cfg!(unix) {
                link.arg("-lm");
            }
            success(&w, &mut link, "link-allocation-failure");
            output(&w, &mut Command::new(&exe), "allocation-failure")
        };
        assert!(!actual.status.success(), "{route}");
        assert_eq!(actual.stdout, b"before\n", "{route}");
        assert_eq!(
            String::from_utf8(actual.stderr)
                .unwrap()
                .replace("\r\n", "\n"),
            expected,
            "{route}"
        );
        #[cfg(unix)]
        if route != "wat" {
            use std::os::unix::process::ExitStatusExt;
            assert_eq!(
                actual.status.signal(),
                Some(if matches!(route, "c" | "qbe") { 6 } else { 4 }),
                "{route}"
            );
        }
        #[cfg(windows)]
        if route != "wat" {
            let status = actual.status.code().map(|n| n as u32);
            if route == "c" {
                assert!(matches!(status, Some(3 | 0xc0000409)));
            } else {
                assert_eq!(status, Some(0xc000001d));
            }
        }
    }
}
fn replace_allocator_symbol(bytes: &mut [u8]) {
    fn number(bytes: &[u8], at: usize, width: usize) -> usize {
        let mut result = 0usize;
        for (i, b) in bytes[at..at + width].iter().enumerate() {
            result |= (*b as usize) << (8 * i);
        }
        result
    }
    let mut matches = 0;
    if bytes.starts_with(b"\x7fELF") {
        let headers = number(bytes, 40, 8);
        let stride = number(bytes, 58, 2);
        let count = number(bytes, 60, 2);
        for i in 0..count {
            let h = headers + i * stride;
            if number(bytes, h + 4, 4) != 2 {
                continue;
            }
            let table = number(bytes, h + 24, 8);
            let size = number(bytes, h + 32, 8);
            let names_header = headers + number(bytes, h + 40, 4) * stride;
            let names = number(bytes, names_header + 24, 8);
            for sym in (table..table + size).step_by(24) {
                if number(bytes, sym + 6, 2) != 0 {
                    continue;
                }
                let name = names + number(bytes, sym, 4);
                if bytes[name..].starts_with(b"malloc\0") {
                    bytes[name..name + 6].copy_from_slice(b"oom_fn");
                    matches += 1;
                }
            }
        }
    } else {
        assert_eq!(&bytes[..2], &[0x64, 0x86]);
        let table = number(bytes, 8, 4);
        let count = number(bytes, 12, 4);
        for i in 0..count {
            let sym = table + i * 18;
            if number(bytes, sym + 12, 2) == 0 && &bytes[sym..sym + 8] == b"malloc\0\0" {
                bytes[sym..sym + 6].copy_from_slice(b"oom_fn");
                matches += 1;
            }
        }
    }
    assert_eq!(matches, 1, "exactly one undefined allocator symbol");
}
