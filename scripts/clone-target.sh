#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: scripts/clone-target.sh https://github.com/OWNER/REPOSITORY[.git]" >&2
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
destination="$root_dir/workspaces/${owner}-${repo}"

if [[ -e "$destination" ]]; then
  echo "error: destination already exists: $destination" >&2
  exit 73
fi

echo "Cloning untrusted source into: $destination"
echo "No target build, hook, script, or application will be executed."
git -c core.hooksPath=/dev/null clone --no-recurse-submodules -- "$url" "$destination"
git -C "$destination" config core.hooksPath /dev/null
printf '%s\n' "$destination"
