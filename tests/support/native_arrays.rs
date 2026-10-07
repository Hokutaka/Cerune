//! 共通ケースを外部assembler経由と自前Object経由で実行し、同じ診断を検査します。
use cerune_lang::{
    codegen::x86_64::{self, Target},
    ir, ir_executor,
};
use std::process::Output;
#[path = "native_process.rs"]
mod native_process;
use super::{crash_dialogs, process};
use native_process::execute;
pub fn target() -> Target {
    if cfg!(windows) {
        Target::X86_64PcWindowsMsvc
    } else {
        Target::X86_64UnknownLinuxGnu
    }
}
fn checked_failure(actual: &Output, record: &str) {
    #[cfg(unix)]
    {
        use std::os::unix::process::ExitStatusExt;
        assert_eq!(actual.status.signal(), Some(4), "{actual:?}");
    }
    #[cfg(windows)]
    assert_eq!(
        actual.status.code().map(|c| c as u32),
        Some(0xc0000409),
        "{actual:?}"
    );
    assert_eq!(
        String::from_utf8(actual.stderr.clone())
            .unwrap()
            .replace("\r\n", "\n"),
        format!("cerune: {record}\n")
    );
}
pub fn compare(program: &ir::Program, direct: &Result<String, ir_executor::ExecutionError>) {
    let text = x86_64::emit_asm(program, target()).unwrap();
    // 文字列を出力する経路ではCR/LF/NULをそのまま比較します。
    let binary = text.contains("callq _setmode");
    for (bytes, extension) in [
        (text.into_bytes(), "s"),
        (x86_64::emit_object(program, target(), true).unwrap(), "o"),
    ] {
        let Some(mut actual) = execute(&bytes, extension) else {
            return;
        };
        if cfg!(windows) && !binary {
            actual.stdout = String::from_utf8(actual.stdout)
                .unwrap()
                .replace("\r\n", "\n")
                .into_bytes();
        }
        match direct {
            Ok(expected) => {
                assert!(actual.status.success(), "{extension}: {actual:?}");
                assert!(actual.stderr.is_empty(), "{actual:?}");
                assert_eq!(&actual.stdout, expected.as_bytes(), "{extension}");
            }
            Err(error) => {
                assert_eq!(actual.stdout, error.output().as_bytes(), "{extension}");
                checked_failure(&actual, &error.runtime_failure().unwrap().record());
            }
        }
    }
}
