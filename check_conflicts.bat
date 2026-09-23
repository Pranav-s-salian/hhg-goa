@echo off
echo ============================================
echo Checking for Git Merge Conflicts
echo ============================================
echo.

echo [1] Checking git status...
echo ----------------------------------------
git status
echo.

echo [2] Checking for conflict markers...
echo ----------------------------------------
git diff --check
echo.

echo [3] Searching for conflict markers in files...
echo ----------------------------------------
findstr /S /N /C:"<<<<<<< HEAD" /C:"=======" /C:">>>>>>> " *.* 2>nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ❌ CONFLICTS FOUND! See files above.
) else (
    echo ✅ No conflict markers found
)
echo.

echo [4] Checking for unmerged paths...
echo ----------------------------------------
git ls-files -u
if %ERRORLEVEL% EQU 0 (
    echo ✅ No unmerged files
) else (
    echo ❌ Unmerged files found above
)
echo.

echo [5] Checking current branch...
echo ----------------------------------------
git branch --show-current
echo.

echo ============================================
echo Check complete!
echo ============================================
pause
