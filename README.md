# Codex Tool Switcher

**在 CC Switch 和 Cockpit Tools 之间自由切换 Codex 接口，同时保持 ChatGPT 账号登录、保留全部历史会话。**

**🎁 ChatGPT Free 账号可用插件 + 手机远程控制桌面 Codex**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue)

---

## 亮点

### ChatGPT Free（免费）账号解锁完整功能

Codex 官方限制 ChatGPT Free 账号无法使用**插件**和**手机远程控制桌面**功能——因为这些要求 Codex 以 ChatGPT OAuth 方式登录，而非 API Key 方式。

本项目通过 `auth_mode = "chatgpt"` + 统一 provider 架构，让 Free 账号也能：

- ✅ **使用插件**（Browser Use 等）
- ✅ **手机端 Codex 远程控制电脑端 Codex**（与 [codex-ccswitch-mobile](https://github.com/kuangre123/codex-ccswitch-mobile) 配合）
- ✅ **会话历史永久可见**
- ✅ **模型请求走本地代理**（CC Switch / Cockpit Tools），不消耗 OpenAI 配额

**原理**：Auth 层用 ChatGPT OAuth 登录（满足插件和手机远程控制的身份验证要求），Model 层走本地代理（实际 AI 调用由 CC Switch 或 Cockpit Tools 转发到第三方 API）。两层互不干扰。

---

## 一、解决的问题

使用 [Codex](https://github.com/openai/codex) + [CC Switch](https://github.com/farion1231/cc-switch) + [Cockpit Tools](https://github.com/jlcodes99/cockpit-tools) 的开发者面临以下痛点：

| 痛点 | 现象 | 根因 |
|------|------|------|
| 切换工具后 ChatGPT 登录消失 | Codex 变成 API Key 模式 | CC Switch "接管"功能和 Cockpit Tools "启动API服务"会覆盖 `auth.json` |
| 历史对话全部不见 | 切换工具后 Codex 历史为空 | 不同工具的 `model_provider` 名称不同，Codex 按此字段过滤会话 |
| Codex 启动白屏 | 界面卡死或全白 | 配置了不存在的端口或不被支持的参数 |
| 反复登录被踢 | ChatGPT 令牌被覆盖后需重新登录 | 无自动恢复机制 |

### 本项目提供的三层防护

```
┌──────────────────────────────────────────────┐
│  切换层: switch-codex.ps1                     │
│  → 一键切换 CC Switch ↔ Cockpit Tools        │
│  → 自动迁移会话到统一 provider               │
│  → 修复 auth.json 为 ChatGPT 模式            │
│  → 自动更新守护进程金备份                    │
├──────────────────────────────────────────────┤
│  保护层: guard-codex-config.ps1               │
│  → Windows 任务计划程序自启动                 │
│  → 每 5 秒轮询检测 auth.json + config.toml   │
│  → 检测到被覆盖 → 秒级自动恢复               │
│  → 多层备份链: 金备份 → 永久备份 → 安全备份  │
├──────────────────────────────────────────────┤
│  数据层: 统一 provider 名称                   │
│  → 使用 codex_local_access (Codex 原生保留名) │
│  → CC Switch 和 Cockpit Tools 共用同一名称    │
│  → 切换只改 base_url 端口，不动 provider     │
│  → 所有会话永久可见，不受切换影响             │
└──────────────────────────────────────────────┘
```

---

## 二、安装

### 前提条件

- Windows 10/11
- [PowerShell 5.1+](https://aka.ms/powershell) (系统自带)
- [sqlite3](https://www.sqlite.org/download.html) (需在 PATH 中可用)
- 已安装 [Codex Desktop](https://github.com/openai/codex)
- 已安装 [CC Switch](https://github.com/farion1231/cc-switch) 和/或 [Cockpit Tools](https://github.com/jlcodes99/cockpit-tools)

### 一键安装

```powershell
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/codex-tool-switcher.git
cd codex-tool-switcher

# 运行安装脚本
.\install.ps1
```

安装脚本会：
1. 将 `switch-codex.ps1` 和 `guard-codex-config.ps1` 复制到 `~/.codex/`
2. 将 `guard-codex-config.ps1` 注册为 Windows 登录自启动任务
3. 执行一次性会话迁移（将所有历史会话迁移到统一 provider）
4. 创建初始金备份

### 手动安装

```powershell
Copy-Item .\switch-codex.ps1 "$env:USERPROFILE\.codex\switch-codex.ps1"
Copy-Item .\guard-codex-config.ps1 "$env:USERPROFILE\.codex\guard-codex-config.ps1"
& "$env:USERPROFILE\.codex\guard-codex-config.ps1" -Install
```

---

## 三、使用

### 日常切换

```powershell
# 切换到 CC Switch（端口 16897）
& "$env:USERPROFILE\.codex\switch-codex.ps1" cc

# 切换到 Cockpit Tools（端口 42805）
& "$env:USERPROFILE\.codex\switch-codex.ps1" cockpit

# 查看当前状态
& "$env:USERPROFILE\.codex\switch-codex.ps1" status

# 迁移旧会话到统一 provider（通常不需要手动执行）
& "$env:USERPROFILE\.codex\switch-codex.ps1" migrate
```

每次切换后**重启 Codex** 生效。

### CC Switch 内部切换供应商

在 CC Switch 的 GUI 界面上直接切换供应商，**不会影响 Codex 的配置文件**。这是两个独立的层级：

| 层级 | 操作 | 影响范围 |
|------|------|---------|
| CC Switch 供应商 | 在 CC Switch 界面切换 | 仅 CC Switch 内部转发目标 |
| Codex 接口工具 | 用 `switch-codex.ps1` 切换 | Codex 的 `config.toml` |

### Cockpit Tools 特殊流程

Cockpit Tools 的「启动API服务」按钮会强制重启 Codex 并覆盖 `auth.json`。正确操作顺序：

```
1. 在 Cockpit Tools 界面点击「启动API服务」
   → 端口 42805 启动，Codex 被重启，auth.json 可能被覆盖
   → 守护进程会在 5 秒内自动恢复 auth.json

2. 运行: switch-codex.ps1 cockpit
   → 确保 config.toml 正确指向 Cockpit Tools

3. 重启 Codex
   → ChatGPT 已登录 + 接口走 Cockpit Tools
```

---

## 四、核心原理

### 4.1 为什么切换工具后历史对话会消失

Codex 将所有会话元数据存储在 `~/.codex/state_5.sqlite` 的 `threads` 表中：

```sql
CREATE TABLE threads (
    id TEXT PRIMARY KEY,
    model_provider TEXT NOT NULL,  -- ★ 关键字段
    ...
);
```

Codex 启动时，**只显示 `model_provider` 与当前配置匹配的会话**。如果 CC Switch 配置的 provider 名是 `"cc_switch"`，Cockpit Tools 配置的是 `"codex_local_access"`，那么切换到另一个工具后，之前的所有会话就「消失」了。

### 4.2 解决方案：统一 provider 名称

我们使用 `codex_local_access` 作为统一的 provider 名称——这是 Cockpit Tools 原生支持的保留名，Codex 可以正确处理其会话可见性。

CC Switch 和 Cockpit Tools 共用同一个 provider 名，切换时只改 `base_url` 端口：

```toml
# 使用 CC Switch 时:
model_provider = "codex_local_access"
[model_providers.codex_local_access]
base_url = "http://127.0.0.1:16897/v1"    # ← CC Switch 端口

# 切换为 Cockpit Tools 时:
model_provider = "codex_local_access"       # ← provider 名不变!
[model_providers.codex_local_access]
base_url = "http://127.0.0.1:42805/v1"    # ← 只改这里
```

每次切换时，脚本会自动执行 SQL 迁移：

```sql
UPDATE threads SET model_provider = 'codex_local_access'
WHERE model_provider != 'codex_local_access';
```

### 4.3 为什么 ChatGPT 登录会被"踢掉"

三个工具会覆盖 Codex 配置文件：

- **CC Switch "接管 Codex"**: 修改 `config.toml`，删除 `auth.json`
- **Cockpit Tools "启动API服务"**: 写入 API Key 到 `auth.json`，删除 ChatGPT 令牌
- **`.cockpit_codex_auth.json` 标记**: 使 Codex 在 `codex_local_access` 下强制使用 API Key 模式

守护进程通过 MD5 哈希变化检测这些覆盖，并从多层备份中自动恢复。

### 4.4 踩过的坑

| 坑 | 现象 | 原因 | 解决方案 |
|----|------|------|---------|
| `preferred_auth_method = "chatgpt"` | Codex 白屏 | 不被当前版本 Codex 支持 | 不使用此参数 |
| 自创 provider 名 `local_proxy` | 会话不显示 | Codex 不识别自定义名 | 使用 `codex_local_access` |
| `.cockpit_codex_auth.json` 标记 | 强制切到 API Key 模式 | Cockpit Tools 标记触发 | 重命名禁用 |
| auth.json 只读 | Codex 启动白屏 | Codex 启动需写入令牌 | 保持可写，用守护进程恢复 |
| FileSystemWatcher 事件丢失 | 守护进程漏恢复 | 事件机制不可靠 | 改用 5 秒轮询 MD5 哈希 |

---

## 五、文件结构

```
codex-tool-switcher/
├── README.md                # 本文件
├── LICENSE                  # MIT License
├── install.ps1              # 一键安装脚本
├── switch-codex.ps1         # CC Switch ↔ Cockpit Tools 切换脚本
├── guard-codex-config.ps1   # 配置守护进程 (v3, 轮询模式)
└── .gitignore
```

安装后 `~/.codex/` 下会增加：

```
~/.codex/
├── switch-codex.ps1              # 切换脚本
├── guard-codex-config.ps1        # 守护进程
├── guardian-golden/              # 金备份目录
│   ├── auth.json.golden
│   └── config.toml.golden
├── auth-backups/                 # 多层备份
│   ├── auth.json.PERMANENT       # 永久只读备份
│   └── auth.json.YYYYMMDD-HHmmss.bak
├── guardian-logs/
│   └── guardian.log
└── switch-backups/
    └── config.toml.YYYYMMDD-HHmmss.bak
```

---

## 六、守护进程管理

```powershell
# 安装自启动
& "$env:USERPROFILE\.codex\guard-codex-config.ps1" -Install

# 卸载
& "$env:USERPROFILE\.codex\guard-codex-config.ps1" -Uninstall

# 查看日志
Get-Content "$env:USERPROFILE\.codex\guardian-logs\guardian.log" -Tail 20

# 通过 Windows 任务计划程序管理
taskschd.msc  # 查找 "CodexConfigGuardian" 任务
```

---

## 七、故障恢复

### Codex 白屏

1. 检查目标端口是否在监听：`netstat -ano | Select-String "16897|42805"`
2. 确保 `auth.json` 存在且 `auth_mode = "chatgpt"`
3. 确保 `auth.json` **不是**只读状态
4. 杀掉 Codex 进程后重启

### ChatGPT 登录丢失

守护进程会自动恢复。如果没恢复：

```powershell
# 手动从备份恢复
Copy-Item "$env:USERPROFILE\.codex\auth-backups\auth.json.PERMANENT" `
          "$env:USERPROFILE\.codex\auth.json" -Force
# 重启 Codex
```

### 会话历史不显示

```powershell
# 手动执行会话迁移
sqlite3 "$env:USERPROFILE\.codex\state_5.sqlite" `
  "UPDATE threads SET model_provider = 'codex_local_access' WHERE model_provider != 'codex_local_access';"
# 重启 Codex
```

---

## 八、环境要求

| 组件 | 最低版本 | 用途 |
|------|---------|------|
| Windows | 10/11 | 操作系统 |
| PowerShell | 5.1 | 脚本运行环境 |
| sqlite3 CLI | 3.x | 会话数据库迁移 |
| Codex Desktop | 26.x | AI 编程工具 |
| CC Switch | 最新版 | 本地 API 代理 (端口 16897) |
| Cockpit Tools | 0.24.x | 本地 API 代理 (端口 42805) |

---

## 九、License

MIT — 详见 [LICENSE](LICENSE)

## 十、致谢

- [CC Switch](https://github.com/farion1231/cc-switch) — 本地 AI 代理切换工具
- [Cockpit Tools](https://github.com/jlcodes99/cockpit-tools) — AI 驾驶舱工具套件
- [Codex](https://github.com/openai/codex) — OpenAI 的 AI 编程终端
- [codex-ccswitch-mobile](https://github.com/kuangre123/codex-ccswitch-mobile) — Codex 手机远程控制 Skill
