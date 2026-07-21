@echo off
setlocal EnableExtensions
cd /d "%~dp0"

where docker >nul 2>&1
if errorlevel 1 (
  echo HATA: Docker bulunamadi. Docker Desktop kurulu ve calisir olmali.
  pause
  exit /b 1
)

if not exist "backend\.env" (
  if exist "backend\.env.example" (
    copy /Y "backend\.env.example" "backend\.env" >nul
    echo backend\.env olusturuldu — Docker icin MSSQL/LLM adreslerini duzenleyin ^(host.docker.internal^).
    pause
  ) else (
    echo HATA: backend\.env yok.
    pause
    exit /b 1
  )
)

echo Docker Compose baslatiliyor ^(build + up^)...
echo Arayuz: http://localhost:8080  API: http://localhost:8000
docker compose up --build
pause
