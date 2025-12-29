unit Splash;
{$codepage utf8}
interface
uses
{$IFDEF MSWINDOWS}
  Windows, Forms, SysUtils, ExtCtrls, Classes, Controls, StdCtrls,
  Registry, jpeg;//, GIFimage; //   , jpeg
{$ELSE}
  Forms, SysUtils, ExtCtrls, Classes, Controls, StdCtrls, Dialogs,
  Graphics;
{$ENDIF}
const RegFile='License.txt';
type
{$IFDEF MSWINDOWS}
  TfrmSplash = class(TForm)
    Image0: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    butt1: TButton;
    butt2: TButton;
    Bevel1: TBevel;
    myTimer: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure setWindow(bb :boolean);
    procedure butt1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MakeTimer;
    procedure myTimerTimer(Sender: TObject);
    procedure Image0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure butt2Click(Sender: TObject);
  public
  end;
{$ELSE}
  TfrmSplash = class(TForm)
  private
    procedure BuildUi;
  protected
    procedure DoHide; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor CreateNew(AOwner: TComponent; Num: Integer = 0); override;
    procedure setWindow(bb:boolean);
    procedure butt1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MakeTimer;
    procedure myTimerTimer(Sender: TObject);
    procedure Image0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure butt2Click(Sender: TObject);
  end;
{$ENDIF}
type
  PtsType = array [0..51, 0..1] of Integer;
var frmSplash: TfrmSplash;
  serial:string; //æ³¨åè¯å«ç 
  pw:string;     //æ³¨åå·
{$IFDEF MSWINDOWS}
  reg: Tregistry;
{$ENDIF}
  G: TextFile;
implementation

uses
  inRm3Dunit;

{$IFNDEF MSWINDOWS}
{$I SplashImage.inc}
{$ENDIF}

{$IFDEF MSWINDOWS}
{$R *.DFM}

procedure TfrmSplash.setWindow(bb :boolean);
var HRegion1: THandle;  pts:ptsType;
const w=555; h=68;
const pts0:ptsType=(  //未注册后的大窗口
  (0,15), (1,15), (1,13), (3,11), (5,11), (5,10),
  (10,10),(10,5), (11,5), (11,3), (13,1), (15,1), (15,0),
  (540,0),(540,1),(542,1),(544,3),(544,5),(545,5),
  (545,10),(550,10),(550,11),(552,11),(554,13),(554,15),(555,15),
  (555,223),(554,223),(554,224),(551,227),(550,227),(550,228),
  (545,228),(545,233),(544,233),(544,234),(541,237),(540,237),(540,238),
  (15,238),(15,237),(14,237),(11,234),(11,233),(10,233),
  (10,228),(5,228),(5,227),(4,227),(1,224),(1,222),(0,223));
const pts1:ptsType=( //注册后的小窗口
  (0,15), (1,15), (1,13), (3,11), (5,11), (5,10),
  (10,10),(10,5), (11,5), (11,3), (13,1), (15,1), (15,0),
  (540,0),(540,1),(542,1),(544,3),(544,5),(545,5),
  (545,10),(550,10),(550,11),(552,11),(554,13),(554,15),(555,15),
  (555,223-h),(554,223-h),(554,224-h),(551,227-h),(550,227-h),(550,228-h),
  (545,228-h),(545,233-h),(544,233-h),(544,234-h),(541,237-h),(540,237-h),(540,238-h),
  (15,238-h),(15,237-h),(14,237-h),(11,234-h),(11,233-h),(10,233-h),
  (10,228-h),(5,228-h),(5,227-h),(4,227-h),(1,224-h),(1,222-h),(0,223-h));
begin
  if bb then pts:=pts0 else pts:=pts1;
  HRegion1 := CreatePolygonRgn (Pts,sizeof(Pts) div 8, alternate);
  SetWindowRgn (Handle, HRegion1, True);
//8  SetWindowLong(Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);
end;
{
procedure DrawGIF(IMG:TImage; GIFname:string);
var
  Stream		: TStream;
  GIF			: TGIFImage;
begin // Do not use buffering.
  // This is safe since we have complete control over the TImage's canvas
  include(GIFImageDefaultDrawOptions, goDirectDraw);
  // Create a stream to load the GIF resource from
  Stream := TResourceStream.Create(hInstance, GIFname, 'GIF');
  try
    GIF := TGIFImage.Create;
    try
      GIF.LoadFromStream(Stream); // Load the GIF from the resource stream
      IMG.Picture.Assign(GIF); // Display the GIF in the TImage
    finally
      GIF.Free;
    end;
  finally
    Stream.Free;
  end;
end;  }

