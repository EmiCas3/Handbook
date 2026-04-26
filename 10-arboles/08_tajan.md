# Algoritmo de Tarjan para Componentes Fuertemente Conexos

```cpp
void tarjan(int u, vvi& grafo, vi& ids, vi& bajos, stack<int>& pila, vb& enPila, int& idActual, vvi& componentes) {
    ids[u] = bajos[u] = idActual++;
    pila.push(u);
    enPila[u] = true;

    for (int v : grafo[u]) 
    {
        if (ids[v] == -1) 
        {
            tarjan(v, grafo, ids, bajos, pila, enPila, idActual, componentes);
        }
        if (enPila[v]) 
            bajos[u] = min(bajos[u], bajos[v]);
    }

    if (ids[u] == bajos[u]) 
    {
        vi componente;
        while (true) 
        {
            int nodo = pila.top();
            pila.pop();
            enPila[nodo] = false;
            componente.push_back(nodo);
            if (nodo == u) break;
        }
        componentes.push_back(componente);
    }
}

vvi componentesConexos(vvi& grafo) {
    int n = grafo.size();
    vi ids(n, -1), bajos(n,-1);
    vb enPila(n, false);
    stack<int> pila;
    int idActual = 0;
    vvi componentes;

    for (int i = 0; i < n; i++) 
    {
        if (ids[i] == -1) 
        {
            tarjan(i, grafo, ids, bajos, pila, enPila, idActual, componentes);
        }
    }

    return componentes;
}

```