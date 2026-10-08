-- 内側のcontinueは1回目の加算を省き、breakは内側だけを抜けます。
namespace CeruneProof

def nestedExpected (input : Nat) : Result :=
  if input < 254 then .ok (input + 2)
  else .error (.integerOverflow loopFailureOrigin)

set_option maxRecDepth 16384 in
set_option maxHeartbeats 4000000 in
theorem nested_expected : ∀ (x : Fin 256),
    evalLoop loopReference hirFuel x.val = .completed (nestedExpected x.val) := by decide

theorem mir_nested_expected (x : Fin 256) :
    evalMirWithFuel mirReference mirFuel x.val = .completed (nestedExpected x.val) := by
  exact (loop_translation_correct x).trans (nested_expected x)

#print axioms loop_translation_correct
#print axioms loop_completed
#print axioms nested_expected
#print axioms mir_nested_expected

end CeruneProof
