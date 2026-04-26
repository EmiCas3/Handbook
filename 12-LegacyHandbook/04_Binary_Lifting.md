# Binary Lifting

Binary Lifting es una técnica de preprocesamiento para responder consultas de ancestros en árboles en tiempo logarítmico. Precalcula para cada nodo sus ancestros a distancias potencias de dos ($2^{0}$, $2^{1}$, $2^{2}$, \ldots) mediante programación dinámica, permitiendo alcanzar cualquier ancestro k-ésimo mediante descomposición binaria de k. Con complejidad $O(n \log n)$ de preprocesamiento y $O(\log n)$ por consulta, es fundamental para implementar Lowest Common Ancestor (LCA) eficientemente.

```cpp
#include <iostream>
#include <vector>
#include <cmath>

const int MAXN = 100005; // Número máximo de nodos
const int LOGN = 18;    // Logaritmo base 2 del número máximo de nodos

std::vector<int> adj[MAXN];
int parent[MAXN];
int dp[MAXN][LOGN];
int depth[MAXN];

void dfs(int u, int p, int d) {
    parent[u] = p;
    depth[u] = d;
    dp[u][0] = p; // El $2^0$-ésimo ancestro es el padre

    // Precalculamos los ancestros para todos los nodos
    for (int i = 1; i < LOGN; ++i) {
        dp[u][i] = dp[dp[u][i - 1]][i - 1];
    }

    for (int v : adj[u]) {
        if (v != p) {
            dfs(v, u, d + 1);
        }
    }
}

// Función para encontrar el k-ésimo ancestro de un nodo u
int get_kth_ancestor(int u, int k) {
    // Si k es mayor que la profundidad del nodo, no existe el ancestro
    if (k > depth[u]) {
        return -1; // Indicador de que no hay ancestro
    }

    // Recorremos los bits de k
    for (int i = 0; i < LOGN; ++i) {
        if ((k >> i) & 1) { // Si el i-ésimo bit es 1
            u = dp[u][i];
        }
    }
    return u;
}

int main() {
    // Ejemplo de uso: Construir un árbol y precalcular
    int n; // número de nodos
    std::cin >> n;

    // Leer aristas (ejemplo: arista entre u y v)
    // ...

    // Llama a la DFS para precalcular dp y depth
    dfs(1, 0, 0); // Asumiendo que la raíz es 1 y su padre es 0

    int u, k;
    std::cin >> u >> k;

    int ancestor = get_kth_ancestor(u, k);

    if (ancestor != -1) {
        std::cout << "El " << k << "-ésimo ancestro de " << u << " es " << ancestor << std::endl;
    } else {
        std::cout << "No tiene un " << k << "-ésimo ancestro." << std::endl;
    }

    return 0;
}
```