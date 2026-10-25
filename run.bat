@echo off
cd /d "%~dp0"
if not exist .venv\Scripts\python.exe python -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
set ADMIN_EMAIL=admin@trustvault.local
set ADMIN_PASSWORD=ChangeThisPassword123!
set TRUSTVAULT_SECRET=replace-this-with-a-long-random-secret
.venv\Scripts\python.exe -m uvicorn app.main:app --reload
pause
