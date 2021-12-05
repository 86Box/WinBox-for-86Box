unit dmGraphUtil;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, Forms,
  ImageList, ImgList, WinCodec,
  VirtualImageList, BaseImageCollection, ImageCollection;

type
  TIconSet = class(TDataModule)
    ListImages: TImageCollection;
    ListIcons: TVirtualImageList;
    ActionImages: TImageCollection;
    Icons32: TVirtualImageList;
    Icons16: TVirtualImageList;
  public
    IsColorsAllowed: boolean;

    constructor Create(AOwner: TComponent); override;

    //Ha m�r a MainForm is l�tre van hozva, be�ll�tani mindent.
    procedure Initialize(AControl: TControl);

    //K�pek friss�t�se pl. k�prajzol� elj�r�sok cser�je ut�n
    procedure RefreshImages;

    //T�kr�z�tt k�prajzol� elj�r�sok
    procedure GetBitmapBiDi(ASourceImage: TWICImage; AWidth,
      AHeight: Integer; out ABitmap: TBitmap);
    procedure DrawBiDi(ASourceImage: TWICImage;
      ACanvas: TCanvas; ARect: TRect; AProportional: Boolean);
  end;

var
  IconSet: TIconSet;

implementation

uses uLang;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TIconSet }

constructor TIconSet.Create(AOwner: TComponent);
begin
  inherited;
  IsColorsAllowed := true;
end;

//Az AProportional tulajdons�g jelenleg nem t�mogatott ezen a m�don.
procedure TIconSet.DrawBiDi(ASourceImage: TWICImage; ACanvas: TCanvas;
  ARect: TRect; AProportional: Boolean);
begin
  if ARect.IsEmpty then
    Exit;

  if ASourceImage <> nil then begin
    ASourceImage.InterpolationMode := wipmHighQualityCubic;
    ACanvas.StretchDraw(ARect, ASourceImage);
  end;
end;

//Ez a verzi� bitk�pp� konvert�lja a k�p �j Handle-j�t, �s felszabad�tja
procedure TIconSet.GetBitmapBiDi(ASourceImage: TWICImage; AWidth,
  AHeight: Integer; out ABitmap: TBitmap);
var
  RotatedImage: TWICImage;
  BufferImage: TWICImage;
  Factory: IWICImagingFactory;
  Rotator: IWICBitmapFlipRotator;
begin
  Factory := TWICImage.ImagingFactory;
  Factory.CreateBitmapFlipRotator(Rotator);
  Rotator.Initialize(ASourceImage.Handle, WICBitmapTransformFlipHorizontal);

  ABitmap := TBitmap.Create;

  RotatedImage := TWICImage.Create;
  RotatedImage.Handle := IWICBitmap(Rotator);

  try
    if (ASourceImage.Width = AWidth) and (ASourceImage.Height = AHeight) then
      ABitmap.Assign(RotatedImage)
    else begin
      BufferImage := RotatedImage.CreateScaledCopy(AWidth, AHeight,
        wipmHighQualityCubic);
      try
        ABitmap.Assign(BufferImage);
      finally
        BufferImage.Free;
      end;
    end;
  finally
    RotatedImage.Free;
  end;

  if ABitmap.PixelFormat = pf32bit then
    ABitmap.AlphaFormat := afIgnored;
end;

procedure TIconSet.Initialize(AControl: TControl);
const
  ListIconSize = 42;
begin
  with AControl do begin
    Icons16.SetSize(GetSystemMetrics(SM_CXSMICON),
                    GetSystemMetrics(SM_CYSMICON));

    Icons32.SetSize(GetSystemMetrics(SM_CXICON),
                    GetSystemMetrics(SM_CYICON));

    ListIcons.SetSize(ListIconSize * CurrentPPI div 96,
                      ListIconSize * CurrentPPI div 96);
  end;
end;

procedure TIconSet.RefreshImages;
begin
  if LocaleIsBiDi then begin
    ListImages.OnDraw := DrawBiDi;
    ListImages.OnGetBitmap := GetBitmapBiDi;

    ActionImages.OnDraw := DrawBiDi;
    ActionImages.OnGetBitmap := GetBitmapBiDi;
  end
  else begin
    ListImages.OnDraw := nil;
    ListImages.OnGetBitmap := nil;

    ActionImages.OnDraw := nil;
    ActionImages.OnGetBitmap := nil;
  end;

  Icons16.UpdateImageList;
  ListIcons.UpdateImageList;

  ActionImages.OnDraw := nil;
  ActionImages.OnGetBitmap := nil;

  Icons32.UpdateImageList;
end;

end.
