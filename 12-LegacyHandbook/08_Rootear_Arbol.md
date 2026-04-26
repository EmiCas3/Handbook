# Rootear un árbol
Rootear un árbol consiste en designar un nodo como raíz y establecer relaciones padre-hijo mediante DFS o BFS desde ese nodo. Este proceso transforma un árbol no dirigido en un árbol dirigido con jerarquía, facilitando operaciones como cálculo de ancestros, profundidades y aplicación de algoritmos de programación dinámica en árboles. La complejidad es $O(n)$ y la elección de la raíz puede optimizarse usando el centroide para minimizar la altura.

```cpp
#include <iostream>
#include <vector>

using namespace std;

vector<int> treeCenters(vector<vector<int>>& g) {
    int n = g.size();
    vector<int> degree(n, 0);
    vector<int> leaves;

    for (int i = 0; i < n; i++) {
        degree[i] = g[i].size();
        if (degree[i] == 0 || degree[i] == 1) {
            leaves.push_back(i);
            degree[i] = 0;
        }
    }

    int count = leaves.size();

    while (count < n) {
        vector<int> new_leaves;
        for (int node : leaves) {
            for (int neighbor : g[node]) {
                degree[neighbor] = degree[neighbor] - 1;
                if (degree[neighbor] == 1) {
                    new_leaves.push_back(neighbor);
                }
                degree[node] = 0;
            }
        }
        count += new_leaves.size();
        leaves = new_leaves;
    }

    return leaves; // Centros (center) del árbol
}

void dfs(vector<vector<int>>& g, vector<bool>& visited, vector<vector<int>>& rootedTree, int node) {
    if (!visited[node]) {
        visited[node] = true;
        for (int neighbor : g[node]) {
            if (!visited[neighbor]) {
                rootedTree[node].push_back(neighbor);
                dfs(g, visited, rootedTree, neighbor);
            }
        }
    }
}

int main() {
    // Definir el grafo no dirigido como una lista de adyacencia
    int n = 6;
    vector<vector<int>> graph(n);

    // Agregar las conexiones del grafo
    graph[0].push_back(1);
    graph[1].push_back(0);
    graph[1].push_back(2);
    graph[2].push_back(1);
    graph[2].push_back(3);
    graph[3].push_back(2);
    graph[3].push_back(4);
    graph[4].push_back(3);
    graph[4].push_back(5);
    graph[5].push_back(4);

    vector<int> centers = treeCenters(graph);

    cout << "Centro(s) del árbol: ";
    for (int center : centers) {
        cout << center << " ";
    }
    cout << endl;

    // Elegir el primer centro como raíz
    int root = centers[0];

    vector<vector<int>> rootedTree(n);
    vector<bool> visited(n, false);
    
    dfs(graph, visited, rootedTree, root);

    cout << "Grafo enraizado desde el centro:" << endl;
    for (int i = 0; i < n; i++) {
        cout << i << ": ";
        for (int neighbor : rootedTree[i]) {
            cout << neighbor << " ";
        }
        cout << endl;
    }

    return 0;
}
```