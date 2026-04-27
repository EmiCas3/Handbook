# Ordenamiento

Por lo regular no es conveniente implementar une metodo de ordenamiento desde cero, durante una competencia, pro lo que se recomienda usar directamente la SLT.

**Complejidad:** $O(n\log n)$
```cpp
sort(all(v)); // sort(v.begin(), v.end()1)
```

## Operadores de Comparación

La función $sort$ requiere de un operador de comparación, que para la gran mayoría de las estructuras STL ya viene implementada, pero esta se puede sobre escribir.

```cpp
vector<pair<int,int>> v2 = {{1,2}, {2,3}, {1,5}};
sort(all(v2));
// [(1,2),(1,5),(2,3)] 
vector<tuple<int,int,int>> v3 = {{1,5,3}, {2,1,4}, {2,1,3}};
sort(all(v3));
// [(1,5,3),(2,1,3),(2,1,4)] 
```

Se puede tambien sobrecargar el operador de comparación de la definición de la estructura.

```cpp
class Point
{
public:
    int x,y;
    bool operator<(const Point &p)
    {
        if (x == p.x) return y < p.y;
        return x < p.x;
    }
}
```

Tambien se puede pasar una función callback cómo parametro.

```cpp
bool comp(string a, string b)
{
    if (a.size() == b.size()) return a < b;
    return a.size() < b.size();
}

sort(all(v), comp);
```


$\clearpage$

# Busqueda Binaria

**Idea:** Encontrar un elemento k iterativamente
**Complejidad** : $\log n$

```cpp
int l = 0, r = n-1;
while (l <= r)
{
    int mid = l + (r-l) / 2;
    if (v[mid] == k) // Found k at index mid
    else if (v[mid] < k) l = mid+1;
    else r = mid-1;
}
```


**Idea:** Encontrar un elemento k recursivamente
**Complejidad** : $\log n$

```cpp
int bs(vi &v, int l, int r, int k)
{
    if (l > r) return -1; // Not found
    int mid = l + (r-l) / 2;
    if (v[mid] == k) return mid;
    else if (v[mid] < k) return bs(v, mid+1, r, k);
    else return bs(v,l,mid -1, k);
}
```
**Idea:** Encontrar un elemento k con saltos de $\frac{n}{2^i}$
**Complejidad** : $\log n$

```cpp
int m = 0;
for (int r = n/2; r >>=1; r/=2)
{
    while (m+r < n && v[m+r] <= k) m += r;
}

if (v[m] == k) // Found k at index m
```
**Idea:** Encontrar el valor mas grande que cumpla cierta condición cuando $x < k = false$ y $x \geq true$
**Complejidad** : $\log n$

```cpp
int m = -1;
int z; // upper_bound that always is true
for (int r = zl r >=1 ; r/=2)
{
    while (!valid(m+r)) m += r;
}
int k = m+1;
```

**Ejemplo:** Dadas $n$ tablas de longitudes $v[i]$, quieres cortar para obtener al menos $k$ piezas de longitud exacta $l$

**Entrada**
```in
4 11
802 743 457 539
```
**Salida***
```out
200
```

```cpp
bool valid(vi &v, ll l, ll k)
{
    ll cnt = 0;
    for (auto x : v) cnt += x / l;
    return cnt >= k;
}

int bs(vi &v, ll k)
{
    ll m = 0; // Lower bound
    ll z = 1e9 + 1; // Upper bound
    for (ll r = z; r >= 1; r/=2)
    {
        while (m+r < z && valid(v, m+r, k))
            m += r;
    }
    return m;
}

void _main()
{
    int n, k;
    cin>>n>>k;
    vi v(n);
    forn(i,0,n) cin>>v[i];

    cout<<bs(v,k)<<endl;
}
```

## Busqueda Binaria con STL

### Verificar si existe

```cpp
bool exist(vi &v, int k)
{
    return binary_search(all(v), k);
}
```

### Encontrar indice

```cpp
int bs(vi &v, int k)
{
    auto it = lower_bound(all(v), k);
    if (it != v.end() && *it == k)
        return distance(v.begin(), it);
    return -1;
}
```
### Primer valor que sea menor

```cpp
int lowerBound(vi &v, int k)
{
    auto it = lower_bound(all(v), k);
    if (it == v.begin()) return -1;
    //it--; //Estrictamente menor
    return distance(v.begin(), prev(it));
}
```
### Primer valor que sea mayor

```cpp
int upperBound(vi &v, int k)
{
    auto it = upper_bound(all(v), k);
    if (it == v.end()) return -1;
    //it--; //Estrictamente mayor
    return distance(v.begin(), it);
}
```

# Busqueda Ternaria

**Idea:** Se usa cuando una función $f(x)$ es **unimodal** (crece y luego decrece, o viceversa). Por ejemplo buscar el máximo en una función discreta.
**Complejidad:** $O(\log n)$

```cpp
int ts(int l, int r)
{
    int m1,m2, ans;
    while (r - l >= 3)
    {
        m1 = l + (r-l) / 3;
        m2 = r - (r-l) / 3;
        
        if f(m1) < f(m2)) l = m1;
        else r = m2;
    }
}
```

$\clearpage$
## Busqueda ternaria sobre reales

**Idea:** Se usa cuando f(x) es continua y unimodal (por ejemplo, funciones convexas o cóncavas).

```cpp
double ts(double l, double r)
{
    double m1,m2;
    forn(i,0,200)
    {
        m1 = l + (r-l) / 3;
        m2 = r - (r-l) / 3;

        if (f(m1) < f(m2)) l = m1;
        else r = m2;
    }
    return (l+r) / 2;
}
```

**Ejemplo** Buscar el valor de $x$ que maximiza $f(x) = -(x-3)^2 + 9$ (máximo en $x = 3$):

```cpp
double f(double x)
{
    return -(x-3) * (x-3) + 9;
}

cout<<ts(-100,100)<<endl;
```

