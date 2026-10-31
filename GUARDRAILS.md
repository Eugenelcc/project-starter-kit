# <Project name> — Guardrails

<!-- TEMPLATE GUIDANCE (delete this block once filled in)
Hard rules, binding on every human and every Claude session. Keep it short
enough to read before every change. Each rule is tagged:
  🔴 NEVER     — breaking it is a defect, no exceptions
  🟡 ASK FIRST — needs the owner's explicit approval before proceeding
  🟢 ALWAYS    — the required practice
Keep the section numbers: WORKFLOW.md and the agents refer to §8 (Testing
floor) and §10 (When to stop and ask). Delete rules that don't apply; add
your own under §9.
Worked example: https://github.com/Eugenelcc/spendlygo/blob/main/GUARDRAILS.md
-->

**These are hard rules.** They exist because breaking one costs money, loses
data, or leaks it. When a guardrail conflicts with convenience, the guardrail
wins. When it conflicts with a request, **stop and ask**.

Legend: 🔴 **NEVER** — violating this is a defect, no exceptions.
🟡 **ASK FIRST** — requires explicit owner approval before proceeding.
🟢 **ALWAYS** — the required practice.

---

## 1. Cost — <budget, e.g. "the project must stay free">

- 🔴 **NEVER** add a paid service, a paid tier, or a service that needs a
  credit card on file to start.
- 🔴 **NEVER** add a service with a trial that converts to paid.
- 🔴 **NEVER** exceed a free-tier quota you depend on: <e.g. "one always-on
  web service only; a second one breaches the hours quota">.
- 🟡 **ASK FIRST** before adding *any* new external service, even a free one.
  It becomes an availability dependency and a data processor.
- 🟢 **ALWAYS** record the free-tier limits of anything added, and what
  happens when we hit them, in an ADR (`docs/adr/`).

**Approved infrastructure (nothing else without approval):**
<host>, <database>, <CI>, …

## 2. Data integrity

- 🔴 **NEVER** run a destructive migration (drop or narrow a column, drop a
  table) without a plan the owner approved.
- 🔴 **NEVER** hard-delete user data on a normal user action. <Soft-delete,
  then purge on a schedule — or your rule.>
- 🟡 **ASK FIRST** before any script that bulk-modifies real data.
- 🟢 **ALWAYS** make writes safe to retry (idempotent). Use transactions for
  multi-row changes.
- 🟢 **ALWAYS** keep migrations backward-compatible with the version that is
  currently running.

## 3. Authentication & authorisation

- 🔴 **NEVER** trust identity sent by the client. Take it only from a
  verified source: <e.g. a signed session, a verified token>.
- 🔴 **NEVER** query user-owned data without a user filter. Put the filter in
  the data-access layer so no call site can forget it.
- 🟢 **ALWAYS** test that every route rejects unauthenticated and cross-user
  access.

## 4. Secrets

- 🔴 **NEVER** commit a secret, token or key. Not even "temporarily".
- 🔴 **NEVER** print secrets in logs, errors or test output.
- 🔴 **NEVER** point a development run at production credentials or data.
- 🟢 **ALWAYS** read config from the environment in **one** module, validated
  at startup (fail fast).

## 5. Privacy

- 🔴 **NEVER** log personal data: <list it, e.g. names, emails, amounts, free
  text>.
- 🔴 **NEVER** send user data to a third party the owner hasn't approved.
- 🟢 **ALWAYS** support <data export / account deletion> if the PRD promises it.

## 6. Scope discipline

- 🔴 **NEVER** build a feature that isn't in `PRD.md` or an agreed
  `BACKLOG.md` item.
- 🔴 **NEVER** build a deferred (PRD "out of scope") feature as a shortcut.
- 🟢 **ALWAYS** park side ideas in `BACKLOG.md` → Later instead of building
  them.

## 7. Git & delivery

- 🔴 **NEVER** commit directly to `main`, force-push a shared branch, or
  rewrite pushed history.
- 🔴 **NEVER** merge. Claude opens a PR only when the owner asks; the owner
  merges after review and green CI.
- 🔴 **NEVER** skip, disable or loosen a test or check to get green.
- 🟢 **ALWAYS** one branch per task, `<type>/<B-id>-<slug>`, one feature ID
  per PR, Conventional Commits.
- 🟢 **ALWAYS** run `<full CI command>` before every push.

## 8. Testing floor

**The high-risk areas** of this project are the places where bugs are silent
and expensive. No change to them ships without tests:

1. <e.g. money arithmetic>
2. <e.g. date and timezone boundaries>
3. <e.g. the input parser>
4. <e.g. permissions>

A change is not done until:
- 🟢 Every high-risk area it touches has unit tests (fixtures, edge cases).
- 🟢 Every API route has a test asserting it rejects unauthenticated and
  cross-user access.
- 🟢 `<full CI command>` passes locally.

## 9. Project-specific rules

<!-- Rules that only make sense for this project. Examples:
     - Money is an integer number of cents, never a float.
     - Never call new Date() in domain logic; inject a clock.
     - Bundle budget: the front end stays under N KB gzipped.
     - Platform rules from the API you build on (rate limits, ToS). -->

## 10. When to stop and ask the owner

Stop and ask, rather than guessing, when:

1. A change would introduce cost or a new external service.
2. A migration would drop or narrow data, or a script would bulk-modify it.
3. A request conflicts with the PRD's scope or with any 🔴 rule above.
4. The requirement is ambiguous in a way that changes the data model.
5. Something in production looks wrong with real user data.
6. You've made 2 honest failed attempts at the same problem.

Asking costs a minute. Any of these going wrong costs money or trust.
