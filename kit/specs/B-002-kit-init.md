# B-002 — /kit-init: set up a new project in one grilling session

**Feature:** n/a (kit work, tracked in [issue #3](https://github.com/Eugenelcc/project-starter-kit/issues/3)) · **Branch:** `feat/B-002-kit-init` · **Status:** awaiting owner approval (Requirements)
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
Kit work, [issue #3](https://github.com/Eugenelcc/project-starter-kit/issues/3)
(no PRD feature ID: the root `PRD.md` is a template). Setting up a project
from the kit today means following six manual steps (README "Start a new
project") and filling about 100 `<placeholders>` across six files with no
help. This is slow, easy to get wrong (kit-only files left behind,
`<full CI command>` left in the agent files), and it skips the kit's own
"grill first, never assume" process at the moment it matters most.
`/kit-init` runs that setup as one resumable grilling session.

### Platform facts
Verified by the main session from
<https://code.claude.com/docs/en/skills.md> on 2026-11-01. Later agents rely
on these and don't need to re-check them.
- Project skill path: `.claude/skills/<name>/SKILL.md`, invoked with
  `/<name>`. `.claude/commands/*.md` still works, but skills are recommended
  for new work.
- All frontmatter is optional. `description` is recommended. `name` defaults
  to the folder name. `description` + `when_to_use` must be ≤ 1,536
  characters combined.
- `disable-model-invocation: true` means only the user can invoke it, via
  `/name`. Claude won't load it on its own.
- Supporting files can sit beside `SKILL.md` and are referenced by relative
  Markdown links (e.g. `[reference.md](reference.md)`).
- Keep `SKILL.md` under 500 lines; move detail into supporting files.
- Project skills load in sessions started in that repo. Not stated in the
  docs: whether a plain project skill waits for the workspace trust dialog.
  `allowed-tools` applies even in untrusted folders, so be conservative with
  it.

### User stories
- As **a new-project owner on a PC** who has just clicked *Use this
  template*, I want to type `/kit-init` and be asked plain-language
  questions until PRD, GUARDRAILS, CLAUDE, (DESIGN), BACKLOG and the test and
  CI commands are filled in, so that my project starts from real decisions
  and not from guesses or leftover kit files.
- As **an owner on a phone or in a cloud session** who has to stop halfway, I
  want to run `/kit-init` again later, possibly in a different session, and
  carry on where I stopped without answering confirmed questions again, so
  that setup can span several short sittings.
- As **an owner who has already written part of the PRD**, I want
  `/kit-init` to keep my words, ask only about what's still a
  `<placeholder>`, and ask me when my text and an answer disagree, so that
  my own writing is never silently rewritten.
- As **someone who runs `/kit-init` in the kit repo by mistake** (for
  example, the kit owner working on the kit), I want it to refuse before it
  changes anything, so that the templates stay templates.
- As **the kit owner**, I want free, repeatable checks over the skill files
  plus one recorded dry run, so that I can trust a skill whose behaviour is
  written in prose, without paying for an API in CI.

### Acceptance criteria
Each criterion is proven by exactly one check, marked:
- **Auto:** a local, repeatable `bash`/`python3`/`node` check over the files,
  or a throwaway-repo harness that runs no LLM. It is added to
  `bash kit/scripts/test-all.sh`.
- **Dry run Ax / Bx:** a numbered step of the scripted dry run. Claude runs
  it once, following `/kit-init`, in three throwaway local folders (never
  pushed) made from a copy of this branch. The owner's answers come from a
  fixed answer script written in Stage 3. The transcript is shared with the
  owner. **Repo A** is the full run. **Repo B** is a short run for the "no"
  and "unknown" paths. **Folder C** covers starting with no git repo.
  - Repo A seed: `origin` set to `https://github.com/example/dry-run` (never
    pushed), on `main`. PRD §1 *Summary* holds owner text. PRD §3 *Target
    user* holds owner text that contradicts one scripted answer. An untracked
    file `notes.txt` is present. One answer is ≥ 2,000 characters, in several
    paragraphs. At least two questions are answered "don't know yet". The
    project has no screens. The CI command answer is `bash scripts/ci.sh`,
    and that file doesn't exist.
  - Repo B seed: a git repo with **no remote**, on `main`. The project has
    screens and no tests yet. The owner says no to the first-commit question.
  - Folder C seed: the same files with **no `.git`** at all.

"Skill folder" = `.claude/skills/kit-init/` (`SKILL.md` plus its supporting
files). "Kit-only paths" = `site/`, `kit/`, `.github/workflows/pages.yml`,
`.github/workflows/release.yml`. "Progress file" =
`.claude/skills/kit-init/progress.md`. "Setup branch" = `chore/kit-init`.
"WORKFLOW fill placeholders" = `<Project name>`, `<@github-handle>`,
`<YYYY-MM-DD>`, the `<How it deploys…>` line (Stage 6), the
`<Project-specific>` checklist line (§4), `<scripts/ci.sh>`,
`<test command>` and `<full CI command>`. WORKFLOW's syntax placeholders
(`<slug>`, `<type>`, `<date>`, `<branch>`, `<backlog-id>`) are not fill
placeholders and stay.

**A. Skill file is valid** (decision 9, platform facts)

| # | Given | When | Then |
|---|---|---|---|
| AC1 | The branch | `.claude/skills/kit-init/SKILL.md` is read | It exists. Its frontmatter parses as YAML. `name` is absent or exactly `kit-init`. `description` is non-empty. `description` + `when_to_use` (if present) total ≤ 1,536 characters. *Auto.* |
| AC2 | `SKILL.md` frontmatter | It is parsed | `disable-model-invocation` is the boolean `true`. *Auto.* |
| AC3 | `SKILL.md` | Its lines are counted | It has fewer than 500 lines. *Auto.* |
| AC4 | The skill folder | Every relative Markdown link in every file in it is resolved | Each link points to an existing file inside the skill folder, and every supporting file is linked from `SKILL.md` or from another linked file. *Auto.* |
| AC5 | `SKILL.md` frontmatter | It is parsed | It has no `allowed-tools` key, so every write, `git rm` and commit goes through the normal permission prompts (platform facts: be conservative). *Auto.* |

**B. The skill names every file and rule it must follow** (decisions 1–7, 9; Q1, Q2, Q5–Q7, Q10, Q11)

| # | Given | When | Then |
|---|---|---|---|
| AC6 | The skill folder | It is searched | It names all four kit-only paths, `git rm`, and says they are removed only after an explicit yes (decision 1). *Auto.* |
| AC7 | The skill folder | It is searched | It names `PRD.md`, `GUARDRAILS.md`, `CLAUDE.md`, `BACKLOG.md`, `B-001`, `DESIGN.md`, `WORKFLOW.md`, `.claude/agents/`, `<test command>`, `<full CI command>` and `CHANGELOG.md`. It says only `<full CI command>` is replaced in `RUNBOOK.md`, that `README.md` is not filled, that `.kit-version` is not changed, and that no CI script is created (decision 3, Q5–Q7). *Auto.* |
| AC8 | The skill folder | It is searched | It states the grilling rules: at most 4 questions a round; a plain-language scenario first, then the detail; every option with pros and cons; a marked recommendation. It links to or names WORKFLOW.md's *Grilling* section. *Auto.* |
| AC9 | The skill folder | It is searched | It states: one recap per file, and a file is written only after the owner confirms that recap (decision 4). It keeps existing text, asks only about the remaining `<placeholders>`, and asks on conflict (decision 5). Unanswered items stay `<placeholders>`, are listed at the end, and no fact is invented (decision 6). *Auto.* |
| AC10 | The skill folder | It is searched | It names `.claude/skills/kit-init/progress.md`, says confirmed answers are saved there and committed after each confirmed recap, says a re-run resumes from it, and says it is removed at the end (decision 2, Q1). *Auto.* |
| AC11 | The skill folder | It is searched | Its last step is removing `.claude/skills/kit-init/`, and only after asking (decision 7). *Auto.* |
| AC12 | The skill folder | It is searched | It contains none of: `git rm -f`, `--force`, `git reset --hard`, `git clean`, `git stash`, `git checkout --`, `git merge`, `git push`. *Auto.* |
| AC13 | The skill folder | It is searched | It names the branch `chore/kit-init`, says it asks before its first commit, says it never commits to `main`, and says the owner pushes and merges. It explains that the branch name is a one-off exception to `<type>/<B-id>-<slug>`, because setup comes before the backlog exists (Q2). *Auto.* |
| AC14 | The skill folder | It is searched | It says: if the owner says no to the first commit, it never commits and never asks again, warns once that resuming from another session or a phone won't work, and the end summary says to branch and commit by hand (Q10). It says: if `chore/kit-init` exists locally or on `origin`, it asks to switch to it before starting fresh. With no git repo, it asks "May I run git init?", runs `git init` only on yes, and on no stops and explains that cleanup needs git (Q11). *Auto.* |

**C. Repo check: kit, fork, no remote, no git, setup branch** (decision 8, Q3, Q4, Q11)

The repo check is a deterministic script in the skill folder, run with no
LLM. It reports one of three results: **refuse**, **ask** or **ok**.

| # | Given | When | Then |
|---|---|---|---|
| AC15 | Throwaway git repos with `origin` set to each of `https://github.com/Eugenelcc/project-starter-kit`, the same with `.git`, `git@github.com:Eugenelcc/project-starter-kit.git`, and a different-case `https://github.com/eugenelcc/Project-Starter-Kit` | The repo check runs in each | It reports **refuse** every time, its message says this is the kit repo and `/kit-init` is for new projects, and `git status --porcelain` is unchanged afterwards. *Auto (harness).* |
| AC16 | A throwaway git repo with `origin` set to `https://github.com/example/my-app` | The repo check runs | It reports **ok**. *Auto (harness).* |
| AC17 | A throwaway git repo with no remote, and a throwaway folder that isn't a git repo | The repo check runs in each | It reports **ask**, with the question "Is this a new project, not the kit itself?", and changes nothing. *Auto (harness).* |
| AC18 | Throwaway git repos with `origin` set to `https://github.com/someone/project-starter-kit` and `git@github.com:someone/project-starter-kit.git` | The repo check runs in each | It reports **ask**, with a warning that the repo is named `project-starter-kit` and may be a fork of the kit, and a yes/no question about continuing. *Auto (harness).* |
| AC19 | `SKILL.md` | Its steps are read in order | Running the repo check is the first step, before cleanup and before any other question. It says: on **refuse**, stop without changing any file; on **ask**, ask the check's question once and continue only on an explicit yes. *Auto (the check's mention comes before the first kit-only path and the first file to fill, and the refuse/ask rules are stated).* |
| AC20 | Repo B (no remote) | `/kit-init` starts | It asks "Is this a new project, not the kit itself?" once, before anything else, and continues only after the scripted "yes". *Dry run B1.* |
| AC21 | Throwaway git repos: one with a local `chore/kit-init` branch; one whose `origin` (a local bare repo, fetched) has `chore/kit-init` but with no local branch; one with neither | The repo check runs in each | It reports the setup branch as found locally, found on `origin`, and not found, in that order, and changes nothing. *Auto (harness).* |
| AC22 | Folder C (no `.git`), the owner has answered "yes, it's a new project" | The skill asks "May I run git init?" and the owner says "no" | It stops, explains that cleanup needs git, and the folder is unchanged (still no `.git`, no file changed). *Dry run C1.* |
| AC23 | Folder C, `/kit-init` run again | The owner says "yes" to "May I run git init?" | `.git` exists afterwards, and the skill goes on to the cleanup step. *Dry run C2 (the run stops there).* |

**D. Behaviour, proven by the dry run** (decisions 1–7, Q1, Q2, Q5–Q7, Q10, Q11)

| # | Given | When | Then |
|---|---|---|---|
| AC24 | Repo A, untracked `notes.txt` | `/kit-init` starts | Before cleanup it says the working tree isn't clean, names `notes.txt`, and asks whether to continue. At the end `notes.txt` still exists, byte-identical, untracked and in no commit. *Dry run A1.* |
| AC25 | Repo A | The cleanup step runs | It lists exactly the four kit-only paths and asks. Nothing is removed before the answer. *Dry run A2.* |
| AC26 | Repo A, the owner answers "yes" to cleanup | The run is finished | The four paths are absent from the tip of `chore/kit-init`, and no other path was deleted. *Dry run A3.* |
| AC27 | Repo B, the owner answers "no" to cleanup | Setup continues | All four kit-only paths are still present and unchanged, the skill moves on to `PRD.md`, and the end summary lists them as kept. *Dry run B2.* |
| AC28 | Repo A, the first file recap is confirmed | The first commit is about to happen | The skill asks before committing, names `chore/kit-init`, and only after the scripted "yes" creates that branch and commits there. *Dry run A4.* |
| AC29 | Repo A, the run is finished | The branches are inspected | `main` points to the same commit as in the seed. Each confirmed file (and the cleanup) has a commit on `chore/kit-init`. Nothing was pushed. *Dry run A5.* |
| AC30 | Repo B, the first file recap is confirmed, and the owner says "no" to the first-commit question | The rest of the run happens | The skill warns once that resuming from another session or a phone won't work, never asks about committing again, and `git log --all` at the end shows only the seed commits. *Dry run B3.* |
| AC31 | Repo B, the owner said "no" to committing | The end summary is shown | It tells the owner to create a branch and commit the setup changes themselves. *Dry run B7.* |
| AC32 | Repo A, the whole run | Every question round in the transcript is checked | Each round has at most 4 questions. Each question gives a plain-language scenario before detail. Each option has pros and cons. Each question has exactly one marked recommendation. *Dry run A6 (checks the whole transcript).* |
| AC33 | Repo A | Files are worked on | `PRD.md` → `GUARDRAILS.md` → `CLAUDE.md` → (`DESIGN.md` step) → `BACKLOG.md` come first, in that order, before the WORKFLOW, agents, RUNBOOK and CHANGELOG steps. Self-removal is last. *Dry run A7.* |
| AC34 | Repo A, a file's recap is shown, and the owner corrects one point before confirming | The file is written | The file's hash is unchanged until the confirmation. The written file has the corrected point, not the original one. *Dry run A8.* |
| AC35 | Repo A, PRD §1 holds owner text | `PRD.md` is filled | §1 is byte-identical to the seed, and no question about §1 was asked. *Dry run A9.* |
| AC36 | Repo A, PRD §3 holds owner text that contradicts a scripted answer | The answer is given | Before writing, the skill shows both texts and asks which to keep. §3 matches the owner's choice. *Dry run A10.* |
| AC37 | Repo A, two questions answered "don't know yet" | Those files are written | The matching `<placeholders>` stay verbatim. *Dry run A11.* |
| AC38 | Repo A, the run is finished | The end summary is compared with `grep -o '<[^>]*>'` over `PRD.md`, `GUARDRAILS.md`, `CLAUDE.md`, `BACKLOG.md`, the WORKFLOW fill placeholders in `WORKFLOW.md`, and `<test command>` / `<full CI command>` in `.claude/agents/*.md` and `RUNBOOK.md` | The summary lists every remaining placeholder by file, and nothing else. *Dry run A12.* |
| AC39 | Repo A, the run is finished | The reviewer compares the diff of every filled file with the answer script and the seed | Every added or changed line comes from an answer, the seed, the template, or today's date. No fact is invented. *Dry run A13.* |
| AC40 | Repo A, one answer is ≥ 2,000 characters, in several paragraphs | It is saved and written | The progress file holds it in full, and the recap shows exactly the text that ends up in the file (no silent truncation). *Dry run A14.* |
| AC41 | Repo A, the owner confirms the BACKLOG recap | `BACKLOG.md` is written | *Now* has a `B-001` row and paragraph with the title, feature ID and accept line from the answers. *Dry run A15.* |
| AC42 | Repo A, the project has no screens | The `DESIGN.md` step runs | It offers to delete `DESIGN.md` and asks. On "yes", `DESIGN.md` is absent from the tip of `chore/kit-init`. *Dry run A16.* |
| AC43 | Repo B, the project has screens | The `DESIGN.md` step runs | `DESIGN.md` is filled after its recap is confirmed, and not deleted. *Dry run B4.* |
| AC44 | Repo A, the WORKFLOW step | Its recap is shown and confirmed | Project name, GitHub handle, today's date and the CI script path (`scripts/ci.sh`) are reused from earlier answers without being asked again. The deploy line and the project-specific checklist line are asked. WORKFLOW gets its own recap before it is written. *Dry run A17.* |
| AC45 | Repo A, WORKFLOW and agents are written | `git diff` against the seed is taken for `WORKFLOW.md` and `.claude/agents/*.md` | In `WORKFLOW.md` only WORKFLOW fill placeholders changed, and no answered one remains. In the agents only `<test command>` / `<full CI command>` changed, and neither remains. *Dry run A18.* |
| AC46 | Repo A, the run is finished | `git diff` against the seed is taken for `RUNBOOK.md` | The only change is `<full CI command>` replaced by the given command. Every other RUNBOOK placeholder is untouched. *Dry run A19.* |
| AC47 | Repo A, the CHANGELOG step | The owner answers "yes" to the reset question | No content questions were asked. `CHANGELOG.md` keeps its title, intro and format lines, has no guidance comment, no `[0.1.0]` entry and no `<placeholder>`, and ends with an empty `## [Unreleased]` section. *Dry run A20.* |
| AC48 | Repo A, the CI command is `bash scripts/ci.sh`, and the file doesn't exist | The run is finished | `scripts/ci.sh` was not created, and the end summary lists "create `scripts/ci.sh`". *Dry run A21.* |
| AC49 | Repo B, the owner says there are no tests yet | That step finishes | `<test command>` stays verbatim in `WORKFLOW.md` and `test-writer.md`, and the end summary lists it. *Dry run B6.* |
| AC50 | Repo A, the first file recap is confirmed | The progress file is inspected | `.claude/skills/kit-init/progress.md` holds the confirmed answers and the `.kit-version` line, and is included in that recap's commit on `chore/kit-init`. *Dry run A22.* |
| AC51 | Repo A, `GUARDRAILS.md` is confirmed, the run is stopped, and `main` is checked out | A fresh session (no memory of the first) runs `/kit-init` on `main` | It says `chore/kit-init` exists and asks to switch to it before starting fresh. After the scripted "yes" it says it's resuming from the progress file, asks none of the questions already confirmed, and continues with `CLAUDE.md`. *Dry run A23.* |
| AC52 | Repo B, a progress file whose recorded kit version differs from `.kit-version` | `/kit-init` runs | It names both versions and asks whether to continue or start over, before any setup question. *Dry run B5 (Repo B is stopped after B4, the version line in `progress.md` is edited, and the run restarted).* |
| AC53 | Repo A, all files are written | Self-removal is offered and the owner says "yes" | It was the last question. `.claude/skills/kit-init/` (with `progress.md`) is absent from the tip of `chore/kit-init`. *Dry run A24.* |
| AC54 | Repo A, the run is finished | `README.md` and `.kit-version` are compared with the seed | Both are byte-identical. *Dry run A25.* |

**E. Docs and existing checks** (decision 10, Q8, Q9)

| # | Given | When | Then |
|---|---|---|---|
| AC55 | README "Start a new project with it" | It is read | It recommends running `/kit-init` before the manual steps. The manual steps stay as the alternative and still name the four kit-only paths. *Auto (grep and order).* |
| AC56 | README manual steps | They are read | They say deleting `.claude/skills/kit-init/` is optional, if you won't use `/kit-init`. The required delete list doesn't include it. *Auto (grep).* |
| AC57 | README "What's inside" | It is read | A row names `.claude/skills/kit-init/` and says it removes itself at the end of setup. *Auto (grep).* |
| AC58 | `site/index.html` "From template to first task" | It is read | It recommends `/kit-init` before the manual steps. The manual delete step still names the four paths and calls deleting `.claude/skills/kit-init/` optional, if you won't use `/kit-init`. *Auto (grep and order).* |
| AC59 | `site/playground.html` setup tab, screens on and off | It renders | It shows `/kit-init` as the recommended start. The manual checklist, files table and `git rm` line are still there. The page says deleting `.claude/skills/kit-init/` is optional, and the `git rm` line does not include it. *Auto (Playwright, in `test-site.cjs`).* |
| AC60 | The branch | `bash kit/scripts/test-all.sh` runs | It exits zero, includes the new checks, and the existing B-001 checks (AC1, AC13–AC20 of B-001) still assert at least what they asserted before. *Auto.* |
| AC61 | The branch | `.kit-version` is read | It is still exactly `project-starter-kit v0.1.0`. The bump to `v0.2.0` is a separate release PR after merge (Q9). *Auto (the existing B-001 AC1 check, unchanged).* |
| AC62 | The branch vs `main` | The diff of the root templates (`PRD.md`, `GUARDRAILS.md`, `CLAUDE.md`, `BACKLOG.md`, `DESIGN.md`, `WORKFLOW.md`, `RUNBOOK.md`, `CHANGELOG.md`, `.claude/agents/`, `docs/`) is taken | It is empty. In the kit repo, they stay templates. *Auto.* |

### Edge cases
- **No git remote, or not a git repo at all** (e.g. a downloaded zip): asks
  "Is this a new project, not the kit itself?" once, and continues only on
  yes (AC17, AC20). With no git repo, it then asks "May I run git init?",
  runs it only on yes, and on no stops and explains that cleanup needs git
  (AC22, AC23).
- **Fork, or any other repo named `project-starter-kit`:** warns and asks
  yes/no (AC18). `Eugenelcc/project-starter-kit` in any URL form is always
  refused (AC15).
- **Dirty working tree:** the skill names the changed and untracked files,
  then asks (AC24). It never stashes, resets, cleans or forces a removal
  (AC12), and commits only the files it wrote. If `git rm` refuses because a
  kit-only file has local edits, the skill shows the real message and asks.
  It never adds `-f`.
- **Some kit-only paths already deleted by hand:** it lists only the ones
  still present. If none are present, it skips the question.
- **Owner says no to cleanup:** nothing is removed, setup continues, and the
  end summary lists the kept files (AC27).
- **Owner says no to the first-commit question:** no commit is ever made,
  and it is not asked again. One warning says resuming from another session
  or a phone won't work. The end summary says to branch and commit by hand
  (AC30, AC31). Resuming on the same machine still works from the
  uncommitted progress file.
- **`chore/kit-init` already exists**, locally or on `origin`: the skill
  says so and asks to switch to it before starting fresh (AC21, AC51). It
  never creates a second setup branch.
- **Owner says no to self-removal:** the skill folder stays, and
  `progress.md` is still removed (decision 2) and that removal committed.
  The end summary says how to remove the folder. A later `/kit-init` (no
  progress file) starts again. By decision 5 it keeps everything already
  written and asks only about the `<placeholders>` left.
- **Owner says no to the CHANGELOG reset:** `CHANGELOG.md` is unchanged, and
  the end summary lists it as still a template.
- **Progress file from a different kit version:** it names both versions and
  asks (AC52).
- **Progress file present but unreadable or hand-edited into nonsense:** it
  says so, shows what it could read, and asks whether to start over. It
  never guesses the missing answers.
- **Resuming in a different session or on a different machine:** works when
  the owner has pushed `chore/kit-init` and the session is on that branch.
  The resumed session re-reads the files already written and doesn't rely on
  chat memory. A session that starts on `main` finds `chore/kit-init` and
  asks to switch (AC51).
- **Owner edits a filled file by hand between sessions:** on resume, the
  skill treats it as existing text (decision 5). It keeps the edit and asks
  if it conflicts with a saved answer.
- **No tests yet, so no test command:** `<test command>` stays and is listed
  (AC49). The same applies to `<full CI command>`, in WORKFLOW, the agents
  and RUNBOOK.
- **CI script path given but the file doesn't exist:** not created; listed
  as "create `<path>`" in the end summary (AC48).
- **No screens, `DESIGN.md` deleted, and screens added later:** the deletion
  was a committed `git rm`, so the file comes back from git history or the
  kit template. `/kit-init` doesn't track it later. If the PRD answers
  mention screens but the owner says "no screens", that's a conflict, and the
  skill asks (decision 5).
- **Very long answers:** stored and written in full, never truncated. The
  recap shows exactly what will be written (AC40).
- **Owner answers more than was asked, or answers a later file's question
  early:** the answer is saved for that later file and shown again in that
  file's recap. It is not written early (decision 4).
- **Owner stops mid-round** (before a recap is confirmed): unconfirmed
  answers aren't saved, so that round is asked again on resume (decision 2
  saves only confirmed answers).
- **`.kit-version` missing in the new project:** the progress file records
  "missing", and the end summary says so. `/kit-init` never creates or edits
  `.kit-version`.

### Out of scope
- Stack presets (parked).
- Kit sync, i.e. pulling kit updates into existing projects (parked).
- Filling `README.md`, or any `RUNBOOK.md` placeholder other than
  `<full CI command>` (decision 3, Q6).
- Creating the CI script or any other code (Q7).
- Content questions for `CHANGELOG.md` (Q5: reset only).
- Running the dry run in CI, or any paid or LLM API in an automated check
  (decision 9).
- Pushing, opening PRs, merging, or committing to `main` from `/kit-init`
  (Q2).
- Changing the root templates in the kit repo (AC62).
- Bumping `.kit-version`, tagging or publishing `v0.2.0`. That's a separate
  release PR after merge, then the owner's tag (Q9).

### Open questions for the owner
None. Answered by owner, 2026-11-01:
- **Q1 → C.** The progress file is `.claude/skills/kit-init/progress.md`.
  It is committed after each confirmed recap and removed with the skill
  folder.
- **Q2 → B.** `/kit-init` asks before its first commit, then commits each
  confirmed file on `chore/kit-init`. That name is a documented one-off
  exception to `<type>/<B-id>-<slug>`, because setup comes before the
  backlog. The owner pushes and merges. It never commits to `main`.
- **Q3 → A.** With no remote, or no git, it asks once "Is this a new
  project, not the kit itself?" and continues only on yes.
- **Q4 → C.** It always refuses `Eugenelcc/project-starter-kit`, in any URL
  form. For any other repo named `project-starter-kit`, it warns and asks
  yes/no.
- **Q5 → B.** After asking, it resets `CHANGELOG.md` to an empty
  `[Unreleased]` section, with no content questions. `.kit-version` stays
  unchanged.
- **Q6 → C.** It fills WORKFLOW's other placeholders, reusing answers it
  already has and asking about the deploy line and the project-specific
  line, with a WORKFLOW recap. In `RUNBOOK.md` it replaces only
  `<full CI command>`.
- **Q7 → A.** It does not create the CI script. The end summary lists
  "create `<script path>`".
- **Q8 → C.** The manual steps (README, site, playground) say deleting
  `.claude/skills/kit-init/` is optional, if you won't use `/kit-init`. It is
  not added to the `git rm` line.
- **Q9 → B.** `.kit-version` stays `v0.1.0` in B-002. A separate small
  release PR bumps it after merge.

- **Q10 → A.** If the owner says no to the first-commit question, it
  continues without ever committing and doesn't ask again. It warns once
  that resuming from another session or a phone won't work, and the end
  summary says to branch and commit by hand.
- **Q11 → C.** It detects an existing `chore/kit-init` (locally or on
  `origin`) and asks to switch to it before starting fresh. With no git
  repo, it asks "May I run git init?" and runs it only on yes. On no it
  stops, explaining that cleanup needs git.

No open questions remain.

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
