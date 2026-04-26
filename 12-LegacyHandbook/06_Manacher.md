# Algoritmo de Manacher
El algoritmo de Manacher encuentra todos los palíndromos en una cadena en tiempo lineal $O(n)$. Utiliza simetría para evitar recalcular información ya conocida, manteniendo el centro y radio del palíndromo más a la derecha encontrado. Transforma la cadena insertando caracteres especiales para manejar uniformemente palíndromos de longitud par e impar, siendo significativamente más eficiente que el enfoque $O(n²)$ de expansión desde el centro.

```cpp
string manacher(const string& s) {
    string T = "^#";
    for (char c : s) {
        T += c;
        T += '#';
    }
    T += '$';

    int n = T.size();
    vector<int> P(n, 0);
    int C = 0, R = 0;

    for (int i = 1; i < n - 1; i++) {
        int i_mirror = 2 * C - i;
        if (R > i) {
            P[i] = min(R - i, P[i_mirror]);
        }

        while (T[i + 1 + P[i]] == T[i - 1 - P[i]]) {
            P[i]++;
        }

        if (i + P[i] > R) {
            C = i;
            R = i + P[i];
        }
    }

    int maxLen = 0;
    int centerIndex = 0;
    for (int i = 1; i < n - 1; i++) {
        if (P[i] > maxLen) {
            maxLen = P[i];
            centerIndex = i;
        }
    }

    int start = (centerIndex - maxLen) / 2;
    return s.substr(start, maxLen);
}
```




