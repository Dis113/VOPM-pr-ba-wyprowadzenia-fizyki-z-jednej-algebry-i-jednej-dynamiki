import VOPM.Associator
import VOPM.OctavianProduct

/-!
# VOPM-013: nonassociativity as a concrete left-translation word defect

This is a model-specific *coordinate verification* of classical octonion
multiplication, not a new general theorem about Moufang loops.

In the real Cayley-Dickson units i=e1, j=e2, k=e3=ij,
the BRACKETED scalar word k*(j*i) equals 1. But the associated
composition of linear left actions L_k ∘ L_j ∘ L_i is nontrivial on O:

    L_k L_j L_i = I - 2 P_(span{1,i,j,k})^perp
                = I - (1/2) H_assoc,
    H_assoc = (L_i L_j - L_k)^†(L_i L_j - L_k) = 4 P_perp.

It is an orthogonal involution, identity on the quaternionic 4-space
and minus identity on its complementary 4-space. Hence it fixes the
identity but is nontrivial on octonions; in an associative quaternionic
subalgebra the same translation word is simply identity.

CAUTION: the three-unit word is an ALGEBRAIC loop (product 1),
not automatically a closed three-edge path on the E8 root graph.
A separate regression tests actual E8 graph triangles and respects
inverse-link orientation. This is NOT a spacetime curvature theorem.
-/

namespace VOPM.OctavianHolonomy

open VOPM.OctonionicCoin VOPM.Associator

/-- k is the Cayley-Dickson quaternionic unit i*j. -/
def e3 : Fin 8 → ℤ :=
  ![(0 : ℤ), 0, 0, 1, 0, 0, 0, 0]

/-- Scalar octonionic word, with parentheses specified, equals one. -/
theorem closed_octonion_word :
    VOPM.OctavianProduct.mul e3
      (VOPM.OctavianProduct.mul
        VOPM.OctavianProduct.e2 VOPM.OctavianProduct.e1) =
      VOPM.OctavianProduct.one := by
  funext a
  fin_cases a <;>
    norm_num [VOPM.OctavianProduct.mul, e3,
      VOPM.OctavianProduct.e2, VOPM.OctavianProduct.e1,
      VOPM.OctavianProduct.one]

/-- A three-step *operator* word, not a scalar octonionic product. -/
def translationWord (v : Vec) : Vec :=
  leftE3 (leftE2 (leftE1 v))

/-- The word is a reflection across the quaternionic subspace. -/
theorem translationWord_formula (v : Vec) :
    translationWord v =
      fun a => v a - (1 / 2 : ℂ) * hamiltonian v a := by
  funext a
  fin_cases a <;>
    simp [translationWord, leftE1, leftE2, leftE3,
      hamiltonian, internalProjection] <;> ring

/-- Exact involution from the concrete Cayley-Dickson action. -/
theorem translationWord_involution (v : Vec) :
    translationWord (translationWord v) = v := by
  funext a
  fin_cases a <;>
    simp [translationWord, leftE1, leftE2, leftE3]

/-- The full Hermitian pairing is conserved by the translation word. -/
theorem translationWord_pairing (u v : Vec) :
    pairing (translationWord u) (translationWord v) = pairing u v := by
  simp [pairing, translationWord, leftE1, leftE2, leftE3]

/-- A unit vector in the complementary (non-quaternionic) subspace. -/
def ell : Vec :=
  ![(0 : ℂ), 0, 0, 0, 1, 0, 0, 0]

/-- The scalar word closes, but its left-action word does not. -/
theorem translationWord_nontrivial : translationWord ell ≠ ell := by
  intro h
  have h4 := congrArg (fun v : Vec => v 4) h
  norm_num [translationWord, ell, leftE1, leftE2, leftE3] at h4

end VOPM.OctavianHolonomy
