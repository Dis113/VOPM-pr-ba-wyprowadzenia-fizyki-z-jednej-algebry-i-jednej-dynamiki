# VOPM-012 — proposed octavian-labelled edge gate: one algebra linked to one lattice

**Status (VOPM-012): E8-to-octavian bridge IMPLEMENTED and independently verified; simple-root Gram certificate added to Lean. The proposed 64x64 interacting transport gate is tested as a prototype in exact arithmetic, but has NOT been formally proved for all 240 labels in Lean nor adopted as the uniquely derived microscopic law.**  
**Primary precedent:** M. Koca, N. Özdes, *Division Algebras with Integral Elements*,
J. Phys. A **22** (1989), 1469–1493, DOI:
https://doi.org/10.1088/0305-4470/22/10/006.

## 1. The missing bridge

Present VOPM-010 uses the E₈ graph only to choose the endpoints of
a controlled-phase gate. Its operator is the same for any graph.
That is not yet an essential coupling between E₈ geometry and the
complexified octonionic algebra.

Koca–Özdes (1989) construct the 240 E₈ roots as integral octonions.
The unit octavians give a known realization of the same 240-point
root geometry. We should therefore **choose and verify one explicit
norm-preserving coordinate map**

\`\`\`math
\Phi:\mathcal R(E_8)\longrightarrow\mathcal U_{\rm oct},
\qquad |\Phi(\alpha)|_{\mathbb O}=1.
\`\`\`

The map depends on a basis/orientation convention. **Do not**
identify the present *Cartesian coordinate vectors* for E₈ with
elements of the Cayley–Dickson multiplication table without
checking that isometry. Not every orthogonal coordinate change
preserves octonionic multiplication.

## 2. The minimal unitary two-site transport map

Let \`u=Phi(alpha)\` be a real octavian unit. On the local space
\`C^8\`, use complex-linear extension of **real** left
multiplication \`L_u\`. Normed-algebra identities imply

\`\`\`math
L_{\bar u}L_u = L_u L_{\bar u} = I,\qquad
L_u^\dagger = L_{\bar u}
\qquad (|u|=1).
\`\`\`

This is **known mathematics**, not a VOPM discovery.

On a *genuine two-site tensor-product Hilbert space*
\`C^8_x tensor C^8_y\`, the proposed transport operator is

\`\`\`math
W_{xy,u} =
(L_u^{(x)}\otimes L_{\bar u}^{(y)})\,{\rm SWAP}_{xy}.
\`\`\`

For vectors \`v,w in C^8\` it acts as:

\`\`\`math
W_{xy,u}(v\otimes w)=(L_u w)\otimes(L_{\bar u} v).
\`\`\`

It is an exact two-site **unitary involution**, without any
continuous tunable parameter. It transports local information
and rotates the internal octonionic amplitudes at once.
For a finite graph, it is strictly local to the selected edge.

**Important:** \`SWAP\` followed by local unitary transformations
does **not** entangle a product state. This transport map alone
does not supply the nontrivial two-body interaction required
for a quantum field theory.

## 3. Combine transport and associative energy as ONE gate

A concrete hypothesis to test (not deduced uniquely from
the abstract octonion algebra):

\`\`\`math
P_{\rm im}=I-P_{\mathbf1},\quad
V_{xy}=I-2P_{\rm im}^{(x)}\otimes P_{\rm im}^{(y)},
\qquad
G_{xy,\alpha}=V_{xy}\,W_{xy,\Phi(\alpha)}.
\`\`\`

\`V\` is an entangling controlled-phase gate on suitable input
superpositions, motivated by the **symmetrized** associator
Hamiltonian \`H_sym=48P_im\` verified in the VOPM-011
integer-matrix benchmark. \`W\` is the orientation-dependent
octavian transport gate. Their product is unitary and
acts on two sites and no others.

The choice of multiplying \`V\` and \`W\`, its order, and
the discrete phase \`-1\` are **new dynamical postulates**.
Despite using one algebra and one graph, we must not call
this a *uniquely derived* law.

### Structure to distinguish in proofs

- **Single-excitation model:** \`C^8_x ⊕ C^8_y\` with
  \`(v_x,v_y) -> (L_u v_y,L_baru v_x)\`.
- **Many-body two-site model:** \`C^8_x ⊗ C^8_y\`
  with the **64×64** map \`G\` above.

These are **not the same Hilbert space**. We must formalize
the second if we claim a microscopic local quantum theory.

## 4. Verification requirements and falsification benchmarks

**Representation certificate**

1. Fix the integral octavian basis and the multiplication
   convention explicitly (Koca–Özdes, Conway–Smith, Baez).
2. Establish a bijection to the 240 entries in \`E8Basis.lean\`,
   verify Euclidean Gram products and norm 1, and check
   multiplication signs independently.
3. Ensure graph endpoints are distinct when claiming
   a two-site gate; the \`N=1\` periodic quotient is degenerate.

**Operator certificate**

4. Prove \`L_u^\dagger=L_{\bar u}\` for **all 240** units,
   not only \`e_1\`; use a known abstract normed-alternative
   algebra lemma if Mathlib supplies it.
5. Prove \`G^\dagger G=I\`, exact edge locality and unitary
   composition for a *fixed, published* edge scheduling rule.
6. Test the \`u=1\`, \`u=e_1\` and an explicitly half-integral
   octavian case. Ensure phase-plus-transport is **not**
   equivalent to mere commuting diagonal gates.

**Physics comparisons**

7. Compare the same rule on E₈ with D₈ and cubic Z⁸,
   adjusting the on-site Hilbert space and propagation
   normalization consistently.
8. Compute the one-excitation and many-body spectra.
   Test whether a linear Weyl/Dirac dispersion appears,
   rather than merely quadratic Schrödinger propagation.
9. Compute dimension indicators. A transport map on
   the eight-dimensional lattice does **not**, by itself,
   select macroscopic 3+1 dimensions.
10. Define at least one dimensionless falsifiable
    consequence with no parameter fitted to its value.

## 5. Symmetry warning

The *real* octonionic algebra has continuous automorphism
group \`G₂\`, which fixes the real unit and rotates the
imaginary septet. However, a discrete integral-octavian
lattice is not generally preserved by **every** element of
this continuous group. Thus octavian edge labels may
reduce the symmetry to a discrete subgroup. This requires
an explicit analysis rather than a claim of automatic
continuous local G₂ gauge invariance.

Likewise the E₈ *root* symmetry does **not** automatically
supply a local E₈ gauge symmetry or an E₈ particle
representation. Distler–Garibaldi representation-theoretic
restrictions apply to certain such claims.

## 6. Published mathematical prerequisites, not VOPM discoveries

- Koca–Özdes (1989), integral octonions and E₈, DOI
  10.1088/0305-4470/22/10/006.
- Baez (2002), *The Octonions*, DOI
  10.1090/S0273-0979-01-00934-X.
- Arrighi–Nesme–Werner (2011), causality / locality of
  quantum cellular automata, DOI
  10.1016/j.jcss.2010.05.004.
- Bannai–Sloane (1981), the E₈ root 7-design, DOI
  10.4153/CJM-1981-038-7.

The **research question** is whether this specific
octavian-labelled, interacting finite quantum circuit
has a physically meaningful low-energy sector that
cannot be reproduced on simpler control graphs.


---

## 7. Implementation progress: exact certificate for 240 edge labels

Files in PR #16:

- \`VOPM/OctavianBridge.lean\` defines eight octavian simple-root
  vectors, the map \`octavianRootDoubled(d)\` from the already published
  primitive E8 root coordinates, and a kernel-checked **8x8 Gram
  compatibility certificate**, subject to successful CI.
- \`checks/check_octavian_bridge.py\` reads both actual Lean basis
  tables and uses **exact integers** (no numerical tolerance).
  It certifies a bijection between **all 240** E8 roots and **all 240**
  units of a specific maximal octavian order, norm one, inverse
  and conjugation, **all 57,600 pairwise inner products**,
  **all 57,600 octavian products**, and the isometry condition
  \`(2 L_u)^T(2 L_u)=4I\` for all 240 labels.
- \`checks/check_octavian_gate.py\` constructs the actual **64x64**
  two-site candidate matrix with exact integer numerators.
  It verifies full unitarity for three representative unit types:
  \`u=1\`, \`u=i\`, and one four-entry half-octavian unit.
  A half-real unit maps a basis product state to 16 nonzero
  computational-basis amplitudes; after the controlled phase, an
  explicit 2x2 amplitude minor is nonzero, proving entanglement
  for that **chosen** input.

### The concrete order and literature

In the Cayley–Dickson basis \`(1,i,j,k,l,il,jl,kl)\`, take:

- 16 single-axis units \`±e_a\`, for \`a=0,...,7\`;
- 224 half-unit vectors with four nonzero entries \`±1/2\`.
  Their supports are 14 quadruples (14 tetrads, each allowing
  16 independent signs). These fourteen supports are the
  \`ell-integer\` maximal order described in the *Geometry
  of the Octonions* (Dray–Manogue) and in the Conway–Smith
  discussion of Cayley integers.

**Critical distinction from the literature:** the naive
\`Kirmse integers\` may share the E8 lattice geometry,
but the naive coordinate realization is **not closed under
octonion multiplication** ("Kirmse's mistake"). We have
deliberately selected the multiplicatively closed **Cayley/
ell-integer order**, and the complete 240x240 integer
product test checks exactly this issue.

These are *classical results*, not VOPM discoveries:
- [Conway–Smith book and Baez's BAMS review](https://math.ucr.edu/home/baez/octonions/conway_smith/index.html)
- [Dray–Manogue, Geometry of the Octonions](https://sites.science.oregonstate.edu/physics/coursewikis/GO/book/go/oint.html)
- [Koca–Özdes, J. Phys. A (1989)](https://doi.org/10.1088/0305-4470/22/10/006).

### Important symmetry obstruction, demonstrated explicitly

A Weyl reflection in the real unit root maps
\`1 -> -1\` but leaves the imaginary unit \`i\` fixed.
Therefore:

\`\`\`math
r_1(1\cdot i)=i,\qquad
r_1(1)\cdot r_1(i)=(-1)\cdot i=-i.
\`\`\`

The reflection preserves the root *set* and Euclidean
metric but NOT octonionic multiplication. Thus:

\`\`\`math
W(E_8)\not\subset \mathrm{Aut}(\mathbb O).
\`\`\`

**Consequences:** E8 Weyl invariance of a graph does not
automatically transfer to a law based on edge octavian
multiplication. The microscopic operator may select
an arithmetic subgroup compatible with the chosen
octavian order. This must be a test, not a hidden assumption.

The reverse root has unit \`u_{-α}=-u_α\`, which is
**generally not** the multiplicative inverse
\`\bar u_α\`. A future orientation-independent hopping
Hamiltonian must define adjoints using conjugation
rather than silently equating them to negative-root labels.

### 64x64 model and its current scientific scope

The tested gate is the **hypothesis**

\`\`\`math
G_{xy,u}=(I-2P_{\mathrm{im}}^{(x)}\otimes
P_{\mathrm{im}}^{(y)})
\left(L_u^{(x)}\otimes L_{\bar u}^{(y)}\right)
\mathrm{SWAP}_{xy}.
\`\`\`

The two factors are individually unitary; only the
controlled phase is entangling on appropriate inputs.
This separates:
- known octonionic norm identities;
- a chosen lattice-to-octavian isometry;
- the **extra dynamical postulate** of controlled phase
  and ordering.

There is still **no** derivation of Dirac/Maxwell
propagation, chiral fermions, 3+1 dimensions,
tetrads or experimental dimensionless constants.
The 240 edge labels remain a discrete choice,
not local E8 or continuous G2 gauge bosons.

## 8. Publication criteria for the bridge

A peer-reviewed mathematical-physics methods paper
would require, at minimum:
1. A rigorous **kernel-checked or published general**
   proof of the 240-unit operator isometries, in
   addition to the independent exhaustive integer
   regression.
2. A deterministic circuit scheduling rule and its
   causal cone on periodic E8 root graphs. For
   \`n=0\` the single-site torus identifies endpoints;
   claims of "two distinct sites" require a separate
   nondegeneracy condition.
3. A comparison against graph controls with the
   **same local 8-level system**, to establish a
   consequence specific to the octavian labelling.
4. A spectral prediction that cannot be reproduced
   by a standard SWAP+controlled-phase circuit.


## 9. More direct peer-reviewed comparisons for a gauge/geometry claim

**Octonionic gauge theory already exists** in other frameworks.
E. K. Loginov, *On a class of gauge theories*, J. Math. Phys.
48 (2007), 073522 (DOI 10.1063/1.2749173), studies gauge
structures associated with nonassociative Moufang loops.

S. Grigorian, *G₂-structures and octonion bundles*, Advances in
Mathematics 308 (2017), 142–207 (DOI
10.1016/j.aim.2016.12.003), gives an octonionic covariant
derivative, relates torsion to an octonionic connection, and
studies an octonionic Dirac operator. These are MUCH stronger
mathematical geometric claims than presently justified by
our discrete 64×64 gate. Do not call an arbitrary product
of left multipliers a physical gauge connection.

The comparison framework is therefore now explicit:

- Define a consistent **local change-of-frame law** for each
  octavian-labelled edge transport operator and decide
  which group/loop actually acts as gauge redundancy.
- Check the compatibility (or obstruction) of that law with
  the associative composition of linear operators and the
  nonassociative multiplication of unit octavians. In general
  \`L_u L_v != L_(uv)\`; the difference is an associator,
  so naive group-valued Wilson-loop formulas cannot
  simply be transplanted.
- Obtain a gauge-covariant plaquette/closed-loop quantity,
  with carefully fixed bracketing and orientation. Only
  then ask whether a continuum Yang–Mills or torsion
  limit is possible.
- Distinguish the **discrete arithmetic automorphism**
  group of the selected integral-octavian order
  (see Koca–Koç–Koca 2007, DOI
  10.1016/j.laa.2006.12.011) from the full continuous
  Lie group G₂=Aut(O).
- Meet QCA locality and homogeneity benchmarks from
  P. Arrighi, *An overview of quantum cellular automata*
  (Natural Computing 18, 2019, DOI
  10.1007/s11047-019-09762-6).
  An externally selected arbitrary event list is **not**
  a derivation of an intrinsic clock or a translationally
  invariant one-step automaton.

This benchmark is **not another physics discovery**; it
prevents existing nonassociative gauge and octonionic
connection theory from being mistakenly re-presented
as original consequences of VOPM.
