# VOPM-015 — jedna lokalna dynamika z zamkniętą rodziną łączy i stabilnym spinorowym stanem próżni

**Status: 3 listopada 2026 r.**  
**Rodzaj wyniku:** jawna, pozytywna, lokalna konstrukcja Hamiltonianowa i
formalizacja jej wybranych własności. Standardowych ogólnych
twierdzeń o kwantowych Hamiltonianach, grupie G₂, oktonionach,
twierdzeniu Elitzura oraz propagacji Lieb–Robinsona **nie powtarzamy**.

**Najważniejszy rezultat:** możemy jednocześnie uzyskać
(1) zamkniętą na wybrane lokalne zmiany ram rodzinę operatorów łączy,
(2) dokładnie jedno zeroenergiczne spinorowe podłoże w każdej komórce,
(3) dodatni, niefrustrowany model lokalny z jedyną globalną próżnią,
(4) rzeczywisty niediagonalny transport wzbudzeń.

**NIE** jest to jeszcze pochodzący jednoznacznie z algebry
Model Standardowy/kwantowa grawitacja ani mechanizm emergencji 3+1.

## 1. Dane mikroskopowe i matematyka wejściowa

- **Graf:** nierozłączna krata pierwiastków E₈ w bazie prymitywnej.
  Każde łącze ma etykietę \(\alpha\), jedną z 240 najkrótszych
  dróg; dla zbioru krawędzi nieskierowanych wybieramy jedną
  reprezentację pary \(\pm\alpha\) i nie liczymy łącza dwukrotnie.
- **Stan lokalny:** \(\mathcal H_x=\mathbb C^8\), baza
  \((1,i,j,k,\ell,i\ell,j\ell,k\ell)\).
- **Baza próżni i projekcja:**
  \[
  s_0=|1\rangle=(1,0,\ldots,0),\qquad
  P=I-|1\rangle\langle1|
  =\operatorname{diag}(0,1,\ldots,1).
  \]
- **Reprezentacja krawędzi:** znane 240 integralnych jednostek
  oktonionowych \(u_\alpha\) oraz unitarne
  \(\mathbb C\)-liniowe rozszerzenia
  \(L_{u_\alpha}\) z VOPM-012. Wybrana izometria
  \(E₈\to\mathbb O\) jest **niekanoniczna**.

**Energia z asocjatorów** — ścisła suma 21 macierzy,
wcześniej zweryfikowana dokładną arytmetyką całkowitą:

\[
H_{\mathrm{sym}}
=\sum_{1\le a<b\le7}
 (L_{e_a}L_{e_b}-L_{e_ae_b})^\dagger
 (L_{e_a}L_{e_b}-L_{e_ae_b})
=\boxed{48P}.
\tag{1}
\]

