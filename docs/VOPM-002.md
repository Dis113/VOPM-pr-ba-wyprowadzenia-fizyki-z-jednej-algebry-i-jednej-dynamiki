# VOPM-002 — unitarna ewolucja jednoskokowa (model pomocniczy)

## Co jest już znane?

**Znana, opublikowana matematyka i fizyka:** dyskretne spacery kwantowe (`U = S C`), przeindeksowanie skończonej sumy przez bijekcję, unitarność permutacji bazy, klasyczne pierwiastki E₈. Nie dowodzimy ich ponownie; używamy ogólnych lematów Mathlib.

Źródła:
- https://pmc.ncbi.nlm.nih.gov/articles/PMC11049270/ — *Efficient Implementation of Discrete-Time Quantum Walks on Quantum Computers* (2024), standardowa konstrukcja DTQW.
- https://github.com/leanprover-community/mathlib4 — twierdzenie `Equiv.sum_comp`.
- Conway–Sloane, *Sphere Packings, Lattices and Groups* — klasyczny układ pierwiastków E₈.

## Dokładna definicja sprawdzanej dynamiki

Dla skończonej, periodycznej siatki `X = (ℤ/Nℤ)^8`, tablicy kroków `r : Fin 240 → X` i permutacji `σ : Fin 8 ≃ Fin 8` stan pomocniczy to

```text
ψ : X × Fin 240 × Fin 8 → ℂ.
```

Jeden takt:

```text
(U ψ)(x,d,a) = ψ(x - r(d), d, σ⁻¹(a)).
```

Jego odwrotność:

```text
(U⁻¹ ψ)(x,d,a) = ψ(x + r(d), d, σ(a)).
```

Różne etykiety `d` reprezentują kanały kierunkowe. **To rozszerzona, jednocząstkowa przestrzeń Hilberta**, z `240 × 8` amplitudami zespolonymi na węzeł (przy takim zapisie). **Nie jest to nadal postulowane 16R na fundamentalny kwant próżni.** Trzeba później znaleźć opis bez tych dodatkowych lokalnych kanałów, lub pokazać, że są one tylko pomocniczym rozbiciem pola na skierowanych krawędziach.

W module Lean `r` jest dowolną tablicą przesunięć. Nie udajemy, że Lean sprawdził jej identyfikację z pierwiastkami E₈.

## Co jest weryfikowane w Lean?

1. Odwracalność ewolucji: `untick_tick` i `tick_untick`.
2. Dokładne zachowanie sumy kwadratów modułów: `probability_tick`.
3. Dokładne zachowanie iloczynu skalarnego: `pairing_tick`.
4. Ograniczenie wpływu jednego taktu do jednego wybranego sąsiada: `tick_apply`, `tick_local` i `tick_source_is_neighbor`.

Stwierdzenia 1–3 są standardową konsekwencją permutacji bazy; ich rola tutaj to **maszynowe sprawdzenie konkretnej implementacji VOPM-002**, nie zgłoszenie nowego ogólnego twierdzenia fizycznego.

## Porównanie z VOPM-001

VOPM-001: liniowy centralny schemat dwukrokowy prowadził przy zadanej kalibracji do warunku `184/15 > 4`, zatem brakowało rzeczywistej częstości w jednym modzie.

VOPM-002: każdy krok jest unitarną permutacją skończonej bazy, zatem zachowuje normę **dla każdego modu i dowolnej liczby iteracji**. Nie występuje analogiczna niestabilność normy. Nie ma też parametru `ρ=Kδ²/M`.

W interpretacji kierunkowej na nieskończonej regularnej sieci, bez permutacji `σ`, fala płaska `e^{ik·x}` w kanale `d` jest własnym stanem przesunięcia, z mnożnikiem `e^{-ik·r_d}`; prędkość grupowa gałęzi to `r_d/δ`. Wybór `|r_d|=ℓ_P` oraz `δ=t_P` dopuszcza **kinematycznie** `|v|=c`. Jest to konsekwencja założonej długości i taktu — **nie wyprowadzenie stałej c z algebry**.

## Dlaczego to jeszcze nie pełne VOPM?

- Sama permutacja nie miesza amplitud liniowo i nie daje typowej interferencji pomiędzy kanałami; następny krok to rzeczywisty lokalny operator mieszający (coin).
- Kierunkowe kanały są nadmiarową strukturą względem 16R na węzeł.
- Nie ma jeszcze oktonionowego asocjatora ani zależności dynamiki od pola tetrad.
- Graf jest stały i periodyczny — brak tworzenia komórek i grawitacji.
- Nie uzyskaliśmy efektywnej symetrii Lorentza 3+1 ani pól Maxwella.

**Wniosek:** znaleźliśmy jawny stabilny, przyczynowo lokalny *model pomocniczy*, który pokazuje, że niestabilność VOPM-001 nie jest nieuchronna dla każdej ewolucji dyskretnej. Następnie trzeba udowodnić tę właściwość dla dużo bardziej restrykcyjnego modelu, w którym pojedynczy węzeł ma dokładnie 8 amplitud zespolonych, a 240 kierunków to wyłącznie etykiety krawędzi i oddziaływań.


## Rozszerzenie VOPM-002b: liniowe mieszanie ośmiu składowych

Plik `VOPM/CoinedWalk.lean` dopuszcza lokalny operator `C : ℂ⁸ ≃ₗ[ℂ] ℂ⁸` (odwracalny liniowy transformator wewnętrznych amplitud) spełniający **jawnie założony** warunek unitarności:

```text
∀u v, Σ_a conj((C u)_a) (C v)_a = Σ_a conj(u_a) v_a.
```

Jeden takt to teraz:

```text
(U ψ)(x,d,a) = [ C (b ↦ ψ(x-r(d), d, b)) ]_a.
```

Formalny wynik `coinedTick_pairing` przenosi zachowanie iloczynu skalarnego
z lokalnego operatora na całe 240-kanałowe pole. Twierdzenie
`coinedTick_local` dowodzi, że **żadna amplituda z innego niż wskazany
sąsiedniego węzła nie wpływa na dany wynik po tym takcie**.

Ten moduł nie nadaje jeszcze `C` konkretnego oktonionowego wzoru:
jego istnienie o zadanej własności to **założenie warunkowe**, a nie
wyprowadzenie z VOPM. Rozszerzenie pozwala jednak badać prawdziwe
superpozycje i interferencję po wyborze niefikcyjnego `C`.
