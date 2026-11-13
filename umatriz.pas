unit umatriz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  MAX_F = 100;
  MAX_C = 100;

type

  { Matriz }

  Matriz = class
  private
    elem: array[1..MAX_F, 1..MAX_C] of real;
    fils: integer;
    cols: integer;
  public
    // Constructor
    constructor crear();

    // Propiedades y accesores basicos (estilo Evans Balcazar)
    procedure setFils(filas: integer);
    function  getFils(): integer;
    procedure setCols(columnas: integer);
    function  getCols(): integer;
    procedure dimensionar(f, c: integer);
    procedure setElem(f, c: integer; ele: real);
    function  getElem(f, c: integer): real;
    procedure setElemInt(f, c: integer; ele: integer);
    function  getElemInt(f, c: integer): integer;
    procedure copiar(var Dest: Matriz);
    procedure limpiar();

    // =========================================================================
    // A) MATRIZ GENERAL
    // =========================================================================
    // 1. Cargar
    procedure cargarCeros();
    procedure cargarAleatorio(minVal, maxVal: integer);

    // 2. Mostrar
    procedure obtenerTextoMatriz(var txt: string);

    // 3. Busqueda
    procedure busqueda(ele: real; var fEnc, cEnc: integer; var existe: boolean);

    // 4. Ordenamiento
    procedure ordenamiento();

    // =========================================================================
    // B) MATRIZ CUADRADA
    // =========================================================================
    // Verificacion de matriz cuadrada
    procedure esCuadrada(var resp: boolean);

    // 1. Triangulares
    procedure esTriangularSuperior(var resp: boolean);
    procedure esTriangularInferior(var resp: boolean);
    procedure convertirATriangularSuperior(var MRes: Matriz; var ok: boolean);
    procedure convertirATriangularInferior(var MRes: Matriz; var ok: boolean);

    // 2. Diagonal principal
    procedure sumaDiagonalPrincipal(var suma: real; var ok: boolean);
    procedure obtenerDiagonalPrincipal(var texto: string; var ok: boolean);

    // 3. Diagonal secundaria
    procedure sumaDiagonalSecundaria(var suma: real; var ok: boolean);
    procedure obtenerDiagonalSecundaria(var texto: string; var ok: boolean);

    // 4. Sumar
    procedure sumar(B: Matriz; var MRes: Matriz; var ok: boolean);

    // 5. Restar
    procedure restar(B: Matriz; var MRes: Matriz; var ok: boolean);

    // 6. Multiplicar
    procedure multiplicar(B: Matriz; var MRes: Matriz; var ok: boolean);

    // 7. Invertir (invertir el orden de todos los elementos)
    procedure invertir();

    // 8. Determinante
    procedure determinante(var det: real; var ok: boolean);

    // 9. Transpuesta
    procedure transpuesta(var MRes: Matriz);

    // 10. Inversa
    procedure inversa(var MRes: Matriz; var tieneInversa: boolean);
  end;

implementation

{ Matriz }

constructor Matriz.crear();
var
  f, c: integer;
begin
  fils := 0;
  cols := 0;
  for f := 1 to MAX_F do
    for c := 1 to MAX_C do
      elem[f, c] := 0.0;
end;

procedure Matriz.setFils(filas: integer);
begin
  if (filas >= 0) and (filas <= MAX_F) then
    fils := filas;
end;

function Matriz.getFils(): integer;
begin
  getFils := fils;
end;

procedure Matriz.setCols(columnas: integer);
begin
  if (columnas >= 0) and (columnas <= MAX_C) then
    cols := columnas;
end;

function Matriz.getCols(): integer;
begin
  getCols := cols;
end;

procedure Matriz.dimensionar(f, c: integer);
begin
  setFils(f);
  setCols(c);
end;

procedure Matriz.setElem(f, c: integer; ele: real);
begin
  if (f >= 1) and (f <= MAX_F) and (c >= 1) and (c <= MAX_C) then
  begin
    elem[f, c] := ele;
    if f > fils then fils := f;
    if c > cols then cols := c;
  end;
end;

function Matriz.getElem(f, c: integer): real;
begin
  if (f >= 1) and (f <= MAX_F) and (c >= 1) and (c <= MAX_C) then
    getElem := elem[f, c]
  else
    getElem := 0.0;
