# Project Starter Kit

A free, reusable set of project documents and Claude Code agents for building
software with an AI pair, for any stack (web app, bot, API). It gives every
new project the same foundation: what to build, the hard rules, one file per
task, and a pipeline where Claude never assumes and the owner approves every
important step.

**Explainer site:** https://eugenelcc.github.io/project-starter-kit/ ·
**Playground:** https://eugenelcc.github.io/project-starter-kit/playground.html
(simulate the pipeline, check a task's lane, build a spec file, track setup)
**Worked example:** [Spendlygo](https://github.com/Eugenelcc/spendlygo), a
Telegram expense tracker built with this exact process. Every template below
links to Spendlygo's real, filled-in version.

---

## Start a new project with it

1. Click **Use this template → Create a new repository** at the top of this
   page. Name your project and create it.
2. In your new repo, **delete** `site/`, `kit/`, `.github/workflows/pages.yml`
   and `.github/workflows/release.yml`. They are the kit's explainer site, its
   own task files and its release workflow; both workflows are guarded so they
   won't run in your copy anyway. Keep `.kit-version`: it records the kit
   version your project started from.
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
| [`.kit-version`](./.kit-version) | Which kit release this project was created from. Keep it. | — |
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

## Kit versions and releases

The kit uses SemVer, staying on `0.x` while B-002 and B-003 still reshape the
process. The first release is `v0.1.0`.

- `.kit-version` holds exactly one line, `project-starter-kit vX.Y.Z`.
  Projects keep it, and can compare it with the
  [Releases page](https://github.com/Eugenelcc/project-starter-kit/releases)
  to see what changed since.
- Release notes live in GitHub Releases. There is no kit changelog file (the
  root `CHANGELOG.md` is a template for your project).
- To release: bump `.kit-version` in a PR, merge it, then push the `vX.Y.Z`
  tag on the `main` commit. `.github/workflows/release.yml` then creates the
  Release with generated notes.
- The workflow refuses a `.kit-version` that doesn't match the tag, a
  pre-release or other non-`vX.Y.Z` tag, and a tag that isn't on `main`.
- Local dry run: `TAG=v0.1.0 MAIN_REF=main kit/scripts/check-release.sh`.

## The kit's own backlog

The kit's backlog is GitHub Issues (the root `BACKLOG.md` is a template for
your project).

- Titles are `B-### <title>`; IDs are never reused.
- The `backlog` label marks an issue as a `B-###` item.
- Status is shown by labels, mirroring WORKFLOW §7: `status: todo`,
  `status: spec`, `status: planned`, `status: tests`, `status: in progress`,
  `status: in review`, `status: done`. Labels only, no Project board.
- Claude creates the labels with `gh` when the owner asks.
- Kit task files live in `kit/specs/B-###-<slug>.md`, the kit's equivalent of
  `docs/specs/` (same template). Projects delete `kit/` at setup.
- Kit tests: `bash kit/scripts/test-all.sh`.

## Cost

Everything here is free: plain Markdown, Claude Code's built-in subagents,
and GitHub Pages (free for public repos) for the explainer site. The release
workflow uses GitHub Actions, also free for public repos, with no secrets
beyond the built-in token.

## License

[MIT](./LICENSE). Use it, change it, share it.
