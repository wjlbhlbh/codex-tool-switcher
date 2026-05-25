# ============================================================================
# Codex Tool Switcher v4 - Three-way switching
# GitHub: https://github.com/wjlbhlbh/codex-tool-switcher
#
# Usage:
#   .\switch-codex.ps1 deepseek  -> DeepSeek API (via codex_proxy:5000)
#   .\switch-codex.ps1 cc         -> CC Switch relay (port 16897)
#   .\switch-codex.ps1 cockpit    -> Cockpit Tools (port 42805)
#   .\switch-codex.ps1 status     -> View current state
# ============================================================================

$codexDir = "$env:USERPROFILE\.codex"
$configPath = Join-Path $codexDir "config.toml"
$authPath = Join-Path $codexDir "auth.json"
$stateDbPath = Join-Path $codexDir "state_5.sqlite"
$backupDir = Join-Path $codexDir "switch-backups"
$UNIFIED = "codex_local_access"

$null = New-Item -ItemType Directory -Path $backupDir -Force

$targets = @{
    "deepseek" = @{ Name = "DeepSeek Proxy"; Port = "5000"; Model = "deepseek-v4-pro"; Desc = "DeepSeek V4 Pro (official API)" }
    "cc"       = @{ Name = "CC Switch Relay"; Port = "16897"; Model = "gpt-5.5"; Desc = "CC Switch relay (zz1cc.cc.cd etc)" }
    "cockpit"  = @{ Name = "Cockpit Tools"; Port = "42805"; Model = "gpt-5.5"; Desc = "Cockpit Tools pool" }
}

$validTargets = ($targets.Keys -join ", ")

function Get-CurrentTarget {
    if (-not (Test-Path $configPath)) { return "unknown" }
    $config = Get-Content $configPath -Raw
    foreach ($key in $targets.Keys) {
        $port = $targets[$key].Port
        if ($config.Contains("127.0.0.1:$port")) { return $key }
    }
    return "unknown"
}

function Protect-AuthJson {
    if (-not (Test-Path $authPath)) { Write-Warning "auth.json missing!"; return $false }
    try { $auth = Get-Content $authPath -Raw | ConvertFrom-Json }
    catch { Write-Warning "auth.json corrupted, recreating..."; @{ auth_mode = "chatgpt"; OPENAI_API_KEY = $null } | ConvertTo-Json | Set-Content $authPath -Encoding UTF8; return $true }
    $currentMode = $null
    try { $currentMode = $auth.auth_mode } catch { }
    if ($currentMode -ne "chatgpt") {
        Write-Warning "auth_mode is '$currentMode', fixing..."
        @{ auth_mode = "chatgpt"; OPENAI_API_KEY = $null } | ConvertTo-Json | Set-Content $authPath -Encoding UTF8
    }
    Copy-Item $authPath (Join-Path $backupDir "auth.json.bak") -Force
    return $true
}

function Migrate-Sessions {
    if (-not (Test-Path $stateDbPath)) { return }
    $sqliteExe = Get-Command sqlite3 -ErrorAction SilentlyContinue
    if (-not $sqliteExe) { return }
    $result = & sqlite3 $stateDbPath "UPDATE threads SET model_provider = '$UNIFIED' WHERE model_provider != '$UNIFIED'; SELECT changes();" 2>$null
    $null = & sqlite3 $stateDbPath "PRAGMA wal_checkpoint(TRUNCATE);" 2>$null
    if ($result -and $result -ne "0") { Write-Host "  Migrated $result sessions" -ForegroundColor Cyan }
}

