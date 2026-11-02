# VOPM-014 — Audyt informacji traconej w śladach pętli i właściwa trójforma G₂

**Stan: 2 listopada 2026.**  
**Zasada:** znanej matematyki (Clifford, G₂, calibrations, Wilson loops)
**nie przedstawiamy jako własnego dowodu recenzowanego twierdzenia**.
Pytanie VOPM brzmi: **które konkretne testy implementacji
na E₈ rzeczywiście zależą od mnożenia oktonionowego, a które
występują już w prostszej strukturze metrycznej?**

## 1. Korekta interpretacji VOPM-013: trójkątne ślady nie wykrywają G₂

Niech \(\mathbb O=\mathbb R\oplus\operatorname{Im}\mathbb O\)
z dzieleniem \(a=a_0+\mathbf a\). Dla
\(L_a(x)=ax\) i standardowej ortonormalnej bazy
Cayleya–Dicksona mamy siedem macierzy
\(J_i=L_{e_i}\) spełniających znane relacje

\[
J_iJ_j+J_jJ_i=-2\delta_{ij}I_8,\qquad
\operatorname{tr}J_i=0,\quad
\operatorname{tr}(J_iJ_j)=-8\delta_{ij},\quad
\operatorname{tr}(J_iJ_jJ_k)=0.
\]

Zatem dla **dowolnych rzeczywistych oktonionów** \(a,b,c\):

\[
\boxed{\frac18\operatorname{tr}(L_cL_bL_a)
=a_0b_0c_0
-c_0\langle\mathbf a,\mathbf b\rangle
-b_0\langle\mathbf a,\mathbf c\rangle
-a_0\langle\mathbf b,\mathbf c\rangle.}
\tag{1}
\]

Jest to standardowa konsekwencja relacji Clifforda,
nie nowy wzór VOPM. Należy oddzielić go od skalarnej części
**iloczynu oktonionowego**
\(\operatorname{Re}(c(ba))\), zawierającej
informację o znanej trójformie \(G₂\):

\[
\varphi(x,y,z)=\langle x,yz\rangle,\quad
x,y,z\in\operatorname{Im}\mathbb O .
\tag{2}
\]

**W szczególności nie zachodzi ogólna równość**
\(\frac18\operatorname{tr}(L_cL_bL_a)
=\operatorname{Re}(c(ba))\).
Przykład \(a=i,b=j,c=k\):
\(\operatorname{Re}(k(ji))=1\), lecz
\(\operatorname{tr}(L_kL_jL_i)=0\).

### Dokładny test danych VOPM

