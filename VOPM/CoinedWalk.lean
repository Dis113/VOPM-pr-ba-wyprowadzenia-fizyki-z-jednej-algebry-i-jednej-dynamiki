import VOPM.UnitaryWalk

/-!
# VOPM-002b: local unitary mixing before one-edge transport

This is a general *conditional* construction. The local coin is supplied as a
linear equivalence of 8-dimensional complex vector spaces together with a
proof of inner-product preservation. We do not repeat general results
about linear equivalences, finite sums, or quantum walks.

A concrete coin coming from complexified octonion multiplication remains to
be constructed. The directional channel is still an auxiliary edge label,
not an additional fundamental on-site degree of freedom.
-/

namespace VOPM.UnitaryWalk

/-- A reversible complex-linear local transformation on eight amplitudes. -/
abbrev LocalCoin := (Fin 8 → ℂ) ≃ₗ[ℂ] (Fin 8 → ℂ)

/-- Local preservation of the standard complex scalar product. -/
def PreservesCoinPairing (C : LocalCoin) : Prop :=
  ∀ (u v : Fin 8 → ℂ),
    (∑ a : Fin 8, star (C u a) * C v a) =
      ∑ a : Fin 8, star (u a) * v a

/-- Apply a local linear coin to each vertex and direction, without moving. -/
def coinApply {n : ℕ} (C : LocalCoin) (ψ : Wave n) : Wave n :=
  fun i => C (fun a => ψ (i.1, (i.2.1, a))) i.2.2

/--
The global coin is a Hilbert-space isometry when each eight-component local
coin preserves its ordinary complex scalar product.
-/
theorem coinApply_pairing {n : ℕ} (C : LocalCoin)
    (hC : PreservesCoinPairing C) (ψ φ : Wave n) :
    pairing (coinApply C ψ) (coinApply C φ) = pairing ψ φ := by
  unfold pairing coinApply
  simp only [Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro x hx
  apply Finset.sum_congr rfl
  intro d hd
  exact hC (fun a => ψ (x, (d, a))) (fun a => φ (x, (d, a)))

/-- Mix the internal amplitudes locally and then shift one root edge. -/
def coinedTick {n : ℕ} (roots : Fin 240 → Site n) (C : LocalCoin)
    (ψ : Wave n) : Wave n :=
  tick roots (Equiv.refl (Fin 8)) (coinApply C ψ)

/-- The output is a linear combination of only one neighboring site's 8 amplitudes. -/
theorem coinedTick_apply {n : ℕ} (roots : Fin 240 → Site n)
    (C : LocalCoin) (ψ : Wave n)
    (x : Site n) (d : Fin 240) (a : Fin 8) :
    coinedTick roots C ψ (x, (d, a)) =
      C (fun b => ψ (x - roots d, (d, b))) a := by
  rfl

/--
Composition of a local isometric coin and reversible root shift preserves
every complex scalar product. This includes high-frequency modes.
-/
theorem coinedTick_pairing {n : ℕ} (roots : Fin 240 → Site n)
    (C : LocalCoin) (hC : PreservesCoinPairing C) (ψ φ : Wave n) :
    pairing (coinedTick roots C ψ) (coinedTick roots C φ) =
      pairing ψ φ := by
  unfold coinedTick
  exact (pairing_tick roots (Equiv.refl (Fin 8))
    (coinApply C ψ) (coinApply C φ)).trans
      (coinApply_pairing C hC ψ φ)

/-- One tick cannot depend on any state outside the selected input site. -/
theorem coinedTick_local {n : ℕ} (roots : Fin 240 → Site n)
    (C : LocalCoin) (ψ φ : Wave n)
    (x : Site n) (d : Fin 240) (a : Fin 8)
    (h : ∀ b : Fin 8, ψ (x - roots d, (d, b)) =
      φ (x - roots d, (d, b))) :
    coinedTick roots C ψ (x, (d, a)) =
      coinedTick roots C φ (x, (d, a)) := by
  rw [coinedTick_apply, coinedTick_apply]
  have hv : (fun b => ψ (x - roots d, (d, b))) =
      (fun b => φ (x - roots d, (d, b))) := by
    funext b
    exact h b
  rw [hv]

end VOPM.UnitaryWalk
