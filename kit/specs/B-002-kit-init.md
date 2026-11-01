# B-002 — /kit-init: set up a new project in one grilling session

**Feature:** n/a (kit work, tracked in [issue #3](https://github.com/Eugenelcc/project-starter-kit/issues/3)) · **Branch:** `feat/B-002-kit-init` · **Status:** draft
<!-- After each approval, Claude adds a line:
     Requirements approved by owner, YYYY-MM-DD
     Build plan approved by owner, YYYY-MM-DD -->

Process: [`WORKFLOW.md`](../../WORKFLOW.md). **This one file is the handoff between agents:**
each writes only its own section. Worked example:
[Spendlygo B-004](https://github.com/Eugenelcc/spendlygo/blob/main/docs/specs/B-004-settings-command.md).

| Section | Written by | Stage |
|---|---|---|
| Grilling recap | main session, confirmed by the owner | before 1 |
| Requirements, Build plan | `spec-planner` (Opus) | 1–2 |
| Second opinion | `challenger` (Opus), risky items only | 1–2 |
| Test report | `test-writer` (Sonnet) creates it; `builder` (Sonnet) fills in the results | 3–4 |
| Build notes | `builder` (Sonnet) | 4 |
| Review | `reviewer` (Opus) | 5 |

Keep it lean: summaries and tables, never raw logs.

---

## Grilling recap (confirmed by owner, 2026-11-01)

**Context for agents:** this is work on the *kit itself* (see
`kit/specs/B-001-kit-versioning.md` for the kit's own rules: free/S$0, public
repo with no secrets, kit-only files guarded or deleted at setup, site has no
external requests, Claude never merges). The root `PRD.md`, `GUARDRAILS.md`,
`CLAUDE.md`, `BACKLOG.md`, `DESIGN.md`, `WORKFLOW.md` and `.claude/agents/` are
the **templates** `/kit-init` fills in a *new project*; inside the kit repo they
must stay templates.

- **What we're building:** a Claude Code skill at `.claude/skills/kit-init/`
  that ships with every project made from the template. The owner types
  `/kit-init` in a new repo and it sets the project up by grilling them,
  following the kit's own rules (never assume; at most 4 questions a round;
  a plain-language scenario first, then detail; options with pros and cons and
  a marked recommendation).
- **Decisions made:**
  1. **Cleanup:** first step lists the kit-only files (`site/`, `kit/`,
     `.github/workflows/pages.yml`, `.github/workflows/release.yml`), asks, and
     removes them (`git rm`) only on an explicit yes.
  2. **Resumable:** confirmed answers are saved to a temporary progress file
     as it goes; running `/kit-init` again continues from there; the file is
     deleted at the end.
  3. **Files it fills:** `PRD.md`, `GUARDRAILS.md`, `CLAUDE.md`, `BACKLOG.md`
     (with B-001); `DESIGN.md` only if the project has screens (else it offers
     to delete it); the real `<test command>` / `<full CI command>` in
     `WORKFLOW.md` and `.claude/agents/*.md`. `RUNBOOK.md` and `README.md` stay
     templates.
  4. **Writing:** one recap per file; a file is written only after the owner
     confirms that file's recap.
  5. **Existing text:** keeps anything the owner already wrote, asks only
     about remaining `<placeholders>`, and asks when existing text conflicts
     with an answer. Never rewrites the owner's text silently.
  6. **Unknowns:** anything unanswered stays a `<placeholder>` and is listed
     for the owner at the end. Never invents facts.
  7. **Self-removal:** the last step removes `.claude/skills/kit-init/`, after asking.
  8. **Safety:** refuses to run inside the kit repo itself
     (`Eugenelcc/project-starter-kit`).
  9. **Testing:** free automated checks (skill file valid; names every file
     and rule it must follow; refusal in the kit repo) plus one guided dry run
     in a throwaway repo, run by Claude in this session, transcript shared with
     the owner. No paid API in CI.
  10. **Docs:** README, site and playground setup instructions say "run
      `/kit-init`" as the recommended start, keeping the manual steps as the
      alternative.
- **Out of scope / parked:** stack presets; kit sync; filling `RUNBOOK.md` /
  `README.md`.
- **Open risks:** skill quality depends on careful instruction wording (the
  dry run tests it); B-002 changes the process enough to release as `v0.2.0`
  after merge (owner pushes or publishes the tag, as for v0.1.0).

---

## Requirements — *what* (Stage 1)

### Problem
<!-- One or two sentences: what's wrong or missing, for whom. Cite the PRD feature ID. -->

### User stories
- As <who>, I want <what>, so that <why>.

### Acceptance criteria
<!-- Each one is testable and gets exactly one test in Stage 3. -->

| # | Given | When | Then |
|---|---|---|---|
| AC1 | | | |
| AC2 | | | |

### Edge cases
<!-- Prompts: empty state, zero, maximum, duplicate/retried request,
     two users at once, month end / leap year, the user's timezone,
     offline or slow network, permission denied. Keep the ones that apply. -->
-

### Out of scope
-

### Open questions for the owner
<!-- Each with a plain-language scenario and options with pros and cons.
     Must be empty before approval. -->
-

---

## Build plan — *how* (Stage 2)

### Files
| File | Change |
|---|---|
| | |

### Data
<!-- Schema change? How is the migration generated? Backward-compatible
     with the version that's currently running? Any destructive step →
     GUARDRAILS §10. Or "none". -->

### Tests
| AC | Test file › test name |
|---|---|
| AC1 | |

### Risks & guardrails
<!-- One line per relevant GUARDRAILS section — or "none", with a reason. -->

### PR split
<!-- One feature ID per PR. "Single PR", or "part 1 of N: …". -->

---

## Second opinion (risky items only, `challenger`)
<!-- Or "n/a: not a risky item". Each finding: scenario, detail, options with pros and cons, blocking? -->

---

## Test report (Stages 3–4)

| AC | Test file › test name | Before build | After build |
|---|---|---|---|
| AC1 | | ❌ failing (expected) | |

**Checks:** <!-- one line, e.g. typecheck ✓ · lint ✓ · test 312 passed -->
**Screenshots:** <!-- UI changes: light + dark at phone width, attached to the PR — or "n/a" -->

---

## Build notes (Stage 4)

- **Deviations from plan:** <!-- "none", or what and why (a plan change needs owner re-approval) -->
- **Parked ideas:** <!-- added to BACKLOG → Later, or "none" -->

---

## Review (Stage 5)

**Verdict:** <!-- ready for owner · back to build · back to plan -->

| # | Severity | file:line | Finding | Failure scenario |
|---|---|---|---|---|
| | | | | |

**Guardrail self-check** (WORKFLOW §4)
- [ ] Cost · [ ] Data · [ ] Auth + cross-user test · [ ] Privacy · [ ] <Project-specific>
