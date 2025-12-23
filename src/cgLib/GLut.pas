unit Glut;

interface

{$MACRO ON}

uses
  cgGL;

{$IFDEF MSWINDOWS}
  {$DEFINE GLUTCALL := stdcall}
{$ELSE}
  {$DEFINE GLUTCALL := cdecl}
{$ENDIF}

type
  PInteger = ^Integer;            // These two really suck, but I didn't see any
  PPChar = ^PChar;                // other or better way to solve the glutInit issue.
  TGlutVoidCallback = procedure; GLUTCALL;
  TGlut1IntCallback = procedure(value: Integer); GLUTCALL;
  TGlut2IntCallback = procedure(v1, v2: Integer); GLUTCALL;
  TGlut3IntCallback = procedure(v1, v2, v3: Integer); GLUTCALL;
  TGlut4IntCallback = procedure(v1, v2, v3, v4: Integer); GLUTCALL;
  TGlut1Char2IntCallback = procedure(c: Byte; v1, v2: Integer); GLUTCALL;

{$INCLUDE GLDRIVER.INC}

const
  {$IFDEF SGIGL}
    GLUTDLL = 'GLUT.DLL';
  {$ELSE}
    {$IFDEF 3DFXGL}
      GLUTDLL = '';   //*** There is no 3dfxOpenGL version of GLUT!
    {$ELSE}
      {$IFDEF MSWINDOWS}
        GLUTDLL = 'GLUT32.DLL';
      {$ELSE}
        GLUTDLL = 'glut';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  GLUT_API_VERSION                = 3;
  GLUT_XLIB_IMPLEMENTATION        = 12;
  // Display mode bit masks.
  GLUT_RGB                        = 0;
  GLUT_RGBA                       = GLUT_RGB;
  GLUT_INDEX                      = 1;
  GLUT_SINGLE                     = 0;
  GLUT_DOUBLE                     = 2;
  GLUT_ACCUM                      = 4;
  GLUT_ALPHA                      = 8;
  GLUT_DEPTH                      = 16;
  GLUT_STENCIL                    = 32;
  GLUT_MULTISAMPLE                = 128;
  GLUT_STEREO                     = 256;
  GLUT_LUMINANCE                  = 512;

  // Mouse buttons.
  GLUT_LEFT_BUTTON                = 0;
  GLUT_MIDDLE_BUTTON              = 1;
  GLUT_RIGHT_BUTTON               = 2;

  // Mouse button state.
  GLUT_DOWN                       = 0;
  GLUT_UP                         = 1;

  // function keys
  GLUT_KEY_F1                     = 1;
  GLUT_KEY_F2                     = 2;
  GLUT_KEY_F3                     = 3;
  GLUT_KEY_F4                     = 4;
  GLUT_KEY_F5                     = 5;
  GLUT_KEY_F6                     = 6;
  GLUT_KEY_F7                     = 7;
  GLUT_KEY_F8                     = 8;
  GLUT_KEY_F9                     = 9;
  GLUT_KEY_F10                    = 10;
  GLUT_KEY_F11                    = 11;
  GLUT_KEY_F12                    = 12;
  // directional keys
  GLUT_KEY_LEFT                   = 100;
  GLUT_KEY_UP                     = 101;
  GLUT_KEY_RIGHT                  = 102;
  GLUT_KEY_DOWN                   = 103;
  GLUT_KEY_PAGE_UP                = 104;
  GLUT_KEY_PAGE_DOWN              = 105;
  GLUT_KEY_HOME                   = 106;
  GLUT_KEY_END                    = 107;
  GLUT_KEY_INSERT                 = 108;

  // Entry/exit  state.
  GLUT_LEFT                       = 0;
  GLUT_ENTERED                    = 1;

  // Menu usage state.
  GLUT_MENU_NOT_IN_USE            = 0;
  GLUT_MENU_IN_USE                = 1;

  // Visibility  state.
  GLUT_NOT_VISIBLE                = 0;
  GLUT_VISIBLE                    = 1;

  // Window status  state.
  GLUT_HIDDEN                     = 0;
  GLUT_FULLY_RETAINED             = 1;
  GLUT_PARTIALLY_RETAINED         = 2;
  GLUT_FULLY_COVERED              = 3;

  // Color index component selection values.
  GLUT_RED                        = 0;
  GLUT_GREEN                      = 1;
  GLUT_BLUE                       = 2;

  // Layers for use.
  GLUT_NORMAL                     = 0;
  GLUT_OVERLAY                    = 1;

  // Stroke font constants (use these in GLUT program).
  GLUT_STROKE_ROMAN		  = Pointer(0);
  GLUT_STROKE_MONO_ROMAN	  = Pointer(1);

  // Bitmap font constants (use these in GLUT program).
  GLUT_BITMAP_9_BY_15		  = Pointer(2);
  GLUT_BITMAP_8_BY_13		  = Pointer(3);
  GLUT_BITMAP_TIMES_ROMAN_10	  = Pointer(4);
  GLUT_BITMAP_TIMES_ROMAN_24	  = Pointer(5);
  GLUT_BITMAP_HELVETICA_10	  = Pointer(6);
  GLUT_BITMAP_HELVETICA_12	  = Pointer(7);
  GLUT_BITMAP_HELVETICA_18	  = Pointer(8);

  // glutGet parameters.
  GLUT_WINDOW_X                   = 100;
  GLUT_WINDOW_Y                   = 101;
  GLUT_WINDOW_WIDTH               = 102;
  GLUT_WINDOW_HEIGHT              = 103;
  GLUT_WINDOW_BUFFER_SIZE         = 104;
  GLUT_WINDOW_STENCIL_SIZE        = 105;
  GLUT_WINDOW_DEPTH_SIZE          = 106;
  GLUT_WINDOW_RED_SIZE            = 107;
  GLUT_WINDOW_GREEN_SIZE          = 108;
  GLUT_WINDOW_BLUE_SIZE           = 109;
  GLUT_WINDOW_ALPHA_SIZE          = 110;
  GLUT_WINDOW_ACCUM_RED_SIZE      = 111;
  GLUT_WINDOW_ACCUM_GREEN_SIZE    = 112;
  GLUT_WINDOW_ACCUM_BLUE_SIZE     = 113;
  GLUT_WINDOW_ACCUM_ALPHA_SIZE    = 114;
  GLUT_WINDOW_DOUBLEBUFFER        = 115;
  GLUT_WINDOW_RGBA                = 116;
  GLUT_WINDOW_PARENT              = 117;
  GLUT_WINDOW_NUM_CHILDREN        = 118;
  GLUT_WINDOW_COLORMAP_SIZE       = 119;
  GLUT_WINDOW_NUM_SAMPLES         = 120;
  GLUT_WINDOW_STEREO              = 121;
  GLUT_WINDOW_CURSOR              = 122;
  GLUT_SCREEN_WIDTH               = 200;
  GLUT_SCREEN_HEIGHT              = 201;
  GLUT_SCREEN_WIDTH_MM            = 202;
  GLUT_SCREEN_HEIGHT_MM           = 203;
  GLUT_MENU_NUM_ITEMS             = 300;
  GLUT_DISPLAY_MODE_POSSIBLE      = 400;
  GLUT_INIT_WINDOW_X              = 500;
  GLUT_INIT_WINDOW_Y              = 501;
  GLUT_INIT_WINDOW_WIDTH          = 502;
  GLUT_INIT_WINDOW_HEIGHT         = 503;
  GLUT_INIT_DISPLAY_MODE          = 504;
  GLUT_ELAPSED_TIME               = 700;

  // glutDeviceGet parameters.
  GLUT_HAS_KEYBOARD               = 600;
  GLUT_HAS_MOUSE                  = 601;
  GLUT_HAS_SPACEBALL              = 602;
  GLUT_HAS_DIAL_AND_BUTTON_BOX    = 603;
  GLUT_HAS_TABLET                 = 604;
  GLUT_NUM_MOUSE_BUTTONS          = 605;
  GLUT_NUM_SPACEBALL_BUTTONS      = 606;
  GLUT_NUM_BUTTON_BOX_BUTTONS     = 607;
  GLUT_NUM_DIALS                  = 608;
  GLUT_NUM_TABLET_BUTTONS         = 609;

  // glutLayerGet parameters.
  GLUT_OVERLAY_POSSIBLE           = 800;
  GLUT_LAYER_IN_USE               = 801;
  GLUT_HAS_OVERLAY                = 802;
  GLUT_TRANSPARENT_INDEX          = 803;
  GLUT_NORMAL_DAMAGED             = 804;
  GLUT_OVERLAY_DAMAGED            = 805;

  // glutVideoResizeGet parameters.
  GLUT_VIDEO_RESIZE_POSSIBLE       = 900;
  GLUT_VIDEO_RESIZE_IN_USE         = 901;
  GLUT_VIDEO_RESIZE_X_DELTA        = 902;
  GLUT_VIDEO_RESIZE_Y_DELTA        = 903;
  GLUT_VIDEO_RESIZE_WIDTH_DELTA    = 904;
  GLUT_VIDEO_RESIZE_HEIGHT_DELTA   = 905;
  GLUT_VIDEO_RESIZE_X              = 906;
  GLUT_VIDEO_RESIZE_Y              = 907;
  GLUT_VIDEO_RESIZE_WIDTH          = 908;
  GLUT_VIDEO_RESIZE_HEIGHT         = 909;

  // glutGetModifiers return mask.
  GLUT_ACTIVE_SHIFT                = 1;
  GLUT_ACTIVE_CTRL                 = 2;
  GLUT_ACTIVE_ALT                  = 4;

  // glutSetCursor parameters.
  // Basic arrows.
  GLUT_CURSOR_RIGHT_ARROW          = 0;
  GLUT_CURSOR_LEFT_ARROW           = 1;
  // Symbolic cursor shapes.
  GLUT_CURSOR_INFO                 = 2;
  GLUT_CURSOR_DESTROY              = 3;
  GLUT_CURSOR_HELP                 = 4;
  GLUT_CURSOR_CYCLE                = 5;
  GLUT_CURSOR_SPRAY                = 6;
  GLUT_CURSOR_WAIT                 = 7;
  GLUT_CURSOR_TEXT                 = 8;
  GLUT_CURSOR_CROSSHAIR            = 9;
  // Directional cursors.
  GLUT_CURSOR_UP_DOWN              = 10;
  GLUT_CURSOR_LEFT_RIGHT           = 11;
  // Sizing cursors.
  GLUT_CURSOR_TOP_SIDE             = 12;
  GLUT_CURSOR_BOTTOM_SIDE          = 13;
  GLUT_CURSOR_LEFT_SIDE            = 14;
  GLUT_CURSOR_RIGHT_SIDE           = 15;
  GLUT_CURSOR_TOP_LEFT_CORNER      = 16;
  GLUT_CURSOR_TOP_RIGHT_CORNER     = 17;
  GLUT_CURSOR_BOTTOM_RIGHT_CORNER  = 18;
  GLUT_CURSOR_BOTTOM_LEFT_CORNER   = 19;
  // Inherit from parent window.
  GLUT_CURSOR_INHERIT              = 100;
  // Blank cursor.
  GLUT_CURSOR_NONE                 = 101;
  // Fullscreen crosshair (if available).
  GLUT_CURSOR_FULL_CROSSHAIR       = 102;

  // GLUT initialization sub-API.
  procedure glutInit(argcp: PInteger; argv: PPChar); GLUTCALL; external GLUTDLL;
  procedure glutInitDisplayMode(mode: Word); GLUTCALL; external GLUTDLL;
  procedure glutInitDisplayString(const str: PChar); GLUTCALL; external GLUTDLL;
  procedure glutInitWindowPosition(x, y: Integer); GLUTCALL; external GLUTDLL;
  procedure glutInitWindowSize(width, height: Integer); GLUTCALL; external GLUTDLL;
  procedure glutMainLoop; GLUTCALL; external GLUTDLL;

  // GLUT window sub-API.
  function glutCreateWindow(const title: PChar): Integer; GLUTCALL; external GLUTDLL;
  function glutCreateSubWindow(win, x, y, width, height: Integer): Integer; GLUTCALL; external GLUTDLL;
  procedure glutDestroyWindow(win: Integer); GLUTCALL; external GLUTDLL;
  procedure glutPostRedisplay; GLUTCALL; external GLUTDLL;
  procedure glutPostWindowRedisplay(win: Integer); GLUTCALL; external GLUTDLL;
  procedure glutSwapBuffers; GLUTCALL; external GLUTDLL;
  function glutGetWindow: Integer; GLUTCALL; external GLUTDLL;
  procedure glutSetWindow(win: Integer); GLUTCALL; external GLUTDLL;
  procedure glutSetWindowTitle(const title: PChar); GLUTCALL; external GLUTDLL;
  procedure glutSetIconTitle(const title: PChar); GLUTCALL; external GLUTDLL;
  procedure glutPositionWindow(x, y: Integer); GLUTCALL; external GLUTDLL;
  procedure glutReshapeWindow(width, height: Integer); GLUTCALL; external GLUTDLL;
  procedure glutPopWindow; GLUTCALL; external GLUTDLL;
  procedure glutPushWindow; GLUTCALL; external GLUTDLL;
  procedure glutIconifyWindow; GLUTCALL; external GLUTDLL;
  procedure glutShowWindow; GLUTCALL; external GLUTDLL;
  procedure glutHideWindow; GLUTCALL; external GLUTDLL;
  procedure glutFullScreen; GLUTCALL; external GLUTDLL;
  procedure glutSetCursor(cursor: Integer); GLUTCALL; external GLUTDLL;
  procedure glutWarpPointer(x, y: Integer); GLUTCALL; external GLUTDLL;

  // GLUT overlay sub-API.
  procedure glutEstablishOverlay; GLUTCALL; external GLUTDLL;
  procedure glutRemoveOverlay; GLUTCALL; external GLUTDLL;
  procedure glutUseLayer(layer: GLenum); GLUTCALL; external GLUTDLL;
  procedure glutPostOverlayRedisplay; GLUTCALL; external GLUTDLL;
  procedure glutPostWindowOverlayRedisplay(win: Integer); GLUTCALL; external GLUTDLL;
  procedure glutShowOverlay; GLUTCALL; external GLUTDLL;
  procedure glutHideOverlay; GLUTCALL; external GLUTDLL;

  // GLUT menu sub-API.
  function glutCreateMenu(callback: TGlut1IntCallback): Integer; GLUTCALL; external GLUTDLL;
  procedure glutDestroyMenu(menu: Integer); GLUTCALL; external GLUTDLL;
  function glutGetMenu: Integer; GLUTCALL; external GLUTDLL;
  procedure glutSetMenu(menu: Integer); GLUTCALL; external GLUTDLL;
  procedure glutAddMenuEntry(const caption: PChar; value: Integer); GLUTCALL; external GLUTDLL;
  procedure glutAddSubMenu(const caption: PChar; submenu: Integer); GLUTCALL; external GLUTDLL;
  procedure glutChangeToMenuEntry(item: Integer; const caption: PChar; value: Integer); GLUTCALL; external GLUTDLL;
  procedure glutChangeToSubMenu(item: Integer; const caption: PChar; submenu: Integer); GLUTCALL; external GLUTDLL;
  procedure glutRemoveMenuItem(item: Integer); GLUTCALL; external GLUTDLL;
  procedure glutAttachMenu(button: Integer); GLUTCALL; external GLUTDLL;
  procedure glutDetachMenu(button: Integer); GLUTCALL; external GLUTDLL;

  // GLUT  sub-API.
  procedure glutDisplayFunc(f: TGlutVoidCallback); GLUTCALL; external GLUTDLL;
  procedure glutReshapeFunc(f: TGlut2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutKeyboardFunc(f: TGlut1Char2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutMouseFunc(f: TGlut4IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutMotionFunc(f: TGlut2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutPassiveMotionFunc(f: TGlut2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutEntryFunc(f: TGlut1IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutVisibilityFunc(f: TGlut1IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutIdleFunc(f: TGlutVoidCallback); GLUTCALL; external GLUTDLL;
  procedure glutTimerFunc(millis: Word; f: TGlut1IntCallback; value: Integer); GLUTCALL; external GLUTDLL;
  procedure glutMenuStateFunc(f: TGlut1IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutSpecialFunc(f: TGlut3IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutSpaceballMotionFunc(f: TGlut3IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutSpaceballRotateFunc(f: TGlut3IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutSpaceballButtonFunc(f: TGlut2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutButtonBoxFunc(f: TGlut2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutDialsFunc(f: TGlut2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutTabletMotionFunc(f: TGlut2IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutTabletButtonFunc(f: TGlut4IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutMenuStatusFunc(f: TGlut3IntCallback); GLUTCALL; external GLUTDLL;
  procedure glutOverlayDisplayFunc(f:TGlutVoidCallback); GLUTCALL; external GLUTDLL;
  procedure glutWindowStatusFunc(f: TGlut1IntCallback); GLUTCALL; external GLUTDLL;

  // GLUT color index sub-API.
  procedure glutSetColor(cell: Integer; red, green, blue: GLfloat); GLUTCALL; external GLUTDLL;
  function glutGetColor(ndx, component: Integer): GLfloat; GLUTCALL; external GLUTDLL;
  procedure glutCopyColormap(win: Integer); GLUTCALL; external GLUTDLL;

  // GLUT state retrieval sub-API.
  function glutGet(t: GLenum): Integer; GLUTCALL; external GLUTDLL;
  function glutDeviceGet(t: GLenum): Integer; GLUTCALL; external GLUTDLL;
  // GLUT extension support sub-API
  function glutExtensionSupported(const name: PChar): Integer; GLUTCALL; external GLUTDLL;
  function glutGetModifiers: Integer; GLUTCALL; external GLUTDLL;
  function glutLayerGet(t: GLenum): Integer; GLUTCALL; external GLUTDLL;

  // GLUT font sub-API
  procedure glutBitmapCharacter(font, character: Integer); GLUTCALL; external GLUTDLL;
  function glutBitmapWidth(font, character: Integer): Integer; GLUTCALL; external GLUTDLL;
  procedure glutStrokeCharacter(font, character: Integer); GLUTCALL; external GLUTDLL;
  function glutStrokeWidth(font, character: Integer): Integer; GLUTCALL; external GLUTDLL;
  function glutBitmapLength(font: Integer; const str: PChar): Integer; GLUTCALL; external GLUTDLL;
  function glutStrokeLength(font: Integer; const str: PChar): Integer; GLUTCALL; external GLUTDLL;

  // GLUT pre-built models sub-API
  procedure glutWireSphere(radius: GLdouble; slices, stacks: GLint); GLUTCALL; external GLUTDLL;
  procedure glutSolidSphere(radius: GLdouble; slices, stacks: GLint); GLUTCALL; external GLUTDLL;
  procedure glutWireCone(base, height: GLdouble; slices, stacks: GLint); GLUTCALL; external GLUTDLL;
  procedure glutSolidCone(base, height: GLdouble; slices, stacks: GLint); GLUTCALL; external GLUTDLL;
  procedure glutWireCube(size: GLdouble); GLUTCALL; external GLUTDLL;
  procedure glutSolidCube(size: GLdouble); GLUTCALL; external GLUTDLL;
  procedure glutWireTorus(innerRadius, outerRadius: GLdouble; sides, rings: GLint); GLUTCALL; external GLUTDLL;
  procedure glutSolidTorus(innerRadius, outerRadius: GLdouble; sides, rings: GLint); GLUTCALL; external GLUTDLL;
  procedure glutWireDodecahedron; GLUTCALL; external GLUTDLL;
  procedure glutSolidDodecahedron; GLUTCALL; external GLUTDLL;
  procedure glutWireTeapot(size: GLdouble); GLUTCALL; external GLUTDLL;
  procedure glutSolidTeapot(size: GLdouble); GLUTCALL; external GLUTDLL;
  procedure glutWireOctahedron; GLUTCALL; external GLUTDLL;
  procedure glutSolidOctahedron; GLUTCALL; external GLUTDLL;
  procedure glutWireTetrahedron; GLUTCALL; external GLUTDLL;
  procedure glutSolidTetrahedron; GLUTCALL; external GLUTDLL;
  procedure glutWireIcosahedron; GLUTCALL; external GLUTDLL;
  procedure glutSolidIcosahedron; GLUTCALL; external GLUTDLL;

  // GLUT video resize sub-API.
  function glutVideoResizeGet(param: GLenum): Integer; GLUTCALL; external GLUTDLL;
  procedure glutSetupVideoResizing; GLUTCALL; external GLUTDLL;
  procedure glutStopVideoResizing; GLUTCALL; external GLUTDLL;
  procedure glutVideoResize(x, y, width, height: Integer); GLUTCALL; external GLUTDLL;
  procedure glutVideoPan(x, y, width, height: Integer); GLUTCALL; external GLUTDLL;

  // GLUT debugging sub-API.
  procedure glutReportErrors; GLUTCALL; external GLUTDLL;

implementation

end.
