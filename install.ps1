# ============================================================================
# Codex Tool Switcher — 一键安装脚本
# GitHub: https://github.com/YOUR_USERNAME/codex-tool-switcher
# ============================================================================

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Codex Tool Switcher — Installer" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$codexDir = "$env:USERPROFILE\.codex"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ====== 1. Check prerequisites ======
Write-Host "[1/5] Checking prerequisites..." -ForegroundColor Yellow

if (-not (Test-Path $codexDir)) {
    Write-Error "Codex directory not found: $codexDir"
    Write-Error "Please install Codex Desktop first: https://github.com/openai/codex"
    exit 1
}

$sqliteOk = Get-Command sqlite3 -ErrorAction SilentlyContinue
if (-not $sqliteOk) {
    Write-Warning "sqlite3 not found in PATH. Session migration will be skipped."
    Write-Warning "Install from: https://www.sqlite.org/download.html"
}

$codexDirExists = Test-Path $codexDir
Write-Host "  Codex directory: $codexDirExists"
Write-Host "  sqlite3: $($sqliteOk -ne $null)"

# ====== 2. Copy scripts ======
Write-Host ""
Write-Host "[2/5] Copying scripts to ~/.codex/..." -ForegroundColor Yellow

$switchSrc = Join-Path $scriptDir "switch-codex.ps1"
$guardSrc = Join-Path $scriptDir "guard-codex-config.ps1"

if (Test-Path $switchSrc) {
    Copy-Item $switchSrc "$codexDir\switch-codex.ps1" -Force
    Write-Host "  switch-codex.ps1 copied" -ForegroundColor Green
} else {
    Write-Error "switch-codex.ps1 not found in $scriptDir"
    exit 1
}

if (Test-Path $guardSrc) {
    Copy-Item $guardSrc "$codexDir\guard-codex-config.ps1" -Force
    Write-Host "  guard-codex-config.ps1 copied" -ForegroundColor Green
} else {
    Write-Error "guard-codex-config.ps1 not found in $scriptDir"
    exit 1
}

# ====== 3. Create backup directories ======
Write-Host ""
Write-Host "[3/5] Creating backup directories..." -ForegroundColor Yellow

$dirs = @(
    "$codexDir\guardian-golden",
    "$codexDir\auth-backups",
    "$codexDir\guardian-logs",
    "$codexDir\switch-backups"
)
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    Write-Host "  Created: $d"
}

# ====== 4. Initial session migration ======
Write-Host ""
Write-Host "[4/5] Migrating existing sessions to unified provider..." -ForegroundColor Yellow

if ($sqliteOk) {
    $db = "$codexDir\state_5.sqlite"
    if (Test-Path $db) {
        # Kill Codex if running (to avoid WAL conflicts)
        Get-Process -Name "Codex","codex" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2

        # Checkpoint WAL
        & sqlite3 $db "PRAGMA wal_checkpoint(TRUNCATE);" 2>$null

        # Check current state
        $before = & sqlite3 $db "SELECT model_provider, COUNT(*) FROM threads GROUP BY model_provider;" 2>$null
        Write-Host "  Before migration:"
        $before | ForEach-Object { Write-Host "    $_" }

        # Migrate
        & sqlite3 $db "UPDATE threads SET model_provider = 'codex_local_access' WHERE model_provider != 'codex_local_access';" 2>$null
        $result = & sqlite3 $db "SELECT changes();" 2>$null

        $after = & sqlite3 $db "SELECT model_provider, COUNT(*) FROM threads GROUP BY model_provider;" 2>$null
        Write-Host "  After migration:"
        $after | ForEach-Object { Write-Host "    $_" }
        Write-Host "  Sessions migrated: $result" -ForegroundColor Green
    } else {
        Write-Host "  No state database found, skipping." -ForegroundColor Gray
    }
} else {
    Write-Host "  sqlite3 not available, skipping." -ForegroundColor Yellow
}

# ====== 5. Install guardian as startup task ======
Write-Host ""
Write-Host "[5/5] Installing guardian as Windows startup task..." -ForegroundColor Yellow

# Uninstall old version first
& "$codexDir\guard-codex-config.ps1" -Uninstall 2>$null
Start-Sleep -Seconds 1

# Install new version
& "$codexDir\guard-codex-config.ps1" -Install

# Verify
$task = Get-ScheduledTask -TaskName "CodexConfigGuardian" -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "  Guardian installed: $($task.State)" -ForegroundColor Green
} else {
    Write-Warning "  Guardian installation may have failed. Check manually."
}

# ====== Done ======
Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Cyan
Write-Host "  & `"`$env:USERPROFILE\.codex\switch-codex.ps1`" cc       → CC Switch" -ForegroundColor White
Write-Host "  & `"`$env:USERPROFILE\.codex\switch-codex.ps1`" cockpit  → Cockpit Tools" -ForegroundColor White
Write-Host "  & `"`$env:USERPROFILE\.codex\switch-codex.ps1`" status   → View status" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT:" -ForegroundColor Yellow
Write-Host "  - Log in to ChatGPT in Codex AFTER running this installer" -ForegroundColor White
Write-Host "  - NEVER use CC Switch's 'Take over Codex' feature" -ForegroundColor White
Write-Host "  - Restart Codex after each switch" -ForegroundColor White
Write-Host ""