function Switch-Target {
    param([string]$targetKey)
    if ($targetKey -notin $targets.Keys) { Write-Error "Use: $validTargets"; return }
    if (-not (Protect-AuthJson)) { Write-Error "auth.json unhealthy, aborting."; return }
    $target = $targets[$targetKey]
    $ts = Get-Date -Format "yyyyMMdd-HHmmss"
    if (Test-Path $configPath) { Copy-Item $configPath (Join-Path $backupDir "config.toml.$ts.bak") -Force }
    $port = $target.Port

    $listening = netstat -ano 2>$null | Select-String "127\.0\.0\.1:$port.*LISTENING"
    if (-not $listening) {
        if ($targetKey -eq "deepseek") { Write-Warning "DeepSeek Proxy NOT running on 5000! Run: Start-ScheduledTask -TaskName CodexDeepSeekProxy" }
        elseif ($targetKey -eq "cockpit") { Write-Host ""; Write-Host "Cockpit Tools not running! Click [Start API Service] first, then re-run this script." -ForegroundColor Red; Write-Host "" }
        else { Write-Warning "Port $port not listening! Start CC Switch first." }
    }

    $escSrc = "\\\\\\\\?\\\\" + ($codexDir -replace '\\','\\\\') + "\\\\.tmp\\\\bundled-marketplaces\\\\openai-bundled"
    $escPrj = ($env:USERPROFILE.ToLower() -replace '\\','\\\\')

    $config = @"
model_provider = "$UNIFIED"
model = "$($target.Model)"
model_reasoning_effort = "high"

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
name = "$($target.Name)"
base_url = "http://127.0.0.1:$port/v1"
wire_api = "responses"
requires_openai_auth = false

[marketplaces.openai-bundled]
last_updated = "2026-05-25T10:17:22Z"
source_type = "local"
source = '$escSrc'

[plugins."browser-use@openai-bundled"]
enabled = true

[projects.'$escPrj']
trust_level = "trusted"
"@

    Set-Content -Path $configPath -Value $config -Encoding UTF8
    Migrate-Sessions
    $goldenDir = Join-Path $codexDir "guardian-golden"
    if (Test-Path $goldenDir) {
        Copy-Item $configPath (Join-Path $goldenDir "config.toml.golden") -Force -ErrorAction SilentlyContinue
        if (Test-Path $authPath) { Copy-Item $authPath (Join-Path $goldenDir "auth.json.golden") -Force -ErrorAction SilentlyContinue }
    }
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "  Active : $($target.Desc)" -ForegroundColor Green
    Write-Host "  Port   : $port   Model: $($target.Model)" -ForegroundColor Green
    Write-Host "  Session: $UNIFIED (persistent)" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Restart Codex to apply." -ForegroundColor Yellow
}

# ====== Main ======
$action = $args[0]
if ($action -and $action -in $targets.Keys) { Switch-Target $action }
elseif ($action -eq "status") {
    $current = Get-CurrentTarget
    Write-Host ""; Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "  Codex Switch Tool v4" -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan
    if ($current -ne "unknown") { $t = $targets[$current]; Write-Host "  Active : $($t.Desc) (port $($t.Port), model $($t.Model))" -ForegroundColor Yellow }
    else { Write-Host "  Active : unknown" -ForegroundColor Red }
    $config = Get-Content $configPath -Raw -ErrorAction SilentlyContinue
    if ($config -and $config.Contains($UNIFIED)) { Write-Host "  Provider: $UNIFIED" -ForegroundColor Green } else { Write-Host "  Provider: mismatch!" -ForegroundColor Red }
    if (Test-Path $authPath) {
        $auth = Get-Content $authPath -Raw | ConvertFrom-Json
        if ($auth.tokens -and $auth.auth_mode -eq "chatgpt") { Write-Host "  Auth   : ChatGPT logged in" -ForegroundColor Green }
        elseif ($auth.auth_mode -eq "apikey") { Write-Host "  Auth   : API key mode" -ForegroundColor Red }
        else { Write-Host "  Auth   : not logged in" -ForegroundColor Yellow }
        if ($auth.OPENAI_API_KEY) { Write-Host "  API Key: SET (rogue key risk!)" -ForegroundColor Red } else { Write-Host "  API Key: null" -ForegroundColor Green }
    }
    $guardian = Get-ScheduledTask -TaskName "CodexConfigGuardian" -ErrorAction SilentlyContinue
    $proxy = netstat -ano 2>$null | Select-String "5000.*LISTEN"
    Write-Host "  Guardian: $(if($guardian -and $guardian.State -eq 'Running'){'running'}else{'NOT running'})"
    Write-Host "  Proxy   : $(if($proxy){'running (5000)'}else{'NOT running'})"
    Write-Host ""; Write-Host "Commands:" -ForegroundColor Cyan
    Write-Host "  .\switch-codex.ps1 deepseek  -> $($targets['deepseek'].Desc)" -ForegroundColor White
    Write-Host "  .\switch-codex.ps1 cc        -> $($targets['cc'].Desc)" -ForegroundColor White
    Write-Host "  .\switch-codex.ps1 cockpit   -> $($targets['cockpit'].Desc)" -ForegroundColor White
    Write-Host "  .\switch-codex.ps1 status    -> This view" -ForegroundColor White; Write-Host ""
}
else {
    Write-Host "Usage: .\switch-codex.ps1 [$validTargets|status]" -ForegroundColor Cyan
    $current = Get-CurrentTarget
    if ($current -ne "unknown") { Write-Host "Current: $($targets[$current].Desc)" -ForegroundColor Yellow }
}
