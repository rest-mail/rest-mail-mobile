# Mobile grants and session integration

The API methods were checked against server `grants.go`, `escalation.go` and
`routes.go`. The original implementation used `pr-607`; scoped session/server
integration is separately tracked in mobile #108 and server #619.

| Operation | Supported request | Response and workflow |
| --- | --- | --- |
| `listRoles` GET `admin/roles` | No body/query | ID, name, description, system-role flag, capability names; Permissions → Roles and grant role picker |
| `listCapabilities` GET `admin/capabilities` | No body/query | ID, name, description, resource/action; Permissions → Capabilities |
| `listGrants` GET `admin/grants` | Holder kind/ID, scope, limit/offset | Parsed grant page and total; combined holder/scope filters, clear/reset, and Load more |
| `createGrant` POST same path | Holder kind/ID, role, scope, optional mode and expiry | Created grant; account picker or typed ID, role/scope/mode/lifetime form |
| `deleteGrant` DELETE `admin/grants/{id}` | Grant ID, no body | 204; explicit confirmation, failure leaves the grant visible |
| `listMyGrants` GET `admin/grants/mine` | No body/query | Own grants, including active temporary activation; My permissions from Settings |
| `activateGrant` POST `admin/grants/{id}/activate` | Reason, optional minutes, authenticator/recovery code | 201 updated grant and capability snapshot; reason/duration/proof form |
| `deactivateGrant` POST `admin/grants/{id}/deactivate` | No body | 200 updated grant and capabilities; confirmation |
| `makeGrantEligible` POST `admin/grants/{id}/make-eligible` | JSON object, optional authenticator/recovery code | 200 updated grant and capabilities; fresh-proof form |

Operation names above are descriptive; the server OpenAPI operation IDs remain
the authority. Models retain holder/actor kind and ID, role ID/name, scope,
active/eligible mode, grant and expiry timestamps, and activation ID, timestamps,
reason and seconds remaining. An unknown mode is not treated as active.

## Integration corrections

- This branch contains main `90a8050`, including persisted session renewal,
  complete domain/mailbox fields, fresh resource details, DKIM management and
  own-authenticator settings. Main was merged after first fast-forwarding the
  prepared local worktree to the published grants branch.
- Activation, deactivation and making eligible capture the session generation
  before the request. A successful late answer after logout or a replacement
  login cannot update tokens or capabilities. Normal refresh rotation remains
  part of the same session: its newest pair is kept and receives the grant's
  updated metadata. An unexpected success status does not apply metadata.
- Existing refresh handling also preserves newer grant metadata when an older
  refresh answer arrives, while retaining the newly rotated credential pair.
- Holder and scope filters are applied together. Draft edits do not change
  later page queries until applied; invalid holder input sends no query. Reset
  clears both. Applying a new filter removes previous rows before the request.
- The account picker loads every mailbox page rather than stopping at 200.
  Manual account-number entry remains available even when a picker is present,
  so visible address metadata does not limit which valid holder can be sent to
  the server for authorization.

## Authorization and remaining limits

Catalog/grant list access needs `users:read`; granting and removal need
`users:write`, a session signed in with 2FA, and live grants covering the role
and requested scope. Own-grant steps need ownership and, where required, fresh
proof. The server enforces these decisions. The UI surfaces refusal codes,
including invalid proof, wider-than-held grants, conflicts and last-superadmin
protection; a 403 does not refresh or sign the session out.

My permissions refreshes the server's capability snapshot and own-grant list
on entry, pull-to-refresh, retry and app resume. While this screen is mounted,
a single timer reloads at the next known grant or activation deadline. Old
actions disappear while loading or after refusal; a late earlier load cannot
restore them. Grant and activation deadlines are exclusive: at the exact
expiry time the role is no longer in force. Historical step summaries clear
when reconciling permissions.

App resume renews every signed-in REST session even if its access token still
has time left, because grants can expire or be removed independently. Concurrent
resume calls share the refresh, and rotated tokens and the resulting capability
snapshot use the existing ordered persistence. A transient network failure
keeps the session; a refused refresh ends it.

The fake still models only `superadmin` and `admin`, and its grantor checks do
not fully model scoped holdings. Scoped snapshots/permissions depend on #108
and server #619. The deadline timer belongs to My permissions; after leaving
it, other screens learn permission changes through ordinary token renewal,
app resume, or another server request. This is not evidence of complete live
scoped authorization or the whole admin parity objective.

## Verification

- **195 API tests pass**, including seven deadline-boundary regressions and
  the 12 session-generation/rotation/status regressions across all three
  own-grant mutation methods. API analysis passes with `--fatal-infos`.
- **76 fake tests pass**, including its existing grants, DKIM and two-factor
  suites. Fake analysis passes with `--fatal-infos`.
- Pinned Dart 3.13.1 formatting, package formats and `git diff --check` pass.
- Three new widget tests cover combined filters/reset/invalid input; paging
  beyond 200, manual holder entry and eligible create/delete; and read-only
  role/capability inspection. Four additional widget tests cover timed expiry,
  background/resume, refusal/retry and an out-of-order grant response. Two
  additional AppState tests cover removal of permissions while the access
  token remains fresh, coalesced renewal/persistence, and a revoked refresh.
  The existing eligible-activation and phone-width tests remain. These Flutter
  tests, full app analysis/tour and Android/iOS builds have not run locally;
  normal GitHub CI supplies that evidence.

Local logs live under `/tmp/restmail-mobile-api-audit/grants-integrated-*`
and `grants-expiry-*`;
the durable overnight state records exact branch heads and subsequent CI
results. No production account or credential was used.
