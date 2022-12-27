unit CgGeometry;

interface

uses
  SysUtils, CgTypes, CgUtils, Menus, Math;

function EP(a:single):boolean;
procedure cgSetPrecision(_eps: Single);
procedure cgInvertNormal(var a,b,c :single);
procedure cgInvertVec(var p:TcgVector);
function cgPrecision: Single;
function cgOrigin: TCGVector;
function cgXAxis: TCGVector;
function cgYAxis: TCGVector;
function cgZAxis: TCGVector;
procedure cgTranslate(var v: TCGVector; t: TCGVector);
procedure cgMirror(var v: TCGVector; mx, my, mz: Boolean);

procedure cgScale(var v: TCGVector; sx, sy, sz: Single);
procedure cgRotateX(var v: TCGVector; a: Single);
procedure cgRotateY(var v: TCGVector; a: Single);
procedure cgRotateZ(var v: TCGVector; a: Single);
procedure cgRotate(var v: TCGVector; P, Q: TCGVector; a: Single);  // Doesn't work.
procedure cgNormalize(var v: TCGVector);
procedure cgVecSwap(var v1,v2: TCGVector); //交换两点

function cgIIF(b:boolean; v1,v2:TcgVector): TCGVector;
function cgNormalVec(v1,v2 :TcgVector):TcgVector;
function cgGetNormal(v1, v2, v3: TCGVector): TCGVector;
function cgCrossProduct(v1, v2: TCGVector): TCGVector; //叉积
function cgVecSgn( v1,v2: TcgVector): boolean; //两向量是否同向
function cgVecComp(v1,v2: TCGVector): Boolean;
function cgVecCompABS(v1, v2: TCGVector): Boolean;
function cgVecParallel(v1,v2: TCGVector): Boolean; //两向量是否平行
function cgComp(v: TCGVector): Boolean;
function cgMax(v1,v2: TCGVector):TCGVector;
function cgMin(v1,v2: TCGVector):TCGVector;
function cgVecAdd(v1,v2: TCGVector): TCGVector; //v1+v2
function cgVecSub(v1,v2: TCGVector): TCGVector; //v1-v2
function cgVecMid(v1,v2: TCGVector): TCGVector; //
function cgDotProduct(v1, v2: TCGVector): Single;//v1*v2
function cgVecScale(v1 : TCGVector; scale : Single): TCGVector;
function cgVecPower(v :TcgVector): single;       //v*v
function cgVecMult(v1,v2 :TCGVector):TCGVector;  //v1*v2
function cgVecAddMult(v1,v2: TCGVector; scale: Single): TCGVector;
function cgVecSubMult(v1,v2: TCGVector; scale: Single): TCGVector;
function cgVecMultSub(v1,v2: TCGVector; scale: Single): TCGVector;
function cgVecLength(v: TCGVector): Single;
function cgModelLength(a,b,c: single): single;
function cgDistance(v1,v2: TCGVector): Single;
function cgDistanceDotLine(p1,p2, v2:TcgVector): single;
function cgAt2Dot(v0, v1,v2 : TCGVector):Boolean;

function cgIdentity: TCGMatrix;
function cgNullMatrix: TCGMatrix;
function cgMatMult(v1, v2: TCGVector): TCGMatrix;
procedure cgApplyMatrix(var v: TCGVector; m: TCGMatrix);
procedure cgMatrixAdd(var m1: TCGMatrix; m2: TCGMatrix);
procedure cgMatrixSub(var m1: TCGMatrix; m2: TCGMatrix);
procedure cgMatrixMult(var m1: TCGMatrix; m2: TCGMatrix);
procedure cgMScalarMult(var m: TCGMatrix; s: Single);
function cgMRotateX(angle: Single): TCGMatrix;
function cgMRotateY(angle: Single): TCGMatrix;
function cgMRotateZ(angle: Single): TCGMatrix;
function cgMScale(sx, sy, sz: Single): TCGMatrix;
function cgPlane(p1, p2, p3: TCGVector): TcgVector;

function cgDotInBox(Dot, p1,p2 :TcgVector):boolean; //点Dot是否在六面体内
function cgDotNearestLine( Dot, pa,pb:TcgVector):TcgVector; //线段最近点
function cgDotLineFooter(Dot, pa,na:TcgVector; bDistance:boolean):TcgVector; //垂足
function cgDotAtLine(Dot, p1,p2 :TcgVector):boolean; //点Dot是否与在直线上
function cgDotInPlane(Dot, p0,p1,p2,p3 :TcgVector; Precise,bb:boolean):boolean; //点Dot是否在平面之内 bb=false时为三点面
function cgDotInPolygon(Dot:TcgVector; Vec:array of TcgVector; W:integer):boolean;
function cgTowLineCanCross(p1,p2,p3,p4, nor :TcgVector):boolean; //判断两线段是否相交
function cgLinePlaneCross(pL,vL, pP,vP:TcgVector; var p:TcgVector):boolean;//线面交点
function cgPlaneCross(p1,p2,p3,p4, pP,vP:TcgVector; var pa,pb:TcgVector):boolean;
function cgPlaneSection(pa,na, pb,nb:TcgVector; var pp,nc:TcgVector):boolean;
function cgTowCircleTangent(pa,na,pb,nb:TcgVector; aR,bR,L:single;
            var p0,p1:TcgVector; var isSegment:boolean; Inner,Exchange:boolean):boolean;//两圆之切线
function cgCheckSide( p, p1,p2 :TcgVector; i:integer):integer;//p点 p1,p2线段
function cgShell(out Vct:array of TcgVector; M:integer):integer;
function cgDotPlaneFooter(Dot, pa,pn:TcgVector):TcgVector;
function cgLineCircleCross(pa,na, pb:TcgVector; R:single; var px,py:TcgVector):integer;//直线和圆之交点
function cgTowCircleCross(pa,pb, Normal:TcgVector; La,Lb:double; var px,py:TcgVector):integer;//两圆交点
function cgTowLineCross2( pA,pB, vA,vB:TcgVector ):TcgVector; //One,Tow 两直线端点 aa,bb两直线的向量
function cgTowLineCross( One,Tow, va,vb:TcgVector ):TcgVector; //One,Tow 两直线端点 aa,bb两直线的向量
function cgDeterminant2D( a1,b1,a2,b2:single) :single; assembler;
function cgDeterminant3D(a1,b1,c1, a2,b2,c2, a3,b3,c3 :single) :single;
function cgDeterminant3D1( a,b,c :TcgVector) :single;
function cgDistance2D(x,y:integer; pp:TcgVector):single; //屏幕平面上两点之间距
procedure cgPublicVerticalLine(pA,vA, pB,vB:TcgVector; var p0,p1,vC:TcgVector);
function cgFooterAtLine(Dot, pa,pb:TcgVector; var pt:TcgVector; atLine:boolean):boolean;
function cgDotInLine2D( p0, p1,p2 :TcgVector):boolean;//是否线段内的点
function cgPlaneNormal( p0,p1,p2,p3 :TcgVector; Normal:boolean) :TcgVector;
function cgSolution(var t :single; a,b,c :single; bb:boolean) :boolean;
function cgForePointInOnePlane( p1,p2,p3,p4 :TcgVector ):boolean;
function cgCenter( pa,pb,pc:TcgVector; var Cen,Nor:TcgVector; H:integer):boolean;
function cgInversion(pp,Dot:TcgVector; k:single; vert:boolean):TcgVector;
function cgGetRectangle(pp,Nor:TcgVector; L,R:single; var pa,pb,pc,pd:TcgVector):boolean;

function cgTriangleArea(pa,pb,pc :TcgVector):single;//三角形面积
procedure cgXYZtoAngle(X,Y,Z:single; var m,n,r:single; is3D:boolean);
procedure cgAngleToXYZ(R,m,n:single; var X,Y,Z:single; is3D:boolean);

