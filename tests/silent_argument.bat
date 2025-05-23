@echo off
REM Test script for BCUA_SILENT argument logic

set "BCUA_SILENT=0"
for %%i in (%*) do (
    REM Check for "-" arguments
    if /I "%%i"=="--silent" set "BCUA_SILENT=1"
    if /I "%%i"=="-s" set "BCUA_SILENT=1"
    REM Check for "/" arguments
    if /I "%%i"=="/silent" set "BCUA_SILENT=1"
    if /I "%%i"=="/s" set "BCUA_SILENT=1"
)

echo Arguments received: %*
echo BCUA_SILENT=%BCUA_SILENT%

pause
