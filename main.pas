unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids, ExtCtrls,
  umatriz;

type

  { TFormMain }

  TFormMain = class(TForm)
    // Encabezado
    LabelTitulo: TLabel;
    LabelSubtitulo: TLabel;
    LabelAutor: TLabel;

    // Matriz A
    GroupBoxA: TGroupBox;
    LabelFilsA: TLabel;
    EditFilsA: TEdit;
    LabelColsA: TLabel;
    EditColsA: TEdit;
    ButtonDimA: TButton;
    ButtonAleatorioA: TButton;
    ButtonCerosA: TButton;
    ButtonEjemploA: TButton;
    ButtonLimpiarA: TButton;
    StringGridA: TStringGrid;

    // Matriz B
    GroupBoxB: TGroupBox;
    LabelFilsB: TLabel;
    EditFilsB: TEdit;
    LabelColsB: TLabel;
    EditColsB: TEdit;
    ButtonDimB: TButton;
    ButtonAleatorioB: TButton;
    ButtonCerosB: TButton;
    ButtonEjemploB: TButton;
    ButtonLimpiarB: TButton;
    StringGridB: TStringGrid;

    // Matriz C (Resultado)
    GroupBoxC: TGroupBox;
    LabelInfoC: TLabel;
    ButtonCopiarCA: TButton;
    ButtonCopiarCB: TButton;
    ButtonLimpiarC: TButton;
    StringGridC: TStringGrid;

    // Operaciones Matriz General
    GroupBoxGeneral: TGroupBox;
    ButtonCargarA: TButton;
    ButtonMostrarA: TButton;
    ButtonBusquedaA: TButton;
    ButtonOrdenamientoA: TButton;

    // Operaciones Matriz Cuadrada
    GroupBoxCuadrada: TGroupBox;
    ButtonTriangularesA: TButton;
    ButtonHacerTriangSup: TButton;
    ButtonHacerTriangInf: TButton;
    ButtonDiagPrincipalA: TButton;
    ButtonDiagSecundariaA: TButton;
    ButtonInvertirA: TButton;
    ButtonDeterminanteA: TButton;
    ButtonTranspuestaA: TButton;
    ButtonInversaA: TButton;

    // Operaciones Binarias
    GroupBoxBinarias: TGroupBox;
    ButtonSumar: TButton;
    ButtonRestar: TButton;
    ButtonMultiplicar: TButton;
    ButtonDemoCompleta: TButton;

    // Panel de Log
    GroupBoxLog: TGroupBox;
    MemoLog: TMemo;
    ButtonLimpiarLog: TButton;

    // Procedimientos de Eventos
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    // Eventos Matriz A
    procedure ButtonDimAClick(Sender: TObject);
    procedure ButtonAleatorioAClick(Sender: TObject);
    procedure ButtonCerosAClick(Sender: TObject);
    procedure ButtonEjemploAClick(Sender: TObject);
    procedure ButtonLimpiarAClick(Sender: TObject);

    // Eventos Matriz B
    procedure ButtonDimBClick(Sender: TObject);
    procedure ButtonAleatorioBClick(Sender: TObject);
    procedure ButtonCerosBClick(Sender: TObject);
    procedure ButtonEjemploBClick(Sender: TObject);
    procedure ButtonLimpiarBClick(Sender: TObject);

    // Eventos Matriz C
    procedure ButtonCopiarCAClick(Sender: TObject);
    procedure ButtonCopiarCBClick(Sender: TObject);
    procedure ButtonLimpiarCClick(Sender: TObject);

    // Eventos Operaciones Generales
    procedure ButtonCargarAClick(Sender: TObject);
    procedure ButtonMostrarAClick(Sender: TObject);
    procedure ButtonBusquedaAClick(Sender: TObject);
    procedure ButtonOrdenamientoAClick(Sender: TObject);

    // Eventos Operaciones Cuadradas
    procedure ButtonTriangularesAClick(Sender: TObject);
    procedure ButtonHacerTriangSupClick(Sender: TObject);
    procedure ButtonHacerTriangInfClick(Sender: TObject);
    procedure ButtonDiagPrincipalAClick(Sender: TObject);
    procedure ButtonDiagSecundariaAClick(Sender: TObject);
    procedure ButtonInvertirAClick(Sender: TObject);
    procedure ButtonDeterminanteAClick(Sender: TObject);
    procedure ButtonTranspuestaAClick(Sender: TObject);
    procedure ButtonInversaAClick(Sender: TObject);

    // Eventos Operaciones Binarias
    procedure ButtonSumarClick(Sender: TObject);
    procedure ButtonRestarClick(Sender: TObject);
    procedure ButtonMultiplicarClick(Sender: TObject);
    procedure ButtonDemoCompletaClick(Sender: TObject);

    // Evento Log
    procedure ButtonLimpiarLogClick(Sender: TObject);

  private
    MatA: Matriz;
    MatB: Matriz;
    MatC: Matriz;

    procedure SincronizarMatrizDesdeGrid(SG: TStringGrid; M: Matriz);
    procedure SincronizarGridDesdeMatriz(SG: TStringGrid; M: Matriz);
    procedure Log(const msg: string);
  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  MatA := Matriz.crear();
  MatB := Matriz.crear();
  MatC := Matriz.crear();

  // Inicializar Matriz A con valores de ejemplo (3x3)
  ButtonEjemploAClick(nil);

  // Inicializar Matriz B con valores de ejemplo (3x3)
  ButtonEjemploBClick(nil);

  Log('========================================================================');
  Log('Bienvenido a la Aplicacion U5: Clase Matriz (Lazarus - Pascal)');
  Log('Materia: Programacion I (INF120) | Evans Balcazar | Gustavo Melgar');
  Log('========================================================================');
  Log('Sistemas listos. Puede editar los valores directamente en las celdas.');
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  MatA.Free;
  MatB.Free;
  MatC.Free;
