-- 更新を通るcontinueと、更新を飛ばすbreakの独立した仕様です。
namespace CeruneProof

def forExpected (input : Nat) : Result :=
  if input < 251 then .ok (input + 5)
  else if input < 254 then .error (.integerOverflow loopReturnOrigin)
  else .error (.integerOverflow loopFailureOrigin)

set_option maxRecDepth 16384 in
set_option maxHeartbeats 4000000 in
theorem for_expected : ∀ (x : Fin 256),
    evalLoop loopReference hirFuel x.val = .completed (forExpected x.val) := by decide

theorem mir_for_expected (x : Fin 256) :
    evalMirWithFuel mirReference mirFuel x.val = .completed (forExpected x.val) := by
  exact (loop_translation_correct x).trans (for_expected x)

#print axioms loop_translation_correct
#print axioms loop_completed
#print axioms for_expected
#print axioms mir_for_expected
end CeruneProof
