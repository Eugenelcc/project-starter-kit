#!/usr/bin/env bash
# Kit-only test: file and grep checks (AC1, AC13-AC16). Run: bash kit/scripts/test-kit-files.sh
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
FAILED=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1: $2"; FAILED=1; }
has() { grep -qF -- "$2" <<<"$1"; } # text needle

# AC1
n="AC1 kit-version is exactly the v0.1.0 line"
if python3 -c '
import sys
try: c=open(".kit-version",encoding="utf-8").read()
except OSError: sys.exit(1)
sys.exit(0 if c in ("project-starter-kit v0.1.0","project-starter-kit v0.1.0\n") else 1)'; then pass "$n"; else fail "$n" ".kit-version missing or not exact"; fi

README="$(cat README.md)"

# AC13
n="AC13 README backlog conventions"; miss=""
for s in '`backlog`' 'status: todo' 'status: spec' 'status: planned' 'status: tests' 'status: in progress' 'status: in review' 'status: done' 'B-###' 'GitHub Issues' 'no Project board' 'gh'; do
  has "$README" "$s" || miss="$miss [$s]"
done
[ -z "$miss" ] && pass "$n" || fail "$n" "README lacks:$miss"

# AC14
n="AC14 kit/specs exists and is documented"; miss=""
[ -f kit/specs/B-001-kit-versioning.md ] || miss="$miss [spec file]"
has "$README" 'kit/specs/B-###-<slug>.md' || miss="$miss [kit/specs/B-###-<slug>.md]"
has "$README" '`kit/`' || miss="$miss [\`kit/\`]"
[ -z "$miss" ] && pass "$n" || fail "$n" "missing:$miss"

# AC15
n="AC15 README delete list"; miss=""
step="$(awk '/^2\. In your new repo/,/^3\. /' README.md)"
[ -n "$step" ] || miss="$miss [step 2 not found]"
for s in '`site/`' '`kit/`' '`.github/workflows/pages.yml`' '`.github/workflows/release.yml`'; do
  has "$step" "$s" || miss="$miss [$s]"
done
[ -z "$miss" ] && pass "$n" || fail "$n" "step 2 lacks:$miss"

# AC16
n="AC16 index.html delete list"; miss=""
line="$(grep -F 'Delete <code>' site/index.html | head -n1)"
[ -n "$line" ] || miss="$miss [line not found]"
for s in '<code>site/</code>' '<code>kit/</code>' '<code>.github/workflows/pages.yml</code>' '<code>.github/workflows/release.yml</code>'; do
  has "$line" "$s" || miss="$miss [$s]"
done
[ -z "$miss" ] && pass "$n" || fail "$n" "line lacks:$miss"

exit $FAILED
