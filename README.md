**English** · [中文](README.zh.md)

# AiKey Production Highlights

> Unify keys, accounts, and routing for Claude, Codex, and Kimi — so your team can swap quotas, watch costs, and orchestrate multi-model productivity without breaking flow.

**Website:** [aikeylabs.com](https://aikeylabs.com)

## Make AI tools feel like one workbench

- Import keys and accounts once; reuse them across Claude, Codex, Kimi, Cursor, and OpenCode.
- Real credentials stay in the vault; daily work only sees revocable, copyable, manageable route entrypoints.
- When quota runs low, keep the conversation alive — switch accounts and finish the thought.
- See usage, token, and provider trends as they happen, instead of waiting for the bill.
- Compose multiple AI accounts into one routing fabric, so personal exploration, team development, and scripted jobs each travel their own lane.

## Core Highlights

### 1. One-click import for keys and accounts

The pain isn't a missing key — it's keys scattered across terminals, scripts, personal laptops, and third-party clients. Every copy is one more leak point, and every team change makes it harder to know who still holds which real credential.

> AiKey imports API keys and OAuth accounts into a local or team vault. Real credentials never leave the vault; daily work only sees a controllable route token or the currently active binding.

```bash
aikey add anthropic:work        # Import a Claude API key
aikey web --import              # Or one-click import from the Web Console

aikey auth login claude         # Or sign in with a Claude OAuth account
aikey use                       # Pick the active key / account
```

![AiKey Vault routing](assets/aikey-vault-routing-minimal.png)

**Centralize sensitive credentials, distribute work entrypoints freely.**

> ✨ Walkthrough → [Personal edition complete flow · Step 3: Add a key in the Vault](#3-add-a-key-in-the-vault-and-accept-the-install-hook-banner)

### 2. Usage trends and token cost insights

AI cost easily becomes a black box: who's calling at high frequency, which account suddenly got expensive, whether tokens spiked around a release — most teams only find out when the invoice arrives. Without trend and structure, optimization never makes it into the daily routine.

> The AiKey console shows usage trends per key, per account, and per protocol so the team can pinpoint heavy callers. Combined with token structure (cache token share, request volume, provider distribution), it supports pre/post-release cost reviews and steady-state optimization.

```bash
aikey web                       # Open the console for vault, usage, and token structure
```

![AiKey usage dashboard](assets/aikey-usage-dashboard-minimal.png)

**Don't just use the key — understand how the key is being used.**

> ✨ Walkthrough → [Personal flow · Step 4: Cost receipt after a chat](#4-run-claude-and-read-the-cost-receipt-after-the-chat) · [Step 6: Usage dashboard](#6-view-usage-statistics)

### 3. Multiple windows, multiple apps, multiple accounts in parallel

Real workflows rarely run a single AI tool: one window runs Claude, an editor is autocompleting code, a script is batch-processing data. When all of them share the same set of environment variables, accounts collide and test/dev/automation work step on each other.

> AiKey supports the Claude, Codex, and Kimi CLIs as well as third-party clients like Cursor, OpenCode, and Continue. Different terminal windows can use different accounts or temporarily activate different keys, so engineering, QA, scripts, and personal exploration stay isolated.

```bash
claude                          # Window A: Claude
codex                           # Window B: Codex
kimi                            # Window C: Kimi

aikey activate claude2          # Window D: run on the claude2 account in parallel
claude
```

![AiKey multi-workflow routing](assets/aikey-multi-workflows-minimal.png)

**One workstation, many AI workflows running side by side.**

> ✨ Walkthrough → [Personal flow · Step 4: Run claude / kimi / codex](#4-run-claude-and-read-the-cost-receipt-after-the-chat) · [Step 5: Switch keys](#5-switch-keys-web-or-cli)

### 4. Seamless account switching when quota runs out

The thing that breaks flow isn't the quota itself — it's the quota running out mid-conversation, mid-review, or mid-debug. Re-login, restart the CLI, copy context: each step pulls you out of the problem and risks losing momentum on unfinished work.

> AiKey moves quota switching outside the session. When the active Claude account or key runs out, you don't have to exit the running `claude` session. Run `aikey use <another-account>` and the in-flight session uses the new active binding on its next request.

```bash
aikey use backup-account        # Don't exit claude; the session continues on the new account
```

![AiKey quota switch](assets/aikey-quota-switch-minimal.png)

**Quota gone, train of thought intact.**

> ✨ Walkthrough → [Personal flow · Step 5: Switch keys (Web or CLI)](#5-switch-keys-web-or-cli)

### 5. Custom routing and multi-model orchestration

When a team uses several models across several accounts, the hard part is the choice: which model handles code tasks, which expensive account batch jobs should avoid, how to fail over when the primary account is down. Configuring each client separately is a fast track to losing control of the routing policy.

> The `base_url` and `api_key` produced by `aikey route` plug any number of Claude, Kimi, Codex, or OpenAI-compatible accounts into your client, script, or gateway. Power users can build their own routing strategies on top — orchestrating accounts by model, task, quota, or cost.

```bash
aikey route                     # List every available route
aikey route work                # Copy the base_url + api_key for a specific key
```

![AiKey custom routing](assets/aikey-custom-routing-minimal.png)

**Compose multiple AI accounts into one controllable routing fabric.**

> ✨ Walkthrough → [Reference · Use keys in third-party AI clients](#advanced-use-keys-in-third-party-ai-clients)

### 6. Seamlessly plug in third-party agents

Third-party agents never see your plaintext keys. When they call providers through AiKey, real Anthropic / OpenAI / Kimi credentials stay in the Vault — each agent's access stays under your control, granted per agent and revoked per agent, with no copies of real keys sitting in agent configs.

**No plaintext keys ever leave the Vault. Agent access stays explicit and revocable.**

### 7. Spot model degradation before it hits your work

Sometimes "claude-opus" silently routes to a cheaper model, or a gateway's quality quietly drops. By the time a batch run looks suspicious you've already burned tokens on bad output.

> `Trust Check` scores every credential 0–100 from streaming-rhythm fingerprints plus an on-demand private-question cascade. The page surfaces Trusted / Suspect / Risky bands per credential, with one-click re-verification and a 10-run cascade history per row.

```bash
# Default ON since rc.5 — the standard install already bundles trust-local
curl -fsSL .../latest-install.sh | sh

aikey web                       # sidebar → Quality → Trust Check
aikey trust status              # CLI equivalent

# Opt out
curl -fsSL .../latest-install.sh | sh -s -- --no-degrade-detector   # skip install-time
aikey app uninstall degrade-detector                                # remove post-install (reversible)
```

> **Current scope (MVP)**: full support for Anthropic `claude-opus-4-7` and `claude-sonnet-4-6` (L1 rhythm + L3 cascade with the official question bank); other Claude models get L1 rhythm only (L3 returns `inconclusive` until their question bank lands); OpenAI / Kimi / Gemini are on the roadmap.

**Spot the degradation before the invoice does.**

> ✨ Walkthrough → [Optional: Trust Check (degrade detection)](#optional-trust-check-degrade-detection)




# aikey Quickstart

---

## Install

### macOS / Linux

**Latest stable** (recommended — auto-detects the newest GA tag):

```bash
curl -fsSL https://github.com/aikeylabs/launch/releases/latest/download/latest-install.sh | sh
```

Add `-s -- --yes` to skip prompts (e.g. CI / automated scripts):

```bash
curl -fsSL https://github.com/aikeylabs/launch/releases/latest/download/latest-install.sh | sh -s -- --yes
```

**Pinned version** — replace `<TAG>` below with a specific release (e.g. `v1.0.0-rc.3`):

```bash
curl -fsSL https://github.com/aikeylabs/launch/releases/download/<TAG>/local-install.sh | sh -s -- --version <TAG>
```

Installs to `~/.aikey/bin`.

---

## Personal edition complete flow

> End-to-end daily flow: **install → add a key → chat → read the cost receipt → switch → check usage**. Each step has a screenshot placeholder and points back to the product highlight it delivers. For command details and advanced options, see the [Reference](#use-your-own-api-key) below.

### 1. Install the CLI + source

After completing [`## Install`](#install) above, apply PATH changes immediately:

```bash
source ~/.zshrc    # or source ~/.bashrc, depending on your shell
```

For Windows PowerShell, see the [Windows-specific](#windows-specific) section below — native PowerShell install, **no** WSL required.

> Terminal output after `local-install.sh` completes (`aikey` installed to `~/.aikey/bin`)
![alt text](assets/personal-step1-install-output.png)

### 2. Open aikey web

```bash
aikey web
```

Opens the local vault console in the default browser.

> `aikey web` on first open (empty Vault list, no keys added yet)
![alt text](assets/personal-step2-aikey-web-empty.png)

### 3. Add a key in the Vault and accept the install-hook banner

✨ **Delivers Highlight 1: one-click import for keys and accounts** — real credentials only enter the local Vault; what's distributed daily is a revocable route token.

In the **Vault** page (sidebar **My Vault**, or `aikey web --vault`) add a key. Four paths:


- **A) API Key (Web)**: click "Add Key", fill alias + provider + the real key → save.
> Vault page + top Install-hook banner + the "Add Key" form
![alt text](assets/personal-step3-add-key-form.png)


- **B) API Key (CLI)**:
> Follow the CLI prompts to complete the add flow.
![alt text](assets/personal-step3-cli-add-key.png)

- **C) Batch import**:
> Sidebar **Import**, or run `aikey web --import` to open the bulk-import page.
![alt text](assets/personal-step3-batch-import.png)

- **D) OAuth account** (Pro / Max / Plus subscriptions): click OAuth login, the browser handles authorization and writes back. CLI equivalent:

  ```bash
  aikey auth login claude        # Claude (Anthropic)
  aikey auth login codex         # Codex / ChatGPT (OpenAI)
  aikey auth login kimi_code     # Kimi Code (api.kimi.com); 'kimi' alias still works
  ```

> After adding, the top of the page shows an **"Install hook" banner** — click it to install. The shell hook is written to your local rc file so that `claude` / `codex` / `kimi` and other CLIs auto-pick up the active key in new terminals.
![alt text](assets/personal-step3-install-hook-banner.png)


> Vault key list after adding (API Keys + OAuth accounts side by side)
![alt text](assets/personal-step3-vault-key-list.png)

### 4. Run claude and read the cost receipt after the chat

✨ **Delivers Highlights 2 + 3: multi-window multi-account work + usage trends and token cost insight**

Open a **new** terminal (so the hook is loaded), then:

```bash
claude        # or kimi / codex — depending on what you added to the Vault
```

When the session ends, AiKey prints a **cost receipt** in the terminal — the session's token usage and estimated cost. No need to wait for the monthly invoice; cost stays in real-time view.

> Claude CLI interactive session in a fresh terminal
![alt text](assets/personal-step4-claude-interactive-en.png)

> Cost receipt printed in the terminal after claude exits (tokens used + estimated cost)
![alt text](assets/personal-step4-cost-receipt-en.png)

### 5. Switch keys (Web or CLI)

✨ **Delivers Highlight 4: seamless account switching when quota runs out** — no need to exit the running `claude` session; the next request picks up the new binding.

> **Web side**: click any key in the Vault page to set it active — affects every new CLI window.
![alt text](assets/personal-step5-web-switch-active.png)

**CLI global switch** (persistent, writes to `active.env`):

```bash
aikey use my-key                  # global active key switch
```

**CLI temporary switch** (current terminal only):

```bash
aikey activate my-key             # current-terminal env only; close terminal to revert
(my-key) ~/Projects %             # the prompt shows the active key

aikey deactivate                  # restore global settings immediately
```

> Terminal output of `aikey use my-key`
![alt text](assets/personal-step5-cli-aikey-use.png)

### 6. View usage statistics

✨ **Delivers Highlight 2: usage trends and token cost insight**

```bash
aikey web                # opens the console → Usage / Dashboard
```

The console surfaces per-key, per-account, per-protocol usage trends plus token structure (cache token share, request volume, provider distribution) — useful for pre/post-release cost review and optimization.

> aikey web Usage / Dashboard main view (token trend + provider distribution)
![alt text](assets/personal-step6-usage-dashboard.png)

---

## Trust Check (degrade detection)

> Step 7 in the personal flow — **installed by default since rc.5**.
> If you ran the install with `--no-degrade-detector`, skip this section
> or run `aikey app install degrade-detector` to add it back.

✨ **Delivers Highlight 7: spot model degradation before it hits your work**

After the standard install, the `trust-local` service runs on
`http://127.0.0.1:8801` and the web console shows a new sidebar entry:
**Quality → Trust Check**.

> **Realtime detection toggle stays OFF by default**: the service is
> installed but doesn't score chat traffic until you click the toggle
> in `/user/trust-check` (top-right). Manual `Check` button always
> works regardless of the toggle.

```bash
aikey web                       # sidebar → Quality → Trust Check
```

Per credential the page shows:

- **Combined score 0–100** (Trusted ≥ 80, Suspect 60–79, Risky < 60)
- Sub-scores **L1** (local rhythm fingerprint) / **L2** (cross-user quorum) / **L3** (cascade verify against private question bank)
- Per-row **Check** button — kicks off an L3 cascade (~30 s; rate-limited to 1 run / 24 h / credential; the inline "Retry now" passes `force=true` to bypass)
- Header **Run checks** — fires the same verify serially across every visible row
- **BAND** tab — same rows grouped by trust band (Risky → Suspect → Trusted → Unverified, sorted by most-recent check inside each band)
- Click any row — slide-over drawer with the last 10 cascade runs + per-question scoring detail

CLI equivalents:

```bash
aikey trust status              # list mode (same as the page table)
aikey trust verify <alias>      # = pressing "Check" on a row
aikey trust history <alias>     # = expanding a row's drawer
aikey trust sync                # pull fresh baseline / question bank
```

### Supported scope (MVP)

| Provider / model | Status |
|---|---|
| Anthropic — `claude-opus-4-7`, `claude-sonnet-4-6` | ✅ Full: L1 rhythm fingerprint + L3 cascade against bundled question bank |
| Anthropic — other models (e.g. `claude-haiku-4-5`) | 🟡 L1 rhythm only; L3 returns `inconclusive` until that model's question bank ships |
| OpenAI / Kimi / Gemini / OpenAI-compatible gateways | ⏳ Out of MVP — the proxy observer skips scoring for these protocols, so credentials still work but won't carry a trust score |

Multi-protocol support is on the roadmap. The harder part isn't the
code — it's that each protocol's streaming-rhythm distribution is
different (Anthropic 1-3 tokens/frame, OpenAI 1-2, Gemini 5-20), so
each new protocol needs its own baseline collected from 1000+ real
samples.

### Recovery: "trust-local is offline"

If the page shows the red offline banner, the service is dead. Restart:

```bash
# macOS
launchctl kickstart -k gui/$UID/aikey.trust-local
# Linux
systemctl --user restart aikey.trust-local
# Or re-run the bundled service installer (idempotent):
curl -fsSL https://raw.githubusercontent.com/aikeylabs/ai-degrade-detector/main/scripts/install_service.sh | bash
```

### Removing Trust Check

Want a clean uninstall (e.g. don't need degrade detection on this
machine)? One command stops the service, removes the binary, and
wipes the vault rows — reversible via `aikey app install` later:

```bash
aikey app uninstall degrade-detector
```

---

## Use Your Own API Key

> ⚠️ **`aikey login` and `aikey auth login` are two different commands — don't confuse them:**
> - `aikey login` (alias of `aikey account login`) — **log in to the AiKey control service** (team edition: connect the CLI to a server). Not needed on the personal edition.
> - `aikey auth login <claude/codex/kimi>` — **add a provider OAuth account to your local vault** (Claude Pro/Max, ChatGPT Plus, Kimi Code subscriptions — no API key required).

Add your API key to the local encrypted vault:

```bash
aikey add my-key
```

Activate it:

```bash
aikey use my-key
```

Then use your usual tools — the local proxy injects the key for you:

```bash
claude              # Anthropic Claude CLI
codex               # OpenAI Codex CLI
kimi                # Kimi CLI (works for both kimi(kimi-code) and kimi(moonshot))
```

Keys are routed through the local proxy. Real credentials are never exposed.

### Sign in to a provider via OAuth (no API key needed)

If you have a Claude Pro/Max, ChatGPT Plus, or Kimi subscription, run `aikey auth login <provider>` to **add the provider's OAuth account into your local vault** — no API key required:

```bash
aikey auth login claude       # Claude (Anthropic) — Pro / Max subscription
aikey auth login codex        # Codex / ChatGPT (OpenAI) — Plus / Pro subscription
aikey auth login kimi_code    # Kimi Code (api.kimi.com); the 'kimi' alias still works
```

> `auth login` here **adds a provider credential to the local vault** — it is NOT the same as the team edition's `aikey login` (which connects the CLI to the AiKey control service).

Provider OAuth accounts and API keys are both switched via `aikey use`.

List every key you've added:

```bash
aikey list
```

View a key's route configuration (for third-party clients):

```bash
aikey route
```

Open the Web Console to see key status, usage, and more management features:

```bash
aikey web
```

The sidebar's **My Vault** page (or `aikey web --vault`) lists every Personal
API Key and OAuth account you have locally. You can rename, one-shot reveal
(client-side 60-second auto-mask), delete, or add keys through the same
unlock session as the Import page. OAuth session tokens are **never** revealed
in the browser — to add an OAuth account, run `aikey auth login <provider>`.

---

## CI / Scripts (Non-Interactive)

No shell hook needed. Works with GitHub Actions, cron jobs, etc.

```bash
aikey run -- python eval.py
```

---

## Daily Commands

```bash
aikey list              # View all keys
aikey use               # Switch the active key
aikey whoami            # Current identity + active key
aikey env               # View active.env (shell-facing) and proxy.env (aikey-proxy process)
aikey env set KEY=VAL   # Merge-write proxy.env (e.g. https_proxy / http_proxy)
aikey doctor            # One-click health check
aikey test --all        # Probe every credential in the vault (see below)
aikey hook uninstall    # Stop the takeover: restore shell + third-party CLI configs (see below)
```

> Tip: the installer also creates an `ak` symlink to `aikey`. Every command works under the short alias (e.g. `ak env`, `ak use`, `ak doctor`).

---

## Stop the Takeover (restore shell & third-party CLI configs)

"Takeover" is what the install-hook enables: aikey routes `claude` / `codex` / `kimi` / Claude Desktop through the currently active key. To undo it, one command:

```bash
aikey hook uninstall
```

It does three things — each idempotent, each backed up before touching anything:

1. **Shell wiring**: strips the aikey marker block from every shell startup file (`~/.zshrc`, `~/.bashrc`, `~/.bash_profile`, PowerShell profile), backing up each file it edits. The `~/.aikey/hook.*` files are kept, so `aikey hook install` can re-wire at any time.
2. **codex / kimi configs**: their aikey-routed config sections only work WITH the hook env, so uninstall reconciles them too — interactive terminals get a prompt to strip the aikey-managed region; non-interactive runs get a loud warning instead of a silent trap.
3. **Claude Desktop**: restored to the official direct-connect config. Desktop reads a persisted config file, not env vars — left un-restored it would break silently once the proxy stops, with nothing to diagnose in the GUI.

Boundaries and companion commands:

```bash
aikey deactivate          # Restore env vars in THIS terminal immediately (new terminals no longer load the hook anyway)
export AIKEY_NO_HOOK=1    # Temporary bypass without uninstalling: aikey skips hook actions for this session
aikey hook install        # Changed your mind? Re-wire any time.
```

> Already-open terminals keep the env vars they have until you open a new one — a running `claude` session is never interrupted.

---

## Connectivity Test

```bash
aikey test                # Probe each active Primary binding
aikey test my-key         # One row per protocol the named key supports
aikey test --all          # Every credential in the vault (personal / team / OAuth)
```

Each row runs **Ping(D) → Ping(proxy) → API → Chat** in sequence. Multi-protocol personal keys (e.g. an aggregator key declaring `anthropic + openai + kimi`) expand to one row per protocol — same Key column, different Protocol column; team keys and OAuth accounts each produce one row because their provider is fixed by the credential itself. `--all` is the right call after bulk-importing keys or when triaging "this one key suddenly stopped working" — the Key column surfaces friendly aliases (`key-335923591-0011-1` / email), not internal vk_id / account_id tails.

---

## Advanced: Temporary Key Switching

Use `aikey activate` to temporarily switch the active key in the current terminal only. Unlike `aikey use`, it does **not** modify global settings or `active.env` — closing the terminal reverts everything.

```bash
aikey activate my-key               # Activate in the current terminal
(my-key) ~/Projects %               # The prompt shows the active key

aikey activate team-key --provider openai   # Switch to another key
(team-key) ~/Projects %

aikey deactivate                     # Restore global settings immediately
~/Projects %
```

- `activate` sets shell env vars via `eval` — requires the shell hook (installed by `aikey use`).
- `deactivate` restores `active.env` global settings instantly (no need to wait for the next prompt).
- Multiple terminals can each activate different keys simultaneously.
- `--provider` is required when the key supports multiple providers.

---

## Advanced: Use Keys in Third-Party AI Clients

Configure Cursor, OpenCode, Continue, or any AI client that supports custom `base_url` + `api_key`:

```bash
aikey route                     # List all route tokens
aikey route my-key              # Show copy-paste config for a specific key
```

Example output:

```
  # Configuration for: my-key (personal, anthropic)
  base_url:  http://127.0.0.1:27200/anthropic
  api_key:   aikey_vk_b82ef1d49c3a7e08...
```

Paste `base_url` and `api_key` into your client settings. The proxy routes requests by token — real credentials stay in the vault.

### OpenCode

Create or edit `~/.config/opencode/opencode.jsonc`:

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
  "model": "anthropic/claude-opus-4-7"
}
```

Pick the official `anthropic` provider, point `baseURL` at the local proxy, then enter the API key shown by `aikey route my-key` in OpenCode.

---

## Troubleshooting

```bash
aikey doctor            # Auto-check common issues
aikey proxy restart     # Restart if the proxy is stuck
aikey key sync          # Force-sync key status
```

### Windows-specific

#### Install on Windows (PowerShell — native, **no** WSL required)
(Windows compatibility is still being polished — stay tuned.)

> Stage 4 windows-compat. Minimum: Windows 10 1809+ / Windows 11 / Windows
> Server 2019+. Works on PowerShell 7+ (recommended) or Windows
> PowerShell 5.1.

```powershell
# Download the installer bundle (entrypoint + lib/*.ps1), extract, run
# Auto-resolves the latest tag via GitHub API — no hardcoded version
$Tag  = (Invoke-RestMethod "https://api.github.com/repos/aikeylabs/launch/releases/latest").tag_name
$Bare = $Tag.TrimStart('v')
iwr "https://github.com/aikeylabs/launch/releases/download/$Tag/aikey-installer-windows_${Bare}.zip" -OutFile "$env:TEMP\aikey-inst.zip"
Expand-Archive -Path "$env:TEMP\aikey-inst.zip" -DestinationPath "$env:TEMP\aikey-inst" -Force
& "$env:TEMP\aikey-inst\local-install.ps1"     # without -Version, installer auto-resolves the latest tag
```

> Why "download zip + extract + run" instead of a single `iwr | iex` line:
> the `.ps1` entrypoint dot-sources `lib/{health,service,backup}.ps1`
> from `$PSScriptRoot/lib`, so the libs must be on disk next to the
> entrypoint at run time. The zip preserves that layout. Functionally
> equivalent to `curl ... | sh` on macOS / Linux.

Installs to `%LOCALAPPDATA%\Aikey\bin` and appends it to the current
user's `PATH`. The installer tightens NTFS ACLs on the install dir to
owner-only — the encrypted vault is never readable by other users on
the same machine.

For PowerShell hook auto-activation (after `aikey use foo`, new
PowerShell sessions automatically pick up the env vars), run after
install:

```powershell
aikey hook install
```

This appends a single marker block to `$PROFILE.CurrentUserAllHosts`
(asks before touching it; pass `-Yes` to accept).

---

| Symptom | Likely cause + fix |
|---|---|
| `aikey hook update` returns EACCES on `hook.ps1` | Another PowerShell session has the file open. Close the other PS windows; **don't** use sudo — elevation does not solve a handle lock. |
| `aikey: command not found` right after install | The new PATH only takes effect in **new** PowerShell windows. Open a fresh terminal, or restart the current one. |
| `aikey use <alias>` runs but env vars don't appear in the next prompt | The PowerShell hook isn't installed. Run `aikey hook install` once (writes to `$PROFILE.CurrentUserAllHosts`). |
| `aikey-proxy.exe` upgrade-in-place fails with "file in use" | Stop the running proxy first: `aikey proxy stop` (clean exit), then re-run install. If a stale `.exe` lingers, force-kill it via `Stop-Process -Force`. |
| Claude Code interactive mode ignores `ANTHROPIC_API_KEY` | Known issue — `aikey use` writes a sentinel into `~/.claude.json` `customApiKeyResponses.approved` to pre-approve the env var. If you cleared `.claude.json` manually, re-run `aikey use <anthropic-alias>`. See bugfix `2026-04-29-claude-interactive-ignores-anthropic-api-key.md`. |

Reinstall = upgrade. Just run:

```bash
curl -fsSL https://github.com/aikeylabs/launch/releases/latest/download/latest-install.sh | sh
```

**Environment management (`aikey env` / `ak env`):**

AiKey keeps two env files:

- `~/.aikey/active.env` — **shell-facing** derived env (the hook injects the active key / endpoint into `claude` / `codex` / `kimi`; written by `aikey use`, don't edit by hand).
- `~/.aikey/proxy.env` — **aikey-proxy process** env (outbound HTTP proxy, custom endpoint overrides; user-managed).

```bash
aikey env                  # Show both env files (sensitive values masked; proxy.env shows entry count + config hash)
```

`aikey env` also shows **"Upstream proxy egress (running daemon)"** — the live, layer-by-layer egress decision fetched from the running proxy: 1. user-set upstream proxy (web Settings) > 2. explicit `proxy.env` config > 3. the OS system proxy (auto-detected on macOS/Windows, refreshed live) > 4. shell-inherited env vars (fallback only — your `.zshrc` exports do **not** pin the egress; a system-proxy change still applies automatically), plus the final effective proxy for AI providers. This reflects what the daemon **actually uses** (its env is captured at spawn and usually differs from your shell). If the proxy isn't running, the section says so and how to start it.

**Behind an outbound proxy (e.g. github / providers unreachable without VPN):**

```bash
# Option A — space-separated KEY=VALUE pairs (simplest):
aikey env set -- http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

# Option B — paste a shell-export snippet, but ALWAYS wrap in single quotes:
aikey env set -- 'export https_proxy=http://127.0.0.1:7890; export http_proxy=http://127.0.0.1:7890; export all_proxy=socks5://127.0.0.1:7890'

aikey proxy restart        # Required after editing proxy.env
```

> ⚠️ **Common pitfall**: without the surrounding `'...'`, your shell (zsh/bash) interprets every `;` as a command separator. Only the first `export` reaches `aikey`; the others run inside your current shell, never touching `proxy.env`. Running `aikey env` afterward will show the missing keys under "Shell env (inherited by proxy)" instead of "Proxy env" — that's the diagnostic signal.

> `aikey env set` only writes `proxy.env` — it **does not** touch `active.env`. It merges into the existing file instead of replacing it, and accepts `KEY=VAL` pairs (multiple, optional `export` prefix, semicolon-separated **inside a quoted string**). If the existing `proxy.env` is unparseable it stops and asks you to fix it first.


**Wipe data and reinstall:**

```bash
# Danger: clear everything first, then install the latest version
# (in pipe mode the prompt reads y/N from /dev/tty; pass --yes to skip)
curl -fsSL https://github.com/aikeylabs/launch/releases/latest/download/latest-install.sh | sh -s -- --clear

# Wipe data and install a pinned version (replace <TAG> with the version to pin, e.g. v1.0.0-rc.3)
curl -fsSL https://github.com/aikeylabs/launch/releases/download/<TAG>/local-install.sh | sh -s -- --version <TAG> --clear
```


**Uninstall only (no reinstall):**

```bash
# Danger: removes ~/.aikey, third-party CLI injections, shell hooks,
# and OS keychain entries — but does not reinstall.
curl -fsSL https://github.com/aikeylabs/launch/releases/latest/download/uninstall.sh | sh -s -- --yes
```
