# ============================================================================
# Codex Config Guardian v3 — polling mode
# GitHub: https://github.com/YOUR_USERNAME/codex-tool-switcher
#
# 后台守护进程，监控 auth.json 和 config.toml
# 检测到被 CC Switch / Cockpit Tools 覆盖时自动恢复
# 每 5 秒轮询 MD5 哈希，比 FileSystemWatcher 更可靠
#
# 用法:
#   安装:  .\guard-codex-config.ps1 -Install
#   卸载:  .\guard-codex-config.ps1 -Uninstall
# ============================================================================

param([switch]$Install, [switch]$Uninstall)

$codexDir = "$env:USERPROFILE\.codex"
$authPath = Join-Path $codexDir "auth.json"
$configPath = Join-Path $codexDir "config.toml"
$goldenDir = Join-Path $codexDir "guardian-golden"
$logFile = Join-Path $codexDir "guardian-logs\guardian.log"
$safeAuth = Join-Path $codexDir "auth-backups\auth.json.PERMANENT"
$taskName = "CodexConfigGuardian"
$scriptPath = Join-Path $codexDir "guard-codex-config.ps1"

if ($Install) {
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
    Write-Host "Guardian v3 installed. Starting..."
    Start-ScheduledTask -TaskName $taskName
    return
}

if ($Uninstall) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "Guardian uninstalled."
    return
}

# ====== Runtime (runs as scheduled task) ======

$null = New-Item -ItemType Directory -Path $goldenDir -Force
$null = New-Item -ItemType Directory -Path (Split-Path $logFile -Parent) -Force
$null = New-Item -ItemType Directory -Path (Split-Path $safeAuth -Parent) -Force

function Write-Log($msg) {
    "$(Get-Date -Format 'HH:mm:ss') $msg" | Add-Content -Path $logFile
}

function Test-AuthHealthy {
    if (-not (Test-Path $authPath)) { return $false }
    try {
        $auth = Get-Content $authPath -Raw | ConvertFrom-Json
        return ($auth.auth_mode -eq "chatgpt" -and $null -ne $auth.tokens)
    }
    catch { return $false }
}

function Test-ConfigHealthy {
    if (-not (Test-Path $configPath)) { return $false }
    $config = Get-Content $configPath -Raw
    return ($config.Contains('codex_local_access'))
}

function Save-Golden {
    if (Test-AuthHealthy) {
        Copy-Item $authPath (Join-Path $goldenDir "auth.json.golden") -Force
    }
    if (Test-ConfigHealthy) {
        Copy-Item $configPath (Join-Path $goldenDir "config.toml.golden") -Force
    }
}

function Restore-Auth {
    # Multi-layer fallback: golden -> PERMANENT -> SAFE
    $sources = @(
        (Join-Path $goldenDir "auth.json.golden"),
        $safeAuth,
        (Join-Path $codexDir "auth.json.SAFE")
    )
    foreach ($src in $sources) {
        if (Test-Path $src) {
            try {
                $test = Get-Content $src -Raw | ConvertFrom-Json
                if ($test.auth_mode -eq "chatgpt" -and $null -ne $test.tokens) {
                    Copy-Item $src $authPath -Force
                    Write-Log "RESTORED auth.json from $(Split-Path $src -Leaf)"
                    return $true
                }
            }
            catch { }
        }
    }
    Write-Log "FATAL: No valid auth backup found!"
    return $false
}

function Restore-Config {
    $golden = Join-Path $goldenDir "config.toml.golden"
    if (Test-Path $golden) {
        Copy-Item $golden $configPath -Force
        Write-Log "RESTORED config.toml"
        return $true
    }
    return $false
}

Write-Log "===== Guardian v3 started ====="

# Initial health check and restore
if (-not (Test-AuthHealthy)) {
    Write-Log "auth.json unhealthy on start, restoring..."
    Restore-Auth
}
if (-not (Test-ConfigHealthy)) {
    Write-Log "config.toml unhealthy on start, restoring..."
    Restore-Config
}

Save-Golden
Write-Log "Startup: auth=$(Test-AuthHealthy) config=$(Test-ConfigHealthy)"

# Track file state via MD5 hashes
$lastAuthHash = (Get-FileHash $authPath -Algorithm MD5).Hash
$lastConfigHash = (Get-FileHash $configPath -Algorithm MD5).Hash

$restoreCount = @{ auth = 0; config = 0 }

# Main polling loop — checks every 5 seconds
while ($true) {
    Start-Sleep -Seconds 5

    # Check auth.json
    if (Test-Path $authPath) {
        $currentHash = (Get-FileHash $authPath -Algorithm MD5).Hash
        if ($currentHash -ne $lastAuthHash) {
            $lastAuthHash = $currentHash
            if (-not (Test-AuthHealthy)) {
                Write-Log "auth.json changed to UNHEALTHY! Restoring..."
                if (Restore-Auth) {
                    $restoreCount.auth++
                    $lastAuthHash = (Get-FileHash $authPath -Algorithm MD5).Hash
                }
            }
            else {
                Save-Golden
            }
        }
    }
    else {
        Write-Log "auth.json deleted! Restoring..."
        Restore-Auth
        $restoreCount.auth++
        $lastAuthHash = (Get-FileHash $authPath -Algorithm MD5 -ErrorAction SilentlyContinue).Hash
    }

    # Check config.toml
    if (Test-Path $configPath) {
        $currentHash = (Get-FileHash $configPath -Algorithm MD5).Hash
        if ($currentHash -ne $lastConfigHash) {
            $lastConfigHash = $currentHash
            if (-not (Test-ConfigHealthy)) {
                Write-Log "config.toml changed to UNHEALTHY! Restoring..."
                if (Restore-Config) {
                    $restoreCount.config++
                    $lastConfigHash = (Get-FileHash $configPath -Algorithm MD5).Hash
                }
            }
            else {
                Save-Golden
            }
        }
    }

    # Hourly status summary
    if ((Get-Date).Minute -eq 0 -and (Get-Date).Second -lt 10) {
        Write-Log "Hourly: auth=$(Test-AuthHealthy) config=$(Test-ConfigHealthy) restores: auth=$($restoreCount.auth) config=$($restoreCount.config)"
    }
}
