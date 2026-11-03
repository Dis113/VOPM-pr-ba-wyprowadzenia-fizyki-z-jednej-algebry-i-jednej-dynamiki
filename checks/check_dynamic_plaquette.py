#!/usr/bin/env python3
"""VOPM-016b: dynamical E8 triangle flux and EXACT finite-volume spectrum.

This is a local, quantum Z2-subgroup-of-G2 gauge LINK benchmark, not a
proof of emergent photons or a new form of lattice gauge theory.

Literature: Wegner (1971), Kogut--Susskind (1975), Fradkin--Shenker
(1979), Kitaev (2003), Levin--Wen (2005).

Choose an ACTUAL nondegenerate E8 root triangle with oriented root indices
(1,14,37) in the committed VOPM/E8Basis data, so alpha+beta+gamma=0.
Each of its three links carries TWO endpoint frame qubits; 6 qubits total.
At vertex v the local Z2 gauge transformation flips BOTH half-link bits
incident at v, leaving the octavian Wilson-type character invariant.

Operators:
  electric H_E = Gamma sum_{six half-links}(I-X_j);
  magnetic H_B = mu*(I-W_triangle), where W=Tr(T01 T12 T20)/8.

Both are Hermitian, gauge invariant and NONCOMMUTING for mu,Gamma>0.
The magnetic potential is positive because every T is orthogonal,
so -1<=W<=1. This is a genuine gauge-link dynamics toy Hamiltonian.

There are 64 link basis configurations, but the local Gauss constraints
reduce the PHYSICAL LINK Hilbert space to 8 dimensions = three parity bits
p0,p1,p2. Here the exact octavian link holonomy reduces to

  W_oct = 1/4 * (I+Z0 Z1 Z2).

Thus for Gamma=1, mu=4:
  H_phys = 9 I - 2(X0+X1+X2) - Z0Z1Z2.

The eight energy eigenvalues are analytically
  9 +/- sqrt(37) (once each), 9 +/- sqrt(5) (threefold each).
The gap is sqrt(37)-sqrt(5)>0; NO finite-volume gapless photon.

STRONG CONTROL: replacing ALL three octavian links with the identity
gives W_control = 1/2*(I+Z0Z1Z2) = 2*W_oct.
Consequently H_oct(Gamma,mu) =
H_control(Gamma,mu/2)+(mu/2)*I.
The entire physical spectrum and eigenvectors are therefore equivalent
up to an ENERGY SHIFT and MAGNETIC COUPLING RESCALING on this triangle.
There is NO NEW universality or parameter-free physics on this cluster.

No external packages; all certificates use exact integer or Fraction
arithmetic and a small degree-four polynomial identity for the spectrum.
"""

from fractions import Fraction
from itertools import product
from check_e8_basis import cartesian_roots, lean_rows
from check_octavian_bridge import (
    ROOT, mapped_octavians, left_doubled_matrix, matrix_mul,
)
from check_octavian_holonomy import oriented_links


TRIANGLE = (1, 14, 37)
VERTEX_ENDS = ((0, 5), (1, 2), (3, 4))


def dot_matrix(a, b):
    return matrix_mul(a, b)


def transpose(a):
    return [list(col) for col in zip(*a)]


def frame_sign(f, a):
    return -1 if f and a >= 4 else 1


def dress(T, left, right):
    return [[frame_sign(left,i)*T[i][j]*frame_sign(right,j)
             for j in range(8)] for i in range(8)]


def asbits(config):
    return tuple((config >> j) & 1 for j in range(6))


def w_oct_from_config(base, config):
    h = asbits(config)
    left = dress(base[0],h[0],h[1])
    middle = dress(base[1],h[2],h[3])
    right = dress(base[2],h[4],h[5])
    # T_u=2L_u and W=Tr(U01 U12 U20)/8, denominator 2^3*8.
    value = sum(dot_matrix(dot_matrix(left,middle),right)[i][i]
                for i in range(8))
    return Fraction(value,64)


def pbits(config):
    h=asbits(config)
    return (h[0]^h[5],h[1]^h[2],h[3]^h[4])


def p_index(p):
    return p[0]*4+p[1]*2+p[2]


def physical_h(gamma, mu, values):
    """Exact 8x8 physical gauge-invariant Hamiltonian in parity basis."""
    h=[[Fraction(0) for j in range(8)] for i in range(8)]
    for p in range(8):
        h[p][p]=Fraction(6*gamma)+mu*(1-values[p])
        for mask in (1,2,4):
            h[p][p^mask]-=2*gamma
    return h


