//! scalar SSAの表現と構造検証です。自動変換・実行・load形式はまだありません。
pub mod text;
mod validate;
use super::{self as mir, BlockId, InstructionId, LocalId, Origin};
use crate::ir;
pub use validate::validate;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct ValueId(pub usize);
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Operand {
    Value(ValueId),
    /// 元MIRの局所値番号です。scalar型のslotは許しません。
    Slot(LocalId),
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Value {
    pub ty: ir::Type,
    /// 定義・合流の元になった局所値。値番号とは別です。
    pub original_local: LocalId,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Program {
    /// 型・signature・出自と未到達記録の独立したsnapshotです。実行へのfallbackではありません。
    pub original: mir::Program,
    pub functions: Vec<Function>,
    pub main: Function,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Function {
    pub values: Vec<Value>,
    /// 元signatureの順番。scalarは入口引数、その他はslotです。
    pub parameters: Vec<Operand>,
    pub entry: BlockId,
    pub blocks: Vec<Block>,
    /// 元MIRのblock番号。命令・辺はoriginalにそのまま保持します。
    pub retained_unreachable: Vec<BlockId>,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Block {
    pub original_block: BlockId,
    pub arguments: Vec<ValueId>,
    pub instructions: Vec<Instruction>,
    pub terminator: Terminator,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Instruction {
    pub original_instruction: InstructionId,
    pub origin: Origin,
    pub kind: mir::InstructionKind<Operand>,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Edge {
    pub target: BlockId,
    /// 辺の終点へ同時に渡します。式やslot読取りを埋め込みません。
    pub arguments: Vec<ValueId>,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Terminator {
    pub original_instruction: InstructionId,
    pub origin: Origin,
    pub kind: TerminatorKind,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TerminatorKind {
    Jump(Edge),
    Branch {
        condition: ValueId,
        then_edge: Edge,
        else_edge: Edge,
    },
    Return(Option<Operand>),
}
impl TerminatorKind {
    pub fn edges(&self) -> Vec<&Edge> {
        match self {
            Self::Jump(e) => vec![e],
            Self::Branch {
                then_edge,
                else_edge,
                ..
            } => vec![then_edge, else_edge],
            Self::Return(_) => vec![],
        }
    }
}
pub fn is_scalar(ty: &ir::Type) -> bool {
    matches!(
        ty,
        ir::Type::Bool | ir::Type::Integer(_) | ir::Type::F32 | ir::Type::F64
    )
}
