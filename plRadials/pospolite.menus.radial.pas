unit PospoLite.Menus.Radial;

{ (EN)
                     -PospoLite-
  TplxRadialMenu - Radial Menu Component for Lazarus
  --------------------------------------------------
  Author: Marcin Stefanowicz (Matek)
  Date: 05/08/2019
  Version: 1.0.0

  --PROBLEMS--
  When you have problems with my package or see bugs, please contact me via:
    * email: matiowo@wp.pl
    * Facebook: https://www.facebook.com/matek.y

  --ACKNOWLEDGEMENTS--
  Thanks for:
    * BGRABitmap (by Johann ELSASS,
        https://wiki.lazarus.freepascal.org/BGRABitmap)
    * ControlTimer (by Antonio Fortuny,
        https://wiki.lazarus.freepascal.org/Yet_another_Running_Timer)
}

{ (PL)
                     -PospoLite-
  TplxRadialMenu - Komponent obrotowego menu dla Lazarusa
  -------------------------------------------------------
  Autor: Marcin Stefanowicz (Matek)
  Data: 5.08.2019
  Wersja: 1.0.0

  --PROBLEMY--
  Jeśli masz jakieś problemy z moim pakietem lub znalazłeś/aś bugi, proszę
  skontaktuj się ze mną przez:
    * e-maila: matiowo@wp.pl
    * Facebooka: https://www.facebook.com/matek.y

  --PODZIĘKOWANIA--
  Dziękuję za:
    * BGRABitmap (stworzył Johann ELSASS,
        https://wiki.lazarus.freepascal.org/BGRABitmap)
    * ControlTimer (stworzył Antonio Fortuny,
        https://wiki.lazarus.freepascal.org/Yet_another_Running_Timer)
}

{
  --LICENCE--
}
{$warning Please read the license (LICENCE.txt) before using PospoLite library!}

{
  --LOGS--

  - 5.08.2019 v1.0.0
    Package completed.

}

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}
{$macro on}
{$goto on}
{$warnings off}
{$hints off}
{$define elif:=else if}
{$ifndef windows}
  {$fatal This component only works on Windows}
{$endif}

//if you want to turn on radial menu debug painting mode, uncomment line below:
{.$define PLXRADIALMENU_DEBUG}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LCLProc,
  LCLIntf, LMessages, BGRABitmap, BGRABitmapTypes, ImgList, ActnList, strutils,
  ExtCtrls, LResources, windows, math, LazUTF8, GraphUtil, Menus, simpletimer,
  fgl;

type

  TBitmap = Graphics.TBitmap;

  TplxRadialMenuItem = class;
  TplxRadialMenuItems = class;
  TplxRadialForm = class;
  TplxCustomRadialMenu = class;
  TplxRadialMenu = class;
  TplxRadialMenuActionLink = class;
  TplxRadialMenuStyle = class;
  TplxRadialMenuMetrics = class;


  { TplxRadialMenuItemInfo }

  PplxRadialMenuItemInfo = ^TplxRadialMenuItemInfo;
  TplxRadialMenuItemInfo = packed record
  private
    FBase: TPointF;
    FForm: TplxRadialForm;
    FNumber: integer;
    function GetArrow: TPointF;
    function GetFirst: TPointF;
    function GetFirstB: TPointF;
    function GetImage: TRectF;
    function GetMiddle: TPointF;
    function GetMiddleB: TPointF;
    function GetOffset: ValReal;
    function GetSecond: TPointF;
    function GetSecondB: TPointF;
    function GetText: TRectF;
  public
    constructor Create(ABase: TPointF; ANum: integer; AForm: TplxRadialForm);

    property Base: TPointF read FBase write FBase;
    property Number: integer read FNumber write FNumber;
    property Form: TplxRadialForm read FForm;

    property Offset: ValReal read GetOffset;

    property First: TPointF read GetFirst;
    property Middle: TPointF read GetMiddle;
    property Second: TPointF read GetSecond;
    property FirstB: TPointF read GetFirstB;
    property MiddleB: TPointF read GetMiddleB;
    property SecondB: TPointF read GetSecondB;
    property Arrow: TPointF read GetArrow;

    property Image: TRectF read GetImage;
    property Text: TRectF read GetText;
  end;

  { TplxRadialMenuActionLink }

  TplxRadialMenuActionLink = class(TActionLink)
  protected
    FClient: TplxRadialMenuItem;
    procedure AssignClient(AClient: TObject); override;
    function {%H-}IsCaptionLinked: Boolean; override;
    function {%H-}IsCheckedLinked: Boolean; override;
    function {%H-}IsEnabledLinked: Boolean; override;
    function {%H-}IsHelpContextLinked: Boolean; override;
    function {%H-}IsHintLinked: Boolean; override;
    function {%H-}IsImageIndexLinked: Boolean; override;
    function {%H-}IsShortCutLinked: Boolean; override;
    function {%H-}IsVisibleLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHelpContext(Value: THelpContext); override;
    procedure SetHint(const Value: string); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetShortCut(Value: TShortCut); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  { TplxRadialMenuStyle }

  TplxRadialMenuStyle = class(TPersistent)
  private
    FArrow: TColor;
    FBackground: TColor;
    FBorder: TColor;
    FBorderMoreBtn: TColor;
    FBorderMoreBtnHover: TColor;
    FBtnActive: TColor;
    FBtnHover: TColor;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure ApplyDefaultTheme;
  published
    property Background: TColor read FBackground write FBackground;
    property Border: TColor read FBorder write FBorder;
    property BorderMoreBtn: TColor read FBorderMoreBtn write FBorderMoreBtn;
    property BorderMoreBtnHover: TColor read FBorderMoreBtnHover write FBorderMoreBtnHover;
    property BtnActive: TColor read FBtnActive write FBtnActive;
    property BtnHover: TColor read FBtnHover write FBtnHover;
    property Arrow: TColor read FArrow write FArrow;
  end;

  { TplxRadialMenuMetrics }

  TplxRadialMenuMetrics = class(TPersistent)
  private
    FAnimation: boolean;
    FBorder: integer;
    FController: TplxCustomRadialMenu;
    FR: integer;
    FRBtn: integer;
    function GetD: integer;
  public
    constructor Create(AFrom: TplxCustomRadialMenu);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure RestoreDefaults;
  published
    property D: integer read GetD;
    property R: integer read FR write FR;
    property RBtn: integer read FRBtn write FRBtn;
    property Border: integer read FBorder write FBorder;
    property Animation: boolean read FAnimation write FAnimation;
  end;

  TplxTimingType = (ttShow, ttClose);
  TplxAngleType = -360..360;

  { TplxRadialForm }

  TplxRadialForm = class(TForm)
  private
    FController: TplxCustomRadialMenu;
    FGlobalOpacity: byte;
    FTimer: TSimpleTimer;
    FTimingType: TplxTimingType;
    FBmpAlpha: byte;
    FBmpAngle: TplxAngleType;
    procedure SetGlobalOpacity(AValue: byte);
    procedure OnDeactivateEv(Sender: TObject);
    procedure OnTimerEv(Sender: TObject);
    procedure OnCloseEv(Sender: TObject; var CloseAction: TCloseAction);
  protected
    procedure Premultiply(BMP: TBGRABitmap);
    procedure MakePNGWnd(WND: TCustomForm; bgraPNG: TBGRABitmap; bAlpha: Byte);
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;

    procedure DrawBody(bmp: TBGRABitmap);
    procedure DrawItem(bmp: TBGRABitmap; ind: integer);
    procedure DrawItems(bmp: TBGRABitmap);
    procedure DrawArrow(bmp: TBGRABitmap);
    procedure DrawMoreBtn(bmp: TBGRABitmap; ind: integer);
    procedure DrawMoreBtns(bmp: TBGRABitmap);
    procedure AnimateRadial(var tmp, bmp: TBGRABitmap);
    procedure PaintRadial;

    procedure ActivateTimer(att: TplxTimingType);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer
      ); override;
    procedure MouseLeave; override;
    procedure KeyPress(var Key: char); override;
  public
    constructor Create(AOwner: TComponent; MainFrm: TCustomForm);
    destructor Destroy; override;
  public
    XPoint: TPoint;

    function Alpha: double;
    function GetPoint(Nr: integer): TPointF;
    function IsBackHover: boolean;
    function IsItemHover(Nr: integer): boolean;
    function IsItemBtnHover(Nr: integer): boolean;
    function GetHoverInd: integer;
    function GetBtnHoverInd: integer;
    procedure Back;
    procedure GoToItem(AItem: TplxRadialMenuItem);

    procedure Prepare;
    procedure ShowRadialAt(Pnt: TPoint);

    property GlobalOpacity: byte read FGlobalOpacity write SetGlobalOpacity;
    property Controller: TplxCustomRadialMenu read FController;
  end;

  { TplxRadialMenuItem }

  TplxRadialMenuItem = class(TCollectionItem)
  private
    FActionLink: TplxRadialMenuActionLink;
    FCaption: string;
    FChecked: boolean;
    FEnabled: boolean;
    FHint: string;
    FImageIndex: TImageIndex;
    FItems: TplxRadialMenuItems;
    FOnClick: TNotifyEvent;
    FTag: PtrUInt;
    FVisible: boolean;
    function GetAction: TBasicAction;
    procedure SetAction(AValue: TBasicAction);
  protected
    procedure DoActionChange(Sender : TObject);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    property Action: TBasicAction read GetAction write SetAction;

    property Caption: string read FCaption write FCaption;
    property Checked: boolean read FChecked write FChecked;
    property Enabled: boolean read FEnabled write FEnabled;
    property Hint: string read FHint write FHint;
    property ImageIndex: TImageIndex read FImageIndex write FImageIndex;
    property Visible: boolean read FVisible write FVisible;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property Tag: PtrUInt read FTag write FTag;
    property Items: TplxRadialMenuItems read FItems write FItems;
  end;

  { TplxRadialMenuItems }

  TplxRadialMenuItems = class(TOwnedCollection)
  private
    function GetItem(Index: integer): TplxRadialMenuItem;
    procedure SetItem(Index: integer; AValue: TplxRadialMenuItem);
  public
    function Add: TplxRadialMenuItem;
    function CountVisible: integer;
    //procedure GetVisibleItems(var AItems: TplxRadialMenuItems);

    property Items[Index: integer]: TplxRadialMenuItem read GetItem write SetItem; default;
  end;

  TplxRadialMenuItemsStack = specialize TFPGObjectList<TplxRadialMenuItems>;

  { TplxCustomRadialMenu }

  TplxCustomRadialMenu = class(TPopupMenu)
  private
    FFont: TFont;
    FItems: TplxRadialMenuItems;
    FMetrics: TplxRadialMenuMetrics;
    FStyle: TplxRadialMenuStyle;
    FForm: TplxRadialForm;
    function GetAbout: string;
    procedure SetMetrics(AValue: TplxRadialMenuMetrics);
    procedure SetStyle(AValue: TplxRadialMenuStyle);
  protected
    FActiveItems: TplxRadialMenuItems;
    FStack: TplxRadialMenuItemsStack;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure PopUp;
    procedure PopUp(X, Y: Integer); override;
    procedure Close;

    property Items: TplxRadialMenuItems read FItems write FItems;
    property Font: TFont read FFont write FFont;
    property Style: TplxRadialMenuStyle read FStyle write SetStyle;
    property Metrics: TplxRadialMenuMetrics read FMetrics write SetMetrics;
  published
    property About: string read GetAbout stored false;
  end;

  TplxRadialMenu = class(TplxCustomRadialMenu)
  published
    property Font;
    property Items;
    property Style;
    property Metrics;

    property Name;
    property OnPopup;
    property OnClose;
    property OnChange;
  end;

function BGRAPNGWnd(hWnd: HWND; hdcDst: HDC; pptDst: PPoint; psize: PSize; hdcSrc: HDC;
  pptSrc: PPoint; crKey: TColor; pblend: PBlendFunction; dwFlags: DWORD): BOOL; stdcall;
  external User32 name 'UpdateLayeredWindow';
procedure GetVisibleItems(constref initems: TplxRadialMenuItems; out outitems: TplxRadialMenuItems);

implementation

function plScaleX(Size, FromDPI: integer; ToDPI: integer=0): integer;
begin
  if ToDPI = 0 then
    ToDPI := ScreenInfo.PixelsPerInchX;

  if ToDPI = FromDPI then
    Result := Size
  else
    begin
      if (ToDPI/FromDPI <= 1.5) and (Size = 1) then
        Result := 1
      else
        Result := MulDiv(Size, ToDPI, FromDPI);
    end;
end;

function plScaleY(Size, FromDPI: integer; ToDPI: integer=0): integer;
begin
  if ToDPI = 0 then
    ToDPI := ScreenInfo.PixelsPerInchY;

  if ToDPI = FromDPI then
    Result := Size
  else
    begin
      if (ToDPI/FromDPI <= 1.5) and (Size = 1) then
        Result := 1
      else
        Result := MulDiv(Size, ToDPI, FromDPI);
    end;
end;

function pX(Size: integer): integer;
begin
  Result:=plScaleX(Size,96);
end;

function pY(Size: integer): integer;
begin
  Result:=plScaleY(Size,96);
end;

function RotatePoint(O, P: TPointF; AngleDeg: Double): TPointF;
var
  AngleRads,
  OffsetX, OffsetY, TempX, TempY, X, Y: ValReal;
begin
  AngleRads := AngleDeg * (PI / 180);
  OffsetX := O.X;
  Offsety := O.Y;
  TempX := P.X - OffsetX;
  TempY := P.Y - OffsetY;
  X := Trunc(Cos(AngleRads) * TempX - Sin(AngleRads) * TempY);
  Y := Trunc(Sin(AngleRads) * TempX + Cos(AngleRads) * TempY);
  Result := PointF(x + OffsetX, y + OffSetY);
end;

function PointInPolygon(Point: TPoint; Polygon: array of TPoint): Boolean;
var
  rgn: HRGN;
begin
  rgn := windows.CreatePolygonRgn(Polygon, Length(Polygon), WINDING);
  Result := PtInRegion(rgn, Point.X, Point.Y);
  DeleteObject(rgn);
end;

procedure IncByte(var b: byte; a: integer);
var
  x: integer;
begin
  x:=b+a;
  if x>255 then x:=255;
  if x<0 then x:=0;
  b:=x;
end;

procedure IncAngle(var b: TplxAngleType; a: integer);
var
  x: integer;
begin
  x:=b+a;
  if x>360 then x:=360;
  if x<-360 then x:=-360;
  b:=x;
end;

function roundrf(r: TRectF): TRect;
begin
  Result:=TRect.Create(round(r.Left), round(r.Top), round(r.Right), round(r.Bottom));
end;

function StrMaxLen(const S: string; MaxLen: integer): widestring;
begin
  result := S;
  if Length(result) <= MaxLen then Exit;
  SetLength(result, MaxLen);
  SetLength(result, MaxLen+1);
  result[MaxLen-1] := '.';
  result[MaxLen] := '.';
  result[MaxLen+1] := '.';
end;

procedure GetVisibleItems(constref initems: TplxRadialMenuItems; out
  outitems: TplxRadialMenuItems);
var
  i: integer;
begin
  outitems.Clear;

  for i:=0 to initems.Count-1 do begin
    if initems[i].Visible then begin
      outitems.Add.Assign(initems[i]);
    end;
  end;
end;

{ TplxRadialMenuItemInfo }

function TplxRadialMenuItemInfo.GetFirst: TPointF;
var
  tmp: TPointF;
  r: ValReal;
begin
  tmp:=FBase;
  tmp.x:=tmp.x-Offset;

  r:=pX(FForm.Controller.Metrics.R)-1;
  Result:=RotatePoint(PointF(r,r), tmp, FForm.Alpha*FNumber);
end;

function TplxRadialMenuItemInfo.GetArrow: TPointF;
var
  r: ValReal;
begin
  r:=pX(FForm.Controller.Metrics.R)-1;

  Result.x:=r;
  Result.y:=pY(FForm.Controller.Metrics.Border)/2;
  Result:=RotatePoint(PointF(r,r), Result, FForm.Alpha*FNumber);
end;

function TplxRadialMenuItemInfo.GetFirstB: TPointF;
var
  tmp: TPointF;
  r: ValReal;
begin
  tmp:=FBase;
  tmp.x:=tmp.x-Offset*1.3;
  tmp.y:=1;

  r:=pX(FForm.Controller.Metrics.R)-1;
  Result:=RotatePoint(PointF(r,r), tmp, FForm.Alpha*FNumber);
end;

function TplxRadialMenuItemInfo.GetImage: TRectF;
var
  w, h: ValReal;
  p: TPointF;
begin
  if FForm.Controller.Images=nil then exit(RectF(0,0,0,0));

  w:=pX(FForm.Controller.Images.Width);
  h:=pY(FForm.Controller.Images.Height);

  p:=FForm.GetPoint(FNumber);

  with Result do begin
    Left:=p.x-w/2;
    Top:=p.y-h;
    Width:=w;
    Height:=h;
  end;
end;

function TplxRadialMenuItemInfo.GetMiddle: TPointF;
var
  tmp: TPointF;
  r: ValReal;
begin
  tmp:=FBase;
  tmp.y:=tmp.y-pY(2);

  r:=pX(FForm.Controller.Metrics.R)-1;
  Result:=RotatePoint(PointF(r,r), tmp, FForm.Alpha*FNumber);
end;

function TplxRadialMenuItemInfo.GetMiddleB: TPointF;
var
  tmp: TPointF;
  r: ValReal;
begin
  tmp:=FBase;
  tmp.y:=1;

  r:=pX(FForm.Controller.Metrics.R)-1;
  Result:=RotatePoint(PointF(r,r), tmp, FForm.Alpha*FNumber);
end;

function TplxRadialMenuItemInfo.GetOffset: ValReal;
var
  r, c, a: ValReal;
begin
  if FForm.Controller.FActiveItems.CountVisible=1 then exit(pX(50));

  a:=degtorad(FForm.Alpha);
  r:=pX(FForm.Controller.Metrics.R - FForm.Controller.Metrics.Border);
  //wyliczanie ze wzorów na strzałkę łuku
  c:=(r*(1-cos(a/2))) / (tan(a/4));

  Result:=c;
end;

function TplxRadialMenuItemInfo.GetSecond: TPointF;
var
  tmp: TPointF;
  r: ValReal;
begin
  tmp:=FBase;
  tmp.x:=tmp.x+Offset;

  r:=pX(FForm.Controller.Metrics.R)-1;
  Result:=RotatePoint(PointF(r,r), tmp, FForm.Alpha*FNumber);
end;

function TplxRadialMenuItemInfo.GetSecondB: TPointF;
var
  tmp: TPointF;
  r: ValReal;
begin
  tmp:=FBase;
  tmp.x:=tmp.x+Offset*1.3;
  tmp.y:=1;

  r:=pX(FForm.Controller.Metrics.R)-1;
  Result:=RotatePoint(PointF(r,r), tmp, FForm.Alpha*FNumber);
end;

function TplxRadialMenuItemInfo.GetText: TRectF;
var
  w, h: ValReal;
  p: TPointF;
begin
  p:=FForm.GetPoint(FNumber);

  w:=pX(40)*2;
  h:=pX(40);

  with Result do begin
    Left:=p.x-w/2;
    Top:=p.y+1;
    Width:=w;
    Height:=h;
  end;
end;

constructor TplxRadialMenuItemInfo.Create(ABase: TPointF; ANum: integer;
  AForm: TplxRadialForm);
begin
  FBase:=ABase;
  FNumber:=ANum;
  FForm:=AForm;
end;

{ TplxRadialMenuItem }

function TplxRadialMenuItem.GetAction: TBasicAction;
begin
  if FActionLink <> nil then
    Result := FActionLink.Action
  else
    Result := nil;
end;

procedure TplxRadialMenuItem.SetAction(AValue: TBasicAction);
begin
  if AValue = nil then
    FreeAndNil(FActionLink)
  else begin
    if FActionLink = nil then
      FActionLink := TplxRadialMenuActionLink.Create(Self);
    FActionLink.Action := AValue;
    FActionLink.OnChange := @DoActionChange;
    //AValue.FreeNotification(TplxRadialMenuItems(Collection).Owner);
    DoActionChange(AValue);
  end;
end;

procedure TplxRadialMenuItem.DoActionChange(Sender: TObject);
var
  A: TCustomAction absolute Sender;
begin
  FCaption:=A.Caption;
  FChecked:=A.Checked;
  FEnabled:=A.Enabled;
  FHint:=A.Hint;
  FImageIndex:=A.ImageIndex;
  FVisible:=A.Visible;
  if Assigned(A.OnExecute) then
    FOnClick:=A.OnExecute;
end;

constructor TplxRadialMenuItem.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);

  FItems:=TplxRadialMenuItems.Create(self, TplxRadialMenuItem);

  FCaption:='Item';
  FChecked:=false;
  FEnabled:=true;
  FHint:='';
  FImageIndex:=-1;
  FVisible:=true;
  FTag:=0;
end;

destructor TplxRadialMenuItem.Destroy;
begin
  FItems.Free;
  if Assigned(FActionLink) then
    FreeAndNil(FActionLink);

  inherited Destroy;
end;

procedure TplxRadialMenuItem.Assign(Source: TPersistent);
var
  s: TplxRadialMenuItem;
begin
  if Source is TplxRadialMenuItem then begin
    s:=Source as TplxRadialMenuItem;

    FCaption:=s.FCaption;
    FChecked:=s.FChecked;
    FEnabled:=s.FEnabled;
    FHint:=s.FHint;
    FImageIndex:=s.FImageIndex;
    FVisible:=s.FVisible;
    FOnClick:=s.FOnClick;
    FTag:=s.FTag;
    FItems.Assign(s.FItems);
    Action:=s.Action;
  end;
end;

{ TplxRadialMenuItems }

function TplxRadialMenuItems.GetItem(Index: integer): TplxRadialMenuItem;
begin
  Result:=TplxRadialMenuItem(inherited GetItem(Index));
end;

procedure TplxRadialMenuItems.SetItem(Index: integer; AValue: TplxRadialMenuItem
  );
begin
  inherited SetItem(Index, AValue);
end;

function TplxRadialMenuItems.Add: TplxRadialMenuItem;
begin
  Result:=TplxRadialMenuItem(inherited Add);
end;

function TplxRadialMenuItems.CountVisible: integer;
var
  i: integer;
begin
  Result:=0;
  for i:=0 to Count-1 do
    if Items[i].Visible then Result+=1;
end;

//procedure TplxRadialMenuItems.GetVisibleItems(var AItems: TplxRadialMenuItems);
//var
//  i: integer;
//begin
//  AItems.Clear;
//  AItems.Assign(self);
//  for i:=0 to AItems.Count-1 do begin
//    if i>=AItems.Count then exit;
//    if not AItems[i].Visible then AItems.Delete(i);
//  end;
//end;

{ TplxCustomRadialMenu }

procedure TplxCustomRadialMenu.SetMetrics(AValue: TplxRadialMenuMetrics);
begin
  FMetrics.Assign(AValue);
end;

function TplxCustomRadialMenu.GetAbout: string;
begin
  Result:='Copyright (c) Marcin Stefanowicz (Matek) 2019';
end;

procedure TplxCustomRadialMenu.SetStyle(AValue: TplxRadialMenuStyle);
begin
  FStyle.Assign(AValue);
end;

constructor TplxCustomRadialMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FItems:=TplxRadialMenuItems.Create(Self, TplxRadialMenuItem);
  FActiveItems:=TplxRadialMenuItems.Create(Self, TplxRadialMenuItem);
  FStack:=TplxRadialMenuItemsStack.Create(true);

  FStyle:=TplxRadialMenuStyle.Create;
  FMetrics:=TplxRadialMenuMetrics.Create(self);

  FFont:=TFont.Create;
  FFont.Assign(Screen.SystemFont);
  FFont.Quality:=fqCleartypeNatural;

  //FForm:=TplxRadialForm.Create(Self, AOwner as TCustomForm);
end;

destructor TplxCustomRadialMenu.Destroy;
begin
  FFont.Free;
  FItems.Free;
  FActiveItems.Free;
  FStack.Free;
  FStyle.Free;
  FMetrics.Free;
  //FForm.Free;

  inherited Destroy;
end;

procedure TplxCustomRadialMenu.PopUp;
begin
  PopUp(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;

procedure TplxCustomRadialMenu.PopUp(X, Y: Integer);
var
  mp: TPoint;
  r: integer;
begin
  FForm:=TplxRadialForm.Create(Self, Owner as TCustomForm);
  GetVisibleItems(FItems, FActiveItems);
  if FActiveItems.Count=0 then exit;

  r:=pX(FMetrics.R);
  if X<r then mp.x:=r else
    if X>Screen.Width-r then mp.x:=Screen.Width-r else
      mp.x:=X;
  if Y<r then mp.y:=r else
    if Y>Screen.Height-r then mp.y:=Screen.Height-r else
      mp.y:=Y;

  if FForm.Visible then Close else FForm.ShowRadialAt(mp);
end;

procedure TplxCustomRadialMenu.Close;
begin
  FForm.ActivateTimer(ttClose);
end;

{ TplxRadialForm }

procedure TplxRadialForm.SetGlobalOpacity(AValue: byte);
begin
  if FGlobalOpacity=AValue then Exit;
  FGlobalOpacity:=AValue;
  PaintRadial;
end;

procedure TplxRadialForm.OnDeactivateEv(Sender: TObject);
begin
  ActivateTimer(ttClose);
end;

procedure TplxRadialForm.OnTimerEv(Sender: TObject);
begin
  if not FController.Metrics.Animation then begin
    case FTimingType of
      ttShow: begin
        FBmpAlpha:=255;
        FBmpAngle:=0;
      end;
      ttClose: begin
        FBmpAlpha:=0;
        FBmpAngle:=-180;
        Close;
      end;
    end;

    PaintRadial;
    FTimer.Enabled:=false;
  end;
  case FTimingType of
    ttShow: begin
      IncByte(FBmpAlpha, 30);
      IncAngle(FBmpAngle, 20);

      if FBmpAngle=0 then begin
        XPoint:=ScreenToClient(Mouse.CursorPos);
        PaintRadial;
        FTimer.Enabled:=false;
        exit;
      end;
    end;
    ttClose: begin
      IncByte(FBmpAlpha, -30);
      IncAngle(FBmpAngle, -20);

      if FBmpAngle<=-180 then begin
        PaintRadial;
        Close;
        FTimer.Enabled:=false;
        exit;
      end;
    end;
  end;
  PaintRadial;
end;

procedure TplxRadialForm.OnCloseEv(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TplxRadialForm.Premultiply(BMP: TBGRABitmap);
var
  iX, iY: Integer;
  p: PBGRAPixel;
Begin
  for iY:= 0 to BMP.Height-1 do begin
    p:= BMP.Scanline[iY];
    for iX:=BMP.Width-1 downto 0 do begin
      if p^.Alpha=0 then p^:=BGRAPixelTransparent else begin
        p^.Red  := p^.Red  *(p^.Alpha+1) shr 8;
        p^.Green:= p^.Green*(p^.Alpha+1) shr 8;
        p^.Blue := p^.Blue *(p^.Alpha+1) shr 8;
      end;
      Inc(p);
    end;
  end;
end;

procedure TplxRadialForm.MakePNGWnd(WND: TCustomForm; bgraPNG: TBGRABitmap;
  bAlpha: Byte);
var
  bf: TBlendFunction;
  pt: TPoint;
  Size: TSize;
  dwStyle: DWORD;
begin
  dwStyle:= GetWindowLongA(WND.Handle, GWL_EXSTYLE);

  if (dwStyle And WS_EX_LAYERED=0)
    then SetWindowLong(WND.Handle, GWL_EXSTYLE, dwStyle or WS_EX_LAYERED);

  pt:=TPoint.Create(0, 0);
  Size.cx:=bgraPNG.Width;
  Size.cy:=bgraPNG.Height;

  bf.BlendOp:=AC_SRC_OVER;
  bf.BlendFlags:=0;
  bf.SourceConstantAlpha:=bAlpha;
  bf.AlphaFormat:=AC_SRC_ALPHA;

  BGRAPNGWnd(WND.Handle, 0, nil, @Size, bgraPNG.Bitmap.Canvas.Handle, @pt, 0, @bf, ULW_ALPHA);
end;

procedure TplxRadialForm.WMActivate(var Msg: TWMActivate);
begin
  if (Msg.Active <> WA_INACTIVE) then
    SendMessage(Self.PopupParent.Handle, WM_NCACTIVATE, WPARAM(True), -1);

  inherited;
end;

procedure TplxRadialForm.DrawBody(bmp: TBGRABitmap);
var
  r, rr: ValReal;
begin
  r:=pX(FController.Metrics.R);
  rr:=r-1-pX(FController.Metrics.Border);
  rr:=rr*(FBmpAlpha/255);
  bmp.EllipseAntialias(r, r, (r-pX(1))*(FBmpAlpha/255), (r-pX(1))*(FBmpAlpha/255), ColorToBGRA(FController.Style.Border), 1, ColorToBGRA(FController.Style.Border));
  DrawMoreBtns(bmp);
  bmp.EllipseAntialias(r, r, rr, rr, ColorToBGRA(FController.Style.Background), 1, ColorToBGRA(FController.Style.Background));
end;

procedure TplxRadialForm.DrawItem(bmp: TBGRABitmap; ind: integer);
var
  {%H-}p: TPointF;
  info: TplxRadialMenuItemInfo;
  r, rr: ValReal;
  tmp: TBGRABitmap;
begin
  p:=GetPoint(ind);
  r:=pX(FController.Metrics.R);
  rr:=r-2-pX(FController.Metrics.Border)-pX(2)/2;
  info:=TplxRadialMenuItemInfo.Create(PointF(r,r-rr), 0, self);

  if not Assigned(FController.FActiveItems) then exit;
  if Assigned(FController.FActiveItems[ind].Action) then
    (FController.FActiveItems[ind].Action as TCustomAction).Update;

  if (FBmpAlpha=255) and (Assigned(FController.FActiveItems[ind].Action) or Assigned(FController.FActiveItems[ind].OnClick)) then begin
    tmp:=TBGRABitmap.Create(bmp.Width, bmp.Height);
    try
      tmp.LineCap:=pecSquare;
      if IsItemHover(ind) then
        tmp.Arc(r, r, rr, rr, info.First, info.Second, ColorToBGRA(FController.Style.BtnHover), pX(2), false, BGRAPixelTransparent) else
      if FController.FActiveItems[ind].Checked then
        tmp.Arc(r, r, rr, rr, info.First, info.Second, ColorToBGRA(FController.Style.BtnActive), pX(2), false, BGRAPixelTransparent);

      BGRAReplace(tmp, tmp.FilterRotate(PointF(r,r), Alpha*ind));
      if not FController.FActiveItems[ind].Enabled then
        BGRAReplace(tmp, tmp.FilterGrayscale);

      bmp.PutImage(0,0,tmp,dmDrawWithTransparency);
    finally
      tmp.Free;
    end;
  end;

  info.Number:=ind;

  if (FController.Images<>nil)and(FController.FActiveItems[ind].ImageIndex>-1) then begin
    tmp:=TBGRABitmap.Create(pX(FController.Metrics.D), pY(FController.Metrics.D));
    try;
      FController.Images.StretchDraw(tmp.Canvas, FController.FActiveItems[ind].ImageIndex, roundrf(info.Image), FController.FActiveItems[ind].Enabled);

      bmp.PutImage(0,0,tmp,dmDrawWithTransparency);
    finally
      tmp.Free;
    end;
  end;

  bmp.FontName:=FController.Font.Name;
  bmp.FontHeight:=pY(12);
  bmp.FontStyle:=FController.Font.Style;
  bmp.FontQuality:=fqSystemClearType;
  bmp.Canvas.Font.Assign(FController.Font);
  bmp.Canvas.Font.Height:=bmp.FontFullHeight;
  bmp.TextRect(roundrf(info.Text), StrMaxLen(FController.FActiveItems[ind].Caption.Replace('&',''),20), taCenter, tlTop, ColorToBGRA(ifthen(FController.FActiveItems[ind].Enabled,FController.Font.Color,clGrayText),FBmpAlpha));

  {$ifdef PLXRADIALMENU_DEBUG}

  bmp.Rectangle(roundrf(info.Text), CSSRed, BGRAWhite, dmDrawWithTransparency);
  bmp.Rectangle(roundrf(info.Image), CSSRed, BGRAWhite, dmDrawWithTransparency);
  bmp.DrawPixel(round(p.x), round(p.y), CSSRed);
  bmp.TextOut(p.x, p.y, ind.ToString, CSSRed);
  bmp.DrawPixel(round(info.First.x), round(info.First.y), CSSRed);
  bmp.DrawPixel(round(info.Second.x), round(info.Second.y), CSSRed);
  bmp.DrawPixel(round(info.FirstB.x), round(info.FirstB.y), CSSRed);
  bmp.DrawPixel(round(info.SecondB.x), round(info.SecondB.y), CSSRed);
  bmp.DrawPixel(round(info.Middle.x), round(info.Middle.y), CSSRed);
  bmp.DrawPixel(round(info.MiddleB.x), round(info.MiddleB.y), CSSRed);

  {$endif}
end;

procedure TplxRadialForm.DrawItems(bmp: TBGRABitmap);
var
  i: integer;
  tmp: TBGRABitmap;
begin
  tmp:=TBGRABitmap.Create(bmp.Width, bmp.Height);
  try
    for i:=0 to FController.FActiveItems.Count-1 do
      DrawItem(tmp, i);

    BGRAReplace(tmp, tmp.Resample(round(bmp.Width*(FBmpAlpha/255)),round(bmp.Height*(FBmpAlpha/255))));

    bmp.PutImage((bmp.Width-tmp.Width)div 2, (bmp.Height-tmp.Height)div 2, tmp, dmDrawWithTransparency);
  finally
    tmp.Free;
  end;
end;

procedure TplxRadialForm.DrawArrow(bmp: TBGRABitmap);
var
  r, rr, off: ValReal;
begin
  r:=pX(FController.Metrics.R);
  rr:=pX(FController.Metrics.RBtn);
  off:=rr/3;
  bmp.EllipseAntialias(r, r, rr, rr, ColorToBGRA(FController.Style.BtnHover), pX(2), ColorToBGRA(FController.Style.Background));
  if IsBackHover and (FBmpAlpha=255) then
    bmp.EllipseAntialias(r, r, rr+2+pX(2), rr+2+pX(2), ColorToBGRA(FController.Style.BtnHover), pX(2), BGRAPixelTransparent);

  bmp.LineCap:=pecSquare;
  bmp.DrawPolyLineAntialias([PointF(r, r-off), PointF(r-off, r), PointF(r, r+off)], ColorToBGRA(FController.Style.BtnHover), pX(3));
  bmp.DrawLineAntialias(r-off+pX(3), r, r+off, r, ColorToBGRA(FController.Style.BtnHover), pX(3), true);
end;

procedure TplxRadialForm.DrawMoreBtn(bmp: TBGRABitmap; ind: integer);

  function pf(x, y: ValReal): TPointF;
  begin
    Result:=PointF(x,y);
  end;

var
  {%H-}p, pb: TPointF;
  info: TplxRadialMenuItemInfo;
  r: ValReal;
  tmp: TBGRABitmap;
  col: TBGRAPixel;
  xxx: integer;

begin
  p:=GetPoint(ind);
  r:=pX(FController.Metrics.R);
  info:=TplxRadialMenuItemInfo.Create(PointF(r,r), 0, self);

  xxx:=FController.FActiveItems[ind].Items.CountVisible;
  if (not Assigned(FController.FActiveItems))
     or
     (xxx<=0)
     then exit;

  if (FBmpAlpha=255) then begin
    tmp:=TBGRABitmap.Create(bmp.Width, bmp.Height);
    try
      tmp.LineCap:=pecSquare;
      col:=ColorToBGRA(ifthen(IsItemBtnHover(ind), FController.Style.BorderMoreBtnHover, FController.Style.BorderMoreBtn));
      tmp.Pie(r, r, r-1, r-1, info.FirstB, info.SecondB, col, 1, col);

      pb:=info.Arrow;
      tmp.DrawPolygonAntialias([pf(pb.x,pb.y-pY(3)), pf(pb.x-pX(4),pb.y+pY(3)/2), pf(pb.x+pX(4),pb.y+pY(3)/2)],
        ColorToBGRA(FController.Style.Arrow), 1, ColorToBGRA(FController.Style.Arrow));

      BGRAReplace(tmp, tmp.FilterRotate(PointF(r,r), Alpha*ind));
      if not FController.FActiveItems[ind].Enabled then
        BGRAReplace(tmp, tmp.FilterGrayscale);

      bmp.PutImage(0,0,tmp,dmDrawWithTransparency);
    finally
      tmp.Free;
    end;
  end;
end;

procedure TplxRadialForm.DrawMoreBtns(bmp: TBGRABitmap);
var
  i: integer;
begin
  for i:=0 to FController.FActiveItems.Count-1 do
    DrawMoreBtn(bmp, i);
end;

procedure TplxRadialForm.AnimateRadial(var tmp, bmp: TBGRABitmap);
var
  r: ValReal;
begin
  r:=pX(FController.Metrics.R);

  if FController.Metrics.Animation then begin
    BGRAReplace(tmp, tmp.FilterRotate(PointF(r,r), FBmpAngle));
    bmp.PutImage(0,0,tmp,dmDrawWithTransparency,FBmpAlpha);
  end else begin
    bmp.PutImage(0,0,tmp,dmDrawWithTransparency);
  end;
end;

procedure TplxRadialForm.PaintRadial;
var
  bmp, tmp: TBGRABitmap;
begin
  bmp:=TBGRABitmap.Create(pX(FController.Metrics.D), pX(FController.Metrics.D));
  try
    tmp:=TBGRABitmap.Create(pX(FController.Metrics.D), pX(FController.Metrics.D));
    try
      DrawBody(tmp);
      DrawItems(tmp);

      AnimateRadial(tmp, bmp);
    finally
      tmp.Free;
    end;

    DrawArrow(bmp);

    Premultiply(bmp);
    MakePNGWnd(self,bmp,FGlobalOpacity);
  finally
    bmp.Free;
  end;
end;

procedure TplxRadialForm.ActivateTimer(att: TplxTimingType);
begin
  FTimingType:=att;

  case FTimingType of
    ttShow: begin
      FTimer.Enabled:=false;
      FBmpAlpha:=0;
      FBmpAngle:=-180;

      PaintRadial;
      Show;
    end;
    ttClose: begin
      FTimer.Enabled:=false;
      FBmpAlpha:=255;
      FBmpAngle:=0;

      PaintRadial;
    end;
  end;

  FTimer.Enabled:=true;
end;

procedure TplxRadialForm.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  XPoint.x:=X;
  XPoint.y:=Y;
  if not FTimer.Enabled then PaintRadial;
end;

procedure TplxRadialForm.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  ind: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  XPoint.x:=X;
  XPoint.y:=Y;

  if IsBackHover then Back else begin
    ind:=GetHoverInd;
    if (ind>-1)and(FController.FActiveItems[ind].Enabled) then begin
      if Assigned(FController.FActiveItems[ind].Action) then
        FController.FActiveItems[ind].Action.Execute else
          if Assigned(FController.FActiveItems[ind].OnClick) then
            FController.FActiveItems[ind].OnClick(FController.FActiveItems[ind]) else
              exit;
      ActivateTimer(ttClose);
    end else begin
      ind:=GetBtnHoverInd;
      if (ind>-1)and(FController.FActiveItems[ind].Enabled) then
        GoToItem(FController.FActiveItems[ind]);
    end;
  end;
end;

procedure TplxRadialForm.MouseLeave;
begin
  inherited MouseLeave;

  XPoint:=TPoint.Zero;
  PaintRadial;
end;

procedure TplxRadialForm.KeyPress(var Key: char);
begin
  inherited KeyPress(Key);

  if Key=char(VK_ESCAPE) then ActivateTimer(ttClose);
end;

constructor TplxRadialForm.Create(AOwner: TComponent; MainFrm: TCustomForm);
begin
  inherited CreateNew(AOwner);
  PopupParent:=MainFrm;
  FController:=Owner as TplxCustomRadialMenu;
  FTimer:=TSimpleTimer.Create(self);
  FTimer.Interval:=1;
  FTimer.Enabled:=false;
  FTimer.OnTimer:=@OnTimerEv;

  BorderStyle:=bsNone;
  FormStyle:=fsStayOnTop;
  FGlobalOpacity:=255;
  ControlStyle:=ControlStyle+[csNoFocus];
  Visible:=false;
  OnDeactivate:=@OnDeactivateEv;
  Application.AddOnDeactivateHandler(@OnDeactivateEv);
  OnClose:=@OnCloseEv;

  SetWindowLong(Self.Handle, GWL_EXSTYLE, GetWindowLong(Self.Handle, GWL_EXSTYLE) or WS_EX_NOACTIVATE);
end;

destructor TplxRadialForm.Destroy;
begin
  Application.RemoveOnDeactivateHandler(@OnDeactivateEv);

  inherited Destroy;
end;

function TplxRadialForm.Alpha: double;
begin
  if Assigned(FController.FActiveItems) then
    Result:=360/FController.FActiveItems.CountVisible;
end;

function TplxRadialForm.GetPoint(Nr: integer): TPointF;
var
  r, a: ValReal;
begin
  r:=pX(FController.Metrics.R);
  if (Nr<0) or (Nr>FController.FActiveItems.Count-1) then exit(PointF(-r,-r));

  a:=Alpha*Nr;
  Result:=RotatePoint(PointF(r,r), PointF(r,r/2.2), a);
  Result.y:=Result.y-pY(FController.Metrics.Border)/2.2;
end;

function TplxRadialForm.IsBackHover: boolean;
var
  r, rr: ValReal;
begin
  r:=pX(FController.Metrics.R);
  rr:=pX(FController.Metrics.RBtn);

  Result:= TPoint.PointInCircle(XPoint, PointF(r,r).Round, round(rr));
end;

function TplxRadialForm.IsItemHover(Nr: integer): boolean;
var
  r, rr: ValReal;
  info: TplxRadialMenuItemInfo;
begin
  r:=pX(FController.Metrics.R);
  rr:=r-2-pX(FController.Metrics.Border)-pX(2)/2;
  info:=TplxRadialMenuItemInfo.Create(PointF(r,r-rr), nr, self);

  Result:= not IsBackHover
           and
           TPoint.PointInCircle(XPoint, PointF(r,r).Round, Round(r)-pX(FController.Metrics.Border))
           and
           PointInPolygon(XPoint, [info.First.Round, info.Middle.Round, info.Second.Round, PointF(r,r).Round, info.First.Round]);
end;

function TplxRadialForm.IsItemBtnHover(Nr: integer): boolean;
var
  r, rr: ValReal;
  info: TplxRadialMenuItemInfo;
begin
  r:=pX(FController.Metrics.R);
  rr:=r-2-pX(FController.Metrics.Border)-pX(2)/2;
  info:=TplxRadialMenuItemInfo.Create(PointF(r,r-rr), nr, self);

  Result:= (FController.FActiveItems[nr].Items.CountVisible>0)
           and
           not IsBackHover
           and
           TPoint.PointInCircle(XPoint, PointF(r,r).Round, Round(r))
           and
           not TPoint.PointInCircle(XPoint, PointF(r,r).Round, Round(r)-pX(FController.Metrics.Border))
           and
           PointInPolygon(XPoint, [info.First.Round, info.Middle.Round, info.Second.Round, info.SecondB.Round, info.MiddleB.Round, info.FirstB.Round, info.First.Round]);
end;

function TplxRadialForm.GetHoverInd: integer;
var
  i: integer;
begin
  Result:=-1;

  for i:=0 to FController.FActiveItems.Count-1 do
    if IsItemHover(i) then exit(i);
end;

function TplxRadialForm.GetBtnHoverInd: integer;
var
  i: integer;
begin
  Result:=-1;

  for i:=0 to FController.FActiveItems.Count-1 do
    if IsItemBtnHover(i) then exit(i);
end;

procedure TplxRadialForm.Back;
label
  UsunOrazMaluj, NieRobNic;
begin
  if FController.FStack.Count=0 then begin
    if not FTimer.Enabled then
      ActivateTimer(ttClose);
    goto NieRobNic;
  end elif FController.FStack.Count=1 then begin
    GetVisibleItems(FController.Items, FController.FActiveItems);
    goto UsunOrazMaluj;
  end else begin
    GetVisibleItems(FController.FStack.Last, FController.FActiveItems);
    goto UsunOrazMaluj;
  end;
  UsunOrazMaluj:
  FController.FStack.Remove(FController.FStack.Last);
  PaintRadial;
  NieRobNic:
end;

procedure TplxRadialForm.GoToItem(AItem: TplxRadialMenuItem);
var
  it: TplxRadialMenuItems;
begin
  FController.FStack.Add(TplxRadialMenuItems.Create(AItem, TplxRadialMenuItem));
  FController.FStack.Last.Assign(FController.FActiveItems);
  //TRZEBA TUTAJ ZROBIĆ KOPIĘ LISTY ITEMÓW!!!
  it:=TplxRadialMenuItems.Create(self, TplxRadialMenuItem);
  try
    it.Assign(AItem.Items);
    GetVisibleItems(it, FController.FActiveItems);
  finally
    it.Free;
  end;

  PaintRadial;
end;

procedure TplxRadialForm.Prepare;
begin
  Width:=pX(FController.Metrics.D);
  Height:=Width;

  //WAŻNE! TRZEBA WYCZYŚCIĆ STOS
  FController.FStack.Clear;

  PaintRadial;
end;

procedure TplxRadialForm.ShowRadialAt(Pnt: TPoint);
begin
  Prepare;
  Left:=Pnt.x-pX(FController.Metrics.R);
  Top:=Pnt.y-pX(FController.Metrics.R);

  ActivateTimer(ttShow);
end;

{ TplxRadialMenuStyle }

constructor TplxRadialMenuStyle.Create;
begin
  inherited;

  ApplyDefaultTheme;
end;

procedure TplxRadialMenuStyle.Assign(Source: TPersistent);
var
  s: TplxRadialMenuStyle;
begin
  if Source is TplxRadialMenuStyle then begin
    s:=Source as TplxRadialMenuStyle;

    FBackground:=s.FBackground;
    FBorder:=s.FBorder;
    FBorderMoreBtn:=s.FBorderMoreBtn;
    FBorderMoreBtnHover:=s.FBorderMoreBtnHover;
    FBtnActive:=s.FBtnActive;
    FBtnHover:=s.FBtnHover;
    FArrow:=s.FArrow;
  end;
end;

procedure TplxRadialMenuStyle.ApplyDefaultTheme;
begin
  FBackground:=clWhite;
  FBorder:=$00ebdaf2;
  FBorderMoreBtn:=$007b3980;
  FBorderMoreBtnHover:=$0095529b;
  FBtnActive:=$00B780BB;
  FBtnHover:=$007b3980;
  FArrow:=clWhite;
end;

{ TplxRadialMenuMetrics }

function TplxRadialMenuMetrics.GetD: integer;
begin
  Result:=FR*2;
end;

constructor TplxRadialMenuMetrics.Create(AFrom: TplxCustomRadialMenu);
begin
  inherited Create;
  FController:=AFrom;

  RestoreDefaults;
end;

destructor TplxRadialMenuMetrics.Destroy;
begin
  FController:=nil;

  inherited Destroy;
end;

procedure TplxRadialMenuMetrics.Assign(Source: TPersistent);
var
  s: TplxRadialMenuMetrics;
begin
  if Source is TplxRadialMenuMetrics then begin
    s:=Source as TplxRadialMenuMetrics;

    FR:=s.FR;
    FAnimation:=s.FAnimation;
    FBorder:=s.FBorder;
    FRBtn:=s.FRBtn;
  end;
end;

procedure TplxRadialMenuMetrics.RestoreDefaults;
begin
  FR:=150;
  FAnimation:=false;
  FBorder:=25;
  FRBtn:=25;
end;

{ TplxRadialMenuActionLink }

procedure TplxRadialMenuActionLink.AssignClient(AClient: TObject);
begin
  FClient:=AClient as TplxRadialMenuItem;
end;

function TplxRadialMenuActionLink.IsCaptionLinked: Boolean;
begin
  Result:=inherited IsCaptionLinked and (FClient.Caption = (Action as TCustomAction).Caption);
end;

function TplxRadialMenuActionLink.IsCheckedLinked: Boolean;
begin
  Result:=inherited IsCheckedLinked and (FClient.Checked = (Action as TCustomAction).Checked);
end;

function TplxRadialMenuActionLink.IsEnabledLinked: Boolean;
begin
  Result:=inherited IsEnabledLinked and (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TplxRadialMenuActionLink.IsHelpContextLinked: Boolean;
begin
  Result:=false;
end;

function TplxRadialMenuActionLink.IsHintLinked: Boolean;
begin
  Result:=inherited IsHintLinked and (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TplxRadialMenuActionLink.IsImageIndexLinked: Boolean;
begin
  Result:=inherited IsImageIndexLinked and (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TplxRadialMenuActionLink.IsShortCutLinked: Boolean;
begin
  Result:=false;
end;

function TplxRadialMenuActionLink.IsVisibleLinked: Boolean;
begin
  Result:=inherited IsVisibleLinked and (FClient.Visible = (Action as TCustomAction).Visible);
end;

function TplxRadialMenuActionLink.IsOnExecuteLinked: Boolean;
begin
  Result:=inherited IsOnExecuteLinked and (@FClient.OnClick = @Action.OnExecute);
end;

procedure TplxRadialMenuActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption:=Value;
end;

procedure TplxRadialMenuActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Checked:=Value;
end;

procedure TplxRadialMenuActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled:=Value;
end;

procedure TplxRadialMenuActionLink.SetHelpContext(Value: THelpContext);
begin
  //nic
end;

procedure TplxRadialMenuActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint:=Value;
end;

procedure TplxRadialMenuActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex:=Value;
end;

procedure TplxRadialMenuActionLink.SetShortCut(Value: TShortCut);
begin
  //nic
end;

procedure TplxRadialMenuActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible:=Value;
end;

procedure TplxRadialMenuActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick:=Value;
end;

{$warnings on}
{$hints on}

end.
