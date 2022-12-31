program DistanceOnImage;

uses
  Vcl.Forms,
  DistanceOnImageMain in 'DistanceOnImageMain.pas' {DistanceOnImageForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDistanceOnImageForm, DistanceOnImageForm);
  Application.Run;
end.
