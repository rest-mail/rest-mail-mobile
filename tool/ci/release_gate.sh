#!/usr/bin/env bash
# Whether the tag that started testflight.yml may become a TestFlight release.
# Runs before anything is built and before any secret is read.
#
# A release is a tag, made after each merge into main by release-on-merge.yml,
# and by nothing else: vMAJOR.MINOR.PATCH, where
# MAJOR.MINOR is pubspec.yaml's and PATCH is the build count, the number of
# commits behind the tagged one. The tag is the version testers see, and the
# build count only goes up, so no version can come round twice. A tag must
#
#   - be vMAJOR.MINOR.PATCH,
#   - have the build count of its commit as its PATCH, which a hand-typed tag
#     would not,
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

count=$(git rev-list --count "$tag^{commit}")
[ "${version##*.}" = "$count" ] ||
  fail "$tag's patch must be its commit's build count, $count: release-on-merge.yml would make v${version%.*}.$count"

main=${MAIN_REF:-origin/main}
git merge-base --is-ancestor "$tag^{commit}" "$main" ||
  fail "$tag names a commit that is not on main: only code that has been merged is released"

# Only tags that are releases count: on main, and with their commit's build
# count as their patch. A tag that breaks either rule was refused above when it
# was pushed, and counting it would let one stray tag block every release.
newest=$(
  git tag -l 'v*' --merged "$main" | while read -r t; do
    v=${t#v}
    [[ $v =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || continue
    [ "${v##*.}" = "$(git rev-list --count "$t^{commit}")" ] || continue
    echo "$v"
  done | sort -V | tail -1
)
[ "$newest" = "$version" ] ||
  fail "$tag is older than v$newest, the newest release: versions only go up"

echo "releasing $version from $(git rev-parse --short "$tag^{commit}")"
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "version=$version" >> "$GITHUB_OUTPUT"
fi
