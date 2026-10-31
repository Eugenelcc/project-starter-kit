# Project Starter Kit

A free, reusable set of project documents and Claude Code agents for building
software with an AI pair, for any stack (web app, bot, API). It gives every
new project the same foundation: what to build, the hard rules, one file per
task, and a pipeline where Claude never assumes and the owner approves every
important step.

**Explainer site:** https://eugenelcc.github.io/project-starter-kit/
**Worked example:** [Spendlygo](https://github.com/Eugenelcc/spendlygo), a
Telegram expense tracker built with this exact process. Every template below
links to Spendlygo's real, filled-in version.

---

## Start a new project with it

1. Click **Use this template → Create a new repository** at the top of this
   page. Name your project and create it.
2. In your new repo, **delete** `site/` and `.github/workflows/pages.yml`.
   They only publish this kit's explainer site. (The workflow is guarded so it
   won't run in your copy anyway.)
3. Replace this `README.md` with your own project's.
4. Fill in the documents in this order: **PRD → GUARDRAILS → CLAUDE →
   (DESIGN) → BACKLOG**. Each file starts with a guidance comment; delete it
   once the file is filled in. Replace every `<placeholder>`.
5. In `WORKFLOW.md` and the agent files, replace `<test command>` and
   `<full CI command>` with your real commands. Create the single CI script
   (e.g. `scripts/ci.sh`) that both you and GitHub Actions run.
6. Add your first item, `B-001`, to `BACKLOG.md` and start the pipeline in
   a Claude Code session: *"Let's start B-001. Follow WORKFLOW.md."*

## What's inside

| File | What it is | Spendlygo's version |
|---|---|---|
| [`PRD.md`](./PRD.md) | **What** to build and **why**: feature IDs (F1…), scope, deferred list, metrics, roadmap | [PRD.md](https://github.com/Eugenelcc/spendlygo/blob/main/PRD.md) |
| [`GUARDRAILS.md`](./GUARDRAILS.md) | The hard rules: 🔴 NEVER / 🟡 ASK FIRST / 🟢 ALWAYS | [GUARDRAILS.md](https://github.com/Eugenelcc/spendlygo/blob/main/GUARDRAILS.md) |
| [`DESIGN.md`](./DESIGN.md) | Optional, UI projects only: tokens, type, motion, components | [DESIGN.md](https://github.com/Eugenelcc/spendlygo/blob/main/DESIGN.md) |
| [`CLAUDE.md`](./CLAUDE.md) | Short operating manual Claude Code loads every session | [CLAUDE.md](https://github.com/Eugenelcc/spendlygo/blob/main/CLAUDE.md) |
| [`WORKFLOW.md`](./WORKFLOW.md) | The pipeline, stage by stage, with the Definition of Ready and Done | [WORKFLOW.md](https://github.com/Eugenelcc/spendlygo/blob/main/WORKFLOW.md) |
| [`BACKLOG.md`](./BACKLOG.md) | The single plan: Now / Next / Later / Drift & debt / Done | [BACKLOG.md](https://github.com/Eugenelcc/spendlygo/blob/main/BACKLOG.md) |
| [`RUNBOOK.md`](./RUNBOOK.md) | Deploy, roll back, health checks, common failures | [apps/server/CLAUDE.md](https://github.com/Eugenelcc/spendlygo/blob/main/apps/server/CLAUDE.md) |
| [`CHANGELOG.md`](./CHANGELOG.md) | What changed per release (Keep a Changelog + SemVer) | — |
| [`docs/specs/TEMPLATE.md`](./docs/specs/TEMPLATE.md) | The one file per task: the handoff between agents | [B-004](https://github.com/Eugenelcc/spendlygo/blob/main/docs/specs/B-004-settings-command.md) |
| [`docs/adr/0000-template.md`](./docs/adr/0000-template.md) | Architecture Decision Record (Nygard format) | [ADR 0002](https://github.com/Eugenelcc/spendlygo/blob/main/docs/adr/0002-supabase-instead-of-renders-postgres.md) |
| [`docs/postmortems/TEMPLATE.md`](./docs/postmortems/TEMPLATE.md) | Blameless incident write-up | — |
| [`.claude/agents/`](./.claude/agents) | Five subagents, one per pipeline stage | [.claude/agents](https://github.com/Eugenelcc/spendlygo/blob/main/.claude/agents) |

## How the orchestration works

```
 0 INTAKE ─▶ 1 REQS ─▶ 2 PLAN ─▶ 3 TEST ─▶ 4 BUILD ─▶ 5 REVIEW ─▶ 6 RELEASE ─▶ 7 CLOSE
             ✋ owner   ✋ owner  failing    until     agent, then
             approves  approves first       green     owner merges ✋
```

- **The main Claude session is the orchestrator.** It talks to the owner,
  "grills" them with small rounds of plain-language questions (each option
  with pros and cons) before anything is written, and launches the
  subagents. Subagents never talk to the owner.
- **Every handoff is a file, never a conversation.** Each task has one file,
  `docs/specs/B-###-<slug>.md`, with sections *Grilling recap →
  Requirements (what) → Build plan (how) → Second opinion → Test report →
  Build notes → Review*. Each agent reads it and writes only its own
  section.
- **Model routing:** Opus thinks, Sonnet does.

| Agent | Model | Stage |
|---|---|---|
| `spec-planner` | Opus | Requirements + Build plan |
| `challenger` | Opus | Independent second opinion on risky items |
| `test-writer` | Sonnet | Failing tests, written first |
| `builder` | Sonnet | Code until the tests pass |
| `reviewer` | Opus | Review against spec and guardrails |

- **Golden rule: never assume.** Unsure → ask the owner.
- **Small fixes** (≤30 lines, no schema, dependency, API or high-risk change)
  may skip the requirements and plan stages, but not tests or review.
- **After 2 failed attempts, stop and escalate.** Production broken? Revert
  first, fix second. Claude opens PRs only when asked, and never merges.

## Cost

Everything here is free: plain Markdown, Claude Code's built-in subagents,
and GitHub Pages (free for public repos) for the explainer site.

## License

[MIT](./LICENSE). Use it, change it, share it.
