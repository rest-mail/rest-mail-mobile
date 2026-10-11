#!/usr/bin/env bash
# Whether the tag that started testflight.yml may become a TestFlight release.
# Runs before anything is built and before any secret is read.
#
# A release is a tag: `git tag v0.2.0 && git push origin v0.2.0`. The tag is
# the version testers see, so git itself rules out using one twice. On top of
# that, a tag must
#
#   - be vMAJOR.MINOR.PATCH,
#   - name a commit that is on main: the release environment's secrets open for
#     any v* tag, and without this a tag on an unreviewed branch would ship it,
#   - be the newest release tag: versions only go up.
#
# Prints version=<MAJOR.MINOR.PATCH> to $GITHUB_OUTPUT for the jobs after it.
set -euo pipefail

fail() {
  echo "::error::$1"
  exit 1
}

ref=${GITHUB_REF:?GITHUB_REF is not set}
case "$ref" in
refs/tags/v*) ;;
*) fail "releases come from v* tags, and this run is for $ref" ;;
esac
tag=${ref#refs/tags/}
version=${tag#v}
[[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
  fail "$tag is not vMAJOR.MINOR.PATCH, so it cannot be a release"

main=${MAIN_REF:-origin/main}
git merge-base --is-ancestor "$tag^{commit}" "$main" ||
  fail "$tag names a commit that is not on main: only code that has been merged is released"

# Only tags on main count: a tag on some branch was never released (the check
# above refuses it), and counting it would let a stray tag block every release.
newest=$(git tag -l 'v*' --merged "$main" | sed -n 's/^v\([0-9]*\.[0-9]*\.[0-9]*\)$/\1/p' | sort -V | tail -1)
[ "$newest" = "$version" ] ||
  fail "$tag is older than v$newest, the newest release: versions only go up"

echo "releasing $version from $(git rev-parse --short "$tag^{commit}")"
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "version=$version" >> "$GITHUB_OUTPUT"
fi
