:: Use Python 2 up to Node 12
if %NODEJS_MAJOR_VERSION% leq 12 set "PATH=C:\Python27\;C:\Python27\Scripts;%PATH%"

:: Opt-in for a generating binlog (work with code has https://github.com/nodejs/node/pull/26431/files)
set "msbuild_args=/binaryLogger:node.binlog"

:: Opt-in for a clcache
if not defined DISABLE_CLCACHE if exist C:\clcache\dist\clcache_main\clcache_main.exe (
  set CLCACHE_OBJECT_CACHE_TIMEOUT_MS=60000
  set CLCACHE_BASEDIR="%WORKSPACE%"
  set CLCACHE_HARDLINK=1
  set "msbuild_args=%msbuild_args% /p:CLToolExe=clcache_main.exe /p:CLToolPath=C:\clcache\dist\clcache_main"
  :: multiproc msbuild doesn't play nice with clcache
  set NUMBER_OF_PROCESSORS=1
  :: Ensure cache size
  C:\clcache\dist\clcache_main\clcache_main.exe -M 20000000000
  C:\clcache\dist\clcache_main\clcache_main.exe -s
)

SETLOCAL EnableDelayedExpansion

:: Call vcbuild
if "%nodes:~-6%" == "-arm64" (
  :: Building MSI is not yet supported for ARM64 with WiX 3.
  :: Since PR with WiX 4 migration changed folder structure,
  :: this check can determine which WiX is used for the MSI.
  :: Refs: https://github.com/nodejs/node/pull/45943
  if exist tools\msvs\msi\nodemsi.wixproj (
    :: WiX 3 - doesn't build ARM64 MSI
    set "VCBUILD_EXTRA_ARGS=arm64 release"
  ) else (
    :: WiX 4 - builds ARM64 MSI
    set "VCBUILD_EXTRA_ARGS=arm64 %VCBUILD_EXTRA_ARGS%"

    :: ARM64 MSI needs x64 node.exe to generate the license file.
    :: It is downloaded from vcbuild.bat and is known to hang,
    :: thus failing the build after timing out (1-2% runs).
    :: Downloading it from here and updating it weekly should
    :: decrease, if not remove, these types of CI failures.
    :: 1. Make node_exe_cache directory if it doesn't exist.
    if not exist C:\node_exe_cache (
      mkdir C:\node_exe_cache
    )
    :: 2. Check if node.exe exists and if it's older then 7 days.
    set NODE_CACHED=False
    set CACHE_INVALID=False
    if exist C:\node_exe_cache\node.exe (
      set NODE_CACHED=True
      forfiles /p "C:\node_exe_cache" /m "node.exe" /d -7 && set CACHE_INVALID=True
    )
    :: 3. If node.exe didn't exist, or was older then 7 days, download the new one and check it's validity.
    set SHOULD_DOWNLOAD=False
    if !NODE_CACHED! == False set SHOULD_DOWNLOAD=True
    if !CACHE_INVALID! == True set SHOULD_DOWNLOAD=True
    set VALID_SHASUM=
    set DOWNLOAD_SHASUM=
    if !SHOULD_DOWNLOAD! == True (
      :: 3.1. Download SHASUMS and find value for "win-x64/node.exe".
      ver > nul
      curl -L https://nodejs.org/dist/latest/SHASUMS256.txt -o C:\node_exe_cache\SHASUMS256.txt
      if not !errorlevel! == 0 goto download_cleanup
      for /f %%a in ('findstr win-x64/node.exe C:\node_exe_cache\SHASUMS256.txt') do set VALID_SHASUM=%%a
      if [!VALID_SHASUM!] == [] goto download_cleanup
      :: 3.2. Download win-x64/node.exe and calculate its SHASUM.
      ver > nul
      curl -L https://nodejs.org/dist/latest/win-x64/node.exe -o C:\node_exe_cache\node_new.exe
      if not !errorlevel! == 0 goto download_cleanup
      for /f %%a in ('certutil -hashfile C:\node_exe_cache\node_new.exe SHA256 ^| find /v ":"') do set DOWNLOAD_SHASUM=%%a
      if [!DOWNLOAD_SHASUM!] == [] goto download_cleanup
      :: 3.3. Check if downloaded file is valid. If yes, delete old one. If not, delete new one.
      if !VALID_SHASUM! == !DOWNLOAD_SHASUM! (
        if exist C:\node_exe_cache\node.exe (
          del C:\node_exe_cache\node.exe
        )
        ren C:\node_exe_cache\node_new.exe node.exe
      )
      :: 3.4. Clean up all of the temporary files.
:download_cleanup
      if exist C:\node_exe_cache\SHASUMS256.txt (
        del C:\node_exe_cache\SHASUMS256.txt
      )
      if exist C:\node_exe_cache\node_new.exe (
        del C:\node_exe_cache\node_new.exe
      )
    )
    :: 4. Copy the latest valid node, if any, to where vcbuild expects it to be
    if exist C:\node_exe_cache\node.exe (
      if not exist temp-vcbuild (
        mkdir temp-vcbuild
      )
      copy C:\node_exe_cache\node.exe temp-vcbuild\node-x64-cross-compiling.exe
    )
  )
) else if "%nodes:~-4%" == "-x86" (
  set "VCBUILD_EXTRA_ARGS=x86 %VCBUILD_EXTRA_ARGS%"
) else (
  set "VCBUILD_EXTRA_ARGS=x64 %VCBUILD_EXTRA_ARGS%"
)

ENDLOCAL

set DEBUG_HELPER=1
call vcbuild.bat %VCBUILD_EXTRA_ARGS%
if errorlevel 1 exit /b
:: echo back on after vcbuild
echo on
