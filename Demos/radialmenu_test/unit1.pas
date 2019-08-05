unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdActns,
  StdCtrls, PospoLite.Menus.Radial;

type

  { TForm1 }

  TForm1 = class(TForm)
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    ImageList1: TImageList;
    Memo1: TMemo;
    plxRadialMenu1: TplxRadialMenu;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure plxRadialMenu1Items6Items2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
//var
//  m: TplxRadialMenu;
//  i: integer;
begin
  //m:=TplxRadialMenu.Create(self);
  ////m.Metrics.R:=300;
  //m.Metrics.Animation:=false;
  //m.Images:=ImageList1;
  //for i:=0 to 7 do
  //  with m.Items.Add do begin
  //    Caption:='Testzażółćgęśląśńóąłjaźń';
  //    //ImageIndex:=0;
  //  end;
  //
  //PopupMenu:=m;
end;

procedure TForm1.plxRadialMenu1Items6Items2Click(Sender: TObject);
begin
  ShowMessage('It works!');
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

end.

