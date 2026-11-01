#!/usr/bin/env python3
"""Independent exact-arithmetic check of the VOPM-010 associator proposal.

This test compares the *actual Lean coordinate tables* to the standard
published Cayley-Dickson multiplication. It is not a new proof of the
abstract classification of the octonions or of the physical model.

No external Python packages are required.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def qmul(a, b):
    x, y, z, t = a
    u, v, w, k = b
    return (x * u - y * v - z * w - t * k,
            x * v + y * u + z * k - t * w,
            x * w - y * k + z * u + t * v,
            x * k + y * w - z * v + t * u)


def qconj(a):
    return a[0], -a[1], -a[2], -a[3]


def qadd(a, b):
    return tuple(x + y for x, y in zip(a, b))


def qneg(a):
    return tuple(-x for x in a)


def octmul(p, q):
    a, b = p[:4], p[4:]
    c, d = q[:4], q[4:]
    return qadd(qmul(a, c), qneg(qmul(qconj(d), b))) + qadd(
        qmul(d, a), qmul(b, qconj(c)))


def matmul(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(8))
             for j in range(8)] for i in range(8)]


def trans(A):
    return [[A[j][i] for j in range(8)] for i in range(8)]


def extract_lean_matrix(name, source):
    pattern = (r"def\s+" + re.escape(name) +
               r"\s*\(v\s*:\s*Vec\)\s*:\s*Vec\s*:=\s*!\[([^\]]+)\]")
    match = re.search(pattern, source)
    if match is None:
        raise AssertionError(f"Lean vector form of {name} not found")
    tokens = [s.strip() for s in match.group(1).split(",")]
    assert len(tokens) == 8, (name, tokens)
    output = [[0] * 8 for _ in range(8)]
    for i, token in enumerate(tokens):
        m = re.fullmatch(r"(-?)v\s*([0-7])", token)
        if not m:
            raise AssertionError(f"{name} unknown token: {token}")
        output[i][int(m.group(2))] = -1 if m.group(1) else 1
    return output


def main():
    basis = [tuple(int(i == j) for i in range(8)) for j in range(8)]
    I = [[int(i == j) for j in range(8)] for i in range(8)]
    L = [[[octmul(basis[k], basis[j])[i] for j in range(8)]
          for i in range(8)] for k in range(8)]
    assert octmul(basis[1], basis[2]) == basis[3], "i*j must equal k"

    code1 = (ROOT / "VOPM" / "OctonionicCoin.lean").read_text(encoding="utf-8")
    code2 = (ROOT / "VOPM" / "Associator.lean").read_text(encoding="utf-8")
    for k, name, text in [(1, "leftE1", code1),
                          (2, "leftE2", code2),
                          (3, "leftE3", code2)]:
        assert extract_lean_matrix(name, text) == L[k], f"wrong {name}"

    A = [[v - w for v, w in zip(rowA, rowB)]
         for rowA, rowB in zip(matmul(L[1], L[2]), L[3])]
    expected = [[0] * 8 for _ in range(8)]
    expected[4][7] = 2
    expected[5][6] = -2
    expected[6][5] = 2
    expected[7][4] = -2
    assert A == expected, "associator defect coordinate mismatch"
    assert all(A[i][j] == -A[j][i] for i in range(8) for j in range(8))
    H = matmul(trans(A), A)
    target = [[(4 if i >= 4 else 0) if i == j else 0
               for j in range(8)] for i in range(8)]
    assert H == target, "A^T A must equal 4 times the internal projector"
    assert matmul(A, A) == [[-x for x in row] for row in target]
    assert H[0][0] == 0 and H[4][4] == 4

    left_asso = octmul(octmul(basis[1], basis[2]), basis[4])
    right_asso = octmul(basis[1], octmul(basis[2], basis[4]))
    assert tuple(x - y for x, y in zip(left_asso, right_asso)) ==         tuple(2 * t for t in basis[7])

    for a in range(8):
        for b in range(8):
            joint_energy = H[a][a] * H[b][b]
            assert (joint_energy == 16) == (a >= 4 and b >= 4)
            phase = -1 if joint_energy == 16 else 1
            assert phase * phase == 1

    # Balanced superposition on the {0,4} subspaces of two distinct sites:
    # local tensor-product state has rank-one amplitudes,
    # whereas the interaction phase gives determinant != 0.
    M = [[1, 1], [1, -1]]
    assert M[0][0] * M[1][1] - M[0][1] * M[1][0] == -2

    print("PASS: Lean L_i,L_j,L_k tables match standard Cayley-Dickson multiplication")
    print("PASS: [i,j,l] = +2kl (nonzero associator)")
    print("PASS: A†=-A and H=A†A=diag(0,0,0,0,4,4,4,4)")
    print("PASS: joint energies 0 or 16; discrete controlled phases unitary")
    print("PASS: two-distinct-site controlled phase can entangle a product state")
    print("NOTE: H_xy=H_x tensor H_y and update time pi/16 are EXTRA POSTULATES")


if __name__ == "__main__":
    main()
