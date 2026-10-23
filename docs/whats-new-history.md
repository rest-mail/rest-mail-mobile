# What's New: ten releases in one file

The release workflow publishes one `whats-new.json` asset containing the ten
latest public stable releases in descending numeric version order. Each entry
retains its tag, title, complete GitHub release body and publication timestamp.
Drafts, prereleases, malformed entries and duplicate tags are excluded. With
fewer than ten releases, all available releases are kept.

The stable address is:

`https://github.com/rest-mail/rest-mail-mobile/releases/latest/download/whats-new.json`

## Publication

The normal main merge → automatic tag → signed TestFlight upload remains the
release path. After the upload succeeds, the publish job creates the GitHub
release, collects its notes with earlier releases, generates the single file
with `tool/ci/build_whats_new.py`, and uploads it as a release asset. The current
release must appear in the file. Rerunning publication can finish an interrupted
asset upload without creating a second release. Generated history never causes
a repository commit or an extra tag.

## Mobile

What's New displays the latest version first under **Latest release**, then
nine older entries under **Previous versions**, each with its version, title,
summary and change list. Labels and the Settings description are translated in
all five supported languages. Notes remain ordinary text, with no remote HTML.

The app stores one active cache file, `whats-new.json`, across app versions. It
shows saved notes immediately while refreshing, supports pull-to-refresh, and
keeps cached notes when offline or when a download is invalid. Cache replacement
uses a temporary file and rename. Existing per-version cache files are no longer
read or written. Development builds do not make live requests by default.

Until a new release has the asset, an asset 404 bootstraps the same single file
from GitHub's release list (up to 100 entries). This covers the existing release
history during rollout. Normal asset reads need no GitHub API token. Mobile
requests do not use an account's REST Mail session credentials.

## Evidence

- Nine Python generator tests pass: ten-entry limit, numeric major/minor/patch
  order, public stable selection, deduplication, metadata/null text, pagination,
  malformed input, Unicode and current-release validation.
- The standalone Dart model check passes 20 assertions. A file generated from
  the live public release history passes the same checks plus a file parse:
  ten versions, `0.3.82` through `0.3.73`, newest first, at implementation time.
  Targeted analysis of the pure Dart model and checker also passes.
- Nine new service tests cover the asset request, one-file cache, offline use,
  rollout fallback, invalid downloads, refusal, replacement, corrupt cache and
  unwritable storage. Three new widget tests cover ordering/labels, all ten
  records on a 320-point phone, and cached display while refreshing. Existing
  parsing, close and seen-version tests remain. **Flutter tests and app analysis
  have not run locally**; normal GitHub CI runs them and both platform builds.
- The CI App job also runs the Python and standalone Dart checks. The updated
  publication job needs the next successful normal TestFlight release for live
  asset-publication evidence.
