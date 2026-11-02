#!/usr/bin/env python3
"""VOPM-012: exact bridge between E8 root labels and integral octavian units.

Mathematical background (NOT original discoveries):
- Conway--Smith, On Quaternions and Octonions, chapters 9--10.
- Koca--Ozdes (1989), Division Algebras with Integral Elements.
- Dray--Manogue, Geometry of the Octonions, ell-integers.

A specific isometry is chosen (not canonical). This regression:
  1. reads the actual Lean E8 and octavian simple-root tables,
  2. verifies all 240 coordinates and 57,600 pairwise Gram products,
  3. verifies all 240 x 240 Cayley-Dickson products lie in the same set,
  4. checks each of the 240 complex-linear octavian left-action matrices
     is norm-preserving via exact integral matrix arithmetic,
  5. checks closure under conjugation and the inverse of each unit.

The number 240 and the norm-preserving identities are published algebra.
The added result is a reproducible, convention-specific *implementation
certificate* for the VOPM edge operators.

All vectors are "doubled": an octavian unit u is represented by 2u.
"""
from itertools import product, combinations
from pathlib import Path
from check_e8_basis import cartesian_roots, SIMPLE, lean_rows
from check_associator import octmul

ROOT = Path(__file__).resolve().parents[1]

# The fourteen tetrads of one maximal ell-integer order, in the basis
# 1,i,j,k,ell,iell,jell,kell (Dray--Manogue).
TETRADS = [
    (0, 1, 4, 5), (0, 2, 4, 6), (0, 3, 4, 7),
    (2, 3, 6, 7), (1, 3, 5, 7), (1, 2, 5, 6),
    (0, 2, 3, 5), (0, 1, 3, 6), (0, 1, 2, 7),
    (1, 4, 6, 7), (2, 4, 5, 7), (3, 4, 5, 6),
    (0, 5, 6, 7), (1, 2, 3, 4)
]

# The eight chosen simple roots in doubled OCTAVIAN coordinates.
# Their Gram matrix is half that of E8Basis.simpleRootsDoubled.
# They are one particular choice of chamber/isometry.
SIMPLE_OCT = (
    (0, 0, 0, -1, -1, -1, 1, 0),
    (0, 0, 2, 0, 0, 0, 0, 0),
    (0, 0, 0, 2, 0, 0, 0, 0),
    (0, -1, -1, -1, 1, 0, 0, 0),
    (0, 2, 0, 0, 0, 0, 0, 0),
    (-1, -1, 0, 0, -1, 1, 0, 0),
    (2, 0, 0, 0, 0, 0, 0, 0),
    (-1, 0, 0, 0, 0, -1, -1, 1),
)


def inner(a, b):
    return sum(x*y for x, y in zip(a, b))


def octavians_doubled():
    units = set()
    for j in range(8):
        for sign in (-2, 2):
            v = [0]*8
            v[j] = sign
            units.add(tuple(v))
    for tetrad in TETRADS:
        for signs in product((-1, 1), repeat=4):
            v = [0]*8
            for j, s in zip(tetrad, signs):
                v[j] = s
            units.add(tuple(v))
    return units


def conjugate_doubled(v):
    return (v[0],) + tuple(-x for x in v[1:])


def matrix_mul(a, b):
    return [[sum(a[i][k]*b[k][j] for k in range(8))
             for j in range(8)] for i in range(8)]


def matrix_transpose(a):
    return [[a[j][i] for j in range(8)] for i in range(8)]


def left_doubled_matrix(u2):
    # (2L_u) e_j = (2u)e_j. Entries are integers in the present basis.
    identity = [tuple(int(k == j) for k in range(8)) for j in range(8)]
    return [[octmul(u2, identity[j])[i] for j in range(8)]
            for i in range(8)]


def mapped_octavians(primitive):
    return [
        tuple(sum(co[j]*SIMPLE_OCT[j][i] for j in range(8))
              for i in range(8)) for co in primitive
    ]


