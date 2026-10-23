# Mobile MTA-STS contract

Checked against `rest-mail-server` `internal/api/handlers/mtasts.go`,
`internal/db/models/mtasts.go`, `routes.go` and `openapi.yaml` on
`feat/scoped-admin-access` at `831a0b4` (2026-10-23).

| Operation | Request | Response and mobile workflow |
| --- | --- | --- |
| `getMtaStsPolicy` GET `admin/domains/{id}/mta-sts` | Domain ID; no body or supported query parameters | Policy ID, domain ID, mode, comma-separated MX hosts, exact integer lifetime, active, creation/update timestamps, optional loaded domain. Domain → MTA-STS shows the policy and supports refresh/retry. |
| `setMtaStsPolicy` PUT same path | All optional fields: `mode`, `mx_hosts`, `max_age`, `active`; omitted fields are preserved. Both 200 update and 201 creation are parsed. | Edit/create all fields, with presets and a custom whole-seconds lifetime, including zero and the full signed 64-bit server range. Publication can be disabled before creation. The server's returned policy replaces the screen's data. |
| `deleteMtaStsPolicy` DELETE same path | Domain ID only; no body | Requires 204, asks for confirmation, then offers creation again. A 404 refusal does not report successful deletion. |

## Wire details

- `MtaStsPolicy.maxAgeSeconds` preserves the exact wire integer; the existing
  `maxAge` duration accessor remains for callers whose values fit in a duration.
  Send either `maxAgeSeconds` or the existing `maxAge` argument, never both.
- A lifetime of zero is displayed as `0 seconds`, not `0 weeks`. Custom values
  are not rounded to days. Negative, fractional, empty or overflowing input is
  explained before sending a request.
- Empty `mx_hosts` does **not** clear the server's saved hosts. The handler keeps
  the previous value; a new policy can have none. The form explains this rule
  and displays the response rather than assuming the requested value was saved.
- Only the handler's specific `not_found` / `No MTA-STS policy found for this
  domain` 404 means no configured policy. A missing domain or generic proxy 404
  remains an error, so it cannot expose a misleading creation action.
- Reload clears old data and mutation controls before requesting the policy.
  A pending or refused refresh cannot leave a stale publication toggle or
  delete/edit action visible. Retry performs a new GET.
- The server's unloaded zero-valued `domain` association is absent in the model;
  a populated association is parsed. All public timestamps are retained.

## Authorization and integration

All three server routes check a capability on the requested domain: GET needs
`domains:read`, PUT and DELETE need `domains:write` (not `domains:delete`).
The existing mobile section capability gates remain; the resource-scoped
session and UI integration is tracked separately in mobile PR #108 and server
PR #619. This branch alone does not establish live scoped authorization.

HTTP 403 is surfaced without refresh, sign-out or token mutation. A 422 retains
the editor and shows the server's field errors. Unexpected success statuses
are refused as `bad_response`. No production account or live server was used.

## Evidence

- API package: 164 tests pass, including 16 dedicated MTA-STS request/response
  cases; analysis passes with `--fatal-infos`.
- Fake package: 75 tests pass, including three MTA-STS lifecycle/authorization
  cases; analysis passes with `--fatal-infos`. The first run exposed a new test's
  incorrect account password; the fixture login was corrected and the complete
  suite rerun successfully.
- Five new Flutter workflows cover custom/zero/large values and validation,
  inactive creation, pending/refused refresh with retry, server field errors,
  and a read-only viewer. Existing MTA-STS coverage uses the stable host-field
  key after the second text field was added.
- Pinned Dart 3.13.1 formatting and `git diff --check` pass. Flutter analysis,
  widget workflows, screenshot tour and Android/iOS builds run in GitHub CI;
  they have not run locally on this arm64 Pi.

The fake verifies the contract and UI behavior, not PostgreSQL persistence or
public MTA-STS delivery. Those require server integration evidence. In
particular, explicit zero/false creation must be checked against GORM's model
defaults; a passing fake is not proof that the production insert preserves them.