end;

procedure Matriz.setElemInt(f, c: integer; ele: integer);
begin
  setElem(f, c, ele);
end;

function Matriz.getElemInt(f, c: integer): integer;
begin
  getElemInt := Round(getElem(f, c));
end;

procedure Matriz.copiar(var Dest: Matriz);
var
  f, c: integer;
begin
  Dest.dimensionar(fils, cols);
  for f := 1 to fils do
    for c := 1 to cols do
      Dest.setElem(f, c, elem[f, c]);
end;

procedure Matriz.limpiar();
var
  f, c: integer;
begin
  for f := 1 to MAX_F do
    for c := 1 to MAX_C do
      elem[f, c] := 0.0;
  fils := 0;
  cols := 0;
end;

// =============================================================================
// A) MATRIZ GENERAL
// =============================================================================

// 1. Cargar con ceros
procedure Matriz.cargarCeros();
var
  f, c: integer;
begin
  for f := 1 to fils do
    for c := 1 to cols do
      elem[f, c] := 0.0;
end;

// 1. Cargar con valores enteros aleatorios en el rango [minVal, maxVal]
procedure Matriz.cargarAleatorio(minVal, maxVal: integer);
var
  f, c, rango, menor: integer;
begin
  if minVal > maxVal then
  begin
    menor := maxVal;
    maxVal := minVal;
    minVal := menor;
  end;
  rango := (maxVal - minVal) + 1;
  for f := 1 to fils do
    for c := 1 to cols do
      elem[f, c] := minVal + Random(rango);
end;

// 2. Mostrar: Retorna una representacion textual fila por fila
procedure Matriz.obtenerTextoMatriz(var txt: string);
var
  f, c: integer;
  val: real;
  sVal: string;
begin
  txt := '';
  for f := 1 to fils do
  begin
    txt := txt + '| ';
    for c := 1 to cols do
    begin
      val := elem[f, c];
      if Frac(val) = 0.0 then
        sVal := IntToStr(Round(val))
      else
        sVal := FloatToStrF(val, ffFixed, 6, 2);
      txt := txt + sVal;
      if c < cols then
        txt := txt + #9;
    end;
    txt := txt + ' |' + sLineBreak;
  end;
end;

// 3. Busqueda secuencial en la matriz
procedure Matriz.busqueda(ele: real; var fEnc, cEnc: integer; var existe: boolean);
var
  f, c: integer;
begin
  existe := false;
  fEnc := 0;
  cEnc := 0;
  f := 1;
  while (f <= fils) and not existe do
  begin
    c := 1;
    while (c <= cols) and not existe do
    begin
      if Abs(elem[f, c] - ele) < 0.000001 then
      begin
        existe := true;
        fEnc := f;
        cEnc := c;
      end;
      c := c + 1;
    end;
    f := f + 1;
  end;
end;

// 4. Ordenamiento de todos los elementos de la matriz en orden ascendente
procedure Matriz.ordenamiento();
var
  f1, c1, f2, c2: integer;
  aux: real;
begin
  for f1 := 1 to fils do
  begin
    for c1 := 1 to cols do
    begin
      for f2 := f1 to fils do
      begin
        for c2 := 1 to cols do
        begin
          // Comparar solo las posiciones que vienen despues de (f1, c1)
          if (f2 > f1) or ((f2 = f1) and (c2 > c1)) then
          begin
            if elem[f1, c1] > elem[f2, c2] then
            begin
              aux := elem[f1, c1];
              elem[f1, c1] := elem[f2, c2];
              elem[f2, c2] := aux;
            end;
          end;
        end;
      end;
    end;
  end;
end;

// =============================================================================
// B) MATRIZ CUADRADA
// =============================================================================

// Verificacion de matriz cuadrada
procedure Matriz.esCuadrada(var resp: boolean);
begin
  resp := (fils > 0) and (fils = cols);
end;

// 1. Triangulares: Triangular Superior (elementos debajo de DP deben ser cero: f > c)
procedure Matriz.esTriangularSuperior(var resp: boolean);
var
  f, c: integer;
