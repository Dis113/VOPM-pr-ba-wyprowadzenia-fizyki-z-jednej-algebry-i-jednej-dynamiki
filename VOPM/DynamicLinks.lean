import VOPM.ClosedFrames

/-!
# VOPM-016: quantized endpoint frame links and an exact local Gauss law

A rigorous, deliberately MINIMAL toy regularization of DYNAMICAL
links. It is NOT a quantization of the full continuous Lie group G2.

Prior literature:
  Wegner (1971), Z2 lattice gauge systems;
  Kogut--Susskind (1975), Hamiltonian gauge links;
  Elitzur (1975), local gauge redundancy;
  Fradkin--Shenker (1979), phase diagrams with Higgs matter.

Each E8 edge carries TWO qubits (one endpoint G2 frame bit each).
The full two-site Hilbert space has 8 * 8 * 2 * 2 = 256 basis states,
unlike the previous fixed-background C8 tensor C8 = C64.

The nontrivial finite subgroup Q in G2 acts on local octonionic matter:
  Q = diag(1,1,1,1,-1,-1,-1,-1).
At x and y, a gauge operation simultaneously applies Q to matter and
FLIPS the corresponding endpoint link bit. These transformations are
involutive and commute, giving an exact local Z2 x Z2 Gauss group.

The link kinetic term is Gamma * ((I-X_left)+(I-X_right)), where X
flips a link bit; it is not merely a static classical link label.
It can be written as a sum of positive squared differences.

The matter+link quadratic form is the previous VOPM-015
orientation-SYMMETRIC, positive octavian-hopping parent Hamiltonian,
with its link matrix dressed according to both quantum frame bits,
plus the electric term.

The VOPM-specific implementation invariants are kernel checked here;
the standard abstract facts about positive parent Hamiltonians and
their sums are NOT reproved. Exact 256x256 matrix and gauge-covariance
regression checks live in checks/check_dynamic_links.py.

KEY NO-GO: for any m=48 and Gamma>0, the full finite-graph model has
a unique product ground state and a uniform gap >=min(48,2Gamma).
A gapless photon or graviton cannot emerge within this positive-parent
phase. Even at Gamma=0, a zero gap lower bound alone does not establish
a stable Coulomb phase.

A full physical continuous G2 link sector and Gauss law remain open.
-/

namespace VOPM.DynamicLinks

abbrev LinkBits := Bool × Bool
abbrev PairBasis := VOPM.GappedVacuum.PairBasis
abbrev FullBasis := PairBasis × LinkBits
abbrev FullWave := FullBasis → ℂ

/-- Flip the left endpoint of one dynamic link. -/
def flipLeft (b : LinkBits) : LinkBits := (!b.1, b.2)

/-- Flip the right endpoint of one dynamic link. -/
def flipRight (b : LinkBits) : LinkBits := (b.1, !b.2)

theorem flipLeft_twice (b : LinkBits) :
    flipLeft (flipLeft b) = b := by
  cases b with
  | mk l r => cases l <;> cases r <;> rfl

theorem flipRight_twice (b : LinkBits) :
    flipRight (flipRight b) = b := by
  cases b with
  | mk l r => cases l <;> cases r <;> rfl

theorem flips_commute (b : LinkBits) :
    flipRight (flipLeft b) = flipLeft (flipRight b) := by
  cases b with
  | mk l r => cases l <;> cases r <;> rfl

/-- Local G2-subgroup Gauss transformation at the left vertex. -/
def gaussLeft (ψ : FullWave) : FullWave :=
  fun z =>
    VOPM.ClosedFrames.frameSign true z.1.1 *
      ψ (z.1, flipLeft z.2)

/-- Local G2-subgroup Gauss transformation at the right vertex. -/
def gaussRight (ψ : FullWave) : FullWave :=
  fun z =>
    VOPM.ClosedFrames.frameSign true z.1.2 *
      ψ (z.1, flipRight z.2)

/-- A single local gauge transformation has order two. -/
theorem gaussLeft_twice (ψ : FullWave) :
    gaussLeft (gaussLeft ψ) = ψ := by
  funext z
  change VOPM.ClosedFrames.frameSign true z.1.1 *
    (VOPM.ClosedFrames.frameSign true z.1.1 *
      ψ (z.1, flipLeft (flipLeft z.2))) = ψ z
  rw [flipLeft_twice]
  calc
    _ = (VOPM.ClosedFrames.frameSign true z.1.1 *
           VOPM.ClosedFrames.frameSign true z.1.1) * ψ z := by ring
    _ = ψ z := by
      rw [VOPM.ClosedFrames.frameSign_square]
      simp

theorem gaussRight_twice (ψ : FullWave) :
    gaussRight (gaussRight ψ) = ψ := by
  funext z
  change VOPM.ClosedFrames.frameSign true z.1.2 *
    (VOPM.ClosedFrames.frameSign true z.1.2 *
      ψ (z.1, flipRight (flipRight z.2))) = ψ z
  rw [flipRight_twice]
  calc
    _ = (VOPM.ClosedFrames.frameSign true z.1.2 *
           VOPM.ClosedFrames.frameSign true z.1.2) * ψ z := by ring
    _ = ψ z := by
      rw [VOPM.ClosedFrames.frameSign_square]
      simp

