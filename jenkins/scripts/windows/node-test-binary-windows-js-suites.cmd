:: Git
set COMPILED_BY=%nodes:*-COMPILED_BY-=%
set GIT_REPO=%TEMP_REPO%
set GIT_REF=refs/heads/%TEMP_BRANCH%-bin-win-%COMPILED_BY%
call %~dp0git-checkout.cmd
if errorlevel 1 exit /b

:: Run tests
set "test_ci_args=--run=%RUN_SUBSET%,4 --measure-flakiness 9"
set VCBUILD_TARGET=test-ci-js
set FLAKY_TESTS=keep_retrying
call %~dp0test.cmd
if errorlevel 1 exit /b

:: Check existence of test results
if not exist js-tests.junit.xml (
  echo "Could not find test.tap or js-tests.junit.xml"
  exit /b 1
)
