import Mathlib

/-!
# VOPM 001: a conditional no-go theorem for a particular E₈ lattice update

We **reuse** the standard 240-root description of E₈ and the trigonometric
theorems of Mathlib.  In particular, the counts 28 and 128 below are standard
inputs, not novel theorems proved in this module.

The conclusions apply to the *specified* centered, discrete-time linear
update.  They are not a no-go theorem for every possible VOPM dynamics.
-/

namespace VOPM

/--
The axial Fourier symbol for one coordinate direction of the E₈ root lattice.

In the conventional coordinate presentation, 28 roots have axial coordinate
of absolute value 1, 128 have absolute value 1/2, and 84 have coordinate 0.
Only the nonzero groups contribute to this symbol.
-/
noncomputable def axialSymbol (κ : ℝ) : ℝ :=
  28 * (1 - Real.cos κ) + 128 * (1 - Real.cos (κ / 2))

/--
At axial wave number π, the symbol is 184.

This is a new *use* of classical E₈ multiplicities in the proposed update
rule, not a new proof of the multiplicities themselves.
-/
theorem axialSymbol_at_pi : axialSymbol Real.pi = 184 := by
  norm_num [axialSymbol, Real.cos_pi, Real.cos_pi_div_two]

/-- Necessary spectral budget at the π-mode for the centered time update. -/
def stableAtPi (ρ : ℝ) : Prop :=
  ρ * axialSymbol Real.pi ≤ 4

/--
If the discrete dispersion relation admits a real frequency, the
dimensionless coupling must obey the spectral budget.
-/
theorem stableAtPi_of_real_dispersion (ρ ω δ : ℝ)
    (hdisp : 4 * Real.sin (ω * δ / 2) ^ 2 =
      ρ * axialSymbol Real.pi) : stableAtPi ρ := by
  unfold stableAtPi
  rw [← hdisp]
  nlinarith [Real.sin_sq_le_one (ω * δ / 2)]

/--
Matching the infrared speed to the ratio of the shortest edge length and
the update interval forces ρ = 1/15, provided the lattice spacing a ≠ 0.

The equation 30 a² ρ = 2 a² is the dimensionless form of this calibration.
-/
theorem forcedPlanckRatio (a ρ : ℝ) (ha : a ≠ 0)
    (hMatch : 30 * a ^ 2 * ρ = 2 * a ^ 2) :
    ρ = (1 / 15 : ℝ) := by
  have hsq : a ^ 2 ≠ 0 := pow_ne_zero 2 ha
  have hfactor : (30 * ρ - 2) * a ^ 2 = 0 := by
    calc
      (30 * ρ - 2) * a ^ 2 = 30 * a ^ 2 * ρ - 2 * a ^ 2 := by ring
      _ = 0 := by linarith [hMatch]
  have hc : 30 * ρ - 2 = 0 := (mul_eq_zero.mp hfactor).resolve_right hsq
  linarith

/-- The Planck-ratio matching assumption violates the π-mode spectral budget. -/
theorem noStablePlanckAxialMode (a ρ : ℝ) (ha : a ≠ 0)
    (hMatch : 30 * a ^ 2 * ρ = 2 * a ^ 2) :
    ¬ stableAtPi ρ := by
  rw [forcedPlanckRatio a ρ ha hMatch]
  unfold stableAtPi
  rw [axialSymbol_at_pi]
  norm_num

/--
There is no real angular frequency solving the π-mode dispersion relation
under the joint shortest-edge/tick/infrared-speed matching assumptions.

This statement is conditional on the centered-time linear update and the
standard axial root multiplicities.
-/
theorem noRealPlanckAxialFrequency (a ρ ω δ : ℝ) (ha : a ≠ 0)
    (hMatch : 30 * a ^ 2 * ρ = 2 * a ^ 2) :
    ¬ (4 * Real.sin (ω * δ / 2) ^ 2 =
      ρ * axialSymbol Real.pi) := by
  intro hdisp
  exact noStablePlanckAxialMode a ρ ha hMatch
    (stableAtPi_of_real_dispersion ρ ω δ hdisp)

end VOPM
