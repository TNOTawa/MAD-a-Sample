@echo off
setlocal enableextensions

rem Locate the latest Visual Studio / Build Tools installation via vswhere
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

rem Activate the x64 MSVC command-line environment (no VS IDE required)
call "%VSINSTALL%\VC\Auxiliary\Build\vcvars64.bat" || (
    echo ERROR: Failed to initialize MSVC environment 1>&2
    exit /b 1
)

rem Configure with the local windows-msvc preset (see CMakeUserPresets.json)
cd /d "%~dp0.."
cmake --preset=windows-msvc %*
