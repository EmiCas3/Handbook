## Atajos

###  Macros

Remplaza el texto antes de compilar

```cpp
#define PI 3.1416
#define SQUARE(x) ((x)*(x))
```

### Using

Crea alias de tipos o espacios de nombres para escribir más corto y legible.

```cpp
using ll = long long;
using vi = vector<int>;
using vvi = vector<vi>;
```

### Fast Input Normalizer

Optimiza la velocidad de cin y cout. Evita la sincronización con stdio y acelera la entrada/salida.

```cpp
ios::ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0)
```

### Underscore main

Función donde va la lógica del problema, permite manejar varios casos sin ensuciar main().


```cpp
int _main()
{
    int a,b;
    cin>>a>>b;
    return a+b;
}

void main()
{
    int t;
    cin>>t;
    whike (t--)
        cout<<_main*()<<endl;
    return 0;
}
```

### Libreria

Incluye todas las librerias del Standard Library Template

```cpp
#include <bits/stdc++.h>
```