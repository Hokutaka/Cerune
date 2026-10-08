use cerune_lang::{
    ir,
    mir::{
        self, BlockId, InstructionId, InstructionKind as I, LocalId, Operation as O, Origin, ssa::*,
    },
    types::IntegerType,
};
#[path = "../experiments/ssa/fixtures.rs"]
mod fixtures;
fn v(n: usize) -> Operand {
    Operand::Value(ValueId(n))
}
fn rejects(p: &Program, expected: &str) {
    let error = validate(p).unwrap_err();
    assert!(
        error.message.contains(expected),
        "{error:?}; expected {expected}"
    );
    assert!(text::emit(p).is_err());
}
#[test]
fn fixtures_validate_without_modification_and_emit_all_observation_sections() {
    for p in [
        fixtures::diamond(),
        fixtures::parallel_loop(),
        fixtures::residual_slots(),
    ] {
        let before = p.clone();
        validate(&p).unwrap();
        let a = text::emit(&p).unwrap();
        assert_eq!(a, text::emit(&p).unwrap());
        assert_eq!(p, before);
        assert!(a.starts_with("; Cerune scalar SSA v0.1\n"));
        assert!(a.contains("original-mir {") && a.contains("\nssa {"));
        assert!(
            a.contains("original-local=") && a.contains("original-block=") && a.contains("mir-i")
        );
        assert!(a.contains("source=0 bytes="));
    }
    let loop_text = text::emit(&fixtures::parallel_loop()).unwrap();
    assert!(loop_text.contains("then=bb1(v4, v3)"));
    assert!(loop_text.contains("retained original-block=bb3 reason=unreachable"));
    let slots = text::emit(&fixtures::residual_slots()).unwrap();
    assert!(slots.contains("slot2: [u8; 1]"));
    assert!(slots.contains("日本語\\0\\r\\ne\\u{301}é"));
}
#[test]
fn rejects_bad_definitions_references_and_within_block_order() {
    let p = fixtures::diamond();
    let mut b = p.clone();
    if let I::Assign { destination, .. } = &mut b.main.blocks[2].instructions[0].kind {
        *destination = v(2);
    }
    rejects(&b, "duplicate value");
    let mut b = p.clone();
    b.main.values.push(b.main.values[1].clone());
    rejects(&b, "without definition");
    let mut b = p.clone();
    if let I::Assign { value, .. } = &mut b.main.blocks[1].instructions[0].kind {
        *value = O::Copy(v(999));
    }
    rejects(&b, "unknown value");
    let mut b = p.clone();
    if let I::Assign { value, .. } = &mut b.main.blocks[1].instructions[0].kind {
        *value = O::Copy(v(2));
    }
    rejects(&b, "does not dominate");
    let mut b = p.clone();
    if let I::Assign { value, .. } = &mut b.main.blocks[0].instructions[0].kind {
        *value = O::Copy(v(1));
    }
    rejects(&b, "does not dominate");
    let mut b = p;
    b.main.blocks[3].instructions[0].kind = I::Output {
        value: v(2),
        newline: true,
        quoted: false,
    };
    rejects(&b, "does not dominate");
}
#[test]
fn rejects_malformed_edges_and_preserves_same_target_edge_identity() {
    let p = fixtures::diamond();
    let mut b = p.clone();
    if let TerminatorKind::Jump(e) = &mut b.main.blocks[1].terminator.kind {
        e.arguments.clear();
    }
    rejects(&b, "argument count");
    let mut b = p.clone();
    if let TerminatorKind::Jump(e) = &mut b.main.blocks[1].terminator.kind {
        e.arguments[0] = ValueId(0);
    }
    rejects(&b, "argument type");
    let mut b = p.clone();
    if let TerminatorKind::Jump(e) = &mut b.main.blocks[1].terminator.kind {
        e.arguments[0] = ValueId(3);
    }
    rejects(&b, "does not dominate");
    let mut b = p.clone();
    if let TerminatorKind::Jump(e) = &mut b.main.blocks[1].terminator.kind {
        e.target = BlockId(999);
    }
    rejects(&b, "unknown edge");
    let mut b = fixtures::parallel_loop();
    b.main.blocks[1].terminator.kind = TerminatorKind::Branch {
        condition: ValueId(0),
        then_edge: Edge {
            target: BlockId(2),
            arguments: vec![ValueId(3), ValueId(4)],
        },
        else_edge: Edge {
            target: BlockId(2),
            arguments: vec![ValueId(4), ValueId(3)],
        },
    };
    b.main.values.extend([
        Value {
            ty: b.main.values[1].ty.clone(),
            original_local: LocalId(1),
        },
        Value {
            ty: b.main.values[2].ty.clone(),
            original_local: LocalId(2),
        },
    ]);
    b.main.blocks[2].arguments = vec![ValueId(5), ValueId(6)];
    validate(&b).unwrap();
    let out = text::emit(&b).unwrap();
    assert!(out.contains("then=bb2(v3, v4) else=bb2(v4, v3)"));
}
#[test]
fn rejects_bad_block_origin_and_retained_mappings() {
    let p = fixtures::parallel_loop();
    let mut b = p.clone();
    b.main.entry = BlockId(999);
    rejects(&b, "entry");
    let mut b = p.clone();
    b.main.blocks[1].original_block = BlockId(0);
    rejects(&b, "block mapping");
    let mut b = p.clone();
    b.main.retained_unreachable.clear();
    rejects(&b, "missing retained");
    let mut b = p.clone();
    b.main.retained_unreachable.push(BlockId(3));
    rejects(&b, "retained");
    let mut b = p.clone();
    b.main.retained_unreachable[0] = BlockId(0);
    rejects(&b, "retained");
    let mut b = p.clone();
    b.main.blocks[0].instructions[0].origin = Origin::Synthetic { reason: "lost" };
    rejects(&b, "origin");
    let mut b = p.clone();
    b.main.blocks[0].instructions[0].original_instruction = InstructionId(999);
    rejects(&b, "mapping");
    let mut b = p;
    b.main.blocks[0].instructions.pop();
    rejects(&b, "mapping count");
}
#[test]
fn shared_type_slot_and_index_check_rules_are_enforced() {
    let p = fixtures::residual_slots();
    let mut b = p.clone();
    b.main.blocks[0].instructions[2].kind = I::Assign {
        destination: Operand::Slot(LocalId(2)),
        value: O::Copy(Operand::Slot(LocalId(2))),
    };
    rejects(&b, "initialization");
    let mut b = p.clone();
    b.main.blocks[0].instructions[3].kind = I::Output {
        value: v(0),
        newline: true,
        quoted: false,
    };
    rejects(&b, "preceding index");
    let mut b = p.clone();
    b.main.blocks[0].instructions[3].kind = I::Assign {
        destination: Operand::Slot(LocalId(2)),
        value: O::Array(vec![v(0)]),
    };
    // bindingを二重に初期化する迂回も認めません。
    rejects(&b, "initialized once");
    let mut b = p.clone();
    b.main.blocks[0].instructions[4].kind = I::Store {
        root: v(0),
        path: vec![],
        value: v(0),
    };
    rejects(&b, "store into SSA");
    let mut b = p.clone();
    b.main.blocks[0].instructions[6].kind = I::Output {
        value: Operand::Slot(LocalId(999)),
        newline: true,
        quoted: false,
    };
    rejects(&b, "slot");
    let mut b = p.clone();
    b.main.blocks[0].instructions[6].kind = I::Output {
        value: Operand::Slot(LocalId(0)),
        newline: true,
        quoted: false,
    };
    rejects(&b, "scalar slot");
    let mut b = p;
    b.main.blocks[0].instructions[0].kind = I::Assign {
        destination: v(0),
        value: O::Literal(mir::Literal::Boolean(false)),
    };
    rejects(&b, "type mismatch");
}
#[test]
fn all_scalar_types_are_representable_without_changing_their_operations() {
    for ty in [
        ir::Type::Integer(IntegerType::U8),
        ir::Type::Integer(IntegerType::U16),
        ir::Type::Integer(IntegerType::U32),
        ir::Type::Integer(IntegerType::U64),
        ir::Type::Integer(IntegerType::I8),
        ir::Type::Integer(IntegerType::I16),
        ir::Type::Integer(IntegerType::I32),
        ir::Type::Integer(IntegerType::I64),
        ir::Type::F32,
        ir::Type::F64,
    ] {
        let mut p = fixtures::diamond();
        p.original.main.locals[1].ty = ty.clone();
        for v in &mut p.main.values[1..] {
            v.ty = ty.clone();
        }
        if matches!(ty, ir::Type::F32 | ir::Type::F64) {
            p.original.main.blocks[0].instructions[1].kind = I::Assign {
                destination: LocalId(1),
                value: O::Literal(mir::Literal::Float("-0.0".into())),
            };
            p.main.blocks[0].instructions[1].kind = I::Assign {
                destination: v(1),
                value: O::Literal(mir::Literal::Float("-0.0".into())),
            };
        }
        validate(&p).unwrap();
    }
}
#[test]
fn function_entry_parameters_and_call_signatures_use_original_types() {
    let mut p = fixtures::diamond();
    let mut original = p.original.main.clone();
    original.id = Some(ir::FunctionId(0));
    original.name = "identity".into();
    original.locals[0].kind = mir::LocalKind::Binding {
        id: ir::BindingId(0),
        name: "flag".into(),
        mutable: false,
        borrowed: false,
    };
    original.parameters = vec![LocalId(0)];
    original.blocks[0].instructions.remove(0);
    let mut f = p.main.clone();
    f.parameters = vec![v(0)];
    f.blocks[0].arguments = vec![ValueId(0)];
    f.blocks[0].instructions.remove(0);
    p.original.functions.push(original);
    p.functions.push(f);
    validate(&p).unwrap();
    let mut b = p.clone();
    b.functions[0].blocks[0].arguments.clear();
    rejects(&b, "signature");
    let mut b = p.clone();
    b.functions[0].parameters[0] = v(1);
    rejects(&b, "parameter local");
    let mut b = p;
    b.main.blocks[3].instructions[0].kind = I::Call {
        function: ir::FunctionId(0),
        arguments: vec![v(4)],
        ownership: ir::ArgumentOwnership::Owned,
    };
    rejects(&b, "argument type");
}

