# Grafos
## Terminologia

**Grafo:**  
Conjunto de nodos (vértices) conectados por aristas.  
La convención de nombres es $n =$ número de nodos y $m =$ número de aristas.  


**Camino:**  
Secuencia de nodos conectados por aristas. La longitud del camino es el número de aristas que lo componen.  

**Ciclo:**  
Camino que inicia y termina en el mismo nodo, por ejemplo $1 \to 3 \to 4 \to 1$.  

**Grafo conexo:**  
Existe un camino entre cualquier par de nodos. Si no lo hay, el grafo es disconexo.  

**Componentes:**  
Partes conexas e independientes de un grafo, por ejemplo $\{1,2,3\}, \{4,5,6,7\}, \{8\}$.  


**Árbol:**  
Grafo conexo que no contiene ciclos, por ejemplo uno con $5$ nodos y $4$ aristas.  

**Grafo dirigido:**  
Las aristas tienen una dirección $(u \to v)$, por ejemplo $3 \to 1 \to 2 \to 5$.  

**Grafo ponderado:**  
Cada arista tiene un peso o longitud, por ejemplo $1 \to 3 \to 4 \to 5$ con pesos $1 + 7 + 3 = 11$.  

**Vecinos o adyacentes:**  
Nodos conectados directamente por una arista, por ejemplo los vecinos de $2$ son $\{1,4,5\}$.  

**Grado de un nodo:**  
Número de vecinos de un nodo, por ejemplo $\deg(2) = 3$.  

**Suma de grados:**  
La suma de los grados en un grafo siempre es par: $\sum \deg(v) = 2m$.  

**Grafo regular:**  
Todos los nodos tienen el mismo grado $d$, por ejemplo $d = 3$ para todo nodo.  

**Grafo completo:**  
Cada par de nodos está conectado por una arista, de modo que $\deg(v) = n - 1$.  

**Grado de entrada (indegree):**  
Número de aristas que llegan a un nodo, por ejemplo $\text{indegree}(2) = 2$.  

**Grado de salida (outdegree):**  
Número de aristas que salen de un nodo, por ejemplo $\text{outdegree}(2) = 1$.  

**Grafo bipartito:**  
Sus nodos pueden colorearse con dos colores sin que adyacentes compartan color, por ejemplo $A = \{1,3,5\}$ y $B = \{2,4,6\}$.  

**Propiedad:**  
Un grafo es bipartito si y sólo si no tiene ciclos impares, es decir, $\text{bipartito} \Leftrightarrow \text{sin ciclos impares}$.


## Representaciones de Grafos

### Lista de Adyacencia

#### Grafos No Ponderados
En esta representación, cada nodo $x$ tiene una lista con los nodos a los que está conectado mediante una arista. Para grafos no dirigidos se puede guardar de la misma manera pero cada artista se guarda en ambos sentidos.

```cpp
vvi graph(n);

graph[1].push_back(2);
graph[2].push_back(3);
graph[2].push_back(4);
graph[3].push_back(4);
graph[4].push_back(1);
```

#### Grafos Ponderados

En este caso cada lista de nodos $u$ contiene pares de $v,w$ siempre que exista un camino entre $u$ y $v$ con peso $w$.

```cpp
using pi = pair<int,int>;
using vpi = vector<pi>;
using vvpi = vector<vpi>;

vvpi graph(n);

graph[1].push_back({2,5});
graph[2].push_back({3,7});
graph[2].push_back({4,6});
graph[3].push_back({4,5});
graph[4].push_back({1,2});
```

Con la lista de adyacencia nos permite de manera eficiente iterar sobre todos los nodos que estan conectados a un cierto nodo.

Para grafos no ponderados
```cpp
for (auto v : graph[u])
{
    // Process node v
}
```

Para grafos ponderados
```cpp
for (auto &c : graph[u])
{
    int v = c.first;
    int w = c.second;

    // Process node v
}
```

### Matiz de Adyacencia

### Lista de Aristas

```cpp
using tp = tuple<int,int,int>;
using vtp = vector<tp>;
using vvtp = vector<vtp>;

vvtp edges;
edges.push_back({1,2,5});

```


## Recorridos de Grafos

