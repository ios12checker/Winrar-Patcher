@echo off
setlocal

:: Elevate to Administrator if needed
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

REM Launch the PowerShell WinRAR patcher GUI hidden
powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "%~dp0patch-winrar.ps1"

set "RC=%ERRORLEVEL%"
endlocal & exit /b %RC%
