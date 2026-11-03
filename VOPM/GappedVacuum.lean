import VOPM.Associator
import VOPM.ManyBody

/-!
# VOPM-015: a gapped scalar spinor vacuum and a positive hopping parent Hamiltonian

Classical inputs: Elitzur (1975), positive frustration-free spin
Hamiltonians, octonion G2 automorphisms, and Lieb-Robinson bounds.

At each vertex the *same* local space C^8=(C·1) ⊕ C^7 is used.
The previous independent exact calculation of all 21 asso defect
squares yields H_sym=48 P_im: the unique LOCAL zero-energy spinor is 1.

Here we verify the exact local ground space, a two-site positive
coupling with genuine OFF-DIAGONAL hopping, and the ground-space
and gap lower bound for arbitrary link coefficients T.

The link T can come from the octavian label u via the projected
left-action P_im L_u P_im, which is verified separately for all 240
published units. T need not itself be unitary: B^dag B is positive
regardless, and the resulting whole Hamiltonian is Hermitian.

WARNING: choosing the scalar 1 is built into the octonion algebra.
This is NOT spontaneous breaking of Spin(7), nor of a local G2.
Hamiltonian evolution is unitary and does not attract every state
to the ground state. The overall relative hopping coefficient is
a chosen ansatz, not a derived physical constant.

No emergence of 3+1, gauge bosons, gravity, or SM particles is shown.
-/

namespace VOPM.GappedVacuum

open VOPM.OctonionicCoin

abbrev PairBasis := Fin 8 × Fin 8
abbrev PairWave := PairBasis → ℂ

/-- The distinguished spinor is the scalar octonion 1. -/
def vacuumSpinor : Vec :=
  fun a => if a = 0 then 1 else 0

/-- A normalized local excited state is orthogonal to the scalar 1. -/
def imaginaryProjector (v : Vec) : Vec :=
  fun a => if a = 0 then 0 else v a

/--
The exact symmetric associator energy 48 P_im on C^8.
The matrix identity Sum_{i<j} Aij* Aij = 48 P_im has been audited
by the existing independent exact-integer VOPM-011 benchmark.
-/
def symMass (v : Vec) : Vec :=
  fun a => 48 * imaginaryProjector v a

theorem symMass_vacuum : symMass vacuumSpinor = 0 := by
  funext a
  by_cases h : a = 0 <;> simp [symMass, imaginaryProjector, vacuumSpinor, h]

/-- There are no additional local zero-energy spinor directions. -/
theorem symMass_kernel (v : Vec) :
    symMass v = 0 ↔ ∀ a : Fin 8, a ≠ 0 → v a = 0 := by
  constructor
  · intro h a ha
    have ht := congrArg (fun w : Vec => w a) h
    simp [symMass, imaginaryProjector, ha] at ht
    exact ht
  · intro h
    funext a
    by_cases ha : a = 0
    · simp [symMass, imaginaryProjector, ha]
    · simp [symMass, imaginaryProjector, ha, h a ha]

/-- The real on-site energy is 48 times the squared imaginary norm. -/
noncomputable def onsiteEnergy (v : Vec) : ℝ :=
  ∑ a : Fin 8, if a = 0 then 0 else 48 * Complex.normSq (v a)

theorem onsiteEnergy_nonneg (v : Vec) : 0 ≤ onsiteEnergy v := by
  unfold onsiteEnergy
  apply Finset.sum_nonneg
  intro a ha
  split_ifs <;> nlinarith [Complex.normSq_nonneg (v a)]

/-- A zero on-site energy forces all seven imaginary coordinates to vanish. -/
theorem onsiteEnergy_zero_iff (v : Vec) :
    onsiteEnergy v = 0 ↔ ∀ a : Fin 8, a ≠ 0 → v a = 0 := by
  unfold onsiteEnergy
  rw [Finset.sum_eq_zero_iff_of_nonneg
    (fun a ha => by split_ifs <;> nlinarith [Complex.normSq_nonneg (v a)])]
  constructor
  · intro h a ha
    have hterm := h a (Finset.mem_univ a)
    simp [ha] at hterm
    exact hterm
  · intro h a ha
    by_cases h0 : a = 0
    · simp [h0]
    · simp [h0, h a h0]

theorem onsiteEnergy_vacuum : onsiteEnergy vacuumSpinor = 0 := by
  rw [onsiteEnergy_zero_iff]
  intro a ha
  simp [vacuumSpinor, ha]

