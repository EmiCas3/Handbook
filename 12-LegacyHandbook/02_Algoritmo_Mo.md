# Algoritmo de Mo
El algoritmo de Mo es una técnica de optimización para responder múltiples consultas sobre subarreglos de manera eficiente mediante reordenamiento inteligente. Divide el arreglo en bloques de tamaño √n y ordena las consultas primero por el bloque inicial y luego por el índice final, permitiendo que el puntero se mueva de forma incremental.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int block_size;

// Estructura de datos que almacena los valores y permite realizar las operaciones
struct DataStructure {
    vector<int> data;

    void add(int idx) {
        // TODO: Implementar la lógica para agregar un valor en el índice idx
    }

    void remove(int idx) {
        // TODO: Implementar la lógica para eliminar un valor en el índice idx
    }

    int get_answer() {
        // TODO: Implementar la lógica para calcular la respuesta actual de la estructura de datos
        return 0; // Cambiar 0 por el valor correcto
    }
};

vector<int> mo_s_algorithm(vector<Query> queries) {
    vector<int> answers(queries.size());
    sort(queries.begin(), queries.end());

    DataStructure ds; 

    int cur_l = 0;
    int cur_r = -1;

    for (Query q : queries) {
        while (cur_l > q.l) {
            cur_l--;
            ds.add(cur_l);
        }
        while (cur_r < q.r) {
            cur_r++;
            ds.add(cur_r);
        }
        while (cur_l < q.l) {
            ds.remove(cur_l);
            cur_l++;
        }
        while (cur_r > q.r) {
            ds.remove(cur_r);
            cur_r--;
        }
        answers[q.idx] = ds.get_answer();
    }
    return answers;
}

int main() {
    // Ejemplo de uso del algoritmo de Mo's
    block_size = 3; // Tamaño del bloque, ajusta según tus necesidades

    vector<Query> queries = {
        {0, 4, 0},
        {2, 6, 1},
        {1, 5, 2},
    };

    vector<int> results = mo_s_algorithm(queries);

    for (int answer : results) {
        cout << answer << " ";
    }
    
    return 0;
}
```