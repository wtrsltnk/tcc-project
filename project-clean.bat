@echo off
setlocal EnableDelayedExpansion

for %%i in ("%~dp0..") do (
    set "PROJECT_NAME=%%~ni"
    set "PROJECT_ROOT=%%~dpni"
    set "TCC_PROJECT_ROOT=%PROJECT_ROOT%\tcc-project"
    call %%~di
    cd %%~dpni
)

set OBJ_DIR=%TCC_PROJECT_ROOT%\obj
set BIN_DIR=%TCC_PROJECT_ROOT%\bin

echo.
echo @echo Cleaning project %PROJECT_NAME%>%TCC_PROJECT_ROOT%\temp_clean.bat

if exist %OBJ_DIR% (
    @rem Delete all objects
    echo @echo.>>%TCC_PROJECT_ROOT%\temp_clean.bat
    echo @echo Cleaning compiled objects:>>%TCC_PROJECT_ROOT%\temp_clean.bat
    for /f "tokens=*" %%a in (%PROJECT_ROOT%\project-files.txt) do (
        echo @del /f %OBJ_DIR%\%%~na.o>>%TCC_PROJECT_ROOT%\temp_clean.bat
    )
)

if exist %BIN_DIR% (
    @rem Delete the exe
    echo @echo.>>%TCC_PROJECT_ROOT%\temp_clean.bat
    echo @echo Cleaning executable:>>%TCC_PROJECT_ROOT%\temp_clean.bat
    echo @del /f %BIN_DIR%\%PROJECT_NAME%.exe>>%TCC_PROJECT_ROOT%\temp_clean.bat
)

echo @echo.>>%TCC_PROJECT_ROOT%\temp_clean.bat
echo @echo All done.>>%TCC_PROJECT_ROOT%\temp_clean.bat

@echo on
@call %TCC_PROJECT_ROOT%\temp_clean.bat
@echo off
@del %TCC_PROJECT_ROOT%\temp_clean.bat

goto :exit 

:exit
