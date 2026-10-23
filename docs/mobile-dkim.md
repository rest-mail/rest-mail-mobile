# Mobile DKIM workflows

The global **DKIM keys** screen reads public monitoring metadata and supports
installation/replacement, rotation GET/PUT and confirmed removal. It reads every
page of domains when choosing an installation target. Private PEM text is pasted
exactly into an obscured field and is sent only with the PUT.

A domain's **DKIM signing** screen works even before a key is installed. It reads
that domain directly rather than calling the globally gated DKIM list. Rotation
can be configured for an unsigned domain. Removing a key leaves rotation policy
intact, as on the production server.

The server's list requires global `domains:read`; domain GET and rotation need
`domains:read` on the domain. Key install, rotation changes and removal need
`domains:write` on that domain. Scoped navigation/session metadata is integrated
by the separate scoped-access PR #108; this branch alone does not claim that
scoped administration is enabled in main or deployed.

## Evidence and limits

- API package: 124 tests pass, fatal-info analysis clean. New tests cover exact
  CRLF PEM bytes, legacy timestamps, fractional age, refusals and session retention.
- Fake package: 63 tests pass, fatal-info analysis clean. New tests cover install,
  replacement, unchanged-key age, unsigned domains, rotation boundaries,
  deletion, secret redaction and read-only permissions.
- Five Flutter workflows added in `test/admin_sections_test.dart`: domain-local
  calls/PEM, unsigned-domain install, validation, read-only rotation, and refusal
  when an altered app shows a forbidden control. These need Flutter CI.
- The fake validates selector syntax, PEM framing and a DER sequence. It does
  **not** implement RSA/Ed25519 signing or replace the production server's
  sign-and-verify validation.
- Local formatting is checked with the pinned Dart SDK. Flutter analysis,
  tests, screen tour and platform builds run through the normal PR workflow.

## Scoped-access integration on PR #108

This branch carries the DKIM work from #103 together with the grants/session
changes from #99. The per-domain screen passes its domain scope into `AdminPage`
and its initial read. Key-row writes/removal use the row's domain; a global reader
with write access to only one domain can therefore manage only that row. The
installation picker filters to domains the session may write.

After merging grants #99 through `b2fa1b1`, the combined branch passes 204 API
tests and 99 fake tests, with both fatal-info package analyses and formats clean.
The earlier Dart-only harness recorded seven policy cases importing the real
`AdminAccess`; it was not rerun in this integration batch and does not run
Flutter. The three scoped DKIM widget flows, original four scoped session flows,
five DKIM lifecycle flows and new grants/expiry flows remain for fresh Flutter
CI. #103 is now on main; #99, server #619 and final main integration are still
required. These branch artifacts do not establish deployment.
