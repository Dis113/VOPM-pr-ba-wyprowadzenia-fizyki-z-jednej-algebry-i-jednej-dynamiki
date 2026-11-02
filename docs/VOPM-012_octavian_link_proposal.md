# VOPM-012 — proposed octavian-labelled edge gate: one algebra linked to one lattice

**Status: technical proposal, NOT yet implemented or verified in Lean.**  
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
