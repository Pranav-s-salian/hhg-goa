@echo off
REM Sync Python dependencies without file locking issues
echo Syncing Python dependencies...
cd /d "%~dp0"

REM Stop any Python processes that might be locking files
echo.
echo If you see errors about locked files, close any:
echo - Python shells/REPL
echo - Jupyter notebooks
echo - VS Code Python language server (reload VS Code window)
echo - Other IDEs with Python support
echo.

uv sync

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ Dependencies synced successfully!
    echo.
    echo You can now run your backend server.
) else (
    echo.
    echo ✗ Sync failed. Try:
    echo   1. Close VS Code and other IDEs
    echo   2. Kill any Python processes in Task Manager
    echo   3. Run this script again
    echo.
    pause
)
