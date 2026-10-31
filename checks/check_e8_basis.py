#!/usr/bin/env python3
"""Independent exact-arithmetic regression test for E8 coordinate tables.

This is NOT a new proof of the classification of E8 roots. It tests that the
two *implementations* in the VOPM repository encode the same published roots.

No third-party Python dependencies are required for the main checks.
Optional SymPy prints Smith invariants for the ambient doubled-root lattice.
"""
from fractions import Fraction
from itertools import combinations, product
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def cartesian_roots():
    roots = []
    for i, j in combinations(range(8), 2):
        for a, b in product((-2, 2), repeat=2):
            r = [0] * 8
            r[i] = a
            r[j] = b
            roots.append(tuple(r))
    for mask in range(256):
        r = tuple(-1 if (mask >> i) & 1 else 1 for i in range(8))
        if r.count(-1) % 2 == 0:
            roots.append(r)
    return roots


SIMPLE = (
    (1, -1, -1, -1, -1, -1, -1, 1),
    (2, 2, 0, 0, 0, 0, 0, 0),
    (-2, 2, 0, 0, 0, 0, 0, 0),
    (0, -2, 2, 0, 0, 0, 0, 0),
    (0, 0, -2, 2, 0, 0, 0, 0),
    (0, 0, 0, -2, 2, 0, 0, 0),
    (0, 0, 0, 0, -2, 2, 0, 0),
    (0, 0, 0, 0, 0, -2, 2, 0),
)


def inverse_and_determinant(matrix):
    n = len(matrix)
    a = [
        [Fraction(matrix[i][j]) for j in range(n)]
        + [Fraction(int(i == j)) for j in range(n)]
        for i in range(n)
    ]
    determinant = Fraction(1)
    for col in range(n):
        pivot = next(i for i in range(col, n) if a[i][col])
        if pivot != col:
            a[col], a[pivot] = a[pivot], a[col]
            determinant *= -1
        val = a[col][col]
        determinant *= val
        a[col] = [v / val for v in a[col]]
        for i in range(n):
            if i != col:
                f = a[i][col]
                a[i] = [x - f * y for x, y in zip(a[i], a[col])]
    return tuple(tuple(r[n:]) for r in a), determinant


def coords(root, inverse):
    v = [sum(inverse[i][j] * root[j] for j in range(8)) for i in range(8)]
    assert all(x.denominator == 1 for x in v), "non-integral coordinate"
    return tuple(int(x) for x in v)


def lean_rows(path, start, end):
    text = path.read_text(encoding="utf-8")
    block = text.split(start, 1)[1].split(end, 1)[0]
    rows = re.findall(r"!\[\((-?\d+) : ℤ\),\s*([^\]]+)\]", block)
    return [
        (int(head),) + tuple(int(s.strip()) for s in tail.split(","))
        for head, tail in rows
    ]


def main():
    roots = cartesian_roots()
    assert len(roots) == 240 and len(set(roots)) == 240
    assert all(sum(x * x for x in v) == 8 for v in roots)
    assert all(all(x % 2 == v[0] % 2 for x in v) for v in roots)
    assert all(sum(v) % 4 == 0 for v in roots)

    mat = tuple(tuple(SIMPLE[j][i] for j in range(8)) for i in range(8))
    inv, det = inverse_and_determinant(mat)
    assert det in (256, -256)
    coeff = [coords(v, inv) for v in roots]
    assert len(set(coeff)) == 240
    assert all(
        tuple(sum(SIMPLE[j][i] * c[j] for j in range(8)) for i in range(8)) == r
        for r, c in zip(roots, coeff)
    )
    assert all(
        tuple(1 if j == i else 0 for j in range(8)) in coeff
        for i in range(8)
    )

    source_cartesian = lean_rows(
        ROOT / "VOPM" / "E8Data.lean",
        "def doubledRoots :", "/-- The integer coordinates",
    )
    source_primitive = lean_rows(
        ROOT / "VOPM" / "E8Basis.lean",
        "def primitiveRoots :", "def primitiveRoot (",
    )
    assert source_cartesian == roots, "E8Data differs from the canonical root table"
    assert source_primitive == coeff, "E8Basis differs from the exact basis conversion"

    moments = [[sum(v[i] * v[j] for v in roots) for j in range(8)] for i in range(8)]
    assert moments == [[240 if i == j else 0 for j in range(8)] for i in range(8)]

    print("PASS: 240 unique published roots, squared norm 8, second moment 240 I")
    print(f"PASS: det(simple-root change-of-basis)={det}, integral coordinates")
    print("PASS: 8 simple roots occur among 240 vectors")
    print("PASS: both Lean arrays match exactly (checked independently via Fractions)")
    print("NOTE: original ambient doubled roots span a proper index-256 sublattice")
    try:
        from sympy import Matrix, ZZ
        from sympy.matrices.normalforms import smith_normal_form
        matrix = Matrix.hstack(*(Matrix(v) for v in roots))
        sf = smith_normal_form(matrix, domain=ZZ)
        diagonal = [int(sf[i, i]) for i in range(8)]
        assert diagonal == [1, 2, 2, 2, 2, 2, 2, 4]
        print("OPTIONAL SMITH CHECK:", diagonal)
    except ImportError:
        print("OPTIONAL SMITH CHECK: install sympy to reproduce diagonal invariants")


if __name__ == "__main__":
    main()