implementation
uses inRm3Dunit;

type
  TAVector = array [0..4] of Single;
  TPoint = record x,y :single; end;

const halfPi=Pi/2;
var
  EPS: double = 0.00000001;


function EP( a:single):boolean;
begin result:=abs(a)<EPS; end;

procedure cgInvertNormal(var a,b,c :single);
begin
  a:=-a; b:=-b; c:=-c;
end;
procedure cgInvertVec(var p:TcgVector);
begin
  p.x:=-p.x; p.y:=-p.y; p.z:=-p.z; 
end;

function cgVecSub(v1, v2: TCGVector): TCGVector; assembler;
asm  //result:=cgVector(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z)
 fld v1.x
 fsub v2.x
 fstp Result.x

 fld v1.y
 fsub v2.y
 fstp Result.y

 fld v1.z
 fsub v2.z
 fstp Result.z
end;

function cgVecAdd(v1, v2: TCGVector): TCGVector; assembler;
asm  //result:=cgVector(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z)
 fld v1.x
 fadd v2.x
 fstp Result.x

 fld v1.y
 fadd v2.y
 fstp Result.y

 fld v1.z
 fadd v2.z
 fstp Result.z

 fld v1.w
 fadd v2.w
 fstp Result.w
end;

function cgVecMid(v1, v2: TCGVector): TCGVector; //
  const mid:single = 0.5;
asm
  fld v1.x
  fadd v2.x
  fmul mid  //v.x*0.5
  fstp Result.x

  fld v1.y
  fadd v2.y
  fmul mid  //v.x*0.5
  fstp Result.y

  fld v1.z
  fadd v2.z
  fmul mid  //v.x*0.5
  fstp Result.z
end;

function cgVecPower(v :TcgVector): single;
asm  //v.x*v.x + v.y*v.y + v.z*v.z
  fld v.x
  fmul v.x  //v.x*v.x

  fld v.y
  fmul v.y  //v.y*v.y
  faddp     //v.x*v.x + v.y*v.y

  fld v.z
  fmul v.z  //v.z*v.z
  faddp     //v.x*v.x + v.y*v.y + v.z*v.z
  fstp Result
end;

function cgVecMult(v1,v2 :TCGVector):TCGVector;
asm //result:=cgVector(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z)
  fld v1.x
  fmul v2.x
  fstp Result.x

  fld v1.y
  fmul v2.y
  fstp Result.y

  fld v1.z
  fmul v2.z
  fstp Result.z
end;

function cgVecScale(v1 : TCGVector ; scale : Single): TCGVector; assembler;
asm //result:=cgVector(v.x*scale, v.y*scale, v.z*scale)
 fld v1.x
 fmul scale
 fstp Result.x

 fld v1.y
 fmul scale
 fstp Result.y

 fld v1.z
 fmul scale
 fstp Result.z

 fld v1.w
 fmul scale
 fstp Result.w
end;
function cgVecAddMult(v1,v2 : TCGVector; scale : Single): TCGVector;
asm //result:=cgVector(v1.x+v2.x*scale, v1.y+v2.y*scale, v1.z+v2.z*scale)
  fld v2.x
  fmul scale
  fadd v1.x
  fstp Result.x

  fld v2.y
  fmul scale
  fadd v1.y
  fstp Result.y

  fld v2.z
  fmul scale
  fadd v1.z
  fstp Result.z
end;
function cgVecSubMult(v1,v2 : TCGVector; scale : Single): TCGVector;
asm //result:=cgVector(v1.x-v2.x*scale, v1.y-v2.y*scale, v1.z-v2.z*scale)
  fld v1.x
  fld v2.x
  fmul scale
  fsubp
  fstp Result.x

  fld v1.y
  fld v2.y
  fmul scale
  fsubp
  fstp Result.y

  fld v1.z
  fld v2.z
  fmul scale
  fsubp
  fstp Result.z
end;
function cgVecMultSub(v1,v2 : TCGVector; scale : Single): TCGVector;
asm //result:=cgVector(v1.x*scale-v2.x, v1.y*scale-v2.y, v1.z*scale-v2.z)
  fld v1.x
  fmul scale
  fld v2.x
  fsubp
  fstp Result.x

  fld v1.y
  fmul scale
  fld v2.y
  fsubp
  fstp Result.y

  fld v1.z
  fmul scale
  fld v2.z
  fsubp
  fstp Result.z
end;

procedure cgSetPrecision(_eps: Single);
begin
  { Set precision for vector comparisons. Doesn't really affect floating point
    precision, of course... The default of 0.0001 should be adequate in most
    cases, but you never know. }
  EPS := _eps;
end;

function cgPrecision: Single;
begin { Return the current vector comparison precision. }
  Result := EPS;
end;

function cgOrigin: TCGVector;
const r: TCGVector = (x:0; y:0; z:0; w: 1; r:1);
begin{ Return the origin. }
  Result := r;
end;

function cgXAxis: TCGVector;
const r: TCGVector = (x: 1; y: 0; z: 0; w: 1);
begin{ Return a unit vector along the X axis. }
  Result := r;
end;

function cgYAxis: TCGVector;
const r: TCGVector = (x: 0; y: 1; z: 0; w: 1);
begin{ Return a unit vector along the Y axis. }
  Result := r;
end;

function cgZAxis: TCGVector;
const r: TCGVector = (x: 0; y: 0; z: 1; w: 1);
begin{ Return a unit vector along the Z axis. }
  Result := r;
end;

function cgVecSgn( v1,v2: TcgVector): boolean; //两向量是否同向
begin
  result:=(v1.x*v2.x>=0)and(v1.y*v2.y>=0)and(v1.z*v2.z>=0)
end;

function cgVecComp(v1, v2: TCGVector): Boolean;
begin //两点是否重合
  Result := (Abs(v1.x - v2.x) < EPS)
        and (Abs(v1.y - v2.y) < EPS)
        and (Abs(v1.z - v2.z) < EPS);
end;

function cgVecCompABS(v1, v2: TCGVector): Boolean;
begin //两点是否重合
  Result := ((Abs(v1.x) - Abs(v2.x)) < EPS)
        and ((Abs(v1.y) - Abs(v2.y)) < EPS)
        and ((Abs(v1.z) - Abs(v2.z)) < EPS);
end;

function cgVecParallel(v1,v2: TCGVector): Boolean;
begin //两向量是否平行
  result:=cgVecComp(v1,v2);
  if not result then begin
    cgInvertVec(v1); result:=cgVecComp(v1,v2);
    end;
end;

function cgComp(v: TCGVector): Boolean;
begin
  result:=(abs(v.x)<EPS)and(abs(v.y)<EPS)and(abs(v.z)<EPS);
end;

procedure cgVecSwap(var v1,v2: TCGVector);
  var v:TcgVector;
begin v:=v1; v1:=v2; v2:=v; end;

function cgMax(v1,v2: TCGVector):TCGVector;
  function Max(const A, B: Single): Single;
    begin if A>B then Result:=A else Result:=B; end;
begin
  result.x:=Max(v1.x,v2.x); result.y:=Max(v1.y,v2.y); result.z:=Max(v1.z,v2.z);
end;

function cgMin(v1,v2: TCGVector):TCGVector;
  function Min(const A, B: Single): Single;
    begin if A<B then Result:=A else Result:=B; end;
begin
  result.x:=Min(v1.x,v2.x); result.y:=Min(v1.y,v2.y); result.z:=Min(v1.z,v2.z);
end;

procedure cgTranslate(var v: TCGVector; t: TCGVector); assembler;
asm   //v.x:=v.x+t.x  v.y:=v.y+t.y  v.z:=v.z+t.z
    fld v.x
    fadd t.x
    fstp v.x

    fld v.y
    fadd t.y
    fstp v.y

    fld v.z
    fadd t.z
    fstp v.z
