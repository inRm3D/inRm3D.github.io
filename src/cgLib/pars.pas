unit Pars;
{$F+}
{$IFDEF WIN32}
{$H-}
{$ENDIF}
interface

uses Build, Parsglb, SysUtils, Math;

type

PParse = ^OParse;

OParse = object
  fString:string;
  vars:tVarPoints;
  params:tParPoints;
  numop:integer;
  fop:OperationPointer;
  constructor init(s:string; VarString:tVarString; ParString:tParString; var error:boolean);
  procedure SetParams( parameters:tParValues);
  procedure f(x,y,z :extended; var r:extended; var fError :boolean);
  destructor done;
end;
var Infi,Null :boolean;  //Infi�����Null������
const EP=0.00001;

implementation
//uses inRm3Dunit;

var LastOp:OperationPointer;

procedure myNothing;
begin
end;

procedure mySum;
begin with LastOp^ do dest^:=arg1^+arg2^; end;

procedure myDiff;
begin with LastOp^ do dest^:=arg1^-arg2^; end;

procedure myProd;
begin
  with LastOp^ do dest^:=arg1^*arg2^; end;

procedure myDivis;
begin
  with LastOp^ do
  if arg2^<>0 then dest^:=arg1^/arg2^
              else begin dest^:=0; oError:=true; Infi:=true; end;
end;

procedure myMinus;
begin
  with LastOp^ do dest^:=-arg1^;
end;

procedure myIntPower;
var n,i:longint;
begin
  with LastOp^ do begin
    n:=trunc(abs(arg2^))-1;
    case n of
    -1: dest^:=1;
     0: dest^:=arg1^;
    else
    begin
      dest^:=arg1^;
      for i:=1 to n do dest^:=dest^*arg1^;
    end;
   end;
  if arg2^<0 then if dest^<>0 then dest^:=1/dest^;
 end;
end;

procedure mySquare;
begin
  with LastOp^ do dest^:=arg1^*arg1^;
end;

procedure myThird;
begin
  with LastOp^ do dest^:=arg1^*arg1^*arg1^;
end;

procedure myForth;
begin
  with LastOp^ do dest^:=arg1^*arg1^*arg1^*arg1^;
end;

procedure myRealPower;
begin;
  with LastOp^ do begin
  if arg1^=0 then dest^:=0
  else if arg1^>0 then dest^:=exp(arg2^*ln(arg1^))
  else begin
    if(arg2^=trunc(arg2^))then myIntPower
    else begin dest^:=0; oError:=true; Null:=true;  end;
    end;
  end;
end;

procedure mySin;
begin
  with LastOp^ do dest^:=sin(arg1^);
end;

procedure myCos;
begin
  with LastOp^ do dest^:=cos(arg1^);
end;

procedure myTan;
  var a,n :double;
begin
  with LastOp^ do begin
    a:=arg1^; if(a>2*Pi)then begin n:=int(a/(2*Pi));  a:=a-n*2*Pi; end;
    if(abs(a-Pi/2)<EP)or(abs(a-1.5*Pi)<EP)then
      begin dest^:=0; oError:=true; Infi:=true; end
    else
      dest^:=Tan(arg1^)
  end;
end;

procedure myArcTan;
begin
  with LastOp^ do dest^:=ArcTan(arg1^);
end;

procedure myArcSin;
begin
  with LastOp^ do
  if abs(arg1^)<= 1 then dest^:= ArcSin(arg1^)
  else begin dest^:=0; oError:=true; Null:=true; end;
end;

procedure myArcCos;
begin
  with LastOp^ do
  if abs(arg1^)<= 1 then dest^:= ArcCos(arg1^) 
  else begin dest^:=0; oError:=true; Null:=true; end;
end;

procedure mySinH;
begin
  with LastOp^ do dest^:=SinH(arg1^);
end;

procedure myCosH;
begin
  with LastOp^ do dest^:=CosH(arg1^);
end;

procedure myTanH;
begin
  with LastOp^ do dest^:=TanH(arg1^);
end;

procedure myArcSinH;
begin
  with LastOp^ do dest^:=ArcSinH(arg1^);
end;

procedure myArcCosH;
begin
  with LastOp^ do
  if arg1^>=1then dest^:=ArcCosH(arg1^)
  else begin dest^:=0; oError:=true; Infi:=true; Null:=true; end;
end;

procedure myArcTanH;
begin
  with LastOp^ do
  if abs(arg1^)<=1 then dest^:=ArcTanH(arg1^) //������Ϊ(-1,1)
  else begin dest^:=0; oError:=true; Infi:=true; Null:=true; end;
end;

procedure myExp;
begin
  with LastOp^ do dest^:=exp(arg1^);
end;

procedure myLn;
begin
  with LastOp^ do
  if arg1^>0 then dest^:=ln(arg1^)
             else begin dest^:=0; oError:=true; Null:=true; end;
end;

procedure myLog;
begin
  with LastOp^ do
  if arg1^>0 then dest^:=ln(arg1^)*0.43429444
             else begin dest^:=0; oError:=true; Null:=true; end;
