import VOPM.E8Basis

/-!
# VOPM-004: eight complex amplitudes per vertex, with edge-local updates

We replace the auxiliary 240 *on-site* direction channels of VOPM-002 with
exactly 8 complex amplitudes per site.  The 240 roots label *possible
interactions*, not 240 extra internal degrees of freedom.

This is a finite, single-excitation sector (a direct sum over sites), not the
many-body tensor product of site Hilbert spaces, nor an octonionic field
theory.  We reuse standard facts about permutations and reindexed finite
sums from Mathlib instead of reproving them.

One event applies a local unitary coin independently on each site and swaps
one selected internal component across one selected E8-labelled edge.
Thus no remote site enters the causal input of a single event.

For small periodic quotients, the two sites can coincide.  That does not
invalidate the mathematics, but such an event is not spatial propagation.
-/

namespace VOPM.EightComponent

abbrev Site (n : ℕ) := VOPM.UnitaryWalk.Site n

/-- Exactly 8 internal complex amplitudes per spatial vertex. -/
abbrev Index (n : ℕ) := Site n × Fin 8

/-- One-excitation wave amplitudes in the fixed finite volume. -/
abbrev State (n : ℕ) := Index n → ℂ

/-- Hermitian pairing on the single-excitation Hilbert space. -/
noncomputable def pairing {n : ℕ} (ψ φ : State n) : ℂ :=
  ∑ i : Index n, star (ψ i) * φ i

/-- Sum of squared complex norms. -/
noncomputable def bornMass {n : ℕ} (ψ : State n) : ℝ :=
  ∑ i : Index n, Complex.normSq (ψ i)

/--
Exchange the `a` component at site `x` with the `b` component at site
`y`.  This is a *permutation of existing amplitudes*.
-/
noncomputable def bondPerm {n : ℕ}
    (x y : Site n) (a b : Fin 8) : Index n ≃ Index n :=
  Equiv.swap (x, a) (y, b)

/-- Schrödinger-picture basis permutation across one selected bond. -/
noncomputable def bondTick {n : ℕ}
    (x y : Site n) (a b : Fin 8) (ψ : State n) : State n :=
  fun i => ψ (bondPerm x y a b i)

/-- Swapping a bond twice recovers the original field exactly. -/
theorem bondTick_involution {n : ℕ}
    (x y : Site n) (a b : Fin 8) (ψ : State n) :
    bondTick x y a b (bondTick x y a b ψ) = ψ := by
  funext i
  simp [bondTick, bondPerm, Equiv.swap_apply_self]

/-- Only the two selected components exchange places. -/
theorem bondTick_left {n : ℕ}
    (x y : Site n) (a b : Fin 8) (ψ : State n) :
    bondTick x y a b ψ (x, a) = ψ (y, b) := by
  simp [bondTick, bondPerm]

theorem bondTick_right {n : ℕ}
    (x y : Site n) (a b : Fin 8) (ψ : State n) :
    bondTick x y a b ψ (y, b) = ψ (x, a) := by
  simp [bondTick, bondPerm]

/-- Any amplitude outside the two selected components is unchanged. -/
theorem bondTick_off {n : ℕ}
    (x y : Site n) (a b : Fin 8) (ψ : State n) (i : Index n)
    (h₁ : i ≠ (x, a)) (h₂ : i ≠ (y, b)) :
    bondTick x y a b ψ i = ψ i := by
  change ψ (bondPerm x y a b i) = ψ i
  rw [bondPerm, Equiv.swap_apply_of_ne_of_ne h₁ h₂]

/-- Exact inner-product conservation on the finite state space. -/
theorem bondTick_pairing {n : ℕ}
    (x y : Site n) (a b : Fin 8) (ψ φ : State n) :
    pairing (bondTick x y a b ψ) (bondTick x y a b φ) =
      pairing ψ φ := by
  change (∑ i : Index n,
      star (ψ (bondPerm x y a b i)) * φ (bondPerm x y a b i)) =
      ∑ i : Index n, star (ψ i) * φ i
  exact Equiv.sum_comp (bondPerm x y a b)
    (fun i : Index n => star (ψ i) * φ i)

