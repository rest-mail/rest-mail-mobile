# Mobile sender-list contract

Compared with server `831a0b4`, `internal/api/handlers/sender_rules.go`,
`internal/db/models/pipeline.go`, `internal/api/routes.go` and `openapi.yaml`.

| Operation | Request coverage | Response and UI |
| --- | --- | --- |
| `listAllowlist` GET `admin/domains/{id}/allowlist` | Domain ID; no body or supported query parameters | 200, all rule fields, newest first; “Let in” selection and pull to refresh |
| `addToAllowlist` POST same path | `pattern` and optional `reason`; no client-selected `created_by` | 201 returned rule; add form, duplicate/validation errors kept on the form |
| `removeFromAllowlist` DELETE same path plus `/{eid}` | Domain ID and rule ID; no body | 204 only; confirmation, cancellation, refusal and refreshed list |
| `listBlocklist` GET `admin/domains/{id}/blocklist` | Domain ID; no body or supported query parameters | 200, all rule fields, newest first; “Turned away” selection and pull to refresh |
| `addToBlocklist` POST same path | `pattern` and optional `reason`; no client-selected `created_by` | 201 returned rule; add form, duplicate/validation errors kept on the form |
| `removeFromBlocklist` DELETE same path plus `/{eid}` | Domain ID and rule ID; no body | 204 only; confirmation, cancellation, refusal and refreshed list |

## Responses and list identity

`SenderRule` retains `id`, `domain_id`, `pattern`, `list_type`, `reason`, optional
`created_by`, and `created_at`. The server omits an unrecorded creator and an
empty reason. It does not return an updated timestamp or domain association for
these operations. Tapping a row opens selectable sender, reason and timestamp,
along with the rule/domain IDs, selected list and recorded creator. A missing
creator is shown as “Not recorded”, not inferred from the current session.

The client checks the rule's domain and list against the requested route before
presenting any removal action. Unknown/missing list types, missing identity or
creation time, invalid creator types, non-object rows and mismatched domain/list
responses become `bad_response`. A missing `data` envelope is an error. A Go
empty slice (`data: null`) or empty array remains an empty list.

Each list selection owns a separate request/list instance. Switching selections
or refreshing immediately removes old rows; a late answer to a disposed list
cannot replace the current selection. Pending/refused reads hide add and removal
actions. Retry loads the selected list again. Shared admin list behavior outside
this screen is unchanged.

## Refusals and permissions

- The server checks GET with `domains:read` on the requested domain. POST and
  DELETE need `domains:write` on that domain, not `domains:delete`.
- This branch preserves current section capability gates. Scoped session/UI
  integration is separately tracked in mobile #108 and server #619; this branch
  alone is not evidence of live scoped access.
- A duplicate on the **same** list returns `409 already_exists`; the same sender
  can be on both lists. The fake now matches that server behavior instead of its
  outdated 500 response. The UI explains the duplicate and preserves the form.
- HTTP 403 never refreshes, ends or alters the session. Failed deletion leaves
  the rule visible and does not show a success message. Cross-list/domain and
  repeated deletion return 404 in the fake/server contract.
- The API sends the supplied pattern/reason unchanged. The UI retains its
  existing address/`@domain` validation and lowercase normalization. Its creator
  field is response metadata only; no ownership assertion is sent by the phone.

## Verification

- API: **196 tests pass**, including **48** dedicated sender-list cases covering
  both routes for GET/POST/DELETE, complete fields, empty/optional data,
  malformed and mismatched responses, expected statuses and session-preserving
  refusals. `dart analyze --fatal-infos` passes.
- Fake: **76 tests pass**, including **4** new lifecycle/permission cases.
  `dart analyze --fatal-infos` passes. The first run failed an existing assertion
  expecting status 500 for a duplicate; it now checks the server's 409, and the
  complete suite was rerun successfully.
- Package formats, pinned Dart 3.13.1 root format and `git diff --check` pass.
- **Six new Flutter workflows are authored but not run locally:** pending-list
  switch with late answer, refused read/retry, every metadata field, duplicate
  and independent lists, refused/cancelled deletion, and read-only inspection.
  Flutter analysis, app/tour tests and Android/iOS builds run in normal GitHub
  CI. No Flutter SDK is available on this arm64 Pi.

These tests cover requests, parsing and fake/mobile behavior. They are not live
production SMTP-filter or PostgreSQL evidence, and do not establish deployment
of this PR or completion of the whole admin parity project.
