@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title DWH Code Review - Backend

if not exist "backend\.venv\Scripts\python.exe" (
  echo Once setup-local.bat calistirin.
  pause
  exit /b 1
)

echo Backend: http://127.0.0.1:8000  ^(Ctrl+C ile durdur^)
"backend\.venv\Scripts\python.exe" -m uvicorn main:app --app-dir "backend" --host 127.0.0.1 --port 8000 --reload
pause
