# DeepSeek Proxy switch — standalone, NEVER touches auth.json
$codexDir = "$env:USERPROFILE\.codex"
$config = @'
model_provider = "codex_local_access"
model = "deepseek-v4-pro"
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
[model_providers.codex_local_access]
name = "DeepSeek Proxy"
base_url = "http://127.0.0.1:5000/v1"
wire_api = "responses"
requires_openai_auth = false

[marketplaces.openai-bundled]
last_updated = "2026-05-25T10:17:22Z"
source_type = "local"
source = '\\?\C:\Users\18389\.codex\.tmp\bundled-marketplaces\openai-bundled'
[plugins."browser-use@openai-bundled"]
enabled = true
[projects.'c:\users\18389']
trust_level = "trusted"
'@
Set-Content (Join-Path $codexDir "config.toml") -Value $config -Encoding UTF8

# Ensure proxy is running
if (-not (netstat -ano 2>$null | Select-String "5000.*LISTEN")) {
    Start-ScheduledTask -TaskName "CodexDeepSeekProxy" -ErrorAction SilentlyContinue
    Start-Sleep 3
}

Write-Host "DeepSeek Proxy ready. Restart Codex." -ForegroundColor Green