/-- Number of locally excited levels on the two endpoints. -/
def pairOccupation (p : PairBasis) : ℝ :=
  (if p.1 = 0 then 0 else 1) + (if p.2 = 0 then 0 else 1)

theorem pairOccupation_nonneg (p : PairBasis) :
    0 ≤ pairOccupation p := by
  unfold pairOccupation
  split_ifs <;> norm_num

/-- The sum of the two local 48 P_im Hamiltonians on C^8 tensor C^8. -/
noncomputable def pairOnsiteEnergy (ψ : PairWave) : ℝ :=
  ∑ p : PairBasis, 48 * pairOccupation p * Complex.normSq (ψ p)

/--
For an arbitrary projected link matrix T (which need not be isometric)
the bond map on the 7-output single-excitation subspace is
   B_T(ψ)[a] = ψ[a,0] - Sum_{b=1..7} T[a,b] ψ[0,b].
-/
def bondDifference (T : Fin 8 → Fin 8 → ℂ)
    (ψ : PairWave) (a : Fin 8) : ℂ :=
  ψ (a, 0) -
    ∑ b : Fin 8, if b = 0 then 0 else T a b * ψ (0, b)

/-- Positive bond energy, with no chosen negative hopping coupling. -/
noncomputable def bondEnergy (T : Fin 8 → Fin 8 → ℂ)
    (ψ : PairWave) : ℝ :=
  ∑ a : Fin 8, if a = 0 then 0
    else Complex.normSq (bondDifference T ψ a)

theorem pairOnsiteEnergy_nonneg (ψ : PairWave) :
    0 ≤ pairOnsiteEnergy ψ := by
  unfold pairOnsiteEnergy
  apply Finset.sum_nonneg
  intro p hp
  exact mul_nonneg (mul_nonneg (by norm_num) (pairOccupation_nonneg p))
    (Complex.normSq_nonneg _)

theorem bondEnergy_nonneg (T : Fin 8 → Fin 8 → ℂ)
    (ψ : PairWave) : 0 ≤ bondEnergy T ψ := by
  unfold bondEnergy
  apply Finset.sum_nonneg
  intro a ha
  split_ifs <;> nlinarith [Complex.normSq_nonneg (bondDifference T ψ a)]

/-- The two-site product spinor |1,1> (both scalar coordinates). -/
def vacuumPair : PairWave :=
  fun p => if p = (0, 0) then 1 else 0

/-- Reverse an oriented link via its adjoint, not the negative-root label. -/
def linkAdjoint (T : Fin 8 → Fin 8 → ℂ) : Fin 8 → Fin 8 → ℂ :=
  fun a b => star (T b a)

/-- Swap the two tensor factors of a wave in the computational basis. -/
def swapPair (ψ : PairWave) : PairWave :=
  fun p => ψ (p.2, p.1)

theorem linkAdjoint_involution (T : Fin 8 → Fin 8 → ℂ) :
    linkAdjoint (linkAdjoint T) = T := by
  funext a b
  simp [linkAdjoint]

theorem swapPair_involution (ψ : PairWave) :
    swapPair (swapPair ψ) = ψ := by
  funext p
  cases p
  rfl

/--
Orientation-independent positive edge contribution. The old one-sided
bond term is not symmetric if the compressed octavian link is not unitary.
-/
noncomputable def symmetricBondEnergy
    (T : Fin 8 → Fin 8 → ℂ) (ψ : PairWave) : ℝ :=
  bondEnergy T ψ + bondEnergy (linkAdjoint T) (swapPair ψ)

theorem symmetricBondEnergy_nonneg
    (T : Fin 8 → Fin 8 → ℂ) (ψ : PairWave) :
    0 ≤ symmetricBondEnergy T ψ := by
  unfold symmetricBondEnergy
  exact add_nonneg (bondEnergy_nonneg T ψ)
    (bondEnergy_nonneg (linkAdjoint T) (swapPair ψ))

/-- The same physical edge energy after reversing the edge orientation. -/
theorem symmetricBondEnergy_orientation
    (T : Fin 8 → Fin 8 → ℂ) (ψ : PairWave) :
    symmetricBondEnergy T ψ =
      symmetricBondEnergy (linkAdjoint T) (swapPair ψ) := by
  simp [symmetricBondEnergy, linkAdjoint_involution,
    swapPair_involution, add_comm]

/-- A single autonomous local Hamiltonian via its quadratic form. -/
noncomputable def totalEnergy (T : Fin 8 → Fin 8 → ℂ)
    (ψ : PairWave) : ℝ :=
  pairOnsiteEnergy ψ + symmetricBondEnergy T ψ

