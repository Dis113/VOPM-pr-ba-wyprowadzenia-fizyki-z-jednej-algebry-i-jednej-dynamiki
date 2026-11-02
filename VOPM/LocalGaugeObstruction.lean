import VOPM.OctavianProduct

/-!
# VOPM-014b: obstruction to local G2 gauge covariance of left-action links

Mathematical input: the classical Cayley-Dickson octonion algebra,
whose automorphisms form G2 (Baez 2002; Grigorian 2017, 2021).

In the decomposition O = H ⊕ H*l, the involution
    Q(a,b) = (a,-b)
is a nontrivial real octonion automorphism. This file checks its
specific coordinate implementation and an exact MODEL-SPECIFIC no-go:

Even the identity transporter U_xy = L_1 = I is sent outside the
restricted family of all octonionic LEFT multipliers L_u if we
perform independent local frame changes g_x=Q and g_y=I:

    U_xy -> g_x U_xy g_y^(-1) = Q.

Q fixes 1 but is nontrivial, so it cannot be L_u for any octonion u:
from L_u(1)=u we would need u=1, hence L_u=I != Q.

Therefore, a model allowing *only* single-left-multiplication link
operators cannot have the entire local G2 as an internal gauge
redundancy without enlarging link degrees of freedom or restricting
frame changes. This is not a no-go for all G2 gauge theories, nor
does it disprove VOPM's use of a global octonionic reference algebra.
-/

namespace VOPM.LocalGaugeObstruction

open VOPM.OctavianProduct

/-- A nontrivial, genuine Cayley-Dickson automorphism of O. -/
def quaternionFlip (a : Fin 8 → ℤ) : Fin 8 → ℤ :=
  ![a 0, a 1, a 2, a 3, -a 4, -a 5, -a 6, -a 7]

theorem quaternionFlip_involution (a : Fin 8 → ℤ) :
    quaternionFlip (quaternionFlip a) = a := by
  funext i
  fin_cases i <;> simp [quaternionFlip]

/-- Exact coordinate certificate: Q preserves the octonion product. -/
theorem quaternionFlip_multiplicative (a b : Fin 8 → ℤ) :
    quaternionFlip (mul a b) =
      mul (quaternionFlip a) (quaternionFlip b) := by
  funext i
  fin_cases i <;>
    simp [quaternionFlip, mul] <;>
    ring

/-- No complex or nonassociative complication: a*1=a exactly. -/
theorem oct_mul_one_right (a : Fin 8 → ℤ) :
    mul a one = a := by
  funext i
  fin_cases i <;> simp [mul, one]

/-- The identity also acts on the left. -/
theorem oct_one_mul_left (a : Fin 8 → ℤ) :
    mul one a = a := by
  funext i
  fin_cases i <;> simp [mul, one]

theorem quaternionFlip_fixes_one : quaternionFlip one = one := by
  decide

/--
A genuine octonion automorphism Q need NOT be left multiplication
by any octonion. This is the concrete obstruction to closing the
restricted link family under independent local G2 frame changes.
-/
theorem quaternionFlip_not_leftMultiplier (u : Fin 8 → ℤ) :
    ¬ (∀ v : Fin 8 → ℤ, quaternionFlip v = mul u v) := by
  intro h
  have hu : u = one := by
    calc
      u = mul u one := (oct_mul_one_right u).symm
      _ = quaternionFlip one := (h one).symm
      _ = one := quaternionFlip_fixes_one
  have he4 : quaternionFlip e4 = e4 := by
    calc
      quaternionFlip e4 = mul u e4 := h e4
      _ = mul one e4 := by rw [hu]
      _ = e4 := oct_one_mul_left e4
  have h4 := congrArg (fun v : Fin 8 → ℤ => v 4) he4
  norm_num [quaternionFlip, e4] at h4

/--
In the model where a link transporter must equal L_u, the local
change g_x=Q, g_y=I sends the original L_1=I outside that family.
-/
theorem independent_g2_frames_not_closed :
    ¬ ∃ u : Fin 8 → ℤ,
        ∀ v : Fin 8 → ℤ, quaternionFlip v = mul u v := by
  rintro ⟨u, hu⟩
  exact quaternionFlip_not_leftMultiplier u hu

end VOPM.LocalGaugeObstruction