### Depth First Search (DFS)

La búsqueda en profundidad (DFS) es una técnica simple para recorrer grafos.

El algoritmo empieza en un nodo inicial y avanza hacia todos los nodos alcanzables desde él, siguiendo las aristas del grafo.


#### Recursivo

```cpp
void dfs(int u, vvi &graph, vb &visited)
{
    if (visited) return;
    visited[u] = true;

    // process node u
    for (auto v : graph[u])
        dfs(v, graph, visited);
}
```

#### Iterativo

```cpp
void dfs(int s, vvi &graph)
{
    vb visited(graph.size(), false);
    stack<int> st;

    visited[s] = true;
    st.push(s);

    while (!st.empty())
    {
        int u = st.top(); st.pop();
        // process node u
        for (auto v : graph[u])
        {
            if (visited[v]) continue;
            visited[v] = true;
            st.push(v);
        }
    }

}
```


## Breadth First Search (BFS)

La búsqueda en anchura (BFS) recorre los nodos de un grafo en orden creciente de distancia desde el nodo inicial.

De esta forma, se puede calcular la distancia del nodo inicial a todos los demás.


```cpp
void dfs(int s, vvi &graph)
{
    int n = graph.size();
    vb visited(n, false);
    vi distance(n, -1);
    queue<int> q;

    visited[s] = true;
    distance[s] = 0;
    q.push(s);

    while (!q.empty())
    {
        int u = st.front(); st.pop();
        // process node u
        for (auto v : graph[u])
        {
            if (visited[v]) continue;
            visited[v] = true;
            distance[v] = distance[u] + 1;
            q.push(v);
        }
    }

}
```
$\clearpage$
## Comprobaciones

### Conectividad

Un grafo es conexo si existe un camino entre cualquier par de nodos. Para comprobarlo, basta iniciar desde un nodo y verificar si se puede llegar a todos los demás.

```cpp
bool connected(vvi &graph, int s)
{
    vb visited(graph.size(), false);
    queue<int>q;
    
    q.push(s);
    visited[s] = true;

    while (!q.empty())
    {
        int u = q.front(); q.pop();
        for (auto v : graph[u])
        {
            if (!visited[v])
            {
                visited[v] = true;
                q.push(v);
            }
        }
    }

    for(auto x : visited)
        if (!x) return false;
    return true ;
}
```

$\clearpage$

### Ciclos

Un grafo tiene un ciclo si, al recorrerlo, encontramos un nodo cuyo vecino (distinto del anterior en el camino actual) ya fue visitado.

```cpp
bool hasCycle(vvi &graph)
{
    int n = graph.size();
    vb visited(n, false);

    function<bool(int, int)> dfs = [&](int u, int parent)
    {
        visited[u] = true;
        for (auto v : graph[u])
        {
            if (!visited[v])
                return dfs(v,u);
            else if (v != parent)
                return true;
        }
        return false;
    };

    forn(i,0,n)
    {
        if (!visited[i] && dfs(i, -1))
            return true;
    }
    return false;
}
```

$\clearpage$
### Bipartito

Un grafo es bipartito si sus nodos pueden colorearse con dos colores de forma que ningún par de nodos adyacentes tenga el mismo color.

```cpp
bool bipartite(vvi &graph)
{
    int n = graph.size();
    vi color(n, -1);
    
    forn(i,0,n)
    {
        if (color[i] == -1)
        {
            queue<int> q;
            q,push(i);
            color[i] = 0;

            while (!q.empty())
            {
                int u = q.front(); q.pop();
                for (auto v : graph[u]);
                {
                    if (color[v] == -1)
                    {
                        color[v] = 1 - color[u];
                        q.push(v);
                    }
                    else if (color[v] == color[u])
                        return false;
                }
            }
        }
    }
    return true;
}
```

$\clearpage$

## Camino más corto


### Dijkstra 
Dijkstra calcula las distancias más cortas desde un nodo inicial hasta todos los demás en un grafo con pesos no negativos. 

En cada paso elige el nodo con menor distancia actual, lo marca como procesado y actualiza las distancias de sus vecinos si encuentra un camino más corto. El proceso termina cuando todos los nodos han sido procesados.


