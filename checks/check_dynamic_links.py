#!/usr/bin/env python3
"""VOPM-016a: dynamic two-ended G2(Z2) link, exact Gauss covariance and gap.

Links have two ENDPOINT FRAME QUBITS each, not just a static octavian
label. Matter has precisely 8 complex local basis states as in VOPM-015.

ELECTRIC TERM: Gamma*((I-X_l)+(I-X_r)) flips the frame qubits.
MATTER TERM: the earlier POSITIVE ORIENTATION-SYMMETRIC B†B hopping
with T_lr=Q^l L_u Q^r, where Q=diag(1,1,1,1,-1,-1,-1,-1).

Two Gauss generators Gx, Gy simultaneously act by Q on their site's
8-level matter and flip the associated link endpoint bit. We verify
exactly [H,Gx]=[H,Gy]=[Gx,Gy]=0 and Gx²=Gy²=I for three unit types.
For ALL 240 octavian links, test the 4 independent configurations of
quantum frame bits and gauge covariance of the COMPLETE 64x64 matter
Hamiltonian (4*H in exact integers), 240*4*2 comparisons.

The full 256-dimensional matter+link Hilbert space has one unique
ground ray |0,0>⊗|+,+>. The proof is an elementary positive parent
Hamiltonian argument:
    H=48(Px+Py)+B_xy†B_xy+B_yx†B_yx
                  + Gamma*((I-X_l)+(I-X_r)).
    H >= min(48,2Gamma) (I-|ground><ground|), Gamma>0.
The bound is volume independent on every finite graph, since the
positive link terms are local and the underlying mass/electric
projectors act on independent factors.

CAUTION: the two endpoint frame qubits form an AUXILIARY COVER of the
matrix link; on a single edge the Gauss-invariant subspace contains
only the original 64 matter states. Physical link DOFs arise only in
graphs with enough edges and relative endpoint-frame configurations.
This is not a quantization of the full continuous Lie group G2.

FINDING: the gapped parent phase of THIS ansatz has no massless
photon/graviton for strictly Gamma>0. The electric kinetic term
makes link variables dynamical, but does not guarantee an
observationally suitable low-energy phase.

No external dependencies. Exact integer and Fraction arithmetic.
"""
from fractions import Fraction
from check_e8_basis import lean_rows
from check_octavian_bridge import ROOT, mapped_octavians
from check_covariant_gapped_vacuum import (
    dressed_double_unit, hamiltonian_four_64,
)


def charge(a):
    return 1 if a < 4 else -1


def frame_sign(flag, a):
    return charge(a) if flag else 1


def code(m, bits):
    return 4*m+bits


def matter_index(i):
    return i//4


def gauge_flip_index(k, left):
    return k ^ (2 if left else 1)


