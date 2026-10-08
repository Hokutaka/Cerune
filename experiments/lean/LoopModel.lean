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

def evalLoopLess (left right : LoopExpr) (locals : LoopLocals) : Option (Except Failure Bool) :=
  match evalLoopExpr left locals with
  | none => none
  | some (.error failure) => some (.error failure)
  | some (.ok a) =>
    match evalLoopExpr right locals with
    | none => none
    | some (.error failure) => some (.error failure)
    | some (.ok b) => some (.ok (decide (a < b)))

inductive LoopStatement where
  | assign : Nat → LoopExpr → LoopStatement
  | whileLess : LoopExpr → LoopExpr → List LoopStatement → LoopStatement
  | forLess : List LoopStatement → LoopExpr → LoopExpr → List LoopStatement → List LoopStatement → LoopStatement
  -- 初期化後のforの状態。exporterはforLessだけを書き出します。
  | forNext : LoopExpr → LoopExpr → List LoopStatement → List LoopStatement → LoopStatement
  | ifLess : LoopExpr → LoopExpr → List LoopStatement → List LoopStatement → LoopStatement
  | breakLoop
  | continueLoop
  | ret : LoopExpr → LoopStatement

structure LoopFunction where
  parameter : Nat
  body : List LoopStatement

-- 最も内側のループの継続・終了先を先頭に保持します。中身はHIRの文とforの反復状態です。
structure LoopFrame where
  restart : List LoopStatement
  after : List LoopStatement

-- 文の訪問ごとに1を消費します。forの開始、初期化、条件、更新もそれぞれ数えます。
-- 本文末尾でのframe復帰は文ではなく、fuelを消費しません。
def runLoopStatements (fuel : Nat) (todo : List LoopStatement)
    (locals : LoopLocals) (loops : List LoopFrame) : ExecutionOutcome :=
  let (todo, loops) := match todo, loops with
    | [], frame :: outer => (frame.restart, outer)
    | _, _ => (todo, loops)
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
          (fun index => if index = id then some value else locals index) loops
    | .ret expr :: _ =>
      match evalLoopExpr expr locals with
      | none => .invalid
      | some result => .completed result
    | .breakLoop :: _ =>
      match loops with
      | [] => .invalid
      | frame :: outer => runLoopStatements remaining frame.after locals outer
    | .continueLoop :: _ =>
      match loops with
      | [] => .invalid
      | frame :: outer => runLoopStatements remaining frame.restart locals outer
    | .ifLess left right yes no :: rest =>
      match evalLoopLess left right locals with
      | none => .invalid
      | some (.error failure) => .completed (.error failure)
      | some (.ok selected) =>
        runLoopStatements remaining ((if selected then yes else no) ++ rest) locals loops
    | .forLess initializer left right update body :: rest =>
      runLoopStatements remaining
        (initializer ++ .forNext left right update body :: rest) locals loops
    | .forNext left right update body :: rest =>
      match evalLoopLess left right locals with
      | none => .invalid
      | some (.error failure) => .completed (.error failure)
      | some (.ok selected) =>
        if selected then
          runLoopStatements remaining body locals
            (⟨update ++ .forNext left right update body :: rest, rest⟩ :: loops)
        else runLoopStatements remaining rest locals loops
    | (.whileLess left right body) :: rest =>
      match evalLoopLess left right locals with
      | none => .invalid
      | some (.error failure) => .completed (.error failure)
      | some (.ok selected) =>
        if selected then
          runLoopStatements remaining body locals
            (⟨.whileLess left right body :: rest, rest⟩ :: loops)
        else runLoopStatements remaining rest locals loops

def evalLoop (f : LoopFunction) (fuel input : Nat) : ExecutionOutcome :=
  runLoopStatements fuel f.body
    (fun index => if index = f.parameter then some input else none) []

def isCompleted : ExecutionOutcome → Bool
  | .completed _ => true
  | _ => false

end CeruneProof
