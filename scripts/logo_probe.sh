#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <url1> [url2 ...]"
  exit 1
fi

for u in "$@"; do
  echo "--- $u"
  curl -L -s --max-time 12 -o /tmp/logo_probe.bin -w "%{http_code} %{size_download}\n" "$u"
done
