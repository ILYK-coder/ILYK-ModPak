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
LicenseFile=
WizardImageFile=compiler:WizardModernImage.bmp
WizardSmallImageFile=compiler:WizardModernSmallImage.bmp

[Languages]
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
ukrainian.InfoPageTitle=Інформація про ILYK ModPak
ukrainian.InfoPageDesc=Виберіть додаткові опції встановлення
ukrainian.SystemCheckTitle=Перевірка системних вимог
ukrainian.SystemCheckDesc=Перевіримо вашу систему перед встановленням
ukrainian.UserRegTitle=Реєстрація користувача
ukrainian.UserRegDesc=Введіть вашу інформацію
ukrainian.ComponentsPageTitle=Вибір компонентів
ukrainian.ComponentsPageDesc=Виберіть що встановлювати

[Files]
Source: "SourceFiles\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "XVM\*"; DestDir: "{app}\mods\xvm"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "ModPakLogo.bmp"; DestDir: "{tmp}"; Flags: dontcopy

[Icons]
Name: "{group}\ILYK ModPak"; Filename: "{app}"
Name: "{group}\Видалити ILYK ModPak"; Filename: "{uninstallexe}"
Name: "{group}\XVM Config"; Filename: "{app}\mods\xvm"
Name: "{commondesktop}\ILYK ModPak"; Filename: "{app}"; IconIndex: 0

[Run]
Filename: "{app}"; Description: "Запустити каталог модпака"; Flags: postinstall nowait

[Code]
var
  DirPage: TInputDirWizardPage;
  InfoPage: TWizardPage;
  SystemCheckPage: TWizardPage;
  UserRegPage: TWizardPage;
  ComponentsPage: TWizardPage;
  LogFile: String;
  UsernameEdit: TEdit;
  EmailEdit: TEdit;
  TermsCheckBox: TCheckBox;
  XVMCheckBox: TCheckBox;
  SkinPackCheckBox: TCheckBox;
  ConfigCheckBox: TCheckBox;

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

function CheckDiskSpace: Boolean;
var
  DriveLetter: String;
  FreeSpace: Int64;
begin
  DriveLetter := Copy(GetDestDir(''), 1, 1);
  FreeSpace := GetDiskFreeSpace(DriveLetter);
  
  if FreeSpace < 5000000000 then { 5GB }
  begin
    LogMessage('ПОМИЛКА: Недостатньо місця на диску. Потрібно мінімум 5GB');
    MsgBox('На диску недостатньо місця! Потрібно мінімум 5GB вільного місця.', mbError, MB_OK);
    Result := False;
  end
  else
  begin
    LogMessage('Перевірка диску: OK. Вільно ' + IntToStr(FreeSpace div 1000000000) + 'GB');
    Result := True;
  end;
end;

function CheckSystemMemory: Boolean;
var
  MemorySize: Int64;
begin
  MemorySize := GetMem64(0);
  
  if MemorySize < 2000000000 then { 2GB }
  begin
    LogMessage('ПОМИЛКА: Недостатньо RAM. Потрібно мінімум 2GB');
    MsgBox('На вашому комп''ютері недостатньо RAM! Потрібно мінімум 2GB.', mbError, MB_OK);
    Result := False;
  end
  else
  begin
    LogMessage('Перевірка пам''яті: OK. Доступно ' + IntToStr(MemorySize div 1000000000) + 'GB');
    Result := True;
  end;
end;

function CheckWindowsVersion: Boolean;
var
  WinVersion: String;
begin
  if not IsWin7OrLater then
  begin
    LogMessage('ПОМИЛКА: Потрібна Windows 7 або новіша');
    MsgBox('Потрібна Windows 7 або новіша версія!', mbError, MB_OK);
    Result := False;
  end
  else
  begin
    LogMessage('Перевірка Windows: OK');
    Result := True;
  end;
end;

function CheckWorldOfTanks: Boolean;
begin
  if FileExists(GetDestDir('') + '\WorldOfTanks.exe') or 
     FileExists(GetDestDir('') + '\WoTLauncher.exe') then
  begin
    LogMessage('World of Tanks знайдено в: ' + GetDestDir(''));
    Result := True;
  end
  else
  begin
    LogMessage('ПОПЕРЕДЖЕННЯ: World of Tanks не знайдено в вибраній папці');
    if MsgBox('World of Tanks не знайдено в цій папці. Продовжити?', mbConfirmation, MB_YESNO) = IDYES then
      Result := True
    else
      Result := False;
  end;
end;

procedure CreateInfoPage;
var
  InfoLabel: TLabel;
