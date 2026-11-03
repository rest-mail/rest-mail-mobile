# Mobile admin reports

The report screens use the server's production handlers (`logs.go`, `pipeline.go`,
`analytics.go`, `tlsrpt.go`, `dmarc_reports.go`, `trace.go`, `audit.go`). All gates below
require a global grant, except DMARC reports, which a domain-scoped administrator reads
for their own domains. A permission refusal remains an error on the screen and preserves the session.

| Operation | Request controls | Response / workflow | Capability |
| --- | --- | --- | --- |
| Delivery log | All six statuses; exact destination domain; literal sender/recipient substring; inclusive since/until; offset/limit | Filtered paging; full queue entry metadata, delivery attempts and errors; trace link only with trace access | `messages:read` |
| Pipeline log | Pipeline number; direction; final action; exact Message-ID; outcome; exact reason code; offset/limit | Full trace including undelivered messages; pipeline, sampling and retention metadata; every step's type, timing, arbitrary structured log and error | `pipelines:read` |
| Message trace | Stored message number | Same trace presentation; loading, not-found and permission refusals | `observability:read` |
| Analytics | Day/week; custom Go duration or RFC3339 start (start takes precedence) | Exact fractional counts; returned window bounds/label; independently selected cumulative live counters when present | `observability:read` |
| TLS reports | Domain number; policy; literal reporting organisation substring; offset/limit | Full dates/counts/metadata; arbitrary failure details; selectable original report when present | `domains:read` |
| DMARC reports | Domain number; literal reporter domain substring; offset/limit | Reporting organisation, domain and date range; each record's source, count, disposition, DKIM and SPF results, identifiers and reasons; published policy; report read fresh from `/{id}` | `domains:read` at `*` or a domain scope |
| Audit log | Actor kind/account number/name; exact action; outcome; inclusive since/until; before sequence/limit | Cursor paging; credential/session/request attribution; full entry and selectable anchor/hash | `audit:read` |
| Verify audit | Optional independently saved `sequence:hash` | Complete chain result, last verified entry/hash, echoed anchor, broken sequence/reason/note; never substitutes a freshly fetched hash for external proof | `audit:read` |

Filters can be inspected, changed or cleared; changes restart paging. Empty filters
are omitted. Dates are sent in UTC. Duration values retain subhour/microsecond
precision. Trace totals are milliseconds, whereas the current server serializes
individual step `time.Duration` values in nanoseconds despite the `duration_ms` key.

## Verification

- API request/model/refusal tests: `packages/restmail_api/test/reports_test.dart`.
- Fake integration: `packages/restmail_fake/test/reports_test.dart`, including filtered
  totals/paging, inclusive bounds, anchors and cumulative counters.
- Mobile workflows: five added tests in `test/admin_sections_test.dart` for delivery,
  TLS, pipeline, audit and analytics controls/details. These require Flutter CI.
- Received DMARC reports: `packages/restmail_api/test/dmarc_reports_test.dart`,
  `packages/restmail_fake/test/dmarc_reports_test.dart` and
  `test/dmarc_reports_flow_test.dart`.
- The standard PR workflow runs formatting, package analysis/tests, Flutter
  analysis/tests, screen tour and platform builds. Local Dart evidence does not
  establish Flutter or deployed-server integration.

Other admin parity branches remain separate work; this report matrix does not
claim that the overall mobile/admin parity objective is complete.
