
$$ \clearpage $$

### Strong Connectivity


### Kosaraju

El algoritmo de **Kosaraju** encuentra las **componentes fuertemente conexas (SCC)** en un grafo dirigido, donde cada componente es un conjunto de nodos que se alcanzan mutuamente. El proceso tiene dos fases:  
1️⃣ Realiza un DFS normal y guarda los nodos según su orden de finalización.  
2️⃣ Invierte las aristas y ejecuta DFS en ese orden inverso para formar las SCC.  

Cada nodo se visita exactamente dos veces, por lo que su complejidad es $O(n+m)$.

```cpp
#define pb push_back
vvi kosaraju(vvi &g, int n)
{
  vvi rg(n), scc;
  vb vis(n,0);
  vi order;
  
  forn(u,0,n) 
    for (int v : g[u]) 
        rg[v].pb(u);

  function<void(int)> dfs1 = [&](int u)
  {
    vis[u] = 1;
    for (int v : g[u]) 
        if (!vis[v]) dfs1(v);
    order.pb(u);
  };

  function<void(int,vi&)> dfs2 = [&](int u, vi &comp)
  {
    vis[u] = 1;
    comp.pb(u);
    for (int v : rg[u]) 
        if (!vis[v]) dfs2(v, comp);
  };


  forn(i,0,n) 
    if (!vis[i]) dfs1(i);

  fill(all(vis),0);
  reverse(all(order));


  for (int u : order)
    if (!vis[u])
    {
      vi comp;
      dfs2(u, comp);
      scc.pb(comp);
    }

  return scc;
}
```

### 2 SAT

### 2-SAT

El **problema 2-SAT** consiste en determinar si es posible asignar valores de verdad a un conjunto de variables booleanas $x_1, x_2, ..., x_n$ para que una fórmula de la forma  
$(a_1 \lor b_1) \land (a_2 \lor b_2) \land \dots \land (a_m \lor b_m)$ sea verdadera, donde cada $a_i$ y $b_i$ son una variable o su negación.  

Cada cláusula $(a \lor b)$ genera dos **implicaciones**: ¬a → b y ¬b → a. Con esto, construimos un **grafo de implicaciones** y verificamos si existe una variable $x_i$ y su negación ¬$x_i$ en la misma **componente fuertemente conexa (SCC)**.  
Si eso ocurre, la fórmula es **insatisfacible**. Si no ocurre, la fórmula **tiene solución**, que se obtiene procesando las componentes en orden topológico inverso.  
Su complejidad es $O(n + m)$.

### 2-SAT

El **problema 2-SAT** busca determinar si se pueden asignar valores de verdad a las variables booleanas $x_1, x_2, \dots, x_n$ para que  
$(a_1 \lor b_1) \land (a_2 \lor b_2) \land \dots \land (a_m \lor b_m)$ sea verdadera, donde cada $a_i$ y $b_i$ es una variable o su negación.  

Por ejemplo, la fórmula  
$$(x_2 \lor \lnot x_1) \land (\lnot x_1 \lor \lnot x_2) \land (x_1 \lor x_3) \land (\lnot x_2 \lor \lnot x_3) \land (x_1 \lor x_4)$$  
es verdadera cuando las variables toman los valores:  
$$
\begin{cases}
x_1 = \text{false} \\\\
x_2 = \text{false} \\\\
x_3 = \text{true} \\\\
x_4 = \text{true}
\end{cases}
$$  

Cada cláusula $(a \lor b)$ genera dos **implicaciones**: ¬a → b y ¬b → a. Con esto se construye un **grafo de implicaciones**, donde el problema es **insatisfacible** si existe una variable $x_i$ y su negación ¬$x_i$ en la misma **componente fuertemente conexa (SCC)**.  
Si no ocurre, la fórmula tiene solución, y los valores se obtienen procesando las componentes en orden topológico inverso. Su complejidad es $O(n+m)$.

$\clearpage$

