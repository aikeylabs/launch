# AiKey Production 产品亮点

> 把 Claude、Codex、Kimi 的 KEY、账号与路由统一管理，让团队在不中断工作的情况下切换额度、观察成本、编排多模型生产力。

## 宣传语

- 一处导入，处处可用。
- 保密凭证留在 Vault，自由使用交给路由 KEY。
- 额度不中断，账号无缝切。
- 看清每个 KEY 的用量趋势，把 token 成本优化到日常工作流里。
- 自定义 AI 路由，把 Claude、Kimi、Codex 编排成一个稳定工作台。

## 核心亮点

### 1. 一键导入 KEY 与账号

**Why：**

团队里常见的麻烦不是没有 KEY，而是 KEY 散落在终端环境变量、脚本、个人电脑和第三方客户端里。复制一次就多一个泄漏点，换人、换机器、换额度时也很难确认谁还在用哪一份真实凭证。

**How：**

AiKey 支持导入 API Key 和 OAuth 账号，统一保存在本地或团队 Vault 中。真实凭证不需要暴露给终端、脚本或第三方客户端；日常使用只分发可控的路由 token 或当前 active 绑定。

```bash
aikey add anthropic:work        # 导入 Claude API Key
aikey web --import              # 或在 Web 端一键导入

aikey auth login claude         # 或登录 Claude 账号
aikey use                       # 选择当前使用的 KEY / 账号
```

![AiKey Vault routing](assets/aikey-vault-routing-minimal.png)

**What：敏感凭证集中保管，工作入口自由分发。**

### 2. 用量趋势与 token 成本洞察

**Why：**

AI 成本最容易在日常协作里变成一笔糊涂账：谁在高频调用、哪个账号突然变贵、发布前后 token 是否异常增长，往往要到账单出来后才发现。没有趋势和结构，就很难把优化变成日常动作。

**How：**

控制台可查看每个 KEY、账号、协议的用量趋势，帮助团队定位高频使用来源。结合 token 使用结构，例如 cache token 占比、请求量和 provider 分布，可以辅助发布前后做费用复盘与成本优化。

```bash
aikey web                       # 打开控制台查看 Vault、用量和 token 结构
```

![AiKey usage dashboard](assets/aikey-usage-dashboard-minimal.png)

**What：不只会用 KEY，还能看懂 KEY 怎么被用。**

### 3. 多窗口、多应用、多账号同时工作

**Why：**

真实工作流很少只开一个 AI 工具：一个窗口在跑 Claude，一个编辑器在补代码，一个脚本在批量处理。所有工具共享同一组环境变量时，账号很容易互相抢占，测试、开发和自动化任务也会彼此干扰。

**How：**

AiKey 支持 Claude、Codex、Kimi 等不同 CLI，也支持 Cursor、OpenCode、Continue 等第三方客户端。多个终端窗口可以使用不同账号或临时激活不同 KEY，让研发、测试、脚本和个人探索互不干扰。

```bash
claude                          # 窗口 A：Claude
codex                           # 窗口 B：Codex
kimi                            # 窗口 C：Kimi

aikey activate claude2          # 窗口 D：同时使用 claude2 账号
claude
```

![AiKey multi-workflow routing](assets/aikey-multi-workflows-minimal.png)

**What：一个工作站，同时跑多个 AI 工作流。**

### 4. 额度不足时无缝切换账号

**Why：**

最影响心流的不是额度不足本身，而是额度在长对话、代码审查或排障中途突然耗尽。重新登录、重启 CLI、复制上下文都会打断思路，也可能让还没完成的任务丢掉节奏。

**How：**

当当前 Claude 账号或 KEY 额度不足时，用户不需要退出正在运行的 `claude` 会话。执行 `aikey use <另一个账号>` 后，运行中的会话会在下一次请求使用新的 active 绑定继续工作。

```bash
aikey use backup-account        # 不退出当前 claude，会话继续使用新账号
```

![AiKey quota switch](assets/aikey-quota-switch-minimal.png)

**What：额度用完，不打断思路。**

### 5. 自定义路由与多模型编排

**Why：**

当团队同时使用多个模型和多个账号时，真正复杂的是选择：代码任务该走哪个模型，批处理该避开哪个贵账号，主账号不可用时如何自动兜底。如果每个客户端都单独配置，路由策略会很快失控。

**How：**

通过 `aikey route` 输出的 `base_url` 和 `api_key`，用户可以把多个 Claude、Kimi、Codex 或 OpenAI 兼容账号接入自己的客户端、脚本或网关。高级用户可以在此基础上开发自己的路由策略，按模型、任务、额度或成本编排账号使用。

