unit Build;
{$F+}
{$IFDEF WIN32}
{$H-}
{$ENDIF}
interface
uses sysUtils,parsglb;

procedure ParseFunction(ss:string;varString:TVarString;parString:TParString;
            var fop:OperationPointer;
            var point:TVarPoints;
            var par:TParPoints;
            var numop:integer;
            var error:boolean);
implementation
uses inRm3Dunit;

type
  TTermKind=(variab,constant,param,brack,minus, sum,diff,prod,divis,intpower,
             realpower,cosine,sine,expo,logar, sqroot,arctang,square,third,forth,
             abso,maxim,minim,heavi,phase, randfunc,argu,hypersine,hypercosine,radius,
             randrand,fraction,less,equal,lessequal, notequal,tangent,hypertangent,arcsine,arccosine,
             sqr,int,sgn,rnd,random,loger,parity, arcsineh,arccosineh,arctangenth, factorial,iif,modulo,truncs);

var TheString:string; TheVar:TVarstring; ThePar:TParstring;

procedure CheckSyntax(i0,j0:byte; var i1,j1,i2,j2,i3,j3:byte;
                      var kind:TTermKind; var num:extended;
                      var varsort,parSort:word; var numVar:byte;
                      var checks:boolean); forward;


procedure ChopBlanks(var s:string);  forward;
{deletes all blanks in s}

{i0, j0 in the following are used to denote a part of TheString.
 under investigation is the string s=copy(TheString,i0,j0). i1, j1 (, i2, j2)
 return the delimiter(s) of the substring(s) corresponding to the operand(s).}
