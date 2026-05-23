# AiKey App Install Manifests

Manifests consumed by `aikey app install <slug>` (aikey-cli ≥ v1.0.x).
See [`roadmap20260320/技术实现/阶段4-增值版/第三方Agent自助接入与应用级Key方案.md` §11.B](https://github.com/aikeylabs/aikeylabs/blob/main/roadmap20260320/技术实现/阶段4-增值版/第三方Agent自助接入与应用级Key方案.md) for the design.

## How aikey-cli uses these files

1. CLI has a compile-time `TRUSTED_APPS` allow-list of
   `(slug, manifest_url, manifest_sha256)` triples
   ([aikey-cli/src/commands_app/install.rs](https://github.com/aikeylabs/aikey-cli/blob/main/src/commands_app/install.rs)).
2. On `aikey app install <slug>`, CLI fetches the manifest URL,
   verifies its SHA-256 against the built-in hash, and curl-pipes the
   `service_installer.url` to the user's shell.
3. The plugin's `service_installer.url` is the trust handoff — the
   plugin owns vault registration, binary download, service registration.

The trust anchor is the **CLI binary** (it contains the manifest URL +
SHA-256). A compromised CDN cannot serve a substituted manifest.

## Releasing a new manifest

Manifests are distributed via GitHub Release tags on **this** repo
(`aikeylabs/launch`). Use tag form `manifests-vX.Y.Z`.

To publish a new release:

```bash
cd /path/to/aikeylabs/launch

# 1. Update / add the manifest file(s) in manifests/
#    Verify schema_version, slug, version, service_installer.url.

# 2. Compute the SHA-256 — this is what gets pinned in CLI.
shasum -a 256 manifests/degrade-detector.manifest.json
# → <64-hex-digest>

# 3. Tag + push.
git add manifests/
git commit -m "manifests-v1.0.0: degrade-detector v1.0.0"
git tag -a manifests-v1.0.0 -m "App manifests v1.0.0"
git push origin main --tags

# 4. Create the release with the file attached.
gh release create manifests-v1.0.0 manifests/*.manifest.json \
    --title "App manifests v1.0.0" \
    --notes "First-party degrade-detector v1.0.0"

# 5. Update aikey-cli's TRUSTED_APPS entry with the SHA-256 from step 2.
#    File: aikey-cli/src/commands_app/install.rs
```

## Current manifests

| Slug | Version | SHA-256 |
|---|---|---|
| `degrade-detector` | v1.0.0-rc.5 | `39de932ff058b2d129fea82c77a229695564ae53c474f7d7d66490efda5cc5f3` |

(Recompute with `shasum -a 256 manifests/<slug>.manifest.json` after any
edit. Pre-tag fingerprint above is provisional until `manifests-v1.0.0`
is published.)
