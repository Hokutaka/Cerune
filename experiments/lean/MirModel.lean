-- HIRの式評価から独立して、実際のMIRの局所値・命令・CFGを評価します。
namespace CeruneProof

deriving instance DecidableEq for Except

inductive MirValue where
  | byte : Nat → MirValue
  | boolean : Bool → MirValue

inductive MirOp where
  | literal : Nat → MirOp
  | boolean : Bool → MirOp
  | copy : Nat → MirOp
  | add : Origin → Nat → Nat → MirOp
  | less : Nat → Nat → MirOp

structure MirInstruction where
  id : Nat
  destination : Nat
  operation : MirOp

inductive MirTerminator where
  | ret : Nat → MirTerminator
  | jump : Nat → MirTerminator
  | branch : Nat → Nat → Nat → MirTerminator
  | unreachable

structure MirBlock where
  instructions : List MirInstruction
  terminator : MirTerminator

structure MirFunction where
  parameter : Nat
  entry : Nat
  blocks : List MirBlock

-- 検証用の上限到達を、Ceruneの停止や不正な状態と混同しません。
inductive MirOutcome where
  | completed : Result → MirOutcome
  | invalid
  | exhausted
  deriving DecidableEq

abbrev MirLocals := Nat → Option MirValue

def mirReadOp (op : MirOp) (locals : MirLocals) : Option (Except Failure MirValue) :=
  match op with
  | .literal n => some (.ok (.byte n))
  | .boolean b => some (.ok (.boolean b))
  | .copy index => (locals index).map Except.ok
  | .add origin left right =>
    match locals left, locals right with
    | some (.byte a), some (.byte b) =>
      if a + b ≤ 255 then some (.ok (.byte (a + b)))
      else some (.error (.integerOverflow origin))
    | _, _ => none
  | .less left right =>
    match locals left, locals right with
    | some (.byte a), some (.byte b) => some (.ok (.boolean (decide (a < b))))
    | _, _ => none

def mirExecute (instructions : List MirInstruction)
    (locals : MirLocals) : Option (Except Failure MirLocals) :=
  match instructions with
  | [] => some (.ok locals)
  | instruction :: rest =>
    match mirReadOp instruction.operation locals with
    | none => none
    | some (.error failure) => some (.error failure)
    | some (.ok value) =>
      mirExecute rest
        (fun index => if index = instruction.destination then some value else locals index)

def mirRunBlocks (f : MirFunction) (fuel blockId : Nat) (locals : MirLocals) : MirOutcome :=
  match fuel with
  | 0 => .exhausted
  | remaining + 1 =>
    match f.blocks[blockId]? with
    | none => .invalid
    | some block =>
      match mirExecute block.instructions locals with
      | none => .invalid
      | some (.error failure) => .completed (.error failure)
      | some (.ok values) =>
        match block.terminator with
        | .ret index =>
          match values index with
          | some (.byte value) => .completed (.ok value)
          | _ => .invalid
        | .jump next => mirRunBlocks f remaining next values
        | .branch condition yes no =>
          match values condition with
          | some (.boolean b) => mirRunBlocks f remaining (if b then yes else no) values
          | _ => .invalid
        | .unreachable => .invalid

def evalMirWithFuel (f : MirFunction) (fuel input : Nat) : MirOutcome :=
  mirRunBlocks f fuel f.entry
    (fun index => if index = f.parameter then some (.byte input) else none)

-- exporterは全blockの循環を拒否します。これは各経路のblock数の上界です。
def evalMir (f : MirFunction) (input : Nat) : MirOutcome :=
  evalMirWithFuel f f.blocks.length input

def renderMir (result : MirOutcome) : String :=
  match result with
  | .completed result => render result
  | .invalid => "invalid MIR"
  | .exhausted => "MIR fuel exhausted"

end CeruneProof
