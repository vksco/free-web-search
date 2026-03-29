@echo off
REM Auto-Update Script for Free Web Search Skill - Windows Version
REM Automatically checks and installs updates when the skill runs
REM Compatible with Windows 10/11

setlocal EnableDelayedExpansion

REM Get script directory
set "SCRIPT_DIR=%~dp0.."
set "SKILL_NAME=free-web-search"
set "REPO_URL=https://github.com/vksco/free-web-search"
set "BRANCH=main"
set "LOCAL_VERSION_FILE=%SCRIPT_DIR%\VERSION"
set "REMOTE_VERSION_URL=https://raw.githubusercontent.com/vksco/free-web-search/main/VERSION"
set "LOG_FILE=%SCRIPT_DIR%\update.log"
set "TEMP_DIR=%TEMP%\free-web-search-update-%RANDOM%"
set "BACKUP_DIR=%SCRIPT_DIR%\backups"

REM Colors for Windows
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Get timestamp
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set TIMESTAMP=%%a-%%b-%%c
for /f "tokens=1-3 delims=:." %%a in ('time /t') do set TIMESTAMP=%TIMESTAMP% %%a:%%b:%%c

:main
call :log "INFO" "Checking for updates..."

REM Check if VERSION file exists
if not exist "%LOCAL_VERSION_FILE%" (
    call :log "WARN" "VERSION file not found, assuming first run"
    echo 0.0.0 > "%LOCAL_VERSION_FILE%"
)

REM Get local version
set /p LOCAL_VERSION=<"%LOCAL_VERSION_FILE%"

REM Get remote version using PowerShell
for /f "delims=" %%i in ('powershell -Command "try { (Invoke-WebRequest -Uri '%REMOTE_VERSION_URL%' -TimeoutSec 5 -UseBasicParsing).Content.Trim() } catch { exit 1 }"') do set REMOTE_VERSION=%%i

if !errorlevel! neq 0 (
    call :log "WARN" "Could not fetch remote version, skipping update check"
    exit /b 0
)

REM Check if we got a valid response
if "%REMOTE_VERSION%"=="" (
    call :log "WARN" "Empty version response, skipping update check"
    exit /b 0
)

REM Compare versions
if "%LOCAL_VERSION%"=="%REMOTE_VERSION%" (
    REM No update available
    exit /b 0
)

REM Update available!
call :log "INFO" "Update available: v%LOCAL_VERSION% to v%REMOTE_VERSION%"

REM Create backup
call :create_backup

REM Download and install update
call :install_update "%REMOTE_VERSION%"

exit /b 0

:log
REM %1 = level, %2 = message
echo [%TIMESTAMP%] [%1] %2 >> "%LOG_FILE%"
if "%1"=="INFO" echo %GREEN%[UPDATE]%NC% %2
goto :eof

:create_backup
call :log "INFO" "Creating backup before update..."

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Create backup using PowerShell (compresses folder)
set "BACKUP_FILE=%BACKUP_DIR%\skill_%TIMESTAMP: =_%".zip
powershell -Command "Compress-Archive -Path '%SCRIPT_DIR%\*' -DestinationPath '%BACKUP_FILE%' -Force"

call :log "INFO" "Backup created: %BACKUP_FILE%"
goto :eof

:install_update
set NEW_VERSION=%~1

call :log "INFO" "Downloading v%NEW_VERSION% from GitHub..."

REM Create temporary directory
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

REM Clone repository using git
git clone --depth 1 --branch %BRANCH% %REPO_URL% "%TEMP_DIR%" 2>nul
if %errorlevel% neq 0 (
    call :log "WARN" "Failed to download update"
    rmdir /s /q "%TEMP_DIR%" 2>nul
    exit /b 1
)

call :log "INFO" "Installing update..."

REM Preserve important files before update
set "PRESERVE_DIR=%TEMP%\free-web-search-preserve-%RANDOM%"
if not exist "%PRESERVE_DIR%" mkdir "%PRESERVE_DIR%"

REM Preserve user configuration
if exist "%SCRIPT_DIR%\docker\settings.yml" (
    copy "%SCRIPT_DIR%\docker\settings.yml" "%PRESERVE_DIR%\" >nul
)

if exist "%SCRIPT_DIR%\docker\secret_key" (
    copy "%SCRIPT_DIR%\docker\secret_key" "%PRESERVE_DIR%\" >nul
)

REM Copy new files (robocopy for mirroring)
robocopy "%TEMP_DIR%" "%SCRIPT_DIR%" /MIR /XD backups .git /XF *.log docker\settings.yml docker\secret_key >nul

REM Restore preserved files
if exist "%PRESERVE_DIR%\settings.yml" (
    copy "%PRESERVE_DIR%\settings.yml" "%SCRIPT_DIR%\docker\" >nul
)

if exist "%PRESERVE_DIR%\secret_key" (
    copy "%PRESERVE_DIR%\secret_key" "%SCRIPT_DIR%\docker\" >nul
)

REM Clean up
rmdir /s /q "%TEMP_DIR%" 2>nul
rmdir /s /q "%PRESERVE_DIR%" 2>nul

call :log "INFO" "Updated to v%NEW_VERSION%"
goto :eof
