#!/usr/bin/env python3
"""Literature-grounded VOPM checks; pure stdlib, exact moments.

References:
- Bannai & Sloane (1981): E8 roots form a tight spherical 7-design.
- Baez (2002): octonions, G2 automorphism group.
- D'Ariano & Perinotti (2014): Dirac-like low-energy QCA benchmarks.

This script checks the particular VOPM implementation and compares three
chosen propagation directions with D8 and Z8 controls; no claims of new
E8 design mathematics or a global anisotropy bound are made.
"""
from fractions import Fraction
from itertools import combinations, product
from math import cos, factorial, prod, sqrt

from check_e8_basis import cartesian_roots
from check_associator import octmul, matmul, trans


def multiindices(total, dims=8):
    if dims == 1:
        yield (total,)
    else:
        for k in range(total + 1):
            for tail in multiindices(total - k, dims - 1):
                yield (k,) + tail


def moment_certificate(roots):
    """Check ALL coefficients of moments (alpha dot k)^{2,4,6}."""
    assert len(roots) == 240 and len(set(roots)) == 240
    # The input contains doubled E8 roots beta=2 alpha.
    counts = {}
    for m, c in [(1, 240), (2, 576), (3, 1920)]:
        degree = 2 * m
        tested = 0
        for powers in multiindices(degree):
            multinomial = factorial(degree)
            for p in powers:
                multinomial //= factorial(p)
            lhs = multinomial * sum(
                prod(r[i] ** p for i, p in enumerate(powers)) for r in roots
            )
            if any(p % 2 for p in powers):
                rhs = 0
            else:
                rhs = c * factorial(m)
                for p in powers:
                    rhs //= factorial(p // 2)
            assert lhs == rhs, (degree, powers, lhs, rhs)
            tested += 1
        counts[degree] = tested
    # First demonstrably anisotropic term of the E8 axial/pair probes.
    axis = Fraction(sum(r[0] ** 8 for r in roots), 2 ** 8)
    pair = Fraction(sum((r[0] + r[1]) ** 8 for r in roots), 2 ** 12)
    assert (axis, pair) == (Fraction(57, 2), Fraction(39))
    return counts, axis, pair


def d8_roots():
    out = []
    for i, j in combinations(range(8), 2):
        for a, b in product((-1., 1.), repeat=2):
            v = [0.] * 8
            v[i], v[j] = a, b
            out.append(tuple(v))
    return out


def z8_roots():
    return [tuple(s if i == j else 0. for i in range(8))
            for j in range(8) for s in (-1., 1.)]


def probes():
    return {
        "axis": (1., 0., 0., 0., 0., 0., 0., 0.),
        "pair": (1/sqrt(2), 1/sqrt(2), 0., 0., 0., 0., 0., 0.),
        "diag8": tuple(1/sqrt(8) for _ in range(8)),
    }


def directional_dispersion(roots, ell, t):
    """Normalize link length and isotropic |k|^2 coefficient to the same value."""
    quadratic = sum(r[0] ** 2 for r in roots) / 2
    assert quadratic > 0
    values = {}
    for name, u in probes().items():
        s = sum(1 - cos((t/ell) * sum(a*b for a,b in zip(r,u)))
                for r in roots)
        values[name] = ell**2 * s / quadratic
    return values, ((max(values.values()) - min(values.values())) /
                    (sum(values.values()) / len(values)))


def g2_symmetric_associator():
    """Sum 21 exact integer 8x8 A_ij^T A_ij matrices."""
    e = [tuple(int(i == j) for i in range(8)) for j in range(8)]
    L = [
        [[octmul(e[a], e[b])[c] for b in range(8)] for c in range(8)]
        for a in range(8)
    ]
    total = [[0] * 8 for _ in range(8)]
    for i, j in combinations(range(1, 8), 2):
        p = octmul(e[i], e[j])
        productL = matmul(L[i], L[j])
        directL = [[sum(p[c] * L[c][a][b] for c in range(8))
                    for b in range(8)] for a in range(8)]
        A = [[productL[a][b] - directL[a][b] for b in range(8)]
             for a in range(8)]
        assert trans(A) == [[-x for x in row] for row in A]
        H = matmul(trans(A), A)
        total = [[total[a][b] + H[a][b] for b in range(8)]
                 for a in range(8)]
    target = [[48 if a == b and a > 0 else 0
               for b in range(8)] for a in range(8)]
    assert total == target
    return [total[i][i] for i in range(8)]


def main():
    roots2 = cartesian_roots()
    counts, m_axis, m_pair = moment_certificate(roots2)
    print("PASS: E8 moment polynomial coefficients for degrees 2,4,6:", counts)
    print("PASS: T2=60|k|², T4=36|k|⁴, T6=30|k|⁶")
    print("PASS: degree-8 anisotropy: M8(axis)=", m_axis,
          "M8(pair)=", m_pair)

    physical_e8 = [tuple(r / 2 for r in beta) for beta in roots2]
    for t in (0.75, 1.5, 2.0):
        for name, roots, ell in [
            ("E8", physical_e8, sqrt(2)),
            ("D8", d8_roots(), sqrt(2)),
            ("Z8", z8_roots(), 1.),
        ]:
            values, spread = directional_dispersion(roots, ell, t)
            if t == 1.5 and name == "E8":
                assert 0 < spread < 1.3e-5
            if t == 1.5 and name == "D8":
                assert 0.04 < spread < 0.05
            if t == 1.5 and name == "Z8":
                assert 0.16 < spread < 0.17
            print(f"CHECK: k*link={t:.2f}, {name}: {100*spread:.9f}% "
                  f"(axis={values['axis']:.9f}, pair={values['pair']:.9f}, "
                  f"diag={values['diag8']:.9f})")

    print("PASS: 21-associator symmetric Hamiltonian diag:",
          g2_symmetric_associator())
    print("LIMIT: no emergent 3+1 in a scalar isotropic E8 Laplacian.")
    print("LIMIT: symmetric 0+7 local energy is not three fermion generations.")
    print("STATUS: classical published identities + model-specific benchmark.")


if __name__ == "__main__":
    main()
