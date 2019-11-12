set "PROMPT=> "
echo on

:: Information
git --version

:: Checkout nodejs/build repository or fork with scripts
mkdir build
cd build
git init
git clean -dffx
git remote add GitHub https://github.com/nodejs/build.git
git fetch --prune --no-tags GitHub
git fetch --prune --no-tags https://github.com/%SCRIPTS_REPO%.git +refs/heads/%SCRIPTS_BRANCH%:refs/remotes/jenkins_tmp
if errorlevel 1 exit /b
git checkout -f refs/remotes/jenkins_tmp
if errorlevel 1 exit /b
git reset --hard
if errorlevel 1 exit /b
git clean -dffx
if errorlevel 1 exit /b
cd %~dp0

:: Clean up before running
call build\jenkins\scripts\windows\ci-cleanup.cmd

:: Run script
mkdir node
cd node
call ..\build\jenkins\scripts\windows\%1.cmd
if errorlevel 1 exit /b
