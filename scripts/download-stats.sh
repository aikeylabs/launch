#!/usr/bin/env bash
# Rough install-funnel stats from GitHub release download counts.
#
# GitHub only exposes per-asset download counters (no IP, no timestamps),
# so this script can't give exact unique-installs. Instead it surfaces
# several proxy signals per release so you can sanity-check by crossing
# them:
#
#   entry   = latest-install.sh + local-install.sh
#             upper bound; inflated by curl retries, bots, head-only pulls
#   helper  = common.sh / platform.sh / download.sh / state.sh / health.sh
#             / backup.sh / uninstall.sh
#             middle of funnel; downloaded once per real run when the
#             entry script doesn't bundle them inline
#   manifest = manifest.json
#              best proxy for "install reached precheck-pass";
#              fetched exactly once per script run, hard to retry-inflate
#   binary  = aikey-local_* / aikey-local-server_* / aikey-installer-windows*
#             close to "install reached binary-download step";
#             can be inflated by manual asset downloads outside the script
#
#   ~unique = manifest if present, else min(entry, binary)
#             conservative single-number estimate; one user reinstalling
#             N times still counts as N (true per-user dedupe requires
#             a beacon from inside install.sh)
#
# Usage:
#   ./download-stats.sh                       # default repo aikeylabs/launch
#   ./download-stats.sh owner/repo
#   GITHUB_TOKEN=ghp_xxx ./download-stats.sh  # raises rate limit 60 -> 5000/h

set -euo pipefail

REPO="${1:-aikeylabs/launch}"
API="https://api.github.com/repos/${REPO}/releases"

# Fetch every release across pages.
# (macOS bash 3.2 + set -u doesn't tolerate empty arrays; build args inline.)
fetch_all_releases() {
  local page=1
  local all="[]"
  while :; do
    local chunk
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
      chunk=$(curl -fsS -H "Authorization: Bearer ${GITHUB_TOKEN}" "${API}?per_page=100&page=${page}") \
        || { echo "ERROR: GitHub API request failed (rate limit? auth?)" >&2; exit 1; }
    else
      chunk=$(curl -fsS "${API}?per_page=100&page=${page}") \
        || { echo "ERROR: GitHub API request failed (rate limit? auth?)" >&2; exit 1; }
    fi
    local n
    n=$(jq 'length' <<<"$chunk")
    [[ "$n" -eq 0 ]] && break
    all=$(jq -s 'add' <(echo "$all") <(echo "$chunk"))
    [[ "$n" -lt 100 ]] && break
    page=$((page + 1))
  done
  echo "$all"
}

releases=$(fetch_all_releases)

# Classify each asset and aggregate per release.
# Output rows: tag<TAB>entry<TAB>helper<TAB>manifest<TAB>binary<TAB>unique
rows=$(jq -r '
  def classify(n):
    if (n == "latest-install.sh" or n == "local-install.sh") then "entry"
    elif (n | test("^(common|platform|download|state|health|backup|uninstall)\\.sh$")) then "helper"
    elif (n == "manifest.json") then "manifest"
    elif (n | test("^aikey-local(-server)?_.*\\.(tar\\.gz|zip)$")) then "binary"
    elif (n | test("^aikey-installer-windows.*\\.zip$")) then "binary"
    else "other"
    end;

  .[]
  | .tag_name as $tag
  | reduce .assets[] as $a (
      {entry:0, helper:0, manifest:0, binary:0};
      .[classify($a.name)] = (.[classify($a.name)] // 0) + $a.download_count
    )
  | . as $b
  | ( if $b.manifest > 0 then $b.manifest
      else ( [$b.entry, $b.binary] | map(select(. > 0)) | if length == 0 then 0 else min end )
      end ) as $unique
  | "\($tag)\t\($b.entry)\t\($b.helper)\t\($b.manifest)\t\($b.binary)\t\($unique)"
' <<<"$releases")

# Render table with totals.
printf "\nRepo: %s\n\n" "$REPO"
printf "%-20s %8s %8s %10s %8s %10s\n" \
  "release" "entry" "helper" "manifest" "binary" "~unique"
printf -- "---------------------------------------------------------------------\n"

tot_e=0; tot_h=0; tot_m=0; tot_b=0; tot_u=0
while IFS=$'\t' read -r tag e h m b u; do
  [[ -z "$tag" ]] && continue
  printf "%-20s %8d %8d %10d %8d %10d\n" "$tag" "$e" "$h" "$m" "$b" "$u"
  tot_e=$((tot_e + e))
  tot_h=$((tot_h + h))
  tot_m=$((tot_m + m))
  tot_b=$((tot_b + b))
  tot_u=$((tot_u + u))
done <<<"$rows"

printf -- "---------------------------------------------------------------------\n"
printf "%-20s %8d %8d %10d %8d %10d\n" "TOTAL" "$tot_e" "$tot_h" "$tot_m" "$tot_b" "$tot_u"

# Rough conversion hints. Avoid divide-by-zero.
if [[ "$tot_e" -gt 0 ]]; then
  conv_m=$(awk -v m="$tot_m" -v e="$tot_e" 'BEGIN{ printf "%.0f", m*100/e }')
  conv_b=$(awk -v b="$tot_b" -v e="$tot_e" 'BEGIN{ printf "%.0f", b*100/e }')
  printf "\nConversion (vs entry): manifest=%s%%  binary=%s%%\n" "$conv_m" "$conv_b"
fi

cat <<'EOF'

Notes:
  * ~unique is an APPROXIMATION. GitHub does not expose per-user data.
    A user reinstalling N times still counts as N. For true per-machine
    dedupe, emit a one-line beacon from install.sh with a generated UUID.
  * If "helper" is 0 for a release, the entry script probably bundles
    helpers inline -- use manifest/binary as the signal for that release.
  * If "binary" > "entry", users are likely downloading binaries directly
    from the release page without running install.sh.
EOF
