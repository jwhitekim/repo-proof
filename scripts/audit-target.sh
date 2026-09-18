#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: scripts/audit-target.sh https://github.com/OWNER/REPOSITORY[.git]" >&2
  exit 64
fi

url=$1
if [[ ! "$url" =~ ^https://github\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/?$ ]]; then
  echo "error: only a GitHub HTTPS repository URL is accepted" >&2
  exit 65
fi

owner=${BASH_REMATCH[1]}
repo=${BASH_REMATCH[2]}
repo=${repo%.git}
if [[ -z "$repo" ]]; then
  echo "error: repository name is empty" >&2
  exit 65
fi

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
"$root_dir/scripts/clone-target.sh" "$url"

workspace="$root_dir/workspaces/${owner}-${repo}"
report_dir="$root_dir/reports/$repo"
mkdir -p "$report_dir"

printf '\nAudit preparation complete. Target code has not been executed.\n'
printf 'Workspace: %s\n' "$workspace"
printf 'Report directory: %s\n' "$report_dir"
printf 'Next required stage: run repository-recon and write %s/repository-context.json\n' "$report_dir"
printf 'Protocol: %s/docs/orchestration.md\n' "$root_dir"
