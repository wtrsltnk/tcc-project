@echo off

if not exist ../project-files.txt (
    goto :no_project
)

@cd ..

echo @call tcc-project/project-build.bat > build.cmd
echo @call tcc-project/project-clean.bat > clean.cmd
echo @call tcc-project/project-run.bat > run.cmd

goto :exit

:no_project
@echo There is no project here

:exit
