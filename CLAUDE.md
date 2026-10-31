# CLAUDE.md — <Project name>

<!-- TEMPLATE GUIDANCE (delete this block once filled in)
This file loads into EVERY Claude Code session and EVERY subagent, so every
line costs context in every run. Keep it small (aim for < 10 KB): what this
is, where things are, the commands, the conventions. Detail for one area
(e.g. the server, the front end, a domain package) goes in a nested
CLAUDE.md inside that folder; Claude loads it automatically only when it
works there.
Worked example: https://github.com/Eugenelcc/spendlygo/blob/main/CLAUDE.md
(with nested ones in apps/server, apps/miniapp and packages/core)
-->

Operating manual for Claude Code (and any human) working in this repository.
Read this first, then the doc it points you to for the task at hand.

## What this is
<!-- Two sentences from PRD §1, plus the one constraint that drives
     everything (e.g. "must run 24/7 for $0"). -->

## Document map

| Doc | Read it when |
|---|---|
| [`PRD.md`](./PRD.md) | You need to know *what* to build, feature IDs (F1…), scope, phase order |
| [`GUARDRAILS.md`](./GUARDRAILS.md) | **Before every change.** Hard rules |
| [`DESIGN.md`](./DESIGN.md) | You touch anything the user sees (UI projects only) |
| [`WORKFLOW.md`](./WORKFLOW.md) | **Start and end of every session.** The pipeline, stages, models |
| [`BACKLOG.md`](./BACKLOG.md) | Choosing what to work on. Every task is a `B-###` item |
| [`docs/specs/`](./docs/specs) | A task is past intake: its one spec file lives here |
| [`docs/adr/`](./docs/adr) | Why a non-obvious decision was made |
| [`RUNBOOK.md`](./RUNBOOK.md) | Deploying, rolling back, something is down |
| [`CHANGELOG.md`](./CHANGELOG.md) | Recording what a release changed |
| `<area>/CLAUDE.md` | Local rules for that area. Loaded automatically when you work there |

If a request conflicts with `GUARDRAILS.md`, **stop and ask.** Do not silently
resolve the conflict.

## Stack

| Layer | Choice | Why |
|---|---|---|
| Language | | |
| Runtime | | |
| Framework | | |
| Database | | |
| Hosting | | |
| Tests | | |

**Rejected on purpose:** <tools you decided against, and why, so nobody
re-adds them>.

## Repository layout

```
<project>/
├── src/            # <what lives here>
├── tests/
├── docs/specs/     # one spec file per backlog item
├── docs/adr/       # architecture decision records
└── scripts/ci.sh   # the single CI pipeline (local and GitHub)
```

**Layering rule:** <which modules may import which>.

## Commands

```bash
<install>           # install dependencies
<dev>               # run locally
<test>              # run tests          ← must pass before commit
<full CI command>   # the whole pipeline ← before every push
```

## Conventions
<!-- Language rules, naming, error handling, data and time rules. Keep to
     the ones a newcomer would get wrong. -->

**Commits:** Conventional Commits with the PRD feature ID in the scope or
body: `feat(export): F8 add CSV download`.

## Working agreement

The full process is in [`WORKFLOW.md`](./WORKFLOW.md). In short:

1. **Read `GUARDRAILS.md` before changing anything.**
2. **Never assume.** Unsure → ask the owner, with a plain-language scenario
   and options with pros and cons.
3. **Every task is a `BACKLOG.md` item.** Unless it's a small fix, grill the
   owner, then write Requirements, then a Build plan, in one spec file. Each
   needs the owner's "approved".
4. **Tests first** for every acceptance criterion; the high-risk areas
   (GUARDRAILS §8) never ship untested.
5. **One branch per task**, `<type>/<B-id>-<slug>`; one feature ID per PR.
6. **Run `<full CI command>`** before every push.
7. **Update docs in the same PR** whenever behaviour or layout changes.
8. **Park side ideas** in `BACKLOG.md` → Later.
9. **After 2 failed attempts, stop and escalate.**
10. **Open a PR only when the owner asks. Never merge.**

## Where the rest lives

| Topic | Now in |
|---|---|
| Environment variables, deployment, infra gotchas | `<server area>/CLAUDE.md` + `RUNBOOK.md` |
| Front-end architecture and UI gotchas | `<front-end area>/CLAUDE.md` |
| Agent roles and models per stage | `.claude/agents/` (see `WORKFLOW.md` §1) |

A new gotcha goes into the nested file for the area where it bites. Only
something repo-wide goes here.