```cpp
const int INF = 1e9;
vi dijkstra(int start, vvpi &graph) 
{
  int n = graph.size();
  vi vis(n, false), dist(n, INF);
  priority_queue<pi> q;
  
  dist[start] = 0;
  q.push({0, start});

  while (!q.empty()) {
    int u = q.top().second; q.pop();
    
    if (vis[u]) continue;
    vis[u] = true;


    for (auto [w, u] : adj[u]) {

      if (dist[u] + w < dist[v]) 
      {
        dist[v] = dist[u] + w;
        q.push({-dist[v], v});
      }
    }
  }
  return dist;
}
```


$\clearpage$

### Bellman-Ford

El algoritmo de Bellman–Ford calcula las distancias más cortas desde un nodo inicial incluso si existen aristas con pesos negativos. 

Repite $n−1$ veces la relajación de todas las aristas, actualizando las distancias si encuentra un camino más corto. Si en una ronda adicional alguna distancia aún se reduce, significa que existe un ciclo negativo.

```cpp
using viii = vector<tuple<int,int,int>>;
vi bellmanFord(int start, int n, viii&adj)
{
  vi dist(n, INF);
  
  dist[start] = 0;
  
  forn(i,0,n-1)
  {
    for (auto e : adj)
    {
      int u, v, w;
      tie(u, v, w) = e;
      dist[v] = min(dist[v], dist[u] + w);
    }
  }

  return dist;
}
```

### Floyd-Warshall

Floyd-Warshall encuentra las distancias mínimas entre todos los pares de nodos en un solo recorrido. Usa una matriz de distancias y en cada iteración permite que un nodo intermedio $k$ mejore las rutas existentes. Su simplicidad lo hace ideal para grafos pequeños donde $O(n^3)$ es aceptable.


```cpp
using viii = vector<tuple<int,int,int>>;

vvi floydWarshall(vvi &adj, int n)
{
  vvi d(n, vi(n, INF));

  forn(i,0,n)
  {
    forn(j,0,n)
    {
      if (i == j) d[i][j] = 0;
      else if (adj[i][j]) d[i][j] = d[i][j];
    }
  }

  forn(k,0,n)
    forn(i,0,n)
        forn(j,0,n)
            d[i][j] = min(d[i][j], d[i][k] + d[k][j]);

  return d;
}
```


### Topological Sort

Topological sort ordena los nodos de un grafo dirigido de forma que si existe un camino de $a$ a $b$, entonces $a$ aparece antes que $b$ en la lista; existe solo si el grafo es acíclico.  
Se realiza con una búsqueda en profundidad (DFS) donde cada nodo tiene tres estados:  
$0$ = no visitado, $1$ = en proceso, $2$ = procesado.

Cuando un nodo pasa a estado $2$ se agrega a la lista; si durante la DFS se encuentra un nodo en estado $1$, se detecta un ciclo.  
Al final, la lista se invierte para obtener el orden topológico.  $O(n + m)$


```cpp
vi topologicalSort(vvi &graph, int n)
{
  vi state(n, 0), order;
  bool has_cycle = false;

  function<void(int)> dfs = [&](int u)
  {
    state[u] = 1;
    for (int v : graph[u])
    {
      if (state[v] == 0) dfs(v);
      else if (state[v] == 1) has_cycle = true;
    }
    state[u] = 2;
    order.push_back(u);
  };

  forn(i, 0, n)
    if (state[i] == 0) dfs(i);

  if (has_cycle) return {};

  reverse(all(order));
  return order;
}
```
$\clearpage$

## Dynamic Programming for Graphs

La programación dinámica en grafos permite responder preguntas sobre caminos en grafos dirigidos acíclicos, como el camino más corto o más largo entre dos nodos, el número total de caminos posibles o qué nodos aparecen en todos ellos.  

Por ejemplo, para contar los caminos desde un nodo inicial a otro nodo, se define una función paths(x) que representa el número de caminos desde el nodo inicial hasta x. 


Como caso base, paths(a) = 1, y para los demás nodos se cumple la relación:  
$$paths(x) = paths(s_1) + paths(s_2) + \cdots + paths(s_k)$$  
donde $s_1, s_2, …, s_k$ son los nodos con aristas hacia x.  


