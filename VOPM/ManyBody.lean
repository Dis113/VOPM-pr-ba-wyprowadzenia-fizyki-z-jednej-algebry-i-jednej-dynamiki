import VOPM.EightComponent

/-!
# VOPM-006: finite many-site Hilbert space with 8 local basis states

The preceding VOPM-004 model describes only a *single excitation*.
Here a basis configuration is a function Site -> Fin 8; thus the full wave
function has one complex amplitude per global configuration, corresponding
to the tensor-product Hilbert space of eight-dimensional local factors.

We use a conventional two-site controlled-phase gate, NOT a derived
octonionic interaction. Its standard abstract unitarity is not novel.
The new check is that the *concrete local gate on this finite VOPM
configuration space* preserves all inner products and only probes a pair
of vertices, with no additional local basis states.

This is still a fixed graph, without creation of sites, tetrads, QCD,
or a derivation of the observed effective 3+1 dimensions.
-/

namespace VOPM.ManyBody

abbrev Site (n : ℕ) := VOPM.UnitaryWalk.Site n

/-- Exactly eight orthogonal basis labels on each local site. -/
abbrev LocalBasis := Fin 8

/-- Tensor-product computational basis configurations. -/
abbrev Configuration (n : ℕ) := Site n → LocalBasis

/-- Many-site wave functions on the full configuration basis. -/
abbrev Wave (n : ℕ) := Configuration n → ℂ

/-- Complex Hilbert pairing in the computational basis. -/
noncomputable def pairing {n : ℕ} (ψ φ : Wave n) : ℂ :=
  ∑ q : Configuration n, star (ψ q) * φ q

/-- Total Born probability of the complete many-site state. -/
noncomputable def bornMass {n : ℕ} (ψ : Wave n) : ℝ :=
  ∑ q : Configuration n, Complex.normSq (ψ q)

/--
A two-site controlled minus sign for the basis event |0,0⟩.
For x = y this becomes a local phase, not a two-site interaction.
-/
def edgePhase {n : ℕ} (x y : Site n) (q : Configuration n) : ℂ :=
  if q x = 0 ∧ q y = 0 then -1 else 1

/-- Exact two-site controlled-phase Schrödinger update. -/
def phaseTick {n : ℕ} (x y : Site n) (ψ : Wave n) : Wave n :=
  fun q => edgePhase x y q * ψ q

/-- The diagonal phase is its own inverse. -/
theorem edgePhase_sq {n : ℕ} (x y : Site n)
    (q : Configuration n) : edgePhase x y q * edgePhase x y q = 1 := by
  by_cases h : q x = 0 ∧ q y = 0 <;> simp [edgePhase, h]

/-- The diagonal phase has modulus one. -/
theorem edgePhase_unit {n : ℕ} (x y : Site n)
    (q : Configuration n) : star (edgePhase x y q) * edgePhase x y q = 1 := by
  by_cases h : q x = 0 ∧ q y = 0 <;> simp [edgePhase, h]

/-- The full many-body gate is an involution, without a continuum limit. -/
theorem phaseTick_involution {n : ℕ} (x y : Site n) (ψ : Wave n) :
    phaseTick x y (phaseTick x y ψ) = ψ := by
  funext q
  change edgePhase x y q * (edgePhase x y q * ψ q) = ψ q
  calc
    edgePhase x y q * (edgePhase x y q * ψ q) =
      (edgePhase x y q * edgePhase x y q) * ψ q := by ring
    _ = ψ q := by rw [edgePhase_sq]; simp

/--
Exact quantum unitarity in the many-body Hilbert space: all inner products
are preserved under the local controlled phase.
-/
theorem phaseTick_pairing {n : ℕ} (x y : Site n)
    (ψ φ : Wave n) :
    pairing (phaseTick x y ψ) (phaseTick x y φ) =
      pairing ψ φ := by
  unfold pairing phaseTick
  apply Finset.sum_congr rfl
  intro q hq
  calc
    star (edgePhase x y q * ψ q) * (edgePhase x y q * φ q) =
      (star (edgePhase x y q) * edgePhase x y q) *
        (star (ψ q) * φ q) := by
          rw [star_mul]
          ring
    _ = star (ψ q) * φ q := by rw [edgePhase_unit]; simp

/-- Exact Born probability conservation for every many-site state. -/
theorem phaseTick_bornMass {n : ℕ} (x y : Site n) (ψ : Wave n) :
    bornMass (phaseTick x y ψ) = bornMass ψ := by
  unfold bornMass phaseTick
  apply Finset.sum_congr rfl
  intro q hq
  by_cases h : q x = 0 ∧ q y = 0 <;> simp [edgePhase, h]

/--
If two basis configurations agree on the two selected vertices, they
receive the same local phase. No other vertex enters the local rule.
-/
theorem edgePhase_local {n : ℕ} (x y : Site n)
    (q r : Configuration n) (hx : q x = r x) (hy : q y = r y) :
    edgePhase x y q = edgePhase x y r := by
  simp [edgePhase, hx, hy]

end VOPM.ManyBody
