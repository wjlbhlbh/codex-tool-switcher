# CC Switch relay switch — standalone, NEVER touches auth.json
$codexDir = "$env:USERPROFILE\.codex"
$config = @'
model_provider = "codex_local_access"
model = "gpt-5.5"
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
name = "CC Switch"
base_url = "http://127.0.0.1:16897/v1"
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

Write-Host "CC Switch relay ready. Restart Codex." -ForegroundColor Green
