@echo off
color 0a
cd %windir%

:: get the user's language
FOR /F "tokens=3" %%a IN ('reg query "HKCU\Control Panel\Desktop" /v PreferredUILanguages ^| find "PreferredUILanguages"') DO set LangCulture=%%a
set UILanguage=%LangCulture:~0,2%
echo User Display Language: %UILanguage%, language+Culture: %LangCulture%
set LinkLocation=%APPDATA%\Microsoft\Windows\SendTo


if {%UILanguage%}=={de} (
	set LinkName=%LinkLocation%\++Zu SendTo hinzufügen++.lnk
	set Description=Fügt eine Verknüpfung zu dieser Datei im SendTo-Ordner ein
) else (
	set LinkName=%LinkLocation%\++Add to SendTo++.lnk
	set Description=Adds a link to this File into the SendTo-Folder
)
set TargetPath=%LinkLocation%
set Arguments=
set IconLocation=
call :AddLink

if {%UILanguage%}=={de} (
	set LinkName=%LinkLocation%\++SendTo-Ordner öffnen++.lnk
	set Description=Öffnet den SendTo-Ordner in einem Explorer-Fenster
) else (
	set LinkName=%LinkLocation%\++open SendTo-Folder++.lnk
	set Description=opens the SendTo-Folder in an explorer window
)
set TargetPath=cmd.exe
set Arguments=/C start shell:sendto
set IconLocation=%SystemRoot%\explorer.exe, 13
call :AddLink

timeout 3
exit

:AddLink
:: create a temporary vb script because creating a shortcut is HARD
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%.vbs"

echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%LinkName%" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%TargetPath%" >> %SCRIPT%
if not {"%Arguments%"}=={""} (echo oLink.Arguments = "%Arguments%" >> %SCRIPT%)
if not {"%Description%"}=={""} (echo oLink.Description = "%Description%" >> %SCRIPT%)
if not {"%IconLocation%"}=={""} (echo oLink.IconLocation = "%IconLocation%" >> %SCRIPT%)
echo oLink.Save >> %SCRIPT%

cscript /nologo %SCRIPT%
if errorlevel 0 echo succefully added link
if errorlevel 1 echo link could not be added
del %SCRIPT%
:end