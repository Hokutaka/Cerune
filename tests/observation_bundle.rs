use std::{
    fs,
    path::{Path, PathBuf},
    process::{Command, Output},
    sync::atomic::{AtomicUsize, Ordering},
};

static NEXT: AtomicUsize = AtomicUsize::new(0);
struct Scratch(PathBuf);
impl Scratch {
    fn new() -> Self {
        let path = std::env::temp_dir().join(format!(
            "cerune-observe-{}-{}",
            std::process::id(),
            NEXT.fetch_add(1, Ordering::Relaxed)
        ));
        fs::create_dir(&path).unwrap();
        Self(path)
    }
}
impl Drop for Scratch {
    fn drop(&mut self) {
        fs::remove_dir_all(&self.0).unwrap();
    }
}
fn cli(command: &str, input: &Path, options: &[&str]) -> Output {
    Command::new(env!("CARGO_BIN_EXE_cerune"))
        .arg(command)
        .arg(input)
        .args(options)
        .output()
        .unwrap()
}
fn success(output: &Output) {
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    assert!(output.stderr.is_empty());
}
const TARGETS: &[&str] = &["x86_64-unknown-linux-gnu", "x86_64-pc-windows-msvc"];
const BUDGETS: &[&str] = &["--string-heap-limit", "512", "--array-heap-limit", "1024"];
fn observe(input: &Path, target: &str, output: &Path) -> Output {
    let mut options = vec!["--target", target, "-o", output.to_str().unwrap()];
    options.extend(BUDGETS);
    cli("observe", input, &options)
}

#[test]
fn bundle_matches_individual_emits_and_is_deterministic_for_both_targets() {
    let scratch = Scratch::new();
    for (index, example) in [
        "examples/ir_stages/control_flow.ceru",
        "examples/ir_stages/owned_values.ceru",
        "examples/ir_stages/native_calls.ceru",
        "examples/modules/main.ceru",
        "examples/string_origins.ceru",
    ]
    .iter()
    .enumerate()
    {
        let input = Path::new(env!("CARGO_MANIFEST_DIR")).join(example);
        for (ti, target) in TARGETS.iter().enumerate() {
            let bundle = scratch.0.join(format!("{index}-{ti}"));
            let second = scratch.0.join(format!("{index}-{ti}-again"));
            let result = observe(&input, target, &bundle);
            success(&result);
            assert!(result.stdout.is_empty());
            success(&observe(&input, target, &second));
            for (command, file) in [
                ("emit-sources", "sources.json"),
                ("emit-ir", "program.ceir"),
                ("emit-mir", "program.mir.txt"),
                ("emit-asm", "program.origins.s"),
            ] {
                let mut options = Vec::new();
                if command != "emit-sources" {
                    options.extend(BUDGETS);
                }
                if command == "emit-asm" {
                    options.extend(["--target", target, "--annotate-origins"]);
                }
                let individual = cli(command, &input, &options);
                success(&individual);
                let actual = fs::read(bundle.join(file)).unwrap();
                assert_eq!(actual, individual.stdout, "{example} {target} {file}");
                assert_eq!(actual, fs::read(second.join(file)).unwrap());
            }
            let manifest = fs::read_to_string(bundle.join("manifest.json")).unwrap();
            assert!(manifest.contains("\"schema\": \"cerune-observation-v1\""));
            assert!(manifest.contains(&format!("\"target\": \"{target}\"")));
            assert!(manifest.contains("\"string_heap_limit\": 512"));
            assert!(manifest.contains("\"array_heap_limit\": 1024"));
            assert!(manifest.contains("\"executed\": false"));
            assert!(manifest.contains("\"optimization_passes\": []"));
            assert_eq!(
                manifest,
                fs::read_to_string(second.join("manifest.json")).unwrap()
            );
            assert_eq!(fs::read_dir(&bundle).unwrap().count(), 5);
        }
    }
}

