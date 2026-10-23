# Dashboard response coverage

`getDashboardStats`: `GET /api/v1/admin/stats`, no path parameters,
query parameters or request body. Requires `domains:read` at `*`, including
when a narrower grant permits other administration screens. There are no
write actions on this screen.

Contract source: `rest-mail-server` commit
`831a0b4ccb388df9245d62acf942c7f1d93e4b3b`,
`internal/api/handlers/stats.go` (`DashboardStats`, `QueueStats`,
`MessageVolumeData`, `RecentActivity`, `InboundTransportSecurity`) and
`internal/api/routes.go`. The operation also exists on server main; this
change does not require the pending scoped-admin server feature.

## Response and screen mapping

| JSON field under `data` | Client member | Overview |
| --- | --- | --- |
| `domainCount` | `ServerStats.domains` | Domains |
| `mailboxCount` | `mailboxes` | Mailboxes |
| `queueStats.pending` | `queuePending` | Waiting to go out |
| `queueStats.processing` | `queueProcessing` | Being delivered |
| `queueStats.failed` | `queueFailed` | Given up on |
| `messageVolume[].date` | `volume[].date` | Server's date label |
| `messageVolume[].count` | `volume[].count` | Count and proportional bar |
| `recentActivity[].id` | `recent[].id` | Selectable ID on each record |
| `recentActivity[].type` | `recent[].type` | Selectable event type |
| `recentActivity[].description` | `recent[].description` | Wrapping record heading |
| `recentActivity[].timestamp` | `recent[].at` | Local date/time |
| `inboundTransportSecurity.totalInboundMX` | `inboundMx` | Deliveries from other servers |
| `inboundTransportSecurity.overTLS` | `inboundOverTls` | Encrypted with TLS |
| `inboundTransportSecurity.plaintext` | `inboundPlaintext` | Unencrypted |
| `inboundTransportSecurity.tlsPercent` | `inboundTlsPercent` | Server's TLS percentage |
| `inboundTransportSecurity.plaintextPercent` | `inboundPlaintextPercent` | Server's plaintext percentage |
| `inboundTransportSecurity.plaintextAuthPass` | `plaintextAuthPass` | Unencrypted, sender authentication passed |
| `inboundTransportSecurity.plaintextAuthFail` | `plaintextAuthFail` | Unencrypted, no passing sender authentication |

Percentages are preserved from the response, including fractional values;
there is no client-side division or rounding. Zero inbound deliveries show
an explanation. Missing groups on older servers use zero/empty defaults.
Unknown activity types are preserved. `ServerStats.recent` now contains
`DashboardActivity` objects with the existing `description` and `at` members
plus `id` and `type`; callers explicitly constructing records must use the
new typed constructor.

Long activity descriptions and identifiers use vertically labelled cards
with wrapping/selectable text. The records require no horizontal scrolling.
This applies the responsive record-card request to Overview; it is not a
claim that all other mobile or web administration layouts have been audited.

## Errors and permission changes

The shared authenticated client handles access-token renewal. A 403/500 on
this operation preserves the session and does not refresh it. The screen
shows the shared error message and retry action instead of old statistics.
Pull-to-refresh requests the latest snapshot; losing the global capability
hides the screen through `AdminPage`.

## Verification

- API request/body/auth and all 18 leaf response fields: `dashboard_test.dart`
  in `restmail_api`, with the exact server-shaped fixture.
- Model defaults, integer/fractional percentages, future activity types,
  absent timestamps and session-preserving 403/500 cases: same test file.
- Fake transport/activity fixture consistency: `restmail_fake/test/dashboard_test.dart`.
- Five Flutter workflows authored in `test/overview_flow_test.dart`: phone
  width 320 at text scale 1.6; width 1024; refresh/refusal/retry; no request
  without permission; zero inbound deliveries. They run on normal PR CI;
  Flutter is not available on the Raspberry Pi.

This operation's implementation does not establish parity for all 81
production admin operations, nor integrate other pending feature branches.
