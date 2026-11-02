import VOPM.OctavianProduct
import VOPM.OctavianBridge

/-!
# VOPM-014: the Clifford-trace blind spot, and a G₂-sensitive witness

The classical G₂ 3-form and Clifford gamma-trace identities are NOT new.
See Baez (2002); Harvey--Lawson (1982); Bryant (1987). They imply that
traces of three octonionic left-action matrices only sample the metric
and the real parts, and cannot in general test preservation of the
octonion multiplication.

The model-specific observations to audit are:
* an E8 root triangle maps linearly to three dependent octavians, so
  the alternating 3-form vanishes identically;
* a particular NON-G2 root-set isometry leaves the entire 13,440
  triangle-character histogram unchanged (exact Python certificate);
* one explicit 4-edge E8 loop admits a NONZERO G2 three-form
  on its independent three-edge prefix.

Lean here checks the Cayley-Dickson sign convention and an explicit
G2-sensitive three-form witness. The full 13,440-triangle trace
comparison is checked independently in exact integer arithmetic by
checks/check_g2_trace_blindspot.py, not claimed as a Lean theorem.

Important physics distinction: a 3-edge prefix and its 3-form are
not gauge-invariant Wilson loops under arbitrary INDEPENDENT local
frame rotations. No gauge symmetry, gravitation or 3+1 emergence
is inferred from these calculations.
-/

namespace VOPM.G2TraceAudit

open VOPM.OctavianProduct

/-- One imaginary-coordinate reflection fixing the scalar unit 1. -/
def flipImagOne (a : Fin 8 → ℤ) : Fin 8 → ℤ :=
  ![a 0, -a 1, a 2, a 3, a 4, a 5, a 6, a 7]

/--
The reflection preserves the Euclidean metric, yet fails to preserve
octonion multiplication; it is NOT in Aut(O)=G2.
-/
theorem flipImagOne_not_multiplicative :
    flipImagOne (mul e1 e2) ≠
      mul (flipImagOne e1) (flipImagOne e2) := by
  intro h
  have h3 := congrArg (fun v : Fin 8 → ℤ => v 3) h
  norm_num [flipImagOne, mul, e1, e2] at h3

/-- Projection of a real octonion onto its seven imaginary coordinates. -/
def imag (a : Fin 8 → ℤ) : Fin 8 → ℤ :=
  ![(0 : ℤ), a 1, a 2, a 3, a 4, a 5, a 6, a 7]

/--
The unnormalized published associative 3-form:
φ(a,b,c)=<Im(a), Im(b) Im(c)>.
With DOUBLE octavian vectors it is eight times the normalized form.
-/
def threeForm (a b c : Fin 8 → ℤ) : ℤ :=
  ∑ i : Fin 8, (imag a i) * (mul (imag b) (imag c) i)

/-- Actual doubled octavian images of the first two E8 root directions. -/
def sampleA : Fin 8 → ℤ :=
  ![(0 : ℤ), 0, -2, 0, 0, 0, 0, 0]

def sampleB : Fin 8 → ℤ :=
  ![(0 : ℤ), 0, 0, 2, 0, 0, 0, 0]

/-- Actual doubled octavian image of root direction #6. -/
def sampleC : Fin 8 → ℤ :=
  ![(0 : ℤ), 1, 1, -1, -1, 0, 0, 0]

/--
Four-step E8 loop directions #0,#1,#6,#7 contain an independent
three-edge prefix. In the chosen octavian convention its G2 form
is -4/8 = -1/2.
-/
theorem fourStepPrefix_form_nonzero : threeForm sampleA sampleB sampleC = -4 := by
  norm_num [threeForm, Fin.sum_univ_succ, imag, mul,
    sampleA, sampleB, sampleC]

/--
The non-G2 imaginary-axis reflection reverses the same G2-sensitive
three-form. This controls the *specific* left-multiplication convention.
-/
theorem fourStepPrefix_form_changes :
    threeForm (flipImagOne sampleA) (flipImagOne sampleB)
      (flipImagOne sampleC) = 4 := by
  norm_num [threeForm, Fin.sum_univ_succ, flipImagOne, imag, mul,
    sampleA, sampleB, sampleC]

end VOPM.G2TraceAudit
