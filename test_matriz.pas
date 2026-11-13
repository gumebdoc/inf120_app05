program test_matriz;

{$mode objfpc}{$H+}

uses
  SysUtils, umatriz;

procedure probarTodo();
var
  A, B, C, I_mat: Matriz;
  ok, existe, resp: boolean;
  fEnc, cEnc: integer;
  suma, det: real;
  txt: string;
begin
  Writeln('====================================================');
  Writeln('PRUEBAS UNITARIAS DE LA CLASE MATRIZ (umatriz.pas)');
  Writeln('====================================================');

  A := Matriz.crear();
  B := Matriz.crear();
  C := Matriz.crear();
  I_mat := Matriz.crear();

  // Test 1: Dimensionar y Cargar
  A.dimensionar(3, 3);
  A.setElem(1, 1, 1); A.setElem(1, 2, 2); A.setElem(1, 3, 3);
  A.setElem(2, 1, 0); A.setElem(2, 2, 4); A.setElem(2, 3, 5);
  A.setElem(3, 1, 0); A.setElem(3, 2, 0); A.setElem(3, 3, 6);

  Writeln('[1] Matriz A (3x3):');
  A.obtenerTextoMatriz(txt);
  Write(txt);

  // Test 2: Es Cuadrada
  A.esCuadrada(resp);
  Writeln('[2] Es cuadrada?: ', resp);

  // Test 3: Triangulares
  A.esTriangularSuperior(resp);
  Writeln('[3] Es triangular superior?: ', resp);
  A.esTriangularInferior(resp);
  Writeln('    Es triangular inferior?: ', resp);

  // Test 4: Diagonales
  A.sumaDiagonalPrincipal(suma, ok);
  A.obtenerDiagonalPrincipal(txt, ok);
  Writeln('[4] Diagonal Principal: ', txt, ' -> Suma = ', suma:0:2);

  A.sumaDiagonalSecundaria(suma, ok);
  A.obtenerDiagonalSecundaria(txt, ok);
  Writeln('    Diagonal Secundaria: ', txt, ' -> Suma = ', suma:0:2);

  // Test 5: Determinante
  A.determinante(det, ok);
  Writeln('[5] Determinante de A (1*4*6 = 24): ', det:0:2);

  // Test 6: Busqueda
  A.busqueda(5.0, fEnc, cEnc, existe);
  Writeln('[6] Busqueda de 5.0: Existe? ', existe, ' en (', fEnc, ',', cEnc, ')');
  A.busqueda(99.0, fEnc, cEnc, existe);
  Writeln('    Busqueda de 99.0: Existe? ', existe);

  // Test 7: Suma y Resta con B
  B.dimensionar(3, 3);
  B.setElem(1, 1, 2); B.setElem(1, 2, 0); B.setElem(1, 3, 1);
  B.setElem(2, 1, 1); B.setElem(2, 2, 3); B.setElem(2, 3, 0);
  B.setElem(3, 1, 0); B.setElem(3, 2, 1); B.setElem(3, 3, 2);

  A.sumar(B, C, ok);
  Writeln('[7] C = A + B:');
  C.obtenerTextoMatriz(txt);
  Write(txt);

  A.restar(B, C, ok);
  Writeln('[8] C = A - B:');
  C.obtenerTextoMatriz(txt);
  Write(txt);

  // Test 9: Multiplicacion
  A.multiplicar(B, C, ok);
  Writeln('[9] C = A * B:');
  C.obtenerTextoMatriz(txt);
  Write(txt);

  // Test 10: Transpuesta
  A.transpuesta(C);
  Writeln('[10] Transpuesta de A:');
  C.obtenerTextoMatriz(txt);
  Write(txt);

  // Test 11: Inversa
  // Matriz invertible B:
  // [2 0 1]
  // [1 3 0]
  // [0 1 2]
  // det = 2*(6 - 0) - 0 + 1*(1 - 0) = 12 + 1 = 13 <> 0
  B.determinante(det, ok);
  Writeln('[11] Determinante de B: ', det:0:2);
  B.inversa(C, ok);
  Writeln('     Inversa de B calculada? ', ok);
  Writeln('     Matriz Inversa B^-1:');
  C.obtenerTextoMatriz(txt);
  Write(txt);

  // Verificar B * B^-1 = Identidad
  B.multiplicar(C, I_mat, ok);
  Writeln('     Verificacion B * B^-1 (Debe ser la Identidad):');
  I_mat.obtenerTextoMatriz(txt);
  Write(txt);

  // Test 12: Invertir
  Writeln('[12] Matriz A antes de Invertir:');
  A.obtenerTextoMatriz(txt);
  Write(txt);
  A.invertir();
  Writeln('     Matriz A despues de Invertir (orden invertido):');
  A.obtenerTextoMatriz(txt);
  Write(txt);

  // Test 13: Ordenamiento
  A.ordenamiento();
  Writeln('[13] Matriz A despues de Ordenamiento ascendente:');
  A.obtenerTextoMatriz(txt);
  Write(txt);

  Writeln('====================================================');
  Writeln('TODAS LAS PRUEBAS COMPLETADAS SATISFACTORIAMENTE');
  Writeln('====================================================');

  A.Free;
  B.Free;
  C.Free;
  I_mat.Free;
end;

begin
  probarTodo();
end.
