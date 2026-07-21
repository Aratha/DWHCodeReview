@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if not exist "backend\.venv\Scripts\python.exe" (
  echo Once setup-local.bat calistirin.
  pause
  exit /b 1
)
if not exist "frontend\node_modules\" (
  echo Once setup-local.bat calistirin.
  pause
  exit /b 1
)

start "DWH Code Review - Backend" cmd /k "%~dp0start-backend.bat"
timeout /t 2 /nobreak >nul
start "DWH Code Review - Frontend" cmd /k "%~dp0start-frontend.bat"
timeout /t 3 /nobreak >nul
start "" "http://localhost:5173"
echo Iki pencere acildi; tarayici aciliyor.