end;

procedure cgMirror(var v: TCGVector; mx, my, mz: Boolean);

label __my , __mz , __exit;

asm
          test dl,dl
          jz __my
          fld v.x
          fchs
          fstp v.x

    __my :
          test cl,cl
          jz __mz
          fld v.y
          fchs
          fstp v.y

    __mz :
          cmp mz,$00
          jz __exit
          fld v.z
          fchs
          fstp v.z
          jb __exit

    __exit:
end;

procedure cgScale(var v: TCGVector; sx, sy, sz: Single); assembler;
asm { Scale v with the given scale factors for each axis. }
  fld v.x
  fmul sx
  fstp v.x

  fld v.y
  fmul sy
  fstp v.y

  fld v.z
  fmul sz
  fstp v.z
end;
function cgModelLength( a,b,c :single): single; assembler;
asm
  fld a
  fmul a

  fld b
  fmul b
  faddp

  fld c
  fmul c
  faddp

  fsqrt
  fstp Result
end;
function cgVecLength(v: TCGVector): Single; assembler;
asm
  fld v.x
  fmul v.x

  fld v.y
  fmul v.y
  faddp

  fld v.z
  fmul v.z
  faddp

  fsqrt
  fstp Result
end;

function cgDistance(v1, v2: TCGVector): Single;
begin { Calculate the distance between two points. }
  asm
    fld v1.x
    fchs        // working faster - no if conditions!
    fstp v1.x

    fld v1.y
    fchs
    fstp v1.y

    fld v1.z
    fchs
    fstp v1.z

    fld v1.x
    fadd v2.x
    fstp v2.x

    fld v1.y
    fadd v2.y
    fstp v2.y

    fld v1.z
    fadd v2.z
    fstp v2.z
  end;
  Result := cgVecLength(v2);
end;

function cgDistanceDotLine(p1,p2, v2:TcgVector): single; //点到直线之距离
  var p0,v1 :TcgVector;  t :single;
begin
  v1:=cgVecSub( p1, p2); //点到直线端点的向量
  t:=cgDotProduct( v2, v1);
  p0:=cgVecAddMult( p2, v2, t); //垂点
  result:=cgDistance( p1, p0);
end;

procedure cgNormalize(var v: TCGVector);
begin
  v.w:=sqrt(v.x*v.x+v.y*v.y+v.z*v.z);
  if EP(v.w)then exit;
  v.x:=v.x/v.w; v.y:=v.y/v.w; v.z:=v.z/v.w;
end;

procedure cgNormalize2(var v: TCGVector); assembler;
  LABEL _EXIT;  //向量格式化
asm
  fld v.x
  fmul v.x  //v.x*v.x

  fld v.y
  fmul v.y  //v.y*v.y
  faddp     //v.x*v.x + v.y*v.y

  fld v.z
  fmul v.z  //v.z*v.z
  faddp     //v.x*v.x + v.y*v.y + v.z*v.z

  fsqrt     //sqrt(v.x*v.x + v.y*v.y + v.z*v.z)

  ftst
  jz _EXIT
  fstp v.w  //  fstp L

  fld v.x
  fdiv v.w
  fstp v.x

  fld v.y
  fdiv v.w
  fstp v.y

  fld v.z
  fdiv v.w
  fstp v.z

  _EXIT:
end;

procedure cgRotateX(var v: TCGVector; a: Single); assembler;
var temp: TCGVector;
    sin_ , cos_ : Single;
asm
  fld a
  fcos
  fstp cos_

  fld a
  fsin
  fstp sin_

  fld v.y//dword ptr [v.y]          //    y := (v.y * cos_) + (v.z * -sin_);
  fmul cos_

  fld v.z//dword ptr [v.z]
  fmul sin_
  fsubp
  fstp temp.y

  fld v.y//dword ptr [v.y]
  fmul sin_

  fld v.z//dword ptr [v.z]
  fmul cos_
  faddp
  fstp v.z//dword ptr [v.z]

  fld1
  fstp v.w//dword ptr [v.w]

  fld temp.y
  fstp v.y//dword ptr [v.y]
end;

procedure cgRotateY(var v: TCGVector; a: Single); assembler;
var temp: TCGVector;
    sin_ , cos_ : Single;
asm
   fld a
   fcos
   fstp cos_

   fld a
   fsin
   fstp sin_

   fld v.x//dword ptr [v.x]
   fmul cos_

   fld v.z//dword ptr [v.z]
   fmul sin_
   faddp
   fstp temp.x

   fld v.z//dword ptr [v.z]
   fmul cos_

   fld v.x//dword ptr [v.x]
   fmul sin_
   fsubp
   fstp v.z//dword ptr [v.z]

   fld1
   fstp v.w//dword ptr [v.w]

   fld temp.x
   fstp v.x//dword ptr [v.x]
end;

procedure cgRotateZ(var v: TCGVector; a: Single); assembler;
var temp: TCGVector;
    sin_ , cos_ : Single;
 asm
   fld a
   fcos
   fstp cos_

   fld a
   fsin
   fstp sin_

   fld v.x//dword ptr [v.x]
   fmul cos_

   fld v.y//dword ptr [v.y]
   fmul sin_
   fsubp
   fstp temp.x

   fld v.x//dword ptr [v.x]
   fmul sin_

   fld v.y//dword ptr [v.y]
   fmul cos_
   faddp
   fstp v.y//dword ptr [v.y]

   fld1
   fstp v.w//dword ptr [v.w]

   fld temp.x
   fstp v.x//dword ptr [v.x]
end;

procedure cgRotate(var v: TCGVector; P, Q: TCGVector; a: Single);
var rho, phi, theta: Single; // Spherical coordinates the axis endpoint.
begin { Rotate v over a radians around axis PQ. }
  // Translate the rotation axis to the origin.
  cgMirror(P, TRUE, TRUE, TRUE);
  cgTranslate(Q, P);
  // Calculate spherical coordinates for Q.
  rho := cgVecLength(v);
  phi := cgArcCos(v.z / rho);
  // ArcTan is always in [0, 2*pi], which is not good.
  if v.x > 0 then theta := ArcTan(v.y / v.x)
  else if v.x < 0 then theta := ArcTan(v.y / v.x) + pi
  else if v.y >= 0 then theta := pi / 2
  else theta := 3*pi / 2;
  // Now transform the Z-axis to coincide with Q.
  cgRotateZ(v, -theta);
  cgRotateY(v, phi);
  // Now rotate around the Z/Q-axis.
  cgRotateZ(v, a);
  // And restore the original coordinate system.
  cgRotateY(v, -phi);
  cgRotateZ(v, theta);
  // Now translate the vector over P (the starting point of the PQ axis).
  cgMirror(P, TRUE, TRUE, TRUE);
  cgTranslate(v, P);
  // The vector v has now been rotated around axis PQ.

end;

function cgDotProduct(v1, v2: TCGVector): Single; assembler;
asm // Result := v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
  fld v1.x
  fmul v2.x

  fld v1.y
  fmul v2.y
  faddp

  fld v1.z
  fmul v2.z
  faddp
  fstp Result
end;

function cgCrossProduct(v1, v2: TCGVector): TCGVector; assembler;
asm       //Result := cgVector(v1.y * v2.z - v2.y * v1.z,
          //                   v2.x * v1.z - v1.x * v2.z,
          //                   v1.x * v2.y - v2.x * v1.y);
  fld v2.y
  fmul v1.z

  fld v1.y
  fmul v2.z
  fsubp
  fstp Result.x

  fld v1.x
  fmul v2.z

  fld v2.x
  fmul v1.z
  fsubp
  fstp Result.y

  fld v2.x
  fmul v1.y

  fld v1.x
  fmul v2.y
  fsubp
  fstp Result.z

  fld1
  fstp Result.w
