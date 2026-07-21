@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo [DWH Code Review] Ilk kurulum (venv + npm)...
echo.

where py >nul 2>&1
if %ERRORLEVEL%==0 (
  set "PY=py -3"
) else (
  where python >nul 2>&1
  if errorlevel 1 (
    echo HATA: Python bulunamadi. Python 3.10+ kurun ve PATH'e ekleyin.
    pause
    exit /b 1
  )
  set "PY=python"
)

where npm >nul 2>&1
if errorlevel 1 (
  echo HATA: npm bulunamadi. Node.js LTS kurun.
  pause
  exit /b 1
)

if not exist "backend\.env" (
  if exist "backend\.env.example" (
    copy /Y "backend\.env.example" "backend\.env" >nul
    echo backend\.env olusturuldu — SQL Server ve LLM alanlarini doldurun.
  ) else (
    echo UYARI: backend\.env.example yok; backend\.env elle olusturun.
  )
)

if not exist "backend\.venv\Scripts\python.exe" (
  echo Sanal ortam olusturuluyor...
  %PY% -m venv "backend\.venv"
  if errorlevel 1 (
    echo HATA: venv olusturulamadi.
    pause
    exit /b 1
  )
)

echo Python bagimliliklari yukleniyor...
"backend\.venv\Scripts\python.exe" -m pip install --upgrade pip
"backend\.venv\Scripts\python.exe" -m pip install -r "backend\requirements.txt"
if errorlevel 1 (
  echo HATA: pip install basarisiz.
  pause
  exit /b 1
)

echo npm install (frontend)...
pushd "frontend"
call npm install
if errorlevel 1 (
  popd
  echo HATA: npm install basarisiz.
  pause
  exit /b 1
)
popd

echo.
echo Kurulum tamam. Sonra start-app.bat veya start-backend.bat + start-frontend.bat kullanin.
pause
