@echo off
setlocal EnableExtensions
cd /d "%~dp0\frontend"
title DWH Code Review - Frontend

if not exist "node_modules\" (
  echo Once setup-local.bat calistirin ^(npm install^).
  pause
  exit /b 1
)

where npm >nul 2>&1
if errorlevel 1 (
  echo HATA: npm bulunamadi.
  pause
  exit /b 1
)

echo Arayuz: http://localhost:5173  ^(Ctrl+C ile durdur^)
call npm run dev
pause
