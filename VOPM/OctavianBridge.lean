import VOPM.E8Basis

/-!
# VOPM-012: a definite isometry from E8 roots to octavian units

Sources: Conway--Smith (2003), On Quaternions and Octonions, chs 9--10;
Koca--Ozdes (1989), Division Algebras with Integral Elements; Dray--Manogue,
Geometry of the Octonions, section on ell-integers.

The 240 norm-one integral octonions and E8 root system are CLASSICAL
mathematics. What is particular to the VOPM repository is the chosen
Gram-preserving coordinate table that maps each existing E8 root label
to an explicit Cayley--Dickson octavian.

IMPORTANT: The map depends on a noncanonical choice of root chamber and
orientation. An E8 lattice isometry is not generally an octonion-algebra
automorphism, nor does it imply a continuous local G2 gauge symmetry.

All octavian vectors are DOUBLED: the encoded integer coordinates w
represent an octonion u=w/2 with squared Euclidean norm 1.

The full 240×240 bijection, multiplication closure, and all 240
left-action matrices are independently tested with EXACT INTEGER
arithmetic by checks/check_octavian_bridge.py. Only the small
simple-root Gram certificate below is currently proved in Lean; do not
confuse the independent regression with a kernel proof for all units.
-/

namespace VOPM.OctavianBridge

set_option maxRecDepth 8192

/--
Eight E8 simple roots, now written as doubled integral octavian units
in the Cayley--Dickson basis (1,i,j,k,l,il,jl,kl).
Their Gram matrix agrees with that of E8Basis.simpleRootsDoubled
after the known metric rescaling by a factor two.
-/
def simpleOctavianRootsDoubled : Vector (Fin 8 → ℤ) 8 :=
  ⟨#[
    ![(0 : ℤ), 0, 0, -1, -1, -1, 1, 0],
    ![(0 : ℤ), 0, 2, 0, 0, 0, 0, 0],
    ![(0 : ℤ), 0, 0, 2, 0, 0, 0, 0],
    ![(0 : ℤ), -1, -1, -1, 1, 0, 0, 0],
    ![(0 : ℤ), 2, 0, 0, 0, 0, 0, 0],
    ![(-1 : ℤ), -1, 0, 0, -1, 1, 0, 0],
    ![(2 : ℤ), 0, 0, 0, 0, 0, 0, 0],
    ![(-1 : ℤ), 0, 0, 0, 0, -1, -1, 1]
  ], by rfl⟩

/-- Primitive E8 coordinates mapped to the chosen octavian root basis. -/
def octavianRootDoubled (d : Fin 240) : Fin 8 → ℤ :=
  fun i => ∑ j : Fin 8,
    VOPM.E8Basis.primitiveRoot d j *
      (simpleOctavianRootsDoubled.get j) i

/-- Standard Euclidean coordinate pairing for integer vectors. -/
def dot (a b : Fin 8 → ℤ) : ℤ :=
  ∑ i : Fin 8, a i * b i

/-- An exact, model-specific certificate of the 8×8 Gram conversion. -/
theorem simple_gram_compatibility :
    ∀ i j : Fin 8,
      dot (VOPM.E8Basis.simpleRootsDoubled.get i)
          (VOPM.E8Basis.simpleRootsDoubled.get j) =
        2 * dot (simpleOctavianRootsDoubled.get i)
                (simpleOctavianRootsDoubled.get j) := by
  decide

/-- A published octavian unit is represented by a doubled integer vector. -/
def octavianUnit (d : Fin 240) : Fin 8 → ℚ :=
  fun i => (octavianRootDoubled d i : ℚ) / 2

end VOPM.OctavianBridge
