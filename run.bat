@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" py -m venv .venv
call .venv\Scripts\activate.bat
python -m pip install -r backend\requirements.txt
start "ForgeAI server" /b python backend\app.py
for /l %%i in (1,1,45) do (
  powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing http://127.0.0.1:5000/ -TimeoutSec 1 | Out-Null; exit 0 } catch { exit 1 }" >nul 2>nul
  if not errorlevel 1 goto server_ready
  timeout /t 1 /nobreak >nul
)
:server_ready
where msedge >nul 2>nul
if %errorlevel%==0 (
  start "" msedge --kiosk http://localhost:5000 --edge-kiosk-type=fullscreen
) else (
  start "" http://localhost:5000
)
endlocal
