//! 共通の配列ケースをWAT→Wasm→Nodeでも実行し、出力と停止出自を照合します。
use super::process;
use cerune_lang::{codegen, ir, ir_executor};
use std::{
    ffi::OsString,
    fs,
    path::PathBuf,
    process::{Command, Output},
    sync::{
        OnceLock,
        atomic::{AtomicUsize, Ordering},
    },
    time::Duration,
};
struct Workspace(PathBuf);
impl Drop for Workspace {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}
fn tools() -> Option<&'static (OsString, PathBuf)> {
    static TOOLS: OnceLock<Option<(OsString, PathBuf)>> = OnceLock::new();
    TOOLS.get_or_init(|| {
        let configured_node = std::env::var_os("CERUNE_TEST_NODE");
        let configured_wabt = std::env::var_os("CERUNE_TEST_WAT2WASM_JS");
        let node = configured_node.clone().unwrap_or_else(|| "node".into());
        let wabt = configured_wabt.clone().map(PathBuf::from).unwrap_or_else(||
            PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("target/wasm-tools/node_modules/wabt/bin/wat2wasm"));
        let available = Command::new(&node).arg("--version").output().is_ok_and(|r| r.status.success());
        assert!(available || configured_node.is_none(), "CERUNE_TEST_NODE unavailable: {node:?}");
        assert!(wabt.is_file() || configured_wabt.is_none(), "CERUNE_TEST_WAT2WASM_JS unavailable: {wabt:?}");
        if available && wabt.is_file() { Some((node, wabt)) } else {
            eprintln!("dynamic array WAT execution skipped; set CERUNE_TEST_NODE and CERUNE_TEST_WAT2WASM_JS to require it");
            None
        }
    }).as_ref()
}
pub fn execute(text: &str) -> Option<Output> {
    let (node, wabt) = tools()?;
    static NEXT: AtomicUsize = AtomicUsize::new(0);
    let stamp = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let w = Workspace(std::env::temp_dir().join(format!(
        "cerune-array-wat-{}-{stamp}-{}",
        std::process::id(),
        NEXT.fetch_add(1, Ordering::Relaxed)
    )));
    fs::create_dir(&w.0).unwrap();
    let input = w.0.join("program.wat");
    let wasm = w.0.join("program.wasm");
    fs::write(&input, text).unwrap();
    let built = process::bounded_output(
        Command::new(node)
            .arg(wabt)
            .arg(&input)
            .arg("-o")
            .arg(&wasm),
        &w.0,
        "wat-array-build",
        Duration::from_secs(30),
    )
    .unwrap();
    assert!(
        built.status.success(),
        "{}",
        String::from_utf8_lossy(&built.stderr)
    );
    Some(
        process::bounded_output(
            Command::new(node)
                .arg(PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/support/run_wasm.cjs"))
                .arg(&wasm),
            &w.0,
            "wat-array-run",
            Duration::from_secs(30),
        )
        .unwrap(),
    )
}
pub fn compare(program: &ir::Program, direct: &Result<String, ir_executor::ExecutionError>) {
    let mut text = codegen::emit_wat(program).unwrap();
    if direct.is_ok() && text.contains("(global $cerune_array_live") {
        let check = r#"
  (func $main
    call $sample_main
    (if (i64.ne (global.get $cerune_array_live) (i64.const 0)) (then unreachable)))
"#;
        text = text
            .replace("(func $main\n", "(func $sample_main\n")
            .replace(
                "  (export \"main\"",
                &format!("{check}\n  (export \"main\""),
            );
    }
    let Some(actual) = execute(&text) else { return };
    match direct {
        Ok(expected) => {
            assert!(actual.status.success(), "{actual:?}");
            assert!(actual.stderr.is_empty(), "{actual:?}");
            assert_eq!(&actual.stdout, expected.as_bytes(), "WAT");
        }
        Err(error) => {
            assert_eq!(actual.stdout, error.output().as_bytes(), "WAT");
            checked_failure(&actual, &error.runtime_failure().unwrap().record());
        }
    }
}
fn checked_failure(actual: &Output, record: &str) {
    assert!(!actual.status.success(), "{actual:?}");
    assert_eq!(actual.status.code(), Some(1));
    assert_eq!(
        String::from_utf8_lossy(&actual.stderr).replace("\r\n", "\n"),
        format!("cerune: {record}\n")
    );
}

pub fn runtime_boundaries(program: &ir::Program) {
    let text = codegen::emit_wat(program).unwrap();
    let mut limited = program.clone();
    limited.array_heap_limit = 0;
    let expected = ir_executor::run(&limited).unwrap_err();
    let record = expected.runtime_failure().unwrap().record();
    let call =
        "    local.get $length\n    i64.const 8\n    i64.const 8\n    call $cerune_array_allocate";
    assert_eq!(text.matches(call).count(), 1);
    for (length, width, stride) in [
        ("9223372036854775807", "8", "8"),
        ("9223372036854775807", "0", "8"),
        ("-1", "8", "8"),
    ] {
        let modified = text.replace(call, &format!("    i64.const {length}\n    i64.const {width}\n    i64.const {stride}\n    call $cerune_array_allocate"));
        let Some(actual) = execute(&modified) else {
            return;
        };
        assert_eq!(actual.stdout, b"7\n");
        checked_failure(
            &actual,
            &record.replace("allocation-limit-exceeded", "allocation-size-overflow"),
        );
    }
    // ホストへmemoryを公開せず、テスト成果物だけに上限を付けてmemory.growを失敗させます。
    assert!(text.contains("(memory 1)"));
    let modified = text.replace("(memory 1)", "(memory 1 1)").replace(
        call,
        "    i64.const 10000\n    i64.const 8\n    i64.const 8\n    call $cerune_array_allocate",
    );
    let Some(actual) = execute(&modified) else {
        return;
    };
    assert_eq!(actual.stdout, b"7\n");
    checked_failure(
        &actual,
        &record.replace("allocation-limit-exceeded", "allocation-failed"),
    );

    // 幅0・空配列・物理的な成長も、共通IRでは作れないprimitive条件として別に検証します。
    let checks = r#"
  (func $main (local $p i32) (local $empty i32) (local $error i32) (local $end i64) (local $pages i32)
    (local.set $end (global.get $cerune_heap_end))
    (call $cerune_array_allocate (i64.const 0) (i64.const 8) (i64.const 8))
    local.set $error local.set $empty
    (if (i32.or (local.get $error) (local.get $empty)) (then unreachable))
    (if (i64.ne (global.get $cerune_heap_end) (local.get $end)) (then unreachable))
    (call $cerune_array_allocate (i64.const 3) (i64.const 0) (i64.const 0))
    local.set $error local.set $p
    (if (local.get $error) (then unreachable))
    (if (i64.ne (call $cerune_array_length (local.get $p)) (i64.const 3)) (then unreachable))
    (call $cerune_array_initialized (local.get $p))
    (call $cerune_array_initialized (local.get $p))
    (call $cerune_array_initialized (local.get $p))
    (call $cerune_array_retain (local.get $p))
    (if (call $cerune_array_release_owner (local.get $p)) (then unreachable))
    (if (i32.eqz (call $cerune_array_release_owner (local.get $p))) (then unreachable))
    (call $cerune_array_free (local.get $p))
    (if (i64.ne (global.get $cerune_array_live) (i64.const 0)) (then unreachable))
    (local.set $pages (memory.size))
    (call $cerune_array_allocate (i64.const 10000) (i64.const 8) (i64.const 8))
    local.set $error local.set $p
    (if (local.get $error) (then unreachable))
    (if (i32.le_u (memory.size) (local.get $pages)) (then unreachable))
    (i64.store (call $cerune_array_element_address (local.get $p) (i64.const 9999)) (i64.const 42))
    (if (i64.ne (i64.load (call $cerune_array_element_address (local.get $p) (i64.const 9999))) (i64.const 42)) (then unreachable))
    (i64.store offset=16 (local.get $p) (i64.const 10000))
    (drop (call $cerune_array_release_owner (local.get $p)))
    (call $cerune_array_free (local.get $p))
    (if (i64.ne (global.get $cerune_array_live) (i64.const 0)) (then unreachable))
  )
"#;
    let modified = text
        .replace("(func $main\n", "(func $sample_main\n")
        .replace(
            "  (export \"main\"",
            &format!("{checks}\n  (export \"main\""),
        );
    let Some(actual) = execute(&modified) else {
        return;
    };
    assert!(
        actual.status.success() && actual.stdout.is_empty() && actual.stderr.is_empty(),
        "{actual:?}"
    );
}

pub fn reuse_and_growth() {
    let program = cerune_lang::compile_to_ir(
        r#"
        mut n:i64=0;
        while n<1000 {
            a:[string]=array_copy([concat("日","本"),concat("a","b")]);
            mut b:[string]=a; b[0]=concat(b[1],"!");
            if a[0]!="日本" || a[1]!="ab" || b[0]!="ab!" { print(99); }
            n=n+1;
        }
    "#,
    )
    .unwrap();
    let text = codegen::emit_wat(&program).unwrap();
    assert!(text.contains("(memory 1)"));
    // 同じinstanceの繰り返し成功後も、配列/文字列の生存予算は0、物理memoryは1ページです。
    let checks = r#"
  (func $main (local $count i32)
    (loop $repeat
      call $sample_main
      (if (i64.ne (global.get $cerune_array_live) (i64.const 0)) (then unreachable))
      (if (i64.ne (global.get $cerune_heap_live) (i64.const 0)) (then unreachable))
      (if (i32.ne (memory.size) (i32.const 1)) (then unreachable))
      (local.set $count (i32.add (local.get $count) (i32.const 1)))
      (br_if $repeat (i32.lt_u (local.get $count) (i32.const 20)))))
"#;
    let modified = text
        .replace("(memory 1)", "(memory 1 1)")
        .replace("(func $main\n", "(func $sample_main\n")
        .replace(
            "  (export \"main\"",
            &format!("{checks}\n  (export \"main\""),
        );
    let Some(actual) = execute(&modified) else {
        return;
    };
    assert!(
        actual.status.success() && actual.stdout.is_empty() && actual.stderr.is_empty(),
        "{actual:?}"
    );
}
