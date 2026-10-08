namespace CeruneProof

inductive Condition where
  | boolean : Bool → Condition
  | less : Expr → Expr → Condition
  | andThen : Condition → Condition → Condition
  | orElse : Condition → Condition → Condition

def evalCondition (condition : Condition) (input : Nat) : Except Failure Bool :=
  match condition with
  | .boolean b => .ok b
  | .less left right => do
    let a ← eval left input
    let b ← eval right input
    pure (decide (a < b))
  | .andThen left right => do
    let a ← evalCondition left input
    if a then evalCondition right input else pure false
  | .orElse left right => do
    let a ← evalCondition left input
    if a then pure true else evalCondition right input

inductive BranchBody where
  | ret : Expr → BranchBody
  | choose : Condition → BranchBody → BranchBody → BranchBody

def evalBranch (body : BranchBody) (input : Nat) : Result :=
  match body with
  | .ret expr => eval expr input
  | .choose condition yes no => do
    let selected ← evalCondition condition input
    if selected then evalBranch yes input else evalBranch no input

end CeruneProof
