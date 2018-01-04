1. obiekty w srodku obszaru muszą się w pełni stykać
2. brzeg jest aproksymowany łamaną przy użyciu trójkątów
3. Element skończony (trójkątny/czworokątny). Ile ma węzłów (może być 3 węzłowy - na wierzchołkach ma węzły)
4. i,j,k - numeracja lokalna w trójkącie. Nie trzeba zaczynać od lewej, ale ma być zgodnie z regułą śruby prawoskrętnej (przeciwnie do ruchu wskazówek zegara)


Opis elementu
1. zależy od tego jakie mamy równanie różniczkowe. Weźmiemy Laplace'a (w podręczniku strona 262)
2. za k (współczynnik kierunkowy) przyjmujemy przenikalność (epsilon) ośrodka
3. budujemy duży układ równań: H*V = B
    H ma wymiar taki, jak liczba węzłów w siatce. H jest (m x m), m-liczba węzłów w siatce.
    for elementy
        h(e) dla pojedynczego elementu
        wstawienie h(e) do H


Budowanie siatki
1. W - macierz węzłów [xi, yi]
2. meshgrid([ ], [ ])
3. reshape
i już są współrzędne węzłów
Numery węzłów: M=zeros(n,l); 
    powinno zadziałać: M(:) = [1:n*l]; (możliwe, że poziomo ponumeruje, więc trzeba jakąś transforamcję)

Budowa macierzy trójkątów:
T = [T;[M(1:end-1,1) M(2:end, 1) M(2:end, 2) eps1*ones(n-1, 1)]] - to jest dla dolnych trójkątów
tak samo można zrobić dla górnych 3kątów. W T są współrzędne węzłów (? ? ?)

Obliczenia:
Zerowanie elementów niediagonalnych w wierszu, a do B wstawiamy el.diagonalny * potencjał. Nie psuje to uwarunkowania. (jakby coś to strona 268 w książce)
rozwiązanie V
reshape
mesh żeby zwizualizować



Jakie utrudnienia:
- skośna granica ośrodków
    jeśli to jest pod skosem, to punkty przecięcia w poziomie z tą skośną linią góra dół definiują nam gęstość w danym obszarze. Trzeba zrobić tak dyskretyzację żeby element był w jednym, albo drugim ośrodku.
    Jeśli już opuści się ten graniczny obszar, to można sobie zmienić kształt trójkątów.
- granica ośrodków po okręgu
    jakieś sinusy i kosinusy się tutaj plątają, a nierównomierna jest po prostu jedna przyprostokątnych 3kąta

Jeśli obszar jest dziwny (np. trapez), to siatkę budujemy na prostokącie, to zadajemy warunki brzegowe, a ignorujemy to, co zbywa bo i tak samo się dobrze policzy.



Dla zadanej geometrii i warunków brzegowych:
deklarujemy zmienne: a, b, na, nb, eps1, eps2 itd.
obliczenia
wizualizacja



KARTKA:
- ekran ma stałą grubość
- to wcale nie jest symetrycznie w połowie umieszczone - musi być wszystko zmienne
- jeśli nie ma warunków brzegowych, to obszar jest otwarty. (nie jestm pewien, ale bodajże nie modyfikujemy wtedy H i B)
