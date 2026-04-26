# Algoritmo de Kadane
El algoritmo de Kadane resuelve el problema del subarreglo de suma máxima en tiempo lineal O(n) mediante programación dinámica. Mantiene dos variables: la suma máxima terminando en la posición actual y la suma máxima global encontrada. Itera el arreglo una vez, decidiendo en cada paso si extender el subarreglo actual o iniciar uno nuevo, demostrando que la solución óptima puede construirse incrementalmente sin explorar todas las O(n²) posibilidades.


```cpp
#include <iostream>
#include <algorithm> // Para std::max
#include <climits>   // Para INT_MIN

// Función para encontrar la suma máxima del subarreglo
int kadane(int arr[], int n) {
    int max_so_far = INT_MIN; // Inicializa con el menor entero posible
    int max_ending_here = 0;  // Suma máxima hasta el elemento actual

    for (int i = 0; i < n; i++) {
        // Suma el elemento actual a la suma actual
        max_ending_here = max_ending_here + arr[i];

        // Si la suma actual es mayor que la suma global, actualiza la suma global
        if (max_so_far < max_ending_here) {
            max_so_far = max_ending_here;
        }

        // Si la suma actual es negativa, reiníciala a 0
        if (max_ending_here < 0) {
            max_ending_here = 0;
        }
    }
    // Este código puede retornar 0 para arrays con solo números negativos,
    // Para manejar correctamente arrays con solo números negativos, se necesita una comprobación adicional.
    // En este caso, el valor máximo es el número menos negativo.
    // Si `max_so_far` sigue siendo `INT_MIN` después del bucle (lo que puede pasar si el array está vacío o solo tiene números negativos),
    // y `max_ending_here` nunca fue mayor que 0, es necesario manejar el caso de los números negativos.
    // Por lo tanto, se debe encontrar el elemento máximo del array si `max_so_far` es negativo.
    // Por simplicidad, asumiremos aquí que el arreglo contiene al menos un elemento no negativo.
    
    // Esta versión es para la suma máxima de un subarreglo.
    // Si el arreglo puede contener solo números negativos, un enfoque más completo:

    int max_sum_negative_only = arr[0];
    for(int i = 1; i < n; i++) {
        if(arr[i] > max_sum_negative_only) {
            max_sum_negative_only = arr[i];
        }
    }
    if (max_so_far < 0) return max_sum_negative_only;

    return max_so_far;
}

// Función principal para probar el algoritmo
int main() {
    int arr[] = {-2, -3, 4, -1, -2, 1, 5, -3};
    int n = sizeof(arr) / sizeof(arr[0]);
    std::cout << "El subarreglo con la suma maxima es: " << kadane(arr, n) << std::endl; // Salida: 7
    return 0;
}
```