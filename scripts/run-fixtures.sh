#!/usr/bin/env bash
set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
exec ruby "$root_dir/scripts/check-fixtures.rb" "$@"