function GetScreenPos( Num:string):string; //加密函数
  var i,l :dword; r :int64;
begin
  r:=0;
  l:= length( Num);
  for i:= 1 to l do
  begin
    r:= r+ ( dword( Num[ i])+ i)* 9;   //dword(c:char):dword返回字符的ASCII值
    r:= (r+ i)* 9+ i;
  end;
  result:= IntToStr( r);
end;

function GetDiskInfo: string;  //计算识别码
  var cName: pChar;  size:  dWord;
      uSeri, uName, t,u,v: string;  //操作系统序列号、计算机名称
      i,code: integer; r,j,k :int64;
begin
  reg:= TRegistry.Create;
  with reg do begin
    RootKey:= HKEY_LOCAL_MACHINE;
    OpenKey( 'Software\Microsoft\Windows\CurrentVersion', False);
    uSeri:= ReadString( 'ProductID');// 操作系统序列号
    end;
  reg.Free;
  GetMem( cName, 255);
  size:= 255;
  if GetComputerName( cName, size)= false
    then uName:= 'noneUser' else uName:= cName; // 计算机名称
  u:='';
  for i:= 0 to 7 do u:= u+ copy( uSeri,i*2+1,1);
  t:= GetScreenPos( u);     val( t,j, code);
  v:= GetScreenPos(uName);  val( v,k, code);
  frmSplash.Edit1.text := inttostr(j+k );
  result:= inttostr( j+k);      //23509993097
end;
{
procedure TfrmSplash.butt2Click(Sender: TObject);
begin
  frmSplash.myTimer.Interval:= 30000+ Random(60000);
  frmSplash.Hide;
end;

procedure TfrmSplash.regSet(regKey:cardinal; regSt,path:string);
  var reg: Tregistry;  St:string;
begin
  reg:=Tregistry.create;
  reg.RootKey:=regKey;
  St:=regSt+ '\.sgf';
    reg.createKey( St ); //建立项
    reg.openKey( St, false); //打开项
    reg.writeString( '', 'Geometer3D');
  St:=regSt+ '\Geometer3D';
    reg.createKey( st ); //建立项
    reg.openKey( st, false); //打开项
    reg.writeString( '', '三维绘图板'); //建立a键
    reg.WriteInteger( 'BrowserFlags', 8);
    reg.WriteInteger('EditFlags', 0);
  St:=regSt+ '\Geometer3D\DefaultIcon';
    reg.createKey( St ); //建立项
    reg.openKey( St, false); //打开项
    reg.writeString( '', path+'Geometer3D.exe, 0');
  St:=regSt+ '\Geometer3D\shell';
    reg.createKey( St ); //建立项
    reg.openKey( St, false); //打开项
    reg.writeString( '', 'Open');
  St:=regSt+ '\Geometer3D\shell\Open\command';
    reg.createKey( St ); //建立项
    reg.openKey( St, false); //打开项
    reg.writeString( '', path+'Geometer3D.exe "%1" ');
  reg.CloseKey;
end;  }
procedure TfrmSplash.butt1Click(Sender: TObject);
begin
  if trim( Edit2.text) = pw then begin
    AssignFile( G, exePath+RegFile);  ReWrite( G); //重写文件
    WriteLn( G, 'inRm3D v2.7 write by inRm in 2004-2010');
    WriteLn( G, pw);  //注册码
    closeFile( G);    //关闭文件

