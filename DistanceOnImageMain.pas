{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Creation:     Dec 31, 2022
Description:  Simple demo showing how to load a JPG in a TImage and resizing
              the view so that the entire image fits is TImage?
              Show how to compute the distance between two mouse click,
              expressed in the coordinate space of the image.
              The code is kept as simple as possible. There should be more
              tests to prevent bad behavior with invalid parameters.
Version:      1.00
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      No support provided. Try sending me an email.
Legal issues: Copyright (C) 2022 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit DistanceOnImageMain;

interface

uses
    Winapi.Windows, Winapi.Messages,
    System.SysUtils, System.Variants, System.Classes, System.Types,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
    Vcl.StdCtrls, Vcl.Imaging.jpeg;

type
    // Utility class designed to isolate code required to load and resize an
    // image.
    TImgClass = class(TComponent)
    private
        FDstImage   : TImage;
        procedure SetDstImage(const Value: TImage);
    public
        Img        : TJPEGImage;
        ImgProp    : Single;
        PicProp    : Single;
        ImgScale   : Single;
        LeftMargin : Integer;
        TopMargin  : Integer;
        ARect      : TRect;
        function  LoadFromFile(const FileName : String) : Boolean;
        procedure Resize;
        function  MouseToImage(X : Integer; Y : Integer;
                               out XI : Integer; out YI : Integer) : Boolean;
        property DstImage   : TImage read FDstImage write SetDstImage;
        destructor Destroy; override;
    end;

    TDistanceOnImageForm = class(TForm)
        LoadImage1Button: TButton;
        DstImage : TImage;
        LoadImage2Button: TButton;
        DisplayMemo: TMemo;
        Click1ValueLabel: TLabel;
        Click2ValueLabel: TLabel;
        Click1Label: TLabel;
        Click2Label: TLabel;
        DistLabel: TLabel;
        DistValueLabel: TLabel;
        procedure LoadImage1ButtonClick(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure LoadImage2ButtonClick(Sender: TObject);
        procedure DstImageClick(Sender: TObject);
    private
        ImgClass  : TImgClass;
        FClick2   : Boolean;
        FClick1Pt : TPoint;
        FClick2Pt : TPoint;
        procedure Display(const Msg : String); overload;
        procedure Display(const Msg : String; Args : array of const); overload;
    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy; override;
    end;

var
  DistanceOnImageForm: TDistanceOnImageForm;

implementation

{$R *.dfm}

constructor TDistanceOnImageForm.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    DistValueLabel.Caption   := '-';
    Click1ValueLabel.Caption := '-';
    Click2ValueLabel.Caption := '-';
    Click1Label.Font.Style   := [TFontStyle.fsBold];
    FClick1Pt                := Point(-1, -1);
    FClick2Pt                := Point(-1, -1);
    ImgClass                 := TImgClass.Create(Self);
    ImgClass.DstImage        := DstImage;
end;

destructor TDistanceOnImageForm.Destroy;
begin
    FreeAndNil(ImgClass);
    inherited Destroy;
end;

procedure TDistanceOnImageForm.Display(const Msg: String; Args: array of const);
begin
    Display(Format(Msg, Args));
end;

procedure TDistanceOnImageForm.Display(const Msg: String);
begin
    DisplayMemo.Lines.Add(Msg);
    SendMessage(DisplayMemo.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TDistanceOnImageForm.DstImageClick(Sender: TObject);
var
    Pt     : TPoint;
    XI, YI : Integer;
begin
    Pt := DstImage.ScreenToClient(Mouse.CursorPos);
    ImgClass.MouseToImage(Pt.X, Pt.Y, XI, YI);
    if FClick2 then begin
        FClick2Pt                := Point(XI, YI);
        Click2ValueLabel.Caption := Format('X=%d  Y=%d', [XI, YI]);
        Click1Label.Font.Style   := [TFontStyle.fsBold];
        Click2Label.Font.Style   := [];
    end
    else begin
        FClick1Pt                := Point(XI, YI);
        Click1ValueLabel.Caption := Format('X=%d  Y=%d', [XI, YI]);
        Click2Label.Font.Style   := [TFontStyle.fsBold];
        Click1Label.Font.Style   := [];
    end;
    FClick2 := not FClick2;
    if FClick2Pt.X >= 0 then
        DistValueLabel.Caption := Format(
            '%d',
            [Trunc(SQRT(Sqr(FClick2Pt.X - FClick1Pt.X) +
            Sqr(FClick2Pt.Y - FClick1Pt.Y)))]);
end;

procedure TDistanceOnImageForm.FormResize(Sender: TObject);
begin
    if Assigned(ImgClass) then
        ImgClass.Resize;
end;

procedure TDistanceOnImageForm.LoadImage1ButtonClick(Sender: TObject);
begin
    // Load a somewhat large image
    // Adapt the path to your configuration
    ImgClass.LoadFromFile('..\..\Images\FPI09233_2 Liège - Tour des Finances - Plongeur.jpg');
    Display('ImageSize W=%d  H=%d', [ImgClass.Img.Width, ImgClass.Img.Height]);
end;

procedure TDistanceOnImageForm.LoadImage2ButtonClick(Sender: TObject);
begin
    // Load a somewhat small image
    // Adapt the path to your configuration
    ImgClass.LoadFromFile('..\..\Images\FPI01488_2 Cascade de Chanxhe.jpg');
    if Assigned(ImgClass.Img) then
        Display('ImageSize W=%d  H=%d',
                [ImgClass.Img.Width, ImgClass.Img.Height]);
end;


{ TImgClass }

destructor TImgClass.Destroy;
begin
    FreeAndNil(Img);
    inherited Destroy;
end;

function TImgClass.LoadFromFile(const FileName : String) : Boolean;
begin
    if not Assigned(Img) then
        Img := TJPEGImage.Create;

    try
        Img.LoadFromFile(FileName);
        Resize;
        Result := TRUE;
    except
        on E:Exception do begin
            ShowMessage('Error loading file' + #10 + FileName + #10 +
                        E.ClassName + ':' + E.Message);
            FreeAndNil(Img);
            Result := FALSE;
        end;
    end;
end;

function Translate(A, B, C, D, E : Integer) : Integer;
begin
    Result := C + Trunc((D - C) * (E - A) / (B - A));
end;

function TImgClass.MouseToImage(X, Y: Integer; out XI, YI: Integer): Boolean;
begin
    if (not Assigned(DstImage)) or (not Assigned(Img)) or
       (not ARect.Contains(Point(X, Y))) then begin
        XI     := -1;
        YI     := -1;
        Result := FALSE;
        Exit;
    end;

    XI     := Translate(ARect.Left, ARect.Right, 0, Img.Width, X);
    YI     := Translate(ARect.Top, ARect.Bottom, 0, Img.Height, Y);
    Result := TRUE;
end;

procedure TImgClass.Resize;
begin
    if not Assigned(DstImage) then    // No rendering, exit
        Exit;
    if (DstImage.Height <= 0) or (DstImage.Width < 0) then // No rendering, exit
        Exit;

    DstImage.Picture.Bitmap.Width  := DstImage.Width;
    DstImage.Picture.Bitmap.Height := DstImage.Height;
    DstImage.Picture.Bitmap.Canvas.Brush.Color := clBtnFace;

    if not Assigned(Img) then          // No image loaded, exit
        Exit;

    ImgProp  := Img.Width / Img.Height;
    PicProp  := DstImage.Width / DstImage.Height;

    if PicProp >= ImgProp then begin
        ImgScale     := Img.Height / DstImage.Height;
        LeftMargin   := (DstImage.Width - Trunc(Img.Width / ImgScale)) div 2;
        ARect.Top    := 0;
        ARect.Left   := LeftMargin;
        ARect.Right  := LeftMargin + Trunc(Img.Width / ImgScale);
        ARect.Bottom := DstImage.Height;
        DstImage.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, ARect.Left, ARect.Height));
        DstImage.Picture.Bitmap.Canvas.FillRect(Rect(ARect.Right, 0, DstImage.Width, DstImage.Height));
    end
    else begin
        ImgScale     := Img.Width / DstImage.Width;
        TopMargin    := (DstImage.Height - Trunc(Img.Height / ImgScale)) div 2;
        ARect.Top    := TopMargin;
        ARect.Left   := 0;
        ARect.Right  := DstImage.Width;
        ARect.Bottom := TopMargin + Trunc(Img.Height / ImgScale);
        DstImage.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, ARect.Width, ARect.Top));
        DstImage.Picture.Bitmap.Canvas.FillRect(Rect(0, ARect.Bottom, ARect.Width, DstImage.Height));
    end;
    DstImage.Picture.Bitmap.Canvas.StretchDraw(ARect, Img);
end;

procedure TImgClass.SetDstImage(const Value: TImage);
begin
    FDstImage                      := Value;
    DstImage.Picture.Bitmap.Width  := DstImage.Width;
    DstImage.Picture.Bitmap.Height := DstImage.Height;
    DstImage.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, DstImage.Width, DstImage.Top));
end;

end.