procedure CheckBracketNum(i0,j0:byte; var checks:boolean); forward;
{checks whether there's a ')' for any '('}

procedure CheckNum(i0,j0:byte;var num:extended;var checks:boolean); forward;
{checks whether s is a number}

procedure CheckVar(i0,j0:byte; var varsort:word;var checks:boolean); forward;
{checks whether s is a variable character}

procedure CheckParam(i0,j0:byte; var parsort:word;var checks:boolean); forward;
{checks whether s is a parameter character}

procedure CheckBrack(i0,j0:byte; var i1,j1,i2,j2,i3,j3:byte; var kind:TTermKind; var num:extended;
    var varsort,parsort:word; var numvar:byte; var checks:boolean); forward;
{checks whether s =(...(s1)...) and s1 is a valid term}

procedure CheckMin(i0,j0:byte;
      var i1,j1:byte;var checks:boolean); forward;
{checks whether s denotes the negative value of a valid operation}

procedure CheckOperation(i0,j0:byte;
  var i1,j1,i2,j2:byte; var priority:byte;
  var kind:TTermkind; var checks:boolean); forward;
{Checks whether s is a valid expression for an operation +, -, *, /, or ^}

procedure Check1VarFunct(i0,j0:byte;
   var i1,j1:byte;
   var fsort:TTermKind; var checks:boolean); forward;
{checks whether s denotes the evaluation of a function f(s1)}

procedure Check2VarFunct(i0,j0:byte;
   var i1,j1,i2,j2:byte;
   var fsort:Ttermkind; var checks:boolean);  forward;
{checks whether s=f(s1,s2); s1,s2 being valid terms}

procedure Check3VarFunct(i0,j0:byte;
   var i1,j1,i2,j2,i3,j3:byte;
   var fsort:Ttermkind; var checks:boolean);  forward;
{checks whether s=f(s1,s2,s3); s1,s2,s3 being valid terms}

procedure ChopBlanks(var s:string);
var i:byte;
begin
  while pos(' ',s)>0 do
  begin
    i:=pos(' ',s);
    delete(s,i,1);
  end;
end;
//检测括弧
procedure CheckBracketNum(i0,j0:byte; var checks:boolean);
var lauf,lzu,i:integer;
begin
  lauf:=0;  lzu:=0; i:=i0-1;
  checks:=false;
  repeat
    inc(i);
    if TheString[i]='(' then inc(lauf);
    if TheString[i]=')' then inc(lzu);
    if lzu>lauf then exit;
  until i>=i0+j0-1;
  if lauf=lzu then checks:=true;
end;
//检测句法
procedure CheckSyntax(i0,j0:byte; var i1,j1,i2,j2,i3,j3:byte;
              var Kind:tTermKind; var Num:extended;
              var VarSort,ParSort:word; var NumVar:byte;
              var checks:boolean);
var priority:byte; //优先级
begin
  checks:=false;
  CheckBracketNum(i0,j0,checks);  //分类检测
  if not checks then exit;
  CheckBrack(i0,j0,i1,j1,i2,j2,i3,j3,Kind,Num,VarSort,ParSort,NumVar,checks); //检测括弧
  if checks then exit;
  NumVar:=0;  Kind:=constant;
  CheckNum(i0,j0,Num,checks); if checks then exit;
  Kind:=variab;
  CheckVar(i0,j0,VarSort,checks); if checks then exit;
  Kind:=param;
  CheckParam(i0,j0,parsort,checks); if checks then exit;
  NumVar:=1;  Kind:=Minus;
  CheckMin(i0,j0,i1,j1,checks); if checks then exit;
  Check1VarFunct(i0,j0,i1,j1,Kind,checks); if checks then exit;
  NumVar:=2;
  CheckOperation(i0,j0,i1,j1,i2,j2,Priority,Kind,checks); if checks then exit;
  Check2VarFunct(i0,j0,i1,j1,i2,j2,Kind,checks); if checks then exit;
  NumVar:=3;
  Check3VarFunct(i0,j0,i1,j1,i2,j2,i3,j3,Kind,checks); if checks then exit;

end;

procedure CheckNum(i0,j0:byte;var num:extended;var checks:boolean);
var s,t:string;
begin
  checks:=false;
  t:=copy(theString,i0,j0);
  if (t='Pi') or (t='pi') then
    begin checks:=true; num:=Pi; exit; end
  else
    if (t='Ei') or (t='ei') then
      begin checks:=true; num:=2.718282; exit; end
  else begin
    s:=t + #0;
    {$IFDEF WIN32}
    checks:=TextToFloat(@s[1],num,fvExtended);
    {$ELSE}
    checks:=TextToFloat(@s[1],num);
    {$ENDIF}
    end;
end;

procedure CheckParam(i0,j0:byte; var parsort:word; var checks:boolean);
var i:byte;
begin
  checks:=false;
  if j0<>1 then exit else
  begin
    for i:=1 to 18 do
    if theString[i0]=thePar[i] then
      begin checks:=true; parsort:=i; exit; end;
  end;
end;


procedure CheckVar(i0,j0:byte;var varsort:word;var checks:boolean);
var i:byte;
begin
  checks:=false;
  if j0<>1 then exit else
  begin
    for i:=1 to 3 do
    if theString[i0]=theVar[i] then
    begin
      checks:=true;
      varsort:=i;
      exit;
    end;
  end;
end;

procedure CheckBrack(i0,j0:byte; var i1,j1,i2,j2,i3,j3:byte;
            var Kind:tTermKind; var Num:extended;
            var varSort,parSort:word; var NumVar:byte; var checks:boolean);
begin
  checks:=false;
  if theString[i0]='(' then
  if theString[i0+j0-1]=')' then
  begin
    CheckSyntax(i0+1,j0-2,i1,j1,i2,j2,i3,j3,kind,num,varsort,parsort,numvar,checks);
  end;
end;

procedure CheckMin(i0,j0:byte; var i1,j1:byte; var checks:boolean);
var Num :extended;   fSort :tTermKind;
    i2,j2,i3,j3,i4,j4, NumVar,priority :byte;
    varSort,parSort :word;
begin
  checks:=false;
  if theString[i0]='-' then
  begin
    i1:=i0+1; j1:=j0-1;
    checkBrack(i1,j1,i2,j2,i3,j3,i3,j3,fsort,num,varsort,parsort,numvar,checks);
    if checks then begin i1:=i1+1; j1:=j1-2; exit; end;
    checkVar(i1,j1,varSort,checks); if checks then exit;
    checkParam(i1,j1,varSort,checks); if checks then exit;
    check1VarFunct(i1,j1,i2,j2,fSort,checks); if checks then exit;
    check2Varfunct(i1,j1,i2,j2,i3,j3,fSort,checks); if checks then exit;

    check3Varfunct(i1,j1,i2,j2,i3,j3,i4,j4,fSort,checks); if checks then exit;
    checkNum(i1,j1,num,checks); if checks then exit;
    checkOperation(i1,j1,i2,j2,i3,j3,priority,fsort,checks);
    checks:=checks and (priority>=2);
  end;
end;

procedure CheckOperation(i0,j0:byte;
                         var i1,j1,i2,j2:byte; var priority:byte;
                         var kind:TTermKind;  var checks:boolean);
var i3,j3,i4,j4,i5,j5,i,j, Prior,numVar :byte;
    Num:extended;
    fSort :TTermKind;
    varSort,parSort :word;
    che:boolean; Op :char;
begin
  checks:=false;
  i:=i0-1; 
  repeat
    j:=i;
    repeat
      inc(j);
    until (thestring[j] in ['+','-','*','/','^']) or (j>i0+j0-1);
    if j>i0+j0-1 then exit;
    i:=j;
    op:=thestring[i];
    case op of
      '+','-': priority:=1;
      '*','/': priority:=2;
      '^':priority:=3;
    end;
    i1:=i0; j1:=i-i0; i2:=i+1; j2:=i0+j0-1-i;
    if j1>0 then if j2>0 then begin
      checkBracketNum(i1,j1,checks);
      if checks then checkBracketNum(i2,j2,checks);
      if checks then begin
        checkVar(i1,j1,varsort,checks);
        if not checks then checkNum(i1,j1,num,checks);
        if not checks then checkParam(i1,j1,parsort,checks);
        if not checks then checkBrack(i1,j1,i3,j3,i4,j4,i5,j5,kind,num,varsort,parsort,numvar,checks);
        if not checks then begin
          checkMin(i1,j1,i3,j3,checks);
          checks:=checks and (priority < 3);
          end;
        if not checks then begin
          checkOperation(i1,j1,i3,j3,i4,j4,prior,fsort,checks);
          checks:=checks and (prior >=priority);
          end;
        if not checks then check3VarFunct(i1,j1,i3,j3,i4,j4,i5,j5,fsort,checks);
        if not checks then check2VarFunct(i1,j1,i3,j3,i4,j4,fsort,checks);
        if not checks then check1VarFunct(i1,j1,i3,j3,fsort,checks);
        if checks then begin
          checkVar(i2,j2,varsort,checks); if checks then break;
          checkNum(i2,j2,num,checks);if checks then break;
          checkParam(i2,j2,parsort,checks); if checks then break;
          checkBrack(i2,j2,i3,j3,i4,j4,i5,j5,kind,num,varSort,parSort,numVar,checks); if checks then break;
          checkOperation(i2,j2,i3,j3,i4,j4,prior,fsort,checks);
          if checks and (prior>priority) then break;
          check1VarFunct(i2,j2,i3,j3,fsort,checks);if checks then break;
          check2VarFunct(i2,j2,i3,j3,i4,j4,fsort,checks);if checks then break;
          check3VarFunct(i2,j2,i3,j3,i4,j4,i5,j5,fsort,checks);if checks then break;
          end; // if checks
        end; // if checks
      end; //if j1>0 then if j2>0
  until checks or (i>=i0+j0-1) or (j=i0-1);
  if checks then
  case op of
    '+':kind:=sum;
    '-':kind:=diff;
    '*':kind:=prod;
    '/':kind:=divis;
    '^':begin
          kind:=realpower;
          checkNum(i2,j2,num,che);
          if che then
          if trunc(num)=num then begin
            case trunc(num) of
              2:kind:=square;
              3:kind:=third;
              4:kind:=forth;
              else kind:=intPower; end;
            end
          else begin
            checkbrack(i2,j2,i3,j3,i4,j4,i5,j5,kind,num,varSort,parSort,numVar,che);
            if che then begin
              checknum(i2+1,j2-2,num,che);
              if che then if trunc(num)=num then begin
                case trunc(num) of
                  2: kind:=square;
                  3: kind:=third;
                  4: kind:=forth;
                else  kind:=intPower; end;
                end;
            end;
          end;
        end;
    end; {case}
end;
//三参函数
procedure Check3VarFunct(i0,j0:byte;var i1,j1,i2,j2,i3,j3:byte;var fSort:tTermKind;var checks:boolean);
  var num:extended; parSort,varSort:word; numVar:byte;
  procedure CheckComma(i0,j0:byte; var i1,j1,i2,j2:byte; var checks:boolean);
    var i4,j4,i5,j5:byte; i,j:integer;
  begin
    checks:=false;
    i:=i0-1;
    repeat
      j:=pos(',',copy(theString,i+1,j0-(i-i0+1)));
      if j>0 then begin
        i:=i+j;
        if (i<i0+j0-1) and (i>i0) then begin
          i1:=i0; j1:=i-i0; i2:=i+1; j2:=i0+j0-1-i;  i3:=i+2; j3:=i0+j0-1-i;
          CheckSyntax(i1,j1,i4,j4,i5,j5,i5,j5,fSort,Num,varSort,parSort,numVar,checks);
          if checks then
          CheckSyntax(i2,j2,i4,j4,i5,j5,i5,j5,fSort,Num,varSort,parSort,numVar,checks);
          if checks then
          CheckSyntax(i3,i3,j4,j4,i5,j5,i5,j5,fSort,Num,varSort,parSort,numVar,checks);
          end;
        end;
    until checks or (i>=i0+j0-1) or (j=0);
    end;
begin
  checks:=false;
  TheString:= lowerCase(TheString);
  if copy(theString,i0,3)='iif' then begin
    if (theString[i0+3]='(') and (theString[i0+j0-1]=')') then
      CheckComma(i0+4,j0-5,i1,j1,i2,j2,checks);
    if checks then begin fSort:=iif; exit; end;
    end;
end;
//双参函数
procedure Check2VarFunct(i0,j0:byte;var i1,j1,i2,j2:byte;var fsort:tTermKind;var checks:boolean);
  var Num:extended; ParSort,VarSort:word; NumVar:byte;
  procedure CheckComma(i0,j0:byte; var i1,j1,i2,j2:byte; var checks:boolean);
    var i3,j3,i4,j4:byte; i,j:integer;
  begin
    checks:=false;
    i:=i0-1;
    repeat
      j:=pos(',',copy(theString,i+1,j0-(i-i0+1)));
      if j>0 then begin
        i:=i+j;
        if (i<i0+j0-1) and (i>i0) then begin
          i1:=i0; j1:=i-i0; i2:=i+1; j2:=i0+j0-1-i;
          CheckSyntax(i1,j1,i3,j3,i4,j4,i4,j4,fSort,Num,VarSort,ParSort,NumVar,checks);
          if checks then
          CheckSyntax(i2,j2,i3,j3,i4,j4,i4,j4,fSort,Num,VarSort,ParSort,NumVar,checks);
          end;
        end;
    until checks or (i>=i0+j0-1) or (j=0);
    end;
begin
  checks:=false;
  TheString:= lowerCase(TheString);
  if copy(theString,i0,3)='min' then begin
    if (theString[i0+3]='(') and (theString[i0+j0-1]=')') then
      CheckComma(i0+4,j0-5,i1,j1,i2,j2,checks);
    if checks then begin fsort:=minim; exit; end;
    end;
  if copy(theString,i0,3)='max' then begin
    if (theString[i0+3]='(') and (theString[i0+j0-1]=')') then
      CheckComma(i0+4,j0-5,i1,j1,i2,j2,checks);
    if checks then begin fsort:=maxim; exit; end;
    end;
  if copy(theString,i0,2)='rn' then begin
    if (theString[i0+2]='(') and (theString[i0+j0-1]=')') then
      CheckComma(i0+3,j0-4,i1,j1,i2,j2,checks);
    if checks then begin fsort:=randfunc; exit; end;
    end;
  if copy(theString,i0,3)='arg' then begin
    if (theString[i0+3]='(') and (theString[i0+j0-1]=')') then
      CheckComma(i0+4,j0-5,i1,j1,i2,j2,checks);
    if checks then begin fsort:=argu; exit; end;
    end;
  if copy(thestring,i0,3)='rad' then begin
    if (thestring[i0+3]='(') and (thestring[i0+j0-1]=')') then
      CheckComma(i0+4,j0-5,i1,j1,i2,j2,checks);
    if checks then begin fsort:=radius;exit; end;
    end;
  if copy(theString,i0,2)='rm' then begin
    if (theString[i0+2]='(') and (theString[i0+j0-1]=')') then
      CheckComma(i0+3,j0-4,i1,j1,i2,j2,checks);
    if checks then begin fsort:=randrand; exit; end;
    end;
  if copy(theString,i0,5)='equal' then begin
    if (theString[i0+5]='(') and (theString[i0+j0-1]=')') then begin
      CheckComma(i0+6,j0-7,i1,j1,i2,j2,checks);
      if checks then begin fsort:=Equal; exit; end;
      end;
    end;
  if copy(theString,i0,4)='less' then begin
    if (theString[i0+4]='(') and (theString[i0+j0-1]=')') then
      CheckComma(i0+5,j0-6,i1,j1,i2,j2,checks);
    if checks then begin fsort:=less; exit; end;
    end;
  if copy(theString,i0,5)='lesse' then begin
    if (theString[i0+5]='(') and (theString[i0+j0-1]=')') then begin
      CheckComma(i0+6,j0-7,i1,j1,i2,j2,checks);
      if checks then begin fsort:=LessEqual; exit; end;
      end;
    end;
  if copy(thestring,i0,4)='note' then begin
    if (thestring[i0+4]='(') and (thestring[i0+j0-1]=')') then begin
      CheckComma(i0+5,j0-6,i1,j1,i2,j2,checks);
      if checks then begin fsort:=NotEqual; exit; end;
      end;
    end;
  if copy(thestring,i0,3)='mod' then begin
    if (thestring[i0+3]='(') and (thestring[i0+j0-1]=')') then begin
      CheckComma(i0+4,j0-5,i1,j1,i2,j2,checks);
      if checks then begin fsort:=modulo; exit; end;
      end;
    end;
end;

//单参函数
procedure Check1VarFunct(i0,j0:byte;
  var i1,j1:byte; var fsort:tTermKind; var checks:boolean);
  var num:extended; varsort,parsort:word;  numvar:byte;

  procedure CheckArgument(i0,j0:byte; var i1,j1:byte);
    var i2,j2,i3,j3:byte;
    begin
      CheckBrack(i0,j0,i2,j2,i3,j3,i3,j3,fSort,num,varSort,parSort,numVar,checks);
      if checks then begin i1:=i0+1; j1:=j0-2; end;
    end;

begin
  checks:=false;
  TheString:= lowerCase(TheString);
  if copy(thestring,i0,3)='exp' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=expo; exit; end;
    end;
  if copy(thestring,i0,2)='ln' then begin
    CheckArgument(i0+2,j0-2,i1,j1);
    if checks then begin fsort:=logar; exit; end;
    end;
  if copy(thestring,i0,3)='log' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=loger; exit; end;
    end;
  if copy(thestring,i0,6)='arctan' then begin
    CheckArgument(i0+6,j0-6,i1,j1);
    if checks then begin fsort:=arctang; exit; end;
    end;
  if copy(thestring,i0,4)='sqrt' then begin
    CheckArgument(i0+4,j0-4,i1,j1);
    if checks then begin fsort:=sqroot; exit; end;
    end;
  if copy(thestring,i0,3)='abs' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=abso; exit; end;
    end;
  if copy(thestring,i0,4)='heav' then begin
    CheckArgument(i0+4,j0-4,i1,j1);
    if checks then begin fsort:=heavi; exit; end;
    end;
  if copy(thestring,i0,2)='ph' then begin
    CheckArgument(i0+2,j0-2,i1,j1);
    if checks then begin fsort:=phase; exit; end;
    end;

  if copy(thestring,i0,3)='sin' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=sine; exit; end;
    end;
  if copy(thestring,i0,3)='cos' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=cosine; exit; end;
    end;
  if copy(thestring,i0,3)='tan' then begin
    checkArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=tangent; exit; end;
    end;
  if copy(thestring,i0,4)='sinh' then begin
    CheckArgument(i0+4,j0-4,i1,j1);
    if checks then begin fsort:=hypersine; exit; end;
    end;
  if copy(thestring,i0,4)='cosh' then begin
    CheckArgument(i0+4,j0-4,i1,j1);
    if checks then begin fsort:=hypercosine; exit; end;
    end;
  if copy(thestring,i0,4)='tanh' then begin
    CheckArgument(i0+4,j0-4,i1,j1);
    if checks then begin fsort:=hypertangent; exit; end;
    end;
  if copy(thestring,i0,6)='arcsin' then begin
    CheckArgument(i0+6,j0-6,i1,j1);
    if checks then begin fsort:=arcsine; exit; end;
    end;
  if copy(thestring,i0,6)='arccos' then begin
    CheckArgument(i0+6,j0-6,i1,j1);
    if checks then begin fsort:=arccosine; exit; end;
    end;
  if copy(thestring,i0,7)='arcsinh' then begin
    CheckArgument(i0+7,j0-7,i1,j1);
    if checks then begin fsort:=arcsineh; exit; end;
    end;
  if copy(thestring,i0,7)='arccosh' then begin
    CheckArgument(i0+7,j0-7,i1,j1);
    if checks then begin fsort:=arccosineh; exit; end;
    end;
  if copy(thestring,i0,7)='arctanh' then begin
    CheckArgument(i0+7,j0-7,i1,j1);
    if checks then begin fsort:=arctangenth; exit; end;
    end;

  if copy(thestring,i0,2)='fr' then begin
    CheckArgument(i0+2,j0-2,i1,j1);
    if checks then begin fsort:=fraction; exit; end;
    end;
  if copy(thestring,i0,3)='sqr' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=sqr; exit; end;
    end;
  if copy(thestring,i0,3)='int' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=int; exit; end;
    end;
  if copy(thestring,i0,5)='trunc' then begin
    CheckArgument(i0+5,j0-5,i1,j1);
    if checks then begin fsort:=truncs; exit; end;
    end;
  if copy(thestring,i0,3)='sgn' then begin
    CheckArgument(i0+3,j0-3,i1,j1);
    if checks then begin fsort:=sgn; exit; end;
    end;
  if copy(thestring,i0,5)='round' then begin
    CheckArgument(i0+5,j0-5,i1,j1);
    if checks then begin fsort:=rnd; exit; end;
    end;
  if copy(thestring,i0,6)='random' then begin
    CheckArgument(i0+6,j0-6,i1,j1);
    if checks then begin fsort:=random; exit; end;
    end;
  if copy(thestring,i0,6)='parity' then begin
    CheckArgument(i0+6,j0-6,i1,j1);
    if checks then begin fsort:=parity; exit; end;
    end;
  if copy(thestring,i0,4)='fact' then begin
    CheckArgument(i0+4,j0-4,i1,j1);
    if checks then begin fsort:=factorial; exit; end;
    end;

end;


const maxlevels=30;  maxlevelsize=52;
type
   termpointer=^termrec;
   termrec=record
           i0,j0,i1,j1,i2,j2:byte;
           termkind:ttermkind;
           numvar:byte;
           posit:array[1..3] of integer;
           next1,next2,prev:termpointer
           end;
   LevelSizeArray=array[0..maxlevels] of integer;

procedure ini(var theop:operationpointer;term:ttermkind);
begin
  new(theop);
  with theop^ do begin
    arg1:=nil; arg2:=nil; arg3:=nil; dest:=nil; next:=nil;
    opnum:=ord(term);
    end;
end;

procedure ParseFunction(ss:string; varString:TVarString; ParString:TParString;
            var fop:OperationPointer; var point:TVarPoints; var par:TParPoints;
            var numop:integer; var error:boolean);

var checks,done,predone,found :boolean;
    i3,j3,i4,j4,i5,j5, Numv :byte;
    l,i,j, Levels,p,Code :integer;
    varSort,parSort:word;
    Num :extended;
    ab,LevelSize :LevelSizeArray;
    FirstTerm,Next1Term,Next2Term,LastTerm :TermPointer;
    Kind :TTermkind;
    Matrix:array[0..maxLevels,1..maxLevelsize] of OperationPointer;
    LastOp :OperationPointer;
begin
  LastOp:=nil;
  for i:=1 to  3 do point[i]:=nil;
  for i:=1 to 18 do par[i]:=nil;
  fop:=nil;
  error:=false;
  theString:=ss;
  theVar:=varString; thePar:=parString;
  ChopBlanks(theString);  //清理空格符
  CheckSyntax(1,Length(theString),i3,j3,i4,j4,i5,j5, Kind,Num,varSort,parSort,Numv, checks);
  if not checks then begin error:=true; exit; end;
  for i:=1 to  3 do new(point[i]);
  for i:=1 to 18 do new(par[i]);
  done:=false;
  Levels:=0;
  Levelsize[0]:=1;
  for l:=0 to maxLevels do ab[l]:=0;
  new(firstterm);
  FirstTerm^.i0:=1; FirstTerm^.j0:=Length(theString);
  with firstterm^ do begin
    i1:=1; j1:=1; i2:=1; j2:=1; i3:=1; j3:=1; i4:=1; j4:=1; TermKind:=variab; numVar:=0;
    next1:=nil; next2:=nil; prev:=nil;
    new(matrix[0,1]);
    with matrix[0,1]^ do begin
      arg1:=nil; arg2:=nil; arg3:=nil; dest:=nil;
      opNum:=ord(variab); next:=nil;
      end;
    end;
  lastTerm:=firstTerm;
  lastTerm^.posit[1]:=0;
  lastTerm^.posit[2]:=1;
  lastTerm^.posit[3]:=1;
  repeat
    predone:=false;
    repeat
      l:=lastTerm^.posit[1];
      i:=lastTerm^.posit[2];
      j:=lastTerm^.posit[3];
      if lastTerm^.next1=nil then
      with lastterm^ do
      begin
        checkSyntax(i0,j0,i1,j1,i2,j2,i3,j3,TermKind,num,varSort,parSort,numVar,checks);
        if checks then
        begin
          case TermKind of
            variab: case posit[3] of
                      1: matrix[l,i]^.arg1:=point[varsort];
                      2: matrix[l,i]^.arg2:=point[varsort];
                      3: matrix[l,i]^.arg3:=point[varsort];
                    end;
             param: case posit[3] of
                      1: matrix[l,i]^.arg1:=par[parsort];
                      2: matrix[l,i]^.arg2:=par[parsort];
                      3: matrix[l,i]^.arg3:=par[parsort];
                    end;
           constant:case posit[3] of
                      1:begin new(matrix[l,i]^.arg1);  matrix[l,i]^.arg1^:=num; end;
                      2:begin new(matrix[l,i]^.arg2);  matrix[l,i]^.arg2^:=num; end;
                      3:begin new(matrix[l,i]^.arg3);  matrix[l,i]^.arg3^:=num; end;
                    end;
           randfunc:begin
                      val(copy(thestring,i1,j1),num,code);
                      randomsize:=round(num);
                      randomiterates:=true;
                      randomize;
                    end;
           randrand:begin
                      contrand:=true;
                      randomize;
                    end;
          end; {case}
        end; {if checks}
      end; {with lastterm^}
      if lastterm^.numvar=1 then begin
        new(next1term);
        l:=l+1;
        if l>maxLevels then begin error:=true; exit;end;
        if levels<l then levels:=l;
        i:=ab[l]+1;
        if i>maxLevelSize then begin error:=true; exit; end;
        with next1term^ do begin
          i0:=lastTerm^.i1;
          j0:=lastTerm^.j1;
          prev:=lastTerm;
          posit[1]:=l;  posit[2]:=i; posit[3]:=1;
          TermKind:=variab;
          j1:=1; i1:=1; j2:=1; i2:=1; num:=0;
          next1:=nil; next2:=nil;
          ini(matrix[l,i],lastterm^.termkind);
          p:=lastterm^.posit[3];
          new(matrix[l,i]^.dest);
          matrix[l,i]^.dest^:=0;
          case p of
            1: matrix[lastterm^.posit[1],lastterm^.posit[2]]^.arg1:=matrix[l,i]^.dest;
            2: matrix[lastterm^.posit[1],lastterm^.posit[2]]^.arg2:=matrix[l,i]^.dest;
            3: matrix[lastterm^.posit[1],lastterm^.posit[2]]^.arg3:=matrix[l,i]^.dest;
            end;
          end; {with next1term^}
        lastterm^.next1:=next1term;
        ab[l]:=ab[l]+1;
        end;
      if lastterm^.numvar=2 then begin
        if lastterm^.next1=nil then begin
          new(next1term);
          l:=l+1;
          if l>maxlevels then begin error:=true; exit; end;
          if levels<l then levels:=l;
          i:=ab[l]+1;
          if i>maxlevelsize then begin error:=true; exit;end;
          with next1term^ do begin
            i0:=lastterm^.i1;
            j0:=lastterm^.j1;
            prev:=lastterm;
            posit[1]:=l; posit[2]:=i; posit[3]:=1;
            num:=0;
            j1:=1; i1:=1; j2:=1; i2:=1; termkind:=variab;
            next1:=nil; next2:=nil;
            ini(matrix[l,i],lastterm^.termkind);
            p:=lastterm^.posit[3];
            new(matrix[l,i]^.dest);
            matrix[l,i]^.dest^:=0;
            case p of
              1: matrix[lastterm^.posit[1],lastterm^.posit[2]]^.arg1:= matrix[l,i]^.dest;
              2: matrix[lastterm^.posit[1],lastterm^.posit[2]]^.arg2:= matrix[l,i]^.dest;
              3: matrix[lastterm^.posit[1],lastterm^.posit[2]]^.arg3:= matrix[l,i]^.dest;
              end;
            end;
          lastterm^.next1:=next1term;
          end {if lastterm.next1=nil}
        else begin
          new(next2term);
          l:=l+1;
          if l>maxLevels then begin error:=true; exit; end;
          if levels<l then levels:=l;
          i:=ab[l]+1;
          if i>maxlevelsize then begin error:=true; exit;end;
          with next2term^ do begin
            i0:=lastterm^.i2;
            j0:=lastterm^.j2;
            prev:=lastterm;
            posit[1]:=l; posit[2]:=i; posit[3]:=2;
            num:=0;
            j1:=1; i1:=1; j2:=1; i2:=1; termkind:=variab;
            next1:=nil; next2:=nil;
            end;
          lastterm^.next2:=next2term;
          ab[l]:=ab[l]+1;
          end; //else begin
      end; {if lastterm.numvar=2}
      if lastterm^.next1=nil
        then predone:=true
        else if lastterm^.next2=nil
              then lastterm:=lastterm^.next1
              else lastterm:=lastterm^.next2;
    until predone;
    if lastterm=firstterm then begin
      done:=true;
      dispose(lastterm);
      firstterm:=nil;
      end
    else begin
      repeat
        if lastterm^.next1<>nil then dispose(lastterm^.next1);
        if lastterm^.next2<>nil then dispose(lastterm^.next2);
        lastterm:=lastterm^.prev;
      until ((lastterm^.numvar=2) and
            (lastterm^.next2=nil)) or (lastterm=firstterm);
      if(lastterm=firstterm)and((firstterm^.numvar=1)
        or((firstterm^.numvar=2)and(firstterm^.next2<>nil)))then done:=true;
      end;
  until done;
  if firstterm<>nil then begin
    if firstterm^.next1<>nil then dispose(firstterm^.next1);
    if firstterm^.next2<>nil then dispose(firstterm^.next2);
    dispose(firstterm);
    end;
  for l:=1 to levels do levelsize[l]:=ab[l];
  if levels=0 then begin
    fop:=matrix[0,1];
    fop^.dest:=fop^.arg1; fop^.next:=nil;
    numop:=0;
    end
  else begin
    for l:=levels downto 1 do
      for i:=1 to levelsize[l] do begin
        if (l=levels) and (i=1) then begin
          numop:=1;
          fop:=matrix[l,i];
          lastop:=fop;
          end
        else begin
          inc(numop);
          lastop^.next:=matrix[l,i];
          lastop:=lastop^.next;
          end;
      end; {for l,i}
    with matrix[0,1]^ do begin
      arg1:=nil; arg2:=nil; arg3:=nil; dest:=nil;
      end;
    dispose(matrix[0,1]);
  end; {if levels>0}
end;

end.