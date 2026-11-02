#!/usr/bin/env python3
"""VOPM-012b: exact 64x64 unitary two-site octavian edge-gate benchmark.

A proposed dynamical ansatz, NOT a consequence uniquely determined by
published octonion algebra:
    G_u = (I - 2 P_im x P_im) (L_u x L_conj(u)) SWAP.
Here P_im is projection on the seven imaginary octonionic axes.

The transport W=(L_u x L_conj(u))SWAP is a known unitary involution.
The controlled phase V=I-2P_im x P_im is a chosen entangler.
Both use the genuine many-body two-site Hilbert space C^8 tensor C^8,
not a direct sum (single-excitation sector).

For exact integer coefficients, represent the 64x64 matrix 4G_u,
because both L_u and L_conj(u) have half-integer coefficients.

No NumPy or numerical tolerances; all matrix comparisons are exact.
"""
from check_e8_basis import lean_rows
from check_octavian_bridge import (
    ROOT, mapped_octavians, left_doubled_matrix,
    conjugate_doubled, matrix_mul, matrix_transpose,
)


def integer_gate_four(u):
    """Return 4*G_u in computational basis |a,b>, integers."""
    T = left_doubled_matrix(u)
    Tbar = left_doubled_matrix(conjugate_doubled(u))
    g = [[0] * 64 for _ in range(64)]
    for a in range(8):
        for b in range(8):
            col = 8*a+b
            for c in range(8):
                for d in range(8):
                    row = 8*c+d
                    value = T[c][b] * Tbar[d][a]
                    g[row][col] = -value if c and d else value
    return g


def check_unitarity(g):
    # For G4=4G, G4^T G4 = 16 I.
    for a in range(64):
        for b in range(64):
            s = sum(g[k][a] * g[k][b] for k in range(64))
            assert s == (16 if a == b else 0), (a,b,s)


def check():
    rows = lean_rows(
        ROOT/"VOPM"/"E8Basis.lean",
        "def primitiveRoots :", "def primitiveRoot ("
    )
    units = mapped_octavians(rows)
    assert len(units) == 240

    one = next(i for i,u in enumerate(units) if u == (2,0,0,0,0,0,0,0))
    imaginary = next(i for i,u in enumerate(units)
                     if u == (0,2,0,0,0,0,0,0))
    halfreal = next(i for i,u in enumerate(units)
                    if u[0] == 1 and sum(1 for x in u if x) == 4)
    print("Examples: root labels for u=1, u=i and a half-real unit:",
          one, imaginary, halfreal)

    for tag, idx in [("identity",one), ("imaginary",imaginary),
                     ("half-real",halfreal)]:
        g = integer_gate_four(units[idx])
        check_unitarity(g)
        print(f"PASS: exact 64x64 unitarity for {tag} unit at label {idx}")

    # A product input |1,1> (basis indices 0,0) for a half-real unit
    # maps to an entangled output because the diagonal phase is applied
    # after a nontrivial octonionic left rotation of BOTH factors.
    u = units[halfreal]
    k = next(j for j in range(1,8) if u[j] != 0)
    g = integer_gate_four(u)
    col = 0
    r00 = g[0][col]
    r0k = g[k][col]
    rk0 = g[8*k][col]
    rkk = g[8*k + k][col]
    minor = r00*rkk - r0k*rk0
    assert minor != 0, "chosen output unexpectedly not entangled"
    assert sum(g[row][col]**2 for row in range(64)) == 16
    assert sum(g[row][col] != 0 for row in range(64)) == 16

    # A constant controlled-phase gate alone could never change the
    # probabilities of distinct basis configurations. This G does.
    assert sum(g[row][col] != 0 for row in range(1,64)) > 0
    print("PASS: half-real unit transports basis amplitudes to 16 outcomes")
    print(f"PASS: pure product input becomes entangled (2x2 minor numerator={minor})")
    # Crucial sign/orientation no-go: u and -u contribute two
    # minus signs in the tensor product, so G(-u) == G(u).
    # The 240 oriented E8 roots yield only 120 distinct local gates.
    signatures = {}
    for unit in units:
        gunit = integer_gate_four(unit)
        signature = tuple(value for row in gunit for value in row)
        signatures[signature] = signatures.get(signature, 0) + 1
    assert len(signatures) == 120
    assert set(signatures.values()) == {2}
    print("PASS: 240 root labels collapse to 120 unique two-site gates")
    print("NO-GO: current gate G(-u)=G(u); orientation is lost in one local event")
    print("NO-GO: single-edge entangling part is local-unitary-equivalent to CZ*SWAP")
    print("LIMIT: this is one selected gate, not a fixed-graph QFT or QCA")
    print("LIMIT: V and the gate order are independent dynamical POSTULATES")
    print("LIMIT: no spectral prediction of 3+1, Maxwell, TEGR or Standard Model")


if __name__ == "__main__":
    check()
