# Estructuras de Datos 

## Arreglos Dinámicos
Un arreglo dinámico es un arreglo cuyo tamaño puede cambiar durante la ejecución del programa.

La biblioteca estándar de C++ (STL) proporciona varias estructuras de arreglos dinámicos, siendo la más útil el vector.

### Vectores
Un vector permite agregar y eliminar elementos eficientemente al final de la estructura.


Inicialización de un vector vacío
```cpp
    vi v;
    v.pb(3); 
    v.pb(2);
    v.pb(5);
```

Inicialización de un vector con lista de elementos
```cpp
    vi a = {2, 4, 2, 5, 1};
```

Inicialización de un vector determinando el tamaño y valores iniciales
```cpp 
    vi a(8); // tamaño 8, valor inicial 0
    vi b(8,2);// tamaño 8, valor inicial 2
```
Los elementos pueden ser accedidos de manera ordinaria
```cpp
    cout << v[0] << "\n"; // 3
    cout << v[1] << "\n"; // 2
    cout << v[2] << "\n"; // 5
```

$\clearpage$

La función `size()` retorna el número de elementos en el vector

```cpp
    forn(i,0,v.size())
        cout << v[i] << " ";
    cout << endl;
```

Manera más corta de iterar a través de un vector 
```cpp
for (auto x : v) {
    cout <<x<< "\n";
}
```

La función `back()` retorna el útlimo elemento de un vector, y la función `pop_back()` elimina el útlimo elemento

```cpp
vi v = {2,4,2,5,1};
cout << v.back() << "\n"; // 1
v.pop_back();
cout << v.back() << "\n"; // 5
```

Los vectores se implementan de manera que las operaciones `push_back()` y `pop_back()` trabajen en O(1) tiempo medio. 

En la práctica, el uso de un vector es casi tan rápido como el uso una arreglo ordinario.


### Iteradores y rangos 
Los iteradores son objetos que permiten recorrer los elementos de una estructura de datos de forma genérica.
Funcionan como punteros que apuntan a elementos dentro de contenedores de la STL, como vector, set o map.

#### Iterador 

Es una variable que apunta a un elemento de una estructura de datos.

- El iterador `begin()` apunta al primer elemento de una estructura de datos.

- El iterador `end()` apunta a la posición después del último elemento

Los iteradores permiten recorrer estructuras sin conocer su implementación interna.

El elemento al que apunta un iterador se puede acceder con la sintaxis *.

```cpp
cout << *v.begin() << "\n"; //primer elemento del vector
```

#### Rango
Es una secuencia de elementos consecutivos en una estructura de datos.  

Los iteradores begin() y end() definen un rango que contiene todos los elementos de una estructura de datos.

El código siguiente ordena primero un vector, luego invierte el orden de sus elementos, y por último, mezcla sus elementos. 

```cpp
sort(v.begin(),v.end());
reverse(v.begin(),v.end());
random_shuffle(v.begin(),v.end());
```

Un ejemplo más útil,`lower_bound` da un iterador al primer elemento en un rango ordenado cuyo valor es al menos x, y `upper_bound` da una
iterador al primer elemento cuyo valor es mayor que x

```cpp
vi v = {2,3,3,5,7,8,8,8};
auto a = lower_bound(v.begin(),v.end(),5);
auto b = upper_bound(v.begin(),v.end(),5);
cout << *a << " " << *b << "\n"; // 5 7
```
El rango dado debe estar ordenado. 

### Deque
Un deque es un arreglo dinámico que puede manipularse eficientemente en ambos extremos.

Los deques deben utilizarse si hay necesidad de manipular ambos extremos del arreglo.

```cpp
deque<int> d;
d.push_back(5); // [5]
d.push_back(2); // [5,2]
d.push_front(3); // [3,5,2]
d.pop_back(); // [3,5]
d.pop_front(); // [5]
```


### Stack 
Una pila tiene las funciones push y pop para insertar y quitar elementos al final de la estructura, y la función top que recupera el último elemento

```cpp
stack<int> s;
s.push(2); // [2]
s.push(5); // [2,5]
cout << s.top() << "\n"; // 5
s.pop(); // [2]
cout << s.top() << "\n"; // 2
```

### Queue
En una cola, los elementos se insertan al final de la estructura y se eliminan desde la parte delantera de la estructura. Ambas funciones front y back permiten acceder al primer y último elemento.

```cpp
queue<int> q;
q.push(2); // [2]
q.push(5); // [2,5]
cout << q.front() << "\n"; // 2
q.pop(); // [5]
cout << q.back() << "\n"; // 5
```

## Estructuras Set

### Sets y multisets 

#### Set 
Se basa en un árbol de búsqueda binario equilibrado y sus operaciones funcionan en $O(log n)$ tiempo.

#### Unordered set 
Se basa en una tabla hash y sus operaciones funcionan, por término medio, en $O(1)$.

Puesto que son utilizados de la misma manera, nos centramos en la estructura del set en los siguientes ejemplos.


La función *insert* añade un elemento al set, la función *count* devuelve el número de ocurrencias de un elemento en el set, y la función *erase* elimina un elemento del set.

