# Identificar dos arboles isomorficos

Determinar si dos árboles son isomorfos implica verificar si existe una biyección que preserve adyacencias. El algoritmo $AHU (Aho, Hopcroft, Ullman)$ resuelve esto en $O(n)$ mediante hashing canónico: asigna etiquetas únicas a subárboles desde las hojas hacia la raíz, creando una representación invariante bajo isomorfismo. Dos árboles son isomorfos si sus representaciones canónicas coinciden, siendo útil en detección de patrones estructurales.

```cpp
using namespace std;

// Función para realizar un recorrido DFS desde el nodo raíz central
void DFS(int u, int parent, vector<vector<int>>& graph, vector<int>& code) {
    code.push_back(1);  // Etiqueta de apertura
    for (int v : graph[u]) {
        if (v != parent) {
            DFS(v, u, graph, code);
        }
    }
    code.push_back(0);  // Etiqueta de cierre
}

// Función para generar el código AHU de un grafo en forma de lista de adyacencia
vector<int> AHU_Code(vector<vector<int>>& graph, int root) {
    vector<int> code;
    DFS(root, -1, graph, code);
    return code;
}

// Función para verificar si dos códigos AHU son iguales
bool areCodesEqual(const vector<int>& code1, const vector<int>& code2) {
    return code1 == code2;
}

int main() {
    // Definir los grafos como listas de adyacencia
    vector<vector<int>> graph1 = {{1, 2}, {0, 3}, {0, 3}, {1, 2}};
    vector<vector<int>> graph2 = {{1, 2, 3}, {0, 4}, {0, 4}, {0, 4}, {1, 2, 3}};

    // Supongamos que el nodo raíz central es el nodo 0 en ambos grafos
    int root = 0;

    // Generar códigos AHU para ambos grafos
    vector<int> code1 = AHU_Code(graph1, root);
    vector<int> code2 = AHU_Code(graph2, root);

    // Verificar si los códigos son iguales
    if (areCodesEqual(code1, code2)) {
        cout << "Los grafos son isomorfos." << endl;
    } else {
        cout << "Los grafos no son isomorfos." << endl;
    }

    return 0;
}
```