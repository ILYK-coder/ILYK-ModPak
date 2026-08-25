[Setup]
AppName=ILYK ModPak
AppVersion=1.0
AppPublisher=ILYK
DefaultDirName={code:GetDestDir|{userdocs}\MyGames}
AppendDefaultDirName=no
DisableDirPage=no
DisableProgramGroupPage=yes
OutputBaseFilename=ILYK_ModPak_Setup
Compression=lzma2/max
SolidCompression=yes

[Files]
Source: "SourceFiles\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Code]
var
  DirPage: TInputDirWizardPage;

function GetDestDir(Param: String): String;
begin
  Result := DirPage.Values[0];
end;

procedure InitializeWizard;
begin
  DirPage := CreateInputDirPage(wpSelectDir,
    'Select Installation Directory', 'Select World of Tanks Directory',
    'Please select where World of Tanks is installed, then click Next.',
    False, 'New Folder');
  DirPage.Add('');
  DirPage.Values[0] := ExpandConstant('{userdocs}\MyGames');
end;