end;

procedure TFormMain.Log(const msg: string);
begin
  MemoLog.Lines.Add(msg);
  MemoLog.SelStart := Length(MemoLog.Text);
end;

procedure TFormMain.ButtonLimpiarLogClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

// Sincronizar la matriz desde las celdas del StringGrid
procedure TFormMain.SincronizarMatrizDesdeGrid(SG: TStringGrid; M: Matriz);
var
  f, c: integer;
  sVal: string;
  val: real;
begin
  M.dimensionar(SG.RowCount, SG.ColCount);
  for f := 1 to SG.RowCount do
  begin
    for c := 1 to SG.ColCount do
    begin
      sVal := Trim(SG.Cells[c - 1, f - 1]);
      if sVal = '' then sVal := '0';
      // Manejar separadores decimales punto y coma
      sVal := StringReplace(sVal, ',', '.', [rfReplaceAll]);
      val := StrToFloatDef(sVal, 0.0);
      M.setElem(f, c, val);
    end;
  end;
end;

// Sincronizar las celdas del StringGrid desde los datos de la matriz
procedure TFormMain.SincronizarGridDesdeMatriz(SG: TStringGrid; M: Matriz);
var
  f, c: integer;
  val: real;
  sVal: string;
begin
  SG.RowCount := M.getFils();
  SG.ColCount := M.getCols();
  for f := 1 to M.getFils() do
  begin
    for c := 1 to M.getCols() do
    begin
      val := M.getElem(f, c);
      if Frac(val) = 0.0 then
        sVal := IntToStr(Round(val))
      else
        sVal := FloatToStrF(val, ffFixed, 6, 2);
      SG.Cells[c - 1, f - 1] := sVal;
    end;
  end;
end;

// =============================================================================
// EVENTOS MATRIZ A
// =============================================================================

procedure TFormMain.ButtonDimAClick(Sender: TObject);
var
  f, c: integer;
