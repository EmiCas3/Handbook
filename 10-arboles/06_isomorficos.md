# Identificar dos arboles isomorficos

```cpp

using namespace std;

// Función para realizar un recorrido DFS desde el nodo raíz central
void dfs(int u, int parent, vvi &graph, vi& code) 
{
    code.push_back(1);  // Etiqueta de apertura
    for (int v : graph[u]) 
    {
        if (v != parent) 
            dfs(v, u, graph, code);
    }
    code.push_back(0);  // Etiqueta de cierre
}

// Función para generar el código AHU de un grafo en forma de lista de adyacencia
vi AHU_Code(vvi& graph, int root) {
    vector<int> code;
    dfs(root, -1, graph, code);
    return code;
}


int main() {
    // Definir los grafos como listas de adyacencia
    vvi graph1 = {{1, 2}, {0, 3}, {0, 3}, {1, 2}};
    vvi graph2 = {{1, 2, 3}, {0, 4}, {0, 4}, {0, 4}, {1, 2, 3}};

    // Supongamos que el nodo raíz central es el nodo 0 en ambos grafos
    int root = 0;

    // Generar códigos AHU para ambos grafos
    vvi code1 = AHU_Code(graph1, root);
    vvi code2 = AHU_Code(graph2, root);

    // Verificar si los códigos son iguales
    if (code1 == code2) {
        cout << "Los grafos son isomorfos." << endl;
    } else {
        cout << "Los grafos no son isomorfos." << endl;
    }

    return 0;
}

```