```bash
aikey route                     # 查看所有可用路由
aikey route work                # 复制指定 KEY 的 base_url + api_key
```

![AiKey custom routing](assets/aikey-custom-routing-minimal.png)

**What：把多个 AI 账号，编排成一套可控路由。**





# aikey 快速开始

---

## 安装

### macOS / Linux

**最新稳定版**（推荐 —— 自动解析最新 GA tag）：

```bash
curl -fsSL https://github.com/aikeylabs/launch/releases/latest/download/latest-install.sh | sh
```

安装到 `~/.aikey/bin`。



## 使用个人 API Key

将你的 API Key 添加到本地加密 vault：

```bash
aikey add my-key
```

激活当前 Key：

```bash
aikey use my-key
```

然后直接使用你常用的工具 — 本地代理自动注入 Key：

```bash
claude              # Anthropic Claude CLI
codex               # OpenAI Codex CLI
kimi                # Kimi CLI（kimi(kimi-code) 与 kimi(moonshot) 通用）
```

Key 通过本地代理路由，不会暴露真实凭证。

### 使用 OAuth 账号

如果你有 Claude Pro/Max、ChatGPT Plus 等订阅，可以直接用 OAuth 登录，无需 API Key：

```bash
aikey auth login claude       # Claude (Anthropic)
aikey auth login codex        # Codex / ChatGPT (OpenAI)
aikey auth login kimi_code    # Kimi Code (api.kimi.com); 'kimi' alias 仍可用
```

OAuth 账号和 API Key 统一通过 `aikey use` 切换。

查看已添加的所有 Key：

```bash
aikey list
```

查看 Key 的路由配置（用于第三方客户端）：

```bash
aikey route
```

打开 Web 控制台查看 Key 状态、用量和更多管理功能：

```bash
aikey web
```

侧边栏 **My Vault**（或 `aikey web --vault`）展示本机 vault 里的所有 Personal
API Key 和 OAuth 账号，支持改别名、一次性 reveal（前端 60 秒自动重新遮罩）、
删除、新增。unlock 会话与 Import 页面共享。OAuth session token **永不**在
浏览器展示；新增 OAuth 账号请走 `aikey account login <provider>`。

---

## CI / 脚本（无交互）

不依赖 shell hook，适合 GitHub Actions、定时任务等。

```bash
aikey run -- python eval.py
```

---

## 日常操作速查

```bash
aikey list              # 查看所有 Key
aikey use               # 切换当前 Key
aikey whoami            # 查看当前身份和当前 Key
aikey doctor            # 一键自检
```

---

## 高级用法：临时切换 Key

使用 `aikey activate` 在当前终端临时切换 Key。与 `aikey use` 不同，它**不会**修改全局设置或 active.env — 关闭终端即恢复。

```bash
aikey activate my-key               # 在当前终端激活
(my-key) ~/Projects %               # 提示符显示当前激活的 Key

aikey activate team-key --provider openai   # 切换到另一个 Key
(team-key) ~/Projects %

aikey deactivate                     # 立即恢复全局设置
~/Projects %
```

- `activate` 通过 `eval` 设置 shell 环境变量 — 需要先通过 `aikey use` 安装 shell hook
- `deactivate` 立即恢复 active.env 中的全局设置（无需等待下一次 prompt）
- 多个终端可以同时激活不同的 Key
- 当 Key 支持多个 provider 时，需要加 `--provider` 参数

---

## 高级用法：在第三方 AI 客户端中使用 Key

在 Cursor、OpenCode、Continue 或任何支持自定义 `base_url` + `api_key` 的 AI 客户端中配置：

```bash
aikey route                     # 列出所有路由 token
aikey route my-key              # 查看指定 key 的可粘贴配置
```

示例输出：

```
  # Configuration for: my-key (personal, anthropic)
  base_url:  http://127.0.0.1:27200/anthropic
  api_key:   aikey_vk_b82ef1d49c3a7e08...
```

将 `base_url` 和 `api_key` 粘贴到客户端设置中。代理通过 token 路由请求 — 真实凭证始终保留在 vault 中。

### OpenCode

