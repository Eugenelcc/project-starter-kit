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
  it once, following `/kit-init`, in two throwaway local repos (never
  pushed) made from a copy of this branch, with `origin` set to a non-kit
  URL. The owner's answers come from a fixed answer script written in Stage 3.
  The transcript is shared with the owner. **Repo A** is the full run.
  **Repo B** is a short run for the "no" paths.
  - Repo A seed: PRD §1 *Summary* holds owner text. PRD §3 *Target user*
    holds owner text that contradicts one scripted answer. An untracked file
    `notes.txt` is present. One answer is ≥ 2,000 characters, in several
    paragraphs. At least two questions are answered "don't know yet". The
    project has no screens.
  - Repo B seed: no changes. The project has screens and no tests yet.

"Skill folder" = `.claude/skills/kit-init/` (`SKILL.md` plus its supporting
files). "Kit-only paths" = `site/`, `kit/`, `.github/workflows/pages.yml`,
`.github/workflows/release.yml`. "Progress file" = the file named in
answer Q1.

**A. Skill file is valid** (decision 9, platform facts)

| # | Given | When | Then |
|---|---|---|---|
| AC1 | The branch | `.claude/skills/kit-init/SKILL.md` is read | It exists. Its frontmatter parses as YAML. `name` is absent or exactly `kit-init`. `description` is non-empty. `description` + `when_to_use` (if present) total ≤ 1,536 characters. *Auto.* |
| AC2 | `SKILL.md` frontmatter | It is parsed | `disable-model-invocation` is the boolean `true`. *Auto.* |
| AC3 | `SKILL.md` | Its lines are counted | It has fewer than 500 lines. *Auto.* |
| AC4 | The skill folder | Every relative Markdown link in every file in it is resolved | Each link points to an existing file inside the skill folder, and every supporting file is linked from `SKILL.md` or from another linked file. *Auto.* |
| AC5 | `SKILL.md` frontmatter | It is parsed | It has no `allowed-tools` key, so every write and `git rm` goes through the normal permission prompts (platform facts: be conservative). *Auto.* |

**B. The skill names every file and rule it must follow** (decisions 1–7, 9)

| # | Given | When | Then |
|---|---|---|---|
| AC6 | The skill folder | It is searched | It names all four kit-only paths, `git rm`, and says they are removed only after an explicit yes (decision 1). *Auto.* |
| AC7 | The skill folder | It is searched | It names `PRD.md`, `GUARDRAILS.md`, `CLAUDE.md`, `BACKLOG.md`, `B-001`, `DESIGN.md`, `WORKFLOW.md`, `.claude/agents/`, `<test command>` and `<full CI command>`. It says `RUNBOOK.md` and `README.md` are not filled (decision 3). *Auto.* |
| AC8 | The skill folder | It is searched | It states the grilling rules: at most 4 questions a round; a plain-language scenario first, then the detail; every option with pros and cons; a marked recommendation. It links to or names WORKFLOW.md's *Grilling* section. *Auto.* |
| AC9 | The skill folder | It is searched | It states: one recap per file, and a file is written only after the owner confirms that recap (decision 4). It keeps existing text, asks only about the remaining `<placeholders>`, and asks on conflict (decision 5). Unanswered items stay `<placeholders>`, are listed at the end, and no fact is invented (decision 6). *Auto.* |
| AC10 | The skill folder | It is searched | It names the progress file's exact path, says confirmed answers are saved there as setup goes, says a re-run resumes from it, and says it is deleted at the end (decision 2). *Auto.* |
| AC11 | The skill folder | It is searched | Its last step is removing `.claude/skills/kit-init/`, and only after asking (decision 7). *Auto.* |
| AC12 | The skill folder | It is searched | It contains none of: `git rm -f`, `--force`, `git reset --hard`, `git clean`, `git stash`, `git checkout --`, `git merge`, `git push`. *Auto.* |

**C. Refuses in the kit repo** (decision 8)

