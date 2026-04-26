# Exponenciación Binaria

La operación $a^b$ en la gran mayoría de librerías se implementa en $O(b)$.  
Sin embargo, si representamos $b$ en base 2 (binario), se puede realizar en $O(log b)$:

```cpp
int binpow(int a, int b) {
    int r = 1;
    while (b > 0) {
        if (b & 1) r *= a;
        a *= a;
        b >>= 1;
    }
    return r;
}
```

# Aritmética Modular

Cuando los números de entrada son muy grandes, los problemas suelen requerir que apliquemos aritmética modular con un número p, típicamente $10^9$ + 7 (1000000007).  

Por ejemplo, supongamos que queremos calcular: $r = (a * b * c) % 1000000007;$


Si realizamos la multiplicación directamente, los números intermedios pueden exceder la capacidad de almacenamiento, aunque matemáticamente sea correcto. Por eso usamos operaciones modulares paso a paso.

### Operaciones mediante aritmética modular


```cpp
using u64 = uint64_t;
const u64 MOD = 1e9 + 7;

#define ADD(a, b) (((a \% MOD) + (b \% MOD)) \% MOD)
#define SUBTRACT(a, b) (((a) - (b) + MOD)\% MOD)
#define MULTIPLY(a, b) (((a) \% MOD) * ((b) \% MOD)) \% MOD
#define DIVIDE(a, b) (MULTIPLY(a,binpow(b,MOD-2)))


u64 binpow(u64 a, u64 b) {
    u64 r = 1;
    a %= MOD;
    while (b > 0) {
        if (b & 1) r = MULTIPLY(r, a);
        a = MULTIPLY(a, a);
        b >>= 1;
    }
    return r;
}
u64 modInverse(u64 a) {return binpow(a, MOD - 2);}
```

