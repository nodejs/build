:: CODE TO SEND RESULTS TO BUILDPULSE IF MACHINE IS CONFIGURED
:: IF ANY REQUIRED CONDITION IS NOT MET IT WILL BE SKIPPED
echo "Preparing to send data to BuildPulse."

:: 1.Check organization and repository
echo "Checking organization and repository."

set "REQUIRED_ORGANIZATION=nodejs"
if not "%GITHUB_ORG%"=="%REQUIRED_ORGANIZATION%" (
  echo "Organization set to %GITHUB_ORG%, %REQUIRED_ORGANIZATION% required. Cannot send results to BuildPulse."
  exit /b 0
)
echo "Organization set to %GITHUB_ORG%."

set "REQUIRED_REPOSITORY=node"
if not "%REPO_NAME%"=="%REQUIRED_REPOSITORY%" (
  echo "Repository set to %REPO_NAME%, %REQUIRED_REPOSITORY% required. Cannot send results to BuildPulse."
  exit /b 0
)
echo "Repository set to %REPO_NAME%."

:: 2.Check test results
echo "Checking test results."

if "%1"=="" (
  echo "No results provided to send to BuildPulse."
  exit /b 0
)

if not exist %1 (
  echo "No results found in %1 to send to BuildPulse."
  exit /b 0
)

echo "Results found in %1."

:: 3.Check required environment variables
echo "Checking required environment variables."

if not defined BUILDPULSE_ACCESS_KEY_ID (
  echo "BUILDPULSE_ACCESS_KEY_ID not set. Cannot send results to BuildPulse."
  exit /b 0
)
echo "BUILDPULSE_ACCESS_KEY_ID is set."

if not defined BUILDPULSE_SECRET_ACCESS_KEY (
  echo "BUILDPULSE_SECRET_ACCESS_KEY not set. Cannot send results to BuildPulse."
  exit /b 0
)
echo "BUILDPULSE_SECRET_ACCESS_KEY is set."

if not defined BUILDPULSE_ACCOUNT_ID (
  echo "BUILDPULSE_ACCOUNT_ID not set. Cannot send results to BuildPulse."
  exit /b 0
)
echo "BUILDPULSE_ACCOUNT_ID is set."

if not defined BUILDPULSE_REPOSITORY_ID (
  echo "BUILDPULSE_REPOSITORY_ID not set. Cannot send results to BuildPulse."
  exit /b 0
)
echo "BUILDPULSE_REPOSITORY_ID is set."

:: 4.Check test-reporter tool
echo "Checking test-reporter tool."

set "TEST_REPORTER_PATH=C:\test-reporter-windows-amd64.exe"
if not exist %TEST_REPORTER_PATH% (
  echo "Cannot find test-reporter tool in %TEST_REPORTER_PATH%. Cannot send results to BuildPulse."
  exit /b 0
)
echo "Test-reporter tool found in %TEST_REPORTER_PATH%."

:: 5.Set test-reporter tool required environment variables
echo "Setting test-reporter tool required environment variables."

set "GIT_BRANCH=%GIT_REMOTE_REF%"
:: GIT_COMMIT is already set by Jenkins
:: BUILD_URL is already set by Jenkins
set "ORGANIZATION_NAME=%GITHUB_ORG%"
set "REPOSITORY_NAME=%REPO_NAME%"

echo "GIT_BRANCH set to %GIT_BRANCH%."
echo "GIT_COMMIT set to %GIT_COMMIT%."
echo "BUILD_URL set to %BUILD_URL%."
echo "ORGANIZATION_NAME set to %ORGANIZATION_NAME%."
echo "REPOSITORY_NAME set to %REPOSITORY_NAME%."

:: GIT_URL is required for the test-reporter tool
:: We can hardcode it since we enforce nodejs/node
if "%GIT_URL%"=="" set "GIT_URL=https://github.com/%ORGANIZATION_NAME%/%REPOSITORY_NAME%"
echo "GIT_URL set to %GIT_URL%."

:: 6.Send results to BuildPulse
echo "Sending data to BuildPulse."

:: Set TREE_SHA from the current repo to process rebased branches
:: GIT_COMMIT is different from TREE_SHA for rebased branches
for /f %%i in ('git rev-parse HEAD') do set TREE_SHA=%%i
echo "TREE_SHA set to %TREE_SHA%."

:: Add available tags for easier navigation in BuildPulse
set "TAGS=%NODE_NAME% %nodes% v%NODEJS_MAJOR_VERSION%"
if defined NODEJS_VERSION (
  set "TAGS=%TAGS% v%NODEJS_VERSION%"
)
echo "TAGS set to %TAGS%."

:: Edit BUILD_URL to enable better grouping in BuildPulse
set "BUILD_URL_BACKUP=%BUILD_URL%"
for /f "usebackq delims=" %%i in (`powershell -File "%~dp0modify-build-url.ps1" -BUILD_URL "%BUILD_URL%"`) do set "BUILD_URL=%%i"
%TEST_REPORTER_PATH% submit %1 --account-id %BUILDPULSE_ACCOUNT_ID% --repository-id %BUILDPULSE_REPOSITORY_ID% --tree %TREE_SHA% --tags "%TAGS%"
set "BUILD_URL=%BUILD_URL_BACKUP%"
exit /b 0
