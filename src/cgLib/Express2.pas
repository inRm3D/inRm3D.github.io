unit Express;
{$codepage utf8}
{$F+}
{$IFDEF WIN32}
{$H-}
{$ENDIF}
interface
uses
  SysUtils,  Classes, Pars, parsglb; // , WinTypes  StrUtils, Dialogs, 
type
  TExpressEvaluator= function(x,y,z:extended; var fError:boolean):extended of object;
  eExpressError= class(Exception);
  {Is raised whenever the expression assigned is invalid.}
  TExpress = class(TComponent)
  private
    fParse :PParse;
    fParList :TParString;
    fVarList :TVarString;
    fParValues :TParValues;
    fExpression :string;
    fTheFunction :TExpressEvaluator;
    procedure SetExpression(expr:string);
    function fDummy(x,y,z:extended; var fError:boolean):extended;
    function fTheRealThing(x,y,z:extended; var fError:boolean):extended;
  public
    fError :boolean;
    property Error:boolean read fError;
    {read the value of Error to check whether the current expression has valid syntax}
    property TheFunction:TExpressEvaluator read fTheFunction;
    constructor create(AOwner:TComponent); override;
    destructor destroy; override;
    {Call TheFunction to evaluate the current expression. Before you make
    any calls to TheFunction, check that the expression has valid syntax
    (->Error). If you call TheFunction for an invalid expression you get
    a GPF}
    procedure SetParameters(p1,p2,p3,p4,p5,p6,p7,p8,p9, p10,p11,p12,p13,p14,p15,p16,p17,p18 :extended);
    {Set parameter values for the available 6 parameters -> SyntaxText property}
  published
    property Expression:string read fExpression write SetExpression;
    {Expression is the string to be evaluated. For syntax -> SyntaxText property}
    property VariableList:TVarString read fVarList write fVarList;
    {String containing the characters for the 3 possible variables}
    property ParameterList:TParString read fParList write fParList;
    {String containing the characters for the 6 possible parameters}
  end;
procedure Register;

implementation
uses inRm3Dunit;

function RightStr(const AText: AnsiString; const ACount: Integer): AnsiString; overload;
begin
  Result := Copy(WideString(AText), Length(WideString(AText)) + 1 - ACount, ACount);
end;
function LeftStr(const AText: AnsiString; const ACount: Integer): AnsiString; overload;
begin
  Result := Copy(WideString(AText), 1, ACount);
end;

procedure Register;
begin
  RegisterComponents(' inRm3D ', [TExpress]);
end;

constructor TExpress.Create;
var i:integer;
begin
  inherited create(aowner);
  fparse:=nil;
  fVarList:='xyz';    //变量
  fParList:='abcdefghijklmnopqr'; //常数
  for i:=1 to 18 do fParValues[i]:=1;
  fExpression:='';
  fTheFunction:=fDummy;
end;

procedure TExpress.SetExpression(expr:string);
begin
  if expr[1]='#'then begin //替换变量符号
    case expr[2] of
      '1':fVarList:= 'uvt'; //参数表达式首部字符为“#1”
      '2':fVarList:= 'mnt'; //球面
      '3':fVarList:= 'mrt'; //柱面
      '4':fVarList:= 'tuv'; //x,y,z=F(t) 或 r,m,n=F(t) 曲线的参数方程 %
      '5':fVarList:= 'trz'; //极坐标隐函数曲线
      '6':fVarList:= 'mnr'; //球坐标隐函数曲面
      '7':fVarList:= 'mrz'; //柱坐标隐函数曲面
      end;//case
    expr:= copy( expr,3,Length(expr)-2); //删除表达式首部的“#1”
    end
  else
    fVarList:= 'xyz';   //一般方程
  if fParse<>nil then dispose(fParse,done);
  fParse:=new(pParse, init(expr,fVarlist,fParList,fError));
  if fError then begin
    dispose( fParse, done);
    fParse:=nil;
    fThefunction:= fDummy;
//    raise eExpressError.Create(' 表达式 '+ expr+ ' 有错！ ');
    end
  else begin
    fParse^.setParams(fParValues);
    fExpression:= expr;
    fThefunction:= fTheRealThing;
    end;
end;

function TExpress.fDummy(x,y,z:extended; var fError:boolean):extended;
begin
  result:=1;
end;

function TExpress.fTheRealThing(x,y,z:extended; var fError:boolean):extended;
begin
  fParse^.f(x,y,z,result, fError);
end;

procedure TExpress.SetParameters;
begin
  if fparse<>nil then
  begin
    fParValues[ 1]:=p1;   fParValues[ 2]:=p2;   fParValues[ 3]:=p3;
    fParValues[ 4]:=p4;   fParValues[ 5]:=p5;   fParValues[ 6]:=p6;
    fParValues[ 7]:=p7;   fParValues[ 8]:=p8;   fParValues[ 9]:=p9;
    fParValues[10]:=p10;  fParValues[11]:=p11;  fParValues[12]:=p12;
    fParValues[13]:=p13;  fParValues[14]:=p14;  fParValues[15]:=p15;
    fParValues[16]:=p16;  fParValues[17]:=p17;  fParValues[18]:=p18;
    fparse^.setparams(fParValues);
  end;
end;

Destructor TExpress.destroy;
begin
  if fparse<>nil then dispose(fparse,done);
  inherited destroy;
end;

end.

