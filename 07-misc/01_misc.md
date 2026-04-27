## Patrones y Diseño de Algoritmos

### Hamming Distance


La distancia de Hamming entre dos cadenas $a$ y $b$ de igual longitud es el número de posiciones donde difieren. Por ejemplo, $hamming(01101, 11001) = 2$. 

Si representamos las cadenas como enteros (cuando $k \le 32$), podemos calcular la distancia usando operaciones a nivel de bit. El XOR ($\oplus$) identifica los bits diferentes y contar los 1s.

Esto reduce la complejidad de O($n^2 k$) a O($n^2$) al comparar $n$ cadenas de longitud $k$.

```cpp
int hamming(int a, int b) 
{
    bitset<32> x(a), y(b);
    return (x ^ y).count();
}

int hamming(string a, string b) 
{
    int d = 0;
    forn(i, 0, a.size())
        if (a[i] != b[i]) d++;
    return d;
}
```

$\clearpage$

### Reachability in Graphs
Dado un DAG con $n$ nodos, queremos calcular $reach(x)$: número de nodos alcanzables desde $x$.  

Se puede usar programación dinámica clásica O($n^2$) o bit-paralela usando `bitset` para cada nodo, donde `reach[x] |= reach[u]` para cada $u$ adyacente a $x$. Esto reduce operaciones por nodo usando OR de bits, pero puede usar mucha memoria ($O(n^2)$ bits).

```cpp
using vbt = vector<bitset<1000>>;
vbt computeReach(vvi &graph, int n) 
{
    vbt reach;
    for (int x = n-1; x >= 0; x--) 
    {
        reach[x][x] = 1;
        for (auto u : adj[x])
            reach[x] |= reach[u];
    }
    return reach;
}
```

### Counting Subgrids
Dado un grid $n \times n$ con casillas negras (1) o blancas (0), queremos contar subgrids cuyos cuatro vértices son negros.  

En la implementación bit-paralela, cada fila se representa como un `bitset` y usamos operaciones AND para contar columnas donde ambas filas tienen negro. La complejidad baja de O($n^3$) a O($n^2$) y es mucho más rápida, pero usa más memoria ($O(n^2)$ bits para los bitsets).

```cpp
using vbt = vector<bitset<1000>>;
int countSubgrids(vbt &row, int n) {
    int total = 0;
    forn (a, 0, n) {
        for (b, a+1, n) {
            int c = (row[a] & row[b]).count();
            total += c * (c-1) / 2;
        }
    }
    return total;
}
```

$\clearpage$

### Two Pointers Method
Se usan dos punteros $l$ y $r$ que solo avanzan hacia la derecha para encontrar subarrays con ciertas propiedades (ej: suma = x).  

Ejemplo clásico: encontrar subarray con suma exacta x. Ambos punteros se mueven O($n$) pasos en total, dando complejidad O($n$).  

También se aplica al problema 2SUM: encontrar dos valores cuya suma sea x. Primero se ordena el array O($n\log n$) y luego se usan dos punteros desde extremos opuestos.

```cpp
bool subarraySum(vi v, int x) {
    int n = v.size();
    int l = 0, r = 0, sum = 0;
    while (r < n) {
        sum += v[r++];
        while (sum > x) sum -= v[l++];
        if (sum == x) return true;
    }
    return false;
}

bool twoSum(vi v, int x) {
    sort(all(v));
    int l = 0, r = v.size()-1;
    while (l < r) {
        int s = v[l] + v[r];
        if (s == x) return true;
        else if (s < x) l++;
        else r--;
    }
    return false;
}
```

### Nearest Smaller Element (Amortized Stack)
Para cada elemento de un array, encontramos el primer elemento más pequeño que lo precede usando un stack.  

Cada elemento se agrega exactamente una vez y se elimina a lo sumo una vez → O($n$) tiempo. Es un ejemplo de análisis amortizado: operaciones individuales varían, pero el total es lineal.

```cpp
vi nearestSmaller(vi v) 
{
    int n = v.size();
    vi ans(n, -1);
    stack<int> st;
    forn(i, 0, n) 
    {
        while (!st.empty() && v[st.top()] >= v[i])
            st.pop();
        if (!st.empty()) ans[i] = v[st.top()];
        st.push(i);
    }
    return ans;
}
```

### Sliding Window Minimum
Se mantiene una ventana de tamaño fijo moviéndose sobre un array, y queremos el mínimo de cada ventana.  

Se usa un deque: los elementos se agregan al final y se eliminan del final si son mayores al nuevo elemento. El primero siempre es el mínimo. Cada elemento se agrega y elimina a lo sumo una vez → O($n$).


```cpp
vi slidingWindowMin(vi v, int k) 
{
    int n = v.size();
    vi ans;
    deque<int> dq;
    forn(i, 0, n)
    {
        while (!dq.empty() && dq.front() <= i-k) 
            dq.pop_front();
        while (!dq.empty() && v[dq.back()] >= v[i]) 
            dq.pop_back();
        dq.push_back(i);
        if (i >= k-1) 
            ans.push_back(v[dq.front()]);
    }
    return ans;
}
```

### Minimizing Sums
Dado un conjunto de $n$ números $a_1, a_2, \dots, a_n$, consideremos el problema de encontrar un valor $x$ que minimice la suma  

$$|a_1 - x| + |a_2 - x| + \dots + |a_n - x|$$

Por ejemplo, si los números son [1, 2, 9, 2, 6], la solución óptima es $x = 2$, lo que produce la suma  

$$|1-2| + |2-2| + |9-2| + |2-2| + |6-2| = 12$$

Cada función $|a_k - x|$ es convexa, así que la suma también lo es. Podríamos usar búsqueda ternaria para encontrar el $x$ óptimo, pero hay una solución más simple: el valor óptimo de $x$ siempre es la mediana de los números, es decir, el elemento central después de ordenar. Por ejemplo, [1, 2, 9, 2, 6] se ordena como [1, 2, 2, 6, 9], y la mediana es 2.  

La mediana siempre es óptima, porque si $x$ es menor que la mediana, la suma disminuye al aumentar $x$, y si $x$ es mayor, la suma disminuye al disminuir $x$. Si $n$ es par y hay dos medianas, ambas medianas y todos los valores entre ellas son soluciones óptimas.  

Ahora consideremos minimizar la función  

$$(a_1 - x)^2 + (a_2 - x)^2 + \dots + (a_n - x)^2$$

Por ejemplo, con [1, 2, 9, 2, 6], la mejor elección es $x = 4$, produciendo la suma  

$$(1-4)^2 + (2-4)^2 + (9-4)^2 + (2-4)^2 + (6-4)^2 = 46$$ 

Esta función también es convexa. Aunque podríamos usar búsqueda ternaria, hay una solución directa: el valor óptimo de $x$ es el promedio de los números. En este ejemplo, el promedio es  

$$(1 + 2 + 9 + 2 + 6)/5 = 4$$

Esto se puede demostrar reescribiendo la suma como  

$$n x^2 - 2x(a_1 + a_2 + \dots + a_n) + (a_1^2 + a_2^2 + \dots + a_n^2)$$  

La última parte no depende de $x$, y la función restante forma una parábola con mínimo en $x = s/n$, donde $s = a_1 + a_2 + \dots + a_n$. Por lo tanto, el mínimo se alcanza en el promedio de los números $a_1, a_2, \dots, a_n$.

```cpp
int minAbsSum(vi v)
{
    sort(all(v));
    return v[v.size() / 2];
}

double minSquareSum(vi v)
{
    double a = accumulate(all(v), 0.0);
    return a / a.size();
}
```