```cpp
struct TwoSAT
{
  int n;
  vvi g, rg;
  vb val, vis;
  vi order, comp;
  TwoSAT(int n) : n(n), g(2*n), rg(2*n),
                  val(n, 0), vis(2*n, 0),
                  comp(2*n, -1) {}

  int neg(int x) { return x ^ 1; } 

  void addClause(int a, bool na, int b, bool nb)
  {
    a = 2*a ^ na;
    b = 2*b ^ nb;

    g[neg(a)].pb(b);
    g[neg(b)].pb(a);

    rg[b].pb(neg(a));
    rg[a].pb(neg(b));
  }

  void dfs1(int u)
  {
    vis[u] = 1;
    for (int v : g[u])
      if (!vis[v]) dfs1(v);
    order.pb(u);
  }

  void dfs2(int u, int c)
  {
    comp[u] = c;
    for (int v : rg[u])
      if (comp[v] == -1) dfs2(v, c);
  }

  bool solve()
  {
    forn(i, 0, 2*n)
      if (!vis[i]) dfs1(i);

    reverse(all(order));
    int c = 0;

    for (int u : order)
      if (comp[u] == -1) dfs2(u, c++);

    forn(i, 0, n)
    {
      if (comp[2*i] == comp[2*i^1])
        return 0;
      val[i] = comp[2*i] > comp[2*i^1];
    }
    return 1;
  }
};
```


### Eulerian Paths and Circuits  

Un **camino Euleriano** es aquel que recorre **cada arista exactamente una vez**.  
Si el camino empieza y termina en el mismo nodo, se llama **circuito Euleriano**.  

En **grafos no dirigidos**, existe un camino Euleriano si todas las aristas están en la misma componente conexa y:
- Todos los nodos tienen grado par, o  
- Exactamente dos nodos tienen grado impar (estos serán los extremos del camino).

En **grafos dirigidos**, se cumple si todas las aristas pertenecen a la misma componente y:
- Cada nodo tiene el mismo número de entradas y salidas (circuito Euleriano), o  
- Hay un nodo con una salida más que entradas (inicio) y otro con una entrada más que salidas (final).  

Para **construir** un circuito o camino Euleriano se usa el **algoritmo de Hierholzer**, que:
1. Empieza desde un nodo con aristas disponibles.  
2. Recorre aristas sin repetir hasta regresar al inicio (subcircuito).  
3. Inserta subcircuitos dentro del circuito principal hasta usar todas las aristas.  

Su complejidad es $O(n+m)$, ya que cada arista se recorre una vez.

$\clearpage$

```cpp
vi eulerianPath(vvi &graph, int n)
{
  vi indeg(n, 0), outdeg(n, 0), path;
  vpi st;

  int start = 0, end = 0, cnt = 0;

  forn(u, 0, n)
    for (int v : adj[u])
    {
      outdeg[u]++;
      indeg[v]++;
    }

  forn(i, 0, n)
  {
    if (outdeg[i] - indeg[i] == 1) 
        start = i, cnt++;
    else if (indeg[i] - outdeg[i] == 1) 
        end = i, cnt++;
  }

  if (cnt != 0 && cnt != 2) 
    return {};

  st.push_back({start, 0});

  while (!st.empty())
  {
    auto &[u, i] = st.back();

    if (i < graph[u].size())
    {
      int v = graph[u][i++];
      st.push_back({v, 0});
    }
    else
    {
      path.pb(u);
      st.pop_back();
    }
  }

  reverse(all(path));
  return path;
}
```

### Hamiltonian Path

El **camino Hamiltoniano** recorre **cada vértice exactamente una vez**, y si empieza y termina en el mismo vértice, se denomina **circuito Hamiltoniano**.  
Encontrar uno es un problema **NP-hard**, ya que no existe un algoritmo eficiente general. Sin embargo, usando **programación dinámica con bitmask**, se puede verificar su existencia en tiempo $O(2^n n^2)$.

$$dp[mask][u] = \bigvee_{v \in mask,\, adj[v][u]} dp[mask \setminus \{u\}][v]$$

```cpp
vi hamiltonian_path(vvi &graph)
{
  int n = graph.size();
  vvi dp(1<<n, vi(n,-1)), par(1<<n, vi(n,-1));

  function<int(int,int)> dfs = [&](int m, int u)
  {
    if(m==(1<<n)-1) return 1;
    int &r=dp[m][u];
    if(r!=-1) return r;
    r=0;
    forn(v,0,n) if(graph[u][v] && !(m&(1<<v)))
      if(dfs(m|(1<<v), v))
      { par[m][u]=v; r=1; break; }
    return r;
  };

  forn(s,0,n) if(dfs(1<<s,s))
  {
    vi p={s};
    int m=1<<s,u=s;
    while(par[m][u]!=-1)
        { u=par[m][u]; m|=1<<u; p.push_back(u); }
    return p;
  }
  return {};
}
```
$\clearpage$
### De Bruijn Sequences  
Una **secuencia de De Bruijn** es una cadena que contiene **todas las posibles subcadenas de longitud $n$** exactamente una vez, usando un alfabeto de $k$ símbolos.  
La longitud total es $k^n + n - 1$.  
Por ejemplo, con $n = 3$ y $k = 2$, una secuencia válida es `0001011100`,  
que incluye todas las combinaciones binarias de 3 bits: 000, 001, 010, 011, 100, 101, 110 y 111.  

