use super::*;

#[derive(Clone, Copy, PartialEq, Eq)]
enum Kind {
    Type,
    Function,
    Constant,
}

#[derive(Clone)]
struct Symbol {
    name: String,
    public: bool,
    is_enum: bool,
}
#[derive(Default)]
struct Names {
    functions: HashMap<String, Symbol>,
    types: HashMap<String, Symbol>,
    constants: HashMap<String, Symbol>,
}

pub(super) fn resolve(units: &[Unit]) -> Result<Program, Diagnostic> {
    let mut names = Vec::new();
    for (index, unit) in units.iter().enumerate() {
        let mut scope = Names::default();
        for item in &unit.module.program.items {
            let (name, span, kind) = match item {
                Item::FunctionDefinition(d) => (&d.name, d.name_span, Kind::Function),
                Item::TypeDefinition(d) => (&d.name, d.name_span, Kind::Type),
                Item::ConstantDefinition(d) => (&d.name, d.name_span, Kind::Constant),
                _ => continue,
            };
            if Type::from_name(name).is_some() || (kind != Kind::Type && name == "byte_len") {
                return Err(Diagnostic::new(
                    format!("definition name `{name}` is reserved"),
                    span,
                ));
            }
            if unit.imports.contains_key(name) {
                return Err(Diagnostic::new(
                    format!("definition `{name}` conflicts with an import alias"),
                    span,
                ));
            }
            let table = match kind {
                Kind::Function => &mut scope.functions,
                Kind::Constant => &mut scope.constants,
                Kind::Type => &mut scope.types,
            };
            let symbol = Symbol {
                is_enum: matches!(item, Item::TypeDefinition(d) if d.variants.is_some()),
                name: if index == 0 && kind == Kind::Function && name == "main" {
                    name.clone()
                } else {
                    format!("module_{}_{name}", unit.id.index())
                },
                public: unit
                    .module
                    .exports
                    .iter()
                    .any(|(_, exported)| *exported == span),
            };
            if table.insert(name.clone(), symbol).is_some() {
                return Err(Diagnostic::new(
                    format!(
                        "duplicate {} `{name}`",
                        match kind {
                            Kind::Function => "function",
                            Kind::Constant => "constant",
                            Kind::Type => "type",
                        }
                    ),
                    span,
                ));
            }
        }
        names.push(scope);
    }
    let mut program = Program { items: Vec::new() };
    for (index, unit) in units.iter().enumerate() {
        let resolver = Resolver {
            units,
            names: &names,
            current: index,
        };
        for mut item in unit.module.program.items.clone() {
            match &mut item {
                Item::ConstantDefinition(d) => {
                    let symbol = &names[index].constants[&d.name];
                    d.name = symbol.name.clone();
                    resolver.ty(&mut d.type_ref, symbol.public)?;
                    resolver.expr(&mut d.value)?;
                }
                Item::TypeDefinition(d) => {
                    let public = names[index].types[&d.name].public;
                    d.name = names[index].types[&d.name].name.clone();
                    if let Some(variants) = &mut d.variants {
                        for variant in variants {
                            for field in &mut variant.fields {
                                resolver.ty(&mut field.type_ref, public)?;
                            }
                        }
                    }
                    for field in &mut d.fields {
                        resolver.ty(&mut field.type_ref, public)?;
                        if let Some(default) = &mut field.default {
                            resolver.expr(default)?;
                        }
                    }
                }
                Item::FunctionDefinition(d) => {
                    let public = names[index].functions[&d.name].public;
                    d.name = names[index].functions[&d.name].name.clone();
                    for parameter in &mut d.parameters {
                        resolver.binding(&parameter.name, parameter.name_span)?;
                        resolver.ty(&mut parameter.type_ref, public)?;
                    }
                    if let ReturnTypeRef::Value(ty) = &mut d.return_type {
                        resolver.ty(ty, public)?;
                    }
                    resolver.statements(&mut d.body)?;
                }
                Item::Statement(statement) => resolver.statement(statement)?,
            }
            program.items.push(item);
        }
    }
    Ok(program)
}

