# ============================================================================
# Codex Tool Switcher v3 — CC Switch <-> Cockpit Tools
# GitHub: https://github.com/YOUR_USERNAME/codex-tool-switcher
#
# 统一 provider "codex_local_access" — Codex 原生保留名，会话永远可见
# 切换只改 base_url 端口，不动 provider 名，历史对话永不丢失
#
# 用法:
#   .\switch-codex.ps1 cc       → 切换到 CC Switch (端口 16897)
#   .\switch-codex.ps1 cockpit  → 切换到 Cockpit Tools (端口 42805)
#   .\switch-codex.ps1 status   → 查看当前状态
#   .\switch-codex.ps1 migrate  → 迁移旧会话到统一 provider
# ============================================================================

$codexDir = "$env:USERPROFILE\.codex"
$configPath = Join-Path $codexDir "config.toml"
$authPath = Join-Path $codexDir "auth.json"
$stateDbPath = Join-Path $codexDir "state_5.sqlite"
$backupDir = Join-Path $codexDir "switch-backups"
$UNIFIED = "codex_local_access"
$userProfile = $env:USERPROFILE.ToLower()

$null = New-Item -ItemType Directory -Path $backupDir -Force

function Get-CurrentTarget {
    if (-not (Test-Path $configPath)) { return "unknown" }
    $config = Get-Content $configPath -Raw
    if ($config.Contains("16897")) { return "cc_switch" }
    if ($config.Contains("42805")) { return "cockpit" }
    return "unknown"
}

function Protect-AuthJson {
    if (-not (Test-Path $authPath)) {
        Write-Warning "auth.json missing!"
        return $false
    }
    try {
        $auth = Get-Content $authPath -Raw | ConvertFrom-Json
    }
    catch {
        Write-Warning "auth.json corrupted, recreating..."
        @{ auth_mode = "chatgpt"; OPENAI_API_KEY = $null } | ConvertTo-Json | Set-Content $authPath -Encoding UTF8
        return $true
    }
    $currentMode = $null
    try { $currentMode = $auth.auth_mode }
    catch { }
    if ($currentMode -ne "chatgpt") {
        Write-Warning "auth_mode is '$currentMode', fixing to chatgpt..."
        @{ auth_mode = "chatgpt"; OPENAI_API_KEY = $null } | ConvertTo-Json | Set-Content $authPath -Encoding UTF8
    }
    Copy-Item $authPath (Join-Path $backupDir "auth.json.bak") -Force
    return $true
}

function Migrate-Sessions {
    if (-not (Test-Path $stateDbPath)) { return }
    $sqliteExe = Get-Command sqlite3 -ErrorAction SilentlyContinue
    if (-not $sqliteExe) {
        Write-Warning "sqlite3 not found, skipping session migration"
        return
    }
    $result = & sqlite3 $stateDbPath "UPDATE threads SET model_provider = '$UNIFIED' WHERE model_provider != '$UNIFIED'; SELECT changes();" 2>$null
    $null = & sqlite3 $stateDbPath "PRAGMA wal_checkpoint(TRUNCATE);" 2>$null
    if ($result -and $result -ne "0") {
        Write-Host "  Migrated $result sessions" -ForegroundColor Cyan
    }
}

