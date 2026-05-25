# Codex Tool Switcher

**鍦?CC Switch 鍜?Cockpit Tools 涔嬮棿鑷敱鍒囨崲 Codex 鎺ュ彛锛屽悓鏃朵繚鎸?ChatGPT 璐﹀彿鐧诲綍銆佷繚鐣欏叏閮ㄥ巻鍙蹭細璇濄€?*

**馃巵 ChatGPT Free 璐﹀彿鍙敤鎻掍欢 + 鎵嬫満杩滅▼鎺у埗妗岄潰 Codex**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue)

---

## 浜偣

### ChatGPT Free锛堝厤璐癸級璐﹀彿瑙ｉ攣瀹屾暣鍔熻兘

Codex 瀹樻柟闄愬埗 ChatGPT Free 璐﹀彿鏃犳硶浣跨敤**鎻掍欢**鍜?*鎵嬫満杩滅▼鎺у埗妗岄潰**鍔熻兘鈥斺€斿洜涓鸿繖浜涜姹?Codex 浠?ChatGPT OAuth 鏂瑰紡鐧诲綍锛岃€岄潪 API Key 鏂瑰紡銆?
鏈」鐩€氳繃 `auth_mode = "chatgpt"` + 缁熶竴 provider 鏋舵瀯锛岃 Free 璐﹀彿涔熻兘锛?
- 鉁?**浣跨敤鎻掍欢**锛圔rowser Use 绛夛級
- 鉁?**鎵嬫満绔?Codex 杩滅▼鎺у埗鐢佃剳绔?Codex**锛堜笌 [codex-ccswitch-mobile](https://github.com/kuangre123/codex-ccswitch-mobile) 閰嶅悎锛?- 鉁?**浼氳瘽鍘嗗彶姘镐箙鍙**
- 鉁?**妯″瀷璇锋眰璧版湰鍦颁唬鐞?*锛圕C Switch / Cockpit Tools锛夛紝涓嶆秷鑰?OpenAI 閰嶉

**鍘熺悊**锛欰uth 灞傜敤 ChatGPT OAuth 鐧诲綍锛堟弧瓒虫彃浠跺拰鎵嬫満杩滅▼鎺у埗鐨勮韩浠介獙璇佽姹傦級锛孧odel 灞傝蛋鏈湴浠ｇ悊锛堝疄闄?AI 璋冪敤鐢?CC Switch 鎴?Cockpit Tools 杞彂鍒扮涓夋柟 API锛夈€備袱灞備簰涓嶅共鎵般€?
---

## 涓€銆佽В鍐崇殑闂

浣跨敤 [Codex](https://github.com/openai/codex) + [CC Switch](https://github.com/farion1231/cc-switch) + [Cockpit Tools](https://github.com/jlcodes99/cockpit-tools) 鐨勫紑鍙戣€呴潰涓翠互涓嬬棝鐐癸細

| 鐥涚偣 | 鐜拌薄 | 鏍瑰洜 |
|------|------|------|
| 鍒囨崲宸ュ叿鍚?ChatGPT 鐧诲綍娑堝け | Codex 鍙樻垚 API Key 妯″紡 | CC Switch "鎺ョ"鍔熻兘鍜?Cockpit Tools "鍚姩API鏈嶅姟"浼氳鐩?`auth.json` |
| 鍘嗗彶瀵硅瘽鍏ㄩ儴涓嶈 | 鍒囨崲宸ュ叿鍚?Codex 鍘嗗彶涓虹┖ | 涓嶅悓宸ュ叿鐨?`model_provider` 鍚嶇О涓嶅悓锛孋odex 鎸夋瀛楁杩囨护浼氳瘽 |
| Codex 鍚姩鐧藉睆 | 鐣岄潰鍗℃鎴栧叏鐧?| 閰嶇疆浜嗕笉瀛樺湪鐨勭鍙ｆ垨涓嶈鏀寔鐨勫弬鏁?|
| 鍙嶅鐧诲綍琚涪 | ChatGPT 浠ょ墝琚鐩栧悗闇€閲嶆柊鐧诲綍 | 鏃犺嚜鍔ㄦ仮澶嶆満鍒?|

### 鏈」鐩彁渚涚殑涓夊眰闃叉姢

```
鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹? 鍒囨崲灞? switch-codex.ps1                     鈹?鈹? 鈫?涓€閿垏鎹?CC Switch 鈫?Cockpit Tools        鈹?鈹? 鈫?鑷姩杩佺Щ浼氳瘽鍒扮粺涓€ provider               鈹?鈹? 鈫?淇 auth.json 涓?ChatGPT 妯″紡            鈹?鈹? 鈫?鑷姩鏇存柊瀹堟姢杩涚▼閲戝浠?                   鈹?鈹溾攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹? 淇濇姢灞? guard-codex-config.ps1               鈹?鈹? 鈫?Windows 浠诲姟璁″垝绋嬪簭鑷惎鍔?                鈹?鈹? 鈫?姣?5 绉掕疆璇㈡娴?auth.json + config.toml   鈹?鈹? 鈫?妫€娴嬪埌琚鐩?鈫?绉掔骇鑷姩鎭㈠               鈹?鈹? 鈫?澶氬眰澶囦唤閾? 閲戝浠?鈫?姘镐箙澶囦唤 鈫?瀹夊叏澶囦唤  鈹?鈹溾攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹? 鏁版嵁灞? 缁熶竴 provider 鍚嶇О                   鈹?鈹? 鈫?浣跨敤 codex_local_access (Codex 鍘熺敓淇濈暀鍚? 鈹?鈹? 鈫?CC Switch 鍜?Cockpit Tools 鍏辩敤鍚屼竴鍚嶇О    鈹?鈹? 鈫?鍒囨崲鍙敼 base_url 绔彛锛屼笉鍔?provider     鈹?鈹? 鈫?鎵€鏈変細璇濇案涔呭彲瑙侊紝涓嶅彈鍒囨崲褰卞搷             鈹?鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?```

---

## 浜屻€佸畨瑁?
### 鍓嶆彁鏉′欢

- Windows 10/11
- [PowerShell 5.1+](https://aka.ms/powershell) (绯荤粺鑷甫)
- [sqlite3](https://www.sqlite.org/download.html) (闇€鍦?PATH 涓彲鐢?
- 宸插畨瑁?[Codex Desktop](https://github.com/openai/codex)
- 宸插畨瑁?[CC Switch](https://github.com/farion1231/cc-switch) 鍜?鎴?[Cockpit Tools](https://github.com/jlcodes99/cockpit-tools)

### 涓€閿畨瑁?
```powershell
# 鍏嬮殕浠撳簱
git clone https://github.com/YOUR_USERNAME/codex-tool-switcher.git
cd codex-tool-switcher

# 杩愯瀹夎鑴氭湰
.\install.ps1
```

瀹夎鑴氭湰浼氾細
1. 灏?`switch-codex.ps1` 鍜?`guard-codex-config.ps1` 澶嶅埗鍒?`~/.codex/`
2. 灏?`guard-codex-config.ps1` 娉ㄥ唽涓?Windows 鐧诲綍鑷惎鍔ㄤ换鍔?3. 鎵ц涓€娆℃€т細璇濊縼绉伙紙灏嗘墍鏈夊巻鍙蹭細璇濊縼绉诲埌缁熶竴 provider锛?4. 鍒涘缓鍒濆閲戝浠?
### 鎵嬪姩瀹夎

```powershell
Copy-Item .\switch-codex.ps1 "$env:USERPROFILE\.codex\switch-codex.ps1"
Copy-Item .\guard-codex-config.ps1 "$env:USERPROFILE\.codex\guard-codex-config.ps1"
& "$env:USERPROFILE\.codex\guard-codex-config.ps1" -Install
```

---

## 涓夈€佷娇鐢?
### 鏃ュ父鍒囨崲

```powershell
# 鍒囨崲鍒?CC Switch锛堢鍙?16897锛?& "$env:USERPROFILE\.codex\switch-codex.ps1" cc

# 鍒囨崲鍒?Cockpit Tools锛堢鍙?42805锛?& "$env:USERPROFILE\.codex\switch-codex.ps1" cockpit

# 鏌ョ湅褰撳墠鐘舵€?& "$env:USERPROFILE\.codex\switch-codex.ps1" status

# 杩佺Щ鏃т細璇濆埌缁熶竴 provider锛堥€氬父涓嶉渶瑕佹墜鍔ㄦ墽琛岋級
& "$env:USERPROFILE\.codex\switch-codex.ps1" migrate
```

姣忔鍒囨崲鍚?*閲嶅惎 Codex** 鐢熸晥銆?
### CC Switch 鍐呴儴鍒囨崲渚涘簲鍟?
鍦?CC Switch 鐨?GUI 鐣岄潰涓婄洿鎺ュ垏鎹緵搴斿晢锛?*涓嶄細褰卞搷 Codex 鐨勯厤缃枃浠?*銆傝繖鏄袱涓嫭绔嬬殑灞傜骇锛?
| 灞傜骇 | 鎿嶄綔 | 褰卞搷鑼冨洿 |
|------|------|---------|
| CC Switch 渚涘簲鍟?| 鍦?CC Switch 鐣岄潰鍒囨崲 | 浠?CC Switch 鍐呴儴杞彂鐩爣 |
| Codex 鎺ュ彛宸ュ叿 | 鐢?`switch-codex.ps1` 鍒囨崲 | Codex 鐨?`config.toml` |

### Cockpit Tools 鐗规畩娴佺▼

Cockpit Tools 鐨勩€屽惎鍔ˋPI鏈嶅姟銆嶆寜閽細寮哄埗閲嶅惎 Codex 骞惰鐩?`auth.json`銆傛纭搷浣滈『搴忥細

```
1. 鍦?Cockpit Tools 鐣岄潰鐐瑰嚮銆屽惎鍔ˋPI鏈嶅姟銆?   鈫?绔彛 42805 鍚姩锛孋odex 琚噸鍚紝auth.json 鍙兘琚鐩?   鈫?瀹堟姢杩涚▼浼氬湪 5 绉掑唴鑷姩鎭㈠ auth.json

2. 杩愯: switch-codex.ps1 cockpit
   鈫?纭繚 config.toml 姝ｇ‘鎸囧悜 Cockpit Tools

3. 閲嶅惎 Codex
   鈫?ChatGPT 宸茬櫥褰?+ 鎺ュ彛璧?Cockpit Tools
```

---

## 鍥涖€佹牳蹇冨師鐞?
### 4.1 涓轰粈涔堝垏鎹㈠伐鍏峰悗鍘嗗彶瀵硅瘽浼氭秷澶?
Codex 灏嗘墍鏈変細璇濆厓鏁版嵁瀛樺偍鍦?`~/.codex/state_5.sqlite` 鐨?`threads` 琛ㄤ腑锛?
```sql
CREATE TABLE threads (
    id TEXT PRIMARY KEY,
    model_provider TEXT NOT NULL,  -- 鈽?鍏抽敭瀛楁
    ...
);
```

Codex 鍚姩鏃讹紝**鍙樉绀?`model_provider` 涓庡綋鍓嶉厤缃尮閰嶇殑浼氳瘽**銆傚鏋?CC Switch 閰嶇疆鐨?provider 鍚嶆槸 `"cc_switch"`锛孋ockpit Tools 閰嶇疆鐨勬槸 `"codex_local_access"`锛岄偅涔堝垏鎹㈠埌鍙︿竴涓伐鍏峰悗锛屼箣鍓嶇殑鎵€鏈変細璇濆氨銆屾秷澶便€嶄簡銆?
### 4.2 瑙ｅ喅鏂规锛氱粺涓€ provider 鍚嶇О

鎴戜滑浣跨敤 `codex_local_access` 浣滀负缁熶竴鐨?provider 鍚嶇О鈥斺€旇繖鏄?Cockpit Tools 鍘熺敓鏀寔鐨勪繚鐣欏悕锛孋odex 鍙互姝ｇ‘澶勭悊鍏朵細璇濆彲瑙佹€с€?
CC Switch 鍜?Cockpit Tools 鍏辩敤鍚屼竴涓?provider 鍚嶏紝鍒囨崲鏃跺彧鏀?`base_url` 绔彛锛?
```toml
# 浣跨敤 CC Switch 鏃?
model_provider = "codex_local_access"
[model_providers.codex_local_access]
base_url = "http://127.0.0.1:16897/v1"    # 鈫?CC Switch 绔彛

# 鍒囨崲涓?Cockpit Tools 鏃?
model_provider = "codex_local_access"       # 鈫?provider 鍚嶄笉鍙?
[model_providers.codex_local_access]
base_url = "http://127.0.0.1:42805/v1"    # 鈫?鍙敼杩欓噷
```

姣忔鍒囨崲鏃讹紝鑴氭湰浼氳嚜鍔ㄦ墽琛?SQL 杩佺Щ锛?
```sql
UPDATE threads SET model_provider = 'codex_local_access'
WHERE model_provider != 'codex_local_access';
```

### 4.3 涓轰粈涔?ChatGPT 鐧诲綍浼氳"韪㈡帀"

涓変釜宸ュ叿浼氳鐩?Codex 閰嶇疆鏂囦欢锛?
- **CC Switch "鎺ョ Codex"**: 淇敼 `config.toml`锛屽垹闄?`auth.json`
- **Cockpit Tools "鍚姩API鏈嶅姟"**: 鍐欏叆 API Key 鍒?`auth.json`锛屽垹闄?ChatGPT 浠ょ墝
- **`.cockpit_codex_auth.json` 鏍囪**: 浣?Codex 鍦?`codex_local_access` 涓嬪己鍒朵娇鐢?API Key 妯″紡

瀹堟姢杩涚▼閫氳繃 MD5 鍝堝笇鍙樺寲妫€娴嬭繖浜涜鐩栵紝骞朵粠澶氬眰澶囦唤涓嚜鍔ㄦ仮澶嶃€?
### 4.4 韪╄繃鐨勫潙

| 鍧?| 鐜拌薄 | 鍘熷洜 | 瑙ｅ喅鏂规 |
|----|------|------|---------|
| `preferred_auth_method = "chatgpt"` | Codex 鐧藉睆 | 涓嶈褰撳墠鐗堟湰 Codex 鏀寔 | 涓嶄娇鐢ㄦ鍙傛暟 |
| 鑷垱 provider 鍚?`local_proxy` | 浼氳瘽涓嶆樉绀?| Codex 涓嶈瘑鍒嚜瀹氫箟鍚?| 浣跨敤 `codex_local_access` |
| `.cockpit_codex_auth.json` 鏍囪 | 寮哄埗鍒囧埌 API Key 妯″紡 | Cockpit Tools 鏍囪瑙﹀彂 | 閲嶅懡鍚嶇鐢?|
| `requires_openai_auth = true` | CC Switch 渚涘簲鍟嗛厤缃瑕嗙洊 | Codex 鍙戦€?ChatGPT 浠ょ墝鈫扖C Switch 娣卞害閾炬帴瀵煎叆鈫掕鐩栦緵搴斿晢 | 鏀逛负 `false` |
| auth.json 鍙 | Codex 鍚姩鐧藉睆 | Codex 鍚姩闇€鍐欏叆浠ょ墝 | 淇濇寔鍙啓锛岀敤瀹堟姢杩涚▼鎭㈠ |
| FileSystemWatcher 浜嬩欢涓㈠け | 瀹堟姢杩涚▼婕忔仮澶?| 浜嬩欢鏈哄埗涓嶅彲闈?| 鏀圭敤 5 绉掕疆璇?MD5 鍝堝笇 |

---

## 浜斻€佹枃浠剁粨鏋?
```
codex-tool-switcher/
鈹溾攢鈹€ README.md                # 鏈枃浠?鈹溾攢鈹€ LICENSE                  # MIT License
鈹溾攢鈹€ install.ps1              # 涓€閿畨瑁呰剼鏈?鈹溾攢鈹€ switch-codex.ps1         # CC Switch 鈫?Cockpit Tools 鍒囨崲鑴氭湰
鈹溾攢鈹€ guard-codex-config.ps1   # 閰嶇疆瀹堟姢杩涚▼ (v3, 杞妯″紡)
鈹斺攢鈹€ .gitignore
```

瀹夎鍚?`~/.codex/` 涓嬩細澧炲姞锛?
```
~/.codex/
鈹溾攢鈹€ switch-codex.ps1              # 鍒囨崲鑴氭湰
鈹溾攢鈹€ guard-codex-config.ps1        # 瀹堟姢杩涚▼
鈹溾攢鈹€ guardian-golden/              # 閲戝浠界洰褰?鈹?  鈹溾攢鈹€ auth.json.golden
鈹?  鈹斺攢鈹€ config.toml.golden
鈹溾攢鈹€ auth-backups/                 # 澶氬眰澶囦唤
鈹?  鈹溾攢鈹€ auth.json.PERMANENT       # 姘镐箙鍙澶囦唤
鈹?  鈹斺攢鈹€ auth.json.YYYYMMDD-HHmmss.bak
鈹溾攢鈹€ guardian-logs/
鈹?  鈹斺攢鈹€ guardian.log
鈹斺攢鈹€ switch-backups/
    鈹斺攢鈹€ config.toml.YYYYMMDD-HHmmss.bak
```

---

## 鍏€佸畧鎶よ繘绋嬬鐞?
```powershell
# 瀹夎鑷惎鍔?& "$env:USERPROFILE\.codex\guard-codex-config.ps1" -Install

# 鍗歌浇
& "$env:USERPROFILE\.codex\guard-codex-config.ps1" -Uninstall

# 鏌ョ湅鏃ュ織
Get-Content "$env:USERPROFILE\.codex\guardian-logs\guardian.log" -Tail 20

# 閫氳繃 Windows 浠诲姟璁″垝绋嬪簭绠＄悊
taskschd.msc  # 鏌ユ壘 "CodexConfigGuardian" 浠诲姟
```

---

## 涓冦€佹晠闅滄仮澶?
### Codex 鐧藉睆

1. 妫€鏌ョ洰鏍囩鍙ｆ槸鍚﹀湪鐩戝惉锛歚netstat -ano | Select-String "16897|42805"`
2. 纭繚 `auth.json` 瀛樺湪涓?`auth_mode = "chatgpt"`
3. 纭繚 `auth.json` **涓嶆槸**鍙鐘舵€?4. 鏉€鎺?Codex 杩涚▼鍚庨噸鍚?
### ChatGPT 鐧诲綍涓㈠け

瀹堟姢杩涚▼浼氳嚜鍔ㄦ仮澶嶃€傚鏋滄病鎭㈠锛?
```powershell
# 鎵嬪姩浠庡浠芥仮澶?Copy-Item "$env:USERPROFILE\.codex\auth-backups\auth.json.PERMANENT" `
          "$env:USERPROFILE\.codex\auth.json" -Force
# 閲嶅惎 Codex
```

### 浼氳瘽鍘嗗彶涓嶆樉绀?
```powershell
# 鎵嬪姩鎵ц浼氳瘽杩佺Щ
sqlite3 "$env:USERPROFILE\.codex\state_5.sqlite" `
  "UPDATE threads SET model_provider = 'codex_local_access' WHERE model_provider != 'codex_local_access';"
# 閲嶅惎 Codex
```

---

## 鍏€佺幆澧冭姹?
| 缁勪欢 | 鏈€浣庣増鏈?| 鐢ㄩ€?|
|------|---------|------|
| Windows | 10/11 | 鎿嶄綔绯荤粺 |
| PowerShell | 5.1 | 鑴氭湰杩愯鐜 |
| sqlite3 CLI | 3.x | 浼氳瘽鏁版嵁搴撹縼绉?|
| Codex Desktop | 26.x | AI 缂栫▼宸ュ叿 |
| CC Switch | 鏈€鏂扮増 | 鏈湴 API 浠ｇ悊 (绔彛 16897) |
| Cockpit Tools | 0.24.x | 鏈湴 API 浠ｇ悊 (绔彛 42805) |

---

## 涔濄€丩icense

MIT 鈥?璇﹁ [LICENSE](LICENSE)

## 鍗併€佽嚧璋?
- [CC Switch](https://github.com/farion1231/cc-switch) 鈥?鏈湴 AI 浠ｇ悊鍒囨崲宸ュ叿
- [Cockpit Tools](https://github.com/jlcodes99/cockpit-tools) 鈥?AI 椹鹃┒鑸卞伐鍏峰浠?- [Codex](https://github.com/openai/codex) 鈥?OpenAI 鐨?AI 缂栫▼缁堢
- [codex-ccswitch-mobile](https://github.com/kuangre123/codex-ccswitch-mobile) 鈥?Codex 鎵嬫満杩滅▼鎺у埗 Skill

---

## 鍗佷竴銆丏eepSeek 瀹樻柟 API 鎺ュ叆锛堝崗璁炕璇戞柟妗堬級

DeepSeek 瀹樻柟 API 鍙敮鎸?`/v1/chat/completions`锛岃€?Codex 浣跨敤 `/v1/responses`銆傞渶瑕佹湰鍦扮炕璇戜唬鐞嗐€?
### 鎺ㄨ崘鏂规锛歝odex_deepseek_proxy

```powershell
git clone https://github.com/Nigel211/codex_deepseek_proxy.git ~/codex_deepseek_proxy
cd ~/codex_deepseek_proxy
pip install -r requirements.txt
```

鍒涘缓 `.env`锛?```
DEEPSEEK_API_KEY=sk-your-deepseek-key
DEEPSEEK_MODEL=deepseek-v4-pro
DEEPSEEK_URL=https://api.deepseek.com/v1/chat/completions
DEEPSEEK_DEBUG=0
```

**閲嶈**锛氫慨鏀?`codex_proxy.py` 绗?322 琛岋紝寮哄埗妯″瀷鍚嶏細
```python
# 鏀瑰墠锛歟ffective_model = req_data.get("model") or DEEPSEEK_MODEL
# 鏀瑰悗锛?effective_model = DEEPSEEK_MODEL  # Codex 鍙兘鍙?gpt-5.5锛孌eepSeek 涓嶈
```

娉ㄥ唽涓?Windows 鑷惎鍔ㄦ湇鍔★細
```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File ~/codex_deepseek_proxy/start-proxy.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
Register-ScheduledTask -TaskName "CodexDeepSeekProxy" -Action $action -Trigger $trigger -Force
```

`start-proxy.ps1`:
```powershell
$env:DEEPSEEK_API_KEY = "sk-your-key"
$env:DEEPSEEK_MODEL = "deepseek-v4-pro"
Set-Location "$env:USERPROFILE\codex_deepseek_proxy"
python codex_proxy.py
```

### 鏋舵瀯

```
Codex 鈫?codex_proxy:5000 鈫?DeepSeek API
        (Responses鈫扖hat 缈昏瘧)
```

缁曡繃 CC Switch 鐩磋繛缈昏瘧浠ｇ悊锛岄伩鍏?CC Switch 娣卞害閾炬帴瀵煎叆姹℃煋渚涘簲鍟嗛厤缃€?
## 鍗佷簩銆佸凡鐭ラ櫡闃卞叏闆?
| # | 闄烽槺 | 鐜拌薄 | 鏍瑰洜 | 淇 |
|---|------|------|------|------|
| 6 | `auth.json` 鎼哄甫 `OPENAI_API_KEY` | CC Switch 渚涘簲鍟嗗瘑閽ヨ瑕嗗啓 | CC Switch 璇诲彇 auth.json 鐨?API Key 瑙﹀彂娣卞害閾炬帴瀵煎叆 | `OPENAI_API_KEY` 蹇呴』涓?`null`锛屽畧鎶よ繘绋嬮渶妫€鏌ユ瀛楁 |
| 7 | `codex_deepseek_proxy` 閫忎紶妯″瀷鍚?| DeepSeek 400: model gpt-5.5 not supported | 浠ｇ悊榛樿鐢?Codex 璇锋眰涓殑 model 鑰岄潪閰嶇疆鍊?| 淇敼浠ｇ悊浠ｇ爜寮哄埗浣跨敤 `DEEPSEEK_MODEL` |
| 8 | id_token 杩囨湡鍚庨噸鍚?| 鏄剧ず鐧诲綍椤甸潰 | Codex 鍚姩鏃朵笉鑷姩鍒锋柊杩囨湡 id_token | 鐢?`codex login --device-auth` 閲嶆柊鐧诲綍 |
| 9 | `.env` 鏂囦欢 UTF-8 BOM | 浠ｇ悊鏃犳硶璇诲彇瀵嗛挜 | PowerShell `Set-Content -Encoding UTF8` 浼氬啓 BOM | 鐢?ASCII 缂栫爜鎴栫Щ闄?BOM |
| 10 | `disable_response_storage = true` | 鍙兘褰卞搷閮ㄥ垎鍔熻兘 | 鏉ヨ嚜鍘熷澶囦唤鐨勯厤缃畫鐣?| 鎸夐渶淇濈暀鎴栫Щ闄?|

---

## 十三、最终架构（v5 — 独立切换）

经过大量测试，最终方案是**两个独立脚本**，各管各的目标，绝不触碰 `auth.json`。

### 切换命令

```powershell
# → DeepSeek Proxy (直连 codex_proxy:5000)
& "$env:USERPROFILE\.codex\switch-deepseek.ps1"

# → CC Switch (端口 16897, zz1cc.cc.cd 等中转)
& "$env:USERPROFILE\.codex\switch-relay.ps1"
```

### 架构图

```
DeepSeek 路线:
  Codex → codex_proxy:5000 → api.deepseek.com
         (Responses→Chat 翻译)

CC Switch 路线:
  Codex → CC Switch:16897 → 中转供应商 (zz1cc.cc.cd 等)
         (CC Switch 原生驱动)
         ↑ 在 CC Switch GUI 里配置供应商密钥

Claude 路线:
  Claude → CC Switch:16897 → api.deepseek.com/anthropic
         (DeepSeek 原生兼容 Anthropic Messages API)

Cockpit Tools:
  端口 42805 → 按需启动
  ⚠ 启动时会触发 ccswitch:// 深度链接导入，覆盖 CC Switch 供应商
```

### 关键规则（血泪教训）

1. **永不碰 `auth.json`** — 切换脚本只写 `config.toml`，不动 `auth.json`
2. **`OPENAI_API_KEY` 永远为 `null`** — 防止 CC Switch 读到 API Key 覆盖供应商
3. **`requires_openai_auth = false`** — 防止 CC Switch 深度链接导入
4. **Cockpit Tools 和 CC Switch 不要同时开** — Cockpit Tools 会通过 `ccswitch://` 协议覆盖 CC Switch 供应商
5. **id_token 1小时过期** — 切换后如看到登录页，用 `codex login --device-auth` 快速登录
6. **codex_deepseek_proxy 强制模型名** — 修改 `codex_proxy.py` 第322行为 `effective_model = DEEPSEEK_MODEL`

## 十四、已知陷阱全集（最终版）

| # | 陷阱 | 现象 | 根因 | 修复 |
|---|------|------|------|------|
| 1 | `preferred_auth_method` | Codex 白屏 | Codex 不支持此参数 | 移除 |
| 2 | 自创 provider 名 | 会话不显示 | Codex 不识别 | 用 `codex_local_access` |
| 3 | `.cockpit_codex_auth.json` | 强制 API Key 模式 | Cockpit Tools 标记 | 重命名禁用 |
| 4 | `requires_openai_auth=true` | CC Switch 供应商被覆盖 | 深度链接导入 | 改为 `false` |
| 5 | auth.json 只读 | Codex 白屏 | 无法写令牌 | 保持可写 |
| 6 | FileSystemWatcher | 漏恢复 | 事件不可靠 | 5秒轮询 MD5 |
| 7 | `OPENAI_API_KEY` 有值 | CC Switch 供应商密钥被覆盖 | CC Switch 读到 Key | 设为 `null`，守护检查 |
| 8 | proxy 透传模型名 | DeepSeek 400 | Codex 发 gpt-5.5 | 代理强制覆盖模型 |
| 9 | id_token 过期 | 显示登录页 | 1小时过期，启动不刷新 | `codex login --device-auth` |
| 10 | `.env` UTF-8 BOM | 代理读不到密钥 | PowerShell 编码问题 | ASCII 编码 |
| 11 | Cockpit Tools 深度链接 | CC Switch 供应商被覆盖 | Cockpit Tools 自动注册 | 不要同时开两个工具 |
| 12 | 切换脚本重写 auth.json | 登录丢失 | JSON 序列化问题 | 脚本不碰 auth.json |
