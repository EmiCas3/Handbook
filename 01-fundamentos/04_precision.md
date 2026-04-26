## Precision

### Enteros

\begin{mdtable4}
\rowcolor{headergray}
\textbf{Tipo} & \textbf{Base 2} & \textbf{Base 10} & \textbf{Base 10}\tabularnewline
bool & 0 a 1 & 0 a 1 & 1 * 10^0\tabularnewline
char & -128 a 127 & -128 a 127 & 2 * 10^2\tabularnewline
unsigned char & 0 a 255 & 0 a 255 & 2.55 * 10^2\tabularnewline
short & -32,768 a 32,767 & -32,768 a 32,767 & 3.28 * 10^4\tabularnewline
int & -2^{31} a (2^{31} - 1) & -2,147,483,648 a 2,147,483,647 & 2.15 * 10^9\tabularnewline
long long & -2^{63} a (2^{63} - 1) & -9,223,372,036,854,775,808 a 9,223,372,036,854,775,807 & 9.22 * 10^{18}\tabularnewline
unsigned long long & 0 a (2^{64} - 1) & 0 a 18,446,744,073,709,551,615 & 1.84 * 10^{19}\tabularnewline\end{mdtable4}


### Decimales
\begin{mdtable2}
\rowcolor{headergray}
\textbf{Tipo} & \textbf{Dígitos de precisión}\tabularnewline
float & 7\tabularnewline
double & 15\tabularnewline
long double & 19\tabularnewline\end{mdtable2}

#### Establecer precision

```cpp
double pi = 3.14159265358979323846;
cout << fixed << setprecision(5) << pi << endl;
```

#### Compracion de decimales

```cpp
if (abs(a-b) < 1e-9) // a == b 
```

## Tiempo de Complejidad

\begin{mdtable2}
\rowcolor{headergray}
\textbf{n} & \textbf{Posibles complejidades}\tabularnewline
n \leq 10 & O(n!), O(n^7), O(n^6)\tabularnewline
n \leq 20 & O(2^n * n), O(n^5)\tabularnewline
n \leq 80 & O(n^4)\tabularnewline
n \leq 400 & O(n^3)\tabularnewline
n \leq 7500 & O(n^2)\tabularnewline
n \leq 7 * 10^4 & O(n√n)\tabularnewline
n \leq 5 * 10^5 & O(n log n)\tabularnewline
n \leq 5 * 10^6 & O(n)\tabularnewline
n \leq 10^{18} & O(log^2 n), O(log n), O(1)\tabularnewline\end{mdtable2}