{    reg:= Tregistry.create;
    reg.RootKey:= HKEY_CLASSES_ROOT;
      reg.createKey( '\Licenses\'+ serial); //建立硬盘序列号项
      reg.openKey( '\Licenses\'+ serial, false); //打开serial项
      reg.writeString( '', pw); //将pw写入已打开项的默认键值
    reg.closeKey;
    regSet( HKEY_CLASSES_ROOT, '', exePath);
    regSet( HKEY_LOCAL_MACHINE, '\SOFTWARE\Classes\', exePath);
}
    myTimer.Enabled:= false;
    frmSplash.Height:= 170;
    frmSplash.KeyPreview:= true;
    frmSplash.hide; bPW:=false;
    end;
//  else
//    butt2Click(nil);
end;

procedure TfrmSplash.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  frmSplash.Hide;
end;

procedure TfrmSplash.FormHide(Sender: TObject);
begin
  edit2.SetFocus;
  frmMain.Enabled:= true;
end;
procedure TfrmSplash.MakeTimer;
begin //如未经注册则定时器生效
  myTimer.interval:= 10000+ Random(10000); //沿时10-20秒
  myTimer.Enabled:= true;
  frmSplash.KeyPreview:= false;
  Edit1.Text:= serial;
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
  var st,pwFile:string;
begin //exit; //检测注册状态
{  randomize;
  serial:= GetDiskInfo;               //系统信息
  pw:= GetScreenPos( serial);         //注册码(serial的密文)
  reg:= Tregistry.create;             //打开注册表项
    reg.RootKey:= HKEY_CLASSES_ROOT;    //注册表根键
    bPW:=not reg.openKey( '\Licenses\'+ serial, false)  //如该项不存在，则建立该项
         or (pw<>reg.readString(''));  //读取注册码(已打开项的默认值)
  if bPW then begin  //未读到正确的注册码
    pwFile:=exePath+RegFile;
    if FileExists(pwFile) then begin
      AssignFile( G, pwFile);  ReSet( G);
      ReadLn( G, st);  ReadLn( G, st);  //注册码
      closeFile( G);        //关闭文件
      bPW:= st<>pw;
      end;
    end;}
    bPW:=false; //######### 未注册则bPW为true ############
//    bPath:=(reg.ReadString('DefaultPath')<>exePath);
  if bPW then MakeTimer     //未注册，不定时弹出注册窗口
         else height:= 170; //屏蔽注册
//  if bPath then reg.WriteString('DefaultPath', exePath);
//  reg.closeKey;
{  if bPath then begin
    regSet( HKEY_CLASSES_ROOT, '', exePath);
    regSet( HKEY_LOCAL_MACHINE, '\SOFTWARE\Classes\', exePath);
    end;}
  if not bPW then begin
    Bevel1.Hide; Label1.Hide; Label4.Hide; Label5.Hide;
    Edit1.Top:=300;  Edit2.Top:=300;       Butt1.Hide; Butt2.Hide;
    end;

  if bPW then setWindow(true) else setWindow(false);
//  DrawGIF(Image1, 'Geometer3D');
end;

procedure TfrmSplash.myTimerTimer(Sender: TObject);
begin  //exit;
  if bPW then begin
    frmMain.menSave.Enabled:=false;
    frmMain.menSaveAs.Enabled:=false;
    end;
end;

procedure TfrmSplash.Image0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmSplash.Hide;
end;

procedure TfrmSplash.butt2Click(Sender: TObject);
begin
  frmSplash.Hide;
end;

{$ELSE}

function LoadEmbeddedSplash(Pic: TPicture): Boolean;
var
  Stream: TMemoryStream;
begin
  Result := False;
  if SplashJpgSize <= 0 then
    Exit;
  Stream := TMemoryStream.Create;
  try
    Stream.WriteBuffer(SplashJpgData[0], SplashJpgSize);
    Stream.Position := 0;
    try
      Pic.LoadFromStream(Stream);
      Result := True;
    except
      Result := False;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TfrmSplash.BuildUi;
var
  Img: TImage;
  InfoPanel, ButtonPanel: TPanel;
  Lbl: TLabel;
  Contacts: array[0..2] of string;
  I, YPos: Integer;
  ImgPath: string;
  function FindSplashImage: string;
  const
    ImgNames: array[0..1] of string = ('Splash.jpg', 'Splash2.jpg');
  var
    Dirs: array[0..5] of string;
    DirCount, d, n: Integer;

    procedure AddDir(const Dir: string);
    var
      Actual: string;
    begin
      if (Dir = '') or (DirCount > High(Dirs)) then
        Exit;
      Actual := IncludeTrailingPathDelimiter(ExpandFileName(Dir));
      if DirectoryExists(Actual) then
      begin
        Dirs[DirCount] := Actual;
        Inc(DirCount);
      end;
    end;

    function ExeDir: string;
    begin
      Result := ExtractFilePath(Application.ExeName);
    end;

  begin
    DirCount := 0;
    if exePath <> '' then
      AddDir(exePath);
    AddDir(ExeDir);
    AddDir(ExeDir + '..' + PathDelim);
    AddDir(ExeDir + '..' + PathDelim + '..' + PathDelim);
    AddDir(GetCurrentDir);
    for d := 0 to DirCount - 1 do
      for n := Low(ImgNames) to High(ImgNames) do
      begin
        Result := Dirs[d] + 'SubUnit' + PathDelim + ImgNames[n];
        if FileExists(Result) then
          Exit;
      end;
    Result := '';
  end;
begin
  Caption := 'About inRm3D';
  Position := poScreenCenter;
  BorderStyle := bsDialog;
  KeyPreview := True;
  ClientWidth := 640;
  ClientHeight := 360;
  Color := clWhite;

  Img := TImage.Create(Self);
  Img.Parent := Self;
  Img.Align := alTop;
  Img.Stretch := True;
  Img.Proportional := True;
  Img.Center := True;
  Img.Height := 240;

  ImgPath := FindSplashImage;
  if FileExists(ImgPath) then
    Img.Picture.LoadFromFile(ImgPath)
  else if not LoadEmbeddedSplash(Img.Picture) then
    Img.Height := 0;
  Img.OnMouseDown := Image0MouseDown;

  ButtonPanel := TPanel.Create(Self);
  ButtonPanel.Parent := Self;
  ButtonPanel.Align := alBottom;
  ButtonPanel.Height := 56;
  ButtonPanel.BevelOuter := bvNone;

  with TButton.Create(Self) do
  begin
    Parent := ButtonPanel;
    Align := alRight;
    Width := 120;
    Caption := 'Close';
    OnClick := butt2Click;
  end;

  with TButton.Create(Self) do
  begin
    Parent := ButtonPanel;
    Align := alRight;
    Width := 120;
    Caption := 'Register';
    OnClick := butt1Click;
  end;

  InfoPanel := TPanel.Create(Self);
  InfoPanel.Parent := Self;
  InfoPanel.Align := alClient;
  InfoPanel.BevelOuter := bvNone;

  YPos := 8;
  Lbl := TLabel.Create(Self);
  Lbl.Parent := InfoPanel;
  Lbl.Left := 16;
  Lbl.Top := YPos;
  Lbl.Caption := 'inRm3D v2.869';
  Lbl.Font.Style := [fsBold];
  Lbl.AutoSize := True;
  Inc(YPos, Lbl.Height + 6);

  Lbl := TLabel.Create(Self);
  Lbl.Parent := InfoPanel;
  Lbl.Left := 16;
  Lbl.Top := YPos;
  Lbl.Caption := 'Interactive 3D geometry and teaching platform';
  Lbl.AutoSize := True;
  Inc(YPos, Lbl.Height + 12);

  Lbl := TLabel.Create(Self);
  Lbl.Parent := InfoPanel;
  Lbl.Left := 16;
  Lbl.Top := YPos;
  Lbl.Caption := 'Contact:';
  Lbl.Font.Style := [fsBold];
  Lbl.AutoSize := True;
  Inc(YPos, Lbl.Height + 4);

  Contacts[0] := 'fangxq@live.cn';
  Contacts[1] := 'zhchgao128@sina.com.cn';
  Contacts[2] := '707691929@qq.com';
  for I := 0 to High(Contacts) do
  begin
    Lbl := TLabel.Create(Self);
    Lbl.Parent := InfoPanel;
    Lbl.Left := 32;
    Lbl.Top := YPos;
    Lbl.Caption := Contacts[I];
    Lbl.AutoSize := True;
    Inc(YPos, Lbl.Height + 2);
  end;
end;

constructor TfrmSplash.CreateNew(AOwner: TComponent; Num: Integer);
begin
  inherited CreateNew(AOwner, Num);
  BuildUi;
end;

procedure TfrmSplash.DoHide;
begin
  inherited DoHide;
  FormHide(Self);
end;

procedure TfrmSplash.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  FormKeyDown(Self, Key, Shift);
end;

procedure TfrmSplash.setWindow(bb:boolean);
begin
end;

procedure TfrmSplash.butt1Click(Sender: TObject);
begin
  MessageDlg('Registration is only available in the Windows version.', mtInformation, [mbOK], 0);
end;

procedure TfrmSplash.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then Close;
end;

procedure TfrmSplash.FormHide(Sender: TObject);
begin
  if Assigned(frmMain) then
    frmMain.Enabled:=true;
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
end;

procedure TfrmSplash.MakeTimer;
begin
end;

procedure TfrmSplash.myTimerTimer(Sender: TObject);
begin
end;

procedure TfrmSplash.Image0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TfrmSplash.butt2Click(Sender: TObject);
begin
  Close;
end;

{$ENDIF}

end.
