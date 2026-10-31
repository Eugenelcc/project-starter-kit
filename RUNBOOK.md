# <Project name> — Runbook

<!-- TEMPLATE GUIDANCE (delete this block once filled in)
What to do, step by step, when deploying or when something breaks. Written
for a tired person at 2 a.m.: exact commands and URLs, no theory. The
format follows the SRE practice of keeping operational knowledge written
down instead of in someone's head.
Spendlygo keeps this in its WORKFLOW §6 and apps/server/CLAUDE.md:
https://github.com/Eugenelcc/spendlygo/blob/main/apps/server/CLAUDE.md
-->

**Production:** <URL> · **Host dashboard:** <URL> · **Logs:** <where>

---

## 1. Deploy

<!-- How a merge to main reaches production. Automatic or manual? -->
1. Merge the PR to `main` (the owner).
2. <What happens next, e.g. "the host builds and deploys automatically,
   ~3 min">.
3. Run the health checks (§3).
4. Add the release to `CHANGELOG.md`.

## 2. Roll back

**Revert first, fix second.**

1. <Fastest path, e.g. "Host dashboard → Deploys → last good deploy →
   Redeploy">.
2. Or revert the PR on GitHub and let it deploy.
3. Run the health checks (§3).
4. Database: <can the last migration be undone safely? If not, say so here>.

## 3. Health checks

| Check | How | Expected |
|---|---|---|
| Service is up | `curl -fsS <URL>/healthz` | `200` within <n> s |
| One real action works | <e.g. "log in and save one item"> | <result> |

## 4. Common failures

| Symptom | Likely cause | Fix |
|---|---|---|
| <e.g. first request takes 50 s> | <e.g. free host sleeps when idle> | <e.g. keep-alive ping> |
| CI fails before any step runs | Account or billing problem, not code | Owner checks GitHub billing; run `<full CI command>` locally meanwhile |
| | | |

## 5. Secrets and config

| Name | Where it's set | What breaks without it |
|---|---|---|
| | | |

<!-- Names only. Never put a secret value in this file (GUARDRAILS §4). -->

## 6. After an incident

If users were affected, write a blameless postmortem from
[`docs/postmortems/TEMPLATE.md`](./docs/postmortems/TEMPLATE.md) and add the
lesson to the nested `CLAUDE.md` Gotchas table where it bites.
