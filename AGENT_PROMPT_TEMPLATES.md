# Agent Prompt Templates

Use these prompts with Codex or Claude Code while the working directory is this repo.

## 1) Add startups (research-backed)

```text
Read SKILL.md first.
Add 3 AI startups strongly relevant to anime/ACG.
For each startup:
- add node with high-quality logo strategy
- add connections with correct FACT/POTENTIAL/HYP behavior
- keep all market and financial text in USD
Run bash scripts/validate_map.sh before finishing.
Summarize sources and confidence for each new edge.
```

## 2) Cross-validate high-risk edges

```text
Read SKILL.md first.
Audit all ownership/investment/distribution edges in index.html.
Prefer primary sources (IR, SEC, official announcements).
Classify uncertain edges as POTENTIAL or HYP.
Record results in evidence_log_template.csv format (create a new file with today’s date).
Run bash scripts/validate_map.sh.
```

## 3) Logo quality pass

```text
Read SKILL.md first.
Find nodes with wrong/blurred/missing logos.
Use official logo URLs first, then fallback policy.
Test candidates with bash scripts/logo_probe.sh.
Patch index.html and run bash scripts/validate_map.sh.
```

## 4) Publish-ready cleanup

```text
Read SKILL.md first.
Prepare this repo for public GitHub push:
- check .gitignore coverage
- run sensitive-string scan
- verify README accuracy with current controls and files
- run bash scripts/validate_map.sh
Return a short release checklist.
```