Poprzednia tabela VOPM-013 zawiera 13 440 zamkniętych
zorientowanych trójek \((\alpha,\beta,\gamma)\)
z \(\alpha+\beta+\gamma=0\).
W skrypcie
\`checks/check_g2_trace_blindspot.py\` dla **każdej** z nich:

1. Konstruujemy rzeczywiste 8×8 macierze
   transportu z wcześniejszego VOPM-012.
2. Obliczamy bezpośrednio ślad
   \(\operatorname{tr}(T_\gamma T_\beta T_\alpha)\),
   gdzie \(T=2L_u\) ma całkowite wpisy.
3. Niezależnie obliczamy prawą stronę (1) przez
   **wyłącznie** części rzeczywiste i iloczyny skalarne.
4. Sprawdzamy ich ścisłą równość, bez tolerancji.

Odtwarzany histogram wynosi:

| \(W=\operatorname{tr}(U_\gamma U_\beta U_\alpha)/8\) | Liczność |
|---|---:|
| \(-1/2\) | 3 072 |
| \(0\) | 7 632 |
| \(+1/2\) | 2 736 |
| **Razem** | **13 440** |

Wniosek: te ślady **nie** są samodzielnym testem zachowania
mnożenia oktonionowego. Ta sama trójkątna wielkość
wynika już z **Cliffordowskiej metryki i elementu 1**.

### Kontrprzykład, który poprawia poprzedni test symetrii

Rozważmy izometrię
\[
R(a_0,a_1,a_2,\ldots,a_7)=
(a_0,-a_1,a_2,\ldots,a_7).
\]

Zachowuje ona 240 jednostek całkowitych oktonionów,
normę oraz \(a_0\), lecz **nie jest automorfizmem
mnożenia**, bo \(e_1e_2=e_3\), natomiast
\(R(e_1)R(e_2)=-e_3\ne R(e_1e_2)\).

Mimo tego wzór (1) jest niezmienniczy przy \(R\).
Dokładna kontrola VOPM-014 sprawdza, że **każdy**
z 13 440 śladów trójkąta pozostaje bez zmian.

**Korekta VOPM-013:** wcześniejszy dodatni test
automorfizmu \(G₂\) i ujemny test jednego odbicia
Weyla nie pokazywały jeszcze, że ślady trójkątów
rozpoznają \(G₂\). Nie rozpoznają go:
wystarczy metryczna izometria \(O(7)\)
zachowująca jednostkę rzeczywistą.

Wcześniejszy znak śladu zmieniał się przy odbiciu
*w części rzeczywistej*, które nie należy do tej
grupy stabilizującej wybraną jednostkę \(1\).

## 2. Dlaczego na trójkątach E₈ trójforma G₂ musi być zerowa?

Zdefiniowana w VOPM-012 mapka
\(\Phi:\mathcal R(E₈)\to\mathbb O\) powstaje
z **liniowej izometrii przestrzeni pierwiastków**.
Dlatego dla trójkąta

\[
\alpha+\beta+\gamma=0
\quad\Longrightarrow\quad
\Phi(\alpha)+\Phi(\beta)+\Phi(\gamma)=0.
\]

Części urojone spełniają taką samą liniową zależność.
Ponieważ opublikowana trójforma \(\varphi\)
jest **całkowicie antysymetryczna**:

\[
\boxed{
\varphi(\operatorname{Im}\Phi(\alpha),
        \operatorname{Im}\Phi(\beta),
        \operatorname{Im}\Phi(\gamma))=0
\quad\text{dla każdego trójkąta E₈}.
}
\tag{3}
\]

Nie należy zatem próbować wyprowadzać
kalibracji \(G₂\) z wartości tej trójformy
na trzech krawędziach zamkniętego trójkąta.
Ten konkretny test jest **z definicji trywialny**.

Dokładna arytmetyka kontrolna
potwierdza (3) dla wszystkich 13 440 trójek.
Nie powtarzamy w Lean ogólnego, klasycznego dowodu
alternowania; weryfikujemy jego zastosowanie
do **naszej** tablicy pierwiastków.

## 3. Pierwsza geometryczna pętla dopuszczająca sygnał G₂: cztery krawędzie

Przy czterech krawędziach mogą istnieć
trzy liniowo niezależne kierunki, a czwarta
zamyka drogę. Znaleźliśmy konkretny przykład
**w bieżącej, opublikowanej tablicy VOPM**:

\[
(\alpha_0,\alpha_1,\alpha_6,\alpha_7),
\qquad
\alpha_0+\alpha_1+\alpha_6+\alpha_7=0.
\]

Dokładny test potwierdza cztery różne
kolejne wierzchołki ścieżki i zamknięcie.

Na **trzech pierwszych etykietach** liczymy:

\[
F=
\varphi(\operatorname{Im}\Phi(\alpha_0),
        \operatorname{Im}\Phi(\alpha_1),
        \operatorname{Im}\Phi(\alpha_6)).
\]

W naszej konwencji otrzymujemy:

\[
\boxed{F=-\frac12,\qquad
F(R\Phi(\alpha_0),R\Phi(\alpha_1),R\Phi(\alpha_6))
=+\frac12.}
\tag{4}
\]

Natomiast znany, niebanalny automorfizm
\(G₂\) określony jako
\((a,b)\mapsto(a,-b)\) przy
\(\mathbb O=\mathbb H\oplus\mathbb H\ell\)
zachowuje wartość (4).

Widać także różnicę **operatorową**:
dla otwartego, 3-krokowego prefiksu
\(M=L_{\Phi(\alpha_6)}
     L_{\Phi(\alpha_1)}
     L_{\Phi(\alpha_0)}\)
jego element macierzowy
\(\langle1,M1\rangle\) wynosi \(-1/2\),
a po \(R\) wynosi \(+1/2\).
**Ślad** całej macierzy pozostaje zaś
taki sam w obu przypadkach.

To jest mocniejszy **diagnostyk algebraiczny**
niż poprzedni ślad trójkątnej pętli.

### Bardzo ważna granica interpretacji

Wielkość (4) i element
\(\langle1,M1\rangle\) są określone
w **jednej, ustalonej globalnej ramie**.
Nie zostało wykazane, że przetrwają
**niezależne lokalne transformacje cechowania**
w każdym węźle.

Sama literatura o Wilson loops (Faraji 2026)
przypomina, że ślad usuwa informację
o pełnym transporterze, a rekonstrukcja
połączenia z samych śladów wymaga
dodatkowych danych. W VOPM trzeba teraz
zaprojektować **kowariantną** wersję
diagnostyki (4), np. przez jawne pola
referencyjne, włókna lub transport bazy.
**Nie** ogłaszamy jeszcze krzywizny,
strumienia cechowania ani konfinementu.

## 4. Co konkretnie zostało poprawione?

| Element | VOPM-013 | Po audycie VOPM-014 |
|---|---|---|
| Znaczenie śladów 13 440 trójkątów | Wstępny test \(G₂\)/Weyla | **Ściśle metryczne**: są określone przez Clifforda |
| Test odbicia niemultiplikatywnego | Jedno odbicie rzeczywiste, ślad się zmieniał | Dodano odbicie urojone, niemultiplikatywne, **ślady bez zmian** |
| Próbnik trójformy na trójkącie | Niebadany | **Warunkowy no-go:** dokładnie zero |
| Możliwy sygnał \(\varphi\) | Nieokreślony | Konkretny **czterokrawędziowy** przykład z \(\varphi=\pm1/2\) |
| Formalizacja | Zamknięte słowo i poprawne mnożenie | Nowy lemat Lean dla odbicia niebędącego automorfizmem i świadek trójformy |
| Status fizyczny | Brak wyprowadzonego gauge i 3+1 | Bez zmian — potrzeba lokalnego prawa kowariancji |

## 5. Najważniejsze publikacje

Przede wszystkim **znane** twierdzenia i narzędzia;
nasze wyniki są wyspecyfikowanymi testami VOPM:

1. **Baez, J. C. (2002)**, *The Octonions*, BAMS 39, 145–205,
   DOI: 10.1090/S0273-0979-01-00934-X.
   Klasyczna trójforma \(G₂\), algebra Clifforda, relacje oktonionowe.
2. **Harvey, R. i Lawson, H. B. (1982)**, *Calibrated Geometries*,
   Acta Mathematica 148, 47–157,
   DOI: 10.1007/BF02392726.
   Znana kalibracja asocjacyjna.
3. **Bryant, R. (1987)**, *Metrics with exceptional holonomy*,
   Annals of Mathematics 126, 525–576,
   DOI: 10.2307/1971360.
   Struktura \(G₂\), holonomia i kalibracje.
4. **Grigorian, S. (2017)**, *G₂-structures and octonion bundles*,
   Adv. Math. 308, 142–207,
   DOI: 10.1016/j.aim.2016.12.003.
   Teoria rzeczywistej oktonionowej kowariancji.
5. **Grigorian, S. (2021)**, *Smooth loops and loop bundles*,
   Adv. Math. 393, 108078,
   DOI: 10.1016/j.aim.2021.108078.
6. **Faraji, S. (2026)**, *Foundations of Wilson Lines and Loops:
   From Basic Concepts to Gauge Field Reconstruction*,
   Fortschritte der Physik 74, e70156,
   DOI: 10.1002/prop.70156, publikacja 10.10.2026.
   Rozróżnienie pełnych holonomii i traconych przy śladzie informacji.

## 6. Następny etap

Przyjęcie G₂-symetrycznych, skalarnych śladów
trójkątów jako niezależnego dowodu nowej fizyki
byłoby błędem. Zamiast tego potrzebujemy:

- **Lokalnej reguły ram** kompatybilnej z
  konkretnym oktonionowym produktem na E₈;
- Jawnego **kowariantnego otwartego transportu**
  z polami referencyjnymi lub pętlą z wstawieniem,
  który rzeczywiście zależy od trójformy \(G₂\);
- Widma **jednego, deterministycznie zdefiniowanego**
  kroku automatu, a nie dowolnego harmonogramu;
- Testu względem *zwykłej* sieci \(CZ+SWAP\)
  i każdej prostszej metrycznej struktury
  \(\mathrm{Cl}(0,7)\);
- Mechanizmu 3+1 i kontroli fizycznej chiralności
  bez dopasowywania obserwowanych stałych.


---

## 7. Nietrywialny most do geometrii spinorowej: Spin(7) → G₂

**Nowe i bezpośrednie źródło recenzowane:**
Crowley, Goette i Nordström (2025),
*An analytic invariant of G₂ manifolds*, Inventiones
mathematicae 239, 865–907,
DOI 10.1007/s00222-024-01310-z, §5,
podaje znaną relację (zależnie od konwencji znaku)

\[
\varphi(x,y,z)=\pm\langle c_xc_yc_z s,s\rangle,
\]

gdzie \`s\` jest jednostkowym rzeczywistym spinorem
\`Spin(7)\` w ośmiowymiarowej przestrzeni rzeczywistej,
a jego stabilizatorem jest \`G₂\`. W ten sposób
wybór **spinora referencyjnego**, a nie zwykły
operatorowy ślad, wybiera trójformę \`G₂\`
spośród struktur o tej samej metryce.

W naszej **ściśle ustalonej** konwencji bazy Cayleya–Dicksona
oraz dla jednostkowego spinora \`s=1\` i
\`x,y,z∈Im O\`:

\[
\boxed{
\varphi(x,y,z)=\langle1,L_zL_yL_x1\rangle,
\qquad
\operatorname{tr}(L_zL_yL_x)=0.
}
\]

Jest to **klasyczna geometria spinorów**, a VOPM-014
sprawdza znak i tożsamość dla **wszystkich
\`7³=343\` trójek jednostek urojonych**, z których
42 mają niezerową trójformę (7 linii Fano × 6
uporządkowań). Pozostałe dają zero.

Wcześniejszy model VOPM-013 znał już
\`L_{e_i}\` jako reprezentację \`Cl(0,7)\`.
Teraz można ściśle wyjaśnić, **dlaczego**
\`Tr(L_zL_yL_x)\` traci informację, a
\`⟨s,L_zL_yL_x s⟩\` ją odzyskuje.
To połączenie twierdzeń znanych i zweryfikowanych
koordynatowo, a nie nowe prawo fizyczne.

### Obowiązkowy problem fizyczny

Jeśli VOPM miałby traktować \`s=1\` jako
stan próżni, byłoby to **dodatkowym wyborem
spinora/porządku**, redukującym symetrię
referencyjną do \`G₂\`. Musimy wykazać, że
to wyróżnienie wynika z **tej samej
dynamiki**, np. jako stabilny stan podstawowy,
a nie jest dopisywane arbitralnie.

Przy niezależnych transformacjach ram
\`s_x \mapsto g_x s_x\` należy też
odpowiednio transportować spinory i operatory.
Na razie nasz dowód dotyczy wspólnej
globalnej ramy. Nie deklarujemy
prawdziwej lokalnej symetrii cechowania.