begin
  f := StrToIntDef(Trim(EditFilsA.Text), 3);
  c := StrToIntDef(Trim(EditColsA.Text), 3);
  if (f < 1) or (f > MAX_F) or (c < 1) or (c > MAX_C) then
  begin
    ShowMessage('Error: Dimensiones deben estar entre 1 y ' + IntToStr(MAX_F));
    Exit;
  end;
  MatA.dimensionar(f, c);
  MatA.cargarCeros();
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  Log('[Matriz A] Redimensionada a ' + IntToStr(f) + 'x' + IntToStr(c) + ' con ceros.');
end;

procedure TFormMain.ButtonAleatorioAClick(Sender: TObject);
var
  f, c: integer;
begin
  f := StrToIntDef(Trim(EditFilsA.Text), StringGridA.RowCount);
  c := StrToIntDef(Trim(EditColsA.Text), StringGridA.ColCount);
  MatA.dimensionar(f, c);
  MatA.cargarAleatorio(1, 20);
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  Log('[Matriz A] Cargada con valores enteros aleatorios [1..20].');
end;

procedure TFormMain.ButtonCerosAClick(Sender: TObject);
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.cargarCeros();
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  Log('[Matriz A] Celdas puestas a 0.');
end;

procedure TFormMain.ButtonEjemploAClick(Sender: TObject);
begin
  EditFilsA.Text := '3';
  EditColsA.Text := '3';
  MatA.dimensionar(3, 3);
  MatA.setElem(1, 1, 1); MatA.setElem(1, 2, 2); MatA.setElem(1, 3, 3);
  MatA.setElem(2, 1, 0); MatA.setElem(2, 2, 4); MatA.setElem(2, 3, 5);
  MatA.setElem(3, 1, 0); MatA.setElem(3, 2, 0); MatA.setElem(3, 3, 6);
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  Log('[Matriz A] Cargada con matriz de ejemplo 3x3 (Triangular Superior, det=24).');
end;

procedure TFormMain.ButtonLimpiarAClick(Sender: TObject);
begin
  MatA.limpiar();
  StringGridA.RowCount := 1;
  StringGridA.ColCount := 1;
  StringGridA.Cells[0, 0] := '';
  EditFilsA.Text := '1';
  EditColsA.Text := '1';
  Log('[Matriz A] Limpiada completamente.');
end;

// =============================================================================
// EVENTOS MATRIZ B
// =============================================================================

procedure TFormMain.ButtonDimBClick(Sender: TObject);
var
  f, c: integer;
begin
  f := StrToIntDef(Trim(EditFilsB.Text), 3);
  c := StrToIntDef(Trim(EditColsB.Text), 3);
  if (f < 1) or (f > MAX_F) or (c < 1) or (c > MAX_C) then
  begin
    ShowMessage('Error: Dimensiones deben estar entre 1 y ' + IntToStr(MAX_F));
    Exit;
  end;
  MatB.dimensionar(f, c);
  MatB.cargarCeros();
  SincronizarGridDesdeMatriz(StringGridB, MatB);
  Log('[Matriz B] Redimensionada a ' + IntToStr(f) + 'x' + IntToStr(c) + ' con ceros.');
end;

procedure TFormMain.ButtonAleatorioBClick(Sender: TObject);
var
  f, c: integer;
begin
  f := StrToIntDef(Trim(EditFilsB.Text), StringGridB.RowCount);
  c := StrToIntDef(Trim(EditColsB.Text), StringGridB.ColCount);
  MatB.dimensionar(f, c);
  MatB.cargarAleatorio(1, 15);
  SincronizarGridDesdeMatriz(StringGridB, MatB);
  Log('[Matriz B] Cargada con valores enteros aleatorios [1..15].');
end;

procedure TFormMain.ButtonCerosBClick(Sender: TObject);
begin
  SincronizarMatrizDesdeGrid(StringGridB, MatB);
  MatB.cargarCeros();
  SincronizarGridDesdeMatriz(StringGridB, MatB);
  Log('[Matriz B] Celdas puestas a 0.');
