//! 同一のコンパイル結果を保存します。実行や外部ツール起動は担当しません。
use cerune_lang::{codegen::x86_64, ir, mir, modules::Compilation};
use std::{
    fs::{self, OpenOptions},
    io::Write,
    path::Path,
};

pub(super) fn save(
    source: &Compilation,
    hir: &ir::Program,
    target: x86_64::Target,
    output: &Path,
) -> Result<(), String> {
    // frontendもMIR変換も繰り返さず、観測するsnapshotをNativeへ渡します。
    let mir = mir::lower(hir).map_err(|e| source.render(&e.diagnostic()))?;
    let assembly = x86_64::emit_asm_from_mir(&mir, target, true).map_err(|e| source.render(&e))?;
    let manifest = format!(
        concat!(
            "{{\n",
            "  \"schema\": \"cerune-observation-v1\",\n",
            "  \"cerune_version\": \"{}\",\n",
            "  \"target\": \"{}\",\n",
            "  \"string_heap_limit\": {},\n",
            "  \"array_heap_limit\": {},\n",
            "  \"optimization_passes\": [],\n",
            "  \"executed\": false,\n",
            "  \"artifacts\": {{\n",
            "    \"sources\": \"sources.json\",\n",
            "    \"hir\": \"program.ceir\",\n",
            "    \"mir\": \"program.mir.txt\",\n",
            "    \"assembly\": \"program.origins.s\"\n",
            "  }}\n",
            "}}\n"
        ),
        env!("CARGO_PKG_VERSION"),
        target.triple(),
        hir.string_heap_limit,
        hir.array_heap_limit,
    );
    let files = [
        ("sources.json", source.source_manifest()),
        ("program.ceir", ir::text::emit(hir)),
        ("program.mir.txt", mir::text::emit(&mir)),
        ("program.origins.s", assembly),
        ("manifest.json", manifest),
    ];
    write_new_directory(output, &files)
}

fn write_new_directory(output: &Path, files: &[(&str, String)]) -> Result<(), String> {
    // create_dirは既存ディレクトリやsymlinkも拒否し、親を暗黙に作りません。
    fs::create_dir(output).map_err(|e| {
        format!(
            "failed to create new observation directory {}: {e}",
            output.display()
        )
    })?;
    let mut created = Vec::new();
    for (name, content) in files {
        let path = output.join(name);
        let result = (|| {
            let mut file = OpenOptions::new()
                .write(true)
                .create_new(true)
                .open(&path)?;
            created.push(path.clone());
            file.write_all(content.as_bytes())
        })();
        if let Err(error) = result {
            // この操作が作ったファイルだけを削除します。他のファイルは消しません。
            let mut cleanup_failed = false;
            for path in created.iter().rev() {
                cleanup_failed |= fs::remove_file(path).is_err();
            }
            cleanup_failed |= fs::remove_dir(output).is_err();
            let suffix = if cleanup_failed {
                "; incomplete observation directory remains"
            } else {
                ""
            };
            return Err(format!(
                "failed to write {}: {error}{suffix}",
                path.display()
            ));
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn failed_write_removes_only_its_new_directory() {
        let root = std::env::temp_dir().join(format!(
            "cerune-bundle-write-failure-{}",
            std::process::id()
        ));
        fs::create_dir(&root).unwrap();
        let marker = root.join("keep.txt");
        fs::write(&marker, b"keep").unwrap();
        let output = root.join("bundle");
        let error = write_new_directory(
            &output,
            &[
                ("first.txt", "written".into()),
                ("missing/next.txt", "fail".into()),
            ],
        )
        .unwrap_err();
        assert!(error.contains("failed to write"));
        assert!(!output.exists());
        assert_eq!(fs::read(&marker).unwrap(), b"keep");
        fs::remove_file(marker).unwrap();
        fs::remove_dir(root).unwrap();
    }
}
