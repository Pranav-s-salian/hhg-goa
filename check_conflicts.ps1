Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Checking for Git Merge Conflicts" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1] Git Status..." -ForegroundColor Yellow
Write-Host "----------------------------------------"
git status
Write-Host ""

Write-Host "[2] Checking for conflict markers with git diff..." -ForegroundColor Yellow
Write-Host "----------------------------------------"
$diffCheck = git diff --check 2>&1
if ($diffCheck) {
    Write-Host $diffCheck -ForegroundColor Red
} else {
    Write-Host "✅ No whitespace or conflict issues detected" -ForegroundColor Green
}
Write-Host ""

Write-Host "[3] Searching files for conflict markers..." -ForegroundColor Yellow
Write-Host "----------------------------------------"
$conflictMarkers = Get-ChildItem -Recurse -File -Exclude "*.git*","node_modules","*.venv*","*.exe","*.dll" | 
    Select-String -Pattern "^<<<<<<< |^=======|^>>>>>>> " -SimpleMatch | 
    Select-Object Path, LineNumber, Line

if ($conflictMarkers) {
    Write-Host "❌ CONFLICT MARKERS FOUND:" -ForegroundColor Red
    $conflictMarkers | Format-Table -AutoSize
} else {
    Write-Host "✅ No conflict markers found in files" -ForegroundColor Green
}
Write-Host ""

Write-Host "[4] Checking for unmerged paths..." -ForegroundColor Yellow
Write-Host "----------------------------------------"
$unmerged = git ls-files -u
if ($unmerged) {
    Write-Host "❌ UNMERGED FILES:" -ForegroundColor Red
    Write-Host $unmerged
} else {
    Write-Host "✅ No unmerged files" -ForegroundColor Green
}
Write-Host ""

Write-Host "[5] Current branch info..." -ForegroundColor Yellow
Write-Host "----------------------------------------"
$branch = git branch --show-current
Write-Host "Current branch: $branch" -ForegroundColor Cyan
Write-Host ""

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Check Complete!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
