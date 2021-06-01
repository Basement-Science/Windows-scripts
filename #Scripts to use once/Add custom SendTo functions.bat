@echo off
color 0a
:: This script adds 2 entries to the current user's SendTo functionality. 
:: 1. A script that can add shortcuts into the SendTo-Folder.
::    This way, you can add any locations to which you frequently need to copy things, for example.
:: 2. An entry which opens the SendTo-Folder itself in an explorer window, regardless of what files were selected. 

:: get the user's language
FOR /F "tokens=3" %%a IN ('reg query "HKCU\Control Panel\Desktop" /v PreferredUILanguages ^| find "PreferredUILanguages"') DO set LangCulture=%%a
set UILanguage=%LangCulture:~0,2%
echo User Display Language: %UILanguage%, language+Culture: %LangCulture%

:: Copy the Link Script to SendTo
set SendToLocation=%APPDATA%\Microsoft\Windows\SendTo
if {%UILanguage%}=={de} (
	set LinkScriptLocation=%SendToLocation%\++Zu SendTo hinzufÅgen++.vbs
) else (
	set LinkScriptLocation=%SendToLocation%\++Add to SendTo++.vbs
)
copy /y "Add shortcut into THIS directory.vbs" "%LinkScriptLocation%"
if not errorlevel 0 echo ERROR: script could not be copied & goto :error
echo successfully added Link Script


:: Add Shortcut to the SendTo folder itself. Using the SendTo menu will COPY files and folders here.
if {%UILanguage%}=={de} (
	set LinkName=++Nach SendTo kopieren++
	set Description=Kopiert Dateien und Ordner in den SendTo-Ordner
) else (
	set LinkName=++Copy to SendTo++
	set Description=Copies Files and Folders into the SendTo-Folder
)
set TargetPath=%SendToLocation%
set Arguments=
set IconLocation=
call :RunLinkScript
echo successfully added shortcut to SendTo itself (for copying files to SendTo)

:: Add Script to open SendTo in explorer
if {%UILanguage%}=={de} (
	set LinkName=++SendTo-Ordner îffnen++
	set Description=îffnet den SendTo-Ordner in einem Explorer-Fenster
) else (
	set LinkName=++open SendTo-Folder++
	set Description=opens the SendTo-Folder in an explorer window
)
set TargetPath=cmd.exe
set Arguments="/C start shell:sendto"
set IconLocation="%SystemRoot%\explorer.exe, 13"
call :RunLinkScript
echo successfully added Script to open SendTo in explorer

:error
timeout 3
goto :end

:RunLinkScript
cscript /nologo "%LinkScriptLocation%" "%TargetPath%" "%LinkName%" "%Description%" %Arguments% %IconLocation%
if not errorlevel 0 echo ERROR: Script did not run correctly & goto :error
:end