-- 正常returnはしません。更新と本文の停止出自を区別します。
namespace CeruneProof

def forFailureExpected (input : Nat) : Result :=
  if input < 255 then .error (.integerOverflow loopUpdateOrigin)
  else .error (.integerOverflow loopFailureOrigin)

set_option maxRecDepth 16384 in
set_option maxHeartbeats 4000000 in
theorem for_failure_expected : ∀ (x : Fin 256),
    evalLoop loopReference hirFuel x.val = .completed (forFailureExpected x.val) := by decide

theorem mir_for_failure_expected (x : Fin 256) :
    evalMirWithFuel mirReference mirFuel x.val = .completed (forFailureExpected x.val) := by
  exact (loop_translation_correct x).trans (for_failure_expected x)

#print axioms loop_translation_correct
#print axioms loop_completed
#print axioms for_failure_expected
#print axioms mir_for_failure_expected
end CeruneProof
