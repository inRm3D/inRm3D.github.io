(*++ 
    Procedure declarations, constant definitions and macros for the OpenGL
    Utility Library.
--*)

(*
** Return the error string associated with a particular error code.
** This will return 0 for an invalid error code.
**
** The generic function prototype that can be compiled for ANSI or Unicode
** is defined as follows:
**
** LPCTSTR APIENTRY gluErrorStringWIN (GLenum errCode);
*)

unit GLu;

interface

uses
  GL;

{$INCLUDE GLDRIVER.INC}

const
  {$IFDEF SGIGL}
    GLUDLL = 'GLU.DLL';
  {$ELSE}
    {$IFDEF 3DFXGL}
      GLUDLL = '';   //*** 3dfx does not have a GLU library!!!
    {$ELSE}
      GLUDLL = 'GLU32.DLL';
    {$ENDIF}
  {$ENDIF}

type
  TViewPortArray = array [0..3] of GLint;
  T16dArray = array [0..15] of GLdouble;
  TCallBack = procedure;
  T3dArray = array [0..2] of GLdouble;
  T4pArray = array [0..3] of Pointer;
  T4fArray = array [0..3] of GLfloat;
  PPointer = ^Pointer;

function gluErrorString(errCode: GLenum): PGLubyte;
                      stdcall; external GLUDLL;
function gluErrorUnicodeStringEXT(errCode: GLenum): PWideChar;
                      stdcall; external GLUDLL;
function gluGetString(name: GLenum): PGLubyte;
                      stdcall; external GLUDLL;
procedure gluOrtho2D(left,right, bottom, top: GLdouble);
                      stdcall; external GLUDLL;
procedure gluPerspective(fovy, aspect, zNear, zFar: GLdouble);
                      stdcall; external GLUDLL;
procedure gluPickMatrix(x, y, width, height: GLdouble; viewport: TViewPortArray);
                      stdcall; external GLUDLL;
procedure gluLookAt(eyex, eyey, eyez, centerx, centery, centerz, upx, upy, upz: GLdouble);
                      stdcall; external GLUDLL;
function gluProject(objx, objy, objz: GLdouble; const modelMatrix, projMatrix: T16dArray;
                    viewport: TViewPortArray; winx, winy, winz: PGLdouble): Integer;
                      stdcall; external GLUDLL;
function gluUnProject(winx, winy, winz: GLdouble; const modelMatrix, projMatrix: T16dArray;
                      viewport: TViewPortArray; objx, objy, objz: PGLdouble): Integer;
                      stdcall; external GLUDLL;
function gluScaleImage(format: GLenum; widthin, heightin: GLint; typein: GLenum;
                       const datain: Pointer; widthout, heightout: GLint; typeout: GLenum;
                       dataout: Pointer): Integer;
                      stdcall; external GLUDLL;
function gluBuild1DMipmaps(target: GLenum; components, width: GLint; format,
                           atype: GLenum; const data: Pointer): Integer;
                      stdcall; external GLUDLL;
function gluBuild2DMipmaps(target: GLenum; components, width, height: GLint; format,
                           atype: GLenum; const data: Pointer): Integer;
                      stdcall; external GLUDLL;

type
  GLUnurbs = record end;                PGLUnurbs = ^GLUnurbs;
  GLUquadric = record end;              PGLUquadric = ^GLUquadric;
  GLUtesselator = record end;           PGLUtesselator = ^GLUtesselator;

  // backwards compatibility:
  GLUnurbsObj = GLUnurbs;               PGLUnurbsObj = PGLUnurbs;
  GLUquadricObj = GLUquadric;           PGLUquadricObj = PGLUquadric;
  GLUtesselatorObj = GLUtesselator;     PGLUtesselatorObj = PGLUtesselator;
  GLUtriangulatorObj = GLUtesselator;   PGLUtriangulatorObj = PGLUtesselator;

function gluNewQuadric: PGLUquadric;
                      stdcall; external GLUDLL;
procedure gluDeleteQuadric(state: PGLUquadric);
                      stdcall; external GLUDLL;
procedure gluQuadricNormals(quadObject: PGLUquadric; normals: GLenum);
                      stdcall; external GLUDLL;
procedure gluQuadricTexture(quadObject: PGLUquadric; textureCoords: GLboolean);
                      stdcall; external GLUDLL;
procedure gluQuadricOrientation(quadObject: PGLUquadric; orientation: GLenum);
                      stdcall; external GLUDLL;
procedure gluQuadricDrawStyle(quadObject: PGLUquadric; drawStyle: GLenum);
                      stdcall; external GLUDLL;
procedure gluCylinder(qobj: PGLUquadric; baseRadius, topRadius, height: GLdouble;
                      slices, stacks: GLint);
                      stdcall; external GLUDLL;
