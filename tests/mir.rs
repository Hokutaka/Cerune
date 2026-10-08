use cerune_lang::{
    compile_to_ir, ir,
    mir::{self, *},
};
use std::{
    fs,
    path::{Path, PathBuf},
};

fn lower(source: &str) -> Program {
    mir::lower(&compile_to_ir(source).unwrap()).unwrap()
}
fn instructions(p: &Program) -> impl Iterator<Item = &Instruction> {
    p.functions
        .iter()
        .chain([&p.main])
        .flat_map(|f| &f.blocks)
        .flat_map(|b| &b.instructions)
}
fn all_files(dir: &Path, files: &mut Vec<PathBuf>) {
    for entry in fs::read_dir(dir).unwrap() {
        let path = entry.unwrap().path();
        if path.is_dir() {
            all_files(&path, files);
        } else if path.extension().is_some_and(|e| e == "ceru") {
            files.push(path);
        }
    }
}
#[test]
fn every_example_lowers_without_changing_hir_and_has_deterministic_output() {
    let root = Path::new(env!("CARGO_MANIFEST_DIR"));
    let mut files = vec![];
    all_files(&root.join("examples"), &mut files);
    files.sort();
    let mut count = 0;
    for file in files {
        // ここだけはimportでなく、SourceMapからASTを連結するAPIの例です。
        if file.parent() == Some(root.join("examples/source_files").as_path()) {
            continue;
        }
        let c = cerune_lang::modules::load(&file)
            .unwrap_or_else(|e| panic!("{}: {}", file.display(), e.render()));
        let hir = c
            .to_ir()
            .unwrap_or_else(|e| panic!("{}: {e:?}", file.display()));
        let before = hir.clone();
        let p = mir::lower(&hir).unwrap_or_else(|e| panic!("{}: {e:?}", file.display()));
        assert_eq!(hir, before, "{}", file.display());
        let dump = mir::text::emit(&p);
        assert_eq!(dump, mir::text::emit(&mir::lower(&hir).unwrap()));
        assert!(dump.starts_with("; Cerune MIR v0.1\n"));
        assert!(!dump.contains(root.to_str().unwrap()));
        count += 1;
    }
    assert!(count >= 114, "unexpected example coverage: {count}");
}
#[test]
fn source_map_and_exact_string_bytes_survive_lowering() {
    for entry in [
        include_str!("../examples/source_files/main.ceru"),
        include_str!("../examples/source_files/failure.ceru"),
    ] {
        let mut sources = cerune_lang::source::SourceMap::new();
        let first = sources.add(
            "private-name-one.ceru",
            include_str!("../examples/source_files/values.ceru"),
        );
        let second = sources.add("private-name-two.ceru", entry);
        let mut ast = cerune_lang::ast::Program { items: vec![] };
        for id in [first, second] {
            ast.items.extend(
                cerune_lang::parser::parse(
                    cerune_lang::lexer::lex_source(sources.get(id).unwrap()).unwrap(),
                )
                .unwrap()
                .items,
            );
        }
        let p = mir::lower(&ir::builder::build(&ast).unwrap()).unwrap();
        for id in [first, second] {
            assert!(
                instructions(&p)
                    .any(|i| i.origin.source().is_some_and(|o| o.span.source_id() == id))
            );
        }
        let text = mir::text::emit(&p);
        assert!(!text.contains("private-name"));
    }
    let p = lower("print(\"日本語\\0\\r\\néé\");");
    assert!(instructions(&p).any(|i|matches!(&i.kind,InstructionKind::Assign{value:Operation::Literal(Literal::String(v)),..} if v=="日本語\0\r\néé")));
}
#[test]
fn short_circuit_keeps_rhs_call_on_only_the_selected_edge() {
    let p = lower(
        "fn hit()->bool {print(99);return true;} print(false && hit()); print(true || hit());",
    );
    let mut found = 0;
    for f in p.functions.iter().chain([&p.main]) {
        for b in &f.blocks {
            let TerminatorKind::Branch {
                then_block,
                else_block,
                ..
            } = b.terminator.kind
            else {
                continue;
            };
            let rhs = |id: BlockId| {
                matches!(
                    f.blocks[id.0].origin,
                    Origin::Derived {
                        reason: "short-circuit-rhs",
                        ..
                    }
                )
            };
            if !rhs(then_block) && !rhs(else_block) {
                continue;
            }
            let (right, join) = if rhs(then_block) {
                (then_block, else_block)
            } else {
                (else_block, then_block)
            };
            assert!(f.blocks[right.0].instructions.iter().any(|i| matches!(
                i.kind,
                InstructionKind::Assign {
                    value: Operation::Call {
                        function: ir::FunctionId(0),
                        ..
                    },
                    ..
                }
            )));
            assert!(!b.instructions.iter().any(|i| matches!(
                i.kind,
                InstructionKind::Assign {
                    value: Operation::Call { .. },
                    ..
                }
            )));
            assert_eq!(
                f.blocks[right.0].terminator.kind,
                TerminatorKind::Jump(join)
            );
            let o = b.terminator.origin.source().unwrap();
            let source = "fn hit()->bool {print(99);return true;} print(false && hit()); print(true || hit());";
            if source[o.span.start()..o.span.end()].contains("&&") {
                assert_eq!(right, then_block);
            } else {
                assert_eq!(right, else_block);
            }
            found += 1;
        }
    }
    assert_eq!(found, 2);
}
#[test]
fn for_and_while_continue_and_nested_break_keep_their_destinations() {
    let src = "for(mut i:i64=0;i<2;i=i+1){while true {break;} if i==0 {continue;} break;} mut j:i64=0; while j<2 {j=j+1;continue;}";
    let p = lower(src);
    let mut reasons = vec![];
    for b in &p.main.blocks {
        let Some(o) = b.terminator.origin.source() else {
            continue;
        };
        let spelling = &src[o.span.start()..o.span.end()];
        if spelling != "continue;" && spelling != "break;" {
            continue;
        }
        let TerminatorKind::Jump(next) = b.terminator.kind else {
            panic!("loop control must be jump")
        };
        let Origin::Derived { reason, .. } = p.main.blocks[next.0].origin else {
            panic!("missing derived loop block")
        };
        reasons.push((o.span.start(), spelling, reason));
    }
    reasons.sort();
    assert_eq!(
        reasons.iter().map(|(_, s, r)| (*s, *r)).collect::<Vec<_>>(),
        [
            ("break;", "loop-exit"),
            ("continue;", "for-update"),
            ("break;", "loop-exit"),
            ("continue;", "loop-condition")
        ]
    );
}
#[test]
fn indices_are_checked_in_order_before_rhs_and_preserve_projection_origin() {
    let src = "fn row()->i64 {print(1);return 0;} fn col()->i64 {print(2);return 1;} fn rhs()->i64 {print(3);return 9;} mut a:[[i64;2];2]=[[0,0],[0,0]]; a[row()][col()]=rhs();";
    let p = lower(src);
    let mut observed = vec![];
    for i in p.main.blocks.iter().flat_map(|b| &b.instructions) {
        match &i.kind {
            InstructionKind::Assign {
                value: Operation::Call { function, .. },
                ..
            } if function.0 < 3 => observed.push(format!("call{}", function.0)),
            InstructionKind::CheckIndex { path, .. } => {
                observed.push(format!("check{}", path.len()));
                let o = i.origin.source().unwrap();
                assert_eq!(
                    &src[o.span.start()..o.span.end()],
                    if path.len() == 1 {
                        "[row()]"
                    } else {
                        "[col()]"
                    }
                );
            }
            InstructionKind::Store { path, .. } if !path.is_empty() => {
                observed.push("store".into())
            }
            _ => {}
        }
    }
    assert_eq!(
        observed,
        ["call0", "check1", "call1", "check2", "call2", "store"]
    );
    let mut broken = p.clone();
    for b in &mut broken.main.blocks {
        b.instructions
            .retain(|i| !matches!(i.kind, InstructionKind::CheckIndex { .. }));
    }
    assert!(
        mir::validate(&broken)
            .unwrap_err()
            .message
            .contains("preceding index check")
    );
}
#[test]
fn dynamic_array_operations_and_budget_are_preserved_without_inlining_helpers() {
    let mut hir = compile_to_ir(include_str!(
        "../examples/dynamic_arrays/lowering_order.ceru"
    ))
    .unwrap();
    hir.array_heap_limit = 48;
    hir.string_heap_limit = 123;
    let p = mir::lower(&hir).unwrap();
    assert_eq!((p.array_heap_limit, p.string_heap_limit), (48, 123));
    assert_eq!(p.functions.len(), hir.function_definitions.len());
    for (f, h) in p.functions.iter().zip(&hir.function_definitions) {
        assert_eq!(
            (f.id, f.lowering, f.argument_ownership),
            (Some(h.id), h.lowering, h.argument_ownership())
        );
    }
    for pred in [
        (|i: &Instruction| {
            matches!(
                i.kind,
                InstructionKind::Assign {
                    value: Operation::ArrayAllocate { .. },
                    ..
                }
            )
        }) as fn(&Instruction) -> bool,
        |i| matches!(i.kind, InstructionKind::ArrayInitialize { .. }),
        |i| {
            matches!(
                i.kind,
                InstructionKind::Assign {
                    value: Operation::ArrayReleaseOwner(_),
                    ..
                }
            )
        },
        |i| matches!(i.kind, InstructionKind::ArrayFree { .. }),
    ] {
        assert!(instructions(&p).any(pred));
    }
}
fn rejects(p: &Program, expected: &str) {
    let e = mir::validate(p).unwrap_err();
    assert!(e.message.contains(expected), "{e:?}; expected {expected}");
}
#[test]
fn validator_rejects_invalid_references_types_origins_and_calls() {
    let p = lower("fn f(x:i64)->i64{return x;} if true {print(f(1));} else {print(2);}");
    let mut b = p.clone();
    b.main.blocks[0].terminator.kind = TerminatorKind::Jump(BlockId(999));
    rejects(&b, "successor");
    let mut b = p.clone();
    let i = &mut b.main.blocks[0].instructions[0];
    i.kind = InstructionKind::Assign {
        destination: LocalId(999),
        value: Operation::Literal(Literal::Boolean(true)),
    };
    rejects(&b, "unknown local");
    let mut b = p.clone();
    b.main.locals[0].ty = ir::Type::String;
    rejects(&b, "type mismatch");
    let mut b = p.clone();
    let i = b
        .main
        .blocks
        .iter_mut()
        .flat_map(|b| &mut b.instructions)
        .find(|i| {
            matches!(
                i.kind,
                InstructionKind::Assign {
                    value: Operation::Call { .. },
                    ..
                }
            )
        })
        .unwrap();
    i.origin = Origin::Synthetic { reason: "lost" };
    rejects(&b, "primary HIR origin");
    let mut b = p.clone();
    let i = b
        .main
        .blocks
        .iter_mut()
        .flat_map(|b| &mut b.instructions)
        .find(|i| {
            matches!(
                i.kind,
                InstructionKind::Assign {
                    value: Operation::Call { .. },
                    ..
                }
            )
        })
        .unwrap();
    if let InstructionKind::Assign {
        value: Operation::Call { ownership, .. },
        ..
    } = &mut i.kind
    {
        *ownership = ir::ArgumentOwnership::Borrowed;
    }
    rejects(&b, "ownership");
    let mut b = p.clone();
    b.main.blocks[0].terminator.id = b.main.blocks[0].instructions[0].id;
    rejects(&b, "duplicate instruction");
    let mut b = p.clone();
    b.main.blocks[0].terminator.kind = TerminatorKind::Return(Some(LocalId(0)));
    rejects(&b, "return signature");
}
#[test]
fn validator_requires_initialization_on_every_incoming_path_including_loop_entry() {
    let p = lower("mut x:i64=1; if true {x=2;} else {x=3;} print(x);");
    let binding = p
        .main
        .locals
        .iter()
        .position(|l| matches!(&l.kind,LocalKind::Binding{name,..} if name=="x"))
        .unwrap();
    let mut b = p.clone();
    for block in &mut b.main.blocks {
        block.instructions.retain(|i|!matches!(i.kind,InstructionKind::Assign{destination,..} if destination==LocalId(binding)));
    }
    rejects(&b, "initialization");
    // 条件分岐の片側だけにある一時値を、合流後で読む破損を作ります。
    let mut b = p.clone();
    let (then_block, else_block) = match b.main.blocks[0].terminator.kind {
        TerminatorKind::Branch {
            then_block,
            else_block,
            ..
        } => (then_block, else_block),
        _ => panic!(),
    };
    let temp = match b.main.blocks[then_block.0].instructions[0].kind {
        InstructionKind::Assign { destination, .. } => destination,
        _ => panic!(),
    };
    if let InstructionKind::Store { value, .. } = &mut b.main.blocks[else_block.0]
        .instructions
        .last_mut()
        .unwrap()
        .kind
    {
        *value = temp;
    } else {
        panic!();
    }
    rejects(&b, "initialization");
    let mut b = lower("mut x:i64=0; while x<2 {x=x+1;} print(x);");
    let first = &mut b.main.blocks[0].instructions;
    let removed = first.remove(0);
    // backedgeから値が来るだけでは初回入口の初期化を満たしません。
    let body = b
        .main
        .blocks
        .iter_mut()
        .find(|b| {
            matches!(
                b.origin,
                Origin::Derived {
                    reason: "loop-body",
                    ..
                }
            )
        })
        .unwrap();
    body.instructions.insert(0, removed);
    rejects(&b, "initialization");
}
#[test]
fn rejects_unexpanded_hir_instead_of_silently_ignoring_it() {
    let mut h = compile_to_ir("print(1);").unwrap();
    let ir::StatementKind::Print { value } = &mut h.statements[0].kind else {
        panic!()
    };
    let original = value.clone();
    value.kind = ir::ExprKind::ArrayCopy {
        value: Box::new(original),
        range: None,
    };
    let node_id = value.id;
    let e = mir::lower(&h).unwrap_err();
    assert!(e.message.contains("incomplete HIR"));
    assert_eq!(e.origin.unwrap().node_id, node_id);
}
#[test]
fn cli_emits_mir_with_budgets_and_rejects_unknown_pass_flags() {
    let bin = env!("CARGO_BIN_EXE_cerune");
    let file =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("examples/dynamic_arrays/lowering_order.ceru");
    let out = std::process::Command::new(bin)
        .arg("emit-mir")
        .arg(&file)
        .args(["--array-heap-limit", "48", "--string-heap-limit", "123"])
        .output()
        .unwrap();
    assert!(
        out.status.success(),
        "{}",
        String::from_utf8_lossy(&out.stderr)
    );
    let text = String::from_utf8(out.stdout).unwrap();
    assert!(text.contains("budget string=123 array=48"));
    assert!(text.contains("derived=for-update"));
    let out = std::process::Command::new(bin)
        .arg("emit-mir")
        .arg(&file)
        .arg("--mir-passes")
        .output()
        .unwrap();
    assert!(!out.status.success());
    assert!(out.stdout.is_empty());
}

