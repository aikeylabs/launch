# Contributing to launch

This repo hosts the **public install scripts** that `curl | sh` against. The scripts here are short shell entrypoints that download the real installer from the release bucket and run it. Versioned release tarballs are NOT stored in this repo — they live on GitHub Releases of the relevant repos and on the AiKey CDN.

This is intentionally a low-traffic repo. There is no code to refactor here, only install-flow correctness.

## When to send a PR here

- A new install channel (`/i/<channel>`) needs to be added.
- A platform-specific install path (Windows / Linux / macOS) needs a fix because the underlying installer changed.
- The install banner / first-time-user prompt text needs an update.

## When NOT to send a PR here

- "I want to change how AiKey installs on my system" → those changes belong in [aikey-cli](https://github.com/aikeylabs/aikey-cli) (the real installer logic ships with the CLI release).
- "I want to publish a release" → use the release workflow on the source repo (`aikey-cli` etc.), not this one.
- "Bug in the CLI itself" → [aikey-cli/issues](https://github.com/aikeylabs/aikey-cli/issues), not here.

## Local check

```bash
git clone https://github.com/aikeylabs/launch.git
cd launch
# Each install script is a self-contained sh / ps1 file. Read it, dry-run on a throwaway VM:
sh -n install.sh           # syntax check
shellcheck install.sh      # if you have shellcheck
```

We deliberately do not vendor a test harness here — the install scripts are tested end-to-end via the `aikey-cli` release workflow. A breaking change here will show up in the release smoke test, not in this repo's CI.

## PR flow

1. One change per PR. Install scripts are forensically reviewed because they run as `sh` in users' shells.
2. Describe the behavior delta in the PR body. Screenshots of the install output are welcome.
3. If your change adds a new channel code, document it in the PR description — channel codes feed downstream funnel metrics.

## Security

`aikeyfounder@gmail.com`. See [SECURITY.md](https://github.com/aikeylabs/.github/blob/main/SECURITY.md). A vulnerability in an install script is a high-priority report because it runs as the user with shell-level privileges.

## Code of Conduct

[CODE_OF_CONDUCT.md](https://github.com/aikeylabs/.github/blob/main/CODE_OF_CONDUCT.md).
