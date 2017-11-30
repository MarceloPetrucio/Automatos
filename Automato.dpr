program Automato;

uses
  Forms,
  UAutomato in 'UAutomato.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := 'Programa para ler Automatos';
  Application.Title := 'Automato';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.       