```cpp
set<int> s;
s.insert(3);
s.insert(2);
s.insert(5);
cout << s.count(3) << "\n"; // 1
cout << s.count(4) << "\n"; // 0
s.erase(3);
s.insert(4);
cout << s.count(3) << "\n"; // 0
cout << s.count(4) << "\n"; // 1
```

Una propiedad importante de los sets es que todos sus elementos son distintos, por lo que la función `ìnsert` nunca agregará un elemento si ya se encuentra dentro del set.

La función `count` siempre devuelve 0 (si el elemento no está en el conjunto) o 1 (si está presente)

```cpp
set<int> s;
s.insert(3);
s.insert(3);
s.insert(3);
cout << s.count(3) << "\n"; // 1
```

```cpp
cout << s.size() << "\n"; // imprimir número de elementos
for (auto x : s) { // recorrer elementos del set
    cout << x << "\n";
}
```

La función find(x) devuelve un iterador que apunta al elemento cuyo valor es x. Si el conjunto no contiene x, el iterador devuelto será end()
```cpp
auto it = s.find(x);
if (it == s.end()) {
    // x no se encuentra
}
```

$\clearpage$
#### Sets ordenados 
La principal diferencia entre las dos estructuras es que set es ordenado, mientras que unordered_set no lo es.

```cpp
auto first = s.begin();
auto last = s.end(); last--;
cout << *first << " " << *last << "\n";
```

```cpp
cout << *s.lower_bound(x) << "\n";
cout << *s.upper_bound(x) << "\n";
```

#### Multisets
Un multiset es un conjunto que puede tener varias copias del mismo valor.
C++ incluye las estructuras multiset y unordered_multiset, que son análogas a set y unordered_set.

El siguiente código agrega tres copias del valor 5 a un multiset
```cpp
multiset<int> s;
s.insert(5);
s.insert(5);
s.insert(5);
cout << s.count(5) << "\n"; // 3
```
La función erase elimina todas las copias de un valor en un multiset
```cpp
s.erase(5);
cout << s.count(5) << "\n"; // 0
```
Para eliminar una sola copia de un valor, se puede hacer de la siguiente manera
```cppp
s.erase(s.find(5));
cout << s.count(5) << "\n"; // 2
```


### Maps
Un map es un conjunto que consiste en pares clave–valor (key–value pairs). Las claves pueden ser de cualquier tipo de dato y no tienen que ser consecutivas.

La biblioteca estándar de C++ contiene dos estructuras de map:

- `map` se basa en un árbol binario de búsqueda balanceado, y el acceso a los elementos toma tiempo O(log n).
- `unordered_map` utiliza hashing, y el acceso a los elementos toma tiempo O(1) en promedio

```cpp
map<string, int> m;
m["monkey"] = 4;
m["banana"] = 3;
m["harpsichord"] = 9;
cout << m["banana"] << "\n"; // 3
```

El siguiente código recorre e imprime todos los pares clave–valor almacenados:
```cpp
for (auto x : m) {
    cout << x.first << " " << x.second << "\n";
}
```
Los elementos de un map están ordenados por sus claves, mientras que los de un unordered_map no lo están.

Eliminar una clave de un mapa
```cpp
m.erase("banana");
```

Comprobar si una clave existe utilizando la función `count`, que devuelve 1 si la clave está presente, o 0 en caso contrario.
```cpp
if (m.count("banana")) {
    cout << "banana existe\n";
}
```

### Priority Queues (Colas de Prioridad)

Una cola de prioridad es una estructura similar a un multiset, que permite insertar elementos y obtener/eliminar rápidamente el mínimo o máximo elemento, dependiendo del tipo de cola.

Por defecto, está implementada como un heap binario máximo, lo que permite obtener y eliminar el mayor elemento en la estructura.
```cpp
priority_queue<int> q;
q.push(3);
q.push(5);
q.push(7);
q.push(2);

cout << q.top() << "\n"; // 7
q.pop();
cout << q.top() << "\n"; // 5
q.pop();

q.push(6);
cout << q.top() << "\n"; // 6
q.pop();
```

Si se desea que la cola devuelva el menor elemento (un min-heap), se puede usar un comparador:
```cpp
priority_queue<int, vector<int>, greater<int>> q;
```

$\clearpage$
### Policy-Based Sets (Conjuntos Basados en Políticas)
El compilador g++ ofrece estructuras adicionales que no forman parte de la biblioteca estándar de C++, conocidas como policy-based data structures.
Para utilizarlas se deben incluir las siguientes líneas:
```cpp
#include <ext/pb_ds/assoc_container.hpp>
using namespace __gnu_pbds;
```
Definición para valores int:
```cpp
typedef tree<int, null_type, less<int>, rb_tree_tag,
tree_order_statistics_node_update> indexed_set;
```

Ejemplo de uso
```cpp
indexed_set s;
s.insert(2);
s.insert(3);
s.insert(7);
s.insert(9);
```

Su ventaja es que permite acceder a los elementos por su posición ordenada.
- `find_by_order(k)` devuelve un iterador al elemento en la posición k (0-indexado).
- `order_of_key(x)` devuelve cuántos elementos son menores que x.
```cpp
auto x = s.find_by_order(2);
cout << *x << "\n"; // 7
cout << s.order_of_key(7) << "\n"; // 2
```





