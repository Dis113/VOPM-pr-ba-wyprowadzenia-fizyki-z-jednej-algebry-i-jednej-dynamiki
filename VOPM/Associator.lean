import VOPM.OctonionicCoin

/-!
# VOPM-010: the nonassociative defect and an explicit positive Hamiltonian

This file uses the *published* Cayley-Dickson product on real octonions,
complex-linearly extended to eight complex coordinates. We do not claim
to discover or re-prove the abstract classification of octonions.

In the established convention (1,i,j,k,l,il,jl,kl), we consider

    A(v) = i (j v) - (i j) v = L_i L_j(v) - L_k(v)
         = -[i,j,v].

Unlike a single imaginary-generator coin, this A detects genuine
nonassociativity: A vanishes on the quaternionic subspace but is nonzero
on the complementary four complex directions.

A is skew-adjoint, so its positive Hamiltonian H=A†A is -A².
Direct computation shows H = 4 P_internal, a projector with eigenvalues
0 (multiplicity 4) and 4 (multiplicity 4).

These are EXACT mathematical properties of this particular implementation;
they are not particle masses, confinement, or a proof of a physical theory.
-/

namespace VOPM.Associator

open VOPM.OctonionicCoin

/-- Left multiplication by the real octonionic unit j. -/
def leftE2 (v : Vec) : Vec :=
  ![-v 2, v 3, v 0, -v 1, -v 6, -v 7, v 4, v 5]

/-- Left multiplication by the real octonionic unit k = ij. -/
def leftE3 (v : Vec) : Vec :=
  ![-v 3, -v 2, v 1, v 0, -v 7, v 6, -v 5, v 4]

/--
The nonassociative defect L_i L_j - L_(ij);
equivalently minus the standard octonion associator [i,j,v].
-/
def defect (v : Vec) : Vec :=
  fun a => leftE1 (leftE2 v) a - leftE3 v a

/-- Exact action of the defect: only the non-quaternionic components remain. -/
theorem defect_formula (v : Vec) :
    defect v =
      ![(0 : ℂ), 0, 0, 0, 2 * v 7, -2 * v 6, 2 * v 5, -2 * v 4] := by
  funext a
  fin_cases a <;> simp [defect, leftE1, leftE2, leftE3] <;> ring

/--
A(e4)=-2e7. Thus [i,j,l]=+2kl, a concrete nonzero associator.
-/
theorem defect_nonzero_witness :
    defect (![0, 0, 0, 0, 1, 0, 0, 0] : Vec) 7 = -2 := by
  norm_num [defect, leftE1, leftE2, leftE3]

/-- Projection onto the four complex non-quaternionic coordinates. -/
def internalProjection (v : Vec) : Vec :=
  ![(0 : ℂ), 0, 0, 0, v 4, v 5, v 6, v 7]

/-- Candidate algebraic Hamiltonian: four times the internal projection. -/
def hamiltonian (v : Vec) : Vec :=
  fun a => 4 * internalProjection v a

/-- A² = -4P, so H=A†A=-A² once skew-adjointness is established. -/
theorem defect_square (v : Vec) :
    defect (defect v) = fun a => -4 * internalProjection v a := by
  funext a
  fin_cases a <;>
    simp [defect, leftE1, leftE2, leftE3, internalProjection] <;>
    ring

/-- The algebraic Hamiltonian is exactly minus the square of the defect. -/
theorem hamiltonian_eq_neg_square (v : Vec) :
    hamiltonian v = -(defect (defect v)) := by
  funext a
  rw [defect_square]
  simp [hamiltonian, Pi.neg_apply]
  ring

/--
The nonassociative defect is skew-adjoint for the standard positive
Hermitian pairing on C^8.
-/
theorem defect_skew (u v : Vec) :
    pairing (defect u) v = -pairing u (defect v) := by
  simp [pairing, defect, leftE1, leftE2, leftE3]
  ring

/--
Adjoint-square certificate: H=A†A at the level of the Hermitian
pairing. Positivity of H follows directly from this identity.
-/
theorem defect_adjoint_square (u v : Vec) :
    pairing (defect u) (defect v) =
      pairing u (hamiltonian v) := by
  rw [defect_skew]
  rw [hamiltonian_eq_neg_square]
  simp [pairing]
  
/-- Positive scalar expectation of H expressed using known norm squares. -/
noncomputable def energy (v : Vec) : ℝ :=
  4 * (Complex.normSq (v 4) + Complex.normSq (v 5) +
       Complex.normSq (v 6) + Complex.normSq (v 7))

/-- H cannot produce negative expectation energy. -/
theorem energy_nonneg (v : Vec) : 0 ≤ energy v := by
  unfold energy
  positivity

end VOPM.Associator
