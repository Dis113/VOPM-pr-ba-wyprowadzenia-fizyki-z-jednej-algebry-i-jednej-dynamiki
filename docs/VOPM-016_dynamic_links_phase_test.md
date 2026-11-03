# VOPM-016 — kwantowanie łączy i test właściwego widma w podczerwieni

**3 listopada 2026 · analiza warunkowa, nie nowa teoria cząstek.**  
Repozytorium: [VOPM](https://github.com/Dis113/VOPM-pr-ba-wyprowadzenia-fizyki-z-jednej-algebry-i-jednej-dynamiki).

## 1. Dlaczego modele statycznych łączy to za mało?

VOPM-012–015 przypisują krawędziom E₈ rzeczywiste jednostki całkowitych
oktonionów, prowadzą do 8-poziomowych lokalnych stanów i do dodatniego
Hamiltonianu materii, ale **wszystkie elementy łączy są danymi klasycznymi**.

Kogut–Susskind (1975) w klasycznej pracy o Hamiltonianach sieciowych
wprowadzili **zmienne kwantowe na łączach**, człony elektryczne
i magnetyczne, więzy Gaussa i niezależne testy sektorów spektralnych.
Wegner (1971) opisał fazy dyskretnych systemów cechowania;
Fradkin–Shenker (1979) wskazali znaczenie fazy Coulomba dla ciągłych
grup cechowania. To **ustalona literatura**; nasze zadanie polega
na sprawdzeniu szczególnego modelu z operatorami oktonionowymi,
nie na ponownym udowadnianiu tych twierdzeń.

## 2. Pierwszy uczciwie kwantowy sektor łączy

Każda **nieskierowana** krawędź \(\{x,y\}\)
otrzymuje dwa kwantowe bity końcowych ram
\(f_{e,x},f_{e,y}\in\mathbb Z_2\).
Jest to pomocnicza realizacja jednej rzeczywistej
podgrupy \(\mathbb Z_2=\{I,Q\}\subset G_2\),
gdzie
\(Q=\operatorname{diag}(1,1,1,1,-1,-1,-1,-1)\).

Mimo tej zmiany lokalny układ materii nadal ma
osiem amplitud zespolonych na węzeł.
Operator łącza zależny od jego **stanu kwantowego**:

\[
T_{xy}(f_{e,x},f_{e,y})=
Q^{f_{e,x}}L_{u_\alpha}Q^{f_{e,y}},
\qquad T_{yx}=T_{xy}^\dagger.
\tag{1}
\]

Jego rdzeń \(u_\alpha\) jest nadal **zadaną etykietą**
z tablicy 240 jednostek integralnych oktonionów.
Pole kwantowe obejmuje tutaj dwa bity ramy, nie
samą wielkość \(u_\alpha\) ani pełną grupę ciągłą \(G_2\).

### Lokalna, rzeczywista (nie tylko globalna) redundancja

W węźle \(x\) definiujemy generator

\[
\boxed{G_x=Q_x\prod_{e\ni x}X_{e,x}.}
\tag{2}
\]

\(X_{e,x}\) odwraca **kwantowy** bit ramy tego
końca łącza; \(Q_x\) działa na lokalny
ośmiopoziomowy stan materii.

Dla pojedynczej krawędzi Lean sprawdza:
\(G_x^2=G_y^2=I\), \(G_xG_y=G_yG_x\).
Rzeczywista przestrzeń fizyczna wymaga
\[
G_x|\Psi_{\mathrm{phys}}\rangle=
|\Psi_{\mathrm{phys}}\rangle
\quad \forall x.
\tag{3}
\]

Wszystkie 240 jednostek octavianowych i
cztery kombinacje ram dwóch końców podlegają
dokładnej, całkowitoliczbowej kontroli
kowariancji członu transportu.
To jest pełna lokalna redundancja
**wybranej dyskretnej podgrupy**, nie dowód
istnienia **kwantowego ciągłego G₂**.

## 3. Autonomiczny, dodatni Hamiltonian z dynamicznymi łączami

Pierwsza ścisła konstrukcja to

\[
\boxed{
H_{\mathrm{parent}}=
48\sum_xP_{x}
+\sum_{\{x,y\}\in E(E_8)}
\left(B_{xy}^{\dagger}B_{xy}
+B_{yx}^{\dagger}B_{yx}\right)
+\Gamma\sum_{e}\sum_{v\in\partial e}(I-X_{e,v}).
}
\tag{4}
\]

\(B_{xy}\) pochodzi z VOPM-015 i korzysta z
właściwego transportera (1). Dla każdego
ustalonego stanu bitów łącza daje
mieszające dwa węzły amplitudy
\[
(B_{xy}\Psi)_a=
\Psi_{a,0}-\sum_{b=1}^7
  (P\,T_{xy}P)_{ab}\Psi_{0,b}.
\]

Parametr \(\Gamma>0\) jest **nowym jawnym
współczynnikiem kinetycznym**, nie
wyprowadzoną z oktonionów wartością
fizyczną. Trzeba ponownie wyprowadzić
jego skalę; \(48\) pochodzi
z ustalonej normalizacji sumy
asocjatorów.

### Ścisły modelowy wynik i ograniczenie (bez przepisywania standardowego dowodu)

Wszystkie składniki (4) są dodatnie,
a stan

\[
|\Omega\rangle=
\bigotimes_{x}|1\rangle_x
\otimes
\bigotimes_{(e,v)}|+\rangle_{e,v},
\qquad
|+\rangle=(|0\rangle+|1\rangle)/\sqrt2,
\tag{5}
\]

ma dokładnie energię zero, ponieważ
\(P|1\rangle=0\),
\(B_{xy}|1,1\rangle=0\)
i \((I-X)|+\rangle=0\).

W reprezentacji iloczynowej części
nieoddziałującej jej pierwsza
dodatnia energia wynosi
\(\min(48,2\Gamma)\); dodatkowe
\(B^\dagger B\) **nie mogą**
obniżyć energii ani zmienić stanu
\(|\Omega\rangle\) w zeroenergetycznym
podprzestrzeni. Znany argument
o dodatnim Hamiltonianie bez frustracji
daje dla każdego skończonego grafu:

\[
\boxed{
H_{\mathrm{parent}}\ge
\min(48,2\Gamma)
\bigl(I-|\Omega\rangle\langle\Omega|\bigr),
\quad \Gamma>0.
}
\tag{6}
\]

To jest **jednolita** (niezależna
od liczby węzłów i krawędzi)
dolna granica szczeliny przy
\(\Gamma>0\). Jedyna próżnia
jest produktem tensorowym.
Hamiltonian jest kwantowy
i łącza rzeczywiście ewoluują
przez zmienne \(X\), ale
**nie jest to stabilna faza
z bezmasowym fotonem czy grawitonem**.

Dla \(\Gamma=0\) dolna
granica (6) znika. Nie jest to
jednak wyprowadzenie poprawnej
bezmasowej fazy: na większej
sieci powstaje rozległa
degeneracja sektorów łączy.

W \`VOPM/DynamicLinks.lean\`
Lean sprawdza lokalną algebrę
Gaussa, dodatniość elektrycznej
formy kwadratowej i dokładną
zeroenergetyczną próżnię.
Weryfikacja rozmiaru szczeliny
całej sieci jest tutaj
**standardowym argumentem
spektralnym**, nie osobnym
nowym twierdzeniem jądra Lean.

### Istotna komplikacja: nadmiarowe fizyczne stopnie swobody

Dwa bity **na krawędź** to ogromne
rozszerzenie przestrzeni Hilberta,
nawet jeśli lokalna materia
ciągle ma \(\mathbb C^8\).
W sektorze próżni materii
dla grafu z \(V\) węzłami bez
izolowanych wierzchołków i
\(E\) krawędziami mamy
\(2E\) bitów, ale tylko
\(V\) niezależnych transformacji
wierzchołkowych; w liczbie
konfiguracji fizycznych pozostaje
\(2^{2E-V}\) wymiarów.

W grafie regularnym o stopniu
240 mielibyśmy \(E=120V\)
(dla wystarczająco dużego
ilorazu periodycznego, bez
kolizji kierunków), co oznacza
aż \(2^{239V}\) fizycznych
stanów samych zmiennych ram
przed uwzględnieniem ich energii.

To **prototyp regularizacji**,
nie wyprowadzenie całej mikrofizyki
z *samych* 16 realnych
stopni swobody na węzeł.
Fizyczne połączenia mogłyby
wymagać znacznie mniejszej
przestrzeni, dodatkowych więzów
lub wyprowadzenia łączy jako
zmiennych złożonych.

### Obserwabla, której naprawdę zmienia się wartość

Na **pojedynczej** krawędzi oba bity ram
należą do różnych węzłów i po projekcji
Gaussa nie reprezentują niezależnego
kwantowego pola w próżni materii.
Dlatego sam niezerowy element
\(\langle b'|H_E|b\rangle\)
nie wystarczałby do wykazania
fizycznej dynamiki łącza.

Przy **dwóch różnych krawędziach
spotykających się w jednym węźle**
mamy natomiast dwa bity ram
\(h_1,h_2\) transformowane równocześnie
przez tamtejszy Gauss:
\((h_1,h_2)\mapsto(h_1\oplus1,h_2\oplus1)\).
Względna parzystość
\[
R_v=(-1)^{h_1+h_2}
\]
jest **niezmiennicza względem tego
lokalnego Gaussa**, ale
pojedynczy elektryczny flip
\(X_1\) zmienia jej znak:
\[
\boxed{X_1 R_v X_1=-R_v}.
\]
Stąd dla \(\Gamma>0\)
\([H_E,R_v]\ne0\).
Jest to autentyczna, mała
obserwabla gauge-invariant,
której dynamika nie jest
jedynie zmianą reprezentacji.

\`VOPM/DynamicLinks.lean\`
zawiera jawny dowód tych
dwóch tożsamości na
wszystkich czterech
lokalnych konfiguracjach.

## 4. Dodatkowy człon magnetyczny — rzeczywisty trójkąt E₈

Zgodnie z Hamiltonianową
teorią cechowania, na małym
cyklu testujemy magnetyczną
obserwablę typu Wilsona.

W bieżącej, dokładnej tablicy
pierwiastków E₈ istnieje
zamknięty trójkąt o indeksach
\((1,14,37)\). Jego trzy
bazy wektorowe spełniają
\(\alpha_1+\alpha_{14}
+\alpha_{37}=0\), a ścieżka
odwiedza trzy różne wierzchołki.

Na każdym z trzech łączy
są dwa kwantowe bity ram,
więc mamy **sześć**
bitów i przestrzeń 64-wymiarową.
Gdy \(T_{01},T_{12},T_{20}\)
są ramowo-kowariantnymi
macierzami transportu, ustawiamy

\[
\boxed{
W_\triangle=
\frac18\operatorname{tr}
(T_{01}T_{12}T_{20}),
\qquad
H_\triangle=
\Gamma\sum_{j=1}^6(I-X_j)
+\mu(I-W_\triangle).
}
\tag{7}
\]

Jest to **drugi, dodatkowo
postulowany człon magnetyczny**
w stylu Koguta–Susskinda.
\(W_\triangle\) jest
operatorem diagonalnym
w bazie bitów łączy.
Pod lokalną zmianą ram
cały iloczyn zmienia się
przez sprzężenie u podstawy,
więc ślad pozostaje taki sam.

Każdy \(T\) jest rzeczywistą
macierzą ortogonalną,
więc \(W_\triangle\in[-1,1]\)
i dla \(\mu\ge0\) człon
magnetyczny jest dodatni.
Nie należy jednak zakładać,
że \(|+\rangle^{\otimes6}\)
jest także jego
stanem podstawowym.

### Dokładne więzy i widmo

Trzy lokalne generatory
Gaussa odwracają po dwa
bity tego samego węzła.
Po projekcji na sektor
fizyczny 64 bity bazowe
skupiają się w 8 orbitach,
czyli **trzech fizycznych
bitach** \(p_0,p_1,p_2\).

Dla wybranej mapy E₈→oktoniony
i ustalonej orientacji
test obliczył dokładnie:

\[
\boxed{W_\triangle^{(\mathrm{oct})}
=\frac14(I+Z_0Z_1Z_2).}
\tag{8}
\]

Wobec tego, przy
\(\Gamma=1,\mu=4\):

\[
\boxed{
H_{\mathrm{phys}}=
9I-2(X_0+X_1+X_2)-Z_0Z_1Z_2.
}
\tag{9}
\]

Po odjęciu środka widma
\(K=H_{\mathrm{phys}}-9I\),
kod dokładny sprawdza:

\[
(K^2-37I)(K^2-5I)=0,
\quad \operatorname{tr}K^2=104,
\quad SK+KS=0,
\tag{10}
\]

dla odpowiedniego
ortogonalnego \(S\)
odwracającego widmo \(K\).
Z (10) wynika dokładnie

\[
\boxed{
\operatorname{spec}H_{\mathrm{phys}}=
\{9-\sqrt{37},\
9-\sqrt5\ [\times3],\
9+\sqrt5\ [\times3],\
9+\sqrt{37}\}.
}
\tag{11}
\]

Jedyny stan podstawowy
i szczelina pierwszego
wzbudzenia:

\[
\boxed{
\Delta_{\mathrm{phys}}
=\sqrt{37}-\sqrt5
\approx3.846695>0.
}
\tag{12}
\]

Dla ogólnych
\(\Gamma>0,\mu\ge0\):

\[
\Delta_{\mathrm{phys}}(\Gamma,\mu)
=
\sqrt{36\Gamma^2+\mu^2/16}
-
\sqrt{4\Gamma^2+\mu^2/16}>0.
\]

**Nie jest to dowód
termodynamicznie stabilnej
fazy**: trójkąt ma
zaledwie trzy węzły.

### Najważniejszy test kontrolny: brak nowości w widmie trójkąta

Jeśli zamienimy wszystkie
trzy rdzenie oktonionowe
\(L_u\) na zwykłe
operatory jednostkowe
(\(\mathbb Z_2\)
z tą samą liczbą bitów
i tym samym \(H_E\)),
dostajemy:

\[
W_\triangle^{\rm ctl}
=\frac12(I+Z_0Z_1Z_2)
=2W_\triangle^{\rm oct}.
\]

A więc dla
**dowolnego** \(\Gamma,\mu\):

\[
\boxed{
H_\triangle^{\mathrm{oct}}(\Gamma,\mu)
=
H_\triangle^{\mathrm{ctl}}(\Gamma,\mu/2)
+\frac\mu2 I.
}
\tag{13}
\]

**Przestrzeń fizyczna,
wektory własne,
względne poziomy
i szczelina są więc takie same**
w obu modelach po zmianie
magnetycznej skali i
stałym przesunięciu energii.

To nie jest falsyfikacja
wszystkich możliwych
oktonionowych teorii,
ale jest ścisły
modelowy **no-go
dla nowości tego
pojedynczego trójkąta**.
Nie wolno publikować (11)
jako unikatowej prognozy
oktonionowej.

## 5. Porównanie ze stabilną fazą bezmasową z literatury

Wegner (1971), Fradkin–Shenker (1979),
Kitaev (2003) oraz Levin–Wen
(2005/2006) pokazują,
że łącza kwantowe mogą
prowadzić do faz z topologicznymi
wzbudzeniami i — w
odpowiednich układach
z **ciągłą** grupą —
do emergetnych bezmasowych
bozonów cechowania.

Sektor z dokładną
\(\mathbb Z_2\) stanowi
minimalny test lokalnej
symetrii, nie konstrukcję
bezwymiarowego fotonu.
Nawet zastąpienie go
standardowym
\(U(1)\) na sztywnej
8D kracie E₈
nie rozwiązuje
automatycznie problemu 3+1.
W zwykłej
liniowej granicy Maxwellowskiej
w \(d=8\) wymiarach
przestrzennych dla
niezerowego \(\mathbf k\)
istnieje \(d-1=7\)
polaryzacji poprzecznych,
nie obserwowane 2
polaryzacje światła w 3+1.

Znany drugi moment
pierwiastków E₈:
\[
\sum_{\alpha\in E_8}
\alpha_i\alpha_j=60\delta_{ij}
\]
ma **rangę osiem**,
a sam przez się nie
redukuje wymiaru
niskoenergetycznego
do trzech kierunków.

## 6. Co zostało sprawdzone i co pozostaje otwarte?

### Lean 4 — modelowo specyficzne małe lematy

\`VOPM/DynamicLinks.lean\`:
- flip bitów jako inwolucje i ich komutacja;
- lokalne operatory Gaussa
  na pełnej 256-stanowej przestrzeni,
  \(G_x^2=G_y^2=I\),
  \(G_xG_y=G_yG_x\);
- dokładna niezmienniczość
  referencyjnego stanu
  \(|0,0\rangle\otimes|+\!+\rangle\);
- dodatniość
  elektrycznej energii
  i pełnej dwu-węzłowej
  formy kwadratowej;
- zerowa energia
  referencyjnej próżni.

### Niezależna arytmetyka dokładna

\`checks/check_dynamic_links.py\`:
- 240 jednostek E₈ × 4
  pary ram × 2 końce,
  pełna zgodność wszystkich
  dwuwęzłowych bloków
  64×64;
- trzy rzeczywiste
  256×256 Hamiltoniany
  z linkowym \(X\),
  ich komutacja z
  Gaussami, produktowy
  stan zerowy i
  sektor fizyczny
  na jednej krawędzi.

\`checks/check_dynamic_plaquette.py\`:
- pełny test
  64 konfiguracji bitów
  prawdziwego trójkąta E₈;
- invariancja magnetycznej
  pętli pod wszystkimi
  lokalnymi Gaussami;
- dokładne
  \((K^2-37I)(K^2-5I)=0\),
  wymuszające (11);
- osobna kontrola
  z trywialnym rdzeniem
  \(U=I\), pokazująca
  dokładną równoważność (13).

### Nieuzyskane wyniki

- **Żadnej** stabilnej,
  bezmasowej fazy
  z dokładnie dwoma
  fotonowymi
  polaryzacjami 3+1.
- Brak kwantowania
  wszystkich **ciągłych**
  operatorów łączy \(G_2\).
- Brak dynamiki
  rdzenia octavianowego
  \(u_\alpha\)
  i samej geometrii E₈.
- Brak odtworzenia
  fermionów, chiralności,
  grawitacji teleparalelnej
  i parametrów
  Modelu Standardowego.
- **Nadmierna liczba**
  pomocniczych fizycznych
  bitów łączy
  w stosunku do
  ideału 16 rzeczywistych
  amplitud na węzeł.

## 7. Priorytet następnego badania

Budować model
z **ciągłym**
lub efektywnie
bezmasowym sektorem
cechowania i lokalnymi
związkami ram,
z mapą do operatorów
oktonionowych E₈.
Testować pełny
odpowiednik
\[
H_{\rm gauge}=g^2H_E+g^{-2}H_{\rm magnetic}
\]
w duchu Koguta–Susskinda,
z obowiązkowym
porównaniem do
zwykłych teorii
\(U(1)\)/\(\mathbb Z_2\).

Dopiero wyliczona
w skali duży-rozmiar
**liczba poprzecznych
modów** i skalozależny
**wymiar spektralny**
mogą dać podstawę do
testu pożądanego 3+1.



---

## 8. Własna dynamika KWANTOWEGO rdzenia łącza: 240 jednostek integralnych

**To uzupełnienie jest niezbędne:** poprzedni model z
\(\Gamma\sum(I-X)\) kwantował jedynie **dwa końcowe bity ramy**,
podczas gdy przypisana pierwiastkowi
jednostka oktonionowa \(u_\alpha\) pozostawała nieruchomym rdzeniem.
Aby wypróbować również jej kwantową dynamikę,
wprowadzamy na **każdej nieskierowanej krawędzi**
pomocniczą przestrzeń \(\mathbb C^{240}\) z bazą
\(\{|u\rangle:u\in\mathcal U_{\mathrm{oct}}\}\).

W rezultacie pełny link na próbę
ma przestrzeń
\(\mathbb C^{240}\otimes\mathbb C^2\otimes\mathbb C^2\),
o wymiarze **960 na krawędź**.
To zdecydowanie nie jest jeszcze
minimalny model z samymi 16 realnymi
stopniami swobody w węźle.
Wariant opisujemy jako **jawny model
kontrolny**, nie ostateczną ontologię VOPM.

### Ruch na pętli Moufanga i jego nieoczekiwana redukcja do geometrii E₈

Niech
\[
\mathcal U=\{u\in\mathbb O_\mathrm{int}:|u|=1\},
\qquad |\mathcal U|=240
\]
oraz
\[
S=\{w\in\mathcal U:\operatorname{Re}w=0\},
\qquad |S|=126.
\]

Wybór generatorów \(S\) jest
wyróżniony przez część rzeczywistą
oktonionów i nie wybiera jednej
płaszczyzny kwaternionowej.
**Uwaga:** pełna ciągła grupa \(G₂\)
nie zachowuje ogólnie wybranego
skończonego porządku całkowitych
oktonionów; co najwyżej jego
odpowiednią podgrupę arytmetyczną.

Każdy operator prawego mnożenia
\(|u\rangle\mapsto|uw\rangle\)
dla \(w\in S\) jest permutacją
240 etykiet. Ponieważ
\(\bar w=-w\) też należy do \(S\),
ich symetryczna suma definiuje
zwykłą rzeczywistą
macierz sąsiedztwa \(A\) z
126 sąsiadami przy każdym węźle
i dodatni Hamiltonian łącza:

\[
\boxed{
K_{\mathrm{oct}}=126I-A,\qquad
\langle\psi,K_{\mathrm{oct}}\psi\rangle=
\frac12\sum_{u\sim v}
|\psi(u)-\psi(v)|^2\ge0.
}
\tag{14}
\]

**Kluczowy modelowo-specyficzny no-go:**
znana własność normowanej algebry
kompozycyjnej daje
\[
v=uw,\quad\operatorname{Re}w=0
\quad\Longleftrightarrow\quad
\operatorname{Re}(\bar u v)=0
\quad\Longleftrightarrow\quad
\langle u,v\rangle=0.
\tag{15}
\]

Zatem **cała macierz \(A\) jest dokładnie
grafem ortogonalności 240 pierwiastków E₈**.
Każde odwołanie do konkretnego
mnożenia oktonionowego można
zastąpić czysto metrycznym
warunkiem w \(\mathbb R^8\).

Tożsamość (15) jest **znaną matematyką**;
nie zgłaszamy jej jako odkrycia.
Naszą własną kontrolą jest dokładne
sprawdzenie wszystkich 240×126
odpowiadających jej przejść
na bieżącej tablicy Lean.

### Dokładne widmo bez diagonalizacji numerycznej

Oznaczmy przez \(P\)
permutację antypodalną
\(u\mapsto-u\) i przez \(J\)
macierz samych jedynek.
Sprawdzamy **dokładnie** wszystkie
57 600 wpisów następującej
klasycznej tożsamości
grafu pierwiastków:

\[
\boxed{
A^2=54(I+P)+72J-12A.
}
\tag{16}
\]

Weryfikacja dodatkowo pokazuje
\(AP=A\), \(AJ=126J\),
\(P^2=I\) i \(\operatorname{tr}A=0\).

Na 120-wymiarowym
nieparzystym podprzestrzeni
\(P=-I\) operator \(A=0\).
Na pozostałej 120-wymiarowej
przestrzeni parzystej jest
jeden stan jednostajny
z wartością 126, a
pozostałe wartości spełniają
\[
\lambda^2+12\lambda-108=0,
\quad\lambda\in\{6,-18\}.
\]
Z równości wymiarów
i śladu wyliczamy krotności
bez przybliżeń:

\[
\boxed{
\operatorname{spec}(A)=
\{126[1],\,6[84],\,0[120],\,-18[35]\},
}
\tag{17}
\]
\[
\boxed{
\operatorname{spec}(K_{\mathrm{oct}})=
\{0[1],\,120[84],\,126[120],\,144[35]\}.
}
\tag{18}
\]

Przy wybranej dodatniej skali
\(\tau>0\) rdzeń łącza
ma **jedną** stanową
superpozycję zerową
\[
|+\!_{\mathrm{oct}}\rangle=
\frac1{\sqrt{240}}\sum_{u\in\mathcal U}|u\rangle,
\quad
\Delta_{\mathrm{oct}}=120\tau.
\]

To **nie jest nowy wynik ogólny
o grafach E₈**:
reprodukujemy klasyczną
kombinatorykę 240 pierwiastków
(opublikowane np. w pracy
*The Action of the Weyl Group on
the E₈ Root System*, Graphs
and Combinatorics 37 (2021),
DOI 10.1007/s00373-021-02315-8).
Własny wkład implementacyjny
polega na pokazaniu, że
wybrany *algorytm dynamiki
rdzenia oktonionowego* nie
wnosi danych poza tą
klasyczną metryką.

### Jedna konstrukcja obejmująca materię i oba rodzaje ruchu łączy

Możemy dopisać do dodatniego
Hamiltonianu (4) **naprawdę
kwantowe** fluktuacje
rdzenia octavianowego:

\[
\boxed{
H_{\mathrm{full}}=
48\sum_xP_x+
\sum_{\{x,y\}}
\bigl(B_{xy}^{\dagger}B_{xy}
+B_{yx}^{\dagger}B_{yx}\bigr)
+\Gamma\sum_{(e,v)}(I-X_{e,v})
+\tau\sum_e K_{\mathrm{oct},e}.
}
\tag{19}
\]

Elementy transportu \(B\)
zależą diagonalnie
od aktualnego kwantowego
stanu \(u_e\) i bitów ramy.
Dwie pozostałe sumy
mieszają **te** stany;
formalnie jest to jedna
lokalna ewolucja Hamiltonianowa.

Przy \(\Gamma,\tau>0\)
mamy **standardowy**, niezależny
od rozmiaru grafu wynik o
dodatnich Hamiltonianach
bez frustracji:

\[
|\Omega_{\mathrm{full}}\rangle=
\bigotimes_x|1\rangle_x
\otimes
\bigotimes_{(e,v)}|+\rangle_{e,v}
\otimes
\bigotimes_e|+\!_{\mathrm{oct}}\rangle_e,
\]
\[
\boxed{
H_{\mathrm{full}}\ge
\min(48,2\Gamma,120\tau)
\left(I-|\Omega_{\mathrm{full}}\rangle
\langle\Omega_{\mathrm{full}}|\right).
}
\tag{20}
\]

Wszystkie \(B^\dagger B\ge0\)
anihilują stan próżni materii,
a składnik \(K\) anihiluje
jednostajny stan rdzenia.
To znana argumentacja spektralna,
nie nowy ogólny dowód.

**Wniosek fizyczny:** nawet po
uczynieniu samego \(u\)
dynamiczną zmienną kwantową
ten najprostszy, najbardziej
symetryczny model pozostaje
**ściśle szczelinowy**.
Nie otrzymujemy fotonu,
grawitonu ani redukcji
8D do efektywnych 3D.
Dopiero
operator zależny od
**uporządkowanych, niełącznych
iloczynów kilku transportów**
ma szansę wyjść poza
tę metryczną klasę kontrolną.

\`VOPM/QuantumOctavianCore.lean\`:
definicja i dodatniość formy
kwadratowej, symetria
ortogonalności i zerowa
energia stałej funkcji.

\`checks/check_quantum_octavian_core.py\`:
wszystkie 30 240 przejść
prawego mnożenia, 57 600
porównań ortogonalności,
dokładne (16) i (18)
oraz test automorfizmu.
Widmo (18) jest
**dokładną kontrolą Python i
znaną matematyką E₈**,
jeszcze nie pełnym jądrowym
dowodem 240-wymiarowego
spektrum w Lean.

**Ograniczenie istotne dla
ontologii:** fluktuująca
jednostka \(u_e\) nie
musi być w każdej chwili
równa sztywnej mapie
\(\Phi(\alpha_e)\) z VOPM-012.
Trzeba przyjąć interpretację
\[
u_e(t)=\Phi(\alpha_e)\,w_e(t),
\]
gdzie \(w_e\) jest
zmienną kwantową,
albo wyprowadzić
bardziej restrykcyjne
więzy. To dodatkowa
hipoteza, nie konsekwencja
samego \(E₈\).

## Literatura pierwszeństwa

- F. J. Wegner (1971), *Duality in generalized Ising models
  and phase transitions without local order parameters*,
  J. Math. Phys. 12, 2259–2272,
  DOI 10.1063/1.1665530.
- J. Kogut, L. Susskind (1975),
  *Hamiltonian formulation of Wilson’s lattice gauge theories*,
  Phys. Rev. D 11, 395–408,
  DOI 10.1103/PhysRevD.11.395.
- S. Elitzur (1975), *Impossibility of spontaneously
  breaking local symmetries*, Phys. Rev. D 12, 3978,
  DOI 10.1103/PhysRevD.12.3978.
- E. Fradkin, S. H. Shenker (1979),
  *Phase diagrams of lattice gauge theories with Higgs fields*,
  Phys. Rev. D 19, 3682,
  DOI 10.1103/PhysRevD.19.3682.
- A. Yu. Kitaev (2003), *Fault-tolerant quantum
  computation by anyons*, Ann. Phys. 303, 2–30,
  DOI 10.1016/S0003-4916(02)00018-0.
- M. Levin, X.-G. Wen (2005),
  *String-net condensation: A physical mechanism for topological
  phases*, Phys. Rev. B 71, 045110,
  DOI 10.1103/PhysRevB.71.045110.
- M. Levin, X.-G. Wen (2006),
  *Quantum ether: Photons and electrons from a rotor model*,
  Phys. Rev. B 73, 035122,
  DOI 10.1103/PhysRevB.73.035122.

**Wszystkie powyższe
są istniejącymi
rezultatami naukowymi,
nie „dowodami VOPM”.**