procedure gluDisk(qobj: PGLUquadric; innerRadius, outerRadius: GLdouble;
                  slices, loops: GLint);
                      stdcall; external GLUDLL;
procedure gluPartialDisk(qobj: PGLUquadric; innerRadius, outerRadius: GLdouble;
                         slices, loops: GLint; startAngle, sweepAngle: GLdouble);
                      stdcall; external GLUDLL;
procedure gluSphere(qobj: PGLuquadric; radius: GLdouble; slices, stacks: GLint);
                      stdcall; external GLUDLL;
procedure gluQuadricCallback(qobj: PGLUquadric; which: GLenum; fn: TCallBack);
                      stdcall; external GLUDLL;
function gluNewTess: PGLUtesselator;
                      stdcall; external GLUDLL;
procedure gluDeleteTess(tess: PGLUtesselator);
                      stdcall; external GLUDLL;
procedure gluTessBeginPolygon(tess: PGLUtesselator; polygon_data: Pointer);
                      stdcall; external GLUDLL;
procedure gluTessBeginContour(tess: PGLUtesselator);
                      stdcall; external GLUDLL;
procedure gluTessVertex(tess: PGLUtesselator; coords: T3dArray; data: Pointer);
                      stdcall; external GLUDLL;
procedure gluTessEndContour(tess: PGLUtesselator);
                      stdcall; external GLUDLL;
procedure gluTessEndPolygon(tess: PGLUtesselator);
                      stdcall; external GLUDLL;
procedure gluTessProperty(tess: PGLUtesselator; which: GLenum; value: GLdouble);
                      stdcall; external GLUDLL;
procedure gluTessNormal(tess: PGLUtesselator; x, y, z: GLdouble);
                      stdcall; external GLUDLL;
procedure gluTessCallback(tess: PGLUtesselator; which: GLenum;fn: TCallBack);
                      stdcall; external GLUDLL;
procedure gluGetTessProperty(tess: PGLUtesselator; which: GLenum; value: PGLdouble);
                      stdcall; external GLUDLL;
function gluNewNurbsRenderer: PGLUnurbs;
                      stdcall; external GLUDLL;
procedure gluDeleteNurbsRenderer(nobj: PGLUnurbs);
                      stdcall; external GLUDLL;
procedure gluBeginSurface(nobj: PGLUnurbs);
                      stdcall; external GLUDLL;
procedure gluBeginCurve(nobj: PGLUnurbs);
                      stdcall; external GLUDLL;
procedure gluEndCurve(nobj: PGLUnurbs);
                      stdcall; external GLUDLL;
procedure gluEndSurface(nobj: PGLUnurbs);
                      stdcall; external GLUDLL;
procedure gluBeginTrim(nobj: PGLUnurbs);
                      stdcall; external GLUDLL;
procedure gluEndTrim(nobj: PGLUnurbs);
                      stdcall; external GLUDLL;
procedure gluPwlCurve(nobj: PGLUnurbs; count: GLint; aarray: PGLfloat; stride: GLint;
                      atype: GLenum);
                      stdcall; external GLUDLL;
procedure gluNurbsCurve(nobj: PGLUnurbs; nknots: GLint; knot: PGLfloat; stride: GLint;
                        ctlarray: PGLfloat; order: GLint; atype: GLenum);
                      stdcall; external GLUDLL;
procedure gluNurbsSurface(nobj: PGLUnurbs; sknot_count: GLint; sknot: PGLfloat;
                          tknot_count: GLint; tknot: PGLfloat; s_stride, t_stride: GLint;
                          ctlarray: PGLfloat; sorder, torder: GLint; atype: GLenum);
                      stdcall; external GLUDLL;
procedure gluLoadSamplingMatrices(nobj: PGLUnurbs; const modelMatrix, projMatrix:
                                  T16dArray; viewport: TViewPortArray);
                      stdcall; external GLUDLL;
procedure gluNurbsProperty(nobj: PGLUnurbs; aproperty: GLenum; value: GLfloat);
                      stdcall; external GLUDLL;
procedure gluGetNurbsProperty(nobj: PGLUnurbs; aproperty: GLenum; value: PGLfloat);
                      stdcall; external GLUDLL;
procedure gluNurbsCallback(nobj: PGLUnurbs; which: GLenum; fn: TCallBack);
                      stdcall; external GLUDLL;


(****           Callback function prototypes    ****)