begin
  if (fils = 0) or (fils <> cols) then
  begin
    resp := false;
    Exit;
  end;

  resp := true;
  for f := 2 to fils do
  begin
    for c := 1 to f - 1 do
    begin
      if Abs(elem[f, c]) > 0.000001 then
      begin
        resp := false;
        Exit;
      end;
    end;
  end;
end;

// 1. Triangulares: Triangular Inferior (elementos encima de DP deben ser cero: f < c)
procedure Matriz.esTriangularInferior(var resp: boolean);
var
  f, c: integer;
begin
  if (fils = 0) or (fils <> cols) then
  begin
    resp := false;
    Exit;
  end;

  resp := true;
  for f := 1 to fils - 1 do
  begin
    for c := f + 1 to cols do
    begin
      if Abs(elem[f, c]) > 0.000001 then
      begin
        resp := false;
        Exit;
      end;
    end;
  end;
end;

// 1. Triangulares: Generar Matriz Triangular Superior (hacer cero debajo de DP)
procedure Matriz.convertirATriangularSuperior(var MRes: Matriz; var ok: boolean);
var
  f, c: integer;
begin
  if (fils = 0) or (fils <> cols) then
  begin
    ok := false;
    Exit;
  end;
  ok := true;
  MRes.dimensionar(fils, cols);
  for f := 1 to fils do
  begin
    for c := 1 to cols do
    begin
      if f > c then
        MRes.setElem(f, c, 0.0)
      else
        MRes.setElem(f, c, elem[f, c]);
    end;
  end;
end;

// 1. Triangulares: Generar Matriz Triangular Inferior (hacer cero encima de DP)
procedure Matriz.convertirATriangularInferior(var MRes: Matriz; var ok: boolean);
var
  f, c: integer;
begin
  if (fils = 0) or (fils <> cols) then
  begin
    ok := false;
    Exit;
  end;
  ok := true;
  MRes.dimensionar(fils, cols);
  for f := 1 to fils do
  begin
    for c := 1 to cols do
    begin
      if f < c then
        MRes.setElem(f, c, 0.0)
      else
        MRes.setElem(f, c, elem[f, c]);
    end;
  end;
end;

// 2. Diagonal Principal: Suma
procedure Matriz.sumaDiagonalPrincipal(var suma: real; var ok: boolean);
var
  i: integer;
begin
  suma := 0.0;
  if (fils = 0) or (fils <> cols) then
  begin
    ok := false;
    Exit;
  end;
  ok := true;
  for i := 1 to fils do
    suma := suma + elem[i, i];
end;

// 2. Diagonal Principal: Obtener elementos en formato cadena
procedure Matriz.obtenerDiagonalPrincipal(var texto: string; var ok: boolean);
var
  i: integer;
  val: real;
  sVal: string;
begin
  texto := '';
  if (fils = 0) or (fils <> cols) then
  begin
    ok := false;
    Exit;
  end;
  ok := true;
  texto := '[';
  for i := 1 to fils do
  begin
    val := elem[i, i];
    if Frac(val) = 0.0 then
      sVal := IntToStr(Round(val))
    else
      sVal := FloatToStrF(val, ffFixed, 6, 2);
    texto := texto + sVal;
    if i < fils then
      texto := texto + ', ';
  end;
  texto := texto + ']';
end;

// 3. Diagonal Secundaria: Suma
procedure Matriz.sumaDiagonalSecundaria(var suma: real; var ok: boolean);
var
  i: integer;
begin
  suma := 0.0;
  if (fils = 0) or (fils <> cols) then
  begin
    ok := false;
    Exit;
  end;
  ok := true;
  for i := 1 to fils do
    suma := suma + elem[i, fils - i + 1];
end;

// 3. Diagonal Secundaria: Obtener elementos en formato cadena
procedure Matriz.obtenerDiagonalSecundaria(var texto: string; var ok: boolean);
var
  i: integer;
  val: real;
  sVal: string;
begin
  texto := '';
  if (fils = 0) or (fils <> cols) then
  begin
    ok := false;
    Exit;
  end;
  ok := true;
  texto := '[';
  for i := 1 to fils do
  begin
    val := elem[i, fils - i + 1];
    if Frac(val) = 0.0 then
      sVal := IntToStr(Round(val))
    else
      sVal := FloatToStrF(val, ffFixed, 6, 2);
    texto := texto + sVal;
    if i < fils then
      texto := texto + ', ';
  end;
  texto := texto + ']';
