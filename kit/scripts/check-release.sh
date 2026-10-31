#!/usr/bin/env bash
# Release check for the kit (kit-only; deleted with kit/ at setup).
# Verifies that a vX.Y.Z tag matches .kit-version (read at the tagged commit)
# and that the tagged commit is on main. No network, no gh calls.
# Run locally:  TAG=v0.1.0 MAIN_REF=main bash kit/scripts/check-release.sh
# Inputs: TAG (required), MAIN_REF (optional, default origin/main).
set -euo pipefail

TAG="${TAG:-}"
MAIN_REF="${MAIN_REF:-origin/main}"

fail() { printf '%s\n' "$2" >&2; exit "$1"; }

[[ -n "$TAG" ]] || fail 2 "check-release: TAG is not set."

[[ "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
  fail 1 "Refusing to release '$TAG': only tags of the form vX.Y.Z are published (pre-release and other tags are not)."

git rev-parse --verify --quiet "refs/tags/$TAG^{commit}" >/dev/null ||
  fail 1 "Refusing to release '$TAG': no such tag in this repository."

git rev-parse --verify --quiet "$MAIN_REF^{commit}" >/dev/null ||
  fail 2 "check-release: main ref '$MAIN_REF' not found (in CI, check out with fetch-depth: 0)."

git merge-base --is-ancestor "refs/tags/$TAG^{commit}" "$MAIN_REF" ||
  fail 1 "Refusing to release '$TAG': its commit is not on main ($MAIN_REF). Merge first, then tag a commit on main."

git cat-file -e "refs/tags/$TAG:.kit-version" 2>/dev/null ||
  fail 1 "Refusing to release '$TAG': .kit-version is missing at that commit."

c="$(git show "refs/tags/$TAG:.kit-version")"
c="${c%"${c##*[![:space:]]}"}"

[[ -n "$c" ]] || fail 1 "Refusing to release '$TAG': .kit-version is empty."

[[ "$c" =~ ^project-starter-kit\ v[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
  fail 1 "Refusing to release '$TAG': .kit-version must be exactly one line 'project-starter-kit vX.Y.Z', found '$c'."

[[ "$c" == "project-starter-kit $TAG" ]] ||
  fail 1 "Refusing to release '$TAG': .kit-version says '$c'. Bump .kit-version to 'project-starter-kit $TAG', merge, then tag again."

printf '%s\n' "OK: $TAG matches .kit-version and is on $MAIN_REF."
