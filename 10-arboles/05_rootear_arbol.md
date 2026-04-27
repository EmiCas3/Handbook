
$\clearpage$

# Rootaear un arbol desde el centro

```cpp
vi treeCenters(vvi& g) 
{
    int n = g.size();
    vi degree(n, 0), leaves;

    forn(i, 0, n)
    {
        degree[i] = g[i].size();
        if (degree[i] == 0 || degree[i] == 1) 
        {
            leaves.push_back(i);
            degree[i] = 0;
        }
    }

    int count = leaves.size();

    while (count < n) {
        vector<int> new_leaves;
        for (int node : leaves) 
        {
            for (int neighbor : g[node]) 
            {
                degree[neighbor] = degree[neighbor] - 1;
                if (degree[neighbor] == 1) 
                    new_leaves.push_back(neighbor);
                degree[node] = 0;
            }
        }
        count += new_leaves.size();
        leaves = new_leaves;
    }

    return leaves; // Centros (center) del árbol
}

void dfs(vvi &g, vb& visited, vvi& rootedTree, int node)
{
    if (!visited[node]) 
    {
        visited[node] = true;
        for (int neighbor : g[node])
         {
            if (!visited[neighbor]) 
            {
                rootedTree[node].push_back(neighbor);
                dfs(g, visited, rootedTree, neighbor);
            }
        }
    }
}

int main()
{
    int n = 6;
    vvi graph(n);
    // Agregar las conexiones del grafo
    vi centers = treeCenters(graph);
    cout << "Centro(s) del árbol: ";
    for (int center : centers) {
        cout << center << " ";
    }
    cout << endl;

    // Elegir el primer centro como raíz
    int root = centers[0];

    vvi rootedTree(n);
    vb visited(n, false);
    
    dfs(graph, visited, rootedTree, root);

    cout << "Grafo enraizado desde el centro:" << endl;
    forn(i, 0, n)
    {
        cout << i << ": ";
        for (int neighbor : rootedTree[i]) 
        {
            cout << neighbor << " ";
        }
        cout << endl;
    }

    return 0;
}
```