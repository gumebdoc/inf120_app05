# Aplicación U5: Arreglo de dos dimensiones (Matrices)
**Clase `Matriz` con Interfaz Gráfica (GUI) en Lazarus / Free Pascal**

* **Universidad:** Universidad Autónoma Gabriel René Moreno (UAGRM)
* **Facultad:** Facultad de Ingeniería en Ciencias de la Computación y Telecomunicaciones (FICCT)
* **Materia:** Programación I (INF120) - Grupo SC
* **Docente:** Lic. Evans Balcázar Veizaga
* **Estudiante:** Gustavo Melgar Baldivieso
* **Registro:** 213195623
* **Repositorio GitHub:** [https://github.com/gumebdoc/inf120_app05](https://github.com/gumebdoc/inf120_app05)
* **Fecha:** Noviembre 2026 - Santa Cruz de la Sierra, Bolivia

---

## 📌 1. Descripción del Proyecto

Este proyecto implementa la **Aplicación U5 (Arreglo de dos dimensiones - Matrices)** de la materia Programación I (INF120). Siguiendo rigurosamente las instrucciones del práctico y la guía docente proporcionada en *Implementación 5*, se construyó la clase **`Matriz`** en la unidad `umatriz.pas` en **Object Pascal**, acompañada de una completa y moderna **Aplicación con Interfaz Gráfica de Usuario (GUI)** en **Lazarus IDE**.

El proyecto se diseñó estrictamente bajo el avance conceptual de la materia:
* Programación Orientada a Objetos estándar (clase `Matriz`, encapsulamiento, atributos privados, métodos públicos).
* Arreglos estáticos bidimensionales continuos (`elem: array[1..MAX_F, 1..MAX_C] of real`) con indexación base 1 estándar de la materia.
* Estructuras de control algorítmicas canónicas (`for`, `while`, `if`).
* **Implementación con procedimientos (`procedure`) y parámetros por referencia (`var`), sin funciones ni estructuras complejas ajenas al avance curricular.**

---

## 🚀 2. Operaciones Implementadas

### A) Matriz General
1. **Cargar:** Dimensionamiento interactivo y carga por celdas en el `TStringGrid`, carga de ceros y carga con valores aleatorios.
2. **Mostrar:** Visualización dinámica y formateada en la grilla y en el registro de texto estructurado.
3. **Búsqueda:** Búsqueda secuencial exhaustiva celda por celda de un elemento `x`, devolviendo su posición `(fila, columna)` y marcando su ubicación.
4. **Ordenamiento:** Ordenamiento ascendente de todos los elementos de la matriz bidimensional mediante intercambio directo (burbuja/selección 2D).

### B) Matriz Cuadrada
1. **Triangulares:** 
   - Verificación de Matriz Triangular Superior (ceros debajo de la diagonal principal).
   - Verificación de Matriz Triangular Inferior (ceros encima de la diagonal principal).
   - Generación de Matriz Triangular Superior e Inferior en la matriz resultado.
2. **Diagonal Principal:** Recorrido, extracción de elementos y cálculo de la suma (traza de la matriz).
3. **Diagonal Secundaria:** Recorrido, extracción de elementos y cálculo de la suma de la diagonal secundaria ($i + j = n + 1$).
4. **Sumar:** Suma matricial directa $C = A + B$ validando dimensiones equivalentes.
5. **Restar:** Resta matricial directa $C = A - B$ celda por celda.
6. **Multiplicar:** Multiplicación matricial clásica $C = A \times B$ mediante producto punto de filas por columnas.
7. **Invertir:** Inversión del orden secuencial de todos los elementos de la matriz (intercambio simétrico del primer elemento con el último, etc.).
8. **Determinante:** Cálculo exacto del determinante $\det(A)$ mediante triangulación gaussiana elemental con pivoteo parcial.
9. **Transpuesta:** Matriz transpuesta $A^T$ donde las filas pasan a ser columnas ($C[j, i] = A[i, j]$).
10. **Inversa:** Cálculo de la matriz inversa matemática $A^{-1}$ mediante el método algebraico canónico de Gauss-Jordan sobre la matriz aumentada $[A \mid I]$.

---

## 📁 3. Estructura del Repositorio

```text
├── umatriz.pas                     # Unidad con la implementación de la clase Matriz
├── main.pas                        # Controlador de eventos de la Interfaz Gráfica (GUI)
├── main.lfm                        # Formulario visual con TStringGrids y paneles de control
├── MatrizApp.lpr                   # Programa principal de la aplicación GUI Lazarus
├── MatrizApp.lpi                   # Archivo de configuración del proyecto Lazarus
├── MatrizApp.res                   # Recurso de iconos y manifiesto de Windows
├── test_matriz.pas                 # Suite de pruebas unitarias y verificación de resultados
├── Aplicación U5 - Informe.docx    # INFORME ACADÉMICO COMPLETO EN WORD (Carátula, marco teórico, pseudocódigos, pruebas)
├── Aplicación U5 - Informe.pdf     # Versión PDF del informe académico
├── enlace_github.txt               # Archivo de texto con el enlace directo al repositorio
├── ficct_logo.png                  # Logotipo oficial de la Facultad (FICCT - UAGRM)
└── README.md                       # Documentación técnica del proyecto
```

---

## 🛠️ 4. Instrucciones de Compilación y Ejecución

### Opción 1: Desde Lazarus IDE
1. Abrir **Lazarus IDE**.
2. Ir al menú **Proyecto -> Abrir proyecto...** y seleccionar el archivo `MatrizApp.lpi`.
3. Presionar la tecla **F9** (o presionar el botón verde de reproducir) para compilar y ejecutar la aplicación.

### Opción 2: Desde la línea de comandos con Lazbuild
```bash
lazbuild --build-all MatrizApp.lpi
./MatrizApp.exe
```

### Opción 3: Ejecución de las Pruebas Unitarias en Consola
```bash
fpc -Mobjfpc -Sh test_matriz.pas
./test_matriz.exe
```

---

## 👨‍💻 Autor

* **Estudiante:** Gustavo Melgar Baldivieso
* **Registro:** 213195623
* **Carrera:** Ingeniería de Sistemas / Informática
* **Universidad:** Universidad Autónoma Gabriel René Moreno (UAGRM)
* **Docente:** Lic. Evans Balcázar Veizaga
