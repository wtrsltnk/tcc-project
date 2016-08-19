@echo off
setlocal EnableDelayedExpansion

for %%i in ("%~dp0..") do (
    set "PROJECT_NAME=%%~ni"
    set "PROJECT_ROOT=%%~dpni"
    call %%~di
    cd %%~dpni
)

set BIN_DIR=%PROJECT_ROOT%\tcc-project\bin
if not exist %BIN_DIR%\%PROJECT_NAME%.exe goto :no_binary_found

@echo on
@call %BIN_DIR%\%PROJECT_NAME%.exe
@echo off
goto :exit 

:no_binary_found
echo There is no project binary, run tcc-roject\project-build.bat to build your project

:exit