创建或编辑 `~/.config/opencode/opencode.jsonc`：

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "anthropic": {
      "options": {
        "baseURL": "http://127.0.0.1:27200/anthropic/v1",
      }
    }
  },
  "model": "anthropic/claude-opus-4-6"
}
```

Provider 选择官方 `anthropic`，`baseURL` 指向本地代理，然后在 OpenCode 中填入 `aikey route my-key` 显示的 API Key 即可使用。

---

## 遇到问题？

```bash
aikey doctor            # 自动检查所有常见问题
aikey proxy restart     # proxy 卡住时重启
aikey key sync          # Key 状态不对时强制同步
```

### Windows 专属

#### Windows上安装（PowerShell 原生，**无需** WSL）
(Windows 兼容尚在优化中,敬请期待)

> Stage 4 windows-compat。最低支持：Windows 10 1809+ / Windows 11 /
> Windows Server 2019+。在 PowerShell 7+（推荐）或 Windows PowerShell 5.1
> 下均可。

```powershell
# 下载 installer 包（包含 entrypoint + lib/*.ps1），解压、运行
iwr "https://github.com/aikeylabs/launch/releases/download/v1.0.0-rc.1/aikey-installer-windows_1.0.0-rc.1.zip" -OutFile "$env:TEMP\aikey-inst.zip"
Expand-Archive -Path "$env:TEMP\aikey-inst.zip" -DestinationPath "$env:TEMP\aikey-inst" -Force
& "$env:TEMP\aikey-inst\local-install.ps1" -Version v1.0.0-rc.1
```

> 为什么是"下 zip + 解压 + 运行"三步而不是一行 `iwr | iex`：`.ps1`
> 入口脚本会从 `$PSScriptRoot/lib` 加载 `health/service/backup.ps1`，
> 这些 lib 必须在运行时落在 entrypoint 旁边的磁盘上；zip 保留了
> 这个相对结构。功能上等价于 macOS / Linux 的 `curl ... | sh`。

安装到 `%LOCALAPPDATA%\Aikey\bin` 并自动追加到当前用户 `PATH`。安装器
把 install dir 的 NTFS ACL 收紧到 owner-only —— 加密 vault 永远不会被
同台机器的其他用户读到。

如需 PowerShell hook 自动激活（运行 `aikey use foo` 后，新开 PowerShell
会自动带上对应 env vars），安装后执行：

```powershell
aikey hook install
```

这会向 `$PROFILE.CurrentUserAllHosts` 追加一个标记块（执行前会问你确认；
传 `-Yes` 自动同意）。

---


| 现象 | 可能原因 + 修复 |
|---|---|
| `aikey hook update` 报 `hook.ps1` EACCES | 另一个 PowerShell 会话占着这个文件。先关掉别的 PS 窗口，**不要**用 sudo —— 提权解决不了句柄占用。 |
| 装完立刻 `aikey: command not found` | 新 PATH 只在**新开**的 PowerShell 窗口生效。开个新终端，或重启当前终端。 |
| `aikey use <alias>` 跑过了，但下一个 prompt 没看到 env vars | PowerShell hook 没装。执行 `aikey hook install`（写入 `$PROFILE.CurrentUserAllHosts`）。 |
| `aikey-proxy.exe` 升级时报"file in use" | 先关掉运行中的 proxy：`aikey proxy stop`（清理退出），再重跑安装。如还有残留，用 `Stop-Process -Force` 强杀旧 `.exe`。 |
| Claude Code 交互模式无视 `ANTHROPIC_API_KEY` | 这是 known issue —— `aikey use` 会向 `~/.claude.json` 的 `customApiKeyResponses.approved` 写一个 sentinel 来预批准这个 env var。如果手工清过 `.claude.json`，重跑一次 `aikey use <anthropic-alias>` 即可。详见 bugfix `2026-04-29-claude-interactive-ignores-anthropic-api-key.md`。 |

重新安装 = 升级，直接运行:

```bash
curl -fsSL https://github.com/aikeylabs/launch/releases/download/v1.0.0-rc.1/local-install.sh | sh -s -- --version v1.0.0-rc.1

```

**能不能使用代理:**
```bash
aikey env set -- export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890
```


**删除数据重装:**

```bash
# 危险：先全清，再装最新版（管道场景下走 /dev/tty 弹 y/N，可加 --yes 跳过）
curl -fsSL https://github.com/aikeylabs/launch/releases/latest/download/latest-install.sh | sh -s -- --clear

# 删除数据并安装指定版本
curl -fsSL https://github.com/aikeylabs/launch/releases/download/v1.0.0-rc.1/local-install.sh | sh -s -- --version v1.0.0-rc.1 --clear
```


**仅卸载（不重装）:**
```bash
# 危险：清掉 ~/.aikey、第三方 CLI 注入、shell hook、OS keychain，但不重装
curl -fsSL https://github.com/aikeylabs/launch/releases/download/v1.0.0-rc.1/uninstall.sh | sh -s -- --yes
```
