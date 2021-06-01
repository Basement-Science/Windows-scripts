:start
@echo off
::mode 90,30
color 0a
title UAC-Fullswitcher
setlocal EnableDelayedExpansion
set NL=^


reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" >nul
if errorlevel 1 goto :Error

Set "RegKey_Current="
for /f "delims=" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system"') do (Set RegKey_Current=!RegKey_Current!%%i!NL!)

echo The registry key in question is:
echo.
echo !RegKey_Current!!NL!
FOR /F "tokens=2* delims=	 " %%A IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /v PromptOnSecureDesktop') do (set PromptOnSecureDesktop=%%B)
FOR /F "tokens=2* delims=	 " %%A IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /v EnableLUA') do (set EnableLUA=%%B)
FOR /F "tokens=2* delims=	 " %%A IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /v FilterAdministratorToken') do (set FilterAdministratorToken=%%B)

timeout 3 >nul
cls
echo The following are Important and are currently set as follows: !NL!!NL!PromptOnSecureDesktop: %PromptOnSecureDesktop% !NL!EnableLUA: %EnableLUA% !NL!FilterAdministratorToken: %FilterAdministratorToken% !NL!

::else before if
set UAC_state=1
if {%PromptOnSecureDesktop%}=={0x0} (if {%EnableLUA%}=={0x0} (if {%FilterAdministratorToken%}=={0x0} (
	set UAC_state=0
)))
if not {%UAC_state%}=={} goto :UAC_set
goto :Error

:UAC_set
timeout 2 >nul
echo !NL!/////////////////////////////////////////////////////////////////////////////////////
if {%UAC_state%}=={0} (
	echo UserAccountControl is currently disabled. Enabling...!NL!
	set UAC_Target=1
)
if {%UAC_state%}=={1} (
	echo UserAccountControl is currently enabled. Disabling completely...!NL!
	set UAC_Target=0
)
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /f /t REG_DWORD /D %UAC_Target% /v PromptOnSecureDesktop
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /f /t REG_DWORD /D %UAC_Target% /v EnableLUA
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" /f /t REG_DWORD /D %UAC_Target% /v FilterAdministratorToken
if errorlevel 1 goto :Error
echo.
echo \\\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  ///
echo  \\\/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \///
echo    Press any 2 keys to RESTART the Computer in order to apply the changes.
echo  ///\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\\\
echo ///  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \\\
pause >nul
pause >nul
shutdown /r /t 0
exit

:Error
echo !NL!!NL!\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo   ERROR!  Did you not launch as Admin?
echo /////////////////////////////////////////
pause>nul
exit