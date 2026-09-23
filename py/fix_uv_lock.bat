@echo off
echo Fixing UV file lock issue...
echo.

echo Step 1: Killing Python processes that might be locking files...
taskkill /F /IM python.exe 2>nul
taskkill /F /IM pythonw.exe 2>nul
taskkill /F /IM pylsp.exe 2>nul
taskkill /F /IM jedi-language-server.exe 2>nul

echo.
echo Step 2: Waiting for file handles to release...
timeout /t 2 /nobreak >nul

echo.
echo Step 3: Attempting UV sync...
uv sync

echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ UV sync completed successfully!
) else (
    echo ❌ UV sync still failed. Try these additional steps:
    echo    1. Close VS Code or your IDE completely
    echo    2. Wait 10 seconds
    echo    3. Delete the py\.venv folder
    echo    4. Run: uv sync
)

pause
