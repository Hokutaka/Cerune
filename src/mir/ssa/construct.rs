//! 非最適化MIRからscalar SSAへ変換します。操作と辺の順序を変えません。
use super::*;
use mir::{InstructionKind as I, Operation as O, TerminatorKind as T};
use std::collections::BTreeSet;

pub fn construct(source: &mir::Program) -> Result<Program, mir::Error> {
    mir::validate(source)?;
    let result = Program {
        construction: Some(Construction::ScalarSsaV1),
        original: source.clone(),
        functions: source
            .functions
            .iter()
            .map(function)
            .collect::<Result<_, _>>()?,
        main: function(&source.main)?,
    };
    validate(&result)?;
    Ok(result)
}
fn definition(i: &I, f: &mir::Function) -> Option<LocalId> {
    let local = match i {
        I::Assign { destination, .. } => *destination,
        I::Store { root, path, .. } if path.is_empty() => *root,
        _ => return None,
    };
    is_scalar(&f.locals[local.0].ty).then_some(local)
}
fn reads(i: &I, f: &mir::Function) -> Vec<LocalId> {
    match i {
        // 空pathへのscalar代入は新しい値の定義です。古いrootの値は結果に使いません。
        I::Store { root, path, value } if path.is_empty() && is_scalar(&f.locals[root.0].ty) => {
            vec![*value]
        }
        _ => mir::validate::reads(i),
    }
}
fn terminal_reads(t: &T) -> Vec<LocalId> {
    match t {
        T::Branch { condition, .. } => vec![*condition],
        T::Return(v) => v.iter().copied().collect(),
        _ => vec![],
    }
}
struct Analysis {
    reachable: BTreeSet<usize>,
    parent: Vec<Option<usize>>,
    arguments: Vec<BTreeSet<usize>>,
}
fn analyze(f: &mir::Function) -> Analysis {
    let n = f.blocks.len();
    let mut reachable = BTreeSet::new();
    let mut pending = vec![f.entry.0];
    let mut predecessors = vec![BTreeSet::new(); n];
    while let Some(id) = pending.pop() {
        if reachable.insert(id) {
            for next in f.blocks[id].terminator.kind.successors() {
                predecessors[next.0].insert(id);
                pending.push(next.0);
            }
        }
    }
    let mut dom = vec![reachable.clone(); n];
    dom[f.entry.0] = BTreeSet::from([f.entry.0]);
    loop {
        let mut changed = false;
        for &id in &reachable {
            if id == f.entry.0 {
                continue;
            }
            let mut next = reachable.clone();
            for &pred in &predecessors[id] {
                next.retain(|v| dom[pred].contains(v));
            }
            next.insert(id);
            if dom[id] != next {
                dom[id] = next;
                changed = true;
            }
        }
        if !changed {
            break;
        }
    }
    let mut parent = vec![None; n];
    for &id in &reachable {
        if id != f.entry.0 {
            parent[id] = dom[id]
                .iter()
                .copied()
                .filter(|p| *p != id)
                .max_by_key(|p| dom[*p].len());
        }
    }
    let mut frontier = vec![BTreeSet::new(); n];
    for &id in &reachable {
        for &pred in &predecessors[id] {
            let mut runner = Some(pred);
            while runner != parent[id] {
                let Some(current) = runner else {
                    break;
                };
                frontier[current].insert(id);
                runner = parent[current];
            }
        }
    }
    let mut uses = vec![BTreeSet::new(); n];
    let mut defs = vec![BTreeSet::new(); n];
    let mut sites = vec![BTreeSet::new(); f.locals.len()];
    for &p in &f.parameters {
        if is_scalar(&f.locals[p.0].ty) {
            sites[p.0].insert(f.entry.0);
        }
    }
    for &id in &reachable {
        for i in &f.blocks[id].instructions {
            for read in reads(&i.kind, f) {
                if is_scalar(&f.locals[read.0].ty) && !defs[id].contains(&read.0) {
                    uses[id].insert(read.0);
                }
            }
            if let Some(local) = definition(&i.kind, f) {
                defs[id].insert(local.0);
                sites[local.0].insert(id);
            }
        }
        for read in terminal_reads(&f.blocks[id].terminator.kind) {
            if is_scalar(&f.locals[read.0].ty) && !defs[id].contains(&read.0) {
                uses[id].insert(read.0);
            }
        }
    }
    let mut live = uses.clone();
    loop {
        let mut changed = false;
        for &id in reachable.iter().rev() {
            let mut next = uses[id].clone();
            for succ in f.blocks[id].terminator.kind.successors() {
                next.extend(
                    live[succ.0]
                        .iter()
                        .filter(|local| !defs[id].contains(local))
                        .copied(),
                );
            }
            if live[id] != next {
                live[id] = next;
                changed = true;
            }
        }
        if !changed {
            break;
        }
    }
    let mut arguments = vec![BTreeSet::new(); n];
    for (local, definitions) in sites.iter().enumerate() {
        let mut work = definitions.clone();
        while let Some(id) = work.pop_first() {
            for &join in &frontier[id] {
                // 関数入口の値はsignatureから受け取ります。
                if join != f.entry.0 && live[join].contains(&local) && arguments[join].insert(local)
                {
                    work.insert(join);
                }
            }
        }
    }
    Analysis {
        reachable,
        parent,
        arguments,
    }
}
fn new_value(values: &mut Vec<Value>, source: &mir::Function, local: LocalId) -> ValueId {
    let id = ValueId(values.len());
    values.push(Value {
        ty: source.locals[local.0].ty.clone(),
        original_local: local,
    });
    id
}
fn operand(
    source: &mir::Function,
    env: &[Option<ValueId>],
    local: LocalId,
    origin: Origin,
) -> Result<Operand, mir::Error> {
    if !is_scalar(&source.locals[local.0].ty) {
        return Ok(Operand::Slot(local));
    }
    env[local.0].map(Operand::Value).ok_or_else(|| {
        mir::Error::new(
            format!("SSA construction: no reaching definition for {local}"),
            origin,
        )
    })
}
fn scalar(
    source: &mir::Function,
    env: &[Option<ValueId>],
    local: LocalId,
    origin: Origin,
) -> Result<ValueId, mir::Error> {
    match operand(source, env, local, origin)? {
        Operand::Value(v) => Ok(v),
        Operand::Slot(_) => Err(mir::Error::new("SSA construction: expected scalar", origin)),
    }
}
fn function(source: &mir::Function) -> Result<Function, mir::Error> {
    let analysis = analyze(source);
    let n = source.blocks.len();
    let mut mapping = vec![None; n];
    for (new, &old) in analysis.reachable.iter().enumerate() {
        mapping[old] = Some(BlockId(new));
    }
    let mut values = vec![];
    let mut initial = vec![None; source.locals.len()];
    let parameters = source
        .parameters
        .iter()
        .map(|&local| {
            if is_scalar(&source.locals[local.0].ty) {
                let v = new_value(&mut values, source, local);
                initial[local.0] = Some(v);
                Operand::Value(v)
            } else {
                Operand::Slot(local)
            }
        })
        .collect::<Vec<_>>();
    let mut arguments = vec![vec![]; n];
    arguments[source.entry.0] = parameters
        .iter()
        .filter_map(|p| match p {
            Operand::Value(v) => Some(*v),
            _ => None,
        })
        .collect();
    let mut definitions = vec![vec![]; n];
    for &id in &analysis.reachable {
        for &local in &analysis.arguments[id] {
            arguments[id].push(new_value(&mut values, source, LocalId(local)));
        }
        definitions[id] = source.blocks[id]
            .instructions
            .iter()
            .map(|i| definition(&i.kind, source).map(|local| new_value(&mut values, source, local)))
            .collect();
    }
    let mut children = vec![vec![]; n];
    for &id in &analysis.reachable {
        if let Some(parent) = analysis.parent[id] {
            children[parent].push(id);
        }
    }
    let mut blocks = vec![None; analysis.reachable.len()];
    // 再帰の深さをRustのstackへ載せず、各支配木の枝へ定義環境のsnapshotを渡します。
    let mut pending = vec![(source.entry.0, initial)];
    while let Some((id, mut env)) = pending.pop() {
        for &arg in &arguments[id] {
            env[values[arg.0].original_local.0] = Some(arg);
        }
        let original = &source.blocks[id];
        let mut instructions = vec![];
        for (index, i) in original.instructions.iter().enumerate() {
            for read in reads(&i.kind, source) {
                operand(source, &env, read, i.origin)?;
            }
            let kind = match &i.kind {
                I::Assign { destination, value } => {
                    let rhs = value.map_operands(|local| {
                        operand(source, &env, local, i.origin).expect("checked operand")
                    });
                    let destination = if let Some(v) = definitions[id][index] {
                        Operand::Value(v)
                    } else {
                        Operand::Slot(*destination)
                    };
                    I::Assign {
                        destination,
                        value: rhs,
                    }
                }
                I::Store { value, .. } if definitions[id][index].is_some() => I::Assign {
                    destination: Operand::Value(definitions[id][index].unwrap()),
                    value: O::Copy(operand(source, &env, *value, i.origin)?),
                },
                kind => kind.map_operands(|local| {
                    operand(source, &env, local, i.origin).expect("checked operand")
                }),
            };
            // RHSは古い環境で解決してから、新しい定義を登録します。
            if let Some(v) = definitions[id][index] {
                env[values[v.0].original_local.0] = Some(v);
            }
            instructions.push(Instruction {
                original_instruction: i.id,
                origin: i.origin,
                kind,
            });
        }
        let t = &original.terminator;
        let edge = |target: BlockId| -> Result<Edge, mir::Error> {
            Ok(Edge {
                target: mapping[target.0].expect("reachable successor"),
                arguments: arguments[target.0]
                    .iter()
                    .map(|v| scalar(source, &env, values[v.0].original_local, t.origin))
                    .collect::<Result<_, _>>()?,
            })
        };
        let kind = match &t.kind {
            T::Jump(target) => TerminatorKind::Jump(edge(*target)?),
            T::Branch {
                condition,
                then_block,
                else_block,
            } => TerminatorKind::Branch {
                condition: scalar(source, &env, *condition, t.origin)?,
                then_edge: edge(*then_block)?,
                else_edge: edge(*else_block)?,
            },
            T::Return(value) => TerminatorKind::Return(
                value
                    .map(|v| operand(source, &env, v, t.origin))
                    .transpose()?,
            ),
            T::Unreachable => {
                return Err(mir::Error::new(
                    "SSA construction: reachable unreachable terminator",
                    t.origin,
                ));
            }
        };
        blocks[mapping[id].unwrap().0] = Some(Block {
            original_block: BlockId(id),
            arguments: arguments[id].clone(),
            instructions,
            terminator: Terminator {
                original_instruction: t.id,
                origin: t.origin,
                kind,
            },
        });
        for &child in children[id].iter().rev() {
            pending.push((child, env.clone()));
        }
    }
    Ok(Function {
        values,
        parameters,
        entry: mapping[source.entry.0].unwrap(),
        blocks: blocks
            .into_iter()
            .map(|b| b.expect("dominator tree covers reachable blocks"))
            .collect(),
        retained_unreachable: (0..n)
            .filter(|id| !analysis.reachable.contains(id))
            .map(BlockId)
            .collect(),
    })
}