end;

function cgIIF(b:boolean; v1,v2:TcgVector): TCGVector;
begin if b then result:=v1 else result:=v2; end;

function cgGetNormal(v1, v2, v3: TCGVector): TCGVector;
begin // Return the normal vector to the plane defined by v1, v2 and v3.
  asm
    //cgMirror(v2, TRUE, TRUE, TRUE);
    fld v2.x
    fchs                             // working faster - no if conditions!
    fstp v2.x

    fld v2.y
    fchs
    fstp v2.y

    fld v2.z
    fchs
    fstp v2.z
    //  cgTranslate(v1, v2);
    fld v1.x
    fadd v2.x
    fstp v1.x

    fld v1.y
    fadd v2.y
    fstp v1.y

    fld v1.z
    fadd v2.z
    fstp v1.z
   // cgTranslate(v3, v2);
    fld v3.x
    fadd v2.x
    fstp v3.x

    fld v3.y
    fadd v2.y
    fstp v3.y

    fld v3.z
    fadd v2.z
    fstp v3.z
  end;
  Result := cgCrossProduct(v1, v3);
  cgNormalize(Result);
end;

function cgMatMult(v1, v2: TCGVector): TCGMatrix;
var
  i, j: Integer;
begin // Multiply a row and a column vector, resulting in a 4x4 matrix.
  for i := 0 to 3 do
    for j := 0 to 3 do
      Result[i,j] := TAVector(v1)[i] * TAVector(v2)[j];
end;

function cgIdentity: TCGMatrix;
const
  i: TCGMatrix = ((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1));
begin // Return the identity matrix.
  Result := i;
end;

function cgNullMatrix: TCGMatrix;
const
  n: TCGMatrix = ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0));
begin // Return the null matrix.
  Result := n;
end;

procedure cgApplyMatrix(var v: TCGVector; m: TCGMatrix);
var t: TCGVector;   r,c: Integer;
begin // Multiply v with the matrix m.
  for c := 0 to 3 do begin
    TAVector(t)[c] := 0;
    for r := 0 to 3 do
      TAVector(t)[c] := TAVector(t)[c] + TAVector(v)[r] * m[r,c];
  end;
  v := t;
end;

procedure cgMatrixAdd(var m1: TCGMatrix; m2: TCGMatrix);
var i, j: Integer;
begin // Add the second matrix to the first.
  for i := 0 to 3 do
    for j := 0 to 3 do
      m1[i,j] := m1[i,j] + m2[i,j];
end;

procedure cgMatrixSub(var m1: TCGMatrix; m2: TCGMatrix);
var i, j: Integer;
begin // Substract the second matrix from the first.
  for i := 0 to 3 do
    for j := 0 to 3 do
      m1[i,j] := m1[i,j] - m2[i,j];
end;

procedure cgMatrixMult(var m1: TCGMatrix; m2: TCGMatrix);
var r, c, i: Byte;   t: TCGMatrix;
begin // Multiply two matrices.
  t := cgNullMatrix;
  for r := 0 to 3 do
    for c := 0 to 3 do
      for i := 0 to 3 do
        t[r,c] := t[r,c] + (m1[r,i] * m2[i,c]);
  m1 := t;
end;

procedure cgMScalarMult(var m: TCGMatrix; s: Single);
var i, j: Integer;
begin // Multiply a matrix with a scalar.
  for i := 0 to 3 do
    for j := 0 to 3 do
      m[i,j] := m[i,j] * s;
end;

function cgMRotateX(angle: Single): TCGMatrix;
begin // Return a rotation matrix for the X axis.
  Result := cgIdentity;
  Result[1,1] := cos(angle);
  Result[2,2] := Result[1,1];   // Don't calculate cosine twice.
  Result[1,2] := sin(angle);
  Result[2,1] := -Result[1,2];
end;

function cgMRotateY(angle: Single): TCGMatrix;
begin // Return a rotation matrix for the Y axis.
  Result := cgIdentity;
  Result[0,0] := cos(angle);
  Result[2,2] := Result[0,0];
  Result[0,2] := -sin(angle);
  Result[2,0] := -Result[0,2];
end;

function cgMRotateZ(angle: Single): TCGMatrix;
begin // Return a rotation matrix for the Z axis.
  Result := cgIdentity;
  Result[0,0] := cos(angle);
  Result[1,1] := Result[0,0];
  Result[0,1] := sin(angle);
  Result[1,0] := -Result[0,1];
end;

function cgMScale(sx, sy, sz: Single): TCGMatrix;
begin // Return a transformation matrix for scaling.
  Result := cgIdentity;
  Result[0,0] := sx;
  Result[1,1] := sy;
  Result[2,2] := sz;
end;

function cgPlane(p1, p2, p3: TCGVector): TcgVector;
var n: TCGVector;
begin
  { Create a TCGPlane from 3 coplanar points. To do this, calculate the normal
    to the plane. The x, y and z components of the normal vector correspond to
    the A, B and C components of the plane. D can then be very easily calculated
    knowing that Ax + By + Cz + D = 0 for any point on the plane, such as p1. }
  n := cgGetNormal(p1, p2, p3);
  with Result do
  begin
    X := n.x;
    Y := n.y;
    Z := n.z;
    W := -(X * p1.x + Y * p1.y + Z * p1.z);
  end;
end;

function cgAt2Dot(v0, v1,v2 : TCGVector):Boolean;
  var i:integer; L, dd, dC,dL,dR:single;
begin
  i:=0; L:=0; dd:=0;  dC:=0; dL:=0; dR:=0;
  L:=abs(v2.x-v1.x); if L>dd then begin dd:=L; dC:=v0.x; dL:=v1.x; dR:=v2.x; end;
  L:=abs(v2.y-v1.y); if L>dd then begin dd:=L; dC:=v0.y; dL:=v1.y; dR:=v2.y; end;
  L:=abs(v2.z-v1.z); if L>dd then begin dd:=L; dC:=v0.z; dL:=v1.z; dR:=v2.z; end;
  result:=(dL<=dC)and(dC<=dR)or(dL>=dC)and(dC>=dR);
end;
//判断一点是否在矩形内
function cgDotInRect(Dot, p1,p2 :TcgVector):boolean;
  function Mid(a,b,c:single):boolean;
    begin result:=(a>=b-EPS)and(a<=c+EPS) or (a<=b+EPS)and(a>=c-EPS); end;
begin
  result:= Mid(Dot.x, p1.x,p2.x)
       and Mid(Dot.y, p1.y,p2.y);
end;
//判断一点是否位于以指定直线为对角线的水平六面体之内
function cgDotInBox(Dot, p1,p2 :TcgVector):boolean;
  const EPS=0.0001;
  function Mid(a,b,c:single):boolean;
    begin result:=(a>=b-EPS)and(a<=c+EPS) or (a<=b+EPS)and(a>=c-EPS); end;
begin
  result:= Mid(Dot.x, p1.x,p2.x)
       and Mid(Dot.y, p1.y,p2.y)
       and Mid(Dot.z, p1.z,p2.z);
end;
//判断一点是否与指定直线共线(有可能在俩端点之外)
function cgDotAtLine(Dot, p1,p2 :TcgVector):boolean; //共线为true
    var va,vb,vc :TcgVector;
begin
  va:=cgVecSub(dot,p1);    vb:=cgVecSub(dot,p2);
  vc:=cgCrossProduct(va,vb); //两点之差积
  result:=(abs(vc.x)<0.0001)and(abs(vc.y)<0.0001)and(abs(vc.z)<0.0001);