end;

procedure TFormMain.ButtonEjemploBClick(Sender: TObject);
begin
  EditFilsB.Text := '3';
  EditColsB.Text := '3';
  MatB.dimensionar(3, 3);
  MatB.setElem(1, 1, 2); MatB.setElem(1, 2, 0); MatB.setElem(1, 3, 1);
  MatB.setElem(2, 1, 1); MatB.setElem(2, 2, 3); MatB.setElem(2, 3, 0);
  MatB.setElem(3, 1, 0); MatB.setElem(3, 2, 1); MatB.setElem(3, 3, 2);
  SincronizarGridDesdeMatriz(StringGridB, MatB);
  Log('[Matriz B] Cargada con matriz de ejemplo 3x3 (Invertible, det=13).');
end;

procedure TFormMain.ButtonLimpiarBClick(Sender: TObject);
begin
  MatB.limpiar();
  StringGridB.RowCount := 1;
  StringGridB.ColCount := 1;
  StringGridB.Cells[0, 0] := '';
  EditFilsB.Text := '1';
  EditColsB.Text := '1';
  Log('[Matriz B] Limpiada completamente.');
end;

// =============================================================================
// EVENTOS MATRIZ C (RESULTADO)
// =============================================================================

procedure TFormMain.ButtonCopiarCAClick(Sender: TObject);
begin
  if (MatC.getFils() = 0) or (MatC.getCols() = 0) then
  begin
    ShowMessage('La Matriz C esta vacia.');
    Exit;
  end;
  MatC.copiar(MatA);
  EditFilsA.Text := IntToStr(MatA.getFils());
  EditColsA.Text := IntToStr(MatA.getCols());
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  Log('Copiado resultado de C hacia Matriz A.');
end;

procedure TFormMain.ButtonCopiarCBClick(Sender: TObject);
begin
  if (MatC.getFils() = 0) or (MatC.getCols() = 0) then
  begin
    ShowMessage('La Matriz C esta vacia.');
    Exit;
  end;
  MatC.copiar(MatB);
  EditFilsB.Text := IntToStr(MatB.getFils());
  EditColsB.Text := IntToStr(MatB.getCols());
  SincronizarGridDesdeMatriz(StringGridB, MatB);
  Log('Copiado resultado de C hacia Matriz B.');
end;

procedure TFormMain.ButtonLimpiarCClick(Sender: TObject);
begin
  MatC.limpiar();
  StringGridC.RowCount := 1;
  StringGridC.ColCount := 1;
  StringGridC.Cells[0, 0] := '';
  LabelInfoC.Caption := 'Matriz Resultado (Vacia)';
  Log('[Matriz C] Limpiada.');
end;

// =============================================================================
// A) MATRIZ GENERAL
// =============================================================================

procedure TFormMain.ButtonCargarAClick(Sender: TObject);
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  Log('[Cargar] Matriz A leida y actualizada desde la interfaz grafica (' +
      IntToStr(MatA.getFils()) + 'x' + IntToStr(MatA.getCols()) + ').');
  ShowMessage('Matriz A cargada correctamente desde las celdas.');
end;

procedure TFormMain.ButtonMostrarAClick(Sender: TObject);
var
  txt: string;
begin
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  MatA.obtenerTextoMatriz(txt);
  Log('------------------------------------------------------------------------');
  Log('[Mostrar] Visualizacion de Matriz A:');
  MemoLog.Lines.Add(txt);
  Log('------------------------------------------------------------------------');
end;

