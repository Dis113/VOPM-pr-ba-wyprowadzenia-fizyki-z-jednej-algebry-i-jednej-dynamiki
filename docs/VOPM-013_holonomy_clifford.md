# VOPM-013 — asocjator, zamknięty transport i trójkąty E₈

**Data przeglądu: 2 listopada 2026 r.**  
**Status:** konstrukcja algebraiczna + dokładne certyfikaty implementacji.
Znane twierdzenia o oktonionach, Cliffordzie, pętlach Moufanga
i holonomii nie są ogłaszane jako nowe. **Nie** jest to jeszcze
krzywizna fizycznej czasoprzestrzeni ani wyprowadzenie teorii cechowania.

## I. Najważniejsze połączenie: energia asocjatora jako odbicie transportu

Przypomnijmy opublikowaną już konwencję mnożenia Cayleya–Dicksona:

- \`i=e₁\`, \`j=e₂\`, \`k=e₃=ij\`;
- kwaternionowy podukład \`Q=span_C(1,i,j,k)\`;
- \`P_⊥\` jest rzutem na \`span_C(ℓ,iℓ,jℓ,kℓ)\`.

W VOPM-010 obliczono i zweryfikowano w Lean:

\`\`\`math
A=L_iL_j-L_k,\qquad H_{\rm assoc}=A^\dagger A=4P_\perp.
\`\`\`

**Osobny, nietrywialny krok połączenia znanych tożsamości:**

\`\`\`math
k\,(j\,i)=1 \quad\text{jako iloczyn oktonionowy, ale}\quad
\mathcal T:=L_kL_jL_i
  = I-2P_\perp = I-\frac12 H_{\rm assoc}\neq I.
\`\`\`

\`\`\`math
\mathcal T^2=I,\quad \mathcal T^\dagger\mathcal T=I,\quad
\mathrm{spec}(\mathcal T)=\{+1\ [\times4],-1\ [\times4]\}.
\`\`\`

**Interpretacja:** zamknięty *algebraicznie* word pętli jednostkowych
oktonionów ma nietrywialną reprezentację przez złożenie lewych
operatorów. W podalgebrze kwaternionowej \`Q\` nie ma tej różnicy;
na czterech pozostałych współrzędnych jest odbicie. Oznacza to,
że **ten sam projektor \`P_⊥\` pojawia się niezależnie jako energia
asocjatora i jako defekt transportu w reprezentacji operatorowej**.

To nie jest nowe twierdzenie o pętlach Moufanga: wynika ze
znanych praw alternatywności, lecz VOPM-013 podaje jawny
**dowód koordynatowy w Lean**, łączący dwa wcześniejsze moduły.

**Ważne:** \`k*(j*i)=1\` to zamknięty iloczyn w niełącznej
pętli jednostek, **nie** automatycznie trójkąt geometryczny
na kracie. Nie nazywać go krzywizną czasoprzestrzeni.

## II. Prawdziwe pętle trójkrawędziowe na E₈

Wybieramy **z góry** konwencję orientacji każdej pary \`±α\`:
pierwsza niezerowa współrzędna kartezjańska dodatnia.
Dla każdego dodatnio zorientowanego pierwiastka
\`α\` przypisujemy \`U_α=L_{Φ(α)}\`, gdzie \`Φ\` jest
ustaloną w VOPM-012 izometrią na jednostki całkowitych oktonionów.
Dla przeciwnego kierunku **stosujemy operator odwrotny**:

\`\`\`math
U_{-\alpha}=U_\alpha^{-1}=L_{\overline{\Phi(\alpha)}}.
\`\`\`

Dlaczego? Ponieważ \`Φ(-α)=-Φ(α)\`, a
\`-u\ne\overline{u}\` dla ogólnej jednostki \`u\`.
Naiwne \`U_{-\alpha}=L_{Φ(-α)}\` jest zatem błędną
regułą odwracania transportu, nawet jeśli osobne operatory
zachowują normę.

W nieskończonej kracie korzeni \`E₈\` trójkąt
wokół ustalonego węzła spełnia

\`\`\`math
\alpha,\beta,\gamma\in\mathcal R(E_8),\qquad
\alpha+\beta+\gamma=0.
\`\`\`

To daje 240×56 = **13 440 zorientowanych trójek**
(odpowiadających 2240 trójkątom, gdy utożsamiamy
cykliczne permutacje i odwrócenie orientacji).

Definiujemy **diagnostyczną** liczbę operatorową
(zwaną poniżej *śladem typu Wilsona*, NIE fizyczną
obserwablą cechowania):

\`\`\`math
\mathcal W_{\alpha\beta\gamma}
=\frac18\mathrm{tr}
\bigl(U_\gamma U_\beta U_\alpha\bigr).
\`\`\`

Dokładny test oparty na macierzach całkowitych (bez
tolerancji numerycznych) dał dla wybranej izometrii i orientacji:

| \(\mathcal W\) | Liczba zorientowanych trójek |
|---:|---:|
| \(-1/2\) | 3072 |
| \(0\) | 7632 |
| \(+1/2\) | 2736 |
| **Łącznie** | **13 440** |

Kontrola: przy przypisaniu wszystkim krawędziom tożsamości
\`U_α=I\` wszystkie 13 440 trójkątów mają \(\mathcal W=1\).
Nasz rozkład nie jest więc tylko liczbą geometrycznych
trójkątów, lecz zależy od konkretnych transportów.

To **konkretny, modelowo zależny test operacji na
całej sieci**. Jego poprawność weryfikuje
\`checks/check_octavian_holonomy.py\`, nie jest to
twierdzenie formalnie udowodnione w Lean dla wszystkich
13 440 trójek.

**Zastrzeżenie fundamentalne:** ponieważ nie ustalono jeszcze
transformacji lokalnych układów odniesienia
\`U_{xy}\mapsto g_y U_{xy}g_x^{-1}\` jako symetrii mikrodynamiki,
nie nazywamy tego automatycznie wielkością cechowania.
Ślady standardowych, macierzowych operatorów pętli są
znane od Wilsona (1974); nowym zadaniem VOPM jest
wykazanie **konsekwencji nietrywialnych etykiet oktonionowych**,
nie ponowny dowód samej teorii śladów.

### Niekanoniczność mapy \(\Phi\) — kluczowy test jednoznaczności

Rozważmy drugą izometrię \(\Phi'=r_1\circ\Phi\),
gdzie \`r₁\` jest odbiciem Weyla względem pierwiastka
rzeczywistej jednostki \`1\`. Działa ono w wybranej
bazie jako \`(u₀,u₁,...,u₇) → (-u₀,u₁,...,u₇)\`,
zachowuje zbiór 240 pierwiastków, ale **nie jest**
automorfizmem mnożenia oktonionowego.

Po zastosowaniu tej samej konwencji orientacji
i odwrotności krawędzi dokładne histogramy zmieniają się:

| \(\mathcal W\) | Oryginalna \(\Phi\) | Odbita \(\Phi'\) |
|---:|---:|---:|
| \(-1/2\) | 3072 | 2736 |
| \(0\) | 7632 | 7632 |
| \(+1/2\) | 2736 | 3072 |

Dla **każdego** sprawdzonego trójkąta ślad zmienia znak.
Jest to ważny wynik **negatywny dla predykcji bez
określenia mapy \(\Phi\)**: sama abstrakcyjna geometria
E₈ i abstrakcyjna algebra oktonionowa nie wyznaczają
jeszcze unikatowego rozkładu transportów na grafie.

Nie nazywamy tego wykryciem naruszenia symetrii fizycznej.
Wymaga to jawnego określenia, czy dwie identyfikacje
są fizycznie równoważne oraz jaka jest dopuszczalna
grupa transformacji lokalnych.

## III. Drugie nietrywialne połączenie: Clifford i problem wymiaru

Znany klasyczny fakt (Baez 2002; Krasnov 2024):
lewe mnożenia przez siedem urojonych jednostek
oktonionów spełniają relacje Clifforda:

\`\`\`math
J_aJ_b+J_bJ_a=-2\delta_{ab}I_8,
\qquad J_a=L_{e_a},\quad a,b=1,\dots,7.
\`\`\`

W VOPM testujemy **dokładną tablicę znaków**
dla 7×7 par macierzy 8×8 z danych Cayleya–Dicksona.

Dla operatora pierwszego rzędu
\`D_7(\mathbf k)=i\sum_{a=1}^7 k_aJ_a\`,
te znane tożsamości dają
\`D_7(\mathbf k)^2=|\mathbf k|^2 I_8\`.
Jest więc dostępny naturalny **siedmiokierunkowy**
algebraiczny symbol Diraca, bez arbitralnych macierzy
gamma. Nie daje on jednak spontanicznie trzech
kierunków przestrzennych.

Co więcej, kompleksowa algebra Clifforda dla **ośmiu**
niezależnych euklidesowych generatorów ma
\`Cl_8(C) ≅ Mat_16(C)\`: w standardowej
8D hermitowskiej reprezentacji pełnego odd
Hamiltonianu Diraca wymaga to co najmniej
**16 zespolonych** składowych, a nie \`C^8\`.

**To precyzyjne ograniczenie zakresu:** nie można
jednocześnie zakładać lokalnego ośmiowektorowego
symbolu pierwszego rzędu
\`H(k)=\sum_{a=1}^8 k_a\Gamma_a\`
z **ośmioma** wzajemnie antykomutującymi macierzami
hermitowskimi \`8×8\` i niezmienionej \`C^8\`.
Możliwe obejścia (inne przestrzenie spinorowe,
bloki Weyla między \`C^8\`, dynamiczna redukcja
efektywnego wymiaru) wymagają jawnego wyboru
i testów; **nie jest to zakaz wszelkich modeli
8D ani dowód emergencji 3+1**.

To łączy brakujący krok pomiędzy korzystną izotropią
pierwiastków E₈ **w 8D** a siedmioma operatorami
Clifforda wynikającymi z urojonych oktonionów.
Odpowiednią 16-wymiarową konstrukcję blokową
z \`L_u\` opisuje Krasnov (2024).

## IV. Dlaczego to jest wzmocnienie, ale jeszcze nie nowa fizyka?

Nowe, dokładnie odtwarzalne testy VOPM:

1. **Algebraiczny defekt zamkniętego wordu:**
   \`L_k L_j L_i = I-H_assoc/2\`;
   certyfikat współrzędnych w Lean.
2. **Prawdziwe trójkąty E₈:** kompletny
   histogram śladów 13 440 pętli, z
   poprawną odwrotnością na krawędziach.
3. **Wrażliwość na wybór \(\Phi\):**
   porównanie tej samej geometrii z
   izometrycznym, ale niemultiplikatywnym
   odbiciem Weyla.
4. **Clifford \(\mathrm{Cl}(0,7)\):** kontrola
   siedmiu generatorów i granicy
   wymiaru reprezentacji 8×8.

Wszystkie zasady ogólne (Moufang, Clifford,
Wilson, spinory, G₂) mają pierwszeństwo w
literaturze. Przedstawiamy *modelowe konsekwencje*
i rygorystyczne testy, a **nie własną teorię
grupy \(G_2\) lub nową twierdzenie o Clifforda**.

### Najbliższa recenzowana literatura

- **Baez (2002)**, *The Octonions*, *Bull. AMS*,
  doi:10.1090/S0273-0979-01-00934-X;
  niełączność, Clifford, trialność.
- **Feingold–Kleinschmidt–Nicolai (2009)**,
  *Hyperbolic Weyl groups and the four normed division
  algebras*, *J. Algebra* 322, 1295–1339,
  doi:10.1016/j.jalgebra.2009.05.006.
- **Kleinschmidt–Nicolai–Palmkvist (2012)**,
  *Modular realizations of hyperbolic Weyl groups*,
  *Adv. Theor. Math. Phys.* 16, 97–148;
  prezentuje realizację grupy Weyla \(E_8\)
  przez jednostki całkowitych oktonionów
  i automorfizmy rzędu 12096 (konkretny precedens).
- **Grigorian (2017)**, *G₂-structures and
  octonion bundles*, *Adv. Math.* 308,
  doi:10.1016/j.aim.2016.12.003.
- **Grigorian (2021)**, *Smooth loops and loop
  bundles*, *Adv. Math.* 393, 108078,
  doi:10.1016/j.aim.2021.108078;
  pętle jednostek oktonionowych, połączenia,
  torsja, niełączne struktury geometryczne.
- **Wilson (1974)**, *Confinement of quarks*,
  *Phys. Rev. D* 10, 2445,
  doi:10.1103/PhysRevD.10.2445.
- **Krasnov (2024)**, *Geometry of Spin(10)
  symmetry breaking*, *J. Math. Phys.* 65,
  082302, doi:10.1063/5.0210073;
  jawna realizacja \`Cl(8)\` z bloków
  lewego mnożenia oktonionowego.
- **Gourlay–Gresnigt (2024)**, *Algebraic
  realisation of three fermion generations with
  S₃ family and unbroken gauge symmetry
  from Cl(8)*, *Eur. Phys. J. C* 84, 1129,
  doi:10.1140/epjc/s10052-024-13476-0;
  silny punkt odniesienia dla teorii generacji
  i multipletów — nie dublować.

## V. Kryteria następnej jednej dynamiki

**Przed publikacyjnym twierdzeniem o nowej fizyce:**

- ustalić mapę \(\Phi\), orientację
  i regułę zmiany lokalnego układu odniesienia;
- zapewnić \(U_{-\alpha}=U_\alpha^\dagger\)
  przy jednoczesnej zależności operatora
  od wybranego kierunku (inaczej utrata orientacji);
- udowodnić nie tylko lokalność i unitarność,
  lecz nieusuwalną cechę **widma całego kroku**,
  która nie występuje w zwykłej sieci z
  \`SWAP\`+kontrolowaną fazą;
- wyprowadzić skuteczne kierunki propagacji,
  polaryzacje, chiralię i konkretną zależność
  bezwymiarową bez dopasowania stałych;
- sprawdzić pułapki reprezentacyjne
  \`Cl_8\`, Nielsen–Ninomiya,
  i pierwszeństwo prac octonion/gauge.

Nie nazywać pełnej grupy Weyla \`W(E₈)\`
automatycznie symetrią wewnętrzną mnożenia,
ani samych śladów macierzowych
dowodem konfinementu.

## Reprodukcja

\`\`\`bash
python3 checks/check_octavian_bridge.py
python3 checks/check_octavian_holonomy.py
lake build
\`\`\`

Skrypt dokładny czyta dane istniejących plików Lean;
każdy podany histogram musi być aktualizowany
wraz ze zmianą \(\Phi\) i konwencji kierunków.


## VI. Kontrola dodatnia: automorfizm oktonionów G₂

W przeciwieństwie do izometrycznego odbicia Weyla, znany niebanalny
automorfizm Cayleya–Dicksona `g(a,b)=(a,-b)` dla `O=H ⊕ Hℓ`
zachowuje mnożenie. Na ośmiu współrzędnych odpowiada mu
`Q=diag(1,1,1,1,-1,-1,-1,-1)`, więc `L_{g(u)}=Q L_u Q⁻¹`.

Dokładny test potwierdza `g(uv)=g(u)g(v)` dla **57 600** par
jednostek integralnych oraz identyczność śladu dla **każdego
z 13 440** trójkątów E₈ po przejściu do nowej mapy `g∘Φ`.
Nie chodzi tylko o zgodność histogramów; porównywane są
odpowiadające sobie zorientowane trójkąty.

To wzmacnia rygor interpretacji poprzedniego wyniku:
obserwowany brak zgodności dla `r₁∘Φ` nie wynika
z arbitralnej zmiany współrzędnych przez automorfizm `G₂`,
lecz z użycia izometrii, która **nie zachowuje iloczynu**.
Nie jest to jeszcze dowód fizycznego łamania symetrii;
lokalne prawo cechowania pozostaje do wyprowadzenia.
