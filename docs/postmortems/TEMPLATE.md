# Postmortem: <short title>

<!-- TEMPLATE GUIDANCE (delete this block)
Blameless, in the Google SRE style: we look for causes in systems and
processes, never fault in people. Write one whenever users were affected or
data was at risk. Copy to docs/postmortems/YYYY-MM-DD-<slug>.md.
Spendlygo has no postmortem yet; its revert-first rule is in
https://github.com/Eugenelcc/spendlygo/blob/main/WORKFLOW.md (§6).
-->

**Date:** YYYY-MM-DD · **Duration:** <start → end, timezone> ·
**Severity:** <low · medium · high> · **Author:** <name> · **Status:** draft

## Summary
<!-- Two or three sentences a non-engineer can follow. -->

## Impact
<!-- Who was affected, how many, for how long, any data lost or wrong. -->

## Timeline
| Time | Event |
|---|---|
| | Detected (how?) |
| | Mitigated (reverted / rolled back) |
| | Resolved |

## Root cause
<!-- Ask "why?" until you reach something a process or a test can fix. -->

## What went well
-

## What went wrong
-

## Where we got lucky
-

## Action items
| Action | Type (prevent · detect · mitigate) | Backlog | Owner |
|---|---|---|---|
| Add a test that would have caught it | prevent | B-### | |
| Add the lesson to `<area>/CLAUDE.md` Gotchas | prevent | | |
