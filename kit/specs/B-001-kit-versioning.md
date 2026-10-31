# B-001 — Kit versioning and the kit's own backlog

**Feature:** n/a (kit work, tracked in [issue #2](https://github.com/Eugenelcc/project-starter-kit/issues/2)) · **Branch:** `feat/B-001-kit-versioning` · **Status:** requirements approved; build plan next
<!-- After each approval, Claude adds a line:
     Requirements approved by owner, YYYY-MM-DD
     Build plan approved by owner, YYYY-MM-DD -->
Requirements approved by owner, 2026-10-31

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

## Grilling recap (confirmed by owner, 2026-10-31)

**Context for agents:** this is work on the *kit itself*. The root `PRD.md`,
`GUARDRAILS.md`, `BACKLOG.md` and `CHANGELOG.md` are **templates** for future
projects (full of `<placeholders>` on purpose), not the kit's own rules. The
kit's own rules are:
- It stays free (S$0): GitHub Free features only, no paid or card-required service.
- The repo is public: no secrets or private data.
- Claude never merges and opens PRs only when the owner asks; one branch per task.
- Kit-only files must not burden projects made from the template: they're
  either guarded (`if: github.repository == 'Eugenelcc/project-starter-kit'`)
  or listed in the setup "delete" step.
- The site (`site/`) is plain HTML/CSS/JS with no external requests.

- **What we're building:** version numbers for the kit, so projects know which
  kit version they came from, and a home for the kit's own backlog and task files.
- **Decisions made:**
  - Kit changelog → **GitHub Releases** (no file), so nothing extra is copied into projects.
  - First version → **v0.1.0** (SemVer 0.x while B-002/B-003 still reshape the process), tagged **after B-001 merges**.
  - A project records its origin in a one-line **`.kit-version`** file at the root, e.g. `project-starter-kit v0.1.0` (machine-readable, costs no Claude context).
  - Kit backlog → **GitHub Issues** with `B-###` titles and `status: …` labels mirroring WORKFLOW §7; **labels only**, no Project board.
  - Kit task files → **`kit/specs/`** (this file is the first). Projects delete `kit/` at setup.
  - Releases → a **`release.yml`** workflow creates the GitHub Release with auto-generated notes when a `v*` tag is pushed; guarded to this repo; **refuses to publish if the tag doesn't match `.kit-version`**.
  - README documents the versioning, release and backlog conventions; the setup steps (README, site, playground checklist) add `kit/` and `.github/workflows/release.yml` to the delete list.
- **Out of scope / parked:** a kit-sync script; "lesson from a project" issue templates; a Project board.
- **Open risks:** `.kit-version` must be bumped before tagging (mitigated by the tag-match check).

---

## Requirements — *what* (Stage 1)

### Problem
Kit work, [issue #2](https://github.com/Eugenelcc/project-starter-kit/issues/2)
(no PRD feature ID: the root `PRD.md` is a template). The kit has no version
numbers, so a project can't tell which kit version it was created from, and the
kit has no home for its own backlog and task files because the root
`BACKLOG.md`, `CHANGELOG.md` and `docs/specs/` belong to the projects made from it.

### User stories
- As **the kit owner releasing a version**, I want to bump `.kit-version`,
  merge, and push a `v*` tag to get a GitHub Release with generated notes, and
  have it refused if I forgot the bump, so that releases are one step and never
  mislabelled.
- As **a person starting a project from the template**, I want the setup steps
  (README, site, playground) to tell me exactly which kit-only files to delete,
  including `kit/` and `release.yml`, so that my project carries nothing that
  only matters to the kit.
- As **the owner opening an old project a year later**, I want a one-line
  `.kit-version` at its root, so that I know which kit release it came from and
  can compare it with the kit's Releases page.
- As **an agent or session picking the next kit backlog item**, I want the
  kit's conventions (Issues with `B-###` titles, `status: …` labels, task files
  in `kit/specs/`) written in the README, so that I find and update kit work
  without touching the template files.

### Acceptance criteria
"Automated" = a local, repeatable command (named in the Build plan).
"Verified on GitHub after merge" = can only run on GitHub; the exact steps are given.
"Tag-match step" = the check in `release.yml` that runs before any release is created.

| # | Given | When | Then |
|---|---|---|---|
| AC1 | The B-001 branch | `.kit-version` at the repo root is read | Its content is exactly the line `project-starter-kit v0.1.0` (one line, optionally followed by a newline; nothing else). *Automated.* |
| AC2 | `.github/workflows/release.yml` | Its trigger is inspected | It runs only on `push` of tags matching `v*` (no branch pushes, no PRs, no schedule). *Automated (parse the YAML).* |
| AC3 | `release.yml` | Its jobs are inspected | Every job has `if: github.repository == 'Eugenelcc/project-starter-kit'`, the same guard as `pages.yml`. *Automated (parse the YAML).* |
| AC4 | `release.yml` | Its permissions and secrets are inspected | It uses only the built-in `GITHUB_TOKEN` (no other `secrets.*`), with no permission beyond `contents: write`, and no paid or card-required service. *Automated (parse the YAML).* |
| AC5 | The tag-match step, on a commit on `main` | It runs with tag `v9.9.9` while `.kit-version` is `project-starter-kit v0.1.0` | It exits non-zero before any release is created, and its error names both the tag and the `.kit-version` line and says to bump `.kit-version`. *Automated (run the step locally with those inputs).* |
| AC6 | The tag-match step, on a commit on `main` | It runs with tag `v0.1.0` while `.kit-version` is `project-starter-kit v0.1.0` | It exits zero. *Automated (same harness as AC5).* |
| AC7 | The tag-match step, on a commit on `main` | It runs with tag `v0.1.0` while `.kit-version` is `starter-kit v0.1.0` (wrong prefix) | It exits non-zero, and its error says the line must be exactly `project-starter-kit vX.Y.Z`. *Automated (same harness).* |
| AC8 | The tag-match step, on a commit on `main` | It runs with tag `v0.2.0-rc.1` while `.kit-version` is `project-starter-kit v0.2.0-rc.1` | It exits non-zero, and its error says pre-release tags are not published and only `vX.Y.Z` is allowed. *Automated (same harness).* |
| AC9 | The tag-match step, with tag and `.kit-version` both `v0.1.0`, on a commit that is **not** on `main` | It runs | It exits non-zero, and its error says the tagged commit must be on `main`. *Automated (same harness, in a throwaway local git repo with a side-branch commit).* |
| AC10 | B-001 merged to `main`, `.kit-version` is `project-starter-kit v0.1.0` | Claude, when the owner asks, pushes tag `v0.1.0` on the merge commit | A GitHub Release `v0.1.0` exists with auto-generated notes. *Verified on GitHub after merge:* the Actions run for the tag is green, and `gh api repos/Eugenelcc/project-starter-kit/releases/tags/v0.1.0 --jq '.tag_name, .prerelease, (.body \| length > 0)'` prints `v0.1.0`, `false`, `true`. |
| AC11 | B-001 merged | Claude, when the owner asks, creates the missing labels | The repo has `backlog` plus all seven `status: …` labels from AC13. *Verified on GitHub after merge:* `gh api repos/Eugenelcc/project-starter-kit/labels --paginate --jq '.[].name'` lists all eight. |
| AC12 | The README | A reader looks for how the kit is versioned and released | A section explains: SemVer 0.x starting at `v0.1.0`; that `.kit-version` is exactly `project-starter-kit vX.Y.Z` and projects keep it; release notes live in GitHub Releases (no kit changelog file); the release steps (bump `.kit-version` → merge → push the `vX.Y.Z` tag on `main`); and that the workflow refuses a mismatched line, a pre-release tag, or a tag off `main`. *Scripted manual check: the reviewer ticks each of these five points against the README.* |
| AC13 | The README | A reader looks for the kit's backlog conventions | It states: the kit backlog is GitHub Issues; titles are `B-### <title>` with IDs never reused; the `backlog` label marks an issue as a `B-###` item; status is shown by labels, listing all seven: `status: todo`, `status: spec`, `status: planned`, `status: tests`, `status: in progress`, `status: in review`, `status: done` (WORKFLOW §7); labels only, no Project board; and the labels are created by Claude with `gh` when the owner asks. *Automated (grep README for `backlog`, each status label and `B-###`).* |
| AC14 | The repo | `kit/specs/` is inspected | It exists, holds `B-001-kit-versioning.md`, and the README says kit task files live in `kit/specs/B-###-<slug>.md` (the kit's equivalent of `docs/specs/`) and that projects delete `kit/` at setup. *Automated (file exists + grep README).* |
| AC15 | README "Start a new project" step 2 | It is read | The delete list names `site/`, `.github/workflows/pages.yml`, `kit/` and `.github/workflows/release.yml`. *Automated (grep).* |
| AC16 | `site/index.html` "From template to first task" | It is read | The delete step names the same four paths as AC15. *Automated (grep).* |
| AC17 | The playground setup checklist, "Kit files" table | It renders, with "has screens" on and then off | Both `kit/` and `.github/workflows/release.yml` appear as rows marked **delete**, alongside `site/` and `pages.yml`. *Scripted manual check in a browser (or headless).* |
| AC18 | The playground setup checklist, git rm command | It renders, with "has screens" on and then off | The `git rm -r` line includes `site`, `.github/workflows/pages.yml`, `kit` and `.github/workflows/release.yml` both times (plus `DESIGN.md` when screens are off). *Scripted manual check, same session as AC17.* |
| AC19 | `site/playground.html` at 375 px width, light and dark | The setup tab is opened and both toggle states are rendered | `document.documentElement.scrollWidth <= document.documentElement.clientWidth` (no page-level horizontal scroll; the command box may scroll inside itself) and the console shows zero errors. *Scripted manual check.* |
| AC20 | `site/index.html` and `site/playground.html` after the change | They load | The network panel shows no request outside the site's own origin. *Scripted manual check.* |

### Edge cases
- **Tag without the leading `v`** (`0.2.0`): doesn't match `v*`, so the
  workflow doesn't start and no release is made.
- **Pre-release or other non-`vX.Y.Z` tag** (`v0.2.0-rc.1`, `v1`, `v0.2`):
  matches `v*`, so the workflow starts, then refuses with a clear error (AC8).
- **`.kit-version` with a trailing newline or trailing spaces**: ignored; the
  line still matches. Anything else (a wrong or missing prefix, extra text,
  a second non-empty line, leading spaces) fails (AC7).
- **`.kit-version` with Windows line endings (`\r\n`)**: the `\r` is trailing
  whitespace, so it is ignored like any other.
- **`.kit-version` missing or empty on the tagged commit**: refuse, with an
  error saying the file is missing or empty; no release.
- **Tag pushed on a commit that isn't on `main`** (e.g. a feature branch
  before merge): refused (AC9).
- **Workflow re-run, or a tag deleted and pushed again after its release
  exists**: never creates a second release and never overwrites the existing
  release's notes.
- **Two tags pushed on the same commit** (`v0.1.0` and `v0.1.1`): each is
  checked on its own; only the one matching `.kit-version` publishes.
- **A template copy that keeps `release.yml` by mistake**, or a fork: pushing
  a `v*` tag there skips the job (guard), creates no release and needs no
  secret.
- **A template copy that keeps `kit/` by mistake**: harmless, but the delete
  list (AC15–AC18) is the only safeguard; no automation removes it.
- **A label that already exists** (`backlog`, `status: todo`): creating labels
  leaves it as is; no duplicate, no error that stops the rest.
- **Playground with saved setup ticks from before this change**
  (`localStorage`): still renders without errors (covered by AC19's console
  check, run once with old saved state).
- **Narrow screen and a longer `git rm` line**: the command scrolls or wraps
  inside its box; the page itself never scrolls sideways (AC19).

### Out of scope
- A kit-sync script that pulls kit updates into existing projects (parked).
- "Lesson from a project" issue templates (parked).
- A "Backlog item" issue template (left to B-003, issue #4).
- A GitHub Project board (decided: labels only).
- A kit changelog file (decided: GitHub Releases instead).
- Publishing pre-releases (decided: refused).
- Releases for any version before `v0.1.0`.
- Changes to the root templates (`PRD.md`, `GUARDRAILS.md`, `BACKLOG.md`,
  `CHANGELOG.md`, `WORKFLOW.md`, `docs/specs/TEMPLATE.md`, `.claude/agents/`).

### Open questions for the owner
None. **Answered by owner, 2026-10-31:**
- **Q1 → A.** `.kit-version` is exactly `project-starter-kit vX.Y.Z` on one
  line. Only trailing whitespace or a newline is ignored. The whole line is
  checked strictly, so a wrong prefix fails with a clear error.
- **Q2 → B.** Pre-release tags (e.g. `v0.2.0-rc.1`) are refused with a clear
  error. Only `vX.Y.Z` publishes.
- **Q3 → A.** A tag on a commit that isn't on `main` is refused.
- **Q4 → A.** No issue template in B-001; it's left to B-003 (issue #4).
- **Q5 → B.** After merge, when the owner asks, Claude creates the six
  missing `status:` labels and pushes the `v0.1.0` tag (outside the PR). The
  README says the labels are created this way.
- **Q5b → yes.** The README documents the `backlog` label (it marks an issue
  as a `B-###` item) alongside the seven status labels.

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