Dado que el grafo es acíclico, estos valores pueden calcularse en el orden de un ordenamiento topológico.  
Esta técnica también se extiende para representar cualquier problema de programación dinámica como un grafo dirigido acíclico donde cada nodo representa un estado y las aristas indican dependencias entre estados.  
$$O(n + m)$$


```cpp
vi topo = topologicalSort(graph);

vi paths(n+1, 0);
paths[a] = 1;

for (int u : topo)
  for (int v : graph[u])
    paths[v] += paths[u];

cout << paths[b];
```

$\clearpage$

## Succesor Graphs

Los grafos sucesores (successor graphs) son grafos dirigidos donde cada nodo tiene exactamente un sucesor, formando componentes que consisten en un ciclo y caminos que llevan a él.  

Se pueden representar mediante una función succ(x) que indica el sucesor de cada nodo.  Para calcular eficientemente el sucesor después de k pasos, se precalculan los valores succ(x, k) donde k es potencia de dos usando la recurrencia:  

$$
succ(x, k) =
\begin{cases}
succ(x), & k = 1 \\\\
succ(succ(x, k/2), k/2), & k > 1
\end{cases}
$$

Esto permite calcular cualquier succ(x, k) descomponiendo k en sumas de potencias de dos, logrando un tiempo de $O(\log k)$ por consulta después de precalcular en $O(n \log u)$.

```cpp
int LOG = 20;
vvi succ(n, vi(LOG)); // next[i] is the inmediate succesor for i

forn(i,0,n) succ[i][0] = next[i];

forn(j,1,LOG)
  forn(i,0,n)
    succ[i][j] = succ[succ[i][j-1]][j-1];

int getKsuccesor(int start, int k)
{
  forn(j,0,LOG)
    if (k & (1 << j))
      x = succ[x][j];
  return x;
}
```

$\clearpage$

### Deteccion de Ciclos

En un grafo sucesor que consiste en un camino que termina en un ciclo, podemos preguntar: dado un nodo inicial $x$, ¿cuál es el primer nodo del ciclo y cuántos nodos tiene el ciclo?  
Una forma eficiente de detectar el ciclo es el algoritmo de Floyd: usamos dos punteros, $a$ y $b$, que comienzan en el nodo inicial $x$; $a$ avanza un paso por turno y $b$ avanza dos pasos. Cuando se encuentran, sabemos que hay un ciclo.  

Para encontrar el primer nodo del ciclo, movemos $a$ de nuevo al nodo inicial $x$ y avanzamos ambos punteros paso a paso hasta que se encuentren.  

Finalmente, para obtener la longitud del ciclo, recorremos el ciclo desde ese nodo hasta volver a él, contando los nodos.  
$O(n)$ tiempo y $O(1)$ memoria.

```cpp
int findCycle(int x, vi &succ, int &len)
{
  int a = succ[x];
  int b = succ[succ[x]];

  while (a != b)
  {
    a = succ[a];
    b = succ[succ[b]];
  }

  a = x;
  while (a != b)
  {
    a = succ[a];
    b = succ[b];
  }

  int first = a;
  b = succ[first];
  len = 1;

  while (b != first)
  {
    b = succ[b];
    len++;
  }

  return first;
}
```
$\clearpage$
### Puentes 

Un puente en un grafo es una arista cuya eliminación dividiría el grafo en dos o más componentes conexas adicionales.

```cpp
vector<pii> find_bridges(vvi &g) 
{
    int n = g.size(), t = 0;
    vi tin(n, -1), low(n, -1);
    vector<pii> bridges;

    function<void(int,int)> dfs = [&](int u, int p) 
    {
        tin[u] = low[u] = t++;
        for (int v : g[u]) 
        {
            if (v == p) continue;
            if (tin[v] != -1)
                low[u] = min(low[u], tin[v]);
            else 
            {
                dfs(v, u);
                low[u] = min(low[u], low[v]);
                if (low[v] > tin[u]) 
                  bridges.push_back({u,v});
            }
        }
    };

    forn(i,n) if (tin[i] == -1) dfs(i, -1);
    return bridges;
}
```