/-- Independent local frame changes commute on the full 256-state basis. -/
theorem gauss_commute (ψ : FullWave) :
    gaussLeft (gaussRight ψ) = gaussRight (gaussLeft ψ) := by
  funext z
  change VOPM.ClosedFrames.frameSign true z.1.1 *
    (VOPM.ClosedFrames.frameSign true z.1.2 *
      ψ (z.1, flipRight (flipLeft z.2))) =
    VOPM.ClosedFrames.frameSign true z.1.2 *
    (VOPM.ClosedFrames.frameSign true z.1.1 *
      ψ (z.1, flipLeft (flipRight z.2)))
  rw [flips_commute]
  ring

/-- Unnormalized vacuum ray: scalar-octonionic matter and uniform link bits. -/
def ground : FullWave :=
  fun z => if z.1 = (0, 0) then 1 else 0

/-- Local Gauss transformations preserve the scalar-octonionic vacuum ray. -/
theorem gaussLeft_ground : gaussLeft ground = ground := by
  funext z
  by_cases h : z.1 = (0, 0)
  · have ha : z.1.1 = 0 := congrArg Prod.fst h
    simp [gaussLeft, ground, h, ha,
      VOPM.ClosedFrames.frameSign_vacuum]
  · simp [gaussLeft, ground, h]

theorem gaussRight_ground : gaussRight ground = ground := by
  funext z
  by_cases h : z.1 = (0, 0)
  · have hb : z.1.2 = 0 := congrArg Prod.snd h
    simp [gaussRight, ground, h, hb,
      VOPM.ClosedFrames.frameSign_vacuum]
  · simp [gaussRight, ground, h]

/-- Quantum link shift operator at one endpoint (electric dynamics). -/
def shiftLeft (ψ : FullWave) : FullWave :=
  fun z => ψ (z.1, flipLeft z.2)

def shiftRight (ψ : FullWave) : FullWave :=
  fun z => ψ (z.1, flipRight z.2)

/-- Both link qubit shifts annihilate the uniform link vacuum. -/
theorem shiftLeft_ground : shiftLeft ground = ground := by
  funext z
  rfl

theorem shiftRight_ground : shiftRight ground = ground := by
  funext z
  rfl

/-- Two-link electric kinetic operator (I-X_left)+(I-X_right). -/
def electricOperator (ψ : FullWave) : FullWave :=
  fun z => (2 : ℂ) * ψ z - shiftLeft ψ z - shiftRight ψ z

theorem electricOperator_ground : electricOperator ground = 0 := by
  funext z
  simp [electricOperator, shiftLeft_ground, shiftRight_ground]
  ring

/--
A nonnegative energy is the exact finite-dimensional Hermitian quadratic
form for the link electric operator. The coefficient 1/2 compensates
double counting under an involution.
-/
noncomputable def electricEnergy (ψ : FullWave) : ℝ :=
  (1 / 2 : ℝ) *
    ((∑ z : FullBasis,
       Complex.normSq (ψ z - shiftLeft ψ z)) +
     (∑ z : FullBasis,
       Complex.normSq (ψ z - shiftRight ψ z)))

theorem electricEnergy_nonneg (ψ : FullWave) :
    0 ≤ electricEnergy ψ := by
  unfold electricEnergy
  apply mul_nonneg (by norm_num)
  apply add_nonneg
  · exact Finset.sum_nonneg (fun _ _ => Complex.normSq_nonneg _)
  · exact Finset.sum_nonneg (fun _ _ => Complex.normSq_nonneg _)

theorem electricEnergy_ground : electricEnergy ground = 0 := by
  simp [electricEnergy, shiftLeft_ground, shiftRight_ground]

/-- Coherent link matrix from the 2 dynamical endpoint-frame qubits. -/
def linkMatrix (T : Fin 8 → Fin 8 → ℂ) (b : LinkBits) :
    Fin 8 → Fin 8 → ℂ :=
  VOPM.ClosedFrames.framedLink b.1 b.2 T

/-- The C8 tensor C8 matter state at a fixed link-bit configuration. -/
def matterSlice (ψ : FullWave) (b : LinkBits) :
    VOPM.GappedVacuum.PairWave :=
  fun p => ψ (p, b)

theorem matterSlice_ground (b : LinkBits) :
    matterSlice ground b = VOPM.GappedVacuum.vacuumPair := by
  funext p
  rfl

/--
A single local Hamiltonian quadratic form with ACTUAL quantum link
dynamics; T represents the fixed octavian core, while endpoint bits are
now link quantum degrees of freedom (superposition allowed).
Positive link kinetic coefficient Gamma, and dimensionless matter mass 48.
-/
noncomputable def totalEnergy (Γ : ℝ) (T : Fin 8 → Fin 8 → ℂ)
    (ψ : FullWave) : ℝ :=
  (∑ b : LinkBits,
    VOPM.GappedVacuum.totalEnergy (linkMatrix T b) (matterSlice ψ b))
      + Γ * electricEnergy ψ

theorem totalEnergy_nonneg (Γ : ℝ) (hΓ : 0 ≤ Γ)
    (T : Fin 8 → Fin 8 → ℂ) (ψ : FullWave) :
    0 ≤ totalEnergy Γ T ψ := by
  unfold totalEnergy
  apply add_nonneg
  · exact Finset.sum_nonneg
      (fun b hb => VOPM.GappedVacuum.totalEnergy_nonneg
        (linkMatrix T b) (matterSlice ψ b))
  · exact mul_nonneg hΓ (electricEnergy_nonneg ψ)

theorem totalEnergy_ground (Γ : ℝ)
    (T : Fin 8 → Fin 8 → ℂ) :
    totalEnergy Γ T ground = 0 := by
  simp [totalEnergy, matterSlice_ground,
    VOPM.GappedVacuum.totalEnergy_vacuum, electricEnergy_ground]

end VOPM.DynamicLinks