| # | Given | When | Then |
|---|---|---|---|
| AC13 | Throwaway git repos with `origin` set to each of `https://github.com/Eugenelcc/project-starter-kit`, the same with `.git`, `git@github.com:Eugenelcc/project-starter-kit.git`, and a different-case `https://github.com/eugenelcc/Project-Starter-Kit` | The skill's repo check (a deterministic script in the skill folder, run with no LLM) runs in each | It exits non-zero every time, its message says this is the kit repo and `/kit-init` is for new projects, and `git status --porcelain` is unchanged afterwards. *Auto (harness).* |
| AC14 | A throwaway git repo with `origin` set to `https://github.com/example/my-app` | The repo check runs | It exits zero. *Auto (harness).* |
| AC15 | A throwaway git repo with no remote at all | The repo check runs | Behaves as answer **Q3** decides. *Auto (harness).* |
| AC16 | A throwaway git repo with `origin` set to a fork, `https://github.com/someone/project-starter-kit` | The repo check runs | Behaves as answer **Q4** decides. *Auto (harness).* |
| AC17 | `SKILL.md` | Its steps are read in order | Running the repo check is the first step, before cleanup and before any question. It says to stop without changing any file if the check fails. *Auto (the check's mention comes before the first kit-only path and the first file to fill).* |

**D. Behaviour, proven by the dry run** (decisions 1–7)

| # | Given | When | Then |
|---|---|---|---|
| AC18 | Repo A, untracked `notes.txt` | `/kit-init` starts | Before cleanup it says the working tree isn't clean, names `notes.txt`, and asks whether to continue. At the end `notes.txt` still exists, byte-identical. *Dry run A1.* |
| AC19 | Repo A | The cleanup step runs | It lists exactly the four kit-only paths and asks. Nothing is removed before the answer. *Dry run A2.* |
| AC20 | Repo A, the owner answers "yes" to cleanup | The step finishes | `git status` shows the four paths deleted, and nothing else deleted. *Dry run A3.* |
| AC21 | Repo B, the owner answers "no" to cleanup | Setup continues | All four kit-only paths are still present and unchanged, the skill moves on to `PRD.md`, and the end summary lists them as kept. *Dry run B1.* |
| AC22 | Repo A, the whole run | Every question round in the transcript is checked | Each round has at most 4 questions. Each question gives a plain-language scenario before detail. Each option has pros and cons. Each question has exactly one marked recommendation. *Dry run A4 (checks the whole transcript).* |
| AC23 | Repo A | Files are worked on | The order is `PRD.md` → `GUARDRAILS.md` → `CLAUDE.md` → (`DESIGN.md` step) → `BACKLOG.md` → the commands in `WORKFLOW.md` and `.claude/agents/*.md`. *Dry run A5.* |
| AC24 | Repo A, a file's recap is shown, and the owner corrects one point before confirming | The file is written | The file's hash is unchanged until the confirmation. The written file has the corrected point, not the original one. *Dry run A6.* |
| AC25 | Repo A, PRD §1 holds owner text | `PRD.md` is filled | §1 is byte-identical to the seed, and no question about §1 was asked. *Dry run A7.* |
| AC26 | Repo A, PRD §3 holds owner text that contradicts a scripted answer | The answer is given | Before writing, the skill shows both texts and asks which to keep. §3 matches the owner's choice. *Dry run A8.* |
| AC27 | Repo A, two questions answered "don't know yet" | Those files are written | The matching `<placeholders>` stay verbatim. *Dry run A9.* |
| AC28 | Repo A, the run is finished | The end summary is compared with `grep -o '<[^>]*>'` over the filled files (`PRD.md`, `GUARDRAILS.md`, `CLAUDE.md`, `BACKLOG.md`, plus `<test command>` / `<full CI command>` in `WORKFLOW.md` and `.claude/agents/*.md`) | The summary lists every remaining placeholder by file, and nothing else. *Dry run A10.* |
| AC29 | Repo A, the run is finished | The reviewer compares the diff of every filled file with the answer script and the seed | Every added or changed line comes from an answer, the seed, or the template. No fact is invented. *Dry run A11.* |
| AC30 | Repo A, one answer is ≥ 2,000 characters, in several paragraphs | It is saved and written | The progress file holds it in full, and the recap shows exactly the text that ends up in the file (no silent truncation). *Dry run A12.* |
| AC31 | Repo A, the owner confirms the BACKLOG recap | `BACKLOG.md` is written | *Now* has a `B-001` row and paragraph with the title, feature ID and accept line from the answers. *Dry run A13.* |
| AC32 | Repo A, the project has no screens | The `DESIGN.md` step runs | It offers to delete `DESIGN.md` and asks. On "yes", `git status` shows `DESIGN.md` deleted. *Dry run A14.* |
| AC33 | Repo B, the project has screens | The `DESIGN.md` step runs | `DESIGN.md` is filled after its recap is confirmed, and not deleted. *Dry run B2.* |
| AC34 | Repo A, the owner gives a test command and a full CI command | That step finishes | `WORKFLOW.md` and `.claude/agents/*.md` contain no `<test command>` or `<full CI command>`, and their diff changes only those placeholders. *Dry run A15.* |
| AC35 | Repo B, the owner says there are no tests yet | That step finishes | `<test command>` stays verbatim in `WORKFLOW.md` and `test-writer.md`, and the end summary lists it. *Dry run B3.* |
| AC36 | Repo A, the first file recap is confirmed | The progress file is inspected | It exists at the path from Q1, holds the confirmed answers, and records the `.kit-version` line. *Dry run A16.* |
| AC37 | Repo A, `GUARDRAILS.md` is confirmed, and the run is stopped | A fresh session (no memory of the first) runs `/kit-init` | It says it's resuming from the progress file, asks none of the questions already confirmed, and continues with `CLAUDE.md`. *Dry run A17.* |
| AC38 | Repo B, a progress file whose recorded kit version differs from `.kit-version` | `/kit-init` runs | It names both versions and asks whether to continue or start over, before asking anything else. *Dry run B4.* |
| AC39 | Repo A, the last file is written | Self-removal is offered and the owner says "yes" | It was the last question. Afterwards the progress file and `.claude/skills/kit-init/` are both gone. *Dry run A18.* |
| AC40 | Repo A, the run is finished | `RUNBOOK.md`, `README.md` and `.kit-version` are compared with the seed | They are byte-identical. *Dry run A19.* |

**E. Docs and existing checks** (decision 10)

| # | Given | When | Then |
|---|---|---|---|
| AC41 | README "Start a new project with it" | It is read | It recommends running `/kit-init` before the manual steps. The manual steps stay as the alternative and still name the four kit-only paths. *Auto (grep and order).* |
| AC42 | README "What's inside" | It is read | A row names `.claude/skills/kit-init/` and says it removes itself at the end of setup. *Auto (grep).* |
| AC43 | `site/index.html` "From template to first task" | It is read | It recommends `/kit-init` before the manual steps, and the manual delete step still names the four paths. *Auto (grep and order).* |
| AC44 | `site/playground.html` setup tab | It renders | It shows `/kit-init` as the recommended start, and the manual checklist, files table and `git rm` line are still there. *Auto (Playwright, in `test-site.cjs`).* |
| AC45 | The branch | `bash kit/scripts/test-all.sh` runs | It exits zero, includes the new checks, and the existing B-001 checks (AC1, AC13–AC20 of B-001) still assert at least what they asserted before. *Auto.* |
| AC46 | The branch vs `main` | The diff of the root templates (`PRD.md`, `GUARDRAILS.md`, `CLAUDE.md`, `BACKLOG.md`, `DESIGN.md`, `WORKFLOW.md`, `RUNBOOK.md`, `CHANGELOG.md`, `.claude/agents/`, `docs/`) is taken | It is empty. In the kit repo, they stay templates. *Auto.* |

### Edge cases
- **No git remote, or not a git repo at all** (e.g. a downloaded zip): see
  Q3. `git rm` needs a repo, so cleanup can't run without one.
- **Fork of the kit** (`someone/project-starter-kit`): see Q4.
- **Dirty working tree:** the skill names the changed and untracked files,
  then asks (AC18). It never stashes, resets, cleans or forces a removal
  (AC12). If `git rm` refuses because a kit-only file has local edits, the
  skill shows the real message and asks. It never adds `-f`.
- **Some kit-only paths already deleted by hand:** it lists only the ones
  still present. If none are present, it skips the question.
- **Owner says no to cleanup:** nothing is removed, setup continues, and the
  end summary lists the kept files (AC21).
- **Owner says no to self-removal:** the skill folder stays, and the end
  summary says how to remove it. Running `/kit-init` again later (no progress
  file) starts again. By decision 5 it keeps everything already written and
  asks only about the `<placeholders>` left.
- **Progress file from a different kit version:** it names both versions and
  asks (AC38).
- **Progress file present but unreadable or hand-edited into nonsense:** it
  says so, shows what it could read, and asks whether to start over. It
  never guesses the missing answers.
- **Resuming in a different session or on a different machine:** works only
  if that session can see the progress file (Q1 decides whether it is
  committed). The resumed session re-reads the files already written and
  doesn't rely on chat memory (AC37).
- **Owner edits a filled file by hand between sessions:** on resume, the
  skill treats it as existing text (decision 5). It keeps the edit and asks
  if it conflicts with a saved answer.
- **No tests yet, so no test command:** `<test command>` stays and is listed
  (AC35). The same applies to `<full CI command>`. See Q7 for the CI script.
- **No screens, `DESIGN.md` deleted, and screens added later:** the deletion
  was a `git rm`, so the file comes back from git history or the kit
  template. `/kit-init` doesn't track it later. If the PRD answers mention
  screens but the owner says "no screens", that's a conflict, and the skill
  asks (decision 5).
- **Very long answers:** stored and written in full, never truncated. The
  recap shows exactly what will be written (AC30).
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
- Filling `RUNBOOK.md` or `README.md` (decision 3).
- Running the dry run in CI, or any paid or LLM API in an automated check
  (decision 9).
- Pushing, opening PRs or merging from `/kit-init`.
- Changing the root templates in the kit repo (AC46).
- Tagging or publishing `v0.2.0` (the owner does it after merge; see Q9 for
  the `.kit-version` bump).

### Open questions for the owner
Each needs an answer before approval. No default is chosen.

**Q1. Where does the progress file live, and is it committed?**
*Scenario:* you answer the PRD questions on your laptop, stop, and later
open a Claude Code cloud session on your phone. That session starts from a
fresh copy of the repo on GitHub, so it only sees what was pushed.
- **A. `.kit-init-progress.md` at the repo root, committed after each
  confirmed recap.** Pros: resuming works across machines and cloud
  sessions, and it's easy to see. Cons: your answers go into git history.
  In a public repo that's public, even after the file is deleted. It also
  depends on Q2 (commits).
- **B. Inside the skill folder (`.claude/skills/kit-init/progress.md`), not
  committed (git-ignored).** Pros: no history noise, nothing public, and it
  goes away with the skill. Cons: resume works only on the same machine and
  copy, so it fails for the phone and cloud case.
- **C. Inside the skill folder, committed.** Pros: resumes anywhere, and it's
  removed together with the skill. Cons: the same public-history concern as
  A, and it's harder to spot.

**Q2. Does `/kit-init` make commits, and on which branch?**
*Scenario:* a brand-new repo has only `main`. Your GUARDRAILS template says
"never commit directly to `main`", but there's no task branch yet.
- **A. Never commits.** It leaves everything staged for you to review and
  commit. Pros: you stay fully in control, and no rule is bent. Cons:
  nothing reaches GitHub until you commit and push, so phone and cloud
  resume (Q1 A/C) don't work. Harder on mobile.
- **B. Commits each confirmed file on a setup branch** (e.g.
  `chore/kit-init`) and asks before the first commit. You push and merge.
  Pros: you can review the history, and it follows the branch rule. Cons:
  the branch name has no `B-###` ID, so it breaks the `<type>/<B-id>-<slug>`
  pattern, and there's a merge step.
- **C. Commits each confirmed file directly on `main`**, as a one-off setup
  exception, after asking once. Pros: simplest, and resume works after a
  push. Cons: breaks the template's own rule on day one.

**Q3. With no git remote (or no git repo at all), how does it tell this
isn't the kit repo?**
*Scenario:* you download the kit as a zip, unpack it, and run `/kit-init`.
There's no `origin`, so the URL check has nothing to look at, and the files
look exactly like the kit's.
- **A. Ask you once:** "Is this a new project, not the kit itself?"
  Continue only on yes. Pros: works for zip and local-only starts. Cons:
  relies on your answer, so the kit owner could slip past it by mistake.
- **B. Refuse until a remote is set** (and `git init` is done). Pros:
  simplest and safest. Cons: zip and offline users must create a remote
  first, which adds friction.
- **C. Continue silently.** Pros: no friction. Cons: no protection at all
  without a remote.

**Q4. Should a fork of the kit (any `<owner>/project-starter-kit`) also be
refused?**
*Scenario:* someone forks the kit to propose an improvement and types
`/kit-init` to try it. Their remote is `someone/project-starter-kit`, not
`Eugenelcc/...`.
- **A. Refuse only `Eugenelcc/project-starter-kit`** (as the recap says).
  Pros: exact and predictable. Cons: a contributor's fork gets its templates
  filled in, and a PR from it could carry them back.
- **B. Also refuse any repo named `project-starter-kit`.** Pros: protects
  forks. Cons: someone who names their own project `project-starter-kit` is
  blocked. It needs a clear message saying to rename the repo.
- **C. Like A, but warn and ask on a repo named `project-starter-kit`.**
  Pros: protects forks without blocking anyone. Cons: one more question,
  and it relies on the answer.

**Q5. What happens to `CHANGELOG.md` in the new project?**
*Scenario:* after setup, your `CHANGELOG.md` still has the template's
guidance and a sample entry, `## [0.1.0] - YYYY-MM-DD … First deployable
skeleton (B-001)`, which isn't true for your project. (`.kit-version` is
kept unchanged either way, as the README already says.)
- **A. Leave it as a template** (the recap lists only the files it fills).
  Pros: stays inside the recap, and there's less to ask. Cons: a misleading
  sample entry stays until you notice it.