type
  // gluQuadricCallback
  GLUquadricErrorProc = procedure(p: GLenum);

  // gluTessCallback
  GLUtessBeginProc = procedure(p: GLenum); stdcall;
  GLUtessEdgeFlagProc = procedure(p: GLboolean); stdcall;
  GLUtessVertexProc = procedure(p: Pointer); stdcall;
  GLUtessEndProc = procedure; stdcall;
  GLUtessErrorProc = procedure(p: GLenum); stdcall;
  GLUtessCombineProc = procedure(p1: T3dArray; p2: T4pArray; p3: T4fArray; p4: PPointer); stdcall;
  GLUtessBeginDataProc = procedure(p1: GLenum; p2: Pointer); stdcall;
  GLUtessEdgeFlagDataProc = procedure(p1: GLboolean; p2: Pointer); stdcall;
  GLUtessVertexDataProc = procedure(p1, p2: Pointer); stdcall;
  GLUtessEndDataProc = procedure(p: Pointer); stdcall;
  GLUtessErrorDataProc = procedure(p1: GLenum; p2: Pointer); stdcall;
  GLUtessCombineDataProc = procedure(p1: T3dArray; p2: T4pArray; p3: T4fArray;
                                     p4: PPointer; p5: Pointer); stdcall;

  // gluNurbsCallback
  GLUnurbsErrorProc = procedure(p: GLenum);


//***           Generic constants               ****/

