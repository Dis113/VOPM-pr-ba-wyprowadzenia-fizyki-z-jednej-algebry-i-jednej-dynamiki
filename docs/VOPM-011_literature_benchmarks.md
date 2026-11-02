# VOPM-011 — program badawczy ugruntowany w literaturze, z testami falsyfikacyjnymi

**Data przeglądu: 2 listopada 2026 r.**  
**Stan:** notatka techniczna dla repozytorium VOPM; **nie** recenzowany artykuł ani dowód nowej fizyki.

## 0. Główne ustalenie

Wyniki VOPM-001–010 są poprawnymi *warunkowymi* faktami o konkretnych
dyskretnych konstrukcjach, lecz sama unitarność, 240 pierwiastków E₈
i niezerowy asocjator **nie wystarczają**, aby wyprowadzić teorię
pola w 3+1 wymiarach. W dalszych pracach obowiązują dwa niezależne testy:

1. **Kontrola geometryczna:** sprawdź, czy E₈ daje własność widmową,
   której nie ma prostsza krata D₈ ani Z⁸ przy porównywalnej normalizacji.
2. **Kontrola algebraiczna:** sprawdź, czy uśrednienie asocjatora zachowujące
   symetrię G₂ daje interesujące rozszczepienie widma, a nie tylko
   standardowy singlet i nierozróżnialny multiplet siedmiowymiarowy.

Kod: `checks/literature_benchmarks.py`, wykonywany także w CI.
Zawiera **dokładne** kontrole współczynników wielomianów i 21 macierzy
całkowitoliczbowych oraz **numeryczne** porównanie trzech ustalonych
kierunków fali. Ogólne twierdzenia o E₈ i G₂ pozostają wynikiem znanej literatury.

## 1. Literatura: gdzie VOPM powinien się mierzyć z wcześniejszymi wynikami

