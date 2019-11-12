:: Git
set GIT_REPO=%TEMP_REPO%
set GIT_REF=refs/heads/%TEMP_BRANCH%
call %~dp0git-checkout.cmd
if errorlevel 1 exit /b

:: Compile
set "VCBUILD_EXTRA_ARGS=debug"
call %~dp0compile.cmd
if errorlevel 1 exit /b

:: Basic sanity check
:: Test compiling and running a native add-on
%node_gyp_exe% rebuild --directory=test\addons\hello-world --nodedir="%CD%"
if errorlevel 1 exit /b
Debug\node.exe test\addons\hello-world\test.js
if errorlevel 1 exit /b