#[test]
fn control_flow_example_has_known_output_in_current_execution_routes() {
    let source = include_str!("../examples/ir_stages/control_flow.ceru");
    assert_eq!(cerune_lang::run_ir(source).unwrap(), "2\n4\n");
    assert_eq!(cerune_lang::run_vm(source).unwrap(), "2\n4\n");
    let hir = compile_to_ir(source).unwrap();
    let mir = mir::lower(&hir).unwrap();
    assert!(mir::text::emit(&mir).contains("derived=short-circuit-rhs"));
}

#[test]
fn runtime_failure_sites_remain_primary_mir_origins() {
    for (src, array_budget, string_budget) in [
        ("print(7); print(1/0);", 100, 100),
        ("mut a:[i64;1]=[1]; print(7); a[2]=3;", 100, 100),
        ("print(7); print(concat(\"ab\",\"cd\"));", 100, 1),
        (
            include_str!("../examples/dynamic_arrays/lowering_order.ceru"),
            47,
            100,
        ),
    ] {
        let mut hir = compile_to_ir(src).unwrap();
        hir.array_heap_limit = array_budget;
        hir.string_heap_limit = string_budget;
        let failure = cerune_lang::ir_executor::run(&hir)
            .unwrap_err()
            .runtime_failure()
            .unwrap();
        let mir = mir::lower(&hir).unwrap();
        assert!(
            instructions(&mir).any(|i| matches!(i.origin,Origin::Source(o)
            if o.node_id==failure.node_id && o.span==failure.span)),
            "{failure:?}"
        );
    }
}

