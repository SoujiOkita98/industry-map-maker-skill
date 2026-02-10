---
name: industry-map-maker-skill
description: Maintain a single-file interactive industry map (`index.html`) with evidence-tiered relationships, clean visual hierarchy, strong logo quality, USD-normalized market text, and publish-ready repository hygiene.
---

# Industry Map Maker Skill

Use this skill when an agent is editing this map repository. The anime/ACG map is only a showcase; the workflow is general.

## Mission

Deliver high-signal map updates that are:
- fact-aware
- visually readable
- easy to validate
- safe to publish

## Non-Negotiables

1. Keep runtime dependency-free (single static `index.html`).
2. Keep financial/market values in USD only.
3. Classify uncertain links as `POTENTIAL` or `HYP`.
4. Prefer primary sources for ownership/distribution/investment claims.
5. Use official logo assets first; avoid blurry/wrong-brand logos.
6. Run validation before finishing.

## Fast Operating Loop

1. Read `index.html` data blocks first (`LAYERS`, `NODES`, `CONNECTIONS`).
2. Make a small scoped patch (data or UI, not giant rewrites).
3. Validate with `bash scripts/validate_map.sh`.
4. Report what changed + why + confidence level.

## Build a New Map Page (from scratch)

When asked to create a similar presentation page for a new industry, follow this exact structure:

1. Start from this repository `index.html` as the base (do not introduce frameworks).
2. Replace only data blocks first:
   - `LAYERS` (value chain blocks + market text in USD)
   - `NODES` (companies/startups with `domain`/`logo`/metrics)
   - `CONNECTIONS` (typed links + clear labels)
3. Keep core interaction model:
   - pan/zoom canvas
   - searchable nodes
   - edge visibility toggles
   - detail side panel
   - legend (collapsible)
4. Keep visual readability constraints:
   - high contrast labels
   - non-overlapping major clusters (scatter if needed)
   - line opacity visible by default
   - important nodes visually larger
5. Only after data quality is stable, tune layout and style.
6. Run `bash scripts/validate_map.sh` and manually QA in browser.

Definition of done for a new page:
- loads as a single static HTML
- relationships are evidence-tiered
- logos are mostly official/high quality
- market/financial text is USD-only
- map is readable at default zoom on desktop

## Data Rules

### Nodes

Required fields:
- `id`, `name`, `layer`, `x`, `y`, `size`, `type`

Common optional fields:
- `status`, `revenue`, `mc`, `funding`, `domain`, `logo`, `desc`, `ips`

### Connections

- Reuse current relation vocabulary (`subsidiary`, `license`, `distribute`, `tech`, etc.).
- Keep edge meaning explicit through `type` + `label`.
- In ambiguous cases, downgrade confidence class, do not overstate.

## Evidence Policy

Use these semantics consistently:
- `FACT-H`: high-confidence factual link
- `FACT-M`: medium-confidence factual link
- `POTENTIAL`: plausible application/integration link
- `HYP`: directional hypothesis

For high-risk claims, prefer:
- official IR/SEC filings
- official press releases
- first-party product docs/case studies

## Logo Policy

Source priority:
1. Official brand/press/IR assets
2. Official site logo file (`svg/png/webp`)
3. Domain favicon fallback
4. Clearbit fallback

Helpful probe:
```bash
bash scripts/logo_probe.sh "https://example.com/logo.svg" "https://www.google.com/s2/favicons?domain=example.com&sz=256"
```

## Validation (Required)

Use one command:

```bash
bash scripts/validate_map.sh
```

This checks:
- JS syntax
- node/edge integrity
- quick sensitive-string scan

## Output Format (Agent Response)

Always return:
1. What changed
2. Why it changed
3. Confidence + source basis for key claims
4. Validation result

## Copy-Paste Task Prompt (Recommended)

```text
Read SKILL.md first. Improve this industry map with high-signal changes only.
Requirements:
- USD-only money text
- Correct edge confidence classes (FACT-H / FACT-M / POTENTIAL / HYP)
- High-quality logos (official first)
- Run bash scripts/validate_map.sh before finishing
Output:
- concise change log
- rationale
- confidence and source basis for major claims
```