- **B. Reset it to an empty `[Unreleased]` section after asking** (remove
  the guidance and the sample entry). No questions about content. Pros:
  clean and true, and one yes/no. Cons: a small addition to the recap's
  file list.
- **C. Leave it, but list it in the end summary as "still a template".**
  Pros: no change, and you're reminded. Cons: you still have to fix it by
  hand.

**Q6. Beyond `<test command>` / `<full CI command>`, does it fill
`WORKFLOW.md`'s other placeholders?**
*Scenario:* after setup, `WORKFLOW.md` still says `# <Project name> —
Workflow`, "Agreed with the owner (<@github-handle>) on <YYYY-MM-DD>", the
deploy line `<How it deploys…>`, the review line `<Project-specific>`, and
`<scripts/ci.sh>`. `RUNBOOK.md` also keeps `<full CI command>`, even though
you've just given it.
- **A. Only the two command placeholders** (the recap read literally). The
  rest are listed at the end. Pros: stays inside the recap. Cons: an
  obviously half-filled WORKFLOW, with answers you already gave (name,
  handle) not reused.
- **B. Also fill WORKFLOW's other placeholders**, reusing earlier answers
  (name, handle, today's date, CI script path) and asking about the deploy
  and project-specific lines, with a WORKFLOW recap. Pros: a complete file.
  Cons: more questions, and it widens decision 3.
- **C. B, plus replace only `<full CI command>` in `RUNBOOK.md`** (the rest
  of RUNBOOK stays a template). Pros: no stale command anywhere. Cons:
  touches a file the recap said stays a template.

**Q7. Does `/kit-init` create the CI script (e.g. `scripts/ci.sh`)?**
*Scenario:* README step 5 says "create the single CI script that both you
and GitHub Actions run". You tell `/kit-init` your CI command is
`bash scripts/ci.sh`, but that file doesn't exist.
- **A. No.** It records the command and lists "create `scripts/ci.sh`" as a
  next step. Pros: no code written, and it stays stack-neutral (stack
  presets are out of scope). Cons: setup isn't finished when `/kit-init`
  ends.
- **B. Yes, a minimal script built from the commands you give**, after its
  own recap. Pros: works on day one. Cons: writes code, edges into stack
  presets, and needs its own checks.

**Q8. Should the manual setup steps also delete `.claude/skills/kit-init/`?**
*Scenario:* you skip `/kit-init` and follow the manual steps. The skill
folder stays in your project forever, unused (it never loads by itself,
because of `disable-model-invocation`).
- **A. Yes, add it to the manual delete list** (README, site, playground
  table and `git rm` line). Pros: a clean project. Cons: a longer list, and
  you lose the option to run `/kit-init` later.
- **B. No, leave it.** Pros: you can still run `/kit-init` later, and the
  list stays short. Cons: a leftover folder in projects set up by hand.
- **C. Mention it as optional** ("delete it if you won't use `/kit-init`").
  Pros: you decide. Cons: one more thing to read.

**Q9. Is `.kit-version` bumped to `v0.2.0` in the B-002 PR, or in a separate
PR after merge?**
*Scenario:* the recap says B-002 releases as `v0.2.0`. The B-001 check
expects `.kit-version` to be exactly `project-starter-kit v0.1.0`.
- **A. In the B-002 PR**, updating that check to `v0.2.0`. Pros: one PR, and
  you tag right after merge. Cons: `main` claims `v0.2.0` before the tag
  exists, and the PR mixes feature and release.
- **B. A separate small release PR after B-002 merges** (the README's
  "bump in a PR, merge, tag" flow). Pros: clean separation, matching how
  v0.1.0 was done. Cons: one more PR.

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