function Switch-Target {
    param([string]$target)

    if ($target -notin @("cc_switch", "cockpit")) {
        Write-Error "Use 'cc' or 'cockpit'"
        return
    }
    if (-not (Protect-AuthJson)) {
        Write-Error "auth.json is unhealthy, aborting."
        return
    }

    $ts = Get-Date -Format "yyyyMMdd-HHmmss"
    if (Test-Path $configPath) {
        Copy-Item $configPath (Join-Path $backupDir "config.toml.$ts.bak") -Force
    }

    if ($target -eq "cc_switch") {
        $toolName = "CC Switch"
        $port = "16897"
    }
    else {
        $toolName = "Cockpit Tools"
        $port = "42805"
    }

    # Check if target port is listening
    $listening = netstat -ano 2>$null | Select-String "127\.0\.0\.1:$port.*LISTENING"
    if (-not $listening) {
        if ($target -eq "cockpit") {
            Write-Host ""
            Write-Host "=============================================" -ForegroundColor Red
            Write-Host "  Cockpit Tools API NOT running on port 42805" -ForegroundColor Red
            Write-Host "=============================================" -ForegroundColor Red
            Write-Host ""
            Write-Host "  Workflow:" -ForegroundColor Yellow
            Write-Host "  1. In Cockpit Tools, click [Start API Service]" -ForegroundColor White
            Write-Host "     (This starts port 42805 but also restarts Codex)" -ForegroundColor Gray
            Write-Host "  2. Run this script AGAIN:" -ForegroundColor White
            Write-Host "     .\switch-codex.ps1 cockpit" -ForegroundColor Cyan
            Write-Host "  3. Restart Codex one final time" -ForegroundColor White
            Write-Host ""
            Write-Host "  (The guardian auto-protects your config during step 1)" -ForegroundColor Gray
            Write-Host ""
        }
        else {
            Write-Warning "WARNING: Port $port is NOT listening! CC Switch may not be running."
            Write-Warning "Start CC Switch first, or Codex will show a white screen."
        }
    }

    # Write config.toml with dynamic user profile path
    $escapedSourcePath = "\\\\?\\" + $codexDir + "\\.tmp\\bundled-marketplaces\\openai-bundled"
    $escapedSourcePath = $escapedSourcePath.Replace("\", "\\")
    $escapedProjectPath = $userProfile.Replace("\", "\\")

    $config = @"
model_provider = "$UNIFIED"
model = "gpt-5.5"
model_reasoning_effort = "medium"

[mcp_servers]

[mcp_servers.context7]
type = "stdio"
command = "context7-mcp"

[mcp_servers.playwright]
type = "stdio"
command = "playwright-mcp"
args = ["--headless"]

[windows]
sandbox = "elevated"

[model_providers]

[model_providers.$UNIFIED]
name = "$toolName"
base_url = "http://127.0.0.1:$port/v1"
wire_api = "responses"
requires_openai_auth = true

[marketplaces.openai-bundled]
last_updated = "2026-05-25T10:17:22Z"
source_type = "local"
source = '$escapedSourcePath'

[plugins."browser-use@openai-bundled"]
enabled = true

[projects.'$escapedProjectPath']
trust_level = "trusted"
"@

    Set-Content -Path $configPath -Value $config -Encoding UTF8
    Migrate-Sessions

    # Update guardian golden backup if it exists
    $goldenDir = Join-Path $codexDir "guardian-golden"
    if (Test-Path $goldenDir) {
        Copy-Item $configPath (Join-Path $goldenDir "config.toml.golden") -Force -ErrorAction SilentlyContinue
        if (Test-Path $authPath) { Copy-Item $authPath (Join-Path $goldenDir "auth.json.golden") -Force -ErrorAction SilentlyContinue }
    }

    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "  Active tool : $toolName (port $port)" -ForegroundColor Green
    Write-Host "  Provider    : $UNIFIED (native, sessions persist)" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Restart Codex to apply." -ForegroundColor Yellow
}

# ====== Main ======
$action = $args[0]
switch ($action) {
    "cc" { Switch-Target "cc_switch" }
    "cockpit" { Switch-Target "cockpit" }
    "migrate" {
        Write-Host "Migrating all sessions to unified provider: $UNIFIED"
        Migrate-Sessions
        Write-Host "Done." -ForegroundColor Green
    }
    "status" {
        $target = Get-CurrentTarget
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Cyan
        Write-Host "  Codex Switch Tool v3 — Status" -ForegroundColor Cyan
        Write-Host "=============================================" -ForegroundColor Cyan
        if ($target -eq "cc_switch") { Write-Host "  Tool  : CC Switch (port 16897)" -ForegroundColor Yellow }
        elseif ($target -eq "cockpit") { Write-Host "  Tool  : Cockpit Tools (port 42805)" -ForegroundColor Yellow }
        else { Write-Host "  Tool  : unknown" -ForegroundColor Red }

        $config = Get-Content $configPath -Raw -ErrorAction SilentlyContinue
        if ($config -and $config.Contains($UNIFIED)) {
            Write-Host "  Config: provider = $UNIFIED" -ForegroundColor Green
        }
        else { Write-Host "  Config: provider mismatch!" -ForegroundColor Red }

        if (Test-Path $authPath) {
            $auth = Get-Content $authPath -Raw | ConvertFrom-Json
            if ($auth.tokens -and $auth.auth_mode -eq "chatgpt") {
                Write-Host "  Auth  : ChatGPT logged in" -ForegroundColor Green
            }
            elseif ($auth.auth_mode -eq "apikey") {
                Write-Host "  Auth  : API key mode (NOT logged in!)" -ForegroundColor Red
            }
            else { Write-Host "  Auth  : not logged in" -ForegroundColor Yellow }
        }

        $guardianTask = Get-ScheduledTask -TaskName "CodexConfigGuardian" -ErrorAction SilentlyContinue
        if ($guardianTask -and $guardianTask.State -eq "Running") {
            Write-Host "  Guard : running" -ForegroundColor Green
        }
        else { Write-Host "  Guard : NOT running" -ForegroundColor Red }

        Write-Host ""
        Write-Host "Commands:" -ForegroundColor Cyan
        Write-Host "  .\switch-codex.ps1 cc       → CC Switch (16897)" -ForegroundColor White
        Write-Host "  .\switch-codex.ps1 cockpit  → Cockpit Tools (42805)" -ForegroundColor White
        Write-Host "  .\switch-codex.ps1 migrate  → Migrate sessions" -ForegroundColor White
        Write-Host "  .\switch-codex.ps1 status   → This view" -ForegroundColor White
        Write-Host ""
        Write-Host "Important:" -ForegroundColor Yellow
        Write-Host "  - CC Switch providers: switch inside CC Switch UI (does not touch config)" -ForegroundColor White
        Write-Host "  - CC Switch <-> Cockpit: use this script" -ForegroundColor White
        Write-Host "  - NEVER use CC Switch's 'Take over Codex' feature" -ForegroundColor White
        Write-Host "  - Restart Codex after switching" -ForegroundColor White
        Write-Host ""
    }
    default {
        Write-Host "Usage: .\switch-codex.ps1 [cc|cockpit|migrate|status]" -ForegroundColor Cyan
        $target = Get-CurrentTarget
        if ($target -eq "cc_switch") { Write-Host "Current: CC Switch (16897)" -ForegroundColor Yellow }
        elseif ($target -eq "cockpit") { Write-Host "Current: Cockpit Tools (42805)" -ForegroundColor Yellow }
    }
}