procedure TFormMain.ButtonBusquedaAClick(Sender: TObject);
var
  sInput: string;
  ele: real;
  fEnc, cEnc: integer;
  existe: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  sInput := InputBox('Busqueda en Matriz A', 'Ingrese el valor numerico a buscar:', '4');
  if sInput = '' then Exit;

  sInput := StringReplace(sInput, ',', '.', [rfReplaceAll]);
  if not TryStrToFloat(sInput, ele) then
  begin
    ShowMessage('Valor ingresado no es valido.');
    Exit;
  end;

  MatA.busqueda(ele, fEnc, cEnc, existe);
  if existe then
  begin
    StringGridA.Row := fEnc - 1;
    StringGridA.Col := cEnc - 1;
    Log('[Busqueda] Elemento ' + sInput + ' ENCONTRADO en la Fila ' + IntToStr(fEnc) +
        ', Columna ' + IntToStr(cEnc) + '.');
    ShowMessage('Elemento ' + sInput + ' encontrado con exito en la posicion (' +
                IntToStr(fEnc) + ', ' + IntToStr(cEnc) + ').');
  end
  else
  begin
    Log('[Busqueda] Elemento ' + sInput + ' NO existe en la Matriz A.');
    ShowMessage('El elemento ' + sInput + ' NO fue encontrado en la Matriz A.');
  end;
end;

procedure TFormMain.ButtonOrdenamientoAClick(Sender: TObject);
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.ordenamiento();
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  Log('[Ordenamiento] Matriz A ordenada ascendentemente de menor a mayor.');
  ShowMessage('Matriz A ordenada correctamente.');
end;

// =============================================================================
// B) MATRIZ CUADRADA
// =============================================================================

procedure TFormMain.ButtonTriangularesAClick(Sender: TObject);
var
  esCuad, esSup, esInf: boolean;
  res: string;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.esCuadrada(esCuad);
  if not esCuad then
  begin
    ShowMessage('La operacion requiere una Matriz Cuadrada (Filas = Columnas). ' +
                'Actualmente es ' + IntToStr(MatA.getFils()) + 'x' + IntToStr(MatA.getCols()));
    Exit;
  end;

  MatA.esTriangularSuperior(esSup);
  MatA.esTriangularInferior(esInf);

  res := 'Analisis de Matriz A (' + IntToStr(MatA.getFils()) + 'x' + IntToStr(MatA.getCols()) + '):' + sLineBreak;
  if esSup and esInf then
    res := res + '• Es una Matriz DIAGONAL (tanto Triangular Superior como Inferior).'
  else if esSup then
    res := res + '• Es una Matriz TRIANGULAR SUPERIOR (ceros debajo de la diagonal principal).'
  else if esInf then
    res := res + '• Es una Matriz TRIANGULAR INFERIOR (ceros encima de la diagonal principal).'
  else
    res := res + '• NO es triangular (posee valores no nulos arriba y abajo de la diagonal).';

  Log('[Triangulares] ' + res);
  ShowMessage(res);
end;

procedure TFormMain.ButtonHacerTriangSupClick(Sender: TObject);
var
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.convertirATriangularSuperior(MatC, ok);
  if not ok then
  begin
    ShowMessage('Error: La matriz debe ser cuadrada.');
    Exit;
  end;
  SincronizarGridDesdeMatriz(StringGridC, MatC);
  LabelInfoC.Caption := 'Matriz Resultado: Triangular Superior de A';
  Log('[Triangulares] Generada Matriz Triangular Superior de A en Matriz C.');
end;

procedure TFormMain.ButtonHacerTriangInfClick(Sender: TObject);
var
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.convertirATriangularInferior(MatC, ok);
  if not ok then
  begin
    ShowMessage('Error: La matriz debe ser cuadrada.');
    Exit;
  end;
  SincronizarGridDesdeMatriz(StringGridC, MatC);
  LabelInfoC.Caption := 'Matriz Resultado: Triangular Inferior de A';
  Log('[Triangulares] Generada Matriz Triangular Inferior de A en Matriz C.');
end;

