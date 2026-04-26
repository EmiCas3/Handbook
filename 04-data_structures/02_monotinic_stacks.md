# Monotonic Stack
Es una pila pila que mantiene sus elementos en un orden creciente o decreciente de forma continua. Al insertar un nuevo elemento, se eliminan los elementos que violan el orden monótono para mantener la consistencia.

Se recorre el arreglo de izquierda a derecha manteniendo una pila de elementos.
En cada paso:
	1.	Mientras el elemento del tope de la pila sea mayor o igual que el actual, se elimina.
	2.	Si la pila no está vacía, el elemento del tope es el más cercano menor.
	3.	Luego se agrega el elemento actual a la pila.

Ejemplo de implementación
```cpp
vi a = {1, 3, 4, 2, 5, 3, 4, 2};
stack<int> s;

forn(i, 0, sz(a)) 
{
    while (!s.empty() && s.top() >= a[i])
        s.pop();

    if (s.empty()) cout << "_ ";
    else cout << s.top() << " ";

    s.push(a[i]);
}
cout << endl;
```
Este patrón puede modificarse para hallar:
- El siguiente mayor: pila monótona decreciente
- El siguiente menor: pila monótona creciente