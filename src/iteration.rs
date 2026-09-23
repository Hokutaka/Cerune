//! 配列反復を、一度のコピーと既存の添字付きforへ展開します。
use crate::{ast::*, source::Span};

pub(crate) fn expand(statement: &Stmt) -> Vec<Stmt> {
    let StmtKind::ForEach {
        index,
        element,
        value,
        body,
        header_span,
    } = &statement.kind
    else {
        unreachable!("only array iteration is expanded here")
    };
    let span = *header_span;
    // ソースから書けない名前で、別ファイルや入れ子の束縛と衝突させません。
    let suffix = format!("{}_{}", span.source_id().index(), span.start());
    let snapshot = format!("$for_in_snapshot_{suffix}");
    let cursor = format!("$for_in_cursor_{suffix}");
    let count = format!("$for_in_length_{suffix}");
    let capture = Stmt {
        kind: StmtKind::Binding {
            mutable: false,
            name: snapshot.clone(),
            type_spec: TypeSpec::Infer,
            value: value.clone(),
        },
        span: value.span,
    };
    let initializer = Stmt {
        kind: StmtKind::Binding {
            mutable: true,
            name: cursor.clone(),
            type_spec: TypeSpec::Infer,
            value: integer(0, span),
        },
        span,
    };
    let length = Expr {
        kind: ExprKind::Call {
            name: "array_len".into(),
            name_span: span,
            arguments: vec![variable(&snapshot, span)],
        },
        span,
    };
    let condition = Expr {
        kind: ExprKind::Binary {
            op: BinaryOp::Less,
            left: Box::new(variable(&cursor, span)),
            right: Box::new(variable(&count, span)),
        },
        span,
    };
    let update = Stmt {
        kind: StmtKind::Assignment {
            target: AssignmentTarget {
                name: cursor.clone(),
                name_span: span,
                projections: vec![],
                span,
            },
            value: Expr {
                kind: ExprKind::Binary {
                    op: BinaryOp::Add,
                    left: Box::new(variable(&cursor, span)),
                    right: Box::new(integer(1, span)),
                },
                span,
            },
        },
        span,
    };
    let mut iteration_body = Vec::new();
    if let Some(index) = index {
        iteration_body.push(binding(index, variable(&cursor, index.span)));
    }
    iteration_body.push(binding(
        element,
        Expr {
            kind: ExprKind::Index {
                base: Box::new(variable(&snapshot, element.span)),
                index: Box::new(variable(&cursor, element.span)),
            },
            span: element.span,
        },
    ));
    iteration_body.extend(body.clone());
    let length_binding = Stmt {
        kind: StmtKind::Binding {
            mutable: false,
            name: count,
            type_spec: TypeSpec::Infer,
            value: length,
        },
        span,
    };
    vec![
        capture,
        length_binding,
        Stmt {
            kind: StmtKind::For {
                initializer: Box::new(initializer),
                condition,
                update: Box::new(update),
                body: iteration_body,
            },
            span: statement.span,
        },
    ]
}

fn binding(header: &IterationBinding, value: Expr) -> Stmt {
    Stmt {
        kind: StmtKind::Binding {
            mutable: header.mutable,
            name: header.name.clone(),
            type_spec: header.type_spec.clone(),
            value,
        },
        span: header.span,
    }
}
fn variable(name: &str, span: Span) -> Expr {
    Expr {
        kind: ExprKind::Variable(name.into()),
        span,
    }
}
fn integer(value: usize, span: Span) -> Expr {
    Expr {
        kind: ExprKind::Integer(IntegerLiteral::decimal(value.to_string())),
        span,
    }
}