procedure TFormMain.ButtonDiagPrincipalAClick(Sender: TObject);
var
  suma: real;
  txt: string;
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.sumaDiagonalPrincipal(suma, ok);
  MatA.obtenerDiagonalPrincipal(txt, ok);
  if not ok then
  begin
    ShowMessage('Error: La Diagonal Principal solo se define en Matrices Cuadradas.');
    Exit;
  end;
  Log('[Diagonal Principal] Elementos: ' + txt + ' | Suma (Traza): ' + FloatToStrF(suma, ffFixed, 8, 2));
  ShowMessage('Diagonal Principal de Matriz A:' + sLineBreak +
              'Elementos: ' + txt + sLineBreak +
              'Suma (Traza): ' + FloatToStrF(suma, ffFixed, 8, 2));
end;

procedure TFormMain.ButtonDiagSecundariaAClick(Sender: TObject);
var
  suma: real;
  txt: string;
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.sumaDiagonalSecundaria(suma, ok);
  MatA.obtenerDiagonalSecundaria(txt, ok);
  if not ok then
  begin
    ShowMessage('Error: La Diagonal Secundaria solo se define en Matrices Cuadradas.');
    Exit;
  end;
  Log('[Diagonal Secundaria] Elementos: ' + txt + ' | Suma: ' + FloatToStrF(suma, ffFixed, 8, 2));
  ShowMessage('Diagonal Secundaria de Matriz A:' + sLineBreak +
              'Elementos: ' + txt + sLineBreak +
              'Suma: ' + FloatToStrF(suma, ffFixed, 8, 2));
end;

procedure TFormMain.ButtonInvertirAClick(Sender: TObject);
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.invertir();
  SincronizarGridDesdeMatriz(StringGridA, MatA);
  Log('[Invertir] Se invirtio el orden secuencial de todos los elementos de Matriz A.');
  ShowMessage('Elementos de Matriz A invertidos correctamente.');
end;

procedure TFormMain.ButtonDeterminanteAClick(Sender: TObject);
var
  det: real;
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.determinante(det, ok);
  if not ok then
  begin
    ShowMessage('Error: El determinante solo existe para Matrices Cuadradas (NxN).');
    Exit;
  end;
  Log('[Determinante] det(A) = ' + FloatToStrF(det, ffFixed, 8, 4));
  ShowMessage('Determinante de Matriz A:' + sLineBreak +
              'det(A) = ' + FloatToStrF(det, ffFixed, 8, 4));
end;

procedure TFormMain.ButtonTranspuestaAClick(Sender: TObject);
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.transpuesta(MatC);
  SincronizarGridDesdeMatriz(StringGridC, MatC);
  LabelInfoC.Caption := 'Matriz Resultado: Transpuesta de A (A^T)';
  Log('[Transpuesta] Transpuesta de Matriz A generada en Matriz C (' +
      IntToStr(MatC.getFils()) + 'x' + IntToStr(MatC.getCols()) + ').');
end;

procedure TFormMain.ButtonInversaAClick(Sender: TObject);
var
  tieneInv: boolean;
  det: real;
  okDet: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  MatA.determinante(det, okDet);
  if (not okDet) then
  begin
    ShowMessage('Error: La inversa solo existe para Matrices Cuadradas.');
    Exit;
  end;

  MatA.inversa(MatC, tieneInv);
  if tieneInv then
  begin
    SincronizarGridDesdeMatriz(StringGridC, MatC);
    LabelInfoC.Caption := 'Matriz Resultado: Inversa de A (A^-1)';
    Log('[Inversa] Matriz Inversa A^-1 calculada con exito en Matriz C. (det=' +
        FloatToStrF(det, ffFixed, 6, 2) + ').');
    ShowMessage('Matriz Inversa calculada correctamente y colocada en Matriz C.');
  end
  else
  begin
    LabelInfoC.Caption := 'Matriz Resultado: A es Singular (Sin Inversa)';
    Log('[Inversa] Error: La Matriz A es SINGULAR (determinante = 0), por lo que NO tiene inversa.');
    ShowMessage('La Matriz A NO tiene inversa porque su determinante es 0 (matriz singular).');
  end;
