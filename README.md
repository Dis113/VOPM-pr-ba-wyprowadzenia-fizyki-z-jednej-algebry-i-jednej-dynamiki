# VOPM — algebra, dynamika, dowody (Lean 4)

> **Stan badań (2 listopada 2026):** formalnie zweryfikowane są wybrane konstrukcje
> dyskretne, unitarność i Hamiltonian asocjatora; **nie** istnieje jeszcze
> wyprowadzenie grawitacji, pól cechowania, generacji fermionów, wymiaru 3+1
> lub wartości stałych z jednej mikrodynamiki.
>
> 
**VOPM-015 — jedna lokalna reguła dodatniego transportu i gapped vacuum:**

- `VOPM/GappedVacuum.lean` definiuje `48P_im`, lokalną próżnię
  `|1⟩∈ℂ⁸`, dodatni dwuwęzłowy operator
  `B_xy†B_xy+B_yx†B_yx` z niediagonalnym hoppingiem
  **niezależnym od wyboru zwrotu krawędzi** oraz twierdzenia
  o jednoznaczności zeroenergetycznego stanu na parze węzłów;
- `VOPM/ClosedFrames.lean` sprawdza domknięcie **niebanalnej
  podgrupy ℤ₂⊂G₂** na niezależne lokalne zmiany ram, bez
  twierdzenia, że samo `{L_u}` jest pełną lokalną teorią cechowania;
- `checks/check_covariant_gapped_vacuum.py` certyfikuje
  wszystkie 240 operatorów octavianowych × 4 wybory
  ram, dodatniość oraz dokładne widmo dwuwęzłowego
  Hamiltonianu na `ℂ⁸⊗ℂ⁸`; trzy klasy octavianowych
  kierunków o `|Re(u)|=0,1/2,1` mają odpowiednio 126,112,2 etykiety;
- [VOPM-015 — model, formalizacja i istotne ograniczenia](docs/VOPM-015_gapped_covariant_vacuum.md).

**Ważne ograniczenie:** próżnia jest **energetycznie
stabilna, lecz nie jest spontanicznym złamaniem
lokalnego G₂** (Elitzur 1975). Ściśle lokalne połączenia
nadal są tłem, czas w Hamiltonianie jest zewnętrzny,
a szczelinowy model nie odtwarza bezmasowego
światła, grawitonu lub wymiarów 3+1.

**VOPM-014 — istotna korekta interpretacji holonomii (Clifford + G₂):**

- [audyt literaturowy i ścisłe ograniczenia](docs/VOPM-014_g2_trace_audit.md);
- `VOPM/G2TraceAudit.lean`: kontrprzykład dla nieautomorficznego
  odbicia urojonego oraz jawny **czterokrawędziowy** świadek
  trójformy (G₂);
- `checks/check_g2_trace_blindspot.py`: niezależna dokładna
  weryfikacja wszystkich 13 440 trójkątów:
  **ich ślady są całkowicie określone przez dane metryczne Clifforda**,
  bez potrzeby trójformy (G₂). Dla każdego trójkąta
  `φ(Im Φ(α),Im Φ(β),Im Φ(γ))=0`, ponieważ `α+β+γ=0`;
- `VOPM/LocalGaugeObstruction.lean`: **formalne ograniczenie
  lokalnego G₂**. Niebanalny automorfizm `Q∈G₂` nie może być
  utożsamiony z lewym mnożeniem `L_u` dla żadnego oktonionu;
  niezależne zmiany ram na końcach krawędzi wyprowadzają
  operator poza dotychczasową rodzinę `{L_u}` —
  to ograniczenie **obecnego ansatzu**, nie całych teorii G₂;
- **spinorowy punkt odniesienia:** 343 kombinacje bazowych
  jednostek sprawdzają znaną relację między trójformą
  `G₂` a elementem macierzowym `⟨s,L_zL_yL_x s⟩`;
  zwykły ślad pozostaje zerowy (Crowley–Goette–Nordström 2025);