Cada secuencia De Bruijn corresponde a un **camino Euleriano** en un grafo donde cada nodo representa una cadena de $n − 1$ símbolos y cada arista agrega uno nuevo.  
Al recorrer el camino Euleriano y concatenar los símbolos, se obtiene la secuencia completa de longitud $k^n + n − 1$.  

```cpp
string debruijn(int k, int n)
{
  vi a(k*n,0);
  string s;
  function<void(int,int)> db=[&](int t,int p)
  {
    if(t>n)
    {
      if(n%p==0) forn(j,1,p+1) s.push_back('0'+a[j]);
    }
    else
    {
      a[t]=a[t-p];
      db(t+1,p);
      forn(j,a[t-p]+1,k-1) { a[t]=j; db(t+1,t); }
    }
  };
  db(1,1);
  s.resize(s.size() + n - 1, '0');
  return s;
}
```

$\clearpage$

### Knight’s Tour

Un recorrido del caballo es una secuencia de movimientos en un tablero $n × n$ donde el caballo visita cada casilla exactamente una vez.
Si termina en el punto de inicio, se llama recorrido cerrado; de lo contrario, es abierto.
El problema equivale a encontrar un camino Hamiltoniano en el grafo formado por las casillas como nodos y los movimientos válidos del caballo como aristas.

El recorrido puede generarse por backtracking, pero se acelera con la regla de Warnsdorf,que elige siempre el movimiento hacia la casilla con el menor número de movimientos siguientes posibles.

```cpp
int dx[8]={1,2,2,1,-1,-2,-2,-1},dy[8]={2,1,-1,-2,-2,-1,1,2};

bool knightsTour(int n, vvi &b, int x, int y, int mv)
{
  if(mv==n*n) return true;
  vector<pair<int,pi>> nxt;
  forn(d,0,8)
  {
    int nx=x+dx[d],ny=y+dy[d];
    if(nx<0||ny<0||nx>=n||ny>=n||b[nx][ny]!=-1) continue;
    int c=0;
    forn(k,0,8)
    {
      int tx=nx+dx[k],ty=ny+dy[k];
      if(tx>=0&&ty>=0&&tx<n&&ty<n&&b[tx][ty]==-1) c++;
    }
    nxt.push_back({c,{nx,ny}});
  }
  sort(nxt.begin(),nxt.end());
  for(auto [c,p]:nxt)
  {
    auto [nx,ny]=p;
    b[nx][ny]=mv;
    if(knightsTour(n,b,nx,ny,mv+1)) return true;
    b[nx][ny]=-1;
  }
  return false;
}
```

$\clearpage$


# Flujos

## Red de Flujos

Una red de flujo es un grafo dirigido con:
- V vértices y E aristas
- Cada arista tiene una capacidad c(u,v) ≥ 0
- Hay una fuente s y un sumidero t

Un flujo f(u,v) cumple:
1) 0 $\leq$ f(u,v) $\leq$ c(u,v)
2) Conservación del flujo en todo vértice excepto s y t: suma de flujos que entran = suma de flujos que salen

Objetivo:
Enviar todo el flujo posible desde s hasta t.

## Grafo Residual

El grafo residual contiene:
- Aristas con capacidad disponible: residual = c(u,v) - f(u,v)
- Aristas reversas con residual = f(u,v)

Si existe flujo hacia adelante, puede enviarse más;
si existe flujo hacia atrás, puede revertirse parte del flujo.

Este grafo cambia dinámicamente durante el algoritmo, para la lectura se tienen que realizar algunas modificaciones.

```cpp
vvi graph(n), cap(n, vi(n));
int u,v,w;
forn(i,0,m)
{
    cin>>u>>v>>w;
    graph[u].push_back(v);
    graph[v].pus_back(u);
    cap[u][v] += w;
}
```

$\clearpage$


## Ford-Fulkerson

Idea:
Mientras exista un camino aumentante de s → t en el grafo residual:
 - Se calcula el mínimo residual C en ese camino
 - Se aumenta el flujo en C a lo largo del camino
 - Se actualizan capacidades residuales