end;

// =============================================================================
// C) OPERACIONES BINARIAS
// =============================================================================

procedure TFormMain.ButtonSumarClick(Sender: TObject);
var
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  SincronizarMatrizDesdeGrid(StringGridB, MatB);
  MatA.sumar(MatB, MatC, ok);
  if ok then
  begin
    SincronizarGridDesdeMatriz(StringGridC, MatC);
    LabelInfoC.Caption := 'Matriz Resultado: C = A + B';
    Log('[Suma] Operacion C = A + B completada (' +
        IntToStr(MatC.getFils()) + 'x' + IntToStr(MatC.getCols()) + ').');
  end
  else
  begin
    ShowMessage('Error en Suma: Las matrices deben tener el mismo orden (Filas y Columnas iguales). ' +
                'A es ' + IntToStr(MatA.getFils()) + 'x' + IntToStr(MatA.getCols()) +
                ' y B es ' + IntToStr(MatB.getFils()) + 'x' + IntToStr(MatB.getCols()));
  end;
end;

procedure TFormMain.ButtonRestarClick(Sender: TObject);
var
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  SincronizarMatrizDesdeGrid(StringGridB, MatB);
  MatA.restar(MatB, MatC, ok);
  if ok then
  begin
    SincronizarGridDesdeMatriz(StringGridC, MatC);
    LabelInfoC.Caption := 'Matriz Resultado: C = A - B';
    Log('[Resta] Operacion C = A - B completada (' +
        IntToStr(MatC.getFils()) + 'x' + IntToStr(MatC.getCols()) + ').');
  end
  else
  begin
    ShowMessage('Error en Resta: Las matrices deben tener el mismo orden (Filas y Columnas iguales). ' +
                'A es ' + IntToStr(MatA.getFils()) + 'x' + IntToStr(MatA.getCols()) +
                ' y B es ' + IntToStr(MatB.getFils()) + 'x' + IntToStr(MatB.getCols()));
  end;
end;

procedure TFormMain.ButtonMultiplicarClick(Sender: TObject);
var
  ok: boolean;
begin
  SincronizarMatrizDesdeGrid(StringGridA, MatA);
  SincronizarMatrizDesdeGrid(StringGridB, MatB);
  MatA.multiplicar(MatB, MatC, ok);
  if ok then
  begin
    SincronizarGridDesdeMatriz(StringGridC, MatC);
    LabelInfoC.Caption := 'Matriz Resultado: C = A * B';
    Log('[Multiplicacion] Operacion C = A * B completada (' +
        IntToStr(MatC.getFils()) + 'x' + IntToStr(MatC.getCols()) + ').');
  end
  else
  begin
    ShowMessage('Error en Multiplicacion: Columnas de Matriz A (' + IntToStr(MatA.getCols()) +
                ') deben ser iguales a Filas de Matriz B (' + IntToStr(MatB.getFils()) + ').');
  end;
end;

procedure TFormMain.ButtonDemoCompletaClick(Sender: TObject);
var
  detA, detB: real;
  okDet: boolean;
begin
  ButtonEjemploAClick(nil);
  ButtonEjemploBClick(nil);
  ButtonSumarClick(nil);

  MatA.determinante(detA, okDet);
  MatB.determinante(detB, okDet);

  Log('========================================================================');
  Log('DEMOSTRACION RAPIDA EJECUTADA EXITOSAMENTE:');
  Log('• Matriz A cargada (3x3 Triangular Superior, det=' + FloatToStrF(detA, ffFixed, 6, 2) + ')');
  Log('• Matriz B cargada (3x3 Invertible, det=' + FloatToStrF(detB, ffFixed, 6, 2) + ')');
  Log('• Matriz C calculada como Suma C = A + B');
  Log('========================================================================');
  ShowMessage('Demostracion completada con exito.');
end;

end.
