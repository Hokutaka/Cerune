-- 生成器と分離して記述した、incrementの利用者側の仕様です。
namespace CeruneProof

theorem increment_exact (x : Fin 256) (h : x.val < 255) :
    generated x.val = .ok (x.val + 1) := by
  change (if x.val + 1 ≤ 255 then Except.ok (x.val + 1)
    else Except.error (Failure.integerOverflow rootOrigin)) = _
  exact ite_eq_left h

-- 対応証明を使い、生成定義についての性質をIRモデルへ戻します。
theorem ir_increment_exact (x : Fin 256) (h : x.val < 255) :
    eval reference x.val = .ok (x.val + 1) := by
  exact (translation_correct x).trans (increment_exact x h)

theorem overflow_detected :
    generated 255 = .error (.integerOverflow rootOrigin) := by
  rfl

#print axioms translation_correct
#print axioms increment_exact
#print axioms ir_increment_exact
#print axioms overflow_detected

end CeruneProof

-- HIR→MIR対応から、同じ利用者の性質をMIRへ移します。
namespace CeruneProof

theorem mir_increment_exact (x : Fin 256) (h : x.val < 255) :
    evalMir mirReference x.val = .completed (.ok (x.val + 1)) := by
  exact (mir_translation_correct x).trans (congrArg MirOutcome.completed (ir_increment_exact x h))

theorem mir_overflow_detected :
    evalMir mirReference 255 = .completed (.error (.integerOverflow rootOrigin)) := by
  exact (mir_translation_correct ⟨255, by decide⟩).trans
    (congrArg MirOutcome.completed ((translation_correct ⟨255, by decide⟩).trans overflow_detected))

#print axioms mir_translation_correct
#print axioms mir_increment_exact
#print axioms mir_overflow_detected

end CeruneProof
