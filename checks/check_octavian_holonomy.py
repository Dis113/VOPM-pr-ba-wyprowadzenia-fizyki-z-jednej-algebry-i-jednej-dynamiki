#!/usr/bin/env python3
"""VOPM-013: exact octavian transport word and E8 triangle loop diagnostics.

Non-original mathematics: Cayley-Dickson multiplication, Moufang loops,
octonionic associators, Clifford(0,7), Wilson-loop operator traces.
Literature: Baez (2002), Grigorian (2021), Kleinschmidt et al. (2012).

New contribution here: an exact, reproducible diagnostic for the SPECIFIC
VOPM E8-to-octavian labeling and its need for an additional orientation
and embedding convention. The numerical distributions are not universal
laws of the E8 root system and are NOT physical curvature predictions.

Link direction is implemented carefully: U_{-alpha}=U_alpha^T=U_alpha^-1.
In general the octavian label u_{-alpha}=-u_alpha is NOT the inverse.
We enumerate genuine closed root triangles alpha+beta+gamma=0 on the
unquotiented E8 lattice, at one translation-equivalent base vertex.
For each ordered triple we compute the normalized trace of the 8x8
operator product U_gamma U_beta U_alpha in EXACT INTEGER arithmetic.

DO NOT confuse the unit-octonion word k*(j*i)=1 with a spatial E8
triangle; these are separate diagnostics with different closure notions.
"""
from collections import Counter
from check_e8_basis import cartesian_roots, lean_rows
from check_octavian_bridge import (
    ROOT, mapped_octavians, left_doubled_matrix,
    matrix_mul, matrix_transpose, conjugate_doubled,
)
from check_associator import octmul


def basis(i):
    return tuple(int(i == j) for j in range(8))


def doubled_basis(i):
    return tuple(2 * int(i == j) for j in range(8))


def trace_triple(left, middle, right):
    """trace(left @ middle @ right) from exact integer 8x8 matrices."""
    return sum(
        left[i][j] * middle[j][k] * right[k][i]
        for i in range(8) for j in range(8) for k in range(8)
    )


def canonical_positive(root):
    """Noncanonical but reproducible orientation of every root +/- pair."""
    return next(x for x in root if x != 0) > 0


def oriented_links(roots, mapped):
    """For -alpha use the ADJOINT link on +alpha, not L_{-u}."""
    root_idx = {r: i for i, r in enumerate(roots)}
    out = []
    for root in roots:
        pos = root if canonical_positive(root) else tuple(-a for a in root)
        positive_u = mapped[root_idx[pos]]
        T = left_doubled_matrix(positive_u)
        out.append(T if canonical_positive(root) else matrix_transpose(T))
    for root, matrix in zip(roots, out):
        neg_i = root_idx[tuple(-v for v in root)]
        assert out[neg_i] == matrix_transpose(matrix)
    return out


def triangle_traces(roots, links):
    idx = {root: i for i, root in enumerate(roots)}
    hist = Counter()
    sample = {}
    trace_by_triangle = {}
    oriented = 0
    for i, a in enumerate(roots):
        for j, b in enumerate(roots):
            c = tuple(-x - y for x, y in zip(a, b))
            if c not in idx:
                continue
            k = idx[c]
            # Each matrix T is TWICE the corresponding 8x8 unitary U.
            # normalized trace = trace(T_c T_b T_a) / (8 * 8).
            t = trace_triple(links[k], links[j], links[i])
            assert t in (-64, -32, 0, 32, 64), (i, j, k, t)
            hist[t] += 1
            trace_by_triangle[(i, j, k)] = t
            sample.setdefault(t, (i, j, k))
            oriented += 1
    assert oriented == 13440
    return hist, sample, trace_by_triangle


def triple_word_check():
    I = [[int(i == j) for j in range(8)] for i in range(8)]
    e1, e2, e3 = basis(1), basis(2), basis(3)
    assert octmul(e3, octmul(e2, e1)) == basis(0)
    J1 = left_doubled_matrix(doubled_basis(1))
    J2 = left_doubled_matrix(doubled_basis(2))
    J3 = left_doubled_matrix(doubled_basis(3))
    # T=2J; the unitary word J3 J2 J1 = diag(1^4,-1^4).
    word8 = matrix_mul(J3, matrix_mul(J2, J1))
    desired8 = [[8 * (1 if i < 4 else -1) if i == j else 0
                 for j in range(8)] for i in range(8)]
    assert word8 == desired8

    # Existing VOPM-010 H_assoc=diag(0^4,4^4).
    # Here the closed left-translation word is exactly I-H_assoc/2.
    H2 = [[0 if i < 4 else (16 if i == j else 0)
           for j in range(8)] for i in range(8)]
    assert word8 == [[8*I[i][j] - H2[i][j] for j in range(8)]
                     for i in range(8)]
    print("PASS: k*(j*i)=1 but L_k L_j L_i=I-H_assoc/2 != I")
    print("PASS: operator word is a 4+4 reflection, not scalar identity")


