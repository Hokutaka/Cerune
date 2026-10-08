-- 独立した利用者仕様です。最後の加算と本文の加算の停止位置も区別します。
namespace CeruneProof

def controlExpected (input : Nat) : Result :=
  if input < 250 then .ok (input + 6)
  else if input < 254 then .error (.integerOverflow loopReturnOrigin)
  else .error (.integerOverflow loopFailureOrigin)

set_option maxRecDepth 16384 in
set_option maxHeartbeats 4000000 in
theorem control_expected : ∀ (x : Fin 256),
    evalLoop loopReference hirFuel x.val = .completed (controlExpected x.val) := by decide

theorem mir_control_expected (x : Fin 256) :
    evalMirWithFuel mirReference mirFuel x.val = .completed (controlExpected x.val) := by
  exact (loop_translation_correct x).trans (control_expected x)

#print axioms loop_translation_correct
#print axioms loop_completed
#print axioms control_expected
#print axioms mir_control_expected

end CeruneProof
