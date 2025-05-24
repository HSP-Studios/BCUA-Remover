REM ============================================================================
REM BCUA Remover by HSP Studios
REM Copyright (C) 2025 HSP Studios
REM
REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU Affero General Public License as published
REM by the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU Affero General Public License for more details.
REM
REM You should have received a copy of the GNU Affero General Public License
REM along with this program.  If not, see <https://www.gnu.org/licenses/>.
REM 
REM Description : This batch script automates the removal of Blue Coat Unified Agent (BCUA)
REM               and its related components from a Windows system. It performs the following:
REM                 - Checks for administrator privileges and relaunches as admin if needed.
REM                 - Deletes BCUA-related registry keys and values, including manual uninstall keys.
REM                 - Searches and removes BCUA entries in HKEY_CLASSES_ROOT and HKLM.
REM                 - Terminates BCUA-related processes (bcua-service.exe, bcua-notifier.exe).
REM                 - Deletes BCUA-related directories and files from ProgramData, Program Files,
REM                   and System32 drivers.
REM                 - Removes Unified Agent entries from the Uninstall registry.
REM                 - Prompts the user to restart the computer to complete removal.
REM
REM Usage       : Run as administrator. Follow the on-screen prompts.
REM
REM Note        : This script is based on the official BCUA removal instructions.
REM               (https://knowledge.broadcom.com/external/article/169376/manually-uninstall-unified-agent.html)
REM               
REM ============================================================================

@echo off

REM Check for admin rights
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Attempting to relaunch as administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM Parse command-line arguments for silent mode
for %%i in (%*) do (
    REM Check for "-" arguments
    if /I "%%i"=="--silent" set "BCUA_SILENT=1"
    if /I "%%i"=="-s" set "BCUA_SILENT=1"
    REM Check for "/" arguments
    if /I "%%i"=="/silent" set "BCUA_SILENT=1"
    if /I "%%i"=="/s" set "BCUA_SILENT=1"
)

REM Remove registry keys (manual uninstall)
reg delete "HKLM\SYSTEM\CurrentControlSet\services\bc-cloud-wfp" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\bcua-service" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\bcua-wfp" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Blue Coat Systems" /f >nul 2>&1

REM Search and remove BCUA entries in HKEY_CLASSES_ROOT
for /f "tokens=*" %%k in ('reg query "HKCR" /f "bcua" /s 2^>nul ^| findstr /i "bcua"') do reg delete "%%k" /f >nul 2>&1

REM Kill bcua-service.exe and bcua-notifier.exe processes
for /f "skip=3 tokens=2" %%a in ('tasklist /fi "imagename eq bcua-service.exe" 2^>nul') do taskkill /PID %%a /F >nul 2>&1
for /f "skip=3 tokens=2" %%a in ('tasklist /fi "imagename eq bcua-notifier.exe" 2^>nul') do taskkill /PID %%a /F >nul 2>&1

REM Delete directories and files
rmdir /s /q "C:\ProgramData\bcua" >nul 2>&1
rmdir /s /q "C:\Program Files\Blue Coat Systems" >nul 2>&1
del /f /q "C:\Windows\System32\drivers\bcua-wfp.sys" >nul 2>&1

REM Search registry for BCUA and delete related keys
for /f "tokens=*" %%k in ('reg query HKLM /f "bcua" /s 2^>nul ^| findstr /i "bcua"') do reg delete "%%k" /f >nul 2>&1

REM Remove Unified Agent from Uninstall registry
for /f "tokens=*" %%k in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" 2^>nul') do (
  reg query "%%k" /v "DisplayName" 2>nul | findstr /i "Unified Agent" >nul && reg delete "%%k" /f >nul 2>&1
)

echo Unified Agent removal steps complete.
if "%BCUA_SILENT%"=="1" goto :END_SCRIPT
echo It is recommended to restart your computer to complete the removal.
:RESTART_PROMPT
echo Press Y to restart now, or N to exit without restarting.
set /p RESTART=Restart now? (Y/N): 
if /I "%RESTART%"=="Y" goto :DO_RESTART
if /I "%RESTART%"=="N" goto :END_SCRIPT
echo Invalid input. Please enter Y or N.
goto :RESTART_PROMPT
:DO_RESTART
shutdown /r /t 5
goto :EOF
:END_SCRIPT
exit /b