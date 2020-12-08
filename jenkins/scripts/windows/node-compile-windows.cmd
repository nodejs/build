:: Git
set GIT_REPO=%TEMP_REPO%
set GIT_REF=refs/heads/%TEMP_BRANCH%
call %~dp0git-checkout.cmd
if errorlevel 1 exit /b

:: Delete binary branch that will be built here if it exists
git push %TEMP_REPO% :%TEMP_PUSH_BRANCH%-bin-%nodes%
:: reset errorlevel
ver > nul

:: Compile
set "VCBUILD_EXTRA_ARGS=release msi"
call %~dp0compile.cmd
if errorlevel 1 exit /b

:: Select files to pack
set "BINARY_FILES=config.gypi icu_config.gypi Release/node.exe Release/node.lib Release/openssl-cli.exe Release/cctest.exe Release/node.pdb"
if exist Release\node_test_engine.dll set "BINARY_FILES=%BINARY_FILES% Release/node_test_engine.dll"
if exist Release\overlapped-checker.exe set "BINARY_FILES=%BINARY_FILES% Release/overlapped-checker.exe"

:: Setup binary package
rm -rf binary
mkdir binary
tar cavf binary/binary.tar.gz %BINARY_FILES%
if errorlevel 1 exit /b
md5sum binary/binary.tar.gz %BINARY_FILES%
:: make a copy for artifact
copy binary\binary.tar.gz .
if errorlevel 1 exit /b

:: Create local temp branch with binary
git config --replace-all user.name "Node.js Jenkins CI"
git config --replace-all user.email ci@iojs.org
git checkout -B %TEMP_PUSH_BRANCH%-bin-%nodes%
if errorlevel 1 exit /b
git add binary\binary.tar.gz
if errorlevel 1 exit /b
git commit -m "added binaries"
if errorlevel 1 exit /b

:: Push temp branch
git push "%TEMP_REPO%" "+%TEMP_PUSH_BRANCH%-bin-%nodes%"
if errorlevel 1 exit /b

:: Delete local temp branch with binary
git checkout -f refs/remotes/jenkins_tmp
git branch -D %TEMP_PUSH_BRANCH%-bin-%nodes%
