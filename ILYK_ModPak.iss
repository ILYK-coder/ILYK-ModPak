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
Source: "XVM\*"; DestDir: "{app}\mods\xvm"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\ILYK ModPak"; Filename: "{app}"
Name: "{group}\Видалити ILYK ModPak"; Filename: "{uninstallexe}"
Name: "{group}\XVM Config"; Filename: "{app}\mods\xvm"

[Run]
Filename: "{app}"; Description: "Запустити каталог модпака"; Flags: postinstall nowait

[Code]
var
  DirPage: TInputDirWizardPage;
  LogFile: String;

procedure LogMessage(Message: String);
var
  F: TStrings;
begin
  try
    if FileExists(LogFile) then
    begin
      F := TStringList.Create;
      F.LoadFromFile(LogFile);
      F.Add('[' + GetDateTimeString('hh:mm:ss', '/', ':') + '] ' + Message);
      F.SaveToFile(LogFile);
      F.Free;
    end
    else
    begin
      F := TStringList.Create;
      F.Add('[' + GetDateTimeString('hh:mm:ss', '/', ':') + '] ' + Message);
      F.SaveToFile(LogFile);
      F.Free;
    end;
  except
  end;
end;

function GetDestDir(Param: String): String;
begin
  if DirPage.Values[0] = '' then
    Result := ExpandConstant('{userdocs}\MyGames')
  else
    Result := DirPage.Values[0];
end;

procedure InitializeWizard;
begin
  LogFile := ExpandConstant('{tmp}\ILYK_ModPak_Install.log');
  LogMessage('=== Початок встановлення ILYK ModPak ===');
  LogMessage('Версія: 1.0');
  
  { Створити сторінку вибору каталогу }
  DirPage := CreateInputDirWizardPage(wpSelectDir,
    'Вибір каталогу встановлення', 
    'Виберіть каталог World of Tanks',
    'Будь ласка, виберіть папку, де встановлено World of Tanks, потім натисніть "Далі".',
    False, 
    'Нова папка');
  
  DirPage.Add('');
  DirPage.Values[0] := ExpandConstant('{userdocs}\MyGames');
  LogMessage('Стандартна папка встановлення: ' + DirPage.Values[0]);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = DirPage.ID then
  begin
    if DirPage.Values[0] = '' then
    begin
      LogMessage('ПОМИЛКА: Користувач не вибрав каталог встановлення');
      MsgBox('Будь ласка, виберіть каталог встановлення!', mbError, MB_OK);
      Result := False;
    end
    else
    begin
      LogMessage('Вибраний каталог: ' + DirPage.Values[0]);
      Result := True;
    end
  end
  else
    Result := True;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpReady then
  begin
    LogMessage('Перевірка налаштувань перед встановленням...');
    WizardForm.ReadyMemo.Lines.Add('Каталог встановлення: ' + GetDestDir(''));
    WizardForm.ReadyMemo.Lines.Add('XVM мод буде встановлено в: ' + GetDestDir('') + '\mods\xvm');
  end;
end;

procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
begin
  LogMessage('Прогрес встановлення: ' + IntToStr(CurProgress) + ' / ' + IntToStr(MaxProgress));
end;

procedure CurUninstallProgressChanged(CurProgress, MaxProgress: Integer);
begin
  LogMessage('Прогрес видалення: ' + IntToStr(CurProgress) + ' / ' + IntToStr(MaxProgress));
end;

procedure DeinitializeSetup;
begin
  LogMessage('=== Завершення встановлення ILYK ModPak ===');
end;
