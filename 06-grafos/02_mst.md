# Minimum Spanning Tree

Un árbol generador (spanning tree) contiene todos los nodos de un grafo y algunas de sus aristas de modo que exista un camino entre cualquier par de nodos. 

Un árbol generador mínimo (minimum spanning tree, MST) es aquel cuyo peso total de aristas es el menor posible, mientras que un árbol generador máximo tiene el peso total mayor.

$\clearpage$

### Union-Find / Disjoint Sets

La estructura Union-Find mantiene conjuntos disjuntos y permite unir conjuntos y encontrar el representante de un elemento en $O(\log n)$ tiempo.  

Cada conjunto tiene un representante y los elementos apuntan a él siguiendo un camino. Al unir conjuntos, siempre se conecta el representante del conjunto más pequeño al del más grande para mantener los caminos cortos. 

Con compresión de caminos (path compression), cada elemento apunta directamente a su representante tras una búsqueda, logrando operaciones en tiempo amortizado $O(\alpha(n))$, donde $\alpha$ es la inversa de Ackermann.


```cpp
class Dsu
{
public:
    vi p, rank; // Parent, Rank

    Dsu(int n)
    {
        p.resize(n);
        rank.resize(n, 1);
        forn(i, 0, n) p[i] = i;
    }

    int find(int x)
    {
        if (x == p[x]) return x;
        return find(p[x]);
    }

    // Path Compression
    int findPc(int x)
    {
        if (x == p[x]) return x;
        return p[x] = findPc(p[x]);
    }

    bool same(int a, int b)
    {
        return find(a) == find(b);
    }

    void unite(int a, int b)
    {
        a = find(a), b = find(b);
        p[b] = a;
    }
    void uniteRank(int a, int b)
    {
        a = find(a), b = find(b);
        if (a==b) return;

        if (rank[a]  < rank[b]) swap(a,b);
        p[b] = a;
        if (rank[a] == rank[b]) rank[a]++;
    }
};
```


### Kruskal

Kruskal construye un MST usando un enfoque greedy: primero ordena las aristas por peso y luego agrega cada arista que une dos componentes distintas. Esto garantiza que no se formen ciclos y que siempre se agreguen las aristas de menor peso primero, asegurando la optimalidad del MST.  

Para implementar eficientemente las funciones same (verificar si dos nodos $a$ y $b$ están en la misma componente) y unite (unir componentes), se usa la estructura union-find o disjoint set, que permite ejecutar ambas operaciones en $O(\log n)$.  
El tiempo total de Kruskal es $O(m \log m)$ para ordenar las aristas y $O(m \log n)$ para procesarlas usando union-find.


```cpp
using iii = tuple<int, int, int>;
using viii  = vector<iii>;
viii kruskal(int n, viii adj, int &total)
{
    auto cmp = [](iii a, iii b)
    { return get<2>(a) < get<2>(b) }

    sort(all(adj), cmp);

    Dsu dsu(n);
    total = 0;
    viii mst;

    for (auto [u, v, w] : adj)
    {
        if (!dsu.same(u, v))
        {
            dsu.unite(u, v);
            total += w;
            mst.push_back({u, v, w});
        }
    }
    return mst;
}
```

$\clearpage$

### Prim

Prim’s algorithm construye un árbol de expansión mínima agregando nodos uno por uno.  
Se inicia con un nodo arbitrario y, en cada paso, se elige la arista de menor peso que conecta un nodo ya incluido con uno fuera del árbol. 

El proceso continúa hasta que todos los nodos estén agregados, asegurando que el árbol resultante sea mínimo.  

La implementación eficiente usa una cola de prioridad que contiene todas las aristas que pueden agregar un nodo nuevo, ordenadas por peso.  

En cada iteración se extrae la arista más ligera, se agrega al árbol si conecta nodos distintos y se actualizan las posibles aristas siguientes.  

El algoritmo tiene complejidad $O(n + m \log m)$ y produce el mismo resultado que Kruskal, aunque puede ser más práctico para grafos densos o cuando se conoce un nodo inicial.

```cpp

using iii = tuple<int, int, int>;
using viii = vector<iii>;
viii prim(int n, viii &adj, int &total, int start = 0)
{
    vi vis(n, false);
    priority_queue<iii, viii, greater<>> pq;
    
    // {weight, current, parent}
    pq.push({0, start, start}); 

    viii mst;
    total = 0;

    while (!pq.empty())
    {
        auto [w, u, p] = pq.top(); pq.pop();
        if (vis[u]) continue;
        vis[u] = true;

        if (u != start)
            mst.push_back({par, u, w});
        total += w;

        for (auto [v, wt] : adj[u])
        {
            if (!vis[v])
                pq.push({wt, v, u});
        }
    }
    return mst;
}
```