#[test]
fn observation_preserves_source_bytes_and_does_not_execute_traps() {
    let scratch = Scratch::new();
    let input = scratch.0.join("日本語 source.ceru");
    let text = "print(\"日本語\\0\\r\\n\");\r\nprint(1 / 0);\r\n";
    fs::write(&input, text).unwrap();
    let output = scratch.0.join("bundle");
    let observed = observe(&input, TARGETS[0], &output);
    success(&observed);
    assert!(observed.stdout.is_empty());
    let sources = fs::read_to_string(output.join("sources.json")).unwrap();
    assert!(sources.contains(r#"print(\"日本語\\0\\r\\n\");\u000d\u000a"#));
    let executed = cli("run", &input, &[]);
    assert!(!executed.status.success());
    assert_eq!(executed.stdout, "日本語\0\r\n\n".as_bytes());
    assert!(String::from_utf8_lossy(&executed.stderr).contains("zero"));
}

#[test]
fn rejects_missing_or_duplicate_options_without_creating_output() {
    let scratch = Scratch::new();
    let input = Path::new(env!("CARGO_MANIFEST_DIR")).join("examples/ir_stages/control_flow.ceru");
    let output = scratch.0.join("bundle");
    let path = output.to_str().unwrap();
    for options in [
        vec!["-o", path],
        vec!["--target", TARGETS[0]],
        vec!["--target", "host", "-o", path],
        vec!["--target", TARGETS[0], "--target", TARGETS[1], "-o", path],
        vec!["--target", TARGETS[0], "-o", path, "-o", path],
        vec!["--target", TARGETS[0], "-o", path, "--annotate-origins"],
        vec![
            "--target",
            TARGETS[0],
            "-o",
            path,
            "--string-heap-limit",
            "-1",
        ],
        vec![
            "--target",
            TARGETS[0],
            "-o",
            path,
            "--array-heap-limit",
            "1",
            "--array-heap-limit",
            "2",
        ],
        vec!["--target", TARGETS[0], "-o", path, "--ssa"],
    ] {
        let result = cli("observe", &input, &options);
        assert!(!result.status.success(), "{options:?}");
        assert!(result.stdout.is_empty());
        assert!(!output.exists());
    }
}

#[test]
fn refuses_existing_paths_and_leaves_no_bundle_on_input_errors() {
    let scratch = Scratch::new();
    let input = scratch.0.join("source.ceru");
    fs::write(&input, "print(7);").unwrap();
    let existing = scratch.0.join("existing");
    fs::create_dir(&existing).unwrap();
    fs::write(existing.join("manifest.json"), b"keep").unwrap();
    assert!(!observe(&input, TARGETS[0], &existing).status.success());
    assert_eq!(fs::read(existing.join("manifest.json")).unwrap(), b"keep");
    assert_eq!(fs::read_dir(existing).unwrap().count(), 1);
    assert!(!observe(&input, TARGETS[0], &input).status.success());
    assert_eq!(fs::read_to_string(&input).unwrap(), "print(7);");
    let bundle = scratch.0.join("bundle");
    fs::write(&input, "value: i64 = true;").unwrap();
    assert!(!observe(&input, TARGETS[0], &bundle).status.success());
    assert!(!bundle.exists());
    fs::write(&input, "print(7);").unwrap();
    assert!(
        !observe(
            &input,
            TARGETS[0],
            &scratch.0.join("missing").join("bundle")
        )
        .status
        .success()
    );
    assert!(!scratch.0.join("missing").exists());
}

#[cfg(unix)]
#[test]
fn refuses_symlink_output() {
    let scratch = Scratch::new();
    let input = scratch.0.join("source.ceru");
    fs::write(&input, "print(7);").unwrap();
    let destination = scratch.0.join("destination");
    fs::create_dir(&destination).unwrap();
    let link = scratch.0.join("link");
    std::os::unix::fs::symlink(&destination, &link).unwrap();
    assert!(!observe(&input, TARGETS[0], &link).status.success());
    assert_eq!(fs::read_dir(destination).unwrap().count(), 0);
}
