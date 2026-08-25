[Setup]
AppName=ILYK ModPak
AppVersion=1.0
AppPublisher=ILYK
DefaultDirName={code:GetDestDir|C:\Games}
AppendDefaultDirName=no
DisableDirPage=no
DisableProgramGroupPage=yes
OutputBaseFilename=ILYK_ModPak_Setup
OutputDir=Output
Compression=lzma2/max
SolidCompression=yes
SetupIconFile=
WizardStyle=modern
ShowLanguageDialog=no
LanguageDetectionMethod=uilanguage
DefaultLanguage=ukrainian
LicenseFile=

[Languages]
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "SourceFiles\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\ILYK ModPak"; Filename: "{app}"
Name: "{group}\Видалити ILYK ModPak"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}"; Description: "Запустити каталог модпака"; Flags: postinstall nowait

[Code]
var
  DirPage: TInputDirWizardPage;

function GetDestDir(Param: String): String;
begin
  if DirPage.Values[0] = '' then
    Result := ExpandConstant('{userdocs}\MyGames')
  else
    Result := DirPage.Values[0];
end;

procedure InitializeWizard;
begin
  { Створити сторінку вибору каталогу }
  DirPage := CreateInputDirPage(wpSelectDir,
    'Вибір каталогу встановлення', 
    'Виберіть каталог World of Tanks',
    'Будь ласка, виберіть папку, де встановлено World of Tanks, потім натисніть "Далі".',
    False, 
    'Нова папка');
  
  DirPage.Add('');
  DirPage.Values[0] := ExpandConstant('{userdocs}\MyGames');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = DirPage.ID then
  begin
    if DirPage.Values[0] = '' then
    begin
      MsgBox('Будь ласка, виберіть каталог встановлення!', mbError, MB_OK);
      Result := False;
    end
    else
      Result := True;
  end
  else
    Result := True;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpReady then
  begin
    WizardForm.ReadyMemo.Lines.Add('Каталог встановлення: ' + GetDestDir(''));
  end;
end;