begin
  InfoPage := CreateCustomPage(wpWelcome, 'Інформація про ILYK ModPak', 
    'Важлива інформація перед встановленням');
  
  InfoLabel := TLabel.Create(InfoPage);
  InfoLabel.Parent := InfoPage.Surface;
  InfoLabel.Left := 0;
  InfoLabel.Top := 0;
  InfoLabel.Width := 417;
  InfoLabel.Height := 300;
  InfoLabel.WordWrap := True;
  InfoLabel.Caption := 'ILYK ModPak - Колекція модів для World of Tanks' + #13#10#13#10 +
    'Версія: 1.0' + #13#10 +
    'Розроблювач: ILYK' + #13#10#13#10 +
    'Включає:' + #13#10 +
    '• XVM - розширена інформація про гравців' + #13#10 +
    '• Пакет скінів' + #13#10 +
    '• Конфігурація мінімальні налаштування' + #13#10#13#10 +
    'Системні вимоги:' + #13#10 +
    '• Windows 7 або новіша' + #13#10 +
    '• RAM: мінімум 2GB' + #13#10 +
    '• Місце на диску: 5GB' + #13#10 +
    '• World of Tanks встановлений';
  
  LogMessage('Показана сторінка інформації');
end;

procedure CreateSystemCheckPage;
var
  CheckLabel: TLabel;
begin
  SystemCheckPage := CreateCustomPage(InfoPage.ID, 'Перевірка системи', 
    'Перевірка системних вимог');
  
  CheckLabel := TLabel.Create(SystemCheckPage);
  CheckLabel.Parent := SystemCheckPage.Surface;
  CheckLabel.Left := 0;
  CheckLabel.Top := 0;
  CheckLabel.Width := 417;
  CheckLabel.Height := 300;
  CheckLabel.WordWrap := True;
  CheckLabel.Caption := 'Перевірка системних параметрів:' + #13#10#13#10 +
    '✓ Версія Windows' + #13#10 +
    '✓ Обсяг оперативної пам''яті' + #13#10 +
    '✓ Вільне місце на диску' + #13#10 +
    '✓ Наявність World of Tanks' + #13#10#13#10 +
    'Результати перевірки буде показано на наступній сторінці.';
  
  LogMessage('Показана сторінка перевірки системи');
end;

procedure CreateUserRegPage;
var
  UsernameLabel, EmailLabel, TermsLabel: TLabel;
begin
  UserRegPage := CreateCustomPage(SystemCheckPage.ID, 'Реєстрація користувача', 
    'Введіть вашу інформацію');
  
  UsernameLabel := TLabel.Create(UserRegPage);
  UsernameLabel.Parent := UserRegPage.Surface;
  UsernameLabel.Left := 0;
  UsernameLabel.Top := 0;
  UsernameLabel.Caption := 'Ім''я користувача:';
  
  UsernameEdit := TEdit.Create(UserRegPage);
  UsernameEdit.Parent := UserRegPage.Surface;
  UsernameEdit.Left := 0;
  UsernameEdit.Top := 20;
  UsernameEdit.Width := 417;
  
  EmailLabel := TLabel.Create(UserRegPage);
  EmailLabel.Parent := UserRegPage.Surface;
  EmailLabel.Left := 0;
  EmailLabel.Top := 60;
  EmailLabel.Caption := 'Email (опціонально):';
  
  EmailEdit := TEdit.Create(UserRegPage);
  EmailEdit.Parent := UserRegPage.Surface;
  EmailEdit.Left := 0;
  EmailEdit.Top := 80;
  EmailEdit.Width := 417;
  
  TermsLabel := TLabel.Create(UserRegPage);
  TermsLabel.Parent := UserRegPage.Surface;
  TermsLabel.Left := 0;
  TermsLabel.Top := 120;
  
  TermsCheckBox := TCheckBox.Create(UserRegPage);
  TermsCheckBox.Parent := UserRegPage.Surface;
  TermsCheckBox.Left := 0;
  TermsCheckBox.Top := 120;
  TermsCheckBox.Width := 417;
  TermsCheckBox.Caption := 'Я згоден з умовами встановлення';
  
  LogMessage('Показана сторінка реєстрації користувача');
end;

procedure CreateComponentsPage;
var
  ComponentsLabel: TLabel;
begin
  ComponentsPage := CreateCustomPage(UserRegPage.ID, 'Вибір компонентів', 
    'Виберіть які компоненти встановлювати');
  
  ComponentsLabel := TLabel.Create(ComponentsPage);
  ComponentsLabel.Parent := ComponentsPage.Surface;
  ComponentsLabel.Left := 0;
  ComponentsLabel.Top := 0;
  ComponentsLabel.Caption := 'Доступні компоненти:';
  
  XVMCheckBox := TCheckBox.Create(ComponentsPage);
  XVMCheckBox.Parent := ComponentsPage.Surface;
  XVMCheckBox.Left := 10;
  XVMCheckBox.Top := 25;
  XVMCheckBox.Width := 400;
  XVMCheckBox.Caption := 'XVM - Інформація про гравців';
  XVMCheckBox.Checked := True;
  
  SkinPackCheckBox := TCheckBox.Create(ComponentsPage);
  SkinPackCheckBox.Parent := ComponentsPage.Surface;
  SkinPackCheckBox.Left := 10;
  SkinPackCheckBox.Top := 50;
  SkinPackCheckBox.Width := 400;
  SkinPackCheckBox.Caption := 'Пакет скінів';
  SkinPackCheckBox.Checked := True;
  
  ConfigCheckBox := TCheckBox.Create(ComponentsPage);
  ConfigCheckBox.Parent := ComponentsPage.Surface;
  ConfigCheckBox.Left := 10;
  ConfigCheckBox.Top := 75;
  ConfigCheckBox.Width := 400;
  ConfigCheckBox.Caption := 'Конфігурація мінімальних налаштувань';
  ConfigCheckBox.Checked := True;
  
  LogMessage('Показана сторінка вибору компонентів');
