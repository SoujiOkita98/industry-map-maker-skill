---
name: anime-industry-map-maintainer
description: Maintain and improve a single-file Anime Industry Map (index.html): research-backed node/edge updates, evidence-tiered relationship modeling, USD-only market annotations, logo quality fixes, readability/layout tuning, and release-safe cleanup for public GitHub sharing.
---

# Anime Industry Map Maintainer

Use this skill when updating `index.html` in this repo (graph data + rendering + UX) and when preparing the project for public release.

## Scope

- Data updates:
  - `LAYERS`, `NODES`, `CONNECTIONS`, `GROUPS`, `ACG_AI_PROFILE`
- Visual/interaction updates:
  - readability, controls, filtering, layout/scatter, legend
- Research quality:
  - evidence tiers (`FACT-H`, `FACT-M`, `POTENTIAL`, `HYP`)
  - USD-only market text
- Public-release hygiene:
  - remove local-path leakage
  - avoid shipping local agent config

## Agent Pairing Model (important)

This skill is intended to be used by Codex/Claude Code while the agent's working directory is this repository root.

Best practice:

1. Agent reads `SKILL.md` first.
2. Agent inspects `index.html` data blocks before changing rendering logic.
3. Agent applies small, verifiable patches.
4. Agent runs syntax + integrity validation commands before finalizing.

## Quick Start

```bash
# from repo root
python3 -m http.server 8000
# open http://localhost:8000/index.html
```

## Ground Rules

1. Keep runtime dependency-free (single static HTML).
2. Prefer primary sources for factual edges.
3. Do not mix currencies in map text (USD only).
4. Keep hypotheses visually and semantically distinct from facts.
5. Preserve left->right value-chain reading order.

## Data Model Conventions

### Nodes

- Required: `id`, `name`, `layer`, `x`, `y`, `size`, `type`
- Optional: `status`, `revenue`, `mc`, `funding`, `domain`, `logo`, `desc`, `ips`
- Logo source priority:
  1. explicit `logo`
  2. favicon from `domain`
  3. clearbit fallback
  4. SVG letter fallback

### Connections

- Keep `type` from existing vocabulary (`subsidiary`, `license`, `distribute`, `tech`, `influence`, etc.)
- Evidence mapping is currently computed in `getConnMeta(conn)`:
  - `fact/high` -> `FACT-H`
  - `fact/med` -> `FACT-M`
  - `potential/med` -> `POTENTIAL`
  - `hypothesis/low` -> `HYP`

When uncertain, downgrade to `potential` or `hypothesis`.

## Logo Sourcing and Validation

Preferred source order:

1. Official company brand/media/IR assets
2. Official site-hosted logo file (`logo.svg/png/webp`)
3. Google favicon from `domain`
4. Clearbit fallback

Use explicit `node.logo` when fallback logos are wrong or blurry.

Example:

```js
{
  id: "kadokawa",
  domain: "kadokawa.co.jp",
  logo: "https://static.kadokawa.co.jp/common/img/logo_kadokawa.png"
}
```

Quick logo checks:

```bash
curl -L -s -o /tmp/logo.bin -w "%{http_code} %{size_download}\n" "https://example.com/logo.png"
```

```bash
for u in "https://example.com/logo.svg" "https://www.google.com/s2/favicons?domain=example.com&sz=256"; do
  echo "--- $u"
  curl -L -s -o /tmp/logo.bin -w "%{http_code} %{size_download}\n" "$u"
done
```

Script helper:

```bash
bash scripts/logo_probe.sh "https://example.com/logo.svg" "https://www.google.com/s2/favicons?domain=example.com&sz=256"
```

## Importance Function (logo salience)

Logo prominence is derived from:

- ACG relevance (layer + `ACG_AI_PROFILE`)
- Fame proxy (`ips` count)
- Network centrality (connection degree)
- Volume proxies (`revenue`, `mc`, `funding`)
- Base visual size

If changing weights, keep the function bounded `[0,1]` and validate small/large nodes at default zoom.

## Evidence & Research Workflow

1. Start with high-risk edges first:
  - ownership, investment %, production/distribution claims
2. Require dated source when time-sensitive.
3. For non-contract application edges (AI startup -> studio/platform), label as `POTENTIAL`.
4. Keep speculative trend links in `HYP` and hidden by default unless user asks.

When adding strict evidence tracking, attach per-edge metadata:

- `source_url`
- `as_of`
- `evidence_type` (`official_filing`, `official_announcement`, `case_study`, `inference`)
- `confidence` (`high`, `med`, `low`)

Use `evidence_log_template.csv` as the default record format.

## Public Release Hygiene

Before publishing:

1. Remove local absolute paths from docs/examples.
2. Ensure `.claude/` is ignored (local-only).
3. Check for secrets and obvious private endpoints.

Scan command:

```bash
rg -n "(/Users/|api[_-]?key|secret|token|password|BEGIN [A-Z ]+ KEY|\\.claude|manus\\.space)"
```

## Validation Commands (must run after edits)

```bash
# 1) JS syntax check
awk '/<script>/{flag=1;next}/<\\/script>/{flag=0}flag' index.html > /tmp/map.js
node --check /tmp/map.js
```

```bash
# 2) Node/edge integrity
node - <<'NODE'
const fs=require('fs'),vm=require('vm');
const s=fs.readFileSync('index.html','utf8');
const c=vm.runInNewContext(s.match(/const CONNECTIONS = \[(.*?)\];/s)[0]+'; CONNECTIONS;');
const n=vm.runInNewContext('(()=>{'+s.match(/const CREATOR_LOGO = `[\s\S]*?`;/s)[0]+s.match(/const NODES = \[(.*?)\];/s)[0]+'; return NODES;})()');
const ids=new Set(n.map(x=>x.id));
const missing=c.filter(e=>!ids.has(e.from)||!ids.has(e.to));
console.log({connections:c.length,nodes:n.length,missing:missing.length});
NODE
```

Or use one command:

```bash
bash scripts/validate_map.sh
```

## Manual QA Checklist

- Default view is legible (labels + line contrast).
- `All Lines` default behavior is correct.
- `High-Confidence Only`, `Show Hypotheses`, `Investable View` interact correctly.
- Legend collapse works.
- Known tricky logos load (e.g., Kadokawa, Trigger).
- Reset view centers the current scattered layout.

## Safe Patterns for Future Agents

- Use small focused patches rather than large rewrites.
- Do not randomize layout at runtime; use deterministic jitter only.
- Keep market claims conservative and source-driven.
- If data quality is unknown, expose uncertainty in labels instead of guessing.
