import VOPM.OctavianBridge

/-!
# VOPM-016c: genuinely quantum 240-level octavian CORE on each edge

The preceding DynamicLinks.lean quantized ONLY two endpoint frame bits.
Here the integral-octavian unit u on the edge is itself quantized:
  H_core = C^{240},
with one basis state for each published E8 unit octavian.

The natural G2-respecting (on the continuous algebra) selection of
126 pure imaginary norm-one units w gives right-multiplication moves
  u -> u*w.
Because norm-one octavians form a finite Moufang loop, each fixed
right multiplication is a permutation, and w^{-1}=-w belongs to
the same selected set. The resulting adjacency operator is Hermitian.

A CLASSICAL octonionic inverse property and
  Re(conj(u)*v) = <u,v>
imply:
  v=u*w with Re(w)=0  IFF  <u,v>=0.
Thus the ostensibly nonassociative quantum-core adjacency is JUST
the E8 root ORTHOGONALITY graph. This is a MODEL-SPECIFIC NO-GO:
the most symmetric naive one-link walk forgets nonassociativity.
We do not re-prove the known division-algebra inverse property.

The exact adjacency spectrum and intersection-number certificate are
reconstructed from the actual Lean root tables by
checks/check_quantum_octavian_core.py:
    A: 126^1, 6^84, 0^120, (-18)^35,
    K=126I-A: 0^1, 120^84, 126^120, 144^35.
The all-240 generator walk is even more trivial: complete-graph mixing.

Lean verifies here the concrete definitions, adjacency SYMMETRY,
nonnegative kinetic quadratic form, and uniform link vacuum. The
240-row characteristic polynomial is an exact Python certificate
and the standard E8 association scheme, not a kernel Lean theorem.

A kinetic coefficient tau>0 makes the uniform octavian link wave
a unique gapped ground with gap >= 120*tau.
This is a new auxiliary 240-level link Hilbert space; it does NOT
preserve the slogan "only sixteen real DOF at every node" as a
complete microscopic ontology. Extra link DOFs must be derived
or eliminated in a final formulation.
-/

namespace VOPM.QuantumOctavianCore

set_option maxRecDepth 8192

abbrev CoreWave := Fin 240 → ℂ

/-- Euclidean pairing of two doubled integral-octavian unit vectors. -/
def doubledDot (u v : Fin 240) : ℤ :=
  VOPM.OctavianBridge.dot
    (VOPM.OctavianBridge.octavianRootDoubled u)
    (VOPM.OctavianBridge.octavianRootDoubled v)

/-- Two unit octavians are adjacent in the exact pure-imaginary walk. -/
def orthogonal (u v : Fin 240) : Prop :=
  doubledDot u v = 0

theorem doubledDot_symm (u v : Fin 240) :
    doubledDot u v = doubledDot v u := by
  unfold doubledDot VOPM.OctavianBridge.dot
  apply Finset.sum_congr rfl
  intro i hi
  ring

theorem orthogonal_symm (u v : Fin 240) :
    orthogonal u v ↔ orthogonal v u := by
  unfold orthogonal
  rw [doubledDot_symm]

/-- The constant wave on all 240 octavian units. -/
def uniformCore (z : ℂ) : CoreWave := fun _ => z

/--
The positive quadratic form of the octavian-core quantum walk:
<psi,K psi> = (1/2) sum_{u~v} |psi(u)-psi(v)|².
This is the usual graph Laplacian (already known mathematics).
-/
noncomputable def coreEnergy (ψ : CoreWave) : ℝ :=
  (1 / 2 : ℝ) *
    ∑ u : Fin 240, ∑ v : Fin 240,
      if orthogonal u v
      then Complex.normSq (ψ u - ψ v) else 0

theorem coreEnergy_nonneg (ψ : CoreWave) :
    0 ≤ coreEnergy ψ := by
  unfold coreEnergy
  apply mul_nonneg (by norm_num)
  apply Finset.sum_nonneg
  intro u hu
  apply Finset.sum_nonneg
  intro v hv
  split_ifs
  · exact Complex.normSq_nonneg _
  · exact le_refl 0

theorem coreEnergy_uniform (z : ℂ) :
    coreEnergy (uniformCore z) = 0 := by
  simp [coreEnergy, uniformCore]

end VOPM.QuantumOctavianCore
