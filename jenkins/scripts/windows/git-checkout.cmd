git --version
git init
git clean -dffx

:: This is just an optimization step. It's more efficient to fetch as much as possible from GitHub
git remote add GitHub https://github.com/nodejs/node.git
git fetch --prune --no-tags GitHub
if errorlevel 1 echo Problem fetching the main repo.

:: Privately set git over ssh to our TEMP_REPO
echo off
for /f "delims=" %%F in ('cygpath -u %JENKINS_TMP_KEY%') do set "GIT_SSH_COMMAND=ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i %%F"
echo on

:: Get TEMP_BRANCH from temp repo, retry once
git fetch --prune --no-tags %GIT_REPO% +%GIT_REF%:refs/remotes/jenkins_tmp
if errorlevel 1 (
  sleep 10
  git fetch --prune --no-tags %GIT_REPO% +%GIT_REF%:refs/remotes/jenkins_tmp
  if errorlevel 1 exit /b
)

:: Branch needs to be in remotes/ for the checkout here to leave a detached HEAD state. If the branch was in heads/, the next run would fail when overwriting.
git checkout -f refs/remotes/jenkins_tmp
if errorlevel 1 exit /b

:: Clean up.
git reset --hard
if errorlevel 1 exit /b
git clean -dffx
if errorlevel 1 exit /b

:: https://github.com/nodejs/node/issues/5094
for /f %%F in ('git status --porcelain') do (
  git status
  echo "Workspace cannot be cleaned, possible problem with committed file names"
  exit /b 1
)

:: Check NODEJS_MAJOR_VERSION
for /f "delims=." %%a in ('python tools\getnodeversion.py') do if not "%%a" == "%NODEJS_MAJOR_VERSION%" (
  echo "NODEJS_MAJOR_VERSION parameter (%NODEJS_MAJOR_VERSION%) does not match output of tools\getnodeversion.py (%%a)"
  exit /b 1
)