end;
//判断点P是否在三(四)边形内
//在三(四)边形内任取一点Q, 只要证明点P和点Q在三(四)边形的每一条边的同侧即可
function cgDotInPlane(Dot, p0,p1,p2,p3 :TcgVector; Precise,bb:boolean):boolean; //Fuzzy模糊的
  var p:array[0..4]of TcgVector; // bb:四边形
      pp, pa,pb,pc, na,nb :TcgVector;  i,j :integer;   t:double;
  function TowVec(na,nb:TcgVector):boolean;//两向量是否同向
    begin result:=(na.x*nb.x>=0)and(na.y*nb.y>=0)and(na.z*nb.z>=0);
    end;
begin  result:=true;
  if bb then begin
         if cgVecComp(p0,p1)then begin p1:=p2; p2:=p3; bb:=false; end
    else if cgVecComp(p0,p2)or cgVecComp(p1,p2)then begin p2:=p3; bb:=false; end
    else if cgVecComp(p0,p3)or cgVecComp(p1,p3)or cgVecComp(p2,p3)then bb:=false;
    end;
  p[0]:=p0;  p[1]:=p1;   p[2]:=p2;  p[3]:=p3;
  if bb then p[4]:=p[0] else p[3]:=p[0];
  if bb then j:=4 else j:=3;
  EPS:=0.0001;
  for i:=0 to j-1 do if cgVecComp(Dot,p[i])then exit; //点Dot与平面顶点重合则退出
  EPS:= 0.00000001;

  pp:=cgVector(0,0,0);
  for i:=0 to j-1 do pp:=cgVecAdd(pp,p[i]);
  pp:=cgVecScale(pp,1/j); //形心

  for i:= 0 to j-1 do begin
    pa:=cgVecSub(Dot,   p[i]);
    pb:=cgVecSub(p[i+1],p[i]);
    pc:=cgVecSub(pp,    p[i]);
    na:=cgCrossProduct(pa,pb); nb:=cgCrossProduct(pc,pb);
    t:=cgDotProduct(na,nb);
    if(Precise and(t<=0))or(not Precise and(t<-0.0001))then
      begin result:=false; exit; end;
    end; //( P1 - Q1 )×( Q2 - Q1 ) * ( P2 - Q1 )×( Q2 - Q1 ) < 0
end;
function cgDotInPolygon(Dot:TcgVector; Vec:array of TcgVector; W:integer):boolean;
  var pp, pa,pb,pc, na,nb :TcgVector;  i,j,M :integer;
      p:array of TcgVector;
begin
    result:=true;
  M:=high(Vec); if M<W then M:=W; //平面顶点数

  setLength(p, W+1);
  for i:=0 to W-1 do p[i]:=Vec[i];    p[W]:=p[0];
  pp:=cgVector(0,0,0);
  for i:=0 to W-1 do pp:=cgVecAdd(pp,p[i]);
  pp:=cgVecScale(pp,1/W); //顶点的平均坐标
  for i:=0 to W-1 do begin
    pa:=cgVecSub(Dot,   p[i]);
    pb:=cgVecSub(p[i+1],p[i]);
    pc:=cgVecSub(pp,    p[i]);
    na:=cgCrossProduct(pa,pb); nb:=cgCrossProduct(pc,pb);
    if cgDotProduct(na,nb)<-0.0001 then begin result:=false; exit; end;
    end;
end;

//判断两线段是否相交
function cgTowLineCanCross( p1,p2,p3,p4, nor :TcgVector):boolean; //nor:俩线段所在平面的法线
  var aa,bb :boolean;    
      na,nb,nc :TcgVector;
begin
  na:=cgVecSub(p1,p3);  nb:=cgVecSub(p2,p3);  nc:=cgVecSub(p3,p4);
  aa:=cgDotProduct(cgCrossProduct(na,nc), cgCrossProduct(nb,nc))<=0;

  na:=cgVecSub(p1,p4);  nb:=cgVecSub(p1,p3);  nc:=cgVecSub(p1,p2);
  bb:=cgDotProduct(cgCrossProduct(na,nc), cgCrossProduct(nb,nc))<=0;
  result:= aa and bb;
end;
//直线与平面的交点
function cgLinePlaneCross( pL,vL, pP,vP:TcgVector; var p :TcgVector):boolean;
  var t:single;  //pL,vL 直线上的点和向量 pP,vP 平面上的点和向量
begin
  t:=cgDotProduct(vL,vP);  //俩向量的数量积
  result:=abs(t)>0.0000001;
  if result then p:=cgVecAddMult(pL,vL,-(cgDotProduct(pL,vP)+vP.w)/t)
            else p:=pL;
end;
//四边形与无限平面之交惯线
function cgPlaneCross( p1,p2,p3,p4, pP,vP:TcgVector; var pa,pb:TcgVector):boolean;
  var i:integer;  bb:boolean; pc,vL:TcgVector;
begin i:=0;
  vL:=cgVecSub(p1,p2); //第一条边的向量
  bb:=cgLinePlaneCross(p1,vL, pP,vP, pc);
  if bb then begin
    bb:=cgDotInBox(pc, p1,p2);  pc.w:=0;
    if bb then begin pa:=pc; inc(i); end; //第一个交点
    end;
  vL:=cgVecSub(p2,p3); //第二条边的向量
  bb:=cgLinePlaneCross(p2,vL, pP,vP, pc);
  if bb then begin
    bb:=cgDotInBox(pc, p2,p3);  pc.w:=1;
    if bb and(i>0) then bb:=not cgVecComp(pa,pc); //如果是第二个交点，是否重合
    if bb then begin if i=0 then pa:=pc else pb:=pc; inc(i); end;
    end;
  if i<2 then begin //如果前面没找到或只找到一个交点
    vL:=cgVecSub(p3,p4);
    bb:=cgLinePlaneCross(p3,vL, pP,vP, pc);
    if bb then begin
      bb:=cgDotInBox(pc, p3,p4);  pc.w:=2;
      if bb and(i>0) then bb:=not cgVecComp(pa,pc); //如果是第二个交点，是否重合
      if bb then begin if i=0 then pa:=pc else pb:=pc; inc(i); end;
      end;
    end;
  if(i=1)then begin //如果前面找到一个交点
    vL:=cgVecSub(p1,p4);
    bb:=cgLinePlaneCross(p1,vL, pP,vP, pc);
    if bb then begin
      bb:=cgDotInBox(pc, p1,p4);  pc.w:=3;
      if bb then bb:=not cgVecComp(pa,pc); //是否重合
      if bb then pb:=pc;
      end;
    end;
  result:= (not bb) or cgVecComp(pa,pb);
end;
//两圆之切线
function cgTowCircleTangent( pa,na,pb,nb:TcgVector; aR,bR,L:single;
          var p0,p1:TcgVector; var isSegment:boolean; Inner,Exchange:boolean):boolean;//两圆之切线
  var t,rA,rR :single;   nc,np,pc :TcgVector;
