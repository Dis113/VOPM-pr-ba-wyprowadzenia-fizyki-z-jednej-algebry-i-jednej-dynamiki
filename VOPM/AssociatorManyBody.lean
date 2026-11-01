import VOPM.Associator
import VOPM.E8ManyBody

/-!
# VOPM-010b: an E8-edge quantum interaction from associator energy levels

From the explicit Cayley-Dickson defect A=L_iL_j-L_k, the local positive
Hamiltonian H=A†A has levels 0 (four basis directions) and 4 (four directions).

We make ONE additional, clearly identified dynamical postulate:
  H_xy := H_x ⊗ H_y
on selected neighbor sites x,y, with an evolution interval pi/16 in
units where ħ=1. The joint basis energy is 16 exactly when BOTH local
indices belong to the non-quaternionic sector, otherwise zero. The
resulting phase is -1 or +1, so the gate is an exactly unitary,
conditionally entangling two-site interaction.

The algebra fixes the spectral PROJECTORS and numerical ratio 0:4;
it does not fix the choice H_xy=H_x ⊗ H_y, the interval, the
overall energy scale, or the schedule of neighbor updates.

This is a mathematically consistent, fixed-graph candidate model.
We are not claiming derived electrodynamics, confinement, gravity,
a 3+1-dimensional low-energy phase, or observed physical constants.
-/

namespace VOPM.AssociatorManyBody

open VOPM.ManyBody

/-- Internal basis levels from the explicit positive A†A Hamiltonian. -/
def localEnergy (a : Fin 8) : ℕ :=
  if 4 ≤ a.val then 4 else 0

/--
The additionally postulated product coupling H_x ⊗ H_y:
zero unless both local energies equal four.
-/
def jointEnergy (a b : Fin 8) : ℕ :=
  localEnergy a * localEnergy b

/-- The joint eigenvalue is 16 precisely for two internal-sector states. -/
theorem jointEnergy_sixteen_iff (a b : Fin 8) :
    jointEnergy a b = 16 ↔ 4 ≤ a.val ∧ 4 ≤ b.val := by
  by_cases ha : 4 ≤ a.val <;>
    by_cases hb : 4 ≤ b.val <;>
      simp [jointEnergy, localEnergy, ha, hb]

/--
The discrete time π/16, with ħ=1, gives e^{-i π}=-1 at energy 16
and +1 at energy zero. No numerical physical scale is predicted.
-/
def algebraicPhase {n : ℕ} (x y : Site n) (q : Configuration n) : ℂ :=
  if jointEnergy (q x) (q y) = 16 then -1 else 1

/-- The phase is unimodular at every many-site basis configuration. -/
theorem algebraicPhase_unit {n : ℕ} (x y : Site n)
    (q : Configuration n) :
    star (algebraicPhase x y q) * algebraicPhase x y q = 1 := by
  by_cases h : jointEnergy (q x) (q y) = 16 <;>
    simp [algebraicPhase, h]

/-- Exact two-site Schrödinger evolution for the algebraic Hamiltonian. -/
def interactionTick {n : ℕ} (x y : Site n) (ψ : Wave n) : Wave n :=
  fun q => algebraicPhase x y q * ψ q

/-- The interaction is an involution at the selected lattice interval. -/
theorem interactionTick_involution {n : ℕ}
    (x y : Site n) (ψ : Wave n) :
    interactionTick x y (interactionTick x y ψ) = ψ := by
  funext q
  change algebraicPhase x y q * (algebraicPhase x y q * ψ q) = ψ q
  have hs : algebraicPhase x y q * algebraicPhase x y q = 1 := by
    by_cases h : jointEnergy (q x) (q y) = 16 <;>
      simp [algebraicPhase, h]
  calc
    algebraicPhase x y q * (algebraicPhase x y q * ψ q) =
      (algebraicPhase x y q * algebraicPhase x y q) * ψ q := by ring
    _ = ψ q := by rw [hs]; simp

/-- Entire many-body Hermitian pairing is exactly preserved. -/
theorem interactionTick_pairing {n : ℕ} (x y : Site n)
    (ψ φ : Wave n) :
    pairing (interactionTick x y ψ) (interactionTick x y φ) =
      pairing ψ φ := by
  unfold pairing interactionTick
  apply Finset.sum_congr rfl
  intro q hq
  calc
    star (algebraicPhase x y q * ψ q) * (algebraicPhase x y q * φ q) =
      (star (algebraicPhase x y q) * algebraicPhase x y q) *
        (star (ψ q) * φ q) := by
          rw [star_mul]
          ring
    _ = star (ψ q) * φ q := by rw [algebraicPhase_unit]; simp

/-- Probability is conserved on every finite graph, even at lattice cutoff. -/
theorem interactionTick_bornMass {n : ℕ} (x y : Site n)
    (ψ : Wave n) :
    bornMass (interactionTick x y ψ) = bornMass ψ := by
  unfold bornMass interactionTick
  apply Finset.sum_congr rfl
  intro q hq
  by_cases h : jointEnergy (q x) (q y) = 16 <;>
    simp [algebraicPhase, h]

/--
Strict locality: the update phase depends only on the two endpoints
and their local eight-dimensional basis labels.
-/
theorem algebraicPhase_local {n : ℕ} (x y : Site n)
    (q r : Configuration n)
    (hx : q x = r x) (hy : q y = r y) :
    algebraicPhase x y q = algebraicPhase x y r := by
  simp [algebraicPhase, hx, hy]

/-- Root-labelled interaction: both endpoints are fixed by one E8 direction. -/
def e8Interaction {n : ℕ} (p : VOPM.E8ManyBody.Event n)
    (ψ : Wave n) : Wave n :=
  interactionTick p.1 (p.1 + VOPM.E8Basis.shift n p.2) ψ

/-- One root-labelled event is exactly unitary. -/
theorem e8Interaction_pairing {n : ℕ} (p : VOPM.E8ManyBody.Event n)
    (ψ φ : Wave n) :
    pairing (e8Interaction p ψ) (e8Interaction p φ) = pairing ψ φ := by
  exact interactionTick_pairing p.1 (p.1 + VOPM.E8Basis.shift n p.2) ψ φ

/-- One root-labelled event preserves Born probability. -/
theorem e8Interaction_bornMass {n : ℕ} (p : VOPM.E8ManyBody.Event n)
    (ψ : Wave n) :
    bornMass (e8Interaction p ψ) = bornMass ψ := by
  exact interactionTick_bornMass p.1 (p.1 + VOPM.E8Basis.shift n p.2) ψ

/-- A finite ordered causal schedule of nonassociative-energy interactions. -/
def evolve {n : ℕ} :
    List (VOPM.E8ManyBody.Event n) → Wave n → Wave n
  | [], ψ => ψ
  | p :: ps, ψ => evolve ps (e8Interaction p ψ)

/-- Every finite ordered schedule retains exactly the original pairing. -/
theorem evolve_pairing {n : ℕ}
    (ps : List (VOPM.E8ManyBody.Event n)) (ψ φ : Wave n) :
    pairing (evolve ps ψ) (evolve ps φ) = pairing ψ φ := by
  induction ps generalizing ψ φ with
  | nil => rfl
  | cons p ps ih =>
      change pairing (evolve ps (e8Interaction p ψ))
          (evolve ps (e8Interaction p φ)) = pairing ψ φ
      exact (ih (e8Interaction p ψ) (e8Interaction p φ)).trans
        (e8Interaction_pairing p ψ φ)

end VOPM.AssociatorManyBody
