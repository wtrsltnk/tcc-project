@echo off
setlocal EnableDelayedExpansion

for %%i in ("%~dp0..") do (
    set "PROJECT_NAME=%%~ni"
    set "PROJECT_ROOT=%%~dpni"
    set "TCC_PROJECT_ROOT=%PROJECT_ROOT%\tcc-project"
    call %%~di
    cd %%~dpni
)

set BIN_DIR=%TCC_PROJECT_ROOT%\bin
if not exist %BIN_DIR%\%PROJECT_NAME%.exe goto :no_binary_found

call %BIN_DIR%\%PROJECT_NAME%.exe
goto :exit 

:no_binary_found
echo There is no project binary, run tcc-roject\project-build.bat to build your project

:exit