/-- Conservation of total Born probability, including all lattice modes. -/
theorem bondTick_bornMass {n : ℕ}
    (x y : Site n) (a b : Fin 8) (ψ : State n) :
    bornMass (bondTick x y a b ψ) = bornMass ψ := by
  change (∑ i : Index n,
    Complex.normSq (ψ (bondPerm x y a b i))) =
    ∑ i : Index n, Complex.normSq (ψ i)
  exact Equiv.sum_comp (bondPerm x y a b)
    (fun i : Index n => Complex.normSq (ψ i))

/-- Reuse the existing local 8-component linear equivalence from VOPM-002. -/
def onsiteCoin {n : ℕ}
    (C : VOPM.UnitaryWalk.LocalCoin) (ψ : State n) : State n :=
  fun i => C (fun a => ψ (i.1, a)) i.2

/-- Reuse the established coin-isometry assumption; no new operator theorem. -/
theorem onsiteCoin_pairing {n : ℕ}
    (C : VOPM.UnitaryWalk.LocalCoin)
    (hC : VOPM.UnitaryWalk.PreservesCoinPairing C)
    (ψ φ : State n) :
    pairing (onsiteCoin C ψ) (onsiteCoin C φ) = pairing ψ φ := by
  unfold pairing onsiteCoin
  simp only [Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro x hx
  exact hC (fun a => ψ (x, a)) (fun a => φ (x, a))

/--
A single event: local coin, then one selected amplitude exchange along the
edge from x to x + (the d-th published E8 root displacement).
-/
noncomputable def e8Event {n : ℕ}
    (C : VOPM.UnitaryWalk.LocalCoin) (d : Fin 240)
    (x : Site n) (a b : Fin 8) (ψ : State n) : State n :=
  bondTick x (x + VOPM.E8Basis.shift n d) a b (onsiteCoin C ψ)

/-- The two involved sites are connected by a root-labelled directed edge. -/
theorem event_edge {n : ℕ} (d : Fin 240) (x : Site n) :
    VOPM.UnitaryWalk.DirectedNeighbor (VOPM.E8Basis.shift n)
      x (x + VOPM.E8Basis.shift n d) := by
  exact ⟨d, rfl⟩

/--
Every event preserves the total complex scalar product. The coin-isometry
hypothesis is explicit, rather than inferred from the E8 lattice.
-/
theorem e8Event_pairing {n : ℕ}
    (C : VOPM.UnitaryWalk.LocalCoin)
    (hC : VOPM.UnitaryWalk.PreservesCoinPairing C)
    (d : Fin 240) (x : Site n) (a b : Fin 8)
    (ψ φ : State n) :
    pairing (e8Event C d x a b ψ) (e8Event C d x a b φ) =
      pairing ψ φ := by
  unfold e8Event
  calc
    pairing
        (bondTick x (x + VOPM.E8Basis.shift n d) a b (onsiteCoin C ψ))
        (bondTick x (x + VOPM.E8Basis.shift n d) a b (onsiteCoin C φ))
        = pairing (onsiteCoin C ψ) (onsiteCoin C φ) := by
            exact bondTick_pairing x _ a b (onsiteCoin C ψ) (onsiteCoin C φ)
    _ = pairing ψ φ := onsiteCoin_pairing C hC ψ φ

/--
Outside the two updated coordinates the output at site z depends only on
the eight input amplitudes at z; there is no longer-range dependency.
-/
theorem e8Event_offbond {n : ℕ}
    (C : VOPM.UnitaryWalk.LocalCoin) (d : Fin 240)
    (x : Site n) (a b : Fin 8) (ψ : State n)
    (i : Index n)
    (h₁ : i ≠ (x, a))
    (h₂ : i ≠ (x + VOPM.E8Basis.shift n d, b)) :
    e8Event C d x a b ψ i = C (fun k => ψ (i.1, k)) i.2 := by
  unfold e8Event
  rw [bondTick_off x (x + VOPM.E8Basis.shift n d)
    a b (onsiteCoin C ψ) i h₁ h₂]
  rfl

end VOPM.EightComponent
