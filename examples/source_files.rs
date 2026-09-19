//! ファイル別の解析と出自を観測します。import構文の代わりとなるAPIではありません。
use cerune_lang::{ast, bytecode, ir, lexer, parser, run_bytecode, source::SourceMap};

fn main() {
    let failing = std::env::args().nth(1).as_deref() == Some("failure");
    let mut sources = SourceMap::new();
    let library = sources.add("values.ceru", include_str!("source_files/values.ceru"));
    let entry = sources.add(
        if failing { "failure.ceru" } else { "main.ceru" },
        if failing {
            include_str!("source_files/failure.ceru")
        } else {
            include_str!("source_files/main.ceru")
        },
    );
    let mut program = ast::Program { items: Vec::new() };
    // ここでの結合は出自検証用です。公開範囲やimportの解決は、次の段階で設計します。
    for id in [library, entry] {
        let file = sources.get(id).unwrap();
        program.items.extend(
            parser::parse(lexer::lex_source(file).unwrap())
                .unwrap()
                .items,
        );
    }
    let bytecode = bytecode::lower(&ir::builder::build(&program).unwrap()).unwrap();
    match run_bytecode(&bytecode) {
        Ok(output) => print!("{output}"),
        Err(error) => {
            print!("{}", error.vm_error().output());
            let failure = error.runtime_failure().unwrap();
            eprintln!("cerune: {}", failure.record());
            eprintln!(
                "{}",
                cerune_lang::vm::render::render_compact_with_sources(
                    error.vm_error(),
                    &sources,
                    failure.span
                )
            );
            std::process::exit(1);
        }
    }
}
