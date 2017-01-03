// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program ReflexAttrib;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {fmain},
  UConfigGeral in 'model\UConfigGeral.pas',
  UAttributes in 'attributes\UAttributes.pas',
  UAttributes.Rtti in 'attributes\UAttributes.Rtti.pas',
  ULayoutControlHelper in 'helper\ULayoutControlHelper.pas',
  Geral.Model in 'model\Geral.Model.pas',
  Datapar.Context in 'repo\Datapar.Context.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfmain, fmain);
  Application.Run;
end.