end;

procedure mySqrt;
begin
  with LastOp^ do
  if abs(arg1^)<0.0000001 then dest^:=0
  else if arg1^>0 then dest^:=sqrt(arg1^)
  else begin dest^:=0; oError:=true; Null:=true; end;
end;

procedure myABS;
begin
  with LastOp^ do dest^:=abs(arg1^);
end;

procedure myMin;
begin
  with lastop^ do
    if arg2^<arg1^ then dest^:=arg2^ else dest^:=arg1^;
end;

procedure myMax;
begin
  with LastOp^ do
    if arg1^>arg2^ then dest^:=arg1^ else dest^:=arg2^;
end;

procedure myHeavi;
begin
  with LastOp^ do
    if arg1^<0 then dest^:=0 else dest^:=1;
end;


procedure myPhase;
var a:extended;
begin
  with LastOp^ do begin
    a:=arg1^/2/pi;
    dest^:=2*pi*(a-round(a));
    end;
end;

procedure myRand;
var j,k:word;
begin
  with LastOp^ do begin
  j:=round(arg2^);
  k:=round(arg1^);
  if j=random(k) then dest^:=1 else dest^:=0;
  end;
end;

procedure myArg;
begin
  with LastOp^ do
  if arg1^=0 then dest^:=pi/2
  else if arg1^>0 then dest^:=arctan(arg2^/arg1^)
  else if arg2^>0 then dest^:=arctan(arg2^/arg1^)+pi
  else dest^:=arctan(arg2^/arg1^)-pi;
end;

procedure myRadius;
begin
  with LastOp^ do dest^:=sqrt(sqr(arg1^)+sqr(arg2^));
end;

procedure myRandrand;
var c:extended;
begin
  c:=random;
  if c<0.0000000000000000001 then c:=0.0000000000000000001;
  c:=sqrt(-2*ln(c))*cos(2*pi*random);
  with lastop^ do dest^:=arg1^+arg2^*c;
end;

procedure myFrac;
begin
  with LastOp^ do dest^:=frac(arg1^);
end;

procedure myLess;
begin
  with LastOp^ do
    if arg1^<arg2^ then dest^:=1 else dest^:=0;
end;

procedure myLessEqual;
begin
  with LastOp^ do
    if arg1^<=arg2^ then dest^:=1 else dest^:=0;
end;

procedure myEqual;
begin
  with LastOp^ do
    if abs(arg1^-arg2^)<EP then dest^:=1 else dest^:=0;
end;

procedure myNotEqual;
begin
  with LastOp^ do
    if abs(arg1^-arg2^)<EP then dest^:=0 else dest^:=1;
end;

procedure mySqr;
begin
  with LastOp^ do dest^:=sqr(arg1^);
end;

procedure myTrunc;
begin
  with LastOp^ do dest^:=trunc(arg1^);
end;

procedure myInt;
var a:single;
begin
  with LastOp^ do begin
    dest^:=trunc(arg1^);
    if(arg1^<0)and(dest^<>arg1^)then
      dest^:=dest^-1;
    end;
end;

procedure mySgn;
begin with LastOp^ do begin
  if arg1^<0 then dest^:=-1;
  if arg1^>0 then dest^:= 1;
  if arg1^=0 then dest^:= 0;
  end;
end;

procedure myRound;
begin
  with LastOp^ do dest^:= round(EP+arg1^);
end;

procedure myRandom;
begin //  Randomize;
  with LastOp^ do dest^:=random(trunc(arg1^));
end;

procedure myParity; //��ż��
begin
  with LastOp^ do begin
    arg1^:=round(arg1^);
    dest^:=arg1^-2*trunc(arg1^/2);
    end;
end;

procedure myFact;   //�׳�
  var i, n:integer;
begin
  with LastOp^ do begin 
    n:=trunc(arg1^);
    if n<0 then begin
      dest^:=0; oError:=true; Null:=true; end
    else begin
      dest^:=n;  if arg1^<2 then dest^:=1;
      if arg1^>2 then for i:=n downto 2 do dest^:=dest^ *(i-1);
      end;
  end;
end;

procedure myIIf;
begin
  with LastOp^ do
    if arg1^>0 then dest^:=arg2^ else dest^:=arg3^;
end;

procedure myMod;
begin
  with LastOp^ do
    dest^:=arg1^ - trunc(arg1^ / arg2^) * arg2^;
end;
{OParse}

constructor OParse.init(s:string;VarString:TVarString;
                   ParString:TParString;var Error:boolean);