Termina cuando ya no hay camino aumentante.
Complejidad: O(E * F) donde F = flujo máximo
(Si las capacidades son enteras, siempre termina)


```cpp
int fordFulkerson(vvi &graph, vvi &cap, int s, int t) 
{
    int n = graph.size(), flow = 0;

    function<int(int,int,int,vi&)> dfs = [&](int u, int t, int f, vi &vis) {
        if (u == t) return f;
        vis[u] = 1;
        for (int v : graph[u]) 
        {
            if (!vis[v] && cap[u][v] > 0) 
            {
                int pushed = dfs(v, t, min(f, cap[u][v]), vis);
                if (pushed > 0) {
                    cap[u][v] -= pushed;
                    cap[v][u] += pushed;
                    return pushed;
                }
            }
        }
        return 0;
    };

    while (true) 
    {
        vi vis(n);
        int pushed = dfs(s, t, 1e9, vis);
        if (!pushed) break;
        flow += pushed;
    }
    return flow;
}
```

$\clearpage$

## Edmonds-Karps

Mejora de Ford–Fulkerson: usar BFS para encontrar caminos aumentantes
 → Elige siempre el camino más corto en número de aristas

Complejidad garantizada:
O(V * E^2) incluso con capacidades irracionales

Es el algoritmo estándar para Max-Flow en competiciones.

```cpp
int edmondsKarp(vvi &graph, vvi &cap, int s, int t) 
{
    int n = graph.size(), flow = 0;
    while (true) 
    {
        vi parent(n, -1);
        parent[s] = -2;
        queue<pi> q;
        q.push({s, 1e9});
        int pushed = 0;

        while (!q.empty()) 
        {
            auto [u, f] = q.front(); q.pop();
            for (int v : graph[u])
            {
                if (parent[v] == -1 && cap[u][v] > 0) 
                {
                    parent[v] = u;
                    int new_flow = min(f, cap[u][v]);
                    if (v == t) { pushed = new_flow; break; }
                    q.push({v, new_flow});
                }
            }
            if (pushed) break;
        }
        if (!pushed) break;

        int v = t;
        while (v != s) 
        {
            int u = parent[v];
            cap[u][v] -= pushed;
            cap[v][u] += pushed;
            v = u;
        }
        flow += pushed;
    }
    return flow;
}
```

$\clearpage$

## Teorema del Corte Minimo

Teorema:
El valor del flujo máximo es igual al valor del mínimo corte

Un s-t cut es una partición de los vértices:
- S contiene a s
- T contiene a t
Se suman capacidades de aristas de S → T

No se puede mandar más flujo del valor del corte mínimo
y Ford–Fulkerson demuestra que sí se puede llegar a ese valor.

```cpp
pair<vpi,int> minCut(vvi &graph, vvi &cap, int s, int t)
{
    int n = graph.size(), sum = 0;
    vvi orig = cap; 
    vi vis(n, 0);
    vpi cut;
    queue<int> q;


    edmondsKarp(graph, cap, s, t);

    q.push(s);
    vis[s] = 1;
    while (!q.empty())
    {
        int u = q.front(); q.pop();
        for (int v : graph[u])
        {
            if (!vis[v] && cap[u][v] > 0)
            {
                vis[v] = 1;
                q.push(v);
            }
        }
    }

    forn(u,0,n) if (vis[u])
    {
        for (int v : graph[u])
        {
            if (!vis[v] && orig[u][v] > 0)
            {
                cut.eb(u,v);
                sum += orig[u][v];
            }
        }
    }
    return {cut, sum};
}
pair<vpi,int> minCut(vvi &graph, vvi &cap, int s, int t)
{
    int n = graph.size(), sum = 0;
    vvi orig = cap;
    vpi cut;
    vi vis(n, 0);
    queue<int> q;

    edmondsKarp(graph, cap, s, t);

    q.push(s);
    vis[s] = 1;
    while (!q.empty())
    {
        int u = q.front(); q.pop();
        for (int v : graph[u])
        {
            if (!vis[v] && cap[u][v] > 0)
            {
                vis[v] = 1;
                q.push(v);
            }
        }
    }

    forn(u,0,n) if (vis[u])
    {
        for (int v : graph[u])
        {
            if (!vis[v] && orig[u][v] > 0)
            {
                cut.eb(u,v);
                sum += orig[u][v];
            }
        }
    }
    return {cut, sum};
}
```

### Disjoint Paths

