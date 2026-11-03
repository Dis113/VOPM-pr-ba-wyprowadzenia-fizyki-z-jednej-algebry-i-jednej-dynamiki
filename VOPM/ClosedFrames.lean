import VOPM.GappedVacuum
import VOPM.LocalGaugeObstruction

/-!
# VOPM-015b: a CLOSED local frame action on an extended link family

Mathematical premise:
  G2 = Aut(O) fixes 1 and acts orthogonally on Im(O).
  Link family {g_L L_u g_R^{-1} : g_L,g_R in G2, |u|=1}
  is invariant under independent local G2 frame changes
  by mere GROUP COMPOSITION. This is existing mathematics.

Here Lean checks the concrete nontrivial subgroup {I,Q} of G2,
where Q acts by (a,b)->(a,-b) in the Cayley-Dickson pair
O=H+H*ell. This Q was already proved multiplicative in
VOPM.LocalGaugeObstruction. Note this selected subgroup is Z2,
not a proof of all continuous G2 identities inside Mathlib.

The enlarged link family is actually CLOSED under the selected
local frame transformations, unlike the old {L_u} family.
The positive B†B bond model from GappedVacuum selects its
real-unit vacuum and permits off-diagonal hopping.

CAUTION: local frames can be pure-gauge book-keeping. We have
not promoted independent link variables to dynamical quantum
fields and have not obtained Yang-Mills curvature.
-/

namespace VOPM.ClosedFrames

open VOPM.OctonionicCoin

/-- The 8x8 real diagonal action of a concrete Z2 subset of G2. -/
def frameSign (f : Bool) (a : Fin 8) : ℂ :=
  if f then (if a.val < 4 then 1 else -1) else 1

theorem frameSign_square (f : Bool) (a : Fin 8) :
    frameSign f a * frameSign f a = 1 := by
  cases f <;> fin_cases a <;>
    norm_num [frameSign]

theorem frameSign_vacuum (f : Bool) :
    frameSign f 0 = 1 := by
  cases f <;> norm_num [frameSign]

/-- Frame composition is the ordinary Z2 group law. -/
theorem frameSign_xor (f g : Bool) (a : Fin 8) :
    frameSign (Bool.xor f g) a =
      frameSign f a * frameSign g a := by
  cases f <;> cases g <;> fin_cases a <;>
    norm_num [frameSign, Bool.xor]

/-- Gauge action on one full local complex octonionic 8-vector. -/
def frameAct (f : Bool) (v : Vec) : Vec :=
  fun a => frameSign f a * v a

theorem frameAct_vacuum (f : Bool) :
    frameAct f VOPM.GappedVacuum.vacuumSpinor =
      VOPM.GappedVacuum.vacuumSpinor := by
  funext a
  by_cases ha : a = 0
  · subst a
    simp [frameAct, frameSign_vacuum, VOPM.GappedVacuum.vacuumSpinor]
  · simp [frameAct, VOPM.GappedVacuum.vacuumSpinor, ha]

/-- The physical on-site projector commutes with frame changes. -/
theorem frameAct_commutes_imaginary (f : Bool) (v : Vec) :
    frameAct f (VOPM.GappedVacuum.imaginaryProjector v) =
      VOPM.GappedVacuum.imaginaryProjector (frameAct f v) := by
  funext a
  by_cases ha : a = 0
  · simp [frameAct, VOPM.GappedVacuum.imaginaryProjector, ha]
  · simp [frameAct, VOPM.GappedVacuum.imaginaryProjector, ha]

/--
A link is no longer constrained to a single left multiplier L_u:
it carries independently chosen endpoint frame factors.
The baseline matrix T_ab may be P_im L_u P_im or the full L_u.
-/
def framedLink (fx fy : Bool) (T : Fin 8 → Fin 8 → ℂ) :
    Fin 8 → Fin 8 → ℂ :=
  fun a b => frameSign fx a * T a b * frameSign fy b

/--
Closure under arbitrary INDEPENDENT transformations at both ends,
within the concrete selected Z2 subgroup of octonionic G2.
-/
theorem framedLink_closed (gx gy fx fy : Bool)
    (T : Fin 8 → Fin 8 → ℂ) (a b : Fin 8) :
    framedLink (Bool.xor gx fx) (Bool.xor gy fy) T a b =
      frameSign gx a * framedLink fx fy T a b * frameSign gy b := by
  simp only [framedLink, frameSign_xor]
  ring

end VOPM.ClosedFrames
