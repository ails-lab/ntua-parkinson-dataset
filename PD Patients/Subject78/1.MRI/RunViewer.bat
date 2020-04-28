@echo off
REM 
REM Copyright (c) 2013
REM Codonics, Inc.
REM Middleburg Heights, OH, USA
REM All Rights Reserved
REM 
setlocal

set exitCmdWindowWhenDone=true
if "%1"=="noexit" set exitCmdWindowWhenDone=false
if "%2"=="noexit" set exitCmdWindowWhenDone=false

if "%1"=="install" goto installVcRedist
if "%1"=="run" goto runClarityViewer

goto checkVcRedist

:checkVcRedist
echo.
echo Checking for a compatible Visual C++ 2005 SP1 Redistributable...

set currDir=%CD%
set regRoot=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
set MIN_REQUIRED_MINOR_VERSION=762
set baseDir=%WINDIR%\WinSxS

set foundCompatibleVersion=false
set foundMin2005_SP1_CRT=false
set foundMin2005_SP1_MFC=false
set foundRegKey=true

:: Check what Uninstall GUIDs are available to see if there is one 
:: for a specific version of the x86 vcredist that we want to make sure is there.
:: See: http://blogs.msdn.com/b/astebner/archive/2007/01/24/updated-vc-8-0-runtime-redistributable-packages-are-included-in-visual-studio-2005-sp1.aspx
:: NOTE: reg.exe is not necessarily available on Win2000 (it is optional to install), so it will then fall back on the dir reading code below.
echo Checking for suitable registry key.
:: 8.0.50727.762
echo Checking for 2005 SP1 Redistributable Package (x86)
reg query %regRoot%\{7299052B-02A4-4627-81F2-1818DA5D550D} >nul 2>&1 
if %errorlevel% equ 0 goto foundRegKey

:: 8.0.50727.4053
echo Checking for 2005 SP1 ATL Security Update Redistributable Package (x86)
reg query %regRoot%\{837B34E3-7C30-493C-8F6A-2B0F04E2912C} >nul 2>&1 
if %errorlevel% equ 0 goto foundRegKey

:: 8.0.50727.6195
echo Checking for 2005 SP1 MFC Security Update Redistributable Package (x86)
reg query %regRoot%\{710F4C1C-CC18-4C49-8CBF-51240C89A1A2} >nul 2>&1 
if %errorlevel% equ 0 goto foundRegKey

echo No suitable registry key found.
echo.
echo Checking for any suitable VC Redist files.

cd /d "%baseDir%"

:: Check any 32-bit 2005 VC redist CRT dirs
:: This should catch if MS releases any new VC++ 2005 SP1 updates and its minor version number is over 9000! (or anything over 6195 really)
for /d %%a in (*x86*_Microsoft.VC80.CRT_*) do (
	echo Checking: %%a
	REM get the minor version of the component, which is the 9th token (e.g. array[8]) after 
	REM splitting on each period and underscore character.
	REM e.g. x86_Microsoft.VC80.CRT_1fc8b3b9a1e18e3b_8.0.50727.762_x-ww_6b128700
	REM e.g. x86_Microsoft.VC80.CRT_1fc8b3b9a1e18e3b_8.0.50727.[762]_x-ww_6b128700
	for /f "tokens=9 delims=._" %%b in ("%%a") do (
		echo   Checking version: %%b
		if %%b GEQ %MIN_REQUIRED_MINOR_VERSION% (
			echo     Checking msvcm80.dll
			if exist %%a\msvcm80.dll (
				echo     Checking msvcp80.dll
				if exist %%a\msvcp80.dll (
					echo     Checking msvcr80.dll
					if exist %%a\msvcr80.dll (
						echo     Found compatible version: %%b
						set foundMin2005_SP1_CRT=true
					)
				)
			)
		)
	)
)

:: Check any 32-bit 2005 VC redist MFC dirs
:: This should catch if MS releases any new VC++ 2005 SP1 updates and its minor version number is over 9000! (or anything over 6195 really)
for /d %%a in (*x86*_Microsoft.VC80.MFC_*) do (
	echo Checking: %%a
	REM get the minor version of the component, which is the 9th token (e.g. array[8]) after 
	REM splitting on each period and underscore character.
	REM e.g. x86_Microsoft.VC80.MFC_1fc8b3b9a1e18e3b_8.0.50727.762_x-ww_3bf8fa05
	REM e.g. x86_Microsoft.VC80.MFC_1fc8b3b9a1e18e3b_8.0.50727.[762]_x-ww_3bf8fa05
	for /f "tokens=9 delims=._" %%b in ("%%a") do (
		echo   Checking version: %%b
		if %%b GEQ %MIN_REQUIRED_MINOR_VERSION% (
			echo     Checking mfc80.dll
			if exist %%a\mfc80.dll (
				echo     Checking mfc80u.dll
				if exist %%a\mfc80u.dll (
					echo     Checking mfcm80.dll
					if exist %%a\mfcm80.dll (
						echo     Checking mfcm80u.dll
						if exist %%a\mfcm80u.dll (
							echo     Found compatible version: %%b
							set foundMin2005_SP1_MFC=true
						)
					)
				)
			)
		)
	)
)

cd /d "%currDir%"

if %foundMin2005_SP1_CRT%==true (
	if %foundMin2005_SP1_MFC%==true (
		echo Compatible Visual C++ 2005 SP1 Redistributable found ^(files^).  Can run viewer.
		set foundCompatibleVersion=true
		goto checkFoundCompatibleVersion
	)
)

echo No suitable VC Redist files found.
goto checkFoundCompatibleVersion

:foundRegKey
set foundCompatibleVersion=true
echo Compatible Visual C++ 2005 SP1 Redistributable found ^(reg key^).  Can run viewer.
goto checkFoundCompatibleVersion

:checkFoundCompatibleVersion
if %foundCompatibleVersion%==true (
	goto runClarityViewer
)

echo No compatible Visual C++ 2005 SP1 Redistributable found.
echo Prompting user to install.
start "" %0 install
if %exitCmdWindowWhenDone%==true (
	exit
)
goto end

:installVcRedist
title Codonics Clarity Viewer - Required Software Check

:: http://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
set canInstall=false
net session >nul 2>&1
if %errorLevel% == 0 (
	set canInstall=true
)

echo.
echo ============================================================================
echo Error: Minimum required software for Codonics Clarity Viewer not installed:
echo   Microsoft Visual C++ 2005 SP1 Redistributable
echo ============================================================================
if %canInstall%==false (
	echo.
	echo ============================================================================
	echo Warning:  You do not seem to have Administrative privileges.
	echo Please contact your Administrator in order to install the required software.
	echo ============================================================================
)
echo.
echo Press any key to run the Installer for the required software.
pause 2>&1 >nul

echo.
echo Running Installer.  This may take several minutes, please wait...
start "" /wait bin\vcredist_x86_8.0.50727.6195.exe /q
echo.
echo Installer completed.

goto runClarityViewer

:runClarityViewer
echo.
echo Running Clarity Viewer...
set VIEWER_EXE=Virtua.exe
if exist bin\VirtuaAdv.exe set VIEWER_EXE=VirtuaAdv.exe
start "" /min bin\%VIEWER_EXE%
if %errorlevel% neq 0 (
	REM this doesn't work on Win2000, where the errorlevel is still 0 even if the process fails to start
	echo Viewer .exe failed to run, probably because VC Redist isn't available.
	echo Prompting user to install VC Redist.
	start "" %0 install
)
if %exitCmdWindowWhenDone%==true (
	exit
)
goto end

:end
