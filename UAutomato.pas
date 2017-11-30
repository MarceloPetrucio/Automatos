unit UAutomato;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBClient, Grids, DBGrids;



type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TxtEstados: TEdit;
    TxtAlfabeto: TEdit;
    TxtInicial: TEdit;
    TxtFinal: TEdit;
    TxtTransicao: TMemo;
    Estado: TClientDataSet;
    Transicao: TClientDataSet;
    EstadoESTADO: TStringField;
    EstadoINICIAL: TStringField;
    EstadoFINAL: TStringField;
    TransicaoESTADO: TStringField;
    TransicaoVALOR: TStringField;
    TransicaoPROXESTADO: TStringField;
    Button1: TButton;
    Button2: TButton;
    DsAlfabeto: TDataSource;
    DBGrid1: TDBGrid;
    Alfabeto: TClientDataSet;
    AlfabetoALFABETO: TStringField;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DsEstado: TDataSource;
    DsTransicao: TDataSource;
    PesqTransicao: TClientDataSet;
    PesqTransicaoESTADO: TStringField;
    PesqTransicaoVALOR: TStringField;
    PesqTransicaoPROXESTADO: TStringField;
    TxtSaida: TMemo;
    RlSaida: TLabel;
    PesqTransicaoCODIGO: TIntegerField;
    TransicaoCODIGO: TIntegerField;
    GroupBox2: TGroupBox;
    Button3: TButton;
    TxtPalavra: TEdit;
    Button4: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EstadoUSADO: TStringField;
    Memo1: TMemo;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure TxtTransicaoKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function  BuscaEstadoInicial: string;
    function VerificaQtdeCaminho(Estado:String;Alfabeto:String):Integer;
    Function BackTrack(Estado:String;Palavra:String;Posicao:Integer):Boolean;
    function BuscaEstadoFinal(EstadoParam:String): Boolean;
    function ProximoEstado(Estado:String;Alfabeto:String;Seq:Integer):String;
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TxtAlfabetoEnter(Sender: TObject);
    procedure TxtAlfabetoExit(Sender: TObject);
    procedure TxtEstadosEnter(Sender: TObject);
    procedure TxtEstadosExit(Sender: TObject);
    procedure TxtInicialEnter(Sender: TObject);
    procedure TxtInicialExit(Sender: TObject);
    procedure TxtFinalEnter(Sender: TObject);
    procedure TxtFinalExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
   wVerifica : Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation



{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
Var
   i, wposicao, wComeco : Integer;
   wAux : String;
   wConjunto : String;
   wCodigo : Integer;
   wIniFim : String;
   wIniFimAux : String;
   wLinguagem : Boolean;
begin
   wposicao := 0;
   wComeco  := 0;
   wCodigo  := 1;
   wIniFim  := '';

   Estado.Close;
   Estado.CreateDataSet;
   Estado.Open;

   Transicao.Close;
   Transicao.CreateDataSet;
   Transicao.Open;

   PesqTransicao.Close;
   PesqTransicao.CreateDataSet;
   PesqTransicao.Open;

   Alfabeto.Close;
   Alfabeto.CreateDataSet;
   Alfabeto.Open;

   for i := 0 to TxtTransicao.Lines.Count -1 do
      begin
         Transicao.Append;
         TransicaoCODIGO.AsInteger := wCodigo;
         wposicao := Pos(',',TxtTransicao.Lines[i]);
         wComeco  := Pos('(',TxtTransicao.Lines[i]);
         //Estado Inicial
         TransicaoESTADO.AsString := Trim(Copy(TxtTransicao.Lines[i],wComeco+1,wPosicao-wComeco-1));

         wComeco  := Pos(',',TxtTransicao.Lines[i]);
         wposicao := Pos(')',TxtTransicao.Lines[i]);
         TransicaoVALOR.AsString := Trim(Copy(TxtTransicao.Lines[i],wComeco+1,wPosicao-wComeco-1));
         TxtTransicao.Lines[i];

         //Estado Final
         wComeco  := Pos('=',TxtTransicao.Lines[i]);
         wposicao := Length(TxtTransicao.Lines[i]);
         TransicaoPROXESTADO.AsString := Trim(Copy(TxtTransicao.Lines[i],wComeco+1,wPosicao-wComeco));
         Transicao.Post;
         Inc(wCodigo);
      end;

   for i := 0 to TxtTransicao.Lines.Count -1 do
      begin
         PesqTransicao.Append;
         PesqTransicaoCODIGO.AsInteger := wCodigo;
         wposicao := Pos(',',TxtTransicao.Lines[i]);
         wComeco  := Pos('(',TxtTransicao.Lines[i]);
         //Estado Inicial
         PesqTransicaoESTADO.AsString := Trim(Copy(TxtTransicao.Lines[i],wComeco+1,wPosicao-wComeco-1));

         wComeco  := Pos(',',TxtTransicao.Lines[i]);
         wposicao := Pos(')',TxtTransicao.Lines[i]);
         PesqTransicaoVALOR.AsString := Trim(Copy(TxtTransicao.Lines[i],wComeco+1,wPosicao-wComeco-1));
         TxtTransicao.Lines[i];

         //Estado Final
         wComeco  := Pos('=',TxtTransicao.Lines[i]);
         wposicao := Length(TxtTransicao.Lines[i]);
         PesqTransicaoPROXESTADO.AsString := Trim(Copy(TxtTransicao.Lines[i],wComeco+1,wPosicao-wComeco));
         PesqTransicao.Post;
         Inc(wCodigo);
      end;

   wConjunto := Trim(TxtEstados.Text);
   While (wConjunto <> '') Do
      Begin
         If (Pos(',',wConjunto) > 0) Then
            Begin
               wAux      := '';
               wPosicao  := Pos(',',wConjunto);
               wAux      := Trim(Copy(wConjunto,0,wPosicao-1));
               wConjunto := Trim(Copy(wConjunto,wPosicao+1,120));
            End
         Else
            Begin
               wAux      := Trim(wConjunto);
               wConjunto := '';
            End;

         If wAux <> '' Then
            Begin
               Estado.Append;
               EstadoESTADO.AsString := wAux;
               wIniFimAux := Trim(TxtInicial.Text);
               While (wIniFimAux <> '') Do
                  Begin
                     If (Pos(',',wIniFimAux) > 0) Then
                        Begin
                           wIniFim   := '';
                           wPosicao  := Pos(',',wIniFimAux);
                           wIniFim   := Trim(Copy(wIniFimAux,0,wPosicao-1));
                           wIniFimAux := Trim(Copy(wIniFimAux,wPosicao+1,120));
                           If (wIniFim = wAux) Then
                              EstadoINICIAL.AsString := 'S';
                        End
                     Else
                        Begin
                           wIniFim   := Trim(wIniFimAux);
                           wIniFimAux := '';
                           If (wIniFim = wAux) Then
                              EstadoINICIAL.AsString := 'S';
                        End;
                  End;

               wIniFimAux := Trim(TxtFinal.Text);
               While (wIniFimAux <> '') Do
                  Begin
                     If (Pos(',',wIniFimAux) > 0) Then
                        Begin
                           wIniFim   := '';
                           wPosicao  := Pos(',',wIniFimAux);
                           wIniFim   := Trim(Copy(wIniFimAux,0,wPosicao-1));
                           wIniFimAux := Trim(Copy(wIniFimAux,wPosicao+1,120));
                           If (wIniFim = wAux) Then
                              EstadoFINAL.AsString := 'S';
                        End
                     Else
                        Begin
                           wIniFim   := Trim(wIniFimAux);
                           wIniFimAux := '';
                           If (wIniFim = wAux) Then
                              EstadoFINAL.AsString := 'S';
                        End;
                  End;

               If EstadoINICIAL.AsString = '' Then
                  EstadoINICIAL.AsString := 'N';

               If EstadoFINAL.AsString = '' Then
                  EstadoFINAL.AsString := 'N';

               EstadoUSADO.AsString := 'N';
               Estado.Post;
            End;
      End;


   wConjunto := Trim(TxtAlfabeto.Text);
   While (wConjunto <> '') Do
      Begin
         If (Pos(',',wConjunto) > 0) Then
            Begin
               wAux       := '';
               wPosicao  := Pos(',',wConjunto);
               wAux      := Trim(Copy(wConjunto,0,wPosicao-1));
               wConjunto := Trim(Copy(wConjunto,wPosicao+1,120));
            End
         Else
            Begin
               wAux      := Trim(wConjunto);
               wConjunto := '';
            End;

         If wAux <> '' Then
            Begin
               Alfabeto.Append;
               AlfabetoALFABETO.AsString := wAux;
               Alfabeto.Post;
            End;
      End;

   Estado.First;
   While Not Estado.Eof Do
      Begin
         Transicao.First;
         While not Transicao.Eof Do
            Begin
               If (EstadoESTADO.AsString = TransicaoESTADO.AsString) Or (EstadoESTADO.AsString = TransicaoPROXESTADO.AsString) Then
                  Begin
                     Estado.Edit;
                     EstadoUSADO.AsString := 'S';
                     Estado.Post;
                  End;
               Transicao.Next;
            End;
         Estado.Next;
      End;

   wConjunto := '';
   Estado.First;
   While Not Estado.Eof Do
      Begin
         If (EstadoUSADO.AsString = 'N') Then
            Begin
               If wConjunto = '' Then
                  wConjunto := EstadoESTADO.AsString
               Else
                  wConjunto := wConjunto + ',' + EstadoESTADO.AsString;
            End;
         Estado.Next;
      End;

   If wConjunto <> '' Then
      Begin
         MessageDlg('Existe Estados que não estão sendo utilizados !!!' + #13#10 +'Estados: ' + wConjunto, MtInformation, [mbok],0);
         TxtEstados.Font.Color := ClRed;
      End;

   Transicao.First;
   while not transicao.Eof Do
      Begin
         wLinguagem := False;
         Alfabeto.First;
         while not Alfabeto.Eof Do
            Begin
               If TransicaoVALOR.AsString = AlfabetoALFABETO.AsString Then
                  wLinguagem :=  True;
               Alfabeto.Next;
            End;

         If Not wLinguagem Then
            Begin
               MessageDlg('Existe Transições que não possuem Linguagens !!!' + #13#10 + 'Linguagem: ' + TransicaoVALOR.AsString, MtInformation, [mbok],0);
               TxtTransicao.SetFocus;
               Exit;
            End;
         Transicao.Next;
      End;
end;

procedure TForm1.TxtTransicaoKeyPress(Sender: TObject; var Key: Char);
begin
   Key := UpCase(Key);
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
   WAFN    : String;
   wEstado : String;
   wValor  : String;
begin
   If (Estado.Eof) And (Estado.Bof) Then
      Begin
         MessageDlg('Por favor, gere o automato antes de teste-lo', MtInformation, [mbok],0);
         Button1.SetFocus;
         Abort;
      End;

   wAFN := 'N';
   wEstado := '';
   wValor := '';

   Transicao.First;
   With Transicao Do
      Begin
         While not eof Do
            Begin
               If (westado = '') or (wEstado = TransicaoESTADO.AsString) Then
                  Begin
                     wEstado := TransicaoESTADO.AsString;
                     If (wValor = TransicaoVALOR.AsString) Then
                        wAFN := 'S';
                     wValor := TransicaoVALOR.AsString;
                  End
               Else
                  Begin
                     wEstado := TransicaoESTADO.AsString;
                     wValor  := TransicaoVALOR.AsString;
                  End;
               Next;
            End;
      End;

   If wAFN = 'S' Then
      TxtSaida.Lines.Add('O Automato informado é um AFN')
   Else
      TxtSaida.Lines.Add('O Automato informado é um AFD');
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
   wInicial : String;
begin
   If (Estado.Eof) And (Estado.Bof) Then
      Begin
         MessageDlg('Por favor, gere o automato antes de teste-lo', MtInformation, [mbok],0);
         Button1.SetFocus;
         Abort;
      End
   Else If TxtPalavra.Text = '' Then
      Begin
         MessageDlg('O Campo de Palavra está em Branco !!!' + #13#10 + 'Favor Verificar.', MtInformation, [mbok],0);
         TxtPalavra.SetFocus;
         Abort;
      End;

   wVerifica := False;
   wInicial := BuscaEstadoInicial;
   BackTrack(wInicial,TxtPalavra.Text,1);

   If wVerifica = True Then
      TxtSaida.Lines.Add('A Palavra: ' + TxtPalavra.Text + ' pertence ao Automato')
   Else
      TxtSaida.Lines.Add('A Palavra: ' + TxtPalavra.Text + ' Não pertence ao Automato');
end;

//Funcao que retorna o estado inicial
function TForm1.BuscaEstadoInicial: string;
begin
   Result := '';
   Estado.First;

   While not Estado.Eof Do
      Begin
         If EstadoINICIAL.AsString = 'S' Then
            Begin
               Result := EstadoESTADO.AsString;
               Exit;
            End;
         Estado.Next;
      End;
end;

function TForm1.BuscaEstadoFinal(EstadoParam:String): Boolean;
begin
   Result := False;
   Estado.First;
   While not Estado.Eof Do
      Begin
         If (EstadoFINAL.AsString = 'S') And (EstadoESTADO.AsString =  EstadoParam) Then
            Begin
               Result := True;
               Exit;
            End;
         Estado.Next;
      End;
end;

function TForm1.VerificaQtdeCaminho(Estado:String;Alfabeto:String):Integer;
var
   Cont:Integer;
Begin
   Cont := 0;
   Transicao.First;
   While Not Transicao.Eof Do
      Begin
         If (TransicaoESTADO.AsString = Estado) And (TransicaoVALOR.AsString = Alfabeto) Then
            Inc(Cont);
         Transicao.Next;
      End;
   Result := Cont;
End;

function TForm1.ProximoEstado(Estado:String;Alfabeto:String;Seq:Integer):String;
var
   Cont:Integer;
Begin
   Cont := 0;
   Transicao.First;
   While Not Transicao.Eof Do
      Begin
         If (TransicaoESTADO.AsString = Estado) And (TransicaoVALOR.AsString = Alfabeto)Then
            Inc(Cont);

         If (Seq = Cont) Then
            Begin
               Result := TransicaoPROXESTADO.AsString;
               Exit;
            End;

         Transicao.Next;
      End;
End;


Function TForm1.BackTrack(Estado:String;Palavra:String;Posicao:Integer):Boolean;
var
   wCaminho       : Integer;
   wCont          : Integer;
   wAcabo         : Boolean;
   wProximoEstado : String;
Begin
   wAcabo   := False;
   wCont    := 0;
   wCaminho := VerificaQtdeCaminho(Estado,Palavra[Posicao]);
   If (Estado <> '') Then
      Begin
         If (Length(Palavra) < Posicao) and (BuscaEstadoFinal(Estado)=True) Then
            Result := True
         Else
            Begin
               For wCont := 1 to wCaminho Do
                  Begin
                     wProximoEstado := ProximoEstado(Estado,Palavra[Posicao],wCont);
                     wAcabo         := BackTrack(wProximoEstado,Palavra,Posicao+1);
                     If (wAcabo) Then
                        wVerifica := True
                  End;
            End;
      End
   Else
      Result := False;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   If Button4.Caption = '>' Then
      Begin
         Button4.Caption := '<';
         Button4.Left    := 972;
         Form1.Width     := 990;
         Form1.Position  := poScreenCenter;
      End
   Else
      Begin
         Button4.Caption := '>';
         Button4.Left    := 579;
         Form1.Width     := 597;
         Form1.Position  := poScreenCenter;
      End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Button4.Caption := '>';
   Button4.Left    := 579;
   Form1.Width     := 597;
end;

procedure TForm1.TxtAlfabetoEnter(Sender: TObject);
begin
   If TxtAlfabeto.Text = 'U,N,I,R,P          ' Then
      Begin
         TxtAlfabeto.Font.Color := clNavy;
         TxtAlfabeto.Text := '';
      End;
end;

procedure TForm1.TxtAlfabetoExit(Sender: TObject);
begin
   If TxtAlfabeto.Text = '' Then
      Begin
         TxtAlfabeto.Font.Color := clSilver;
         TxtAlfabeto.Text := '';
         TxtAlfabeto.Text := 'U,N,I,R,P          ';
      End;
end;

procedure TForm1.TxtEstadosEnter(Sender: TObject);
begin
   If TxtEstados.Text = 'Q0,Q1,Q2,Q3,Q4,Q5          ' Then
      Begin
         TxtEstados.Font.Color := clNavy;
         TxtEstados.Text := '';
      End;
end;

procedure TForm1.TxtEstadosExit(Sender: TObject);
begin
   If TxtEstados.Text = '' Then
      Begin
         TxtEstados.Font.Color := clSilver;
         TxtEstados.Text := 'Q0,Q1,Q2,Q3,Q4,Q5          ';
      End
   Else
      TxtEstados.Font.Color := clNavy;
end;

procedure TForm1.TxtInicialEnter(Sender: TObject);
begin
   If TxtInicial.Text = 'Q0          ' Then
      Begin
         TxtInicial.Font.Color := clNavy;
         TxtInicial.Text := '';
      End;
end;

procedure TForm1.TxtInicialExit(Sender: TObject);
begin
   If TxtInicial.Text = '' Then
      Begin
         TxtInicial.Font.Color := clSilver;
         TxtInicial.Text := 'Q0          ';
      End;   
end;

procedure TForm1.TxtFinalEnter(Sender: TObject);
begin
   If TxtFinal.Text = 'Q5          ' Then
      Begin
         TxtFinal.Font.Color := clNavy;
         TxtFinal.Text := '';
      End;
end;

procedure TForm1.TxtFinalExit(Sender: TObject);
begin
   If TxtFinal.Text = '' Then
      Begin
         TxtFinal.Font.Color := clSilver;
         TxtFinal.Text := 'Q5          ';
      End;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   GroupBox1.SetFocus;
end;

end.