- istnieje nieautomorficzna izometria całego zbioru jednostek,
  która zachowuje **wszystkie** wcześniejsze ślady trójkątów —
  poprzedni test z VOPM-013 był zbyt słaby do wykazania
  szczególnego znaczenia symetrii (G₂);
- prawdziwy **czterokrawędziowy** cykl `(0,1,6,7)` ma
  trójformę na niezależnym prefiksie `φ=-1/2`;
  po tej nieautomorficznej izometrii `φ=+1/2`.
  **Nie** jest to jeszcze obserwabla niezmiennicza względem
  niezależnych lokalnych transformacji cechowania.

To zastosowania znanych faktów o kalibracjach (G₂), Cliffordzie
i stratach informacji po śladowaniu holonomii
(Baez 2002; Harvey–Lawson 1982; Bryant 1987;
Faraji 2026), **nie nowy ogólny dowód tych twierdzeń**.

**VOPM-013 — sprawdzanie nietrywialnych połączeń z literaturą:**

- `VOPM/OctavianHolonomy.lean`: dla `k(ji)=1` kompozycja
  lewych operatorów nie jest jednością:
  `L_k L_j L_i = I - H_assoc/2` — ta sama projekcja
  występuje jako energia asocjatora i odbicie transportu;
- `checks/check_octavian_holonomy.py`: dokładne, poprawnie odwracane
  transporty po **13 440 zamkniętych trójkątach E₈**, rozkład
  śladów operatorowych i test zmiany izometrycznej identyfikacji
  korzeni z jednostkami oktonionów;
- siedem lewych generatorów urojonych spełnia relacje
  `Cl(0,7)`, lecz pełne osiem niezależnych hermitowskich
  generatorów wymaga większej przestrzeni spinorowej;
- [VOPM-013: holonomia algebraiczna, trójkąty E₈,
  Clifford i ograniczenia](docs/VOPM-013_holonomy_clifford.md).

**Ostrożność:** poprawne ślady typu Wilsona nie są jeszcze
obserwablami cechowania, dopóki nie określimy prawa transformacji
lokalnych ram. Matematyka pętli Moufanga i Clifforda jest znana
z prac Grigoriana (2021), Feingolda i in. (2009),
Kleinschmidta i in. (2012) oraz Krasnova (2024).

**VOPM-012 — jawny most E₈–oktoniony (wynik konstrukcyjny):**
- `VOPM/OctavianBridge.lean` zawiera osiem oktonionowych pierwiastków
  prostych, mapę na 240 elementów i dowód zgodności ich macierzy Grama;
- `VOPM/OctavianProduct.lean` formalizuje konwencję Cayleya–Dicksona
  i jawny kontrprzykład: odbicie Weyla E₈ nie musi zachowywać iloczynu;
- `checks/check_octavian_bridge.py` kontroluje dokładnie 240 jednostek,
  57 600 produktów oraz 57 600 par iloczynów skalarnych;
- `checks/check_octavian_gate.py` sprawdza trzy konkretne macierze 64×64
  dwuwęzłowej bramki transportującej i splątującej.

Podstawa literaturowa: Conway–Smith, *On Quaternions and Octonions*,
Koca–Özdes (1989), Dray–Manogue, *Geometry of the Octonions*.
**To nie są nowo odkryte własności algebry.** Wybrana mapa jest
niekanoniczna, a sprzężenie fazowe i harmonogram są postulatami.
Dynamika 3+1, fermiony, grawitacja, cechowanie i stałe fizyczne
pozostają niewyprowadzone. Pełny zakres:
[certyfikat i ograniczenia VOPM-012](docs/VOPM-012_octavian_link_proposal.md).

**Nowe uzupełnienie literaturowo-testowe:**
> [VOPM-011 — literatura, kontrolne kraty i symetryzacja G₂](docs/VOPM-011_literature_benchmarks.md),
> [pełna bibliografia BibTeX](docs/references.bib),
> [kandydat transportu przez jednostki oktonionowe E₈](docs/VOPM-012_octavian_link_proposal.md),
> [odtwarzalny skrypt](checks/literature_benchmarks.py).
>
> **Weryfikacja bez dublowania klasycznych twierdzeń:**
> Bannai–Sloane (1981) gwarantuje 7-design pierwiastków E₈;
> Baez (2002) opisuje klasyczną strukturę oktonionów i G₂;
> literatura QCA i kwantowej graphity określa testy niezbędne dla
> emergentnej fizyki. Nasze skrypty sprawdzają *instancje VOPM*,
> nie twierdzą, że ponownie udowadniają te wyniki.

