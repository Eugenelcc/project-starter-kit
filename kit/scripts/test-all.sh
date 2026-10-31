#!/usr/bin/env bash
# Kit-only: runs every kit test script; exits non-zero if any fails.
# Run: bash kit/scripts/test-all.sh
D="$(cd "$(dirname "$0")" && pwd)"
rc=0
bash "$D/test-check-release.sh" || rc=1
python3 "$D/test-release-workflow.py" || rc=1
bash "$D/test-kit-files.sh" || rc=1
node "$D/test-site.cjs" || rc=1
exit $rc
