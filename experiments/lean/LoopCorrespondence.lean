-- 定義と切り離して保存します。実行比較は同じ定義を使い、証明はここで検査します。
namespace CeruneProof
set_option maxRecDepth 16384 in
set_option maxHeartbeats 4000000 in
theorem loop_translation_correct : ∀ (x : Fin 256),
  evalMirWithFuel mirReference mirFuel x.val = evalLoop loopReference hirFuel x.val := by decide

set_option maxRecDepth 16384 in
set_option maxHeartbeats 4000000 in
theorem loop_completed : ∀ (x : Fin 256),
  isCompleted (evalLoop loopReference hirFuel x.val) = true ∧
  isCompleted (evalMirWithFuel mirReference mirFuel x.val) = true := by decide
end CeruneProof
