import VOPM.OctavianBridge

/-!
# Octavian Cayley--Dickson product and a symmetry obstruction

The eight-coordinate product here is the CLASSICAL Cayley--Dickson
octonion product, not a new discovery. It is represented over integers
to keep exact proof certificates.

The specific E8 reflection across the real unit octavian fixes i but
sends 1 to -1. It is an isometry of the E8 root set, yet it does not
preserve the octonionic multiplication: r(1*i) != r(1)*r(i).

This distinction is essential: an E8 Weyl symmetry of the graph does
NOT imply an octonion algebra automorphism or a local gauge symmetry.
-/

namespace VOPM.OctavianProduct

/-- Exact octonion multiplication on eight integral coefficients. -/
def mul (a b : Fin 8 → ℤ) : Fin 8 → ℤ :=
  ![
    a 0*b 0 - a 1*b 1 - a 2*b 2 - a 3*b 3 -
      a 4*b 4 - a 5*b 5 - a 6*b 6 - a 7*b 7,
    a 0*b 1 + a 1*b 0 + a 2*b 3 - a 3*b 2 +
      a 4*b 5 - a 5*b 4 - a 6*b 7 + a 7*b 6,
    a 0*b 2 - a 1*b 3 + a 2*b 0 + a 3*b 1 +
      a 4*b 6 + a 5*b 7 - a 6*b 4 - a 7*b 5,
    a 0*b 3 + a 1*b 2 - a 2*b 1 + a 3*b 0 +
      a 4*b 7 - a 5*b 6 + a 6*b 5 - a 7*b 4,
    a 0*b 4 - a 1*b 5 - a 2*b 6 - a 3*b 7 +
      a 4*b 0 + a 5*b 1 + a 6*b 2 + a 7*b 3,
    a 0*b 5 + a 1*b 4 - a 2*b 7 + a 3*b 6 -
      a 4*b 1 + a 5*b 0 - a 6*b 3 + a 7*b 2,
    a 0*b 6 + a 1*b 7 + a 2*b 4 - a 3*b 5 -
      a 4*b 2 + a 5*b 3 + a 6*b 0 - a 7*b 1,
    a 0*b 7 - a 1*b 6 + a 2*b 5 + a 3*b 4 -
      a 4*b 3 - a 5*b 2 + a 6*b 1 + a 7*b 0
  ]

def one : Fin 8 → ℤ :=
  ![(1 : ℤ), 0, 0, 0, 0, 0, 0, 0]

def e1 : Fin 8 → ℤ :=
  ![(0 : ℤ), 1, 0, 0, 0, 0, 0, 0]

def e2 : Fin 8 → ℤ :=
  ![(0 : ℤ), 0, 1, 0, 0, 0, 0, 0]

def e4 : Fin 8 → ℤ :=
  ![(0 : ℤ), 0, 0, 0, 1, 0, 0, 0]

def e7 : Fin 8 → ℤ :=
  ![(0 : ℤ), 0, 0, 0, 0, 0, 0, 1]

/-- Reflection in the real unit root, a coordinate sign flip. -/
def reflectOne (a : Fin 8 → ℤ) : Fin 8 → ℤ :=
  ![-a 0, a 1, a 2, a 3, a 4, a 5, a 6, a 7]

/--
Concrete counterexample: the E8 reflection across the unit 1
does not preserve Cayley--Dickson multiplication.
-/
theorem e8_reflection_not_octonion_automorphism :
    reflectOne (mul one e1) ≠ mul (reflectOne one) (reflectOne e1) := by
  intro h
  have h1 := congrArg (fun v : Fin 8 → ℤ => v 1) h
  norm_num [reflectOne, mul, one, e1] at h1

/-- Nonassociativity is present in the same coordinate convention. -/
theorem known_associator_witness :
    mul (mul e1 e2) e4 - mul e1 (mul e2 e4) =
      fun i => 2 * e7 i := by
  funext i
  fin_cases i <;> norm_num [mul, e1, e2, e4, e7]

end VOPM.OctavianProduct
