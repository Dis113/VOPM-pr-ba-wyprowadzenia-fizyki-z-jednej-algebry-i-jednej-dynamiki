import VOPM.CoinedWalk

/-!
# VOPM-009 — explicit Cayley–Dickson / octonionic internal coin

The local vacuum state is exactly eight complex amplitudes, modelled by
\`Fin 8 → ℂ\` (16 real coordinates).  In the Cayley–Dickson basis

  (1, i, j, k, ℓ, iℓ, jℓ, kℓ)

of the real octonions, \`leftE1\` below is the complex-linear extension of
LEFT multiplication by \`i\`. Its signs implement the standard
Cayley–Dickson convention. The octonion multiplication rule itself is a
PUBLISHED mathematical input; we do not claim to classify octonions here.

Because \`leftE1² = -I\`, the family

  C(c,s) = c I + s leftE1,  c,s real and c²+s²=1

has the standard rotation/isometry property. Here we verify this
**specific 8-component implementation** with Lean. The parameters are
NOT predicted from fundamental physics. This is a local free coin,
not yet an interaction between two independent vacuum quanta.

The use of complex coefficients is safe for this particular *real*
octonion generator. In general the positive definite Hermitian norm
of complex octonions is not multiplicative for arbitrary complex
octonionic factors.
-/

namespace VOPM.OctonionicCoin

/-- Local vector space: eight complex amplitudes (16 real scalars). -/
abbrev Vec := Fin 8 → ℂ

/--
Complex-linear extension of real-octonion left multiplication by i.
The Cayley–Dickson sign convention gives i(jℓ) = -(kℓ).
-/
def leftE1 (v : Vec) : Vec :=
  ![-v 1, v 0, -v 3, v 2, -v 5, v 4, v 7, -v 6]

/-- The specific imaginary-unit operator squares to minus identity. -/
theorem leftE1_square (v : Vec) :
    leftE1 (leftE1 v) = -v := by
  funext i
  fin_cases i <;> simp [leftE1]

/-- Additivity of this concrete octonionic operator. -/
theorem leftE1_add (u v : Vec) :
    leftE1 (u + v) = leftE1 u + leftE1 v := by
  funext i
  fin_cases i <;> simp [leftE1, Pi.add_apply] <;> ring

/-- Complex-linearity of this particular real octonionic generator. -/
theorem leftE1_smul (z : ℂ) (v : Vec) :
    leftE1 (z • v) = z • leftE1 v := by
  funext i
  fin_cases i <;> simp [leftE1, Pi.smul_apply, smul_eq_mul] <;> ring

/-- The positive-definite standard Hermitian pairing, written explicitly. -/
noncomputable def pairing (u v : Vec) : ℂ :=
    star (u 0) * v 0 + star (u 1) * v 1 +
    star (u 2) * v 2 + star (u 3) * v 3 +
    star (u 4) * v 4 + star (u 5) * v 5 +
    star (u 6) * v 6 + star (u 7) * v 7

/-- The octonionic generator is orthogonal/unitary for this pairing. -/
theorem leftE1_pairing (u v : Vec) :
    pairing (leftE1 u) (leftE1 v) = pairing u v := by
  simp [pairing, leftE1]
  ring

/--
We now choose a family of *concrete* internal rotations; c,s must be
real-valued complex scalars to preserve the standard Hermitian pairing.
-/
def coin (c s : ℂ) (v : Vec) : Vec :=
  fun i => c * v i + s * leftE1 v i

/-- The concrete rotation preserves all inner products on the unit circle. -/
theorem coin_pairing (c s : ℂ)
    (hc : star c = c) (hs : star s = s)
    (hunit : c * c + s * s = 1)
    (u v : Vec) :
    pairing (coin c s u) (coin c s v) = pairing u v := by
  have hform :
      pairing (coin c s u) (coin c s v) =
        (c * c + s * s) * pairing u v := by
    simp only [pairing, coin, leftE1, star_add, star_mul, star_neg, hc, hs]
    ring
  rw [hform, hunit, one_mul]

/-- The standard cosine/sine family of octonionic local coins is unitary. -/
theorem angular_coin_pairing (θ : ℝ) (u v : Vec) :
    pairing (coin (Real.cos θ) (Real.sin θ) u)
      (coin (Real.cos θ) (Real.sin θ) v) =
    pairing u v := by
  apply coin_pairing
  · simp
  · simp
  · have h : Real.cos θ ^ 2 + Real.sin θ ^ 2 = 1 :=
      Real.cos_sq_add_sin_sq θ
    exact_mod_cast h

/-- Unlike a pure direction relabelling, the coin has a mixing component. -/
theorem coin_zero_entry (c s : ℂ) (v : Vec) :
    coin c s v 0 = c * v 0 - s * v 1 := by
  simp [coin, leftE1]
  ring

end VOPM.OctonionicCoin
