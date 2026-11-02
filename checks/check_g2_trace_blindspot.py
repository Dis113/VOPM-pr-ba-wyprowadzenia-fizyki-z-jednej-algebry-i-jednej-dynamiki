#!/usr/bin/env python3
"""VOPM-014: Clifford-trace blind spot and a G2-sensitive four-edge witness.

Published mathematical inputs, NOT original results of this script:
  Baez (2002): real octonions, Clifford(0,7), G2 associative three-form.
  Harvey--Lawson (1982), Bryant (1987): G2 calibrations.
  Faraji (2026): traced Wilson loops lose information about holonomies.

This exact-integer regression audits the PREVIOUSLY PUBLISHED VOPM-013
13,440 E8 root triangles. It distinguishes:
  A) the operator character Tr(L_c L_b L_a)/8, which is expressible
     solely via real parts and the Euclidean Gram matrix (Clifford traces);
  B) the G2-invariant alternating three-form phi(Im a,Im b,Im c),
     which vanishes on ALL linear E8 triangles alpha+beta+gamma=0;
  C) an explicit four-edge closed E8 loop with THREE independent edge
     labels, for which phi on a three-link prefix is nonzero.

The four-loop prefix probe is in a chosen global octonionic frame.
It has NOT been established as a locally gauge-invariant observable.

All computations use integers (vectors and matrices encode twice a
unit octonion), no tolerance or extra Python packages.
"""

from collections import Counter
from fractions import Fraction
from check_e8_basis import cartesian_roots, lean_rows
from check_associator import octmul
from check_octavian_bridge import (
    ROOT, mapped_octavians, left_doubled_matrix, conjugate_doubled,
)
from check_octavian_holonomy import (
    canonical_positive, oriented_links, trace_triple,
)


def imag_inner(a, b):
    return sum(a[j] * b[j] for j in range(1, 8))


def clifford_triple_numerator(a, b, c):
    """For *doubled* units, Tr(T_c T_b T_a) = 8 * this integer.

    Classical Cl(0,7) trace formula, where T_u=2 L_u is encoded as
    the integer matrix of left multiplication by the doubled octonion.
    """
    return (
        a[0] * b[0] * c[0]
        - c[0] * imag_inner(a, b)
        - b[0] * imag_inner(a, c)
        - a[0] * imag_inner(b, c)
    )


def flipped_imaginary_axis_one(a):
    """A root-set isometry fixing 1, but NOT an octonion automorphism."""
    return (a[0], -a[1]) + a[2:]


def g2_involution(a):
    """Known genuine octonion automorphism (a,b)->(a,-b)."""
    return a[:4] + tuple(-x for x in a[4:])


def oriented_link_units(roots, units):
    """Use conjugate of the positive-root unit for the reversed edge."""
    idx = {r: i for i, r in enumerate(roots)}
    result = []
    for r in roots:
        pos = r if canonical_positive(r) else tuple(-t for t in r)
        u = units[idx[pos]]
        result.append(u if canonical_positive(r) else conjugate_doubled(u))
    return result


def g2_threeform_numerator(a, b, c):
    """8*phi(Im(a/2),Im(b/2),Im(c/2)), exact integer."""
    bi = (0,) + tuple(b[1:])
    ci = (0,) + tuple(c[1:])
    prod = octmul(bi, ci)
    return sum(a[i] * prod[i] for i in range(1, 8))


def root_triangles(roots):
    idx = {r: i for i, r in enumerate(roots)}
    return [
        (i, j, idx[tuple(-x-y for x, y in zip(a, b))])
        for i, a in enumerate(roots)
        for j, b in enumerate(roots)
        if tuple(-x-y for x, y in zip(a, b)) in idx
    ]


def open_triple_identity_component(tc, tb, ta):
    """The (0,0) matrix element, not the trace: e0^T Tc Tb Ta e0."""
    return sum(tc[0][j] * tb[j][k] * ta[k][0]
               for j in range(8) for k in range(8))


