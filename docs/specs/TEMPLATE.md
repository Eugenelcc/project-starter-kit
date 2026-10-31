# B-### — <title>

**Feature:** F# · **Branch:** `<type>/B-###-<slug>` · **Status:** draft
<!-- After each approval, Claude adds a line:
     Requirements approved by owner, YYYY-MM-DD
     Build plan approved by owner, YYYY-MM-DD -->

Process: [`WORKFLOW.md`](../../WORKFLOW.md). Copy this file to
`docs/specs/B-###-<slug>.md`. **This one file is the handoff between agents:**
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

## Grilling recap (confirmed by owner, YYYY-MM-DD)
<!-- Written by the main session after the grilling rounds and played back to
     the owner. spec-planner's main input. Plain language. -->

- **What we're building:**
- **Decisions made:** <!-- each with the option chosen, and why -->
- **Out of scope / parked:**
- **Open risks:**

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
