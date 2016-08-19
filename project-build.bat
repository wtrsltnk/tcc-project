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
if not exist %OBJ_DIR% mkdir %OBJ_DIR%
set BIN_DIR=%TCC_PROJECT_ROOT%\bin
if not exist %BIN_DIR% mkdir %BIN_DIR%

call %TCC_PROJECT_ROOT%\tcc-find.bat
if not defined TCC goto :tcc_not_found

echo.
echo @echo Building %BIN_DIR%\%PROJECT_NAME%.exe with %TCC%>%TCC_PROJECT_ROOT%\temp_build.bat

if not exist %PROJECT_ROOT%\project-includes.txt echo Replace this text with one directory per line to include in you project>%PROJECT_ROOT%\project-includes.txt

@rem Gather all configured include directories. These must be relative from project path
set INCLUDES=-I%TCC_INCLUDE%
for /f "tokens=*" %%a in (%PROJECT_ROOT%\project-includes.txt) do (
    if exist %%~a (
        set INCLUDES=!INCLUDES! -I%%~a
    ) else (
        set INCLUDES=!INCLUDES! -I%PROJECT_ROOT%\%%~a
    )
)

if not exist %PROJECT_ROOT%\project-files.txt echo Replace this text with one source file per line to include in you project>%PROJECT_ROOT%\project-files.txt

echo @echo.>>%TCC_PROJECT_ROOT%\temp_build.bat

@rem Compile all sources to objects
for /f "tokens=*" %%a in (%PROJECT_ROOT%\project-files.txt) do (
    echo @echo Compiling %%~a>>%TCC_PROJECT_ROOT%\temp_build.bat
    echo @%TCC% -c %INCLUDES% -o %OBJ_DIR%\%%~na.o %PROJECT_ROOT%\%%~a>>%TCC_PROJECT_ROOT%\temp_build.bat
    echo @if ERRORLEVEL 1 goto :errorHandling>>%TCC_PROJECT_ROOT%\temp_build.bat
)

@rem Link all objects to one exe
echo @echo.>>%TCC_PROJECT_ROOT%\temp_build.bat
echo @echo Linking all objects into %BIN_DIR%\%PROJECT_NAME%.exe>>%TCC_PROJECT_ROOT%\temp_build.bat
echo|set /p=@%TCC% -o %BIN_DIR%\%PROJECT_NAME%.exe>>%TCC_PROJECT_ROOT%\temp_build.bat
for /f "tokens=*" %%a in (%PROJECT_ROOT%\project-files.txt) do (
    echo | set /p dummy=%OBJ_DIR%\%%~na.o>>%TCC_PROJECT_ROOT%\temp_build.bat
)

echo.>>%TCC_PROJECT_ROOT%\temp_build.bat
echo @echo.>>%TCC_PROJECT_ROOT%\temp_build.bat

@rem When there are install files configfured, copy these to the bin folder
if exist %PROJECT_ROOT%\project-install-files.txt (
    for /f "tokens=*" %%a in (%PROJECT_ROOT%\project-install-files.txt) do (
        echo copy %PROJECT_ROOT%\%%~a %BIN_DIR%>>%TCC_PROJECT_ROOT%\temp_build.bat
    )
)

echo @echo Done building %PROJECT_NAME%>>%TCC_PROJECT_ROOT%\temp_build.bat
echo @goto :exit>>%TCC_PROJECT_ROOT%\temp_build.bat
echo :errorHandling>>%TCC_PROJECT_ROOT%\temp_build.bat
echo @echo.>>%TCC_PROJECT_ROOT%\temp_build.bat
echo @echo Error compiling %PROJECT_NAME%>>%TCC_PROJECT_ROOT%\temp_build.bat
echo @echo.>>%TCC_PROJECT_ROOT%\temp_build.bat
echo :exit>>%TCC_PROJECT_ROOT%\temp_build.bat

@echo on
@call %TCC_PROJECT_ROOT%\temp_build.bat
@echo off
@del %TCC_PROJECT_ROOT%\temp_build.bat

goto :exit 

:tcc_not_found
echo We cannot build %PROJECT_NAME%.exe without tcc.exe. Add the location of tcc.exe to your environemnt PATH.

:exit