end;

procedure InitializeWizard;
begin
  LogFile := ExpandConstant('{tmp}\ILYK_ModPak_Install.log');
  LogMessage('=== Початок встановлення ILYK ModPak ===');
  LogMessage('Версія: 1.0');
  LogMessage('Дата встановлення: ' + GetDateTimeString('dd.mm.yyyy', '/', ':'));
  
  { Сторінка вибору каталогу }
  DirPage := CreateInputDirPage(wpSelectDir,
    'Вибір каталогу встановлення', 
    'Виберіть каталог World of Tanks',
    'Будь ласка, виберіть папку, де встановлено World of Tanks, потім натисніть "Далі".',
    False, 
    'Нова папка');
  
  DirPage.Add('');
  DirPage.Values[0] := ExpandConstant('{userdocs}\MyGames');
  LogMessage('Стандартна папка встановлення: ' + DirPage.Values[0]);
  
  { Створити додаткові сторінки }
  CreateInfoPage;
  CreateSystemCheckPage;
  CreateUserRegPage;
  CreateComponentsPage;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpWelcome then
  begin
    Result := True;
    LogMessage('Користувач розпочав встановлення');
  end
  else if CurPageID = DirPage.ID then
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
      Result := CheckWorldOfTanks;
    end;
  end
  else if CurPageID = InfoPage.ID then
  begin
    LogMessage('Користувач переглянув інформацію');
    Result := True;
  end
  else if CurPageID = SystemCheckPage.ID then
  begin
    LogMessage('=== Початок перевірки системи ===');
    Result := CheckWindowsVersion and CheckSystemMemory and CheckDiskSpace;
    LogMessage('=== Завершення перевірки системи ===');
  end
  else if CurPageID = UserRegPage.ID then
  begin
    if TermsCheckBox.Checked then
    begin
      if UsernameEdit.Text <> '' then
      begin
        LogMessage('Реєстрація користувача: ' + UsernameEdit.Text);
        if EmailEdit.Text <> '' then
          LogMessage('Email: ' + EmailEdit.Text);
        Result := True;
      end
      else
      begin
        LogMessage('ПОМИЛКА: Не введено ім''я користувача');
        MsgBox('Будь ласка, введіть ім''я користувача!', mbError, MB_OK);
        Result := False;
      end;
    end
    else
    begin
      LogMessage('ПОМИЛКА: Користувач не прийняв умови встановлення');
      MsgBox('Ви повинні прийняти умови встановлення!', mbError, MB_OK);
      Result := False;
    end;
  end
  else if CurPageID = ComponentsPage.ID then
  begin
    LogMessage('Вибрані компоненти:');
    if XVMCheckBox.Checked then
      LogMessage('  - XVM: так')
    else
      LogMessage('  - XVM: ні');
    if SkinPackCheckBox.Checked then
      LogMessage('  - Скіни: так')
    else
      LogMessage('  - Скіни: ні');
    if ConfigCheckBox.Checked then
      LogMessage('  - Конфіг: так')
    else
      LogMessage('  - Конфіг: ні');
    Result := True;
  end
  else
    Result := True;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpReady then
  begin
    LogMessage('=== Перевірка налаштувань перед встановленням ===');
    WizardForm.ReadyMemo.Lines.Clear;
    WizardForm.ReadyMemo.Lines.Add('Каталог встановлення: ' + GetDestDir(''));
    WizardForm.ReadyMemo.Lines.Add('');
    WizardForm.ReadyMemo.Lines.Add('Компоненти для встановлення:');
    if XVMCheckBox.Checked then
      WizardForm.ReadyMemo.Lines.Add('  ✓ XVM мод');
    if SkinPackCheckBox.Checked then
      WizardForm.ReadyMemo.Lines.Add('  ✓ Пакет скінів');
    if ConfigCheckBox.Checked then
      WizardForm.ReadyMemo.Lines.Add('  ✓ Конфігурація');
    WizardForm.ReadyMemo.Lines.Add('');
    if UsernameEdit.Text <> '' then
      WizardForm.ReadyMemo.Lines.Add('Користувач: ' + UsernameEdit.Text);
    if EmailEdit.Text <> '' then
      WizardForm.ReadyMemo.Lines.Add('Email: ' + EmailEdit.Text);
  end;
end;

procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
begin
  if CurProgress mod 10 = 0 then
    LogMessage('Прогрес встановлення: ' + IntToStr((CurProgress * 100) div MaxProgress) + '%');
end;

procedure CurUninstallProgressChanged(CurProgress, MaxProgress: Integer);
begin
  if CurProgress mod 10 = 0 then
    LogMessage('Прогрес видалення: ' + IntToStr((CurProgress * 100) div MaxProgress) + '%');
end;

procedure DeinitializeSetup;
begin
  LogMessage('=== Завершення встановлення ILYK ModPak ===');
end;