Los caminos disjuntos en aristas se encuentran asignando capacidad 1 a cada arista y calculando el flujo máximo. Cada unidad de flujo representa un camino independiente entre la fuente y el sumidero.

Para los caminos disjuntos en nodos, se divide cada vértice en dos (entrada y salida) conectados por una arista con capacidad 1, asegurando que cada nodo solo pueda usarse en un camino. El máximo flujo en esta red equivale al número máximo de caminos nodo-disjuntos.

```cpp
int nodeDisjointPaths(int n, vpi &edges, int s, int t)
{
    int m = 2*n;
    vvi graph(m), cap(N, vi(m, 0));
    forn(i,0,n)
    {
        graph[i].pb(i+n);
        cap[i][i+n] = 1;
    }
    for (auto [u,v] : edges)
    {
        graph[u+n].pb(v);
        graph[v].pb(u+n);
        cap[u+n][v] = 1;
    }
    return edmondsKarp(graph, cap, s+n, t);
}
```


## Bipartite Matching

El emparejamiento máximo bipartito se reduce fácilmente a un problema de flujo máximo: se conectan todos los nodos izquierdos con la fuente y todos los derechos con el sumidero, asignando capacidad 1 a cada arista. El valor del flujo máximo equivale al tamaño del emparejamiento máximo.

El teorema de Hall establece cuándo existe un emparejamiento perfecto: para todo subconjunto de nodos izquierdos X, su conjunto de vecinos f(X) debe cumplir |X| ≤ |f(X)|. Si alguna elección viola esta condición, no puede formarse un emparejamiento perfecto.

```cpp
int bipartiteMatching(int nLeft, int nRight, vector<pi> &edges)
{
    int n = nLeft + nRight + 2;
    int s = nLeft + nRight;
    int t = s + 1;

    vvi graph(n);
    vvi cap(n, vi(n, 0));

    // conexiones desde fuente a nodos izquierdos
    forn(i,0,nLeft)
    {
        graph[s].pb(i);
        graph[i].pb(s);
        cap[s][i] = 1;
    }

    // conexiones entre conjuntos izquierdo y derecho
    for (auto [u,v] : edges)
    {
        int left = u;
        int right = nLeft + v;
        graph[left].pb(right);
        graph[right].pb(left);
        cap[left][right] = 1;
    }

    // conexiones desde nodos derechos al sumidero
    forn(i,0,nRight)
    {
        int r = nLeft + i;
        graph[r].pb(t);
        graph[t].pb(r);
        cap[r][t] = 1;
    }

    return edmondsKarp(graph, cap, s, t);
}
```

$\clearpage$

## Puentes

Un puente en un grafo es una arista cuya eliminación dividiría el grafo en dos o más componentes conexas adicionales.

```cpp
void findBridges(vvi &graph)
{
    int n = graph.size();
    int timer = 0;
    vb vis(n, false);
    vi tin(n, -1), low(n, -1);

    auto IS_BRIDGE = [&](int u, int v)
    {
        cout << u << " " << v << "\n";
    };

    function<void(int,int)> dfs = [&](int u, int p)
    {
        vis[u] = true;
        tin[u] = low[u] = timer++;
        for (int v : graph[u])
        {
            if (v == p) continue;
            if (vis[v]) low[u] = min(low[u], tin[v]);
            else
            {
                dfs(v, u);
                low[u] = min(low[u], low[v]);
                if (low[v] > tin[u]) IS_BRIDGE(u, v);
            }
        }
    };

    forn(i,0,n)
        if (!vis[i])
            dfs(i, -1);
}
```

## Puntos de articulacion

```cpp
void findArticulationPoints(vvi &graph)
{
    int n = graph.size();
    int timer = 0;
    vb vis(n, false);
    vi tin(n, -1), low(n, -1);

    auto IS_CUTPOINT = [&](int u)
    {
        cout << u << "\n";
    };

    function<void(int,int)> dfs = [&](int u, int p)
    {
        vis[u] = true;
        tin[u] = low[u] = timer++;
        int ch = 0;

        for (int v : graph[u])
        {
            if (v == p) continue;
            if (vis[v]) low[u] = min(low[u], tin[v]);
            else
            {
                dfs(v, u);
                low[u] = min(low[u], low[v]);
                if (low[v] >= tin[u] && p != -1) IS_CUTPOINT(u);
                ++ch;
            }
        }

        if (p == -1 && ch > 1) IS_CUTPOINT(u);
    };

    forn(i,0,n)
        if (!vis[i])
            dfs(i, -1);
}
```