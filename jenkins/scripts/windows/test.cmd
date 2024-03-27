git rev-parse --verify HEAD
git rev-parse "HEAD^"

:: Extract binary
md5sum binary/binary.tar.gz
tar xzvf binary/binary.tar.gz
if errorlevel 1 exit /b
if exist out\Release\node.exe ln -s out/Release Release
md5sum config.gypi icu_config.gypi Release/node.exe Release/node.lib Release/openssl-cli.exe Release/cctest.exe

:: Run the tests
call :diagnostics Before
set DEBUG_HELPER=1
call vcbuild.bat release noprojgen nobuild ignore-flaky %VCBUILD_TARGET%
set "EXIT_RETURN_VALUE=%errorlevel%"
ver > nul
call :diagnostics After

:: Convert test results
if exist test.tap (
  tap2junit -i test.tap -o js-tests.junit.xml
  if errorlevel 1 exit /b
)
if exist js-tests.junit.xml (
  call %~dp0buildpulse.cmd js-tests.junit.xml
)
if exist cctest.tap (
  tap2junit -i cctest.tap -o cctest.junit.xml
  if errorlevel 1 exit /b
)
if exist cctest.junit.xml (
  call %~dp0buildpulse.cmd cctest.junit.xml
)

:: The JUnit Plugin only marks the job as Unstable when it finds any kind of failure, including flaky tests.
:: We need to use the return code of vcbuild.bat to fail the job when there are real failures.
exit /b %EXIT_RETURN_VALUE%



:diagnostics
echo off
set "DIAGFILE=c:\jenkins_diagnostics.txt"
echo. >> %DIAGFILE%
echo. >> %DIAGFILE%
echo. >> %DIAGFILE%
set "TS=%date% %time%"
echo %TS%
echo %TS% >> %DIAGFILE%
echo %1 running vcbuild >> %DIAGFILE%
echo %BUILD_TAG% >> %DIAGFILE%
echo %BUILD_URL% >> %DIAGFILE%
echo %NODE_NAME% >> %DIAGFILE%
echo. >> %DIAGFILE%
echo netstat -abno >> %DIAGFILE%
netstat -abno >> %DIAGFILE% 2>&1
echo. >> %DIAGFILE%
echo tasklist /v >> %DIAGFILE%
tasklist /v >> %DIAGFILE% 2>&1
echo. >> %DIAGFILE%
echo tasklist /svc >> %DIAGFILE%
tasklist /svc >> %DIAGFILE% 2>&1
echo. >> %DIAGFILE%
echo wmic path win32_process get Caption,Processid,Commandline >> %DIAGFILE%
wmic path win32_process get Caption,Processid,Commandline | more >> %DIAGFILE% 2>&1
mv %DIAGFILE% %DIAGFILE%-OLD
cat %DIAGFILE%-OLD | sed s/\r//g;s/$/\r/ | tail -c 20000000 > %DIAGFILE%
rm %DIAGFILE%-OLD
echo on
tasklist | grep node
exit /b 0