Eksperymentalny program matematyczny badający dyskretną dynamikę związaną z geometrią E₈ i potencjalnie z algebrą zespolonych oktonionów.

**Status: program badawczy, nie potwierdzona teoria fizyczna.** Kod sprawdza warunkowe twierdzenia dotyczące *konkretnego* wariantu dynamiki, a nie pełną unifikację.

## Zasada: nie powtarzamy istniejących dowodów

Korzystamy z gotowych wyników literatury i [Mathlib](https://github.com/leanprover-community/mathlib4), gdy tylko są dostępne. W szczególności:
- definicja i klasyfikacja systemu pierwiastków E₈, 240 pierwiastków oraz ich standardowe współrzędne — **znane fakty matematyczne**, nie nowe wyniki VOPM;
- standardowe tożsamości trygonometryczne — używamy Mathlib;
- oktoniony, algebra Clifforda, TEGR — ich klasyczne własności nie są tu dowodzone ponownie.

Nowe zadanie: **sprawdzić, co wynika z konkretnego schematu aktualizacji**, gdy standardowe fakty wykorzystamy jako wejście.

## Moduł 001: warunkowe ograniczenie stabilności

Plik `VOPM/Dispersion.lean` analizuje *liniową* aktualizację drugiego rzędu na sieci E₈:

```text
(q[n+1,x] - 2 q[n,x] + q[n-1,x]) / δ²
   = (K/M) Σ_{α ∈ roots(E₈)} (q[n,x+α] - q[n,x]).
```

Dla fal skierowanych wzdłuż jednej osi sieci, klasyczna enumeracja pierwiastków daje:
- 28 pierwiastków z pierwszą współrzędną ±1;
- 128 pierwiastków z pierwszą współrzędną ±1/2;
- 84 pierwiastki z zerową pierwszą współrzędną.

Otrzymujemy symbol:

```text
S(κ) = 28 (1 - cos κ) + 128 (1 - cos(κ/2)).
```

W szczególności `S(π) = 184`. Dla wymiarowego parametru `ρ = (K/M) δ²` niezbędnym warunkiem istnienia rzeczywistego modu częstości jest `ρ S(π) ≤ 4`.

Prędkość długofalowa spełnia `v² = 30 (K/M) a²`. Jeśli założymy **jednocześnie** długość najkrótszej krawędzi `√2 a = ℓ_P`, takt `δ = t_P`, i `v = c = ℓ_P/t_P`, to z równania prędkości wynika `30 a² ρ = 2 a²`, zatem `ρ = 1/15`.

Wtedy `ρ S(π) = 184/15 > 4`: **żadna rzeczywista częstość nie spełnia wymaganej relacji dyspersyjnej dla tego modu**. W tym konkretnym jawnym schemacie pełne trzy identyfikacje Planckowskie nie mogą być spełnione jednocześnie z oscylacyjną stabilnością tego modu.

**Granica wniosku:** nie obala to całego VOPM. Wymaga zmiany schematu kroku, lokalnego operatora lub interpretacji długości/taktu. Obecny moduł **nie** wyprowadza elektromagnetyzmu, TEGR ani czasoprzestrzeni 3+1.

## Formalny status twierdzeń

- `axialSymbol_at_pi`: obliczenie symbolu z **założonych, znanych** liczności pierwiastków;
- `stableAtPi_of_real_dispersion`: ogólny warunek konieczny wynikający z `sin² ≤ 1`;
- `forcedPlanckRatio`: wymuszenie `ρ = 1/15` przy określonej kalibracji;
- `noStablePlanckAxialMode`: wykluczenie warunku stabilności;
- `noRealPlanckAxialFrequency`: brak rozwiązania z rzeczywistą częstością w tym trybie.

To są **warunkowe twierdzenia**. W pliku Lean nie ma definicji całej sieci E₈, kwantowej dynamiki oktonionowej ani dowodu jej granicy hydrodynamicznej. Warstwa fizyczna pozostaje jawnym zestawem hipotez.

## Reprodukcja

Zainstaluj [elan](https://github.com/leanprover/elan) i Git. Następnie:

```bash
lake update
lake exe cache get
lake build
```

Repozytorium przypina wersję Mathlib i odpowiadającą jej wersję Lean. GitHub Actions kompiluje bibliotekę w Lean (z kontrolą jądra Lean przy opracowaniu twierdzeń) oraz odrzuca znaczniki `sorry`, `admit` i nowe `axiom` w kodzie VOPM. Dodatkowy niezależny program `leanchecker` jest na razie wyłączony: w przypiętym środowisku Lean 4.36.0-rc2 / Mathlib zakończył się SIGSEGV (exit 139) mimo pomyślnej kompilacji; jego poprawność należy zbadać osobno.

## Kolejny etap

Obecnie istnieją moduły formalizujące lokalną przestrzeń `ℂ⁸`,
pełną przestrzeń wielu węzłów, operator oktonionowy,
asocjator i unitarne bramki na prymitywnych krawędziach E₈.
Nadal są to **prototypy**, a część sprzężeń jest postulowana.

Kolejne priorytety to: **(1)** Hamiltonian z faktycznym transportem,
**(2)** mechanizm redukcji do 3+1 wynikający z wyliczonej fazy,
**(3)** widmo fermionowe/polaryzacje i **(4)** unikatowe przewidywanie
bezwymiarowe. Testem zerowym jest prosty 8D Hamiltonian
`H_null(k)=S_E8(k)/30·I₈+m·P_im`, którego widmo pozostaje 1+7,
a propagacja nie jest ani Diracowska, ani 3+1.

### Aktualne moduły

- `VOPM/Dispersion.lean`: ograniczenia `ρ≤1/46` i `ρ≤1/64`
  dla określonego centralnego kroku, nie twierdzenie obalające VOPM;
- `VOPM/E8Basis.lean`: 240 pierwiastków w prymitywnej bazie E₈;
- `VOPM/EightComponent.lean`, `VOPM/ManyBody.lean`:
  osiem stanów zespolonych na węzeł oraz baza wielu węzłów;
- `VOPM/E8ManyBody.lean`: lokalny, unitarny harmonogram bramek;
- `VOPM/OctonionicCoin.lean`, `VOPM/Associator.lean`:
  konkretny operator mnożenia i dodatni Hamiltonian niełączności;
- `VOPM/AssociatorManyBody.lean`: dwuwęzłowa dynamika fazowa
  i ścisła przeszkoda dla transportu amplitud w bazie obliczeniowej;
- `checks/literature_benchmarks.py`: niezależna kontrola izotropii
  E₈, porównanie z D₈ i Z⁸ oraz uśrednione 21 asocjatorów.

**Nowy wynik kontrolny VOPM-011 (Python, nie Lean):**
`∑_{1≤i<j≤7} A_ij†A_ij = 48(I−P_1)`.
Stanowi to zachowanie bardziej symetryczne względem G₂, lecz samo
nie dzieli siedmiu kierunków urojonych na generacje.


## Literatura / implementacje, zamiast ponownych dowodów

- [Mathlib4](https://github.com/leanprover-community/mathlib4) — istniejące formalizacje i tożsamości analityczne.
- [E₈ root system](https://en.wikipedia.org/wiki/E8_(mathematics)#Root_system) — standardowe współrzędne i liczności.
- Conway & Sloane, *Sphere Packings, Lattices and Groups* — standardowe źródło dotyczące krat i E₈.

Każde twierdzenie oznaczamy jako: **znany wynik** / **warunkowy wniosek VOPM** / **hipoteza** / **test obserwacyjny**.
