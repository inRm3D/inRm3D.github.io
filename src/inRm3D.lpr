program inRm3D;

{$MODE Delphi}

uses
  Forms,
  LCLIntf, LCLType, LMessages, Interfaces,
  inRm3Dunit in 'inRm3Dunit.pas' {frmMain},
  DArrays in 'cgLib\DArrays.pas',
  CgUtils in 'cglib\CgUtils.pas',
  CgTypes in 'cglib\CgTypes.pas',
  Express in 'cgLib\Express.pas',
  GLut in 'cglib\GLut.pas',
  GLu in 'cglib\GLu.pas',
  GL in 'cglib\GL.pas',
  BMP in 'cgLib\BMP.pas',
  pars in 'cgLib\pars.pas',
  build in 'cgLib\build.pas',
  Splash in 'SubUnit\Splash.pas' {frmSplash},
  parsglb in 'cgLib\parsglb.pas',
{$IFDEF MSWINDOWS}
  GIFimage in 'cgLib\GIFimage.pas',
{$ENDIF}
  DragImage in 'SubUnit\DragImage.pas',
  CgGeometry in 'cgLib\CgGeometry.pas'
{$IFDEF MSWINDOWS}
  , PNGimage in 'cgLib\PNGimage1.5\PNGimage.pas'
  , PNGzlib in 'cgLib\PNGimage1.5\PNGzlib.pas'
  , PNGlang in 'cgLib\PNGimage1.5\PNGlang.pas'
{$ENDIF}
  ;

{$R *.res}
{$R hand_c.res} //光标
begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
{$IFDEF MSWINDOWS}
  Application.CreateForm(TfrmDrag, frmDrag);
{$ELSE}
  frmDrag := TfrmDrag.CreateNew(Application);
{$ENDIF}
{$IFDEF MSWINDOWS}
  Application.CreateForm(TfrmSplash, frmSplash);
{$ELSE}
  frmSplash := TfrmSplash.CreateNew(Application);
{$ENDIF}
  Application.Run;
end.