struct Resolver<'a> {
    units: &'a [Unit],
    names: &'a [Names],
    current: usize,
}
impl Resolver<'_> {
    fn name(&self, name: &str, span: Span, kind: Kind, public: bool) -> Result<String, Diagnostic> {
        let (target, member, qualified) = if let Some((alias, member)) = name.split_once("::") {
            (
                *self.units[self.current].imports.get(alias).ok_or_else(|| {
                    Diagnostic::new(format!("unknown import alias `{alias}`"), span)
                })?,
                member,
                true,
            )
        } else {
            (self.current, name, false)
        };
        let table = match kind {
            Kind::Function => &self.names[target].functions,
            Kind::Constant => &self.names[target].constants,
            Kind::Type => &self.names[target].types,
        };
        let kind = match kind {
            Kind::Function => "function",
            Kind::Constant => "constant",
            Kind::Type => "type",
        };
        let symbol = table
            .get(member)
            .ok_or_else(|| Diagnostic::new(format!("unknown {kind} `{name}`"), span))?;
        if (qualified || public) && !symbol.public {
            return Err(Diagnostic::new(
                format!(
                    "private {kind} `{name}` cannot be used {}",
                    if qualified {
                        "through an import"
                    } else {
                        "in a public signature"
                    }
                ),
                span,
            ));
        }
        Ok(symbol.name.clone())
    }

    fn constructor_name(&self, path: &str, span: Span) -> Result<String, Diagnostic> {
        if let Some((prefix, variant)) = path.rsplit_once("::")
            && (prefix.contains("::")
                || self.names[self.current]
                    .types
                    .get(prefix)
                    .is_some_and(|s| s.is_enum))
        {
            return Ok(format!(
                "{}::{variant}",
                self.name(prefix, span, Kind::Type, false)?
            ));
        }
        self.name(path, span, Kind::Type, false)
    }

    fn ty(&self, ty: &mut TypeRef, public: bool) -> Result<(), Diagnostic> {
        match &mut ty.kind {
            TypeRefKind::Named(name) if Type::from_name(name).is_none() && name != "infer" => {
                *name = self.name(name, ty.span, Kind::Type, public)?
            }
            TypeRefKind::Array { element, .. } => self.ty(element, public)?,
            _ => {}
        }
        Ok(())
    }

    fn binding(&self, name: &str, span: Span) -> Result<(), Diagnostic> {
        if self.names[self.current].constants.contains_key(name) {
            return Err(Diagnostic::new(
                format!("binding {name} conflicts with a constant"),
                span,
            ));
        }
        if self.units[self.current].imports.contains_key(name) {
            return Err(Diagnostic::new(
                format!("binding `{name}` conflicts with an import alias"),
                span,
            ));
        }
        Ok(())
    }

    fn statements(&self, body: &mut [Stmt]) -> Result<(), Diagnostic> {
        for statement in body {
            self.statement(statement)?;
        }
        Ok(())
    }

    fn statement(&self, statement: &mut Stmt) -> Result<(), Diagnostic> {
        match &mut statement.kind {
            StmtKind::Block(body) => self.statements(body)?,
            StmtKind::Match { value, arms } => {
                self.expr(value)?;
                for arm in arms {
                    let (name, variant) = arm.variant.rsplit_once("::").ok_or_else(|| {
                        Diagnostic::new("a match arm requires Enum::Variant", arm.variant_span)
                    })?;
                    arm.variant = format!(
                        "{}::{variant}",
                        self.name(name, arm.variant_span, Kind::Type, false)?
                    );
                    for field in &arm.fields {
                        if field.binding != "_" {
                            self.binding(&field.binding, field.binding_span)?;
                        }
                    }
                    self.statements(&mut arm.body)?;
                }
            }
            StmtKind::Binding {
                name,
                type_spec,
                value,
                ..
            } => {
                self.binding(name, statement.span)?;
                if let TypeSpec::Explicit(ty) = type_spec {
                    self.ty(ty, false)?;
                }
                self.expr(value)?;
            }
            StmtKind::Assignment { target, value } => {
                if self.names[self.current]
                    .constants
                    .contains_key(&target.name)
                {
                    return Err(Diagnostic::new(
                        "cannot assign to a constant",
                        target.name_span,
                    ));
                }
                for AssignmentProjection::Index { index, .. } in &mut target.projections {
                    self.expr(index)?;
                }
                self.expr(value)?;
            }
            StmtKind::Print { value } | StmtKind::Call { value } => self.expr(value)?,
            StmtKind::Return { value } => {
                if let Some(value) = value {
                    self.expr(value)?;
                }
            }
            StmtKind::If {
                condition,
                then_body,
                else_body,
            } => {
                self.expr(condition)?;
                self.statements(then_body)?;
                self.statements(else_body)?;
            }
            StmtKind::While { condition, body } => {
                self.expr(condition)?;
                self.statements(body)?;
            }
            StmtKind::For {
                initializer,
                condition,
                update,
                body,
            } => {
                self.statement(initializer)?;
                self.expr(condition)?;
                self.statement(update)?;
                self.statements(body)?;
            }
            StmtKind::Break | StmtKind::Continue => {}
        }
        Ok(())
    }

    fn expr(&self, expr: &mut Expr) -> Result<(), Diagnostic> {
        match &mut expr.kind {
            ExprKind::Call {
                name,
                name_span,
                arguments,
            } => {
                if name != "byte_len" {
                    *name = self.name(name, *name_span, Kind::Function, false)?;
                }
                for argument in arguments {
                    self.expr(argument)?;
                }
            }
            ExprKind::Construct {
                type_name,
                type_name_span,
                base,
                fields,
            } => {
                *type_name = self.constructor_name(type_name, *type_name_span)?;
                if let Some(base) = base {
                    self.expr(base)?;
                }
                for field in fields {
                    self.expr(&mut field.value)?;
                }
            }
            ExprKind::Convert { target, value, .. } => {
                self.ty(target, false)?;
                self.expr(value)?;
            }
            ExprKind::Array(values) => {
                for value in values {
                    self.expr(value)?;
                }
            }
            ExprKind::Index { base, index } => {
                self.expr(base)?;
                self.expr(index)?;
            }
            ExprKind::FieldAccess { base, .. } | ExprKind::Unary { value: base, .. } => {
                self.expr(base)?
            }
            ExprKind::Logical { left, right, .. } | ExprKind::Binary { left, right, .. } => {
                self.expr(left)?;
                self.expr(right)?;
            }
            ExprKind::Variable(name)
                if name.contains("::") || self.names[self.current].constants.contains_key(name) =>
            {
                *name = self.name(name, expr.span, Kind::Constant, false)?;
            }
            _ => {}
        }
        Ok(())
    }
}