#[test]
fn validator_does_not_accept_checks_after_indices_are_reassigned() {
    let mut p = lower("mut a:[i64;2]=[1,2]; a[0]=3;");
    let b = &mut p.main.blocks[0];
    let check = b
        .instructions
        .iter()
        .position(|i| matches!(i.kind, InstructionKind::CheckIndex { .. }))
        .unwrap();
    let index = match &b.instructions[check].kind {
        InstructionKind::CheckIndex { path, .. } => path[0],
        _ => panic!(),
    };
    let mut overwritten = b.instructions[check].clone();
    overwritten.id = InstructionId(usize::MAX);
    overwritten.kind = InstructionKind::Assign {
        destination: index,
        value: Operation::Literal(Literal::Integer(99)),
    };
    b.instructions.insert(check + 1, overwritten);
    rejects(&p, "preceding index check");
}

#[test]
fn validator_prevents_assign_from_bypassing_binding_mutability() {
    let mut p = lower("mut x:i64=1; x=2;");
    let i = p.main.blocks[0]
        .instructions
        .iter_mut()
        .find(|i| matches!(i.kind, InstructionKind::Store { .. }))
        .unwrap();
    let InstructionKind::Store { root, value, .. } = i.kind else {
        panic!()
    };
    i.kind = InstructionKind::Assign {
        destination: root,
        value: Operation::Copy(value),
    };
    rejects(&p, "initialized once");
}

#[test]
fn index_check_facts_are_invalidated_by_binding_stores_too() {
    let mut p = lower("mut a:[i64;2]=[1,2]; a[0]=3;");
    let b = &mut p.main.blocks[0];
    let check = b
        .instructions
        .iter()
        .position(|i| matches!(i.kind, InstructionKind::CheckIndex { .. }))
        .unwrap();
    let index = match &b.instructions[check].kind {
        InstructionKind::CheckIndex { path, .. } => path[0],
        _ => panic!(),
    };
    p.main.locals[index.0].kind = LocalKind::Binding {
        id: ir::BindingId(usize::MAX),
        name: "index".into(),
        mutable: true,
        borrowed: true,
    };
    let mut store = b.instructions[check].clone();
    store.id = InstructionId(usize::MAX);
    store.kind = InstructionKind::Store {
        root: index,
        path: vec![],
        value: index,
    };
    b.instructions.insert(check + 1, store);
    rejects(&p, "preceding index check");
}
