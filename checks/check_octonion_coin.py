#!/usr/bin/env python3
"""Independent *representation* check, not a new proof of octonion algebra.

Checks that Lean's 8x8 operator for left multiplication by i matches the
usual Cayley–Dickson sign convention for O = H ⊕ H ℓ and that its sample
real-coefficient coin is orthogonal (hence complex-unitary).
"""
from fractions import Fraction
from pathlib import Path
import re


def qmul(a, b):
    x, y, z, t = a
    u, v, w, k = b
    return (
        x*u - y*v - z*w - t*k,
        x*v + y*u + z*k - t*w,
        x*w - y*k + z*u + t*v,
        x*k + y*w - z*v + t*u,
    )


def qconj(a):
    return (a[0], -a[1], -a[2], -a[3])


def qadd(a, b):
    return tuple(x + y for x, y in zip(a, b))


def qneg(a):
    return tuple(-x for x in a)


def cmul(p, q):
    """(a,b)(c,d) = (ac - conjugate(d)b, da + b conjugate(c))."""
    a, b = p[:4], p[4:]
    c, d = q[:4], q[4:]
    return (
        qadd(qmul(a, c), qneg(qmul(qconj(d), b))) +
        qadd(qmul(d, a), qmul(b, qconj(c)))
    )


def mmul(A, B):
    return [
        [sum(A[i][k] * B[k][j] for k in range(8)) for j in range(8)]
        for i in range(8)
    ]


def transpose(A):
    return [[A[j][i] for j in range(8)] for i in range(8)]


def check():
    e = [tuple(int(i == j) for i in range(8)) for j in range(8)]
    J = [[cmul(e[1], e[j])[i] for j in range(8)] for i in range(8)]
    sign_pairs = (
        (0, 1, -1), (1, 0, 1), (2, 3, -1), (3, 2, 1),
        (4, 5, -1), (5, 4, 1), (6, 7, 1), (7, 6, -1),
    )
    expected = [[0 for _ in range(8)] for _ in range(8)]
    for i, j, s in sign_pairs:
        expected[i][j] = s
    assert J == expected, "Cayley-Dickson table / expected sign mismatch"
    source = (Path(__file__).resolve().parents[1] /
              "VOPM" / "OctonionicCoin.lean").read_text(encoding="utf-8")
    parsed = re.search(
        r"def leftE1 \(v : Vec\) : Vec :=\s*!\[([^\]]+)\]", source
    )
    assert parsed, "missing explicit Lean leftE1 vector expression"
    tokens = [t.strip() for t in parsed.group(1).split(",")]
    assert tokens == [
        "-v 1", "v 0", "-v 3", "v 2",
        "-v 5", "v 4", "v 7", "-v 6",
    ], "the actual Lean leftE1 table differs from Cayley-Dickson"
    
    I = [[int(i == j) for j in range(8)] for i in range(8)]
    assert transpose(J) == [[-x for x in row] for row in J]
    assert mmul(J, J) == [[-x for x in row] for row in I]

    c, s = Fraction(3, 5), Fraction(4, 5)
    U = [[c*I[i][j] + s*J[i][j] for j in range(8)] for i in range(8)]
    assert mmul(transpose(U), U) == I
    print("PASS: left-e1 matrix matches Cayley-Dickson multiplication")
    print("PASS: J² = -I and Jᵀ = -J")
    print("PASS: nontrivial 3/5 + (4/5)J coin is unitary")
    print("NOTE: the angle/coupling is not derived from physical constants")


if __name__ == "__main__":
    check()
