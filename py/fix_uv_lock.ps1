Write-Host "Fixing UV file lock issue..." -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 1: Stopping Python processes..." -ForegroundColor Yellow
$pythonProcesses = Get-Process | Where-Object { $_.Name -match "python|pylsp|jedi" }
if ($pythonProcesses) {
    $pythonProcesses | ForEach-Object {
        Write-Host "  Stopping: $($_.Name) (PID: $($_.Id))"
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "  No Python processes found"
}

Write-Host ""
Write-Host "Step 2: Waiting for file handles to release..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "Step 3: Running UV sync..." -ForegroundColor Yellow
& uv sync

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ UV sync completed successfully!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ UV sync failed. Additional troubleshooting:" -ForegroundColor Red
    Write-Host ""
    Write-Host "Option 1: Close Kiro/IDE and retry" -ForegroundColor Yellow
    Write-Host "  1. Close this IDE completely"
    Write-Host "  2. Open a fresh PowerShell terminal"
    Write-Host "  3. Run: cd py; uv sync"
    Write-Host ""
    Write-Host "Option 2: Nuclear option - delete .venv" -ForegroundColor Yellow
    Write-Host "  1. Close all IDEs/editors"
    Write-Host "  2. Run: Remove-Item -Recurse -Force .venv"
    Write-Host "  3. Run: uv sync"
}

Write-Host ""