def clifford_check():
    """Known Cl(0,7) relation tested for the explicit Cayley-Dickson signs."""
    J = [left_doubled_matrix(doubled_basis(i)) for i in range(1, 8)]
    for a in range(7):
        for b in range(7):
            # Since T_i=2L_i, {T_i,T_j}=-8 delta_ij I8.
            AB = matrix_mul(J[a], J[b])
            BA = matrix_mul(J[b], J[a])
            for i in range(8):
                for j in range(8):
                    assert AB[i][j] + BA[i][j] == (
                        -8 if a == b and i == j else 0
                    )
    print("PASS: seven imaginary left multipliers represent Cl(0,7)")
    print("LIMIT: no claim of eight Hermitian 8x8 Clifford generators (Cl8 needs C16)")


def main():
    triple_word_check()
    clifford_check()
    roots = cartesian_roots()
    primitive = lean_rows(
        ROOT / "VOPM" / "E8Basis.lean",
        "def primitiveRoots :", "def primitiveRoot ("
    )
    oct_units = mapped_octavians(primitive)
    assert len(roots) == len(oct_units) == 240
    assert len(set(oct_units)) == 240

    links = oriented_links(roots, oct_units)
    hist, samples, original_by_triangle = triangle_traces(roots, links)
    assert hist == Counter({0: 7632, -32: 3072, 32: 2736}), hist
    print("PASS: 13,440 directed E8 root triangles at each base vertex")
    print("PASS: normalized trace W=tr(Ugamma Ubeta Ualpha)/8:")
    print("  W=0:", hist[0], "; W=-1/2:", hist[-32], "; W=+1/2:", hist[32])
    print("TRACE-EXAMPLES (root-table indices):", samples)

    # A different isometric root-to-octavian identification:
    # reflect the REAL octonionic coordinate, the Weyl reflection r_1.
    # This reflection is NOT an automorphism of octonionic multiplication.
    reflected = [(-u[0],) + tuple(u[1:]) for u in oct_units]
    new_links = oriented_links(roots, reflected)
    reflected_hist, _, reflected_by_triangle = triangle_traces(roots, new_links)
    assert reflected_hist == Counter({0: 7632, -32: 2736, 32: 3072})
    assert all(reflected_by_triangle[t] == -v for t,v in original_by_triangle.items())
    print("PASS: Weyl-isometric but nonmultiplicative re-labelling alters holonomies")
    print("  reflected W=0:", reflected_hist[0],
          "; W=-1/2:", reflected_hist[-32],
          "; W=+1/2:", reflected_hist[32])

    # A nontrivial, genuine octonionic G2 automorphism:
    # (a,b) -> (a,-b) in the Cayley-Dickson form H + H*ell.
    # Unlike the real-unit Weyl reflection, it preserves multiplication.
    def g2_involution(u):
        return u[:4] + tuple(-a for a in u[4:])
    from check_associator import octmul
    for u in oct_units:
        for v in oct_units:
            assert g2_involution(octmul(u,v)) == octmul(g2_involution(u),g2_involution(v))
    assert set(g2_involution(u) for u in oct_units) == set(oct_units)
    # Since A is a real diagonal involution, L_{A(u)}=A L_u A^{-1}.
    sign = (1,1,1,1,-1,-1,-1,-1)
    g2_units = [g2_involution(u) for u in oct_units]
    for u,au in zip(oct_units,g2_units):
        T = left_doubled_matrix(u)
        TA = left_doubled_matrix(au)
        assert all(TA[i][j] == sign[i]*sign[j]*T[i][j]
                   for i in range(8) for j in range(8))
    g2_links = oriented_links(roots, g2_units)
    g2_hist, _, g2_by_triangle = triangle_traces(roots, g2_links)
    assert g2_hist == hist and g2_by_triangle == original_by_triangle
    print("POSITIVE CONTROL: a genuine nontrivial G2 octonion automorphism")
    print("  leaves EVERY E8 triangle operator trace unchanged.")

    # Control: L_1 at every directed edge has trivial closed-loop trace.
    I2 = [[2 if i == j else 0 for j in range(8)] for i in range(8)]
    control, _, _ = triangle_traces(roots, [I2 for _ in roots])
    assert control == Counter({64: 13440})
    print("CONTROL: identical unit transport on all edges gives W=+1 throughout")
    print("NOTE: Wilson-type TRACE is a candidate diagnostic of ONE fixed-frame")
    print("      connection; a gauge-transformation law is not yet derived.")
    print("NOTE: the distributions depend on the octavian embedding and")
    print("      on the choice of canonical undirected edge orientation.")
    print("NOTE: known Clifford/loop identities are reused, not new theorems.")
    print("NO CLAIM: observed 3+1 spacetime, TEGR, fermions, or quantum gravity.")



if __name__ == "__main__":
    main()