def check():
    roots = cartesian_roots()
    coeff = lean_rows(
        ROOT / "VOPM" / "E8Basis.lean",
        "def primitiveRoots :", "def primitiveRoot (",
    )
    units = mapped_octavians(coeff)
    assert len(roots) == len(set(roots)) == len(units) == len(set(units)) == 240

    ref = [flipped_imaginary_axis_one(u) for u in units]
    assert set(ref) == set(units)
    e1 = (0,2,0,0,0,0,0,0)
    e2 = (0,0,2,0,0,0,0,0)
    assert flipped_imaginary_axis_one(octmul(e1, e2)) != octmul(
        flipped_imaginary_axis_one(e1), flipped_imaginary_axis_one(e2)
    )
    print("PASS: imaginary-axis reflection preserves all 240 octavian roots")
    print("PASS: this reflection does NOT preserve octonionic multiplication (non-G2)")

    links = oriented_link_units(roots, units)
    links_reflected = oriented_link_units(roots, ref)
    T = oriented_links(roots, units)
    Tr = oriented_links(roots, ref)
    triangles = root_triangles(roots)
    assert len(triangles) == 13440
    hist = Counter()

    for i, j, k in triangles:
        # Actual matrix product in the unchanged 8x8 Cayley-Dickson
        # implementation, not just the formula being tested.
        matrix_trace = trace_triple(T[k], T[j], T[i])
        classical = clifford_triple_numerator(
            links[i], links[j], links[k]
        )
        assert matrix_trace == 8 * classical, (i, j, k, matrix_trace, classical)
        hist[matrix_trace] += 1

        # This witness is a non-G2 lattice isometry, yet it preserves
        # each traced length-three link product. Thus the earlier G2
        # invariance control was NECESSARY but not SELECTIVE.
        flipped_metric = clifford_triple_numerator(
            links_reflected[i], links_reflected[j], links_reflected[k]
        )
        assert classical == flipped_metric
        assert trace_triple(Tr[k], Tr[j], Tr[i]) == matrix_trace

        # The actual octavian images of alpha, beta, gamma sum to zero.
        # The G2 associative three-form is alternating, so it must
        # vanish on these linearly dependent triples; verify exactly.
        assert all(units[i][t] + units[j][t] + units[k][t] == 0
                   for t in range(8))
        assert g2_threeform_numerator(units[i], units[j], units[k]) == 0

    assert hist == Counter({0: 7632, -32: 3072, 32: 2736}), hist
    # Published spinorial construction of G2: the ASSOCIATIVE three-form
    # is a unit-spinor matrix element, NOT an ordinary matrix trace.
    # Check all 7^3=343 triples of pure imaginary basis units.
    imaginary_basis = [
        tuple(2 * int(j == i) for j in range(8)) for i in range(1, 8)
    ]
    imag_matrix = [left_doubled_matrix(u) for u in imaginary_basis]
    count_phi_nonzero = 0
    for a in range(7):
        for b in range(7):
            for c in range(7):
                numerator = g2_threeform_numerator(
                    imaginary_basis[a], imaginary_basis[b], imaginary_basis[c]
                )
                amp = open_triple_identity_component(
                    imag_matrix[c], imag_matrix[b], imag_matrix[a]
                )
                tr = trace_triple(imag_matrix[c],imag_matrix[b],imag_matrix[a])
                assert tr == 0
                assert amp == numerator, (a,b,c,amp,numerator)
                assert numerator in (-8, 0, 8)
                if numerator != 0:
                    count_phi_nonzero += 1
    assert count_phi_nonzero == 42
    print("PASS: 343 pure imaginary triples: unit-SPINOR bilinear is G2 3-form")
    print("PASS: all 343 corresponding ordinary matrix TRACES vanish")

    print("PASS: all 13,440 old Wilson-type triangle traces are Clifford/Gram data")
    print("PASS: every triangle G2 three-form value is ZERO")
    print("PASS: non-G2 imaginary-axis reflection preserves EVERY triangle trace")
    print("NO-GO: 3-edge traces cannot be claimed as a G2/nonassociativity detector")

    # An honest, nonbacktracking 4-edge cycle with three linearly
    # independent edge directions. These indices come directly from
    # the existing canonical E8 root table; no fabricated geometry.
    i, j, k, l = (0, 1, 6, 7)
    root_four = [roots[t] for t in (i, j, k, l)]
    assert all(sum(r[t] for r in root_four) == 0 for t in range(8))
    prefixes = [tuple(0 for _ in range(8))]
    for r in root_four:
        prefixes.append(tuple(x+y for x,y in zip(prefixes[-1],r)))
    assert prefixes[-1] == prefixes[0]
    assert len(set(prefixes[:-1])) == 4  # four distinct visited vertices
    assert len({i,j,k,l}) == 4

    # The first three edge labels are now independent; G2 can be seen
    # in a THREE-FORM of the open prefix. This is NOT a Wilson loop trace.
    value = g2_threeform_numerator(units[i], units[j], units[k])
    transformed = g2_threeform_numerator(ref[i], ref[j], ref[k])
    assert value == -4 and transformed == 4
    assert g2_threeform_numerator(
        g2_involution(units[i]), g2_involution(units[j]),
        g2_involution(units[k])) == value

    # Operator-level witness: (0,0) entry is sensitive even though
    # the full 8x8 triple TRACE is blind. The selected vector e0=1 is
    # fixed by global G2, but not by arbitrary local frame changes.
    amp = open_triple_identity_component(T[k],T[j],T[i])
    amp_ref = open_triple_identity_component(Tr[k],Tr[j],Tr[i])
    assert (amp, amp_ref) == (-4,4)
    assert (Fraction(amp,8),Fraction(amp_ref,8)) == (
        Fraction(-1,2), Fraction(1,2)
    )
    assert trace_triple(T[k],T[j],T[i]) == trace_triple(Tr[k],Tr[j],Tr[i])

    print("PASS: closed E8 four-edge witness: root indices (0,1,6,7)")
    print("PASS: three-prefix G2 form phi=-1/2, non-G2 reflection phi=+1/2")
    print("PASS: untraced 3-step (1,1) element changes -1/2 -> +1/2")
    print("PASS: same 3-step TRACED character remains identical")
    print("LIMIT: the open prefix/3-form probe is GLOBAL-G2 covariant only")
    print("LIMIT: no local gauge redundancy, 3+1 phase or physical observable derived")


if __name__ == "__main__":
    check()