end;

// 4. Sumar dos matrices: MRes = A + B
procedure Matriz.sumar(B: Matriz; var MRes: Matriz; var ok: boolean);
var
  f, c: integer;
begin
  if (fils = 0) or (cols = 0) or (B.getFils() <> fils) or (B.getCols() <> cols) then
  begin
    ok := false;
    Exit;
  end;

  ok := true;
  MRes.dimensionar(fils, cols);
  for f := 1 to fils do
    for c := 1 to cols do
      MRes.setElem(f, c, elem[f, c] + B.getElem(f, c));
end;

// 5. Restar dos matrices: MRes = A - B
procedure Matriz.restar(B: Matriz; var MRes: Matriz; var ok: boolean);
var
  f, c: integer;
begin
  if (fils = 0) or (cols = 0) or (B.getFils() <> fils) or (B.getCols() <> cols) then
  begin
    ok := false;
    Exit;
  end;

  ok := true;
  MRes.dimensionar(fils, cols);
  for f := 1 to fils do
    for c := 1 to cols do
      MRes.setElem(f, c, elem[f, c] - B.getElem(f, c));
end;

// 6. Multiplicar dos matrices: MRes = A * B
procedure Matriz.multiplicar(B: Matriz; var MRes: Matriz; var ok: boolean);
var
  f, c, k: integer;
  acum: real;
begin
  if (fils = 0) or (cols = 0) or (cols <> B.getFils()) or (B.getCols() = 0) then
  begin
    ok := false;
    Exit;
  end;

  ok := true;
  MRes.dimensionar(fils, B.getCols());
  for f := 1 to fils do
  begin
    for c := 1 to B.getCols() do
    begin
      acum := 0.0;
      for k := 1 to cols do
        acum := acum + (elem[f, k] * B.getElem(k, c));
      MRes.setElem(f, c, acum);
    end;
  end;
end;

// 7. Invertir: Invertir el orden de todos los elementos de la matriz
procedure Matriz.invertir();
var
  fIni, cIni, fFin, cFin: integer;
  aux: real;
  sigue: boolean;
begin
  if (fils = 0) or (cols = 0) then Exit;

  fIni := 1;
  cIni := 1;
  fFin := fils;
  cFin := cols;

  sigue := true;
  while sigue do
  begin
    // Verificar si el puntero inicial aun esta estrictamente antes del puntero final
    if (fIni < fFin) or ((fIni = fFin) and (cIni < cFin)) then
    begin
      // Intercambiar elementos
      aux := elem[fIni, cIni];
      elem[fIni, cIni] := elem[fFin, cFin];
      elem[fFin, cFin] := aux;

      // Avanzar puntero inicial (izquierda a derecha, fila por fila)
      cIni := cIni + 1;
      if cIni > cols then
      begin
        cIni := 1;
        fIni := fIni + 1;
      end;

      // Retroceder puntero final (derecha a izquierda, fila por fila)
      cFin := cFin - 1;
      if cFin < 1 then
      begin
        cFin := cols;
        fFin := fFin - 1;
      end;
    end
    else
    begin
      sigue := false;
    end;
  end;
end;

// 8. Determinante: Calculado mediante Eliminacion Gaussiana simple
procedure Matriz.determinante(var det: real; var ok: boolean);
var
  A: array[1..MAX_F, 1..MAX_C] of real;
  n, i, j, k, maxFila: integer;
  factor, aux, tempMax, signo: real;