| Wynik istniejący | Czego uczy VOPM | Co jest nowością wyłącznie *naszego testu* |
|---|---|---|
| Baez (2002), [The Octonions](https://doi.org/10.1090/S0273-0979-01-00934-X) | Algebra alternatywna, G₂, Clifford, trialność. | Jawny audyt wybranych tabel i operatorów VOPM. |
| Günaydin–Gürsey (1973), [Quark Structure and Octonions](https://doi.org/10.1063/1.1666240) | G₂/SU(3) i kwarki z oktonionów są starszymi pomysłami. | *Nie* zgłaszamy asocjatora jako wyprowadzenia kwarków. |
| Furey (2018), [Three Generations...](https://doi.org/10.1016/j.physletb.2018.08.032); Furey–Hughes (2025), [Three Generations and a Trio of Trialities](https://doi.org/10.1016/j.physletb.2025.139473) | Analiza reprezentacji jest znacznie bardziej szczegółowa niż obecne 0+7 VOPM. | Test, czy obecny Hamiltonian w ogóle rozróżnia docelowe reprezentacje. |
| Bannai–Sloane (1981), [Uniqueness of Certain Spherical Codes](https://doi.org/10.4153/CJM-1981-038-7) | 240 minimalnych kierunków E₈ stanowi sferyczny 7-design; pierwsze sześć momentów jest izotropowych. | Porównanie dyspersji *konkretnego* grafu VOPM z D₈ i Z⁸. |
| Arrighi–Nesme–Werner (2011), [Unitarity plus Causality Implies Localizability](https://doi.org/10.1016/j.jcss.2010.05.004) | Unitarność i lokalna implementowalność automatu nie są nowymi twierdzeniami VOPM. | Sprawdzanie danego harmonogramu bramek i jego rzeczywistego zasięgu. |
| D'Ariano–Perinotti (2014), [Derivation of the Dirac Equation...](https://doi.org/10.1103/PhysRevA.90.062106) | Odtworzenie równania Diraca z QCA już istnieje. | Cel porównawczy: wyprowadzić jawny propagator relatywistyczny z VOPM. |
| Bisio–D'Ariano–Perinotti (2016), [Quantum Cellular Automaton Theory of Light](https://doi.org/10.1016/j.aop.2016.02.009) | Znane modele automatu uzyskują efektywne równania Maxwella. | Nasze przyszłe równania muszą co najmniej osiągnąć porównywalny poziom. |
| Konopka–Markopoulou–Severini (2008), [Quantum Graphity](https://doi.org/10.1103/PhysRevD.77.104029) | Emergentna niskowymiarowa geometria wymaga mechanizmu dynamiki grafu/fazy. | Obecny graf E₈ jest stały: nie deklarować emergencji 3+1. |
| Lieb–Robinson (1972), [The Finite Group Velocity of Quantum Spin Systems](https://doi.org/10.1007/BF01645779) | Dla lokalnych Hamiltonianów ciągłoczasowych istnieją granice propagacji informacji (z ogonami). | Rozróżniać dokładny stożek dla obwodu od granicy typu Lieb–Robinson dla przepływu Hamiltonianowego. |
| Nielsen–Ninomiya (1981), [Absence of Neutrinos on a Lattice](https://doi.org/10.1016/0550-3213(81)90361-8) | Odtwarzanie chiralnych fermionów na lokalnej sieci napotyka ograniczenia przy określonych założeniach. | Trzeba sprawdzić, czy i jak przyszły sektor fermionowy VOPM unika ich hipotez. |
| Maluf (2013), [The Teleparallel Equivalent of General Relativity](https://doi.org/10.1002/andp.201200272) | Sam związek torzji z grawitacją nie jest nowością. | Dopiero wyprowadzenie *dynamicznych* tetrad i współczynnika (1/16\pi G) mogłoby być nowe. |
| Distler–Garibaldi (2011), [There Is No “Theory of Everything” Inside E₈](https://doi.org/10.1007/s00220-010-1006-y) | Istnieją przeszkody reprezentacyjne dla określonych unifikacji cechowania i Lorentza bezpośrednio w E₈. | Nie dotyczą automatycznie grafu pierwiastkowego VOPM; trzeba uważać przy postulowaniu grupy cechowania E₈. |

Dokładne dane źródeł znajdują się w `docs/references.bib`. Wybrano
publikacje recenzowane; preprinty mogą służyć pomocniczo, lecz nie
zastępują pierwszeństwa recenzowanego wyniku.

## 2. Benchmark geometryczny: rzeczywiście mierzalna cecha E₈

Niech `R_E8` będzie zestawem 240 pierwiastków standardowo
znormalizowanych do `|α|²=2` w fizycznym układzie kartezjańskim R⁸.
Dla translacyjnie niezmienniczego, *skalarnego* najbliższego operatora
sąsiedztwa definiujemy:

```math
S_{E_8}(\mathbf k)=\sum_{\alpha\in R_{E_8}}
\bigl(1-\cos(\mathbf k\cdot\alpha)\bigr).
```

Znana własność sferycznego 7-design (Bannai–Sloane) implikuje dokładne
identyczności wielomianowe:

```math
\sum_\alpha(\alpha\cdot\mathbf k)^2=60|\mathbf k|^2,\quad
\sum_\alpha(\alpha\cdot\mathbf k)^4=36|\mathbf k|^4,\quad
\sum_\alpha(\alpha\cdot\mathbf k)^6=30|\mathbf k|^6.
```

Stąd w podczerwieni:

```math
S_{E_8}(\mathbf k)=30|\mathbf k|^2-
\frac32|\mathbf k|^4+\frac1{24}|\mathbf k|^6-
\frac1{40320}\sum_\alpha(\alpha\cdot\mathbf k)^8
+O(|\mathbf k|^{10}).
```

**Ważna granica:** obrotowa izotropia zachodzi w *ośmiu*, nie
automatycznie w trzech wymiarach. Dla tego skalarnego operatora
jego symbol kwadratowy ma **rangę 8** i nie występuje mechanizm
obniżenia wymiaru przestrzennego do 3.

Dokładny test programu (wyliczenie współczynników *wszystkich*
monomów) obejmuje 36, 330 i 1716 współczynników odpowiednio
dla stopni 2,4,6 — jest to kontrola danych i arytmetyki, nie
nowy dowód twierdzenia o designach.

Pierwsze różnice kierunkowe pojawiają się przy potędze ósmej:

```math
M_8(e_1)=\frac{57}{2},\qquad
M_8\left(\frac{e_1+e_2}{\sqrt2}\right)=39.
```

### Kontrole negatywne, bez arbitralnej przewagi wynikającej ze skali prędkości

Porównanie `E₈` (240 kierunków), `D₈` (112) i
sześciennej `\mathbb Z^8` (16 kierunków) zostało wykonane
z taką samą jednostką długości najkrótszego łącza
`ℓ` i tym samym współczynnikiem `t²` w rozwinięciu
bezwymiarowego symbolu:

```math
\widehat S_G(t,u)=\frac{\ell_G^2}{
\frac12\sum_{r\in R_G}r_1^2}
\sum_{r\in R_G}\left(1-\cos\left(\frac{t}{\ell_G}
u\cdot r\right)\right),\qquad |u|=1.
```

Pomiar: trzy **z góry ustalone** kierunki
`e₁`, `(e₁+e₂)/√2` oraz `(e₁+...+e₈)/√8`.
`spread=(max-min)/mean` jest tylko rozpiętością w tej
próbie, **nie globalną granicą dla wszystkich kierunków**.

| `kℓ` | `E₈` | `D₈` | `Z⁸` |
|---:|---:|---:|---:|
| 0.75 | 0.0000194% | 1.176% | 4.119% |
| 1.50 | 0.0012473% | 4.747% | 16.675% |
| 2.00 | 0.0070558% | 8.520% | 29.980% |

**Interpretacja uczciwa:** E₈ ma istotną, dobrze udokumentowaną
zaletę kierunkowej izotropii *tego* dyskretnego symbolu;
porównywane grafy mają inną liczbę sąsiadów. Nie oznacza to,
że E₈ jako jedyne dopuszcza wyprowadzenie praw fizycznych
lub że sam skalarno-kwadratowy symbol odtwarza światło:
`\omega\propto|k|^2` dla zwykłego Hamiltonianu hoppingowego
jest dyspersją Schrödingera, **nie** relatywistyczną `\omega=c|k|`.

## 3. Benchmark algebraiczny: 21 asocjatorów i symetria G₂

Zgodnie ze standardową alternatywnością algebry oktonionowej:

```math
A_{ij}=L_{e_i}L_{e_j}-L_{e_ie_j},
\quad 1\le i<j\le7.
```

Niezależne obliczenia na całkowitoliczbowych macierzach 8×8
dla **wszystkich 21 par** dają:

```math
H_{\mathrm{sym}}=
\sum_{1\le i<j\le7} A_{ij}^{\dagger}A_{ij}
=48\left(I-P_{\mathbf1}\right)
=\operatorname{diag}(0,48,48,48,48,48,48,48).
```

Zbieżność z symetrią `G₂=Aut(\mathbb O)` jest naturalna,
ponieważ automorfizmy utrzymują jednostkę `1` i ortogonalnie
działają na siedmiowymiarowej części urojonej. Projektor
na `\operatorname{Im}\mathbb O` jest zatem niezmienniczy.

**Granica nowości:** to klasyczna algebra zastosowana do
naszej reprezentacji macierzowej, **nie nowe twierdzenie
o budowie fizycznych generacji**. Przy pełnej symetrii
pozostaje rozkład `1\oplus7`: obecny Hamiltonian nie
wyodrębnia leptonów, kwarków ani trzech pokoleń.

Ważny kompromis: VOPM-010 z jedną parą `(i,j)` daje
`0[\times4]+4[\times4]`, lecz wybór pary wyróżnia
określoną podalgebrę kwaternionową. Symetryczna suma
usuwa arbitralny wybór pary, ale zarazem daje
`0[\times1]+48[\times7]`.

**Status kontroli:** wszystkie 21 macierzy i równość
ich sumy zostały sprawdzone **dokładnymi liczbami
całkowitymi** przez kod Python. To nie jest jeszcze
osobny dowód tej równości wewnątrz jądra Lean.
Natomiast pojedynczy Hamiltonian z VOPM-010 jest
sprawdzony formalnie w Lean 4.

## 4. Model zerowy do falsyfikacji: 8D i brak relatywistycznych multipletów

Aby oddzielić fizyczną treść od samej kompilacji,
rozważmy celowo prosty dodatkowy **ansatz**:

```math
H_{\mathrm{null}}(\mathbf k)
=\frac{S_{E_8}(\mathbf k)}{30}I_8+
m P_{\operatorname{Im}\mathbb O}.
```

Nie wynika on jednoznacznie z algebry: parametr `m` i
dodawanie dwóch operatorów są postulatem.
Jego widmo jest jednak wyliczalne od razu:

```math
E_0(\mathbf k)=S_{E_8}(\mathbf k)/30,
\qquad
E_{1,\ldots,7}(\mathbf k)=S_{E_8}(\mathbf k)/30+m.
```

To **jedna** gałąź bez szczeliny i **siedem**
zdegenerowanych gałęzi, a całość nadal rozchodzi się
po **ośmiu kierunkach**. Dla ewolucji Schrödingera
w podczerwieni energia jest kwadratowa w `|k|`.
Nie otrzymujemy fermionów chiralnych ani pola Maxwella.

Taki **model kontrolny** będzie służył do sprawdzania
każdej następnej, bardziej złożonej mikrodynamiki.
Jeśli nowy operator nie daje obserwowalnej różnicy
w porównaniu z `H_null`, sama obecność symboli
`E₈` i oktonionów nie oznacza nowej fizyki.

## 5. Warunki, które wynikają z literatury, a nie ze spekulacji

1. **Lorentz/Dirac/Maxwell:** zgodnie z D'Ariano–Perinotti
   i Bisio i in. trzeba rzeczywiście wyprowadzić w granicy
   `k→0` operator pierwszego rzędu i właściwe liczby
   polaryzacji; nie wystarczy kwadratowa fala skalarna.
2. **Kauzalność:** dla obwodu o ograniczonej głębokości
   można wskazać ostry stożek przyczynowy, natomiast
   ciągłoczasowy Hamiltonian lokalny spełnia
   zwykle nierówności typu Lieb–Robinson.
3. **Fermiony:** należy jawnie odnieść przyszły operator
   chiralny do warunków twierdzenia Nielsena–Ninomiyi,
   nie twierdzić, że samo `E₈` je omija.
4. **3+1:** zgodnie z fizyką kwantowej graphity potrzebny
   jest dynamiczny mechanizm fazowy lub geometryczny,
   nie wybór trzech osi z ośmiu.
5. **Grawitacja:** aby powołać się na TEGR, trzeba
   wyprowadzić zmienne tetradowe, skręcenie i poprawną
   dynamikę; same etykiety torzji nie są grawitacją.
6. **Model Standardowy:** multiplet 7 nie jest
   automatycznie trzema pokoleniami; porównać szczegółowo
   z Furey 2018 i 2025, bez deklaracji odkrycia kwarków.

## 6. Priorytety badawcze i warunki publikacyjności

**P1 — jedna reguła transportu.** Zbudować naprawdę
niediagonalną, lokalną i unitarną regułę na prymitywnych
krawędziach E₈. Zmierzyć widmo, grupowe prędkości oraz
różnicę do `H_null`.

**P2 — faza wymiarowa.** Z tej samej dynamiki wyliczyć
stabilną fazę z trzema kierunkami niskoenergetycznymi
i czwartym wymiarem czasowym (nie postulat redukcji).
Weryfikować wymiar spektralny lub inny dobrze określony
wskaźnik wymiaru w funkcji skali.

**P3 — pola i chiralia.** Wyprowadzić co najmniej jedną
strukturę Weyla/Diraca lub U(1) z policzalną relacją
dyspersyjną; sprawdzić no-go dla duplikacji fermionów.

**P4 — falsyfikowalność.** Dostarczyć wielkość bezwymiarową
lub skuteczną relację, której nie daje prostszy graf
kontrolny ani znane automaty.

**Status końcowy:** VOPM ma obecnie mocniejsze
uzasadnienie wyboru E₈ jako geometrycznej sieci
niskoanizotropowej oraz jawny symetryzowany operator
oktonionowy. Żadna z tych zalet sama nie dowodzi
jednej fizycznej mikrodynamiki ani obserwowanych stałych.

## Reprodukcja

```bash
python3 checks/check_e8_basis.py
python3 checks/check_associator.py
python3 checks/literature_benchmarks.py
lake build
```

Kontrole Python używają wyłącznie biblioteki standardowej.
`checks/literature_benchmarks.py` importuje istniejące
generatory tabel zamiast tworzyć alternatywną implementację
tych samych danych. GitHub CI uruchamia te testy automatycznie.
