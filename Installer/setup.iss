﻿; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "WinBox for 86Box"
#define MyAppVersion "1.1.0.356"
#define MyAppPublisher "Laci bá'"
#define MyAppURL "https://users.atw.hu/laciba/"    

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{D3D646C1-1D59-4F32-B244-C41F695BC8E9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\Laci bá'\{#MyAppName}     
LicenseFile="LICENSE.txt"
AllowNoIcons=yes
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=..\Win32\Installer
OutputBaseFilename=WinBox-for-86Box-{#MyAppVersion}
Compression=lzma2/ultra64
SetupIconFile=setup.ico
WizardImageFile=banner.bmp        
WizardSmallImageFile=logo.bmp
WizardImageStretch=true
SolidCompression=yes
WizardStyle=modern
VersionInfoVersion={#MyAppVersion}
UninstallDisplayIcon={app}\WinBox.exe
CloseApplications=yes
; ArchitecturesAllowed=x64
; ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"    
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"      

[CustomMessages]
english.AskBadVersion=Your current operating system version is not supported.%n%nWould you like to continue anyway (not recommended)?
hungarian.AskBadVersion=Az Ön által használt operációs rendszer jelenlegi verziója nem támogatott.%n%nKívánja folytatni ennek ellenére (nem ajánlott)?
italian.AskBadVersion=La versione corrente del tuo sistema operativo non è supportata.%n%nVuoi continuare comunque (non consigliato)?
brazilianportuguese.AskBadVersion=A versão atual do seu sistema operacional não é compatível.%n%nQuer continuar mesmo assim (não recomendado)?
german.AskBadVersion=Ihre aktuelle Betriebssystemversion wird nicht unterstützt.%n%nMöchten Sie trotzdem fortfahren (nicht empfohlen)?

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[InstallDelete]                        
Type: filesandordirs; Name: "{app}\Samples"
Type: filesandordirs; Name: "{app}\Templates"     

[Files]
Source: "..\Win32\Debug\WinBox.exe"; DestDir: "{app}"; Flags: ignoreversion;          
Source: "..\Win32\Debug\Templates\*"; DestDir: "{app}\Templates"; Flags: ignoreversion recursesubdirs createallsubdirs;     
Source: "..\Win32\Debug\Iconsets\*"; DestDir: "{app}\Iconsets"; Excludes: "\*\Source\*"; Flags: ignoreversion recursesubdirs createallsubdirs;        
Source: "..\Languages\*"; DestDir: "{app}\Languages"; Flags: ignoreversion recursesubdirs createallsubdirs;                         
Source: "LICENSE.TXT"; DestDir: "{app}"; Flags: ignoreversion; 
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\WinBox.exe";
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\WinBox.exe"; Tasks: desktopicon; 

[Run]
Filename: "{app}\WinBox.exe"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall runasoriginaluser skipifsilent;   
Filename: "{app}\WinBox.exe"; Flags: nowait postinstall runasoriginaluser skipifnotsilent; Check: CheckParam('/EXEC');

[Code]

function CheckParam(Param: string): boolean;
var
  I: integer;
begin
  Result := false;
 
  if paramcount > 0 then begin
    Param := UpperCase(Param);
    for I := 1 to paramcount do
      if UpperCase(paramstr(I)) = Param then begin
        Result := true;
        exit;
      end;
  end;
end;

function InitializeSetup(): Boolean;
begin                                
  Result := true;

  if (GetWindowsVersion < $06011DB1) (* Windows 7 SP1 *) and not (CheckParam('/EXEC') or
       (MsgBox(ExpandConstant('{cm:AskBadVersion}'), mbError, MB_YESNO) = idYes)) then
     Result := false;
end;

