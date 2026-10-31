# <Project name> — Product Requirements Document

<!-- TEMPLATE GUIDANCE (delete this block once filled in)
The PRD says WHAT to build and WHY, never HOW (that goes in each task's
Build plan, and lasting choices in docs/adr/). Every feature gets an ID
(F1, F2, … and sub-rules F1.1, F1.2) that branches, commits, specs and PRs
cite. Never reuse an ID; mark a dropped feature "withdrawn" instead.
Worked example: https://github.com/Eugenelcc/spendlygo/blob/main/PRD.md
-->

**Status:** draft · **Owner:** <@github-handle> · **Last updated:** <YYYY-MM-DD>

---

## 1. Summary
<!-- Two or three sentences: what it is, who it's for, the one thing it does
     better than anything else. -->

## 2. Problem
<!-- What's painful today, for whom, and how they cope now. -->

## 3. Target user
<!-- One primary user, described concretely. Who it is NOT for. -->

## 4. Goals & success metrics

| Goal | Metric | Target |
|---|---|---|
| <e.g. Capture is fast> | <e.g. median time to save an entry> | <e.g. < 3 s> |
| <e.g. It stays free> | Monthly infrastructure cost | <e.g. $0> |

**Anti-metric:** <a number that, if it rises, means we built the wrong thing>

## 5. Scope

### 5.1 In scope — v1
- F1 <name>
- F2 <name>

### 5.2 Out of scope — deferred
<!-- Things we will probably do later. Listing them stops scope creep:
     a request for one of these is a "stop and ask" (GUARDRAILS §6). -->
| Idea | Deferred to | Why |
|---|---|---|
| | v2 | |

### 5.3 Non-goals
<!-- Things we will never do. -->

## 6. Constraints
<!-- The hard limits that drive design: budget, hosting quotas, platform
     rules, privacy, performance. Rules derived from these live in
     GUARDRAILS.md. -->

## 7. Feature requirements

### F1 — <name>
**User story:** As <who>, I want <what>, so that <why>.

| ID | Requirement |
|---|---|
| F1.1 | <a testable rule> |
| F1.2 | |

**Acceptance (example):** Given <state>, when <action>, then <result>.

### F2 — <name>

## 8. Data model (logical)
<!-- Entities and key fields, no SQL. Who owns each row. -->

## 9. Architecture (one paragraph + a diagram)
<!-- Big boxes only. Decisions with trade-offs → an ADR each. -->

## 10. Security & privacy
<!-- What data is stored, where, for how long; how deletion works. -->

## 11. Phased roadmap

| Phase | Contents | Definition of done | Status |
|---|---|---|---|
| **P0 — Skeleton** | Repo, CI, deploy, health check | Something responds in production | todo |
| **P1 — <core>** | F1, F2 | <observable outcome> | todo |

Live task tracking lives in [`BACKLOG.md`](./BACKLOG.md). This table only
shows phase status.

## 12. Open questions

| # | Question | Needed by | Owner's answer |
|---|---|---|---|
| Q1 | | | |

## 13. Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| | | | |