begin
  isSegment:=false;
  t:=-cgDotProduct(na, pb)- na.w;
  pb:=cgVecAddMult(pb, na, t);//第二圆心在第一圆平面上的投影
  nc:=cgVecSub(pb,pa); cgNormalize(nc);
  np:=cgCrossProduct(na,nc);//俩圆心连线与法线之公垂线
  rA:=cgDistance(pa,pb);//俩圆心之距离
  result:=EP(rA) or (Inner)and((aR+bR)>rA) or ((rA+bR)<aR) or ((rA+aR)<bR);
  if result then exit;
  if Inner then begin //内切线
    if EP(rA-aR-bR)then begin //两圆外切时的内切线
      t:=(aR*rA)/(aR+bR);
      p0:=cgVecAddMult(pa,nc,t);  p1:=cgVecSubMult(p0,np,L);
      isSegment:=true;
      end
    else begin //内切
      rR:=halfPi-arcSin((aR+bR)/rA);
      t:=aR*cos(rR); pc:=cgVecAddMult(pa,nc,t);
      t:=aR*sin(rR); if Exchange then t:=-t;  p0:=cgVecAddMult(pc,np,t);
      t:=bR*cos(rR); pc:=cgVecSubMult(pb,nc,t);
      t:=bR*sin(rR); if Exchange then t:=-t;  p1:=cgVecSubMult(pc,np,t);
      end;
    end
  else begin //外切线
    if(aR>bR)and EP(aR-rA-bR)then begin //两圆内切
      p0:=cgVecAddMult(pa,nc,aR); p1:=cgVecAddMult(p0,np,L);
      isSegment:=true;
      end
    else if(aR<bR)and EP(bR-rA-aR)then begin //两圆内切
      p0:=cgVecSubMult(pa,nc,aR); p1:=cgVecAddMult(p0,np,L);
      isSegment:=true;
      end
    else begin
      rR:=(aR-bR)/rA;
      t:=aR*rR;  pc:=cgVecAddMult(pa,nc,t);
      t:=sqrt(sqr(aR)-sqr(t)); if Exchange then t:=-t;
      p0:=cgVecAddMult(pc,np,t);
      t:=bR*rR;  pc:=cgVecAddMult(pb,nc,t);
      t:=sqrt(sqr(bR)-sqr(t)); if Exchange then t:=-t;
      p1:=cgVecAddMult(pc,np,t);
      end;
    end;
end;

function cgCheckSide( p, p1,p2 :TcgVector; i:integer):integer;//p点 p1,p2线段
  var t:double;
begin result:=0; //判断两点是否位于线段同侧  (y-y1)(x2-x1)-(x-x1)(y2-y1)=0
  if i=1 then t:=(p.y-p1.y)*(p2.x-p1.x)-(p.x-p1.x)*(p2.y-p1.y);
  if i=2 then t:=(p.z-p1.z)*(p2.x-p1.x)-(p.x-p1.x)*(p2.z-p1.z);
  if i=3 then t:=(p.y-p1.y)*(p2.z-p1.z)-(p.z-p1.z)*(p2.y-p1.y);
  if t>EPS then result:=1 else if t<-EPS then result:=-1 else result:=0;
  end;
//=======平面凸壳  ======================
function cgShell(out Vct:array of TcgVector; M:integer):integer;
  type  TPos=Record i:integer; r:single; b:boolean; end;//用于凸壳
  var a,b,i,j,k,N :integer;  kx,ky,kz, dx,dy :single;
      pa,pb,pc, Vec:array of TcgVector;  p:array of TPos;
  procedure Swap( var p0,p1:TPos); //交换顶点位置
    var pp:TPos; begin pp:=p0; p0:=p1; p1:=pp; end;
begin //用格雷厄姆算法计算凸壳
  setLength(p,M+1);  setLength(Vec,M+1);
  for i:=0 to 2 do begin Vec[i]:=Vct[i]; Vec[i].x:=0; end; //判断点集相对平行面
  kx:=cgTriangleArea(Vec[0],Vec[1],Vec[2]);
  for i:=0 to 2 do begin Vec[i]:=Vct[i]; Vec[i].y:=0; end;
  ky:=cgTriangleArea(Vec[0],Vec[1],Vec[2]);
  for i:=0 to 2 do begin Vec[i]:=Vct[i]; Vec[i].z:=0; end;
  kz:=cgTriangleArea(Vec[0],Vec[1],Vec[2]);

  if(kz>kx)and(kz>ky)then
    for i:=0 to M do Vec[i]:=cgVector( Vct[i].x, Vct[i].y, 0);
  if(ky>kx)and(ky>kz)then
    for i:=0 to M do Vec[i]:=cgVector( Vct[i].x, Vct[i].z, 0);
  if(kx>ky)and(kx>kz)then
    for i:=0 to M do Vec[i]:=cgVector( Vct[i].y, Vct[i].z, 0);
  dy:=1000;
  for i:=0 to M do begin  //第一个凸点
    p[i].i:=i;  p[i].b:=false;
    if Vec[i].y<dy then begin dy:=Vec[i].y; k:=i; end;
    end;
  Swap(p[0],p[k]);  p[0].b:=true;  p[0].r:=0; //
  for i:=1 to M do begin //各顶点与第一个凸点连线的仰角
    dx:=Vec[p[i].i].X-Vec[p[0].i].X;  dy:=Vec[p[i].i].y-Vec[p[0].i].y;
    if EP(dx) then p[i].r:=Pi/2
    else begin p[i].r:=arcTan(abs(dy/dx)); if dx<0 then p[i].r:=Pi-p[i].r; end;
    end;

  for i:=2 to M do begin //用“直接插入排序法”将各顶点按仰角排序
    j:=i;
    while(j>=2)and(p[j].r<p[j-1].r)do
      begin swap(p[j],p[j-1]);  dec(j); end;
    end;
  p[1].b:=true; p[M].b:=true; //第二个凸点，最后一个凸点
  i:=1;
  while(i<(M-1))do begin //凸点甄别
    k:=i+1;
    a:=cgCheckSide( Vec[p[0].i], Vec[p[i].i],Vec[p[k].i], 1);
    for j:=k+1 to M do
      if EP(p[i].r-p[k].r)then begin
        if cgDistance(Vec[p[0].i],Vec[p[i].i])>=cgDistance(Vec[p[0].i],Vec[p[k].i])
          then k:=j;
        end
      else begin
        b:=cgCheckSide( Vec[p[j].i], Vec[p[i].i],Vec[p[k].i], 1);
        if a*b<0 then begin
          k:=j; a:=cgCheckSide( Vec[p[0].i], Vec[p[i].i],Vec[p[k].i], 1);
          end;
      end;
    p[k].b:=true;
    i:=k;
    end;
  for i:=0 to M do Vec[i]:=Vct[i];
  N:=0;
  for i:=0 to M do if p[i].b then //连接凸点
    begin Vct[N]:=Vec[p[i].i]; inc(N);  end;
  result:=N;
  setLength(p,0);  setLength(Vec,0);
end;
//========== 俩圆的交点 ================
function cgTowCircleCross(pa,pb, Normal:TcgVector; La,Lb:double; var px,py:TcgVector):integer;//两圆交点
  var aa,bb,cc, t,x,aR,bR :double; dn,pc,nc:TcgVector;
begin result:=2;
  aa:=abs(La);  bb:=abs(Lb);  //两圆之半径
  EPS:=0.00001;
  cc:=cgDistance(pa,pb);  if cc<EPS then begin result:=0; exit; end; //两圆心之间距
  if EP(cc-aa)then cc:=aa
  else if EP(cc-bb)then cc:=bb
  else if EP(bb-aa-cc)then cc:=bb-aa;
  if((cc-(aa+bb))>EPS) or ((aa-(bb+cc))>EPS) or ((bb-(aa+cc))>EPS)then
    begin result:=0; exit; end;
  if EP(cc-(aa+bb))then begin //两圆相切
    dn:=cgNormalvec(pb,pa);
    px:=cgVecAddMult(pa,dn, La);  py:=px;
    end
  else begin
    aR:=sqr(aa); bR:=sqr(bb);
    t:=(-bR+aR+cc*cc)/(2*aa*cc); // cosA=(-a*a+b*b+c*c)/(2*b*c)
    x:=aa*t;
    dn:=cgVecSub(pb,pa);
    pc:=cgVecAddMult(pa,dn,x/cc); //圆心连线与交点连线之交点

    nc:=cgCrossProduct(Normal,dn); //交点连线之向量
    t:=sqrt(abs(aR-x*x))/cc;
    px:=cgVecSubMult(pc,nc,t);    py:=cgVecAddMult(pc,nc,t);
    end;
  EPS:=0.00000001;  
