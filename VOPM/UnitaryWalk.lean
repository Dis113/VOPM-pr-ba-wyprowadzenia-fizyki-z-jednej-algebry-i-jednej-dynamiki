import Mathlib

/-!
# VOPM-002: reversible one-edge quantum propagation

This module instantiates an established construction (a discrete-time quantum
walk) on a *finite 8-dimensional torus* with 240 named displacement channels
and eight complex internal amplitudes (16 real coordinates per local channel).

The vector table `roots` is a PARAMETER. Its interpretation as the rescaled
E₈ root system is a separate mathematical input, not proved here.

The model here is a free, single-particle propagation sector. It does NOT yet
implement octonionic multiplication, particle interactions, a dynamical graph,
the emergence of 3+1 spacetime, Maxwell's equations, or TEGR.

The proofs use existing `Equiv.sum_comp` and complex-number results rather
than reconstructing established general results about unitary permutations.
-/

namespace VOPM.UnitaryWalk

/-- Periodic 8D positions, with a positive modulus to ensure finiteness. -/
abbrev Site (n : ℕ) := Fin 8 → ZMod (n + 1)

/-- Root-direction channel and internal 8-component complex state index. -/
abbrev Label := Fin 240 × Fin 8

/-- Basis indices for a finite-volume one-particle sector. -/
abbrev Mode (n : ℕ) := Site n × Label

/-- Complex amplitudes; 8 complex internal coordinates per direction. -/
abbrev Wave (n : ℕ) := Mode n → ℂ

/--
An exact permutation of quantum-walk basis indices:
one root displacement per tick and a local permutation of internal labels.

The root table and internal permutation are parameters. No nontrivial theorem
about E₈ roots or octonions is presumed here.
-/
def flowEquiv {n : ℕ} (roots : Fin 240 → Site n)
    (rot : Fin 8 ≃ Fin 8) : Mode n ≃ Mode n where
  toFun i := (i.1 + roots i.2.1, (i.2.1, rot i.2.2))
  invFun i := (i.1 - roots i.2.1, (i.2.1, rot.symm i.2.2))
  left_inv := by
    rintro ⟨x, ⟨d, a⟩⟩
    simp
  right_inv := by
    rintro ⟨x, ⟨d, a⟩⟩
    simp

/-- Schrödinger-picture update: the preimage is moved along one edge. -/
def tick {n : ℕ} (roots : Fin 240 → Site n) (rot : Fin 8 ≃ Fin 8)
    (ψ : Wave n) : Wave n :=
  fun i => ψ ((flowEquiv roots rot).symm i)

/-- Explicit reverse update. -/
def untick {n : ℕ} (roots : Fin 240 → Site n) (rot : Fin 8 ≃ Fin 8)
    (ψ : Wave n) : Wave n :=
  fun i => ψ (flowEquiv roots rot i)

/-- Pointwise causal rule: the new amplitude uses one adjacent site. -/
theorem tick_apply {n : ℕ} (roots : Fin 240 → Site n) (rot : Fin 8 ≃ Fin 8)
    (ψ : Wave n) (x : Site n) (d : Fin 240) (a : Fin 8) :
    tick roots rot ψ (x, (d, a)) =
      ψ (x - roots d, (d, rot.symm a)) := by
  rfl

/-- No information about more distant sites is needed for this output. -/
theorem tick_local {n : ℕ} (roots : Fin 240 → Site n) (rot : Fin 8 ≃ Fin 8)
    (ψ φ : Wave n) (x : Site n) (d : Fin 240) (a : Fin 8)
    (h : ψ (x - roots d, (d, rot.symm a)) =
      φ (x - roots d, (d, rot.symm a))) :
    tick roots rot ψ (x, (d, a)) =
      tick roots rot φ (x, (d, a)) := by
  simpa only [tick_apply] using h

/-- One forward tick followed by its inverse recovers the original state. -/
theorem untick_tick {n : ℕ} (roots : Fin 240 → Site n) (rot : Fin 8 ≃ Fin 8)
    (ψ : Wave n) : untick roots rot (tick roots rot ψ) = ψ := by
  funext i
  simp [untick, tick]

/-- The inverse followed by a forward tick also recovers the original state. -/
theorem tick_untick {n : ℕ} (roots : Fin 240 → Site n) (rot : Fin 8 ≃ Fin 8)
    (ψ : Wave n) : tick roots rot (untick roots rot ψ) = ψ := by
  funext i
  simp [untick, tick]

/-- Total Born probability on the finite-volume lattice. -/
noncomputable def probability {n : ℕ} (ψ : Wave n) : ℝ :=
  ∑ i : Mode n, Complex.normSq (ψ i)

/--
The update preserves the total Born probability EXACTLY, including modes
at the lattice cutoff; no small-wave-number or continuum approximation.
-/
theorem probability_tick {n : ℕ} (roots : Fin 240 → Site n)
    (rot : Fin 8 ≃ Fin 8) (ψ : Wave n) :
    probability (tick roots rot ψ) = probability ψ := by
  change (∑ i : Mode n, Complex.normSq
    (ψ ((flowEquiv roots rot).symm i))) =
    ∑ i : Mode n, Complex.normSq (ψ i)
  exact Equiv.sum_comp (flowEquiv roots rot).symm _

/-- The ordinary complex inner product for the finite configuration space. -/
noncomputable def pairing {n : ℕ} (ψ φ : Wave n) : ℂ :=
  ∑ i : Mode n, Complex.conj (ψ i) * φ i

/--
Stronger than norm preservation: all complex inner products are preserved.
The one-step map is therefore a unitary basis permutation.
-/
theorem pairing_tick {n : ℕ} (roots : Fin 240 → Site n)
    (rot : Fin 8 ≃ Fin 8) (ψ φ : Wave n) :
    pairing (tick roots rot ψ) (tick roots rot φ) = pairing ψ φ := by
  change (∑ i : Mode n, Complex.conj
    (ψ ((flowEquiv roots rot).symm i)) *
    φ ((flowEquiv roots rot).symm i)) =
    ∑ i : Mode n, Complex.conj (ψ i) * φ i
  exact Equiv.sum_comp (flowEquiv roots rot).symm _

/-- A directed neighboring edge is one of the 240 prescribed displacements. -/
def DirectedNeighbor {n : ℕ} (roots : Fin 240 → Site n)
    (y x : Site n) : Prop :=
  ∃ d : Fin 240, x = y + roots d

/-- The input on which one output depends is one directed edge away. -/
theorem tick_source_is_neighbor {n : ℕ} (roots : Fin 240 → Site n)
    (x : Site n) (d : Fin 240) :
    DirectedNeighbor roots (x - roots d) x := by
  refine ⟨d, ?_⟩
  simp

end VOPM.UnitaryWalk
