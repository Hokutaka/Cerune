import Std

-- 検証実験用。全Cerune IRの意味論ではありません。
namespace CeruneProof

structure Origin where
  node : Nat
  source : Nat
  start : Nat
  stop : Nat
  deriving DecidableEq, Repr

inductive Failure where
  | integerOverflow : Origin → Failure
  deriving DecidableEq, Repr

abbrev Result := Except Failure Nat

deriving instance DecidableEq for Except

-- 言語上の完了（正常・異常）と、モデルの不正状態・評価上限を区別します。
inductive ExecutionOutcome where
  | completed : Result → ExecutionOutcome
  | invalid
  | exhausted
  deriving DecidableEq

-- 実際の完成済みIRから写した、引数・u8定数・加算の参照表現です。
inductive Expr where
  | arg
  | literal : Nat → Expr
  | add : Origin → Expr → Expr → Expr

def eval (expr : Expr) (input : Nat) : Result :=
  match expr with
  | .arg => .ok input
  | .literal n => .ok n
  | .add origin left right => do
      let a ← eval left input
      let b ← eval right input
      if a + b ≤ 255 then .ok (a + b)
      else .error (.integerOverflow origin)

-- 比較用の安定した表記。失敗も値と出自を落とさず返します。
def render (result : Result) : String :=
  match result with
  | .ok n => s!"ok {n}"
  | .error (.integerOverflow o) =>
      s!"integer-overflow node={o.node} source={o.source} bytes={o.start}..{o.stop}"

end CeruneProof
