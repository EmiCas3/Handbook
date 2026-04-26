# Knuth-Morris-Pratt KMP
El algoritmo KMP busca patrones en texto con complejidad $O(n+m)$ mediante un preprocesamiento que evita comparaciones redundantes. Construye un arreglo de prefijos que almacena para cada posición la longitud del mayor prefijo propio que es también sufijo. Durante la búsqueda, cuando ocurre un desajuste, el algoritmo utiliza esta información para desplazar el patrón inteligentemente sin retroceder en el texto, eliminando el comportamiento $O(nm)$ del enfoque ingenuo.


```cpp
vi computeLPSArray(const string& pattern) 
{
    int m = pattern.length();
    vector<int> lps(m, 0);
    int len = 0;

    for (int i = 1; i < m; i++) 
    {
        while (len > 0 && pattern[i] != pattern[len]) len = lps[len - 1];
        if (pattern[i] == pattern[len]) len++;
        lps[i] = len;
    }

    return lps;
}

vi KMPSearch(const string& text, const string& pattern) {
    vi indices, lps = computeLPSArray(pattern);
    int n = text.length(), m = pattern.length(), i = 0, j = 0;

    while (i < n) 
    {
        if (pattern[j] == text[i]) i++, j++;
        if (j == m) indices.push_back(i - j), j = lps[j - 1];
        else if (i < n && pattern[j] != text[i]) j = j ? lps[j - 1] : i++;
    }

    return indices;
}
```
