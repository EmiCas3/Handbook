# Algoritmo de Tarjan para Componentes Fuertemente Conexos

El algoritmo de Tarjan identifica componentes fuertemente conexas en grafos dirigidos en $O(V+E)$ mediante DFS con un solo recorrido. Utiliza una pila y dos arreglos: tiempos de descubrimiento y valores "low" que rastrean el ancestro más bajo alcanzable. Cuando un nodo tiene $low[v] = disc[v]$, identifica la raíz de una componente fuertemente conexa. Este algoritmo es fundamental para análisis de conectividad, detección de ciclos y problemas de satisfacibilidad.

```cpp
#include <iostream>
#include <vector>
#include <stack>
#include <algorithm>

using namespace std;

void tarjan(int u, vector<vector<int>>& grafo, vector<int>& ids, vector<int>& bajos, stack<int>& pila, vector<bool>& enPila, int& idActual, vector<vector<int>>& componentes) {
    ids[u] = bajos[u] = idActual++;
    pila.push(u);
    enPila[u] = true;

    for (int v : grafo[u]) {
        if (ids[v] == -1) {
            tarjan(v, grafo, ids, bajos, pila, enPila, idActual, componentes);
        }
        if (enPila[v]) {
            bajos[u] = min(bajos[u], bajos[v]);
        }
    }

    if (ids[u] == bajos[u]) {
        vector<int> componente;
        while (true) {
            int nodo = pila.top();
            pila.pop();
            enPila[nodo] = false;
            componente.push_back(nodo);
            if (nodo == u) {
                break;
            }
        }
        componentes.push_back(componente);
    }
}

vector<vector<int>> encontrarComponentesFuertementeConexos(vector<vector<int>>& grafo) {
    int n = grafo.size();
    vector<int> ids(n, -1);
    vector<int> bajos(n, -1);
    vector<bool> enPila(n, false);
    stack<int> pila;
    int idActual = 0;
    vector<vector<int>> componentes;

    for (int i = 0; i < n; i++) {
        if (ids[i] == -1) {
            tarjan(i, grafo, ids, bajos, pila, enPila, idActual, componentes);
        }
    }

    return componentes;
}

int main() {
    int V = 5;
    vector<vector<int>> grafo(V);

    grafo[0].push_back(1);
    grafo[1].push_back(2);
    grafo[2].push_back(0);

    grafo[3].push_back(4);

    vector<vector<int>> componentes = encontrarComponentesFuertementeConexos(grafo);

    cout << "Componentes fuertemente conexos:" << endl;
    for (const vector<int>& componente : componentes) {
        for (int nodo : componente) {
            cout << nodo << " ";
        }
        cout << endl;
    }

    return 0;
}
```