begin
  det := 0.0;
  if (fils = 0) or (fils <> cols) then
  begin
    ok := false;
    Exit;
  end;

  ok := true;
  n := fils;

  // Caso elemental 1x1
  if n = 1 then
  begin
    det := elem[1, 1];
    Exit;
  end;

  // Caso elemental 2x2
  if n = 2 then
  begin
    det := (elem[1, 1] * elem[2, 2]) - (elem[1, 2] * elem[2, 1]);
    Exit;
  end;

  // Copiar datos al arreglo local de trabajo
  for i := 1 to n do
    for j := 1 to n do
      A[i, j] := elem[i, j];

  signo := 1.0;

  // Triangularizacion mediante eliminacion por filas
  for i := 1 to n do
  begin
    // Buscar el pivote maximo en la columna i
    maxFila := i;
    tempMax := Abs(A[i, i]);
    for k := i + 1 to n do
    begin
      if Abs(A[k, i]) > tempMax then
      begin
        tempMax := Abs(A[k, i]);
        maxFila := k;
      end;
    end;

    // Si toda la columna es practicamente cero, el determinante es 0
    if tempMax < 0.0000001 then
    begin
      det := 0.0;
      Exit;
    end;

    // Intercambiar fila i con maxFila si es diferente
    if maxFila <> i then
    begin
      for j := 1 to n do
      begin
        aux := A[i, j];
        A[i, j] := A[maxFila, j];
        A[maxFila, j] := aux;
      end;
      signo := -signo;
    end;

    // Hacer ceros debajo del pivote
    for k := i + 1 to n do
    begin
      factor := A[k, i] / A[i, i];
      for j := i to n do
      begin
        A[k, j] := A[k, j] - (factor * A[i, j]);
      end;
    end;
  end;

  // El determinante es el producto de la diagonal principal
  det := signo;
  for i := 1 to n do
    det := det * A[i, i];

  // Limpiar posibles imprecisiones de coma flotante
  if Abs(det) < 0.0000001 then
    det := 0.0;
end;

// 9. Transpuesta: MRes[c, f] = elem[f, c]
procedure Matriz.transpuesta(var MRes: Matriz);
var
  f, c: integer;
begin
  MRes.dimensionar(cols, fils);
  for f := 1 to fils do
    for c := 1 to cols do
      MRes.setElem(c, f, elem[f, c]);
end;

// 10. Inversa: Calculada por el metodo de Gauss-Jordan sobre [A | I]
procedure Matriz.inversa(var MRes: Matriz; var tieneInversa: boolean);
var
  Aug: array[1..MAX_F, 1..(MAX_C * 2)] of real;
  n, i, j, k, maxFila: integer;
  pivote, factor, aux, tempMax: real;
begin
  tieneInversa := false;
  if (fils = 0) or (fils <> cols) then Exit;

  n := fils;
  MRes.dimensionar(n, n);

  // Construir matriz aumentada [A | I] de tamano n x 2n
  for i := 1 to n do
  begin
    for j := 1 to n do
      Aug[i, j] := elem[i, j];
    for j := 1 to n do
    begin
      if i = j then
        Aug[i, n + j] := 1.0
      else
        Aug[i, n + j] := 0.0;
    end;
  end;

  // Eliminacion de Gauss-Jordan
  for i := 1 to n do
  begin
    // Buscar pivote en la columna i
    maxFila := i;
    tempMax := Abs(Aug[i, i]);
    for k := i + 1 to n do
    begin
      if Abs(Aug[k, i]) > tempMax then
      begin
        tempMax := Abs(Aug[k, i]);
        maxFila := k;
      end;
    end;

    // Si el pivote maximo es cero, la matriz no es invertible (singular)
    if tempMax < 0.0000001 then
    begin
      tieneInversa := false;
      Exit;
    end;

    // Intercambiar fila i con maxFila
    if maxFila <> i then
    begin
      for j := 1 to 2 * n do
      begin
        aux := Aug[i, j];
        Aug[i, j] := Aug[maxFila, j];
        Aug[maxFila, j] := aux;
      end;
    end;

    // Normalizar fila pivote para que Aug[i, i] = 1.0
    pivote := Aug[i, i];
    for j := 1 to 2 * n do
      Aug[i, j] := Aug[i, j] / pivote;

    // Reducir a cero los demas elementos de la columna i (arriba y abajo)
    for k := 1 to n do
    begin
      if k <> i then
      begin
        factor := Aug[k, i];
        for j := 1 to 2 * n do
          Aug[k, j] := Aug[k, j] - (factor * Aug[i, j]);
      end;
    end;
  end;

  // Extraer la parte derecha [A^-1] hacia la matriz resultado MRes
  for i := 1 to n do
  begin
    for j := 1 to n do
    begin
      aux := Aug[i, n + j];
      if Abs(aux) < 0.0000001 then
        aux := 0.0;
      MRes.setElem(i, j, aux);
    end;
  end;

  tieneInversa := true;
end;

end.