var  lop:OperationPointer;
const p:TParValues = (1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1);
begin
    Infi:=false; Null:=false; //Infi�����Null������
    fString:=s;
    fop:=nil;
    parseFunction(s,VarString,ParString,fop,vars,Params,NumOp,Error);
    lop:=fop;
    while (lop<>nil) do
    begin
      with lop^ do
        case opNum of
          0,1,2,3: op:=myNothing;   4: op:=myMinus;
          5: op:=mySum;             6: op:=myDiff;
          7: op:=myProd;            8: op:=myDivis;
          9: op:=myIntpower;        10:op:=myRealPower;
          11:op:=myCos;             12:op:=mySin;
          13:op:=myExp;             14:op:=myLn;
          15:op:=mySqrt;            16:op:=myArcTan;
          17:op:=mySquare;          18:op:=myThird;
          19:op:=myForth;           20:op:=myABS;
          21:op:=myMax;             22:op:=myMin;
          23:op:=myHeavi;           24:op:=myPhase;
          25:op:=myRand;            26:op:=myArg;
          27:op:=mySinH;            28:op:=myCosH;
          29:op:=myRadius;          30:op:=myRandrand;
          31:op:=myFrac;            32:op:=myLess;
          33:op:=myEqual;           34:op:=myLessEqual;
          35:op:=myNotEqual;        36:op:=myTan;
          37:op:=myTanH;            38:op:=myArcSin;
          39:op:=myArcCos;          40:op:=mySqr;
          41:op:=myInt;             42:op:=mySgn;
          43:op:=myRound;           44:op:=myRandom;
          45:op:=myLog;             46:op:=myParity;
          47:op:=myArcSinH;         48:op:=myArcCosH;
          49:op:=myArcTanH;         50:op:=myFact;
          51:op:=myIIf;             52:op:=myMod;
          53:op:=myTrunc;
        end; {case}
      lop:=lop^.next;
    end; {while lop<>nil}
    if lop<>nil then setParams(p);
end;

procedure OParse.setParams;
var i:integer;
begin
  for i:=1 to 18 do params[i]^:=parameters[i];
end;


procedure OParse.f;
begin
    vars[1]^:=x; vars[2]^:=y; vars[3]^:=z;
    LastOp:=fop;
      LastOp^.oError:=false;
    Null:=false; Infi:=false;
    while(LastOp^.next<>nil)do
    begin
      LastOp^.op;
      if Infi or Null then break;
      LastOp:=LastOp^.next;
      LastOp^.oError:=false;
    end;
    LastOp^.oError:=false;
    LastOp^.op;
    r:=LastOp^.dest^;
end;

destructor OParse.done;
var i:integer; LastOp,NextOp :OperationPointer;
begin
  LastOp:=fop;
  while LastOp<>nil do
  begin
    nextOp:=LastOp^.next;
    while nextOp<>nil do
    begin
      if nextOp^.arg1 = lastOp^.arg1 then nextOp^.arg1:=nil;
      if nextOp^.arg2 = lastOp^.arg1 then nextOp^.arg2:=nil;
      if nextOp^.arg3 = lastOp^.arg1 then nextOp^.arg3:=nil;
      if nextOp^.dest = lastOp^.arg1 then nextOp^.dest:=nil;

      if nextOp^.arg1 = lastOp^.arg2 then nextOp^.arg1:=nil;
      if nextOp^.arg2 = lastOp^.arg2 then nextOp^.arg2:=nil;
      if nextOp^.arg3 = lastOp^.arg2 then nextOp^.arg3:=nil;
      if nextOp^.dest = lastOp^.arg2 then nextOp^.dest:=nil;

      if nextOp^.arg1 = lastOp^.arg3 then nextOp^.arg1:=nil;
      if nextOp^.arg2 = lastOp^.arg3 then nextOp^.arg2:=nil;
      if nextOp^.arg3 = lastOp^.arg3 then nextOp^.arg3:=nil;
      if nextOp^.dest = lastOp^.arg3 then nextOp^.dest:=nil;

      if nextOp^.arg1 = lastOp^.dest then nextOp^.arg1:=nil;
      if nextOp^.arg2 = lastOp^.dest then nextOp^.arg2:=nil;
      if nextOp^.arg3 = lastOp^.dest then nextOp^.arg3:=nil;
      if nextOp^.dest = lastOp^.dest then nextOp^.dest:=nil;
      nextOp:=nextOp^.next;
    end;
    with LastOp^ do
    begin
      for i:=1 to  3 do if arg1=  vars[i] then arg1:=nil;
      for i:=1 to 18 do if arg1=params[i] then arg1:=nil;
      for i:=1 to  3 do if arg2=  vars[i] then arg2:=nil;
      for i:=1 to 18 do if arg2=params[i] then arg2:=nil;
      for i:=1 to  3 do if arg3=  vars[i] then arg3:=nil;
      for i:=1 to 18 do if arg3=params[i] then arg3:=nil;
      for i:=1 to  3 do if dest=  vars[i] then dest:=nil;
      for i:=1 to 18 do if dest=params[i] then dest:=nil;
      if (dest=arg1) or (dest=arg2) then dest:=nil;
      if arg1<>nil then dispose(arg1);
      if arg2<>nil then dispose(arg2);
      if arg3<>nil then dispose(arg3);
      if dest<>nil then dispose(dest);
    end;
    nextop:=LastOp^.next;
    dispose(LastOp);
    LastOp:=nextOp;
  end;
  for i:=1 to  3 do if   vars[i]<>nil then dispose(vars[i]);
  for i:=1 to 18 do if params[i]<>nil then dispose(params[i]);
end;



end.