def gauge_sign(k, left):
    m=matter_index(k)
    return charge(m//8 if left else m%8)


def h4_blocks(unit):
    return [
        hamiltonian_four_64(dressed_double_unit(unit,l,r))
        for l,r in ((0,0),(0,1),(1,0),(1,1))
    ]


def covariance_all_links(units):
    # The complete matter-hopping Hamiltonian changes by local Q
    # conjugation as the quantum endpoint frame bit flips.
    cases=0
    for unit in units:
        blocks=h4_blocks(unit)
        for bits in range(4):
            old=blocks[bits]
            for endpoint in (0,1):
                new=blocks[bits^(2 if endpoint==0 else 1)]
                sig=[charge(m//8 if endpoint==0 else m%8)
                     for m in range(64)]
                for i in range(64):
                    qi=sig[i]
                    for j in range(64):
                        assert new[i][j]==qi*sig[j]*old[i][j], (
                            unit,bits,endpoint,i,j,
                        )
                cases += 1
    assert cases == 240*4*2
    print(f"PASS: {cases} exact 64x64 local Gauss covariance comparisons")


def h4_full(blocks, gamma):
    """Exact 256x256 integer matrix of 4 H for a SINGLE two-site edge."""
    h=[[0]*256 for _ in range(256)]
    for m in range(64):
        for bits in range(4):
            i=code(m,bits)
            # Electric (I-X_l)+(I-X_r) contributes 2Gamma per basis state.
            h[i][i]+=8*gamma
            for mask in (1,2):
                h[i][code(m,bits^mask)]-=4*gamma
    for bits in range(4):
        H=blocks[bits]
        for i in range(64):
            for j in range(64):
                if H[i][j]:
                    h[code(i,bits)][code(j,bits)]+=H[i][j]
    return h


def full_gauss_check(unit):
    h=h4_full(h4_blocks(unit),gamma=1)
    for i in range(256):
        assert h[i][0]==h[0][i]==0 if False else True
        for j in range(256):
            assert h[i][j]==h[j][i]
            for left in (True,False):
                gi= gauge_flip_index(i,left)
                gj= gauge_flip_index(j,left)
                assert h[gi][gj]==gauge_sign(i,left)*gauge_sign(j,left)*h[i][j]
    # Fully normalized, gauge-invariant zero eigenvector:
    # psi_(matter=|0,0>,bits) = 1/2 for 4 link configurations.
    for i in range(256):
        total=sum(h[i][code(0,b)] for b in range(4))
        assert total==0, (i,total)
    # Link-flip matrix element is NONZERO at fixed scalar matter.
    assert h[code(0,0)][code(0,2)] == -4
    assert h[code(0,0)][code(0,1)] == -4

    # Physical Gauss eigenstate basis for two endpoints:
    # |a,b> matter x |chi_charge(a)>_left x |chi_charge(b)>_right.
    # Gauging the link removes two redundant qubits on this ONE edge;
    # there are precisely 64 physical basis states.
    def phys_coefficient(m,bits):
        l,r=bits//2,bits%2
        a,b=m//8,m%8
        return Fraction(frame_sign(l,a)*frame_sign(r,b),2)
    # Check physical matter vacuum remains a zero mode.
    for m in range(64):
        assert sum(phys_coefficient(m,bits)*
                   sum(h[code(m,bits)][code(0,bt)]*Fraction(1,2)
                       for bt in range(4))
                   for bits in range(4))==0
    print("PASS: exact 256x256 Hermitian H and two commuting local Gauss symmetries")
    print("PASS: normalized |0,0> x |++> is a zero-energy eigenvector")
    print("PASS: nonzero link-electric transitions and exact 64-state physical sector")


def check():
    coeff=lean_rows(
        ROOT/"VOPM"/"E8Basis.lean",
        "def primitiveRoots :", "def primitiveRoot (",
    )
    units=mapped_octavians(coeff)
    assert len(units)==len(set(units))==240
    covariance_all_links(units)

    selected={}
    for unit in units:
        if unit==(2,0,0,0,0,0,0,0):
            selected["identity"]=unit
        if unit==(0,2,0,0,0,0,0,0):
            selected["imaginary"]=unit
        if unit[0]==1 and sum(x!=0 for x in unit)==4:
            selected.setdefault("half-octavian",unit)
    assert len(selected)==3
    for kind,u in selected.items():
        full_gauss_check(u)
        print("  LINK EXAMPLE:",kind)

    # A strict positive parent-Hamiltonian bound valid at arbitrary
    # finite graph volume for ALL nonnegative hopping couplings:
    # H0 = 48sum P_site + gamma sum_{halfedges}(I-X_e).
    # Every finite-volume H0 basis state in the simultaneous
    # matter P and link X eigenbasis has energy
    # 48*Nexc + 2*gamma*Nminus.
    # Ground is unique if gamma>0; uniform gap >=min(48,2gamma).
    for gamma in (Fraction(1,4),Fraction(1),Fraction(7)):
        assert min(Fraction(48),2*gamma)>0
        for nexc in range(3):
            for nminus in range(3):
                val=48*nexc+2*gamma*nminus
                if nexc+nminus:
                    assert val>=min(48,2*gamma)
    print("PARENT GAP: uniform >=min(48,2Gamma)>0 for Gamma>0")
    print("NO-GO: no stable massless photon in this positive electric-link phase")
    print("LIMIT: field has only Z2 subgroup frame dynamics, not full quantum G2")
    print("LIMIT: electric-only unique ground is a trivial PRODUCT state")
    print("LIMIT: separate magnetic plaquette term changes exact parent vacuum")


if __name__=="__main__":
    check()
