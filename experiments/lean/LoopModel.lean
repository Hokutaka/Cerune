-- 構造化されたHIRを評価します。MIRのblockや評価器は使いません。
namespace CeruneProof

inductive LoopExpr where
  | local : Nat → LoopExpr
  | literal : Nat → LoopExpr
  | add : Origin → LoopExpr → LoopExpr → LoopExpr

abbrev LoopLocals := Nat → Option Nat

def evalLoopExpr (expr : LoopExpr) (locals : LoopLocals) : Option Result :=
  match expr with
  | .local id => (locals id).map Except.ok
  | .literal value => some (.ok value)
  | .add origin left right =>
    match evalLoopExpr left locals with
    | none => none
    | some (.error failure) => some (.error failure)
    | some (.ok a) =>
      match evalLoopExpr right locals with
      | none => none
      | some (.error failure) => some (.error failure)
      | some (.ok b) =>
        if a + b ≤ 255 then some (.ok (a + b))
        else some (.error (.integerOverflow origin))

inductive LoopStatement where
  | assign : Nat → LoopExpr → LoopStatement
  | whileLess : LoopExpr → LoopExpr → List LoopStatement → LoopStatement
  | ret : LoopExpr → LoopStatement

structure LoopFunction where
  parameter : Nat
  body : List LoopStatement

-- 文の訪問ごとに1を消費します。whileの条件判定も毎回1として数えます。
-- 継続列はHIRの文のままで、分岐先やMIRの一時値を構築しません。
def runLoopStatements (fuel : Nat) (todo : List LoopStatement)
    (locals : LoopLocals) : ExecutionOutcome :=
  match fuel with
  | 0 => .exhausted
  | remaining + 1 =>
    match todo with
    | [] => .invalid
    | .assign id expr :: rest =>
      match evalLoopExpr expr locals with
      | none => .invalid
      | some (.error failure) => .completed (.error failure)
      | some (.ok value) =>
        runLoopStatements remaining rest
          (fun index => if index = id then some value else locals index)
    | .ret expr :: _ =>
      match evalLoopExpr expr locals with
      | none => .invalid
      | some result => .completed result
    | (.whileLess left right body) :: rest =>
      match evalLoopExpr left locals with
      | none => .invalid
      | some (.error failure) => .completed (.error failure)
      | some (.ok a) =>
        match evalLoopExpr right locals with
        | none => .invalid
        | some (.error failure) => .completed (.error failure)
        | some (.ok b) =>
          if a < b then
            runLoopStatements remaining (body ++ .whileLess left right body :: rest) locals
          else runLoopStatements remaining rest locals

def evalLoop (f : LoopFunction) (fuel input : Nat) : ExecutionOutcome :=
  runLoopStatements fuel f.body
    (fun index => if index = f.parameter then some input else none)

def isCompleted : ExecutionOutcome → Bool
  | .completed _ => true
  | _ => false

end CeruneProof
