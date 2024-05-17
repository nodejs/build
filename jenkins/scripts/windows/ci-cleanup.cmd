:: Processes that can and have interfered with CI in the past
taskkill /t /f /fi "IMAGENAME eq node.exe"
taskkill /t /f /fi "IMAGENAME eq cctest.exe"
taskkill /t /f /fi "IMAGENAME eq embedtest.exe"
taskkill /t /f /fi "IMAGENAME eq run-tests.exe"
taskkill /t /f /fi "IMAGENAME eq msbuild.exe"
taskkill /t /f /fi "IMAGENAME eq mspdbsrv.exe"
taskkill /t /f /fi "IMAGENAME eq yes.exe"
taskkill /t /f /fi "IMAGENAME eq python.exe"
taskkill /t /f /fi "IMAGENAME eq node-copy.exe"

:: rm is better for very long paths
rm -rfv node/test/tmp*

:: Attempt to recover the worker if a run is aborted during git operations
if exist build\.git\index.lock rd /s /q build\.git
if exist node\.git\index.lock rd /s /q node\.git

:: Don't fail - clear errorlevel
ver > nul
