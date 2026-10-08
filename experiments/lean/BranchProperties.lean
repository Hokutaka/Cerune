-- 利用者の仕様は生成器と別に保持します。127以上ではelse側を使います。
namespace CeruneProof

def branchExpected (input : Nat) : Result :=
  if input < 127 then .ok (input + 1)
  else if input < 254 then .ok (input + 2)
  else .error (.integerOverflow branchFailureOrigin)

set_option maxRecDepth 8192 in
theorem branch_expected : ∀ (x : Fin 256),
    evalBranch branchReference x.val = branchExpected x.val := by decide

theorem mir_branch_expected (x : Fin 256) :
    evalMir mirReference x.val = .completed (branchExpected x.val) := by
  exact (branch_translation_correct x).trans (congrArg ExecutionOutcome.completed (branch_expected x))

#print axioms branch_translation_correct
#print axioms branch_expected
#print axioms mir_branch_expected

end CeruneProof
