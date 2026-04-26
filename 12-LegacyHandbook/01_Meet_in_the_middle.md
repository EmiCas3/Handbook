# Meet in the Middle
El algoritmo "Meet in the Middle" es una técnica de optimización que reduce la complejidad computacional de problemas de búsqueda exhaustiva mediante la partición del espacio de soluciones en dos mitades independientes. Su fundamento radica en el principio divide y vencerás: en lugar de explorar todas las $2^n$ combinaciones posibles en un problema, se divide el conjunto de n elementos en dos subconjuntos de tamaño n/2, generando todas las configuraciones posibles para cada mitad ($2^(n/2)$ cada una), almacenando los resultados de la primera mitad en una estructura de datos eficiente (típicamente una tabla hash o árbol de búsqueda), y luego explorando la segunda mitad buscando complementos que satisfagan las condiciones del problema.

```cpp
// Función que implementa la parte "izquierda" del algoritmo
void generateSubsetsLeft(vector<int>& nums, int index, int sum, map<int, int>& leftSumCounts) {
    if (index == nums.size() / 2) {
        leftSumCounts[sum]++;
        return;
    }

    // Incluir el elemento actual en el subconjunto
    generateSubsetsLeft(nums, index + 1, sum + nums[index], leftSumCounts);

    // No incluir el elemento actual en el subconjunto
    generateSubsetsLeft(nums, index + 1, sum, leftSumCounts);
}

// Función que implementa la parte "derecha" del algoritmo
int countSubsetsRight(vector<int>& nums, int index, int sum, map<int, int>& leftSumCounts) {
    if (index == nums.size()) {
        int complement = -sum; // Calcula el complemento necesario para alcanzar el objetivo
        if (leftSumCounts.find(complement) != leftSumCounts.end()) {
            return leftSumCounts[complement];
        }
        return 0;
    }

    // Incluir el elemento actual en el subconjunto
    int includeCount = countSubsetsRight(nums, index + 1, sum + nums[index], leftSumCounts);

    // No incluir el elemento actual en el subconjunto
    int excludeCount = countSubsetsRight(nums, index + 1, sum, leftSumCounts);

    return includeCount + excludeCount;
}

int main() {
    vector<int> nums = {1, 2, 3, 4, 5};
    int targetSum = 6;

    map<int, int> leftSumCounts;
    generateSubsetsLeft(nums, 0, 0, leftSumCounts);

    int totalSubsets = countSubsetsRight(nums, nums.size() / 2, 0, leftSumCounts);

    cout << "Número de subconjuntos con suma igual a " << targetSum << ": " << totalSubsets << endl;

    return 0;
}
```