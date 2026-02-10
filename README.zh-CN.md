# Industry Map Maker Skill

[English](README.md) | [简体中文](README.zh-CN.md)

<p align="center">
  <a href="https://soujiokita98.github.io/industry-map-maker-skill/">
    <img src="assets/thumbnail.png" alt="Industry Map Maker Demo" width="960" />
  </a>
</p>

## 在线预览

[https://soujiokita98.github.io/industry-map-maker-skill/](https://soujiokita98.github.io/industry-map-maker-skill/)

## 给任意 Agent 的一行指令

```text
Read SKILL.md and then improve index.html with only high-signal changes (USD-only numbers, correct FACT-H/FACT-M/POTENTIAL/HYP edges, better logos), run bash scripts/validate_map.sh, and return changes + rationale + confidence.
```

## 这个仓库是什么

这是一个公开、可复用的行业关系图样板仓库，专门给 AI agent 学习和执行。

- 核心产物：`index.html`（单文件交互地图）
- 核心规则：`SKILL.md`（agent 执行说明）
- 当前示例：Anime/ACG（可替换为任何行业）

## 1 分钟启动

```bash
git clone https://github.com/SoujiOkita98/industry-map-maker-skill.git
cd industry-map-maker-skill
python3 -m http.server 8000
```

打开：[http://localhost:8000/index.html](http://localhost:8000/index.html)

## 与任意 Agent 一起用

把下面这段直接贴给 agent：

```text
Read SKILL.md first. Then improve this map with high-signal changes only.
Requirements:
1) Keep all money values in USD.
2) Classify each new edge as FACT-H / FACT-M / POTENTIAL / HYP.
3) Use high-quality official logos whenever possible.
4) Validate before finishing with: bash scripts/validate_map.sh.
Return: (a) what changed, (b) why, (c) confidence and sources for major claims.
```

## OpenClaw（可选）

如果你用 OpenClaw，且支持导入 skill/repo，可直接使用这个仓库地址：

```text
https://github.com/SoujiOkita98/industry-map-maker-skill
```

如果你的 OpenClaw 是基于本地目录工作，就把本仓库设为工作目录，并先让它读取 `SKILL.md`。

## 目录（简版）

```text
index.html                         # 交互地图
SKILL.md                           # agent 执行手册（先读）
scripts/validate_map.sh            # 完整性 + 敏感信息检查
scripts/logo_probe.sh              # logo 链接探测
docs/AGENT_PROMPT_TEMPLATES.md     # 更多提示词
templates/evidence_log_template.csv
research/2026-02-09/               # 示例研究快照
```

## 质量标准

- 关系边有证据分层，不是随意连线
- 市场和财务口径统一为 USD
- 可读性优先（字体、层次、线条）
- 每次提交前可复现验证

## 发布与预览

仓库已配置 GitHub Pages（`.github/workflows/deploy-pages.yml`）。
推送到 `main` 后会自动更新预览。
