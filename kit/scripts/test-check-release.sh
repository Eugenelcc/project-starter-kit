#!/usr/bin/env bash
# Kit-only test. Exercises kit/scripts/check-release.sh in throwaway git repos
# (AC5-AC9 + edge cases). Run: bash kit/scripts/test-check-release.sh
set -uo pipefail
SCRIPT="$(cd "$(dirname "$0")" && pwd)/check-release.sh"
TMPS=()
trap 'for d in "${TMPS[@]:-}"; do [ -n "$d" ] && rm -rf "$d"; done' EXIT
FAILED=0
GIT=(git -c user.name=test -c user.email=test@example.invalid -c commit.gpgsign=false)

new_repo() { # $1 = kit-version bytes or NONE
  local d; d="$(mktemp -d)"; TMPS+=("$d")
  ( cd "$d" && git -c init.defaultBranch=main init -q
    if [ "$1" != "NONE" ]; then printf '%b' "$1" > .kit-version; git add .kit-version; fi
    "${GIT[@]}" commit -q --allow-empty -m init ) >/dev/null 2>&1
  printf '%s' "$d"
}
OUT=""; ERR=""; RC=0
run() { # repo tag [main_ref]
  local e; e="$(mktemp)"; TMPS+=("$e")
  OUT="$(cd "$1" && TAG="$2" MAIN_REF="${3:-main}" bash "$SCRIPT" 2>"$e")"; RC=$?
  ERR="$(cat "$e")"
}
check() { # name expected_rc stderr_substring(optional) ; uses RC/ERR/OUT
  local name="$1" rc="$2" sub="${3:-}"
  if [ "$RC" != "$rc" ]; then echo "FAIL $name: exit $RC, expected $rc (stderr: $ERR)"; FAILED=1; return; fi
  if [ -n "$sub" ] && [[ "$ERR" != *"$sub"* ]]; then echo "FAIL $name: stderr lacks '$sub' (got: $ERR)"; FAILED=1; return; fi
  echo "PASS $name"
}
tagged() { # content tag [-a]
  local r; r="$(new_repo "$1")"
  if [ "${3:-}" = "-a" ]; then (cd "$r" && "${GIT[@]}" tag -a -m x "$2") >/dev/null 2>&1
  else (cd "$r" && git tag "$2") >/dev/null 2>&1; fi
  printf '%s' "$r"
}
V='project-starter-kit v0.1.0\n'

if [ ! -f "$SCRIPT" ]; then echo "FAIL all: $SCRIPT does not exist"; fi

r="$(tagged "$V" v9.9.9)"; run "$r" v9.9.9
if [[ "$ERR" == *"'v9.9.9'"* && "$ERR" == *"'project-starter-kit v0.1.0'"* && "$ERR" == *"Bump .kit-version"* && $RC == 1 ]]; then echo "PASS AC5 mismatched tag refused"; else echo "FAIL AC5 mismatched tag refused: rc=$RC err=$ERR"; FAILED=1; fi

r="$(tagged "$V" v0.1.0)"; run "$r" v0.1.0
if [[ $RC == 0 && "$OUT" == "OK: v0.1.0"* ]]; then echo "PASS AC6 matching tag on main passes"; else echo "FAIL AC6 matching tag on main passes: rc=$RC out=$OUT err=$ERR"; FAILED=1; fi

r="$(tagged 'starter-kit v0.1.0\n' v0.1.0)"; run "$r" v0.1.0
check "AC7 wrong prefix refused" 1 "must be exactly one line 'project-starter-kit vX.Y.Z'"

r="$(tagged 'project-starter-kit v0.2.0-rc.1\n' v0.2.0-rc.1)"; run "$r" v0.2.0-rc.1
check "AC8 pre-release tag refused" 1 "only tags of the form vX.Y.Z"

r="$(new_repo "$V")"
(cd "$r" && git checkout -q -b side && "${GIT[@]}" commit -q --allow-empty -m side && git tag v0.1.0 && git checkout -q main) >/dev/null 2>&1
run "$r" v0.1.0
check "AC9 tag off main refused" 1 "is not on main (main)"

r="$(tagged 'project-starter-kit v0.1.0  \r\n' v0.1.0)"; run "$r" v0.1.0
check "EDGE trailing spaces and CRLF accepted" 0

r="$(tagged "$V" v0.1.0 -a)"; run "$r" v0.1.0
check "EDGE annotated tag accepted" 0

r="$(tagged NONE v0.1.0)"; run "$r" v0.1.0
check "EDGE missing kit-version refused" 1 "is missing"

r="$(tagged '\n' v0.1.0)"; run "$r" v0.1.0
check "EDGE empty kit-version refused" 1 "is empty"

r="$(tagged 'project-starter-kit v0.1.0\nextra\n' v0.1.0)"; run "$r" v0.1.0
check "EDGE second line refused" 1 "must be exactly one line"

r="$(tagged ' project-starter-kit v0.1.0\n' v0.1.0)"; run "$r" v0.1.0
check "EDGE leading space refused" 1 "must be exactly one line"

r="$(tagged "$V" 0.1.0)"; run "$r" 0.1.0
check "EDGE tag without v refused" 1 "only tags of the form vX.Y.Z"

r="$(tagged "$V" v0.1)"; run "$r" v0.1
check "EDGE short tag refused" 1 "only tags of the form vX.Y.Z"

r="$(new_repo "$V")"; run "$r" v0.9.9
check "EDGE unknown tag refused" 1 "no such tag"

r="$(tagged "$V" v0.1.0)"; run "$r" ""
check "EDGE TAG unset" 2

run "$r" v0.1.0 nope
check "EDGE bad main ref" 2 "not found"

exit $FAILED
