
## Manipulación de Bits

### Operadores AND, OR y XOR

\begin{mdtable2}
\rowcolor{headergray}
\textbf{Operación} & \textbf{Resultado}\tabularnewline
AND & Devuelve 1 solo si ambos bits son 1, 0 en otro caso\tabularnewline
OR  & Devuelve 1 si al menos un bit es 1, 0 si ambos son 0\tabularnewline
XOR & Devuelve 1 si los bits son diferentes, 0 si son iguales\tabularnewline
NOT & Invierte los bits: 1 → 0, 0 → 1\tabularnewline
Desplazamiento izquierda & Mueve los bits a la izquierda, agregando ceros a la derecha\tabularnewline
Desplazamiento derecha & Mueve los bits a la derecha, agregando ceros o unos según el tipo de dato\tabularnewline\end{mdtable2}

```cpp
#include <iostream>
using namespace std;

int main() {
    unsigned int a = 0b1100; // 12
    unsigned int b;

    // Operaciones bit a bit
    b = a & 0b1010; // 0b1100 & 0b1010 = 0b1000 (8)
    cout << "AND: " << b << endl;

    b = a | 0b1010; // 0b1100 | 0b1010 = 0b1110 (14)
    cout << "OR: " << b << endl;

    b = a ^ 0b1010; // 0b1100 ^ 0b1010 = 0b0110 (6)
    cout << "XOR: " << b << endl;

    b = ~a & 0b1111; // complemento limitado a 4 bits: ~0b1100 = 0b0011 (3)
    cout << "NOT: " << b << endl;

    // Desplazamientos
    b = a << 2; // 0b1100 << 2 = 0b110000 (48)
    cout << "Shift left: " << b << endl;

    b = a >> 2; // 0b1100 >> 2 = 0b0011 (3)
    cout << "Shift right: " << b << endl;

    return 0;
}
```

$\clearpage$

## Bitset

Bitset es una estructura que permite una manipulación de bits más sencilla en cuestion de código y permite trabajar con cadenas de bits mayores a un long long int (64).

```cpp
bitset<8> a;
bitset<5> b = 8;
// Establecer bits en posiciones específicas en 'a'
a[0] = 1;
a[2] = 1; 
a[5] = 1;
// Contar los bits encendido en 'a'
int count = a.count();
// Comprobar si el bit en la posición '3' esta encendido
bool isSet = a.test(3);
// Establecer el bit en la posición '4' en '1'
a.set(4, true);
// Resetear el bit en la posición 2 a '0'
a.reset(2);
// Invertir el valor del bit en la posición '1'
a.flip(1);
string bitsetString = a.to_string();
bitset<8> anotherBitset("10101010");
bitset<8> c_and = a & b;
bitset<8> c_or = a | b;
bitset<8> c_xor = a ^ b;
bitset<8> c_not = ~a;
```

### Entero a binario
```cpp
string to_binary(int n) {
    bitset<8>x(n);
    return x.to_string();
}
```

### Binario a entero

```cpp
int binary_to_int(string s) {
    return stoi(s, nullptr, 2);
}
```

### Mascara de bits

Una máscara de bits de la forma 1 << k tiene un bit en 1 en la posición k y todos los demás bits en 0, por lo que podemos usar estas máscaras para acceder a bits individuales de los números. En particular, el k-ésimo bit de un número es 1 exactamente cuando ```x & (1 << k)``` no es cero.

```cpp
for (int k = 8; k >= 0; k--) {
    if (x & (1 << k)) cout << "1";
    else cout << "0";
}
```

#### Iterar sobre todas las mascasras de tamaño N

```cpp
int mask = 0b1011;
for (int sub = mask; sub; sub = (sub - 1) & mask) {
    cout << bitset<4>(sub) << endl; // imprime la submáscara en binario
}
// opcional: incluir la máscara cero como submáscara
cout << bitset<4>(0) << endl;
```


### Propiedades


- Comprobar si un número es par: ```x & 1```

- Encender el $k$-ésimo bit: ```x | (1 << k)```

- Apagar el $k$-ésimo bit: ```x & ~(1 << k)```

- Invertir el $k$-ésimo bit: ```x ^ (1 << k)```

- Poner a 0 el último bit en 1: ```x & (x - 1)```

- Poner a 0 todos los bits en 1, excepto el último: ```x & -x```

- Invertir todos los bits después del último bit en 1: ```x | (x - 1)```

- Multiplicar por $2^n$:```x << n```

- Dividir por $2^n$:```x >> n```

- Comprobar si un número positivo es potencia de dos: ```x & (x - 1) == 0```

#### Codigo de Gray

El código Gray es un sistema numérico en el que los números consecutivos difieren en un solo bit.Cada
número en el código Gray se representa en binario, donde un bit cambia su estado entre números
consecutivos, lo que facilita la detección y corrección de errores.


Para convertir un número binario a código Gray, si definimos $X_2$ de $N$ bits como $B_{N-1}$, $B_{N-2}$,
$B_{N-3}$, ..., $B_0$ y su código de Gray como $G_{N-1}$, $G_{N-2}$, $G_{N-3}$, ..., $G_0$, entonces:

$G_n = B_n \text{ para } n = N-1 $ $G_i = G_{i+1} \oplus B_i \text{para } i = N-2, N-3, \ldots, 0$

Por ejemplo, si $10_2 = 1010$, donde $B_3 = 1$, $B_2 = 0$, $B_1 = 1$ y $B_0 = 0$, entonces:
$G_3 = B_3 = 1$ $G_2 = G_3 \oplus B_2 = 1 \oplus 0 = 1$ $G_1 = G_2 \oplus B_1 = 0 \oplus 1 = 1$ $G_0 =
G_1 \oplus B_0 = 1 \oplus 0 = 1$
Es decir, convertir el número binario $1010$ a código de Gray daría como resultado $1111$, y $Gray(10) =
15$.

$Gray(n) = n \oplus (n \gg 1)$

```cpp
int gray(int n) {
    return n ^ (n >> 1);
}
```