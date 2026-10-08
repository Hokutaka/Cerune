-- HIRの式評価から独立した、実際のMIRの局所値・命令列の参照モデルです。
namespace CeruneProof

deriving instance DecidableEq for Except

inductive MirOp where
  | literal : Nat → MirOp
  | copy : Nat → MirOp
  | add : Origin → Nat → Nat → MirOp

structure MirInstruction where
  id : Nat
  destination : Nat
  operation : MirOp

structure MirBlock where
  instructions : List MirInstruction
  -- この初期実験ではreturnまたはunreachableだけを受け付けます。
  result : Option Nat

structure MirFunction where
  parameter : Nat
  entry : Nat
  blocks : List MirBlock

abbrev MirLocals := Nat → Option Nat

def mirReadOp (op : MirOp) (locals : MirLocals) : Option Result :=
  match op with
  | .literal n => some (.ok n)
  | .copy index => (locals index).map Except.ok
  | .add origin left right =>
    match locals left, locals right with
    | some a, some b =>
      if a + b ≤ 255 then some (.ok (a + b))
      else some (.error (.integerOverflow origin))
    | _, _ => none

-- noneはモデル上の不正状態であり、Ceruneの言語停止とは区別します。
def mirExecute (instructions : List MirInstruction) (result : Option Nat)
    (locals : MirLocals) : Option Result :=
  match instructions with
  | [] => result.bind (fun index => (locals index).map Except.ok)
  | instruction :: rest =>
    match mirReadOp instruction.operation locals with
    | none => none
    | some (.error failure) => some (.error failure)
    | some (.ok value) =>
      mirExecute rest result
        (fun index => if index = instruction.destination then some value else locals index)

def evalMir (f : MirFunction) (input : Nat) : Option Result :=
  (f.blocks[f.entry]?).bind fun block =>
    mirExecute block.instructions block.result
      (fun index => if index = f.parameter then some input else none)

end CeruneProof
