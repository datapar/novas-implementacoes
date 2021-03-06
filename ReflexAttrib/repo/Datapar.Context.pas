unit Datapar.Context;

interface

uses
  Classes, DBClient,
  //connection
  SynDBFireDAC, FireDAC.Comp.Client,

  SynCommons, SynLog, SynSQLite3Static, SynDB,
  mORMot,mORMotSQLite3, mORMotDB,
  mORMotMidasVCL;

type
  TDtQuery = TFDQuery;

  TDataparContext = class(TComponent)
  protected
    fExternalDB: TSQLDBConnectionProperties;
    fModel: TSQLModel;
    fServer: TSQLRestServerDB;
    function CreateDataModel(aExternalDB: TSQLDBConnectionProperties): TSQLModel;
    procedure PopulaBase();
  public
//    function GetServerDateTime(): TDateTime;
  public
    property ExternalDB: TSQLDBConnectionProperties read FExternalDB;
    property Model: TSQLModel read FModel;
    property Server: TSQLRestServerDB read FServer;

    procedure StartTransaction();
    procedure Commit();
    procedure Rollback();

    function Update(ARec: TSQLRecord): boolean;
    function Add(ARec: TSQLRecord): TID;
    function Delete(ARec: TSQLRecord): boolean;

    constructor Create(AOwner: TComponent; const aServerName, aDatabaseName, aUserID, aPassWord: String); reintroduce;
    destructor Destroy(); override;

    function CreateQuery(pSql: string): TDtQuery;
  end;


  TDataparContextHelper = class helper for TDataparContext
    function GetTable(AClass: TSQLRecordClass; Str:string; const BoundsSQLWhere: array of const): TSQLTable;

    function Get<T: TSQLRecord, constructor>(AID: TID): T;
  end;

  TSQLRecordHelper = class helper for TSQLRecord
    function ToClientDataSet(AOwner: TComponent): TClientDataSet;
  end;


implementation

uses
  //Financ.Model, Contabil.Model, Geral.Model, Titulos.Model
  Geral.Model
  ;

constructor TDataparContext.Create(AOwner: TComponent; const aServerName, aDatabaseName, aUserID, aPassWord: String);
begin
  inherited Create(AOwner);

  // set logging abilities
  SQLite3Log.Family.Level := [sllError];
  //SQLite3Log.Family.EchoToConsole := LOG_VERBOSE;
  SQLite3Log.Family.PerThreadLog := ptIdentifiedInOnFile;

  fExternalDB := TSQLDBFireDACConnectionProperties.Create(aServerName, aDatabaseName, aUserID, aPassWord);
  // get the shared data model
  fModel := CreateDataModel(fExternalDB);
  try
    fServer := TSQLRestServerDB.Create(fModel);
    try // MySQL uses one fork per connection -> better only two threads
      fServer.AcquireExecutionMode[execORMGet] := amBackgroundThread;
      fServer.AcquireExecutionMode[execORMWrite] := amBackgroundThread;
      fServer.DB.UseCache:= false;//desativa o cache

      //Cria tabelas e indices faltantes
//      fServer.CreateMissingTables(0, [itoNoAutoCreateGroups, itoNoAutoCreateUsers, itoNoCreateMissingField]);
      //s� registra nao cria nada
      fServer.CreateMissingTables(0, [itoNoIndex4RecordReference,
        itoNoAutoCreateGroups, itoNoAutoCreateUsers, itoNoCreateMissingField,
        itoNoIndex4ID, itoNoIndex4UniqueField, itoNoIndex4NestedRecord, itoNoIndex4RecordReference,
        itoNoIndex4TID, itoNoIndex4RecordVersion]);

      //popula base...
      PopulaBase();
    finally
    end;
  finally
  end;
end;

destructor TDataparContext.Destroy();
begin
  fServer.Free();
  fModel.Free();
  fExternalDB.Free();
  inherited Destroy();
end;

function TDataparContext.CreateQuery(pSql: string): TDtQuery;
begin
  Result:= TDtQuery.Create(Self);
  TDtQuery(Result).Connection:= TSQLDBFireDacConnection(ExternalDB.MainConnection ).Database;
  TDtQuery(Result).SQL.Text:= pSql;
end;

const
  SERVER_ROOT = 'subsee';

function TDataparContext.CreateDataModel(aExternalDB: TSQLDBConnectionProperties): TSQLModel;
begin
  //cria modelo... melhorar referencias deps...
  result:=
    TSQLModel.Create(
       //registro de tabelas /  mapeamento
       [
         TSQLCFGGERA
        ]
    ,SERVER_ROOT);

  VirtualTableExternalRegisterAll(result, aExternalDB);

  //add Map and Filters...
  //TPerson...AddFilterOrValidate('Name',TSynValidateText.Create); // ensure exists
  //TSQLplano_contas
  result.Props[TSQLCFGGERA].ExternalDB.MapField('ID', 'NCODCCFG').SetOptions([rpmNoCreateMissingTable, rpmNoCreateMissingField]) ;

end;

procedure TDataparContext.PopulaBase();
begin
  StartTransaction();
  try
//    Financ.Model.PopulaBase( Self.fServer );
    Commit();
  except
    Rollback();
    raise;
  end;
end;                                   

procedure TDataparContext.Commit;
begin
  ExternalDB.MainConnection.Commit();
  fServer.Commit(1, true);{<<<COMMIT}
end;

procedure TDataparContext.Rollback;
begin
  fServer.RollBack(1);
  ExternalDB.MainConnection.Rollback();
end;

procedure TDataparContext.StartTransaction;
begin
  if fServer.TransactionBegin(TSQLCFGGERA{wa}, 1) then
  begin
    ExternalDB.MainConnection.StartTransaction();
  end;
end;

function TDataparContext.Update(ARec: TSQLRecord): boolean;
begin
  Result:= Server.Update( ARec, ARec.RecordProps.CopiableFieldsBits );{update}
end;

function TDataparContext.Add(ARec: TSQLRecord): TID;
begin
  Result:= Server.Add( ARec, True );{Add}
end;

function TDataparContext.Delete(ARec: TSQLRecord): boolean;
begin
  Result:= Server.Delete( TSQLRecordClass(ARec.ClassType), ARec.ID );{Delete}
end;

//************************************************************/

function TDataparContextHelper.Get<T>(AID: TID): T;
begin
  Result:= TSQLRecordClass(T).Create(Self.Server, AID) as T;
end;
//
//function TDataparContextHelper.Get<T>(): IQueriable<T>;
//begin
//  Result:= TSQLRecordClass(T).Create(Self.Server, AID) as T;
//end;

//function TDataparContextHelper.Get<T>(AID: TID): IQueT;
//begin                                                //
//  Result:= TSQLRecord(T).Create(Self.Server, AID);       fluent api missing
//end;

function TDataparContextHelper.GetTable(AClass: TSQLRecordClass; Str:string; const BoundsSQLWhere: array of const): TSQLTable;
begin
  with AClass.CreateAndFillPrepare(Self.Server, Str, BoundsSQLWhere) do
  begin
    Result:= FillTable;
  end;
  //to object list
end;


//**************************************************************/
function TSQLRecordHelper.ToClientDataSet(AOwner: TComponent): TClientDataSet;
var
  t: TSQLTable;
begin
  t:= Self.FillTable;
  Result:= mORMotMidasVCL.ToClientDataSet(AOwner, t );
  t.Free();
end;

end.
