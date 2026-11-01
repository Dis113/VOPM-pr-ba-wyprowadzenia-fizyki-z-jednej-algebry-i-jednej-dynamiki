# VOPM-010 — asocjator oktonionowy, Hamiltonian i ograniczenie dynamiczne

## Status naukowy

Ten moduł **nie** stanowi wyprowadzenia Modelu Standardowego, grawitacji,
konfinementu ani fizycznych stałych. Wyprowadza konsekwencje konkretnej
algebraicznej reprezentacji, a następnie dodatkowej, **jawnie postulowanej**
reguły sprzężenia wzdłuż krawędzi \`E₈\`.

Nie duplikujemy recenzowanych dowodów o alternatywności oktonionów ani
ogólnych wyników o unitarności. Wykorzystujemy ich ustalone własności
oraz sprawdzamy współrzędne i nowe konsekwencje *wybranego* modelu.

## 1. Lokalna algebra

W standardowej bazie Cayleya–Dicksona \`(1,i,j,k,ℓ,iℓ,jℓ,kℓ)\`:

\`\`\`math
A=L_i L_j-L_k=-[i,j,\cdot],\qquad ij=k.
\`\`\`

Dokładna macierz zespolono-liniowa, działająca na \`ℂ⁸\`, ma
niezerowe wpisy \`A_{4,7}=+2\`, \`A_{5,6}=-2\`,
\`A_{6,5}=+2\` i \`A_{7,4}=-2\`.

Stąd:

\`\`\`math
A^\dagger=-A,\quad
A^2=-4P_{\rm int},\quad
H_{\rm assoc}=A^\dagger A=4P_{\rm int},
\qquad
P_{\rm int}=\operatorname{diag}(0,0,0,0,1,1,1,1).
\`\`\`

\`\`\`math
\operatorname{spec}(H_{\rm assoc})=
\{0\ [\times4],4\ [\times4]\}.
\`\`\`

Liczby te są bezwymiarowymi wartościami operatora przy wybranej
normalizacji bazowych jednostek oktonionowych. **Nie oznaczają
mas ani obserwowanych energii cząstek.**

Szczególnie istotne:

\`\`\`math
[i,j,\ell]=(ij)\ell-i(j\ell)=2k\ell.
\`\`\`

Jest to znana tożsamość oktonionowa. Nasza weryfikacja Lean
sprawdza, że implementacja odpowiada temu układowi znaków.

## 2. Dodatkowy postulat: oddziaływanie na krawędzi

Dla węzłów \`x,y\` połączonych jednym z 240 pierwiastków \`E₈\`:

\`\`\`math
H_{xy}=H_{\rm assoc}^{(x)}\otimes H_{\rm assoc}^{(y)}
      =16\,P_{\rm int}^{(x)}\otimes P_{\rm int}^{(y)}.
\`\`\`

**Uwaga:** ta postać sprzężenia nie jest wymuszona samą algebrą
oktonionową. To **postulat dynamiki**, wybrany w celu stworzenia
minimalnej, unitarnej wersji wielowęzłowej.

Przy \`ℏ=1\` oraz wybranym **czasie modelowym**
\`Δτ=π/16\` otrzymujemy:

\`\`\`math
U_{xy}=e^{-i\Delta\tau H_{xy}}
      =I-2 P_{\rm int}^{(x)}\otimes P_{\rm int}^{(y)}.
\`\`\`

W bazie obliczeniowej na każdej parze węzłów faza jest \`−1\`
tylko gdy oba lokalne indeksy należą do \`{4,5,6,7}\`.
W przeciwnym razie wynosi \`+1\`.

**To nie jest wyprowadzenie czasu Plancka ani c.**
Skalę energii i długość aktualizacji trzeba wyprowadzić
z większej dynamiki, a nie dopasować.

## 3. Dowody, które testujemy w Lean 4

- \`defect_formula\`, \`defect_nonzero_witness\` — sprawdzenie
  tabel i niezerowej niełączności w standardowym układzie;
- \`defect_skew\`, \`defect_square\` — algebraiczna
  antyhermitowskość i relacja \(A^2=-4P\);
- \`defect_adjoint_square\`, \`energy_nonneg\` —
  certyfikat dodatniości \`H=A†A\`;
- \`interactionTick_pairing\`, \`interactionTick_bornMass\` —
  unitarność na pełnej kwantowej przestrzeni wielu węzłów;
- \`evolve_pairing\` — unitarność sekwencji aktualizacji;
- \`evolve_basis_probability\`,
  \`evolve_diagonalExpectation\` — ważny **warunkowy no-go**:
  wszystkie obserwable diagonalne w tej bazie są zachowane.

Odrębny test Python \`checks/check_associator.py\` sprawdza
tablice operatorów Lean względem niezależnej implementacji
mnożenia Cayleya–Dicksona, dokładne widmo macierzy 8×8
oraz niezerowe splątanie tworzone przez dyskretną bramkę.

## 4. Co ten model potrafi, a czego nie potrafi?

Potrafi generować względną fazę zależną od stanów dwóch
sąsiadujących komórek. Może zmienić stan produktowy
w splątany, ponieważ bramka kontrolowanej fazy jest
nieproduktowym operatorem unitarnym, jeśli komórki są różne.

Nie potrafi jednak zmieniać prawdopodobieństw w
wyróżnionej bazie, gdyż \`U_{xy}\` jest **diagonalne**.
Dla dowolnej skończonej sekwencji \`U_\sigma\`:

\`\`\`math
|(U_\sigma\Psi)(q)|^2=|\Psi(q)|^2
\quad
\text{dla każdej konfiguracji bazowej }q.
\`\`\`

W rezultacie w tej dynamice **nie ma propagacji populacji**
ani hoppingu między konfiguracjami. To ograniczenie dotyczy
tego konkretnego Hamiltonianu, nie oktonionów jako takich.

## 5. Następny niezależny problem

Zbudować konkretny operator **niediagonalny**:
\`H_{\mathrm{hop}}\`, który:

1. wynika z jawnie określonej struktury operatorowej
   \`ℂ⊗𝕆\`, a nie jest arbitralnie dopisany;
2. działa lokalnie po krawędziach w prymitywnej bazie \`E₈\`;
3. zachowuje unitarność i ograniczony stożek przyczynowy;
4. daje nietrywialne widmo propagacji i w końcu skuteczną
   geometrię 3+1; nie postuluje jej przez wybór współrzędnych.

Dopiero po rozwiązaniu tego problemu będzie sens
próbować odtworzyć sektory cechowania, fermiony,
konfinement czy kosmologię.

**Nie utożsamiamy niezerowego asocjatora z automatycznym
dowodem uwięzienia kwarków.**

## Odnośniki

- [Mathlib4](https://github.com/leanprover-community/mathlib4)
  — standardowa arytmetyka, normy i własności skończonych sum.
- J. C. Baez, *The Octonions*, Bulletin of the American
  Mathematical Society **39** (2002), 145–205,
  doi:10.1090/S0273-0979-01-00934-X.
- J. H. Conway, N. J. A. Sloane,
  *Sphere Packings, Lattices and Groups*, 3rd ed.,
  Springer, 1999 — geometria układu pierwiastków \`E₈\`.
