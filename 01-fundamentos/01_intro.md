# Introducción a la Programación Competitiva

## Veredictos

\begin{mdtable3}
\rowcolor{headergray}
\textbf{Código} & \textbf{Sinónimo} & \textbf{Posible explicación}\tabularnewline
CE & Compilation Error & Error de sintaxis, faltan librerías o tipos mal definidos.\tabularnewline
RTE & Run Time Error & Acceso a memoria inválida, división entre cero, etc.\tabularnewline
TLE & Time Limit Exceeded & Algoritmo ineficiente o bucle infinito.\tabularnewline
MLE & Memory Limit Exceeded & Uso excesivo de arrays o estructuras grandes.\tabularnewline
WA & Wrong Answer & Lógica incorrecta o caso no cubierto.\tabularnewline
OLE & Output Limit Exceeded & Imprime más líneas de lo esperado.\tabularnewline
PE & Presentation Error & Saltos de línea o espacios extra.\tabularnewline
AC & Accepted & El código fue aceptado.\tabularnewline\end{mdtable3}

## Compilación

\begin{mdtable3}
\rowcolor{headergray}
\textbf{Sistema Operativo} & \textbf{Acción} & \textbf{Comando}\tabularnewline
Linux/Mac OS & Compilar & g++ -o \<problem> \<problem>.cpp\tabularnewline
Windows & Compilar & g++ -o \<problem> \<problem>.cpp\tabularnewline
Linux/Mac OS & Ejecutar & \<problem>\tabularnewline
Windows & Ejecutar & \<problem> .exe\tabularnewline\end{mdtable3}

Para activar todas las advertencias o establecer una versión de C++ agrega los flags:

**-Wall -Wextra -std=c++\<version>**:

```cpp
g++ -Wall -Wextra -std=c++17 -o a problemA.cpp
./a
```

## Lectura

### Strings con espacios

```cpp
string s;
getline(cin, s); 
```

#### Limpiar buffer
Si se alterna con lectura de enteros, en ocasiones se guardara el último salto de línea, por lo que será necesario limpiar el buffer.

```cpp
cin >> edad;
cin.ignore(100, '\n');
getline(cin, nombre);
```

### End of File

Si la cantidad de entrada es desconocida, leer hasta el final del archivo

```cpp
while (cin>>x)
{
    // code
}
```

### Archivos

Redirgir la entrada y salida a archivos

```cpp
freopen("input.in", "r", stdin);
freopen("output.out", "w", stdout);
```