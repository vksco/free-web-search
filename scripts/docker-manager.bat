@echo off
REM SearXNG Docker Manager - Windows Version
REM Manages self-hosted SearXNG search engine container

setlocal EnableDelayedExpansion

set CONTAINER_NAME=searxng-openclaw
set IMAGE_NAME=searxng/searxng:latest
set PORT=8888

REM Colors for Windows
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "NC=[0m"

:main
if "%1"=="" goto usage
if "%1"=="start" goto start
if "%1"=="stop" goto stop
if "%1"=="restart" goto restart
if "%1"=="status" goto status
if "%1"=="logs" goto logs
if "%1"=="remove" goto remove
goto usage

:log_info
echo %GREEN%[INFO]%NC% %~1
goto :eof

:log_warn
echo %YELLOW%[WARN]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

:status
docker ps --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul
if %errorlevel% equ 0 (
    echo running
) else (
    echo stopped
)
goto :eof

:start
call :log_info "Starting SearXNG container..."
call :log_info "Detected OS: Windows"

REM Check if container is already running
docker ps --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul
if %errorlevel% equ 0 (
    call :log_info "SearXNG container is already running"
    goto :eof
)

REM Pull image if not exists
docker image inspect %IMAGE_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    call :log_info "Pulling SearXNG image..."
    docker pull %IMAGE_NAME%
)

REM Check if stopped container exists
docker ps -a --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul
if %errorlevel% equ 0 (
    call :log_info "Starting existing container..."
    docker start %CONTAINER_NAME%
) else (
    call :log_info "Creating new container..."
    
    REM Get script directory
    set "SCRIPT_DIR=%~dp0"
    set "DOCKER_DIR=%SCRIPT_DIR%..\docker"
    
    REM Run container
    docker run -d ^
        --name %CONTAINER_NAME% ^
        -p %PORT%:8080 ^
        -e "SEARXNG_BASE_URL=http://localhost:%PORT%" ^
        -e "INSTANCE_NAME=OpenClaw-Search" ^
        -v "%DOCKER_DIR%\settings.yml:/etc/searxng/settings.yml:ro" ^
        --memory="2g" ^
        --cpus="1.0" ^
        --restart unless-stopped ^
        %IMAGE_NAME%
)

REM Wait for container
call :log_info "Waiting for container to start..."
timeout /t 10 /nobreak >nul

REM Check if running
docker ps --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul
if %errorlevel% equ 0 (
    call :log_info "SearXNG started on http://localhost:%PORT%"
    call :log_warn "Note: JSON API may require additional configuration"
    call :log_info "Testing web interface: curl http://localhost:%PORT%"
) else (
    call :log_error "SearXNG failed to start. Check logs: docker logs %CONTAINER_NAME%"
)
goto :eof

:stop
docker ps --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul
if %errorlevel% neq 0 (
    call :log_info "SearXNG container is not running"
    goto :eof
)

call :log_info "Stopping SearXNG container..."
docker stop %CONTAINER_NAME% >nul
call :log_info "SearXNG stopped"
goto :eof

:restart
call :log_info "Restarting SearXNG container..."
call :stop
timeout /t 2 /nobreak >nul
call :start
goto :eof

:logs
docker logs -f %CONTAINER_NAME%
goto :eof

:remove
call :stop
call :log_info "Removing SearXNG container..."
docker rm %CONTAINER_NAME% >nul 2>&1
call :log_info "Container removed"
goto :eof

:usage
echo SearXNG Docker Manager - Windows Version
echo.
echo Usage: %~nx0 {start^|stop^|restart^|status^|logs^|remove}
echo.
echo Container: %CONTAINER_NAME%
echo Image:     %IMAGE_NAME%
echo Port:      %PORT%
echo URL:       http://localhost:%PORT%
echo.
echo Compatible with: Windows 10/11 with Docker Desktop
exit /b 1