Twierdzenia w \`VOPM/GappedVacuum.lean\` potwierdzają jądro
i dodatnią lokalną energię \(48P\) w Lean. **Pełna tożsamość
21 asocjatorów** pozostaje certyfikowana kodem Python,
a nie osobnym jądrowym dowodem Lean; nie wolno jej tak przedstawiać.

Z (1) **zeroenergetyczny stan lokalny jest dokładnie
jednowymiarowy**:

\[
\ker H_{\mathrm{sym}}=\mathbb C\,s_0,\qquad
\mathrm{spec}(H_{\mathrm{sym}})=
\{0[\times1],\,48[\times7]\}.
\tag{2}
\]

Trzeba oddzielić to od *spontanicznego łamania symetrii*:
wyróżnienie tożsamości \(1\) jest już zawarte w
samym iloczynie oktonionowym i asocjatorze. Stabilny
stan podstawowy wynika z **energii**, lecz nie
jest spontanicznym wyborem spośród ciągłej rodziny
stanów o tej samej energii i nie wyprowadza spontanicznego
złamania \(\mathrm{Spin}(7)\to G₂\).

## 2. Naprawa przestrzeni łączy — domknięcie na transformacje ram

W VOPM-014 wykazano, że \(\{L_u\}\) **nie jest zamknięte**
na niezależne \(G₂\) w końcach krawędzi. Naprawa:

\[
\boxed{
\mathscr T=
\{\,g_L L_u g_R^{-1}:
g_L,g_R\in G₂,\quad u\in\mathcal U_{\rm oct}\,\}.
}
\tag{3}
\]

To rodzina operatorów 8×8 w \(\mathrm{SO}(8)\),
**nie** twierdzenie, że sama \(\mathcal U_{\rm oct}\)
stała się grupą czy lokalnym \(G₂\).
Pod niezależnymi zmianami ram
\(h_x,h_y\in G₂\):

\[
g_L L_u g_R^{-1}
\mapsto
(h_xg_L)L_u(h_yg_R)^{-1}
=h_x(g_LL_ug_R^{-1})h_y^{-1}.
\tag{4}
\]

**Domknięcie (3) pod (4) jest ścisłe i algebraiczne,
wynikające z grupowości \(G₂\); nie jest nowym twierdzeniem**.
Odwrócone łącze ma operator odwrotny:
\[
T_{yx}=T_{xy}^{-1}=g_R L_{\bar u}g_L^{-1}.
\]
Nie mylić z etykietą \(-\alpha\), dla której
\(u_{-\alpha}=-u_\alpha\), zazwyczaj nie
jest to \(\bar u_\alpha\).

Dla dowolnego \(g\in G₂=\operatorname{Aut}(\mathbb O)\)
zachodzi \(g(1)=1\) i \(gP=Pg\). Dzięki temu
wyróżniony spinor \(s_0\) pozostaje niezmienniczy
przy całej lokalnej grupie ram i nie łamiemy
lokalnej redundancji.

**Co naprawdę sprawdzono w Lean?**
\`VOPM/ClosedFrames.lean\` koduje
jawny niebanalny podgrupowy model ram
\(\mathbb Z_2=\{I,Q\}\subset G₂\),
gdzie \(Q(a,b)=(a,-b)\). Dowodzimy
\(Q^2=I\), zachowania \(s_0\) i \(P\),
oraz domknięcia \(\mathscr T_{\mathbb Z_2}\)
na cztery niezależne kombinacje ram w
wierzchołkach. **Nie** twierdzimy, że
tym samym formalnie zbudowaliśmy
całą ciągłą grupę \(G₂\) w Lean.

Poza podgrupą \(\mathbb Z_2\) domknięcie
(3)–(4) jest zwykłą własnością grupowego
działania i opiera się na znanej matematyce.

## 3. Jedna reguła Hamiltonianowa: dodatni transport wzbudzeń

Niech \(x\ne y\) będą sąsiednimi węzłami
i \(T_{xy}\in\mathscr T\). Operator
\[
M_{xy}=P\,T_{xy}\,P
\]
jest zdefiniowany w siedmiowymiarowej
przestrzeni stanów wzbudzonych; w ogólności
**nie jest unitarny**, bo projekcja
usuwa mieszanie ze stanem próżni.

Działanie operatora
\(B_{xy}:\mathbb C^8_x\otimes\mathbb C^8_y
\to\mathbb C^7\)
na amplitudach pary w sektorze jednego
lokalnego wzbudzenia definiujemy:

\[
\boxed{
(B_{xy}\Psi)_a
=\Psi_{a,0}-\sum_{b=1}^7(M_{xy})_{ab}\Psi_{0,b},
\quad a=1,\ldots,7.
}
\tag{5}
\]

Dla pozostałych konfiguracji (para \(|0,0\rangle\)
lub para z dwoma wzbudzeniami) \(B\)
nie pobiera amplitud, więc jest zerowy.

**Jedna wybrana reguła mikrodynamiki na skończonej sieci**:

\[
\boxed{
H_V=
48\sum_{x\in V}P_x+
\sum_{\{x,y\}\in E(E₈)}
B_{xy}^{\dagger}B_{xy}.
}
\tag{6}
\]

Jest to **jedna całość Hamiltonianowa**,
bez zewnętrznej listy zdarzeń czy
dodatkowego operatora \(\mathrm{CZ}\).
Obowiązuje znana ewolucja
\(U(t)=e^{-itH_V}\), z \(\hbar=1\).

**Uwaga o parametrach:** wybór względnego
współczynnika \(1\) przed sumą krawędzi
jest **dodatkowym postulatem**
minimalnego modelu, a nie unikatnym
wynikiem samej algebry. Ustawienie
\(48\) wynika z konwencji normalizacji
(1); nie przewiduje fizycznego stosunku mas.

## 4. Ścisła stabilność próżni i luka

Dla dowolnego \(\Psi\) i skończonego \(V\):

\[
\langle\Psi,H_V\Psi\rangle
=48\sum_x\langle\Psi,P_x\Psi\rangle
+\sum_{xy}\|B_{xy}\Psi\|^2\ge0.
\tag{7}
\]

Niech \(|\Omega\rangle=\bigotimes_x|1\rangle\).
Każdy składnik \(P_x\) i \(B_{xy}\)
anihiluje ten stan. Zatem
\(H_V|\Omega\rangle=0\).

Jeśli \(|\Psi\rangle\) jest ortogonalny
do \(|\Omega\rangle\), każdy jego
wektor bazowy ma co najmniej jeden
wzbudzony węzeł, więc

\[
\sum_xP_x\ge I-|\Omega\rangle\langle\Omega|.
\]

Stąd dla **dowolnego skończonego grafu**
i dowolnej dopuszczalnej konfiguracji łączy:

\[
\boxed{
H_V\ge48(I-|\Omega\rangle\langle\Omega|).
}
\tag{8}
\]

**Wniosek:** \(\Omega\) jest **jedynym**
stanem podstawowym z dokładnością do
fazy i amplitudy normalizacyjnej,
a pierwszy dodatni poziom ma energię
\(\ge48\) w tej skali. Dowód jest
standardowym argumentem o dodatnim
*frustration-free parent Hamiltonian*.
Nie jest to nowe ogólne twierdzenie
o modelach kwantowych. W kodzie Lean
sprawdzamy lokalną unikalność jądra
oraz dwuwęzłowy wariant, a pełną
sumę na grafie uzasadniamy (7)–(8).

**To nie jest termalizacja.** Zamknięta
unitarna ewolucja sama nie prowadzi
dowolnego stanu do \(\Omega\). Słowo
„stabilny” oznacza tutaj
**dokładny stan podstawowy ze
szczeliną spektralną**, a nie
przyciągający stan dynamiki
dysypatywnej.

## 5. Rzeczywisty transport i kowariancja

Część \(B_{xy}^\dagger B_{xy}\) ma
między bazowymi stanami
\(|a,0\rangle\) i \(|0,b\rangle\)
**niediagonalny element**:

\[
\boxed{
\langle a,0|
B_{xy}^\dagger B_{xy}
|0,b\rangle = -(M_{xy})_{ab}.
}
\tag{9}
\]

Jeżeli \(M\ne0\), wzbudzenie
może przenosić się między węzłami
pod wpływem \(U(t)\). To eliminuje
wcześniejszy no-go VOPM-010
dotyczący zachowania wszystkich
prawdopodobieństw konfiguracji
przez *wyłącznie diagonalne* bramki.

Pod \(g_x,g_y\in G₂\) lokalne stany
wzbudzone transformują się
ortogonalnie, a
\[
M'_{xy}=g_x M_{xy}g_y^{-1}.
\]
Zatem \(B'_{xy}\)
na poprawnie przetransformowanym
stanie zmienia się tylko o \(g_x\).
Norma kwadratowa (5) i energia
(6) są **kowariantne**.

Przykładowa reguła
nie dodaje nowego 240-kanałowego
stanu węzła i pozostaje
w \(\mathbb C^8\otimes\mathbb C^8\)
na dwóch węzłach.

Dla reprezentatywnej
podgrupy \(Q\in G₂\)
skrypt \`checks/check_covariant_gapped_vacuum.py\`
sprawdza **wszystkie 240 jednostek**
i cztery niezależne wybory ram:
\(240\times4=960\) układów.
Weryfikowane są pełne
macierze \(B\), \(\widehat H=4h\),
ich transformacje oraz
dodatnie certyfikaty. Nie jest to
nowy dowód abstrakcyjnej kowariancji
dla każdej macierzy rzeczywistego \(G₂\).

## 5a. Dokładne, zależne od etykiety widmo jednego łącza

W modelu VOPM-015 dyskretny kierunek \(\alpha\) etykietuje
oktonion jednostkowy \(u_\alpha\). W przeciwieństwie do samej
bramki SWAP+CZ z VOPM-012, **jedno-linkowe widmo
wzbudzeń może zależeć od etykiety oktonionowej**.

Dla skrótu \(M=P L_u P\) oznaczmy przez \(M_7\)
jego macierz na siedmiu kierunkach urojonych.
Ponieważ \(L_u\) jest macierzą ortogonalną 8×8
oraz \(L_u(1)=u\), znane twierdzenia o kompresji
izometrii (rozłożenie CS) dają wartości
singularne \(M_7\) równe

\[
1,1,1,1,1,1,\ |\operatorname{Re}u|.
\]

Stąd na sektorze jednego wzbudzenia
dwuwęzłowego układu
\[
H_{1\mathrm{ex}}=48 I_{14}+B^\dagger B,
\quad B=(I_7,-M_7),
\]
więc

\[
\boxed{
\operatorname{spec}(H_{1\mathrm{ex}})
=\underbrace{\{48,\ldots,48\}}_{7}
\cup\underbrace{\{50,\ldots,50\}}_{6}
\cup\{49+(\operatorname{Re}u)^2\}.
}
\tag{10}
\]

Przy \(\operatorname{Re}u=\pm1\) ostatni
poziom zlewa się z innymi poziomami 50.

**Weryfikacja konkretnego VOPM:** skrypt
\`checks/check_covariant_gapped_vacuum.py\`
czyta **wszystkie 240 jednostek**,
dla każdej tworzy dokładną całkowitą
macierz \(K_4=(2M_7)^\top(2M_7)\) i sprawdza
wielomian:

\[
\bigl(K_4-4I\bigr)\,
\bigl(K_4-(2\operatorname{Re}u)^2I\bigr)=0
\]

oraz \(\mathrm{tr}(K_4)=24+(2\operatorname{Re}u)^2\).
Testy prowadzą do **trzech** klas kierunków:

| Klasa jednostki oktonionowej | Liczba etykiet E₈ | Pojedynczy wyróżniony wyższy poziom |
|---|---:|---:|
| \(\operatorname{Re}u=0\) | 126 | 49 |
| \(|\operatorname{Re}u|=1/2\) | 112 | 49.25 |
| \(|\operatorname{Re}u|=1\) | 2 | 50 |

Pozostałe poziomy: siedem przy 48,
sześć przy 50, 49 poziomów
dwuekscytacyjnych przy energii 96
oraz jedno zeroenergetyczne \(|0,0\rangle\).

Liczba \(|\operatorname{Re}u|\)
jest niezmiennicza przy mnożeniu
przez lokalne ramy \(G₂\) po obu
stronach, ponieważ każdy \(g\in G₂\)
zachowuje tożsamość \(1\).
Zatem te klasy są stabilne
wobec przyjętych zmian ram,
choć ich przypisanie do konkretnych
wektorów \(\alpha\) zależy od
wyboru **niekanonicznej mapy**
\(E₈\to\mathbb O\).

**Interpretacja:** jest to
**dokładna, bezwymiarowa, modelowo
specyficzna własność widma**,
która rozróżnia rodzaje etykiet.
Nie jest nową matematyką
kompresji ortogonalnych macierzy
ani żadnym już zmierzonym
stosunkiem mas fizycznych.
Dla całej sieci trzeba jeszcze
sprawdzić, czy takie różnice
są nieusuwalne przez lokalną
zmianę ram i widoczne w
fizycznie zdefiniowanych
wielowęzłowych obserwablach.

## 6. Ograniczenia fizyczne — również te niekorzystne

- **Brak masowo zerowych wzbudzeń**:
  przy stałej dodatniej \(48\)
  model ma szczelinę \(\ge48\)
  i nie wyjaśnia jeszcze bezmasowego
  fotonu, grawitonu czy materii
  chiralnej w podczerwieni.
  Urealnienie takich stopni swobody
  wymaga nowego sektora/fazy
  lub uzasadnionego zamknięcia szczeliny.
- **Próżnia ma postać produktową**:
  \(|\Omega\rangle=\bigotimes|1\rangle\).
  Nie zawiera mikroskopowego
  splątania, nie wyjaśnia
  fluktuacji próżniowego pola.
- **Wybrany spinor nie jest
  spontanicznym parametrem porządku**:
  \(|1\rangle\) wyróżnia już
  bazowa algebra oktonionowa,
  nie spontaniczny wybór spośród
  równoważnych stanów \(S^7\).
- **Zgodność z Elitzurem**:
  lokalna redundancja \(G₂\)
  nie ulega spontanicznemu
  złamaniu przez \(|\Omega\rangle\),
  ponieważ każda automorfizacja
  oktonionów pozostawia \(1\).
- **Wciąż brak 3+1**:
  graf jest ośmiowymiarowy,
  żadna z nowych nierówności
  nie redukuje jego wymiaru.
- **Wciąż brak dynamiki łączy**:
  dane \(\{u_\alpha,g_L,g_R\}\)
  stanowią tło; domknięcie
  przestrzeni operatorów na
  transformacje ram
  **nie jest jeszcze niezależną
  kwantową dynamiką pól cechowania**.
- **Czas pozostaje zewnętrzny**:
  \(\exp(-itH)\) nie wyprowadza
  relatywistycznego czasu ani
  przyczynowości Minkowskiego;
  znane nierówności Lieb–Robinsona
  dotyczą skończenie lokalnych
  Hamiltonianów na grafach.

## 7. Najbliższe recenzowane źródła i testy następnego etapu

1. Elitzur, S. (1975), *Impossibility of spontaneously
   breaking local symmetries*, Phys. Rev. D 12, 3978,
   DOI 10.1103/PhysRevD.12.3978.
2. Baez, J. C. (2002), *The Octonions*, BAMS 39,
   DOI 10.1090/S0273-0979-01-00934-X.
3. Grigorian, S. (2017), *G₂-structures and
   octonion bundles*, Adv. Math. 308,
   DOI 10.1016/j.aim.2016.12.003.
4. de Beaudrap, N., Ohliger, M., Osborne, T. J.,
   Eisert, J. (2010), *Solving Frustration-Free
   Spin Systems*, Phys. Rev. Lett. 105, 060504,
   DOI 10.1103/PhysRevLett.105.060504.
5. Lieb, E. H. i Robinson, D. W. (1972),
   *The Finite Group Velocity of Quantum Spin
   Systems*, Commun. Math. Phys. 28,
   DOI 10.1007/BF01645779.
6. Crowley–Goette–Nordström (2025),
   *An analytic invariant of G₂ manifolds*,
   Invent. Math. 239,
   DOI 10.1007/s00222-024-01310-z.

**Badawcze P1:** wyprowadzić relację
pomiędzy połączeniami \(T_{xy}\)
i wzbudzeniowym widmem
w skali makroskopowej.
Sprawdzić, czy istnieje stabilna
faza o 3 wymiarach przestrzennych,
a nie jedynie ośmiowymiarowa
masywna dyspersja.

**P2:** dać dynamikę
samego pola łączy i ustalić,
czy stan podstawowy nadal
jest produktowy, czy powstaje
nowa niefaza o splątaniu.

**P3:** odróżnić fizyczną
redundancję lokalnych ram
od dodatkowych rzeczywistych
zmiennych \(g_x\).
Sprawdzać pełne \(G₂\)
w algebraicznej reprezentacji,
nie mylić sukcesu testu
podgrupy \(\mathbb Z_2\)
z pełną konstrukcją gauge.

**P4:** porównać
widmo z prostym
\(\mathbb C^8\) modelem
kwantowego hoppingu
na \(\mathbb Z^8\) lub \(D_8\).
Należy wyprowadzić
co najmniej jeden
szczegół widma specyficzny
dla etykiet octavianowych.

## Reprodukcja

\`\`\`bash
python3 checks/check_octavian_bridge.py
python3 checks/literature_benchmarks.py
python3 checks/check_covariant_gapped_vacuum.py
lake build
\`\`\`

Pełny układ \(\mathrm{G2}\)
w Lean to jeszcze **zadanie**.
