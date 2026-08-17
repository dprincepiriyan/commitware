@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: CONFIGURATION: Updated for your directory
:: ==========================================
set "SCRIPT_DIR=%~dp0"
set "PYTHON_SCRIPT=committer.py"
set "TRACKER_FILE=last_run_date.txt"

:: Change directory to the repository folder
cd /d "%SCRIPT_DIR%"

:: Get today's date
set "TODAY=%DATE%"

:: Check if the tracker file exists and read the last run date
if exist "%TRACKER_FILE%" (
    set /p LAST_RUN=<"%TRACKER_FILE%"
) else (
    set "LAST_RUN=Never"
)

:: If the last run date matches today's date, exit immediately
if "!LAST_RUN!"=="!TODAY!" (
    exit /b
)

:: Loop to check for an internet connection
:CheckInternet
ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% neq 0 (
    :: Ping failed (No internet). Wait 60 seconds, then loop back.
    timeout /t 60 /nobreak >nul
    goto CheckInternet
)

:: Internet is available! Run the Python script
python "%PYTHON_SCRIPT%"

:: If the Python script ran successfully (no crash), save today's date
if %errorlevel% equ 0 (
    echo !TODAY!>"%TRACKER_FILE%"
)

exit /b