end;
//========== 俩直线的交点 ================
function cgTowLineCross2( pA,pB, vA,vB:TcgVector ):TcgVector; //pa,pb 两直线端点 aa,bb两直线的向量
  var nA :TcgVector;
begin
  nA:=cgCrossProduct(vA,vB);
  nA:=cgCrossProduct(vA,nA);  nA.w:=-cgDotProduct(pA,nA);
  cgLinePlaneCross(pB,vB, pA,nA, result);
end;
function cgTowLineCross( One,Tow, vA,vB:TcgVector ):TcgVector; //One,Tow 两直线端点 aa,bb两直线的向量
  var t :single;  X,Y,Z :single;  M,N,P, A,B,C :single;
begin
  M:=va.x;  A:=vb.x;  X:=Tow.x-One.x;
  N:=va.y;  B:=vb.y;  Y:=Tow.y-One.y;
  P:=va.z;  C:=vb.z;  Z:=Tow.z-One.z;
  t:=cgDeterminant2D(A,B, M,N);
  if not EP(t) then
    t:=cgDeterminant2D(A,B, X,Y)/t
  else begin
    t:=cgDeterminant2D(A,C, M,P);
    if not EP(t) then
      t:=cgDeterminant2D(A,C, X,Z)/t
    else begin
      t:=cgDeterminant2D(C,B, P,N);
      if not EP(t) then t:=cgDeterminant2D(C,B, Z,Y)/t;
      end;
    end;
  result:=cgVecAddMult(One,va,t);
end;

function cgDeterminant2D( a1,b1,a2,b2:single) :single; assembler;
asm  //二阶行列式的值 a1*b2-a2*b1
  fld a1
  fmul b2
  fld a2
  fmul b1

  fsubp
  fstp Result
end;

function cgDeterminant3D(a1,b1,c1, a2,b2,c2, a3,b3,c3 :single) :single;
begin //三阶行列式的值
  result:= a1*cgDeterminant2D(b2,c2,b3,c3)
          -a2*cgDeterminant2D(b1,c1,b3,c3)
          +a3*cgDeterminant2D(b1,c1,b2,c2);
end;
function cgDeterminant3D1( a,b,c :TcgVector) :single;
begin //三阶行列式的值
  result:= a.x*cgDeterminant2D(b.y, c.y, b.z, c.z)
          -a.y*cgDeterminant2D(b.x, c.x, b.z, c.z)
          +a.z*cgDeterminant2D(b.x, c.x, b.y, c.y);
end;
//屏幕平面上两点之间距
function cgDistance2D(x,y:integer; pp:TcgVector):single; 
  begin result:=sqrt(sqr(y-pp.y)+sqr(x-pp.x)); end;
//三角形面积
function cgTriangleArea(pa,pb,pc :TcgVector):single;
  var p, v1,v2:TcgVector; 
begin
  v1:=cgVecSub(pa, pb);  v2:=cgVecSub(pa, pc);
  p:=cgCrossProduct(v1,v2);
  result:=cgVecLength(p)/2;
end;
//======================= 公垂线 =============================
procedure cgPublicVerticalLine(pA,vA, pB,vB:TcgVector; var p0,p1,vC:TcgVector);
  var vP:TcgVector;
begin
  vC:=cgCrossProduct(vA,vB);
  vP:=cgCrossProduct(vA,vC);  vP.w:=-cgDotProduct(pA,vP);
  cgLinePlaneCross(pB,vB, pA,vP, p0);
  vP:=cgCrossProduct(vB,vC);  vP.w:=-cgDotProduct(pB,vP);
  cgLinePlaneCross(pA,vA, pB,vP, p1);
  cgNormalize(vC);
end;
//====== 线段上距给定点最近的点 =============
function cgDotNearestLine(Dot, pa,pb:TcgVector):TcgVector;
  var pU,pV:TcgVector;  t:single;
begin
  pU:=cgVecSub(pa, Dot); pV:=cgNormalVec(pa,pb); //pV.w 线段长度
  t:=-cgDotProduct(pV, pU);
  result:=cgVecAddMult(pa,pV, t);    //垂点
  pa.w:=cgDistance( pa, result);
  pb.w:=cgDistance( pb, result);
  if(pa.w>pV.w)or(pb.w>pV.w)then begin
    if(pa.w<pb.w)then result:=pa else result:=pb;
    end;
  result.w:=cgDistance(Dot, result);
end;
//====== 点在直线上的垂足 =============
function cgDotLineFooter(Dot, pa,na:TcgVector; bDistance:boolean):TcgVector;
  var pb,dV:TcgVector;  t:single;
begin
  pb:=cgVecAddMult(pa,na,1);
  if cgDotAtLine(Dot, pa,pb) then
    begin result:=Dot; result.w:=0; end
  else begin // 投影到直线
    dV:=cgVecSub(pa, Dot);
    t:=-cgDotProduct(na, dV);
    result:=cgVecAddMult(pa,na, t);
    if bDistance then result.w:=cgDistance(Dot, result);
    end;
end;
//======================= 直线上的垂点 =======================
function cgFooterAtLine(Dot, pa,pb:TcgVector; var pt:TcgVector; atLine:boolean):boolean;
  var pv:TcgVector; t:single; //atLine:检验垂足是否位于线段内
begin
  if cgDotAtLine(Dot,pa,pb)then
    pt:=Dot
  else begin
    pv:=cgNormalVec(pa,pb);
    t:=-cgDotProduct(pv, cgVecSub(pa, Dot));
    pt:=cgVecAddMult(pa, pv, t); //垂点
    end;
  if atLine then result:=cgDotInLine2D(pt, pa,pb) else result:=true;
end;

function cgDotInLine2D( p0, p1,p2 :TcgVector):boolean;//是否线段内的点
begin //只考虑二维坐标
result:=((p0.x>=p1.x)and(p0.x<=p2.x)or(p0.x<=p1.x)and(p0.x>=p2.x))
     and((p0.y>=p1.y)and(p0.y<=p2.y)or(p0.y<=p1.y)and(p0.y>=p2.y));
     //and((p0.z>=p1.z)and(p0.z<=p2.z)or(p0.z<=p1.z)and(p0.z>=p2.z));
end;

function cgNormalVec(v1,v2:TcgVector):TcgVector;
begin //返回格式化的向量
  result:=cgVecSub(v1,v2);  cgNormalize(result);
  if EP(result.w) then result:=cgVector(0,0,1);
end;

//======================== 平面法向量 ===========================
function cgPlaneNormal( p0,p1,p2,p3 :TcgVector; Normal:boolean) :TcgVector;
  var n1,n2,n3,n4,n5 :TcgVector;
begin
  n1:=cgVecSub(p1,p0);  n2:=cgVecSub(p2,p1);
  n3:=cgVecSub(p3,p2);  n4:=cgVecSub(p2,p0);  n5:=cgVecSub(p0,p3);
  if cgComp(n1) then n1:=n3 else
  if cgComp(n2) then n2:=n3 else
  if cgComp(n4) then n2:=n5;
  result:=cgCrossProduct(n1,n2);
  if Normal then cgNormalize(result);
end;

function cgSolution(var t :single; a,b,c :single; bb:boolean) :boolean;
  var d :single; //
begin //二元一次方程式的解
  d:= b*b-4*a*c; //判别式
  result:= (d>=0);
  if result then begin
    if bb then t:=(-b-sqrt(d))/(2*a) else t:=(-b+sqrt(d))/(2*a);
    end
  else t:=-1000;
end;
//====================== 俩平面的交惯线 =============================
function cgPlaneSection(pa,na, pb,nb:TcgVector; var pp,nc:TcgVector):boolean;
  var pc,np:TcgVector;
