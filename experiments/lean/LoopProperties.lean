-- 変換器とは別の利用者仕様です。評価上限内の完了も要求します。
namespace CeruneProof

def loopExpected (input : Nat) : Result :=
  if input < 252 then .ok (input + 4)
  else .error (.integerOverflow loopFailureOrigin)

set_option maxRecDepth 16384 in
set_option maxHeartbeats 4000000 in
theorem loop_expected : ∀ (x : Fin 256),
    evalLoop loopReference hirFuel x.val = .completed (loopExpected x.val) := by decide

theorem mir_loop_expected (x : Fin 256) :
    evalMirWithFuel mirReference mirFuel x.val = .completed (loopExpected x.val) := by
  exact (loop_translation_correct x).trans (loop_expected x)

#print axioms loop_translation_correct
#print axioms loop_completed
#print axioms loop_expected
#print axioms mir_loop_expected

end CeruneProof
