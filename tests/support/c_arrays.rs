//! 既存の動的配列ケースを生成Cでも実行します。所有の規則は再実装しません。
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
#[path = "crash_dialogs.rs"]
mod crash_dialogs;
use super::process;

struct Workspace(PathBuf);
impl Drop for Workspace {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}
fn compiler() -> Option<&'static OsString> {
    static CC: OnceLock<Option<OsString>> = OnceLock::new();
    CC.get_or_init(|| {
        crash_dialogs::suppress();
        let configured = std::env::var_os("CERUNE_TEST_CC");
        let cc = configured
            .clone()
            .unwrap_or_else(|| if cfg!(windows) { "clang" } else { "cc" }.into());
        if Command::new(&cc)
            .arg("--version")
            .output()
            .is_ok_and(|r| r.status.success())
        {
            Some(cc)
        } else {
            assert!(configured.is_none(), "CERUNE_TEST_CC unavailable: {cc:?}");
            eprintln!(
                "dynamic array C execution skipped: {cc:?}; set CERUNE_TEST_CC to require it"
            );
            None
        }
    })
    .as_ref()
}
fn execute(text: &str, optimization: &str) -> Option<Output> {
    let cc = compiler()?;
    static NEXT: AtomicUsize = AtomicUsize::new(0);
    let stamp = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let w = Workspace(std::env::temp_dir().join(format!(
        "cerune-array-c-{}-{stamp}-{}",
        std::process::id(),
        NEXT.fetch_add(1, Ordering::Relaxed)
    )));
    fs::create_dir(&w.0).unwrap();
    let input = w.0.join("program.c");
    let exe = w.0.join(if cfg!(windows) {
        "program.exe"
    } else {
        "program"
    });
    fs::write(&input, text).unwrap();
    let mut command = Command::new(cc);
    command.args(["-std=c11", "-pedantic-errors", optimization]);
    if std::env::var_os("CERUNE_TEST_SANITIZE").is_some() {
        command.args([
            "-fsanitize=address,undefined",
            "-fno-sanitize-recover=all",
            "-fno-omit-frame-pointer",
        ]);
    }
    command.arg(&input).arg("-o").arg(&exe);
    if !cfg!(windows) {
        command.arg("-lm");
    }
    let built = process::bounded_output(
        &mut command,
        &w.0,
        "c-array-compile",
        Duration::from_secs(30),
    )
    .unwrap();
    assert!(
        built.status.success(),
        "{}\n{text}",
        String::from_utf8_lossy(&built.stderr)
    );
    Some(
        process::bounded_output(
            Command::new(exe).current_dir(&w.0),
            &w.0,
            "c-array-run",
            Duration::from_secs(30),
        )
        .unwrap(),
    )
}
fn checked_failure(actual: &Output, record: &str) {
    #[cfg(unix)]
    {
        use std::os::unix::process::ExitStatusExt;
        assert_eq!(actual.status.signal(), Some(6), "{actual:?}");
    }
    #[cfg(windows)]
    assert!(
        matches!(actual.status.code().map(|c| c as u32), Some(3 | 0xc0000409)),
        "{actual:?}"
    );
    assert_eq!(
        String::from_utf8_lossy(&actual.stderr).replace("\r\n", "\n"),
        format!("cerune: {record}\n")
    );
}
pub fn compare(program: &ir::Program, direct: &Result<String, ir_executor::ExecutionError>) {
    let mut text = codegen::emit_c(program).unwrap();
    // 正常終了時の予算残存を検出します。ゼロ幅領域の漏れはASan/LSanでも検査します。
    if text.contains("static uint64_t cerune_array_live_bytes;") {
        text = text.replace(
            "    return 0;\n}",
            "    assert(cerune_array_live_bytes == 0);\n    return 0;\n}",
        );
    }
    for optimization in ["-O0", "-O2"] {
        let Some(actual) = execute(&text, optimization) else {
            return;
        };
        match direct {
            Ok(expected) => {
                assert!(actual.status.success(), "{actual:?}");
                assert!(actual.stderr.is_empty(), "{actual:?}");
                assert_eq!(&actual.stdout, expected.as_bytes(), "{optimization}");
            }
            Err(error) => {
                assert_eq!(actual.stdout, error.output().as_bytes(), "{optimization}");
                checked_failure(&actual, &error.runtime_failure().unwrap().record());
            }
        }
    }
}
pub fn runtime_boundaries(program: &ir::Program) {
    let text = codegen::emit_c(program)
        .unwrap()
        .replace("int main(void) {", "int cerune_sample_main(void) {");
    // 本物の巨大確保を試さず、サイズ検査と各mallocの失敗を独立に再現します。
    for (call, code) in [
        (
            "cerune_array_allocate_elements(INT64_MAX, 8, 8, \" node=0 bytes=0..1\\n\");",
            "allocation-size-overflow",
        ),
        (
            "cerune_array_allocate_elements(INT64_MAX, 0, SIZE_MAX, \" node=0 bytes=0..1\\n\");",
            "allocation-size-overflow",
        ),
    ] {
        let c = format!("{text}\nint main(void) {{ {call} return 0; }}\n");
        let Some(actual) = execute(&c, "-O2") else {
            return;
        };
        checked_failure(
            &actual,
            &format!("runtime-v1 code={code} node=0 bytes=0..1"),
        );
    }
    let zero_width = format!(
        "{text}\nint main(void) {{ cerune_dynamic_array a = cerune_array_allocate_elements(3, 0, 0, \"\"); assert(a.length == 3 && cerune_array_live_bytes == 0); a.owner->initialized = 3; assert(cerune_array_release_owner_last(a)); cerune_array_free_elements(a); return 0; }}\n"
    );
    let Some(actual) = execute(&zero_width, "-O2") else {
        return;
    };
    assert!(
        actual.status.success() && actual.stderr.is_empty(),
        "{actual:?}"
    );
    for nth in [1, 2] {
        let allocator = format!(
            "#include <stdlib.h>\nstatic void *test_malloc(size_t n) {{ static int count; return ++count == {nth} ? NULL : malloc(n); }}\n#define malloc test_malloc\n"
        );
        let c = format!(
            "{allocator}{text}\nint main(void) {{ cerune_array_allocate_elements(1, 8, 8, \" node=0 bytes=0..1\\n\"); return 0; }}\n"
        );
        let Some(actual) = execute(&c, "-O2") else {
            return;
        };
        checked_failure(
            &actual,
            "runtime-v1 code=allocation-failed node=0 bytes=0..1",
        );
    }
}