def matmul8(a,b):
    return [[sum(a[i][k]*b[k][j] for k in range(8)) for j in range(8)]
            for i in range(8)]


def linear_combine(a, c, b):
    return [[a[i][j]+c*b[i][j] for j in range(8)]
            for i in range(8)]


def check():
    roots=cartesian_roots()
    idx={r:i for i,r in enumerate(roots)}
    coeff=lean_rows(
        ROOT/"VOPM"/"E8Basis.lean",
        "def primitiveRoots :", "def primitiveRoot (",
    )
    units=mapped_octavians(coeff)
    assert len(roots)==len(units)==240
    r=[roots[i] for i in TRIANGLE]
    assert all(sum(a[j] for a in r)==0 for j in range(8))
    prefix=[(0,)*8]
    for edge in r:
        prefix.append(tuple(a+b for a,b in zip(prefix[-1],edge)))
    assert prefix[-1]==prefix[0] and len(set(prefix[:-1]))==3
    base_links=oriented_links(roots,units)
    base=[base_links[i] for i in TRIANGLE]
    assert all(dot_matrix(transpose(T),T)==[
        [4 if i==j else 0 for j in range(8)] for i in range(8)]
        for T in base)

    W={k:w_oct_from_config(base,k) for k in range(64)}
    assert set(W.values()) == {Fraction(0),Fraction(1,2)}
    for k in range(64):
        for i,j in VERTEX_ENDS:
            assert W[k]==W[k^(1<<i)^(1<<j)]
        p=pbits(k)
        parity=(-1)**sum(p)
        assert W[k] == Fraction(1+parity,4)
    fibers={p:[] for p in product((0,1),repeat=3)}
    for k in range(64):
        fibers[pbits(k)].append(k)
    assert len(fibers)==8 and all(len(v)==8 for v in fibers.values())
    print("PASS: actual E8 triangle roots (1,14,37), 3 distinct vertices")
    print("PASS: magnetic octavian Wilson trace gauge invariant under all 3 generators")
    print("PASS: 64 half-link configurations -> 8 Gauss-invariant parity states")
    print("PASS: exact octavian magnetic flux = (1+Z0 Z1 Z2)/4")

    Wphys=[Fraction(1+(-1)**(p.bit_count()%2),4) for p in range(8)]
    Wctrl=[2*w for w in Wphys]
    assert sorted(Wphys)==[Fraction(0)]*4+[Fraction(1,2)]*4
    for gamma, mu in ((1,0),(1,4),(1,16),(2,8)):
        H=physical_h(gamma,mu,Wphys)
        Hctrl=physical_h(gamma,Fraction(mu,2),Wctrl)
        assert H==linear_combine(Hctrl,Fraction(mu,2),
                               [[int(i==j) for j in range(8)] for i in range(8)])
    print("NO-GO: octavian 3-link flux equivalent to identity-core Z2 theory")
    print("  after mu -> mu/2 and an additive energy offset mu/2.")

    G, mu = Fraction(1), Fraction(4)
    H=physical_h(G,mu,Wphys)
    I=[[int(i==j) for j in range(8)] for i in range(8)]
    K=linear_combine(H,-9,I)
    K2=matmul8(K,K)
    KA=linear_combine(K2,-37,I)
    KB=linear_combine(K2,-5,I)
    assert matmul8(KA,KB)==[[0]*8 for _ in range(8)]
    assert sum(K2[i][i] for i in range(8))==104
    # S= ZZZ*XXX anticommutes with ALL three X_i and ZZZ.
    S=[[0]*8 for _ in range(8)]
    for p in range(8):
        S[p][p^7]=(-1)**p.bit_count()
    sk=matmul8(S,K);ks=matmul8(K,S)
    assert all(sk[i][j]+ks[i][j]==0
               for i in range(8) for j in range(8))
    print("PASS: exact H_phys=9I-2(X0+X1+X2)-Z0Z1Z2")
    print("PASS: (K²-37I)(K²-5I)=0, Tr(K²)=104, SK+KS=0")
    print("SPECTRUM: 9 +/- sqrt(37) [once], 9 +/- sqrt(5) [three times]")
    print("GAP: sqrt(37)-sqrt(5)>0 (Gamma=1,mu=4), no photon")
    print("AT mu=0: physical gap 4 Gamma; finite cluster remains gapped.")
    print("LIMIT: no thermodynamic phase transition inferred from 3 vertices.")
    print("LIMIT: this is a Z2 subset of G2, not a continuous G2 photon.")
    print("LIMIT: no emergent 3+1 or observed coupling constants.")


if __name__=="__main__":
    check()