#[test]
fn cfg_reachability_and_return_contracts_are_not_inferred_from_provenance() {
    let mut p = fixtures::diamond();
    p.main.blocks[0].terminator.kind = TerminatorKind::Jump(Edge {
        target: BlockId(1),
        arguments: vec![],
    });
    rejects(&p, "unreachable SSA block");
    let mut p = fixtures::diamond();
    p.main.blocks[3].terminator.kind = TerminatorKind::Return(Some(v(4)));
    rejects(&p, "return signature");
    let mut p = fixtures::diamond();
    if let TerminatorKind::Branch { condition, .. } = &mut p.main.blocks[0].terminator.kind {
        *condition = ValueId(1);
    }
    rejects(&p, "condition type");
    let mut p = fixtures::diamond();
    p.main.values[1].ty = ir::Type::String;
    rejects(&p, "non-scalar");
    let mut p = fixtures::diamond();
    p.main.values[1].original_local = LocalId(999);
    rejects(&p, "local type");
}

#[test]
fn every_operand_position_rejects_unknown_values_without_panicking() {
    let p = fixtures::residual_slots();
    for (index, instruction) in p.main.blocks[0].instructions.iter().enumerate() {
        let mut count = 0;
        instruction.kind.map_operands(|_| {
            count += 1;
        });
        for bad in 0..count {
            let mut b = p.clone();
            let mut cursor = 0;
            b.main.blocks[0].instructions[index].kind = instruction.kind.map_operands(|op| {
                let replace = cursor == bad;
                cursor += 1;
                if replace { v(usize::MAX) } else { op }
            });
            rejects(&b, "unknown value");
        }
    }
}