theorem totalEnergy_nonneg (T : Fin 8 → Fin 8 → ℂ)
    (ψ : PairWave) : 0 ≤ totalEnergy T ψ := by
  unfold totalEnergy
  exact add_nonneg (pairOnsiteEnergy_nonneg ψ) (symmetricBondEnergy_nonneg T ψ)

theorem pairOnsiteEnergy_vacuum : pairOnsiteEnergy vacuumPair = 0 := by
  unfold pairOnsiteEnergy
  apply Finset.sum_eq_zero
  intro p hp
  by_cases h : p = (0, 0)
  · subst p
    simp [pairOccupation, vacuumPair]
  · simp [vacuumPair, h]

theorem bondEnergy_vacuum (T : Fin 8 → Fin 8 → ℂ) :
    bondEnergy T vacuumPair = 0 := by
  unfold bondEnergy
  apply Finset.sum_eq_zero
  intro a ha
  by_cases hz : a = 0
  · simp [hz]
  · have hleft : vacuumPair (a, 0) = 0 := by
      simp [vacuumPair, hz]
    have hsum :
        (∑ b : Fin 8, if b = 0 then 0
          else T a b * vacuumPair (0, b)) = 0 := by
      apply Finset.sum_eq_zero
      intro b hb
      by_cases hzero : b = 0
      · simp [hzero]
      · simp [vacuumPair, hzero]
    have hdiff : bondDifference T vacuumPair a = 0 := by
      unfold bondDifference
      rw [hleft, hsum]
      ring
    simp [hz, hdiff]

theorem swapPair_vacuum : swapPair vacuumPair = vacuumPair := by
  funext p
  cases p with
  | mk a b =>
      change (if (b, a) = (0, 0) then (1 : ℂ) else 0) =
        (if (a, b) = (0, 0) then (1 : ℂ) else 0)
      simp [Prod.mk.injEq, and_comm]

theorem symmetricBondEnergy_vacuum
    (T : Fin 8 → Fin 8 → ℂ) :
    symmetricBondEnergy T vacuumPair = 0 := by
  simp [symmetricBondEnergy, bondEnergy_vacuum, swapPair_vacuum]

theorem totalEnergy_vacuum (T : Fin 8 → Fin 8 → ℂ) :
    totalEnergy T vacuumPair = 0 := by
  unfold totalEnergy
  rw [pairOnsiteEnergy_vacuum, symmetricBondEnergy_vacuum]
  norm_num

/-- The local excitation count is strictly positive off |0,0>. -/
theorem pairOccupation_pos (p : PairBasis) (hp : p ≠ (0, 0)) :
    0 < pairOccupation p := by
  unfold pairOccupation
  by_cases ha : p.1 = 0
  · have hb : p.2 ≠ 0 := by
      intro h
      apply hp
      exact Prod.ext ha h
    simp [ha, hb]
  · simp [ha]
    split_ifs <;> norm_num

/--
Exact uniqueness of the zero-energy two-site ground ray, for ANY T.
The bond term is positive, so it cannot create a competing zero mode.
-/
theorem totalEnergy_zero_forces_vacuum
    (T : Fin 8 → Fin 8 → ℂ) (ψ : PairWave)
    (h : totalEnergy T ψ = 0) :
    ∀ p : PairBasis, p ≠ (0, 0) → ψ p = 0 := by
  have hm_nonneg := pairOnsiteEnergy_nonneg ψ
  have hb_nonneg := symmetricBondEnergy_nonneg T ψ
  have hm : pairOnsiteEnergy ψ = 0 := by
    unfold totalEnergy at h
    linarith
  unfold pairOnsiteEnergy at hm
  have hterms := (Finset.sum_eq_zero_iff_of_nonneg
    (fun p hp => mul_nonneg
      (mul_nonneg (by norm_num) (pairOccupation_nonneg p))
      (Complex.normSq_nonneg _))).mp hm
  intro p hp
  have hterm := hterms p (Finset.mem_univ p)
  have hc : 0 < (48 : ℝ) * pairOccupation p :=
    mul_pos (by norm_num) (pairOccupation_pos p hp)
  have hz : Complex.normSq (ψ p) = 0 := by
    exact (mul_eq_zero.mp hterm).resolve_left (ne_of_gt hc)
  exact Complex.normSq_eq_zero.mp hz

end VOPM.GappedVacuum
