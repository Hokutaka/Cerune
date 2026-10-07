use super::{crash_dialogs, process};
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
fn compiler() -> Option<&'static OsString> {
    static CC: OnceLock<Option<OsString>> = OnceLock::new();
    CC.get_or_init(|| {
        crash_dialogs::suppress();
        let configured = std::env::var_os("CERUNE_TEST_ASM_CLANG");
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
            assert!(
                configured.is_none(),
                "CERUNE_TEST_ASM_CLANG unavailable: {cc:?}"
            );
            eprintln!(
                "native array execution skipped: {cc:?}; set CERUNE_TEST_ASM_CLANG to require it"
            );
            None
        }
    })
    .as_ref()
}
pub fn execute(bytes: &[u8], extension: &str) -> Option<Output> {
    let cc = compiler()?;
    static NEXT: AtomicUsize = AtomicUsize::new(0);
    let stamp = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let w = Workspace(std::env::temp_dir().join(format!(
        "cerune-array-native-{}-{stamp}-{}",
        std::process::id(),
        NEXT.fetch_add(1, Ordering::Relaxed)
    )));
    fs::create_dir(&w.0).unwrap();
    let input = w.0.join(format!("program.{extension}"));
    let exe = w.0.join(if cfg!(windows) {
        "program.exe"
    } else {
        "program"
    });
    fs::write(&input, bytes).unwrap();
    let mut command = Command::new(cc);
    if cfg!(windows) {
        command.arg("--target=x86_64-pc-windows-msvc");
    }
    command.arg(&input).arg("-o").arg(&exe);
    if !cfg!(windows) {
        command.arg("-lm");
    }
    let linked = process::bounded_output(
        &mut command,
        &w.0,
        "native-array-link",
        Duration::from_secs(30),
    )
    .unwrap();
    assert!(
        linked.status.success(),
        "{}",
        String::from_utf8_lossy(&linked.stderr)
    );
    Some(
        process::bounded_output(
            Command::new(exe).current_dir(&w.0),
            &w.0,
            "native-array-run",
            Duration::from_secs(30),
        )
        .unwrap(),
    )
}
