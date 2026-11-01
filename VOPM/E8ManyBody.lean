import VOPM.ManyBody
import VOPM.E8Basis

/-!
# VOPM-008: a finite many-body E8 causal schedule

Every vertex has an eight-state local quantum system and the global Hilbert
space is the full finite many-body configuration space of VOPM.ManyBody.

An event selects exactly one site and one of the 240 published E8 root
directions (in the *primitive root basis*). The chosen two-site gate is the
standard controlled phase from VOPM.ManyBody, not a derived octonionic
interaction. This concrete finite update is compatible with unitary quantum
evolution for **any finite ordered schedule of events**.

Proving that a composition of unitary maps remains unitary is known
mathematics. The present theorems only check this specific, E8-indexed
implementation; no universal quantum-gravity result is claimed.

The graph and its number of sites are fixed. Quantum amplitudes, not the
underlying E8 lattice geometry, are updated.
-/

namespace VOPM.E8ManyBody

abbrev Site (n : ℕ) := VOPM.UnitaryWalk.Site n

/-- One site and one of the 240 allowed root directions. -/
abbrev Event (n : ℕ) := Site n × Fin 240

/-- A single root-indexed, two-site gate on the many-body Hilbert space. -/
def event {n : ℕ} (p : Event n) (ψ : VOPM.ManyBody.Wave n) :
    VOPM.ManyBody.Wave n :=
  VOPM.ManyBody.phaseTick p.1 (p.1 + VOPM.E8Basis.shift n p.2) ψ

/-- The chosen pair is an actual nearest-neighbor edge in the E8 quotient. -/
theorem event_neighbor {n : ℕ} (p : Event n) :
    VOPM.UnitaryWalk.DirectedNeighbor (VOPM.E8Basis.shift n)
      p.1 (p.1 + VOPM.E8Basis.shift n p.2) :=
  VOPM.E8Basis.neighbor_step n p.1 p.2

/-- The many-body root event is an involution. -/
theorem event_involution {n : ℕ} (p : Event n)
    (ψ : VOPM.ManyBody.Wave n) :
    event p (event p ψ) = ψ := by
  exact VOPM.ManyBody.phaseTick_involution p.1
    (p.1 + VOPM.E8Basis.shift n p.2) ψ

/-- One E8 root event preserves the complete many-body inner product. -/
theorem event_pairing {n : ℕ} (p : Event n)
    (ψ φ : VOPM.ManyBody.Wave n) :
    VOPM.ManyBody.pairing (event p ψ) (event p φ) =
      VOPM.ManyBody.pairing ψ φ := by
  exact VOPM.ManyBody.phaseTick_pairing p.1
    (p.1 + VOPM.E8Basis.shift n p.2) ψ φ

/-- One E8 root event preserves total Born probability. -/
theorem event_bornMass {n : ℕ} (p : Event n)
    (ψ : VOPM.ManyBody.Wave n) :
    VOPM.ManyBody.bornMass (event p ψ) =
      VOPM.ManyBody.bornMass ψ := by
  exact VOPM.ManyBody.phaseTick_bornMass p.1
    (p.1 + VOPM.E8Basis.shift n p.2) ψ

/--
A concrete causal order is a finite list of local two-site events.
No preferred simultaneous-clock foliation has been assumed here.
-/
def evolve {n : ℕ} : List (Event n) → VOPM.ManyBody.Wave n →
    VOPM.ManyBody.Wave n
  | [], ψ => ψ
  | p :: ps, ψ => evolve ps (event p ψ)

/-- The complete finite schedule preserves all complex inner products. -/
theorem evolve_pairing {n : ℕ} (ps : List (Event n))
    (ψ φ : VOPM.ManyBody.Wave n) :
    VOPM.ManyBody.pairing (evolve ps ψ) (evolve ps φ) =
      VOPM.ManyBody.pairing ψ φ := by
  induction ps generalizing ψ φ with
  | nil => rfl
  | cons p ps ih =>
      change VOPM.ManyBody.pairing
        (evolve ps (event p ψ)) (evolve ps (event p φ)) =
          VOPM.ManyBody.pairing ψ φ
      exact (ih (event p ψ) (event p φ)).trans
        (event_pairing p ψ φ)

/-- The complete finite schedule also conserves Born probability. -/
theorem evolve_bornMass {n : ℕ} (ps : List (Event n))
    (ψ : VOPM.ManyBody.Wave n) :
    VOPM.ManyBody.bornMass (evolve ps ψ) =
      VOPM.ManyBody.bornMass ψ := by
  induction ps generalizing ψ with
  | nil => rfl
  | cons p ps ih =>
      change VOPM.ManyBody.bornMass (evolve ps (event p ψ)) =
        VOPM.ManyBody.bornMass ψ
      exact (ih (event p ψ)).trans (event_bornMass p ψ)

end VOPM.E8ManyBody
