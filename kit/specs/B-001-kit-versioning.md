# B-001 — Kit versioning and the kit's own backlog

**Feature:** n/a (kit work, tracked in [issue #2](https://github.com/Eugenelcc/project-starter-kit/issues/2)) · **Branch:** `feat/B-001-kit-versioning` · **Status:** built; awaiting review
<!-- After each approval, Claude adds a line:
     Requirements approved by owner, YYYY-MM-DD
     Build plan approved by owner, YYYY-MM-DD -->
Requirements approved by owner, 2026-10-31
Build plan approved by owner, 2026-10-31 (incl. re-run = leave existing release unchanged, labels colour `ededed`)

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

**Owner decisions on the how (2026-10-31):**
- The release check is a shell script, `kit/scripts/check-release.sh`, called
  by `.github/workflows/release.yml`. It can be run locally and is deleted
  with `kit/` at setup.
- The release is created with the runner's preinstalled `gh` CLI
  (`gh release create <tag> --generate-notes --verify-tag`, with the built-in
  `GITHUB_TOKEN`). The only marketplace action is `actions/checkout@v4` (the
  same major as `pages.yml`), with `fetch-depth: 0` so the script can run
  `git merge-base --is-ancestor`.
- Test scripts live in `kit/scripts/` too, so they are deleted with `kit/`
  and never reach a project.

The kit has no `package.json`, no CI pipeline and no test framework. **Don't
add any.** Tests are plain `bash`, `python3` (+ PyYAML 6, preinstalled) and
`node` (Playwright 1.63, preinstalled globally; `NODE_PATH` and
`PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers` are already set). They run
locally only.

### Files
| File | Change |
|---|---|
| `.kit-version` (new, repo root) | Exactly `project-starter-kit v0.1.0` followed by one `\n`. Nothing else. |
| `kit/scripts/check-release.sh` (new, `chmod +x`) | The release check. Interface below. |
| `.github/workflows/release.yml` (new) | The release workflow. Exact content below. |
| `kit/scripts/test-check-release.sh` (new, `chmod +x`) | Exercises `check-release.sh` in throwaway git repos: AC5–AC9 + edge cases. |
| `kit/scripts/test-release-workflow.py` (new) | YAML assertions on `release.yml`: AC2–AC4. |
| `kit/scripts/test-kit-files.sh` (new, `chmod +x`) | File and grep checks: AC1, AC13–AC16. |
| `kit/scripts/test-site.cjs` (new) | Playwright checks on the site: AC17–AC20. |
| `kit/scripts/test-all.sh` (new, `chmod +x`) | Runs the four test scripts in order and exits non-zero if any of them fails. |
| `README.md` | (a) Step 2 of "Start a new project": the delete list becomes `site/`, `kit/`, `.github/workflows/pages.yml` and `.github/workflows/release.yml`, with one sentence on what they are ("the kit's explainer site, its own task files and its release workflow; both workflows are guarded so they won't run in your copy anyway"), plus "Keep `.kit-version`: it records the kit version your project started from." (b) "What's inside" table: add a `.kit-version` row ("Which kit release this project was created from. Keep it.", Spendlygo column `—`). (c) New section **"Kit versions and releases"** after "How the orchestration works", covering the five AC12 points. (d) New section **"The kit's own backlog"** right after it, covering every AC13 and AC14 point. (e) "Cost": add that the release workflow uses GitHub Actions, free for public repos, with no secrets beyond the built-in token. |
| `site/index.html` | Line ~357, the "Delete …" `<li>`: name all four paths as `<code>` (`site/`, `kit/`, `.github/workflows/pages.yml`, `.github/workflows/release.yml`); text "They only publish this page and the kit's own releases and task files. Keep <code>.kit-version</code>." No CSS change. |
| `site/playground.html` | In `suRender()` (~line 982), `files` array: after the `pages.yml` row, add `["kit/", "del", "The kit's own task files and release scripts."]`, `[".github/workflows/release.yml", "del", "Publishes kit releases; it's guarded so it won't run in your copy anyway."]` and `[".kit-version", "keep", "Records which kit version your project came from."]`. The `rm` array (~line 999) becomes `["site", "kit", ".github/workflows/pages.yml", ".github/workflows/release.yml"]`, still pushing `DESIGN.md` when `!su.ui`. Leave `STEPS` and the step text unchanged. No CSS change: `.term` already has `overflow-x: auto`. |
| `kit/specs/B-001-kit-versioning.md` | Test report, Build notes (builder); Review (reviewer). |

#### `kit/scripts/check-release.sh`: interface
- `#!/usr/bin/env bash`, `set -euo pipefail`. A header comment says what the
  script is, that it is kit-only, and how to run it locally.
- It runs from inside a git repo (cwd). It reads **nothing** from the working
  tree: `.kit-version` is read **at the tagged commit** with
  `git show "refs/tags/$TAG:.kit-version"`, so the result is the same in CI
  and locally whatever is checked out.
- **Inputs (env vars):**
  - `TAG`: required, e.g. `v0.1.0`. In CI it is `${{ github.ref_name }}`, passed through `env:`, never interpolated into `run:`.
  - `MAIN_REF`: optional, default `origin/main`. Locally (or in tests) pass `MAIN_REF=main`.
- **Checks, in this order.** The first failure prints one line to **stderr**
  and exits. Messages are exact (`<TAG>` = the value; `<MAIN_REF>` = the value;
  `<found>` = the line as read, after trailing whitespace is stripped):

| # | Check | Exit | Message |
|---|---|---|---|
| 1 | `TAG` set and non-empty | 2 | `check-release: TAG is not set.` |
| 2 | `TAG` matches `^v[0-9]+\.[0-9]+\.[0-9]+$` (bash `[[ =~ ]]`) | 1 | `Refusing to release '<TAG>': only tags of the form vX.Y.Z are published (pre-release and other tags are not).` |
| 3 | `git rev-parse --verify --quiet "refs/tags/$TAG^{commit}"` succeeds | 1 | `Refusing to release '<TAG>': no such tag in this repository.` |
| 4 | `git rev-parse --verify --quiet "$MAIN_REF^{commit}"` succeeds | 2 | `check-release: main ref '<MAIN_REF>' not found (in CI, check out with fetch-depth: 0).` |
| 5 | `git merge-base --is-ancestor "refs/tags/$TAG^{commit}" "$MAIN_REF"` succeeds | 1 | `Refusing to release '<TAG>': its commit is not on main (<MAIN_REF>). Merge first, then tag a commit on main.` |
| 6 | `git cat-file -e "refs/tags/$TAG:.kit-version"` succeeds | 1 | `Refusing to release '<TAG>': .kit-version is missing at that commit.` |
| 7 | The content, with trailing whitespace stripped (including `\n` and `\r`; e.g. `c="$(git show …)"; c="${c%"${c##*[![:space:]]}"}"`), is non-empty | 1 | `Refusing to release '<TAG>': .kit-version is empty.` |
| 8 | The content matches `^project-starter-kit v[0-9]+\.[0-9]+\.[0-9]+$`. A second line or a leading space fails this, because the whole stripped content is matched | 1 | `Refusing to release '<TAG>': .kit-version must be exactly one line 'project-starter-kit vX.Y.Z', found '<found>'.` |
| 9 | The content equals `project-starter-kit $TAG` | 1 | `Refusing to release '<TAG>': .kit-version says '<found>'. Bump .kit-version to 'project-starter-kit <TAG>', merge, then tag again.` |
| — | All pass | 0 | stdout: `OK: <TAG> matches .kit-version and is on <MAIN_REF>.` |

- Use `printf '%s\n'` for output, not `echo -e`. No network access, and no
  `gh` calls in this script.

#### `.github/workflows/release.yml`: content to write
Copy `pages.yml`'s header-comment style: "Creates a GitHub Release when a
vX.Y.Z tag is pushed. Only runs in Eugenelcc/project-starter-kit: projects
created from the template skip it. Delete this file and kit/ in your own
project."
```yaml
name: Release
on:
  push:
    tags: ["v*"]
permissions:
  contents: write
concurrency:
  group: release-${{ github.ref_name }}
  cancel-in-progress: false
jobs:
  release:
    if: github.repository == 'Eugenelcc/project-starter-kit'
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Check the tag against .kit-version and main
        env:
          TAG: ${{ github.ref_name }}
          MAIN_REF: origin/main
        run: bash kit/scripts/check-release.sh
      - name: Create the release (skip if it already exists)
        env:
          TAG: ${{ github.ref_name }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          if gh release view "$TAG" >/dev/null 2>&1; then
            echo "Release $TAG already exists; leaving it unchanged."
            exit 0
          fi
          gh release create "$TAG" --verify-tag --generate-notes --title "$TAG"
```
**Idempotency:** on a re-run, or a tag pushed again, when the release already
exists, the second step prints `Release <TAG> already exists; leaving it
unchanged.` and the run ends **green**, with no new release and no edit to the
notes. Two runs for the same tag are serialised by `concurrency`. If
`gh release create` itself fails, the run is red and nothing is retried
automatically.

#### README: section content (wording is the builder's; points are fixed)
- **Kit versions and releases:** SemVer 0.x, first `v0.1.0`, `0.x` while
  B-002/B-003 reshape the process. `.kit-version` is exactly
  `project-starter-kit vX.Y.Z`; projects keep it and compare it with the
  [Releases page](https://github.com/Eugenelcc/project-starter-kit/releases).
  Release notes live in GitHub Releases (no kit changelog file; the root
  `CHANGELOG.md` is a template). To release: bump `.kit-version` in a PR →
  merge → push the `vX.Y.Z` tag on the `main` commit. `release.yml` refuses a
  `.kit-version` that doesn't match, a pre-release or other non-`vX.Y.Z` tag,
  and a tag that isn't on `main`. Local dry run:
  `TAG=v0.1.0 MAIN_REF=main kit/scripts/check-release.sh`.
- **The kit's own backlog:** GitHub Issues; titles `B-### <title>`, IDs never
  reused; the `backlog` label marks an issue as a `B-###` item; status labels
  (list all seven literally): `status: todo`, `status: spec`,
  `status: planned`, `status: tests`, `status: in progress`,
  `status: in review`, `status: done`, mirroring WORKFLOW §7; labels only, no
  Project board. The labels are created by Claude with `gh` when the owner
  asks. Kit task files live in `kit/specs/B-###-<slug>.md` (the kit's
  equivalent of `docs/specs/`, same template). Projects delete `kit/` at
  setup. Kit tests: `bash kit/scripts/test-all.sh`.

#### After merge, outside the PR (Claude, only when the owner asks)
1. Labels (AC11): for each of `status: spec`, `status: planned`,
   `status: tests`, `status: in progress`, `status: in review`,
   `status: done`, run `gh api repos/Eugenelcc/project-starter-kit/labels -f name='<name>' -f color=ededed`
   (`ededed` matches the existing `backlog` and `status: todo`). A
   `422 already_exists` response counts as done; continue with the next.
2. Tag (AC10): `git fetch origin main && git tag v0.1.0 origin/main && git push origin v0.1.0`,
   then watch the Release run and run the AC10 and AC11 commands.

### Data
None. No schema, no stored data. `localStorage` (`psk:setup`) keeps its
shape: no new keys and no new step IDs.

### Tests
Run everything with `bash kit/scripts/test-all.sh`. Each test prints
`PASS <name>` or `FAIL <name>: <reason>`. A script exits 1 if any of its
tests failed.

**`test-check-release.sh` harness:** `SCRIPT="$(cd "$(dirname "$0")" && pwd)/check-release.sh"`.
A helper `new_repo "<kit-version bytes>"` does `mktemp -d` (all temp dirs
are removed by `trap … EXIT`) and runs
`git -c init.defaultBranch=main init -q`. It writes `.kit-version` with
`printf '%b'`, or writes no file if the argument is the literal `NONE`, then
commits with
`git -c user.name=test -c user.email=test@example.invalid -c commit.gpgsign=false commit -q --allow-empty -m init`
(`--allow-empty` covers the NONE case). Tag with `git tag <tag>` (lightweight),
or `git tag -a -m x` where stated. Run with
`(cd "$repo" && TAG=… MAIN_REF=main bash "$SCRIPT")`, capturing exit code
and stderr, and assert both. For the off-main case:
`git checkout -q -b side`, add a commit, tag it, `git checkout -q main`.

| AC | Test file › test name | Assertion |
|---|---|---|
| AC1 | `test-kit-files.sh` › `AC1 kit-version is exactly the v0.1.0 line` | `python3 -c` reads `.kit-version`; content is `project-starter-kit v0.1.0` or that plus one `\n` |
| AC2 | `test-release-workflow.py` › `AC2 triggers only on v* tag pushes` | The `on` mapping equals `{"push": {"tags": ["v*"]}}`. **Gotcha:** PyYAML parses the key `on` as `True`; read `wf.get("on", wf.get(True))` |
| AC3 | `test-release-workflow.py` › `AC3 every job has the repo guard` | Every `jobs.*.if == "github.repository == 'Eugenelcc/project-starter-kit'"` |
| AC4 | `test-release-workflow.py` › `AC4 only GITHUB_TOKEN, contents write, checkout only` | Top-level `permissions == {"contents": "write"}`; no job has its own `permissions`; every `re.findall(r"secrets\.(\w+)", raw)` is `GITHUB_TOKEN`; every step `uses` starts with `actions/checkout@v4` |
| AC5 | `test-check-release.sh` › `AC5 mismatched tag refused` | Repo with `project-starter-kit v0.1.0\n`, tag `v9.9.9` → exit 1; stderr contains `'v9.9.9'`, `'project-starter-kit v0.1.0'` and `Bump .kit-version` |
| AC6 | `test-check-release.sh` › `AC6 matching tag on main passes` | Same content, tag `v0.1.0` → exit 0; stdout starts `OK: v0.1.0` |
| AC7 | `test-check-release.sh` › `AC7 wrong prefix refused` | Content `starter-kit v0.1.0\n`, tag `v0.1.0` → exit 1; stderr contains `must be exactly one line 'project-starter-kit vX.Y.Z'` |
| AC8 | `test-check-release.sh` › `AC8 pre-release tag refused` | Content `project-starter-kit v0.2.0-rc.1\n`, tag `v0.2.0-rc.1` → exit 1; stderr contains `only tags of the form vX.Y.Z` |
| AC9 | `test-check-release.sh` › `AC9 tag off main refused` | Valid content; tag `v0.1.0` on a `side`-branch commit → exit 1; stderr contains `is not on main (main)` |
| AC10 | Verified on GitHub after merge | After the tag push: the "Release" Actions run is green, and `gh api repos/Eugenelcc/project-starter-kit/releases/tags/v0.1.0 --jq '.tag_name, .prerelease, (.body \| length > 0)'` prints `v0.1.0`, `false`, `true` |
| AC11 | Verified on GitHub after merge | `gh api repos/Eugenelcc/project-starter-kit/labels --paginate --jq '.[].name'` includes `backlog` and all seven `status: …` names |
| AC12 | Scripted manual check (reviewer) | Tick the five AC12 points against README "Kit versions and releases"; record in Review |
| AC13 | `test-kit-files.sh` › `AC13 README backlog conventions` | `grep -F` in README for each of: `` `backlog` ``, the seven `status: …` strings, `B-###`, `GitHub Issues`, `no Project board`, `gh` |
| AC14 | `test-kit-files.sh` › `AC14 kit/specs exists and is documented` | `kit/specs/B-001-kit-versioning.md` exists; README contains `kit/specs/B-###-<slug>.md` and `` `kit/` `` |
| AC15 | `test-kit-files.sh` › `AC15 README delete list` | Text of step 2 (`awk '/^2\. In your new repo/,/^3\. /'`) contains `` `site/` ``, `` `kit/` ``, `` `.github/workflows/pages.yml` ``, `` `.github/workflows/release.yml` `` |
| AC16 | `test-kit-files.sh` › `AC16 index.html delete list` | The single line of `site/index.html` containing `Delete <code>` contains `<code>site/</code>`, `<code>kit/</code>`, `<code>.github/workflows/pages.yml</code>` and `<code>.github/workflows/release.yml</code>` |
| AC17 | `test-site.cjs` › `AC17 files table lists kit/ and release.yml as delete (screens on/off)` | For both `#su-ui` states: rows in `#su-files` whose first cell is `kit/` or `.github/workflows/release.yml` have second cell `delete` |
| AC18 | `test-site.cjs` › `AC18 git rm line includes all kit-only paths (screens on/off)` | First line of `#su-cmd` contains `site`, `kit`, `.github/workflows/pages.yml` and `.github/workflows/release.yml`; plus `DESIGN.md` only when `#su-ui` is unchecked |
| AC19 | `test-site.cjs` › `AC19 no horizontal overflow or console errors at 375px (light, dark, old saved state)` | Viewport 375×812; for `colorScheme` light and dark, and once with `localStorage["psk:setup"]` pre-seeded (via `page.addInitScript`) to `{"ui":true,"deploy":true,"data":true,"done":{"repo":true,"delete":true}}`: open `playground.html#setup`, toggle `#su-ui` off and on; `scrollWidth <= clientWidth` on `document.documentElement` after each render; zero `console` messages of type `error` and zero `pageerror` events |
| AC20 | `test-site.cjs` › `AC20 no external requests` | Record every `page.on('request')` URL while loading `index.html` and `playground.html#setup`; each starts with the local server origin, or `data:`/`about:`/`blob:` |

**`test-site.cjs` harness:** CommonJS (so the global `require('playwright')`
resolves through `NODE_PATH`). It starts a tiny static server with Node's
`http` + `fs`, serving `site/` on `127.0.0.1` at port `0` (then reads the
port). It launches `chromium` headless, runs the four tests, closes
everything and sets `process.exitCode = 1` on any failure. No new
dependency and no file written outside temp. The header comment says it
needs Playwright + Chromium installed locally.

**Edge-case tests** (also in `test-check-release.sh`, named `EDGE …`):

| Test name | Setup → expected |
|---|---|
| `EDGE trailing spaces and CRLF accepted` | Content `project-starter-kit v0.1.0  \r\n`, tag `v0.1.0` → exit 0 |
| `EDGE annotated tag accepted` | Valid content, `git tag -a -m x v0.1.0` → exit 0 |
| `EDGE missing kit-version refused` | `NONE`, tag `v0.1.0` → exit 1, `is missing` |
| `EDGE empty kit-version refused` | Content `\n`, tag `v0.1.0` → exit 1, `is empty` |
| `EDGE second line refused` | Content `project-starter-kit v0.1.0\nextra\n` → exit 1, `must be exactly one line` |
| `EDGE leading space refused` | Content ` project-starter-kit v0.1.0\n` → exit 1, `must be exactly one line` |
| `EDGE tag without v refused` | Tag `0.1.0` → exit 1, `only tags of the form vX.Y.Z` |
| `EDGE short tag refused` | Tag `v0.1` → exit 1, `only tags of the form vX.Y.Z` |
| `EDGE unknown tag refused` | `TAG=v0.9.9`, never created → exit 1, `no such tag` |
| `EDGE TAG unset` | `TAG` empty → exit 2 |
| `EDGE bad main ref` | `MAIN_REF=nope` → exit 2, `not found` |

**Not automated, and why:** the re-run path (release already exists), the
guard skipping in a template copy or fork, and two tags on one commit. They
only run on GitHub. The reviewer checks them by reading `release.yml`
against the Idempotency paragraph above and AC3. They are not exercised
live, because that would publish extra tags on the public repo.

### Risks & guardrails
- **Free (S$0):** GitHub Actions on a public repo, the preinstalled `gh`
  CLI, and `actions/checkout@v4` (GitHub's own). No paid or card-required
  service and no new external service. Local tests use only preinstalled
  tools; no dependency is added.
- **Public repo, no secrets:** the only token is the built-in
  `GITHUB_TOKEN`, with `contents: write` only for this workflow. No `secrets.*`
  beyond it (AC4). `TAG` reaches shell only via `env:`, never
  `${{ }}` inside `run:`, so a crafted tag name can't inject commands.
  Throwaway test repos use `test@example.invalid`.
- **Kit-only files don't burden projects:** `release.yml` is guarded (AC3)
  **and** in the delete list. `kit/` (specs, scripts, tests) is in the delete
  list everywhere it appears (AC15–AC18). `.kit-version` is meant to be kept.
- **Site stays plain, with no external requests:** only copy and two JS array
  edits; no CSS, no new script, no network (AC20); 375px overflow and console
  checked (AC19).
- **Claude never merges, and opens PRs only when asked:** the tag push and
  label creation happen after merge, only when the owner asks. Neither is in
  the PR.
- **Residual risk:** the tests run locally, not in CI, so a later PR could
  break `check-release.sh` unnoticed until the next tag. When that happens,
  the release is refused (safe failure), not mislabelled. A kit CI workflow
  would be a side idea; the builder parks it in Build notes rather than
  building it.
- **Residual risk:** someone pushes a `v*` tag before bumping `.kit-version`.
  The run is refused (AC5); the fix is to delete the tag, bump, merge and
  re-tag.

### PR split
Single PR on `feat/B-001-kit-versioning` (kit work, issue #2). Commits:
`feat(kit): B-001 …`, with the tests committed first, failing (Stage 3).
After merge, when the owner asks, Claude creates the labels and pushes the
tag (outside the PR).

---

## Second opinion (risky items only, `challenger`)
<!-- Or "n/a: not a risky item". Each finding: scenario, detail, options with pros and cons, blocking? -->

---

## Test report (Stages 3–4)

| AC | Test file › test name | Before build | After build |
|---|---|---|---|
| AC1 | test-kit-files.sh › AC1 kit-version is exactly the v0.1.0 line | ❌ failing (expected) |  ✅ |
| AC2 | test-release-workflow.py › AC2 triggers only on v* tag pushes | ❌ failing (expected) |  ✅ |
| AC3 | test-release-workflow.py › AC3 every job has the repo guard | ❌ failing (expected) |  ✅ |
| AC4 | test-release-workflow.py › AC4 only GITHUB_TOKEN, contents write, checkout only | ❌ failing (expected) |  ✅ |
| AC5 | test-check-release.sh › AC5 mismatched tag refused | ❌ failing (expected) |  ✅ |
| AC6 | test-check-release.sh › AC6 matching tag on main passes | ❌ failing (expected) |  ✅ |
| AC7 | test-check-release.sh › AC7 wrong prefix refused | ❌ failing (expected) |  ✅ |
| AC8 | test-check-release.sh › AC8 pre-release tag refused | ❌ failing (expected) |  ✅ |
| AC9 | test-check-release.sh › AC9 tag off main refused | ❌ failing (expected) |  ✅ |
| AC10 | verified on GitHub after merge (Release run green + gh api) | manual / after merge | |
| AC11 | verified on GitHub after merge (gh api labels) | manual / after merge | |
| AC12 | reviewer ticks five README points | manual / reviewer | |
| AC13 | test-kit-files.sh › AC13 README backlog conventions | ❌ failing (expected) |  ✅ |
| AC14 | test-kit-files.sh › AC14 kit/specs exists and is documented | ❌ failing (expected) |  ✅ |
| AC15 | test-kit-files.sh › AC15 README delete list | ❌ failing (expected) |  ✅ |
| AC16 | test-kit-files.sh › AC16 index.html delete list | ❌ failing (expected) |  ✅ |
| AC17 | test-site.cjs › AC17 files table lists kit/ and release.yml as delete (screens on/off) | ❌ failing (expected) |  ✅ |
| AC18 | test-site.cjs › AC18 git rm line includes all kit-only paths (screens on/off) | ❌ failing (expected) |  ✅ |
| AC19 | test-site.cjs › AC19 no horizontal overflow or console errors at 375px | ✅ passes before build (regression guard: site is unchanged so far; flagged) |  ✅ |
| AC20 | test-site.cjs › AC20 no external requests | ✅ passes before build (regression guard; flagged) |  ✅ |
| Edge | test-check-release.sh › 11 EDGE tests (CRLF, annotated tag, missing/empty/2-line/leading-space file, no-v/short/unknown tag, TAG unset, bad main ref) | ❌ failing (expected) |  ✅ |
| Edge | re-run, guard skip in fork, two tags on one commit | manual / reviewer reads release.yml | |

**Checks (after build):** `bash kit/scripts/test-all.sh` exit 0, 0 FAIL (28 PASS); `.github/workflows/*.yml` parse as YAML.
**Checks (before build):** `bash kit/scripts/test-all.sh` run before build: all feature tests fail as expected; AC19/AC20 pass trivially (guards).
**Screenshots:** <!-- UI changes: light + dark at phone width, attached to the PR — or "n/a" -->

---

## Build notes (Stage 4)

- **Deviations from plan:** none
- **Parked ideas:** a kit CI workflow that runs `bash kit/scripts/test-all.sh` on PRs (tests currently run locally only; see Residual risk).

---

## Review (Stage 5)

**Verdict:** ready for owner

`bash kit/scripts/test-all.sh`: exit 0, 28 PASS / 0 FAIL (16 check-release, 3 workflow, 5 file/grep, 4 Playwright). `release.yml` and `pages.yml` both parse with PyYAML. `.kit-version` is exactly `project-starter-kit v0.1.0\n` (27 bytes). Script modes are `100755` as planned. Commits on the branch go tests first, then the build.

No blocking findings. All of these are low or informational:

| # | Severity | file:line | Finding | Failure scenario |
|---|---|---|---|---|
| 1 | Low (docs) | `README.md:104` | The "Local dry run" command only works once a local `v0.1.0` tag exists. Check 3 needs `refs/tags/$TAG`. So it can't be used as a check *before* tagging. | The owner runs it after bumping `.kit-version` but before tagging. It prints `no such tag in this repository` and exits 1, which looks like a failure. Wording fix (e.g. "after `git tag vX.Y.Z` locally, before pushing it") could go in this PR or a later one. |
| 2 | Low (test) | `kit/scripts/test-kit-files.sh:24` | The AC13 needle `gh` matches almost any English text ("through", "right"…). That part of AC13 passes trivially. | A later edit drops "Claude creates the labels with `gh`", and AC13 still passes. I checked by hand: `README.md:116` states it today. A tighter needle would be `` `gh` ``. |
| 3 | Info (security) | `.github/workflows/release.yml:18,25` | `check-release.sh` runs from the **tagged** commit, and checkout keeps the `contents: write` token in `.git/config` (`persist-credentials` is on by default). If a tagged side-branch commit has a modified script, it could skip the off-main check. | This needs push access to tags, and anyone with that can already create releases. So nothing is escalated, and a public outsider can't trigger it (forks or template copies: job skipped by the guard). Possible hardening, parked: `persist-credentials: false` and/or run the script from `origin/main`. Not built, because the plan fixed the exact YAML. |
| 4 | Info | `release.yml:5-7` | GitHub creates no `push` events when more than 3 tags are pushed at once. | `git push --tags` with 4+ new tags: no run and no release. The documented flow pushes one tag (`git push origin v0.1.0`), so no change is needed. |
| 5 | Info | `release.yml:18` | `actions/checkout@v4` is pinned by major version, not by SHA. | This matches `pages.yml` and the owner's plan decision. It's GitHub's own action, so I accept it. |
| 6 | Trivial | `site/index.html:357` | The text says "the kit's releases and task files". The plan said "the kit's own releases and task files". | None. It's a one-word wording difference. |

**Workflow behaviour (checked by reading, can't be run without pushing tags):**
- Trigger: only `push` of tags matching `v*` (glob `*` doesn't cross `/`). No branches, PRs or schedule. ✅
- Repo guard on the only job (`release`), the same string as `pages.yml`. In a template copy or fork the job is **skipped** (not failed), no release is made and no secret is used. ✅
- Permissions: top-level `contents: write` only, and no job-level override. The only secret is `GITHUB_TOKEN`. ✅
- Injection: `${{ github.ref_name }}` shows up only in `env:` and in the `concurrency.group` expression (not a shell). The `run:` blocks contain no `${{ }}`. `TAG` is regex-checked (`^v[0-9]+\.[0-9]+\.[0-9]+$`) before any git call, and is always quoted. I tried `v1.0.0$(id)` and a newline-suffixed tag locally: both are refused at check 2. ✅
- `gh release create "$TAG" --verify-tag --generate-notes --title "$TAG"`: no `--prerelease` and no `--draft`. ✅
- Re-run, or the same tag pushed again with its release already there: check-release passes again, `gh release view` succeeds, the step prints "already exists; leaving it unchanged." and exits 0. The run is green and the notes are untouched. If `view` fails for another reason (API error), `create` then fails because the release exists, so the run is red: a safe failure. `concurrency` (per tag, no cancel) serialises duplicate runs. ✅
- Two tags on one commit: each tag gets its own run and its own concurrency group. I checked it locally: `v0.1.0` → OK (exit 0), `v0.1.1` → "Bump .kit-version…" (exit 1, red, no release). ✅
- `fetch-depth: 0` fetches all branches as `refs/remotes/origin/*` plus tags, so `MAIN_REF=origin/main` resolves. A tag on a pre-B-001 `main` commit has no `kit/scripts/check-release.sh`, so the run is red with no release (safe). ✅

**`check-release.sh`:** it matches the interface table exactly: order, exit codes 2/1/1/2/1/1/1/1/1, messages and stderr/stdout. `.kit-version` is read only via `git show refs/tags/$TAG:.kit-version`, and annotated tags peel correctly (EDGE test). The trailing-whitespace strip handles CRLF and whitespace-only content (gives empty → "is empty"). Bash `=~` anchors at the whole string, so a second line or a leading space fails (EDGE tests). `set -euo pipefail` causes no problems: every failing command sits on the left of `||`, and `${TAG:-}`/`${MAIN_REF:-}` defaults avoid `-u` aborts. `refs/tags/` is explicit, so a branch named like the tag can't be confused with it.

**AC → test:** AC1–AC9 and AC13–AC20 each have a test that really exercises them. I mutation-checked by reading: AC5/AC9 assert the specific message, not only the exit code. The weak spot is the `gh` needle in AC13 (finding 2). AC19/AC20 passed before the build by design: they guard against regressions, as flagged in the Test report. Every spec edge case is either an EDGE test or one of the read-checks above. AC10/AC11 are post-merge GitHub checks, as planned.

**AC12 (reviewer's manual check, README "Kit versions and releases")**
- [x] SemVer 0.x, first release `v0.1.0`
- [x] `.kit-version` is exactly `project-starter-kit vX.Y.Z`, and projects keep it
- [x] Release notes in GitHub Releases, no kit changelog file
- [x] Steps: bump `.kit-version` in a PR → merge → push the `vX.Y.Z` tag on the `main` commit
- [x] Refuses a mismatched line, a pre-release or non-`vX.Y.Z` tag, and a tag off `main`

**Plan fidelity:** every file in the plan's Files table is present and matches it (YAML byte-for-byte with the plan, plus the header comment). Nothing extra was built. The kit CI idea is parked in Build notes. No root templates were touched. The delete list is the same in all places: README step 2, `site/index.html:357`, the playground files table and the `git rm` array, and the `release.yml`/`check-release.sh` header comments. No other doc names the old two-item list. There's no CHANGELOG to update: by owner decision the kit uses GitHub Releases, and the root `CHANGELOG.md` is a template.

**Guardrail self-check (kit rules)**
- [x] **Free (S$0):** GitHub Actions on a public repo, the preinstalled `gh`, GitHub's own `actions/checkout`. No new service and no dependency added.
- [x] **Public repo, no secrets:** only the built-in `GITHUB_TOKEN`. Test repos use `test@example.invalid`. No personal data in the diff.
- [x] **Kit-only files don't burden projects:** `release.yml` is guarded and on the delete list. `kit/` is on the delete list everywhere. `.kit-version` is meant to be kept.
- [x] **Site has no external requests:** only copy and JS array edits, no CSS or script. AC20 (Playwright request log) and AC19 (375 px, light/dark/old state, zero console errors) both pass.
- [x] **Claude never merges, PR only when asked:** no PR opened. The tag push and label creation stay after merge, and only when the owner asks.
