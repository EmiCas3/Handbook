# Combinatoria
## Definición general
$$
\binom{n}{k} = \frac{n!}{k!(n-k)!}
$$

```cpp
ll comb(int n, int k)
{
    return fact(n) / (fact(k) * fact(n-k));
}
```
## Fórmula Recursiva

$$
\binom{n}{k} =
\begin{cases}
1, & \text{si } k = 0 \text{ o } k = n, \\\\
\binom{n-1}{k-1} + \binom{n-1}{k}, & \text{en otro caso.}
\end{cases}
$$

```cpp
ll comb(int n, int k)
{
    if (k == 0 || k == n) return 1;
    return comb(n-1, k-1) + comb(n-1, k);
}
```

## Obtener todas combianciones

```cpp
void combHelper(vi &a, int start, int k, vi &temp, vvi &ans) {
    if(k == 0) { ans.pb(temp); return; }

    forn(i, start, a.size() - k + 1)
    {
        temp.pb(a[i]);
        combHelper(arr, i+1, k-1, temp, ans);
        temp.pop_back();
    }
}

vvi getCombs(vi &arr, int k) {
    vvi ans;
    vi temp;
    combHelper(arr, 0, k, temp, ans);
    return ans;
}
```

$\clearpage$

# Permutaciones

## Definición general
$$
P(n, k) = \frac{n!}{(n-k)!}
$$


```cpp
ll perm(int n, int k) {
    return fact(n) / fact(n-k);
}
```

## Forma recursiva
$$
P(n, k) =
\begin{cases}
1, & \text{si } k = 0, \\\\
n \cdot P(n-1, k-1), & \text{en otro caso.}
\end{cases}
$$

```cpp
ll perm(int n, int k) {
    if(k == 0) return 1;
    else if (n == k) return fact(n);
    else if (k == 1) return n;
    return n * perm(n-1, k-1);
}
```
## Obtener todas combianciones

```cpp
void permHelper(vi &a, int start, vvi &ans) {
    if(ans.size() == start) { ans.pb(a); return; }

    forn(i, start, a.size() - k)
    {
        swap(a[start], a[i]);
        permHelper(a, start + 1, ans);
        swap(a[start], a[i]);
    }
}

vvi getPerms(vi &arr, int k) {
    vvi ans;
    permHelper(arr, 0, ans);
    return ans;
}
```

$\clearpage$

# Propiedades de Combinatoria y Permutaicones

### Teorema Binomial

$$
(a + b)^n = \sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^k
$$

```cpp
ll binomialTheorem(int a, int b, int n, int k) {
    return comb(n, k) * pow(a, n-k) * pow(b, k);
}
```
$$
\sum_{k=0}^{n} \binom{n}{k} = 2^n
$$

```cpp
ll sumComb(int n)
{
    return 1LL << n;
}
```

$$
P(n, k) = k! \cdot \binom{n}{k}
$$

```cpp
ll permViaComb(int n, int k) {
    return fact(k) * comb(n, k);
}
```

$$
P(n+1, k) = (n+1) \cdot P(n, k-1)
$$


```cpp
ll permRecRelation(int n, int k) {
    if(k == 0) return 1;
    return (n+1) * permRec(n, k-1);
}
```

## Palo de Hockey

$$
\binom{r}{r} + \binom{r+1}{r} + \cdots + \binom{n}{r} = \binom{n+1}{r+1}
$$

```cpp
ll hockeyStick(int r, int n) {
    ll sum = 0;
    for(int i = r; i <= n; i++) sum += comb(i, r);
    return sum;
}
```

## Números de Catalán

Los números de Catalán se definen como:

$$
C_n = \frac{1}{n+1} \binom{2n}{n} = \frac{(2n)!}{(n+1)! \, n!}
$$

```cpp
ll catalan(int n) {
    return comb(2*n, n) / (n+1);
}
```

# Principio de Inclusión - Exclusión

## Dos conjuntos
$$
|A \cup B| = |A| + |B| - |A \cap B|
$$

```cpp
int union2(int a, int b, int ab) {
    return a + b - ab;
}
```

## Tres conjuntos

```cpp
int union3(int a, int b, int c, int ab, int ac, int bc, int abc) {
    return a + b + c - ab - ac - bc + abc;
}
```

## Caso general
$$
|X_1 \cup X_2 \cup \dots \cup X_n| = \sum_{\emptyset \neq S \subseteq \{1, \dots, n\}} (-1)^{|S|+1} \left| \bigcap_{i \in S} X_i \right|
$$

```cpp
#include <bitset>
#include <vector>
using namespace std;

int inclusionExclusion(int n, vi &sizes) 
{
    int ans = 0;
    for (int m = 1; m < (1 << n); m++) 
    {
        bitset<32> mask(m);
        int bits = mask.count();
        int sz = 0;
        forn(i,0,n)
            if (mask[i]) sz += sizes[i]; 
        ans += (bits % 2 ? sz : -sz);
    }
    return ans;
}
```

## Derangements (Desarreglos)

Número de permutaciones sin elementos en su posición original:

```cpp
ll derangements(int n) 
{
    if (n == 1) return 0;
    else if (n == 2) return 1;
    return (n-1) * (derangements(n-1) + derangements(n-2));
}
```

## Burnside’s Lemma

Número de combinaciones distintas considerando simetrías, donde $c(k)$ es el número de combinaciones fijas por la k-ésima simetría.

$$\text{#distinct} = \frac{1}{n} \sum_{k=0}^{n-1} c(k)$$

```cpp
ll burnside(int n, int m) 
{
    ll ans = 0;
    forn(n,0,k) ans += pow(m, gcd(k, n));
    return ans / n;
}
```