const
  // Version
  GLU_VERSION_1_1                 = 1;
  GLU_VERSION_1_2                 = 1;

  // Errors: (return value 0 = no error)
  GLU_INVALID_ENUM                = 100900;
  GLU_INVALID_VALUE               = 100901;
  GLU_OUT_OF_MEMORY               = 100902;
  GLU_INCOMPATIBLE_GL_VERSION     = 100903;

  // StringName
  GLU_VERSION                     = 100800;
  GLU_EXTENSIONS                  = 100801;

  // Boolean
  GLU_TRUE                        = GL_TRUE;
  GLU_FALSE                       = GL_FALSE;


  //***           Quadric constants               ****/

  // QuadricNormal
  GLU_SMOOTH              = 100000;
  GLU_FLAT                = 100001;
  GLU_NONE                = 100002;

  // QuadricDrawStyle
  GLU_POINT               = 100010;
  GLU_LINE                = 100011;
  GLU_FILL                = 100012;
  GLU_SILHOUETTE          = 100013;

  // QuadricOrientation
  GLU_OUTSIDE             = 100020;
  GLU_INSIDE              = 100021;

  // Callback types:
  //      GLU_ERROR       = 100103;


  //***           Tesselation constants           ****/

  GLU_TESS_MAX_COORD              = 1.0e150;

  // TessProperty
  GLU_TESS_WINDING_RULE           = 100140;
  GLU_TESS_BOUNDARY_ONLY          = 100141;
  GLU_TESS_TOLERANCE              = 100142;

  // TessWinding
  GLU_TESS_WINDING_ODD            = 100130;
  GLU_TESS_WINDING_NONZERO        = 100131;
  GLU_TESS_WINDING_POSITIVE       = 100132;
  GLU_TESS_WINDING_NEGATIVE       = 100133;
  GLU_TESS_WINDING_ABS_GEQ_TWO    = 100134;

  // TessCallback
  GLU_TESS_BEGIN          = 100100;    // void (CALLBACK*)(GLenum    type)
  GLU_TESS_VERTEX         = 100101;    // void (CALLBACK*)(void      *data)
  GLU_TESS_END            = 100102;    // void (CALLBACK*)(void)
  GLU_TESS_ERROR          = 100103;    // void (CALLBACK*)(GLenum    errno)
  GLU_TESS_EDGE_FLAG      = 100104;    // void (CALLBACK*)(GLboolean boundaryEdge)
  GLU_TESS_COMBINE        = 100105;    { void (CALLBACK*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut) }
  GLU_TESS_BEGIN_DATA     = 100106;    { void (CALLBACK*)(GLenum    type,
                                                            void      *polygon_data) }
  GLU_TESS_VERTEX_DATA    = 100107;    { void (CALLBACK*)(void      *data,
                                                            void      *polygon_data) }
  GLU_TESS_END_DATA       = 100108;    // void (CALLBACK*)(void      *polygon_data)
  GLU_TESS_ERROR_DATA     = 100109;    { void (CALLBACK*)(GLenum    errno,
                                                            void      *polygon_data) }
  GLU_TESS_EDGE_FLAG_DATA = 100110;    { void (CALLBACK*)(GLboolean boundaryEdge,
                                                            void      *polygon_data) }
  GLU_TESS_COMBINE_DATA   = 100111;    { void (CALLBACK*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut,
                                                            void      *polygon_data) }

  // TessError
  GLU_TESS_ERROR1     = 100151;
  GLU_TESS_ERROR2     = 100152;
  GLU_TESS_ERROR3     = 100153;
  GLU_TESS_ERROR4     = 100154;
  GLU_TESS_ERROR5     = 100155;
  GLU_TESS_ERROR6     = 100156;
  GLU_TESS_ERROR7     = 100157;
  GLU_TESS_ERROR8     = 100158;

  GLU_TESS_MISSING_BEGIN_POLYGON  = GLU_TESS_ERROR1;
  GLU_TESS_MISSING_BEGIN_CONTOUR  = GLU_TESS_ERROR2;
  GLU_TESS_MISSING_END_POLYGON    = GLU_TESS_ERROR3;
  GLU_TESS_MISSING_END_CONTOUR    = GLU_TESS_ERROR4;
  GLU_TESS_COORD_TOO_LARGE        = GLU_TESS_ERROR5;
  GLU_TESS_NEED_COMBINE_CALLBACK  = GLU_TESS_ERROR6;

  //***           NURBS constants                 ****/

  // NurbsProperty
  GLU_AUTO_LOAD_MATRIX            = 100200;
  GLU_CULLING                     = 100201;
  GLU_SAMPLING_TOLERANCE          = 100203;
  GLU_DISPLAY_MODE                = 100204;
  GLU_PARAMETRIC_TOLERANCE        = 100202;
  GLU_SAMPLING_METHOD             = 100205;
  GLU_U_STEP                      = 100206;
  GLU_V_STEP                      = 100207;

  // NurbsSampling
  GLU_PATH_LENGTH                 = 100215;
  GLU_PARAMETRIC_ERROR            = 100216;
  GLU_DOMAIN_DISTANCE             = 100217;


  // NurbsTrim
  GLU_MAP1_TRIM_2                 = 100210;
  GLU_MAP1_TRIM_3                 = 100211;

  // NurbsDisplay
  //      GLU_FILL                = 100012;
  GLU_OUTLINE_POLYGON             = 100240;
  GLU_OUTLINE_PATCH               = 100241;

  // NurbsCallback
  //      GLU_ERROR               = 100103;

  // NurbsErrors
  GLU_NURBS_ERROR1        = 100251;
  GLU_NURBS_ERROR2        = 100252;
  GLU_NURBS_ERROR3        = 100253;
  GLU_NURBS_ERROR4        = 100254;
  GLU_NURBS_ERROR5        = 100255;
  GLU_NURBS_ERROR6        = 100256;
  GLU_NURBS_ERROR7        = 100257;
  GLU_NURBS_ERROR8        = 100258;
  GLU_NURBS_ERROR9        = 100259;
  GLU_NURBS_ERROR10       = 100260;
  GLU_NURBS_ERROR11       = 100261;
  GLU_NURBS_ERROR12       = 100262;
  GLU_NURBS_ERROR13       = 100263;
  GLU_NURBS_ERROR14       = 100264;
  GLU_NURBS_ERROR15       = 100265;
  GLU_NURBS_ERROR16       = 100266;
  GLU_NURBS_ERROR17       = 100267;
  GLU_NURBS_ERROR18       = 100268;
  GLU_NURBS_ERROR19       = 100269;
  GLU_NURBS_ERROR20       = 100270;
  GLU_NURBS_ERROR21       = 100271;
  GLU_NURBS_ERROR22       = 100272;
  GLU_NURBS_ERROR23       = 100273;
  GLU_NURBS_ERROR24       = 100274;
  GLU_NURBS_ERROR25       = 100275;
  GLU_NURBS_ERROR26       = 100276;
  GLU_NURBS_ERROR27       = 100277;
  GLU_NURBS_ERROR28       = 100278;
  GLU_NURBS_ERROR29       = 100279;
  GLU_NURBS_ERROR30       = 100280;
  GLU_NURBS_ERROR31       = 100281;
  GLU_NURBS_ERROR32       = 100282;
  GLU_NURBS_ERROR33       = 100283;
  GLU_NURBS_ERROR34       = 100284;
  GLU_NURBS_ERROR35       = 100285;
  GLU_NURBS_ERROR36       = 100286;
  GLU_NURBS_ERROR37       = 100287;

//***           Backwards compatibility for old tesselator           ****/

procedure gluBeginPolygon(tess: PGLUtesselator);
                      stdcall; external GLUDLL;
procedure gluNextContour(tess: PGLUtesselator; atype: GLenum);
                      stdcall; external GLUDLL;
procedure gluEndPolygon(tess: PGLUtesselator);
                      stdcall; external GLUDLL;

const
  // Contours types -- obsolete!
  GLU_CW          = 100120;
  GLU_CCW         = 100121;
  GLU_INTERIOR    = 100122;
  GLU_EXTERIOR    = 100123;
  GLU_UNKNOWN     = 100124;

  // Names without "TESS_" prefix
  GLU_BEGIN       = GLU_TESS_BEGIN;
  GLU_VERTEX      = GLU_TESS_VERTEX;
  GLU_END         = GLU_TESS_END;
  GLU_ERROR       = GLU_TESS_ERROR;
  GLU_EDGE_FLAG   = GLU_TESS_EDGE_FLAG;

implementation

end.
