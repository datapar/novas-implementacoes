unit UMain;

interface

uses
  Datapar.Context,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SynEdit, SynMemo,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutContainer, dxLayoutControl, FireDAC.Phys.OracleDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.Oracle, Vcl.Grids, Vcl.DBGrids, Data.DB;

type
  Tfmain = class(TForm)
    SynMemo1: TSynMemo;
    Button1: TButton;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    btnBuildLayout: TButton;
    dxLayoutControl1Item1: TdxLayoutItem;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    Button2: TButton;
    Button3: TButton;
    procedure btnBuildLayoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
  public
    ctx: TDataparContext;
  end;

var
  fmain: Tfmain;

implementation

{$R *.dfm}

uses
  ULayoutControlHelper, Geral.Model,
  UAttributes.Rtti, Rtti, UAttributes,
  UConfigGeral;

procedure Tfmain.btnBuildLayoutClick(Sender: TObject);
begin
  dxLayoutControl1.
      Builder().
      AddConfig(TConfigGeral).
      //AddConfig(TConfigFatura).
      //AddConfig(TConfigFinanc).
      AddSeparator().

      AddConfig(TConfigGeral).
      AddSeparator().

      AddConfig(TConfigGeral).

      Generate().
      Free()
  ;
end;

procedure Tfmain.Button1Click(Sender: TObject);
begin
  //
end;

procedure Tfmain.Button2Click(Sender: TObject);
begin
  dxLayoutControl1.Customization:= True;
//  dxLayoutControl1.OnCustomization
end;

procedure Tfmain.Button3Click(Sender: TObject);
begin
  //aurelius
//...
end;

procedure Tfmain.FormCreate(Sender: TObject);
var
  cfg: TSQLCFGGERA;
begin
  ctx:= TDataparContext.Create(Self, 'Ora?Server=oracle-desenv-10g.vm.datapar.com', 'oracle-desenv-10g.vm.datapar.com', 'agtpy', 'superagtpy');

  cfg:= ctx.Get<TSQLCFGGERA>(28);
  caption:= cfg.CEMPRCFG;
end;

end.