begin
  np:=nb;  cgInvertVec(np);
  result:=cgVecComp(na,nb) or cgVecComp(na,np); //平行
  if Result then exit;
  pc:=pp;  //公垂面上的点
  nc:=cgCrossProduct(na,nb); cgNormalize(nc); //公垂面的法线
  np:=cgCrossProduct(nc,na); //与相贯线垂直的向量
  cgLinePlaneCross(pa,np, pb,nb, pp); //pp交点
  pp:=cgDotLineFooter(pc, pp,nc, true);
end;
//========== 四点是否共面 ================
function cgForePointInOnePlane( p1,p2,p3,p4 :TcgVector ):boolean;
  var t :single;
begin
  t:=cgDeterminant3D(p2.x-p1.x, p2.y-p1.y, p2.z-p1.z,
                     p3.x-p1.x, p3.y-p1.y, p3.z-p1.z,
                     p4.x-p1.x, p4.y-p1.y, p4.z-p1.z);
  result:= abs(t)>0.01;
end;
//计算三点圆的圆心
function cgCenter( pa,pb,pc:TcgVector; var Cen,Nor:TcgVector; H:integer):boolean;
  var ac,bc, aa,bb, cc, na,nb,nc :TcgVector;       //Cen:圆心 H:0外心1内心2重心3垂心
begin
  result:= cgDotAtLine(pa,pb,pc); //三点共线则返回true
//
  if result then begin
    Cen:=cgVector((pa.x+pb.x+pc.x)/3,(pa.y+pb.y+pc.y)/3,(pa.z+pb.z+pc.z)/3);
    Cen.w:=999;
    exit;
    end;
  if(H<0)or(H>3)then H:=0;
  if(H=0)then begin //外心
    Nor:=cgGetNormal( pa, pb, pc );  //计算法线向量
    aa:=cgVecSub(pb,pa);  ac:=cgVecMid(pa,pb);
    bb:=cgVecSub(pb,pc);  bc:=cgVecMid(pc,pb);  //向量和中点

    cc:=cgCrossProduct(aa,Nor); //中垂线
    bb.w:=-cgDotProduct(bb,bc);
    cgLinePlaneCross(ac,cc, bc,bb, Cen);
    Cen.w:= cgDistance(pa, Cen); //半径
    if Cen.w>999 then Cen.w:=999;
    end;
  if(H=1)then begin //内心(角平分线之交点)
    Nor:=cgGetNormal( pa, pb, pc );  //计算法线向量
    nc:=cgNormalVec(pb,pa);
    na:=cgVecAdd( nc, cgNormalVec(pc,pa));
    nb:=cgVecAdd( nc, cgNormalVec(pb,pc));
    Cen:=cgTowLineCross2(pa,pb, na,nb);
    aa:= cgDotLineFooter(Cen, pa,nc, true);
    Cen.w:=aa.w;
    end;
  if(H=2)then begin //重心(中线之交点)
    na:=cgVecSub( cgVecMid(pb,pc), pa);
    nb:=cgVecSub( cgVecMid(pa,pc), pb);
    Cen:=cgTowLineCross2( pa,pb, na,nb);
    end;
  if(H=3)then begin //垂心(垂线之交点)
    na:=cgVecSub( pa, cgDotLineFooter( pa, pb,cgNormalVec(pb,pc), false));
    nb:=cgVecSub( pb, cgDotLineFooter( pb, pa,cgNormalVec(pa,pc), false));
    Cen:=cgTowLineCross2( pa,pb, na,nb);
    end;
end;
//================= 反演变换 ===========================
function cgInversion(pp,Dot:TcgVector; k:single; vert:boolean):TcgVector;//pp反演中心
  var aR:single;  np:TcgVector;
begin //
  aR:=cgDistance(pp,Dot);
  if EP(aR)or EP(k) then result:=pp
  else begin
    np:=cgNormalVec(Dot,pp);  if vert then cgInvertVec(np);
    result:=cgVecAddMult(pp,np, k*k/aR);
    end;
  result.w:=aR;
end;
//================= 矩形点法面 ======================
function cgGetRectangle(pp,Nor:TcgVector; L,R:single; var pa,pb,pc,pd:TcgVector):boolean;
  var vA,vB,vC, lA,lB,lC :single; cc,pn:TcgVector;
begin result:=false;
  vA:=Nor.x; vB:=Nor.y; vC:=Nor.z;  //法向量
  lA:=cgModelLength(vA,vB,0); // lA:=sqrt(vA*vA+vB*vB); //法线在XOY平面上的投影
  if EP(lA)then begin  //法线平行于Z轴
    pa:=cgVector( -L/2, -R/2, 0);   pb:=cgVector( pa.x,-pa.y, 0);
    pc:=cgVector(-pa.x,-pa.y, 0);   pd:=cgVector(-pa.x, pa.y, 0);
    end
  else begin //
    lB:=cgModelLength(lA,vC,0); //法线长度
    result:=EP(lB); if result then exit;
    pn:=cgVector( L/2*vB/lA, -L/2*vA/lA, 0);
    lC:=R/2*vC/lB/lA;
    cc:=cgVector( lC*vA, lC*vB,-R/2*lA/lB);
    //上面是以原点为中心的菱形，下面转换成矩形
    pa:=cgVector( pn.x+cc.x,  pn.y+cc.y,  cc.z);
    pb:=cgVector( pn.x-cc.x,  pn.y-cc.y, -cc.z);
    pc:=cgVector(-pn.x-cc.x, -pn.y-cc.y, -cc.z);
    pd:=cgVector(-pn.x+cc.x, -pn.y+cc.y,  cc.z);
    end;
  //平移到基点
  cgTranslate(pa,pp);  cgTranslate(pb,pp);
  cgTranslate(pc,pp);  cgTranslate(pd,pp);
end;
//================= 直线和圆的交点 ======================
function cgLineCircleCross(pa,na, pb:TcgVector; R:single; var px,py:TcgVector):integer;
  var t:single; pp:TcgVector;
begin
  pp:=cgDotLineFooter(pb, pa,na, true); //圆心在直线上的垂点
  t:=pp.w-R;
  if(t>EPS)then result:=0
  else begin
    if EP(t)then t:=0 else t:=sqrt(sqr(R)-sqr(pp.w));//垂足到交点的距离
    px:=cgVecSubMult(pp,na,t);
    py:=cgVecAddMult(pp,na,t);
    result:=2;
    end;
end;
//================= 平面上的垂足 ======================
function cgDotPlaneFooter(Dot, pa,pn:TcgVector):TcgVector;
  var t:single;
begin
  pn.w:=-cgDotProduct(pn,pa);
  t:=-cgDotProduct(pn, Dot)- pn.w;
  result:=cgVecAddMult(Dot, pn, t);
end;
//================= 直角坐标转换为球坐标 =====================
procedure cgXYZtoAngle(X,Y,Z:single; var m,n,R:single; is3D:boolean);
begin
  R:=sqrt(X*X+Y*Y);
  if EP(R)then begin
    if(X>=0)then m:=0 else m:=Pi;
    end
  else begin
    m:=arcCos(abs(X)/R);  //Tx转角 Ry半径
    if(X<0)and(Y>=0)then m:=Pi-m;
    if(X>=0)and(Y<0)then m:=2*Pi-m;
    if(X<0)and(Y<0)then m:=Pi+m;
    end;
  if is3D then begin
    R:=sqrt(Z*Z+R*R);
    if EP(R)then n:=0 else n:=arcSin(Z/R);
    end;
end;
//================= 球坐标转换为直角坐标 =====================
procedure cgAngleToXYZ( R,m,n:single; var X,Y,Z:single; is3D:boolean);
begin
  X:=R*cos(n)*cos(m);
  Y:=R*cos(n)*sin(m);
  if is3D then Z:=R*sin(n);
end;

end.

