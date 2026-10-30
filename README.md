# VOPM — algebra, dynamika, dowody (Lean 4)

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

Zdefiniować i sprawdzić odmianę **unitarnej lokalnej ewolucji** dla skończonego grafu oraz związek jej widma z powyższym modelem drugiego rzędu. Dopiero potem badać odtwarzanie symetrii Lorentza i dynamicznych tetrad.

## Literatura / implementacje, zamiast ponownych dowodów

- [Mathlib4](https://github.com/leanprover-community/mathlib4) — istniejące formalizacje i tożsamości analityczne.
- [E₈ root system](https://en.wikipedia.org/wiki/E8_(mathematics)#Root_system) — standardowe współrzędne i liczności.
- Conway & Sloane, *Sphere Packings, Lattices and Groups* — standardowe źródło dotyczące krat i E₈.

Każde twierdzenie oznaczamy jako: **znany wynik** / **warunkowy wniosek VOPM** / **hipoteza** / **test obserwacyjny**.
