@echo off
setlocal enableextensions

set "CONFIG=%1"
if "%CONFIG%"=="" set "CONFIG=debug"
if /I "%CONFIG%"=="debug" set "CONFIG=debug"
if /I "%CONFIG%"=="release" set "CONFIG=release"

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
    echo ERROR: vswhere.exe not found at "%VSWHERE%" 1>&2
    exit /b 1
)
for /f "usebackq delims=" %%I in (`"%VSWHERE%" -latest -products * -property installationPath`) do set "VSINSTALL=%%I"
if not defined VSINSTALL (
    echo ERROR: No Visual Studio installation found via vswhere 1>&2
    exit /b 1
)

call "%VSINSTALL%\VC\Auxiliary\Build\vcvars64.bat" || (
    echo ERROR: Failed to initialize MSVC environment 1>&2
    exit /b 1
)

cd /d "%~dp0.."
cmake --build --preset=%CONFIG%-windows-msvc
