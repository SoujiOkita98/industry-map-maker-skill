#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[1/4] JS syntax check"
awk '/<script>/{flag=1;next}/<\/script>/{flag=0}flag' index.html > /tmp/map.js
node --check /tmp/map.js

echo "[2/4] Node/edge integrity check"
node - <<'NODE'
const fs=require('fs'),vm=require('vm');
const s=fs.readFileSync('index.html','utf8');
const c=vm.runInNewContext(s.match(/const CONNECTIONS = \[(.*?)\];/s)[0]+'; CONNECTIONS;');
const n=vm.runInNewContext('(()=>{'+s.match(/const CREATOR_LOGO = `[\s\S]*?`;/s)[0]+s.match(/const NODES = \[(.*?)\];/s)[0]+'; return NODES;})()');
const ids=new Set(n.map(x=>x.id));
const missing=c.filter(e=>!ids.has(e.from)||!ids.has(e.to));
if (missing.length) {
  console.error('Missing endpoints found:', missing.slice(0, 10));
  process.exit(1);
}
console.log({connections:c.length,nodes:n.length,missing:missing.length});
NODE

echo "[3/4] Quick sensitive-string scan"
rg -n "(/Users/|api[_-]?key|secret|token|password|BEGIN [A-Z ]+ KEY|\\.claude|manus\\.space)" . \
  --glob "!scripts/validate_map.sh" \
  --glob "!.git/*" || true

echo "[4/4] Done"
echo "Validation completed."