def main():
    octav = octavians_doubled()
    assert len(TETRADS) == 14 and len({frozenset(t) for t in TETRADS}) == 14
    assert len(octav) == 240
    assert all(inner(u, u) == 4 for u in octav)
    assert set(conjugate_doubled(u) for u in octav) == octav

    # Read actual committed Lean data: no disconnected duplicate tables.
    e8path = ROOT / "VOPM" / "E8Basis.lean"
    o8path = ROOT / "VOPM" / "OctavianBridge.lean"
    raw_e8 = lean_rows(e8path, "def primitiveRoots :", "def primitiveRoot (")
    raw_simple = lean_rows(e8path, "def simpleRootsDoubled :", "/--\nCoordinates")
    raw_oct_simple = lean_rows(
        o8path, "def simpleOctavianRootsDoubled :", "/-- Primitive E8")
    assert tuple(raw_simple) == SIMPLE, "Lean E8 simple basis changed"
    assert tuple(raw_oct_simple) == SIMPLE_OCT, "Lean octavian basis changed"
    assert len(raw_e8) == 240

    gram_match = all(
        inner(SIMPLE[i], SIMPLE[j]) == 2*inner(SIMPLE_OCT[i], SIMPLE_OCT[j])
        for i in range(8) for j in range(8)
    )
    assert gram_match, "simple root Gram mismatch"

    doubled_std = cartesian_roots()
    # A stable exact scalar product certification for all 240 vectors.
    map240 = mapped_octavians(raw_e8)
    assert len(set(map240)) == 240
    assert set(map240) == octav, "image not the 240 integral octavian units"
    for alpha, beta in zip(raw_e8, doubled_std):
        assert tuple(
            sum(alpha[j]*SIMPLE[j][i] for j in range(8))
            for i in range(8)) == beta, "E8 coordinate conversion mismatch"

    for ia in range(240):
        for ib in range(240):
            assert inner(doubled_std[ia], doubled_std[ib]) == \
                   2*inner(map240[ia], map240[ib]), "240-root Gram mismatch"

    index = {u: i for i, u in enumerate(map240)}
    e0 = (2, 0, 0, 0, 0, 0, 0, 0)
    assert e0 in index
    signs = {}
    for ia, u in enumerate(map240):
        assert tuple(-x for x in u) in index
        signs[ia] = index[tuple(-x for x in u)]
        # The inverse of norm-1 octavian u is its conjugate.
        conj = conjugate_doubled(u)
        assert conj in index
        assert octmul(u, conj) == (4, 0, 0, 0, 0, 0, 0, 0)
        assert octmul(conj, u) == (4, 0, 0, 0, 0, 0, 0, 0)

    # All 57,600 products: verify multiplication closure in the same order.
    for u in map240:
        for v in map240:
            p4 = octmul(u, v)
            assert all(t % 2 == 0 for t in p4)
            assert tuple(t//2 for t in p4) in index, "unit loop not closed"

    I4 = [[4 if i == j else 0 for j in range(8)] for i in range(8)]
    for u in map240:
        T = left_doubled_matrix(u)
        assert matrix_mul(matrix_transpose(T), T) == I4
        assert matrix_mul(T, left_doubled_matrix(conjugate_doubled(u))) == I4

    assert len(signs) == 240
    print("PASS: octavian order has 240 distinct norm-one units (16+224)")
    print("PASS: all 57,600 octavian products close exactly under multiplication")
    print("PASS: E8-to-octavian simple Gram correspondence and 240-root bijection")
    print("PASS: all 57,600 pairwise root Gram relations (scale factor 2)")
    print("PASS: all 240 left-action matrices satisfy T^T T=4I; all inverses")
    # A Weyl reflection in the real unit preserves this root set, but
    # does not preserve Cayley-Dickson multiplication. Thus a full E8
    # Weyl symmetry is NOT automatically an internal octonionic symmetry.
    def reflect_in_real_unit(a):
        return (-a[0],) + a[1:]
    assert set(reflect_in_real_unit(a) for a in octav) == octav
    a, b = e0, (0, 2, 0, 0, 0, 0, 0, 0)
    def unit_product(u, v):
        p4 = octmul(u, v)
        assert all(z % 2 == 0 for z in p4)
        return tuple(z//2 for z in p4)
    assert reflect_in_real_unit(unit_product(a, b)) != unit_product(
        reflect_in_real_unit(a), reflect_in_real_unit(b))

    print("PASS: inverse, conjugation, orientation reversal each checked")
    print("PASS: explicit E8 Weyl reflection is NOT an octonion automorphism")
    print("LIMIT: isometry is a specific choice, not canonical; Weyl choices differ")
    print("LIMIT: U(-alpha)=-U(alpha), whereas conjugate(U(alpha)) need not equal -U(alpha)")
    print("LIMIT: exact 240-unit checks are regression code, not yet Lean kernel proofs")


if __name__ == "__main__":
    main()
