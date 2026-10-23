# Production administration API source map

`admin-api-parity.json` maps all **81 production admin operations** to their
OpenAPI request/response fields, current server route permission gates and
mobile client/UI call sites. Every source link uses a full commit SHA.

This is a reconciliation checklist, **not a certification that 81 operations
are complete, integrated or released**. A client method or screen call proves
source coverage only. Fields, handler behavior, scope correctness and exact-head
Flutter/integration results still require their own evidence. Most entries are
therefore deliberately `needs_field_review`; that does not mean their feature
implementation is absent. It means this source map has not independently
reconciled every field against that feature's tests and current server DTOs.

The checked-in snapshot pins server feature PR #619. It includes its scoped
list/alias policy; deployment needs the ordered server queue, including #618
and #619, to merge normally. Test-only routes are excluded. Auth, token rotation
and API-key lifecycle routes outside `/admin` remain additional completion
criteria and are not hidden inside the 81 count.

## Sources represented

| Mobile source | Surface | Integration caveat |
| --- | --- | --- |
| #108, including #99/#98/#103/#107 | Grants, domains, mailboxes, aliases, DKIM and domain delivery | Scoped source branch, not all on main |
| #102 | Queue detail, filters and bulk actions | Pending feature integration |
| #104 | Certificate upload/detail | Pending feature integration |
| #105 | Pipeline/custom filter editing, validation and testing | Pending feature integration |
| #106 | Ban filters, creation and IP removal | Pending feature integration |
| #109 | Delivery/pipeline logs, trace, analytics, TLS reports and audit | Pending feature integration |
| #111 | Full MTA-STS policy fields | Needs server #621 for explicit create defaults |
| #112 | Sender allow/block lists | Pending feature integration |
| #114 | Complete dashboard DTO and activity records | Local API/fake evidence; Flutter CI pending |

The JSON records the exact revision for each entry. A PR number is an
implementation location, not a claim about its current checks or release state.
No GitHub checks are polled by these tools.

## How to use the checklist

```sh
python3 tool/ci/admin_api_manifest.py docs/admin-api-parity.json
python3 tool/ci/admin_api_manifest.py docs/admin-api-parity.json --report
python3 -m unittest discover -s tool/ci -p 'test_admin_api_manifest.py'
```

The first command checks bidirectional coverage of the pinned 81 routes,
unique operation IDs, path parameters, immutable source locations, UI evidence
and explicit verification assessments. It rejects a source-discovery entry
claiming overall parity. The report lists fields needing reconciliation,
success schemas with opaque JSON and void client methods whose success response
contains JSON.

The normal App CI job runs the validator and its dependency-free Python unit
tests before Flutter validation. This checks manifest consistency; it cannot
detect an unannounced change in another repository. Server PR #620 separately
guards router/OpenAPI inventory. Refresh this consumer snapshot when that
server contract changes.

## Findings to resolve

1. `deletePipeline`, `deleteCustomFilter`, `retryQueueEntry` and
   `bounceQueueEntry` return `Future<void>` while their declared 200 response
   contains `data.status`. Confirm the real handler and fake, then explicitly
   validate/process those acknowledgements. A successful HTTP code alone does
   not establish full response handling.
2. Fourteen success contracts contain opaque objects or dynamic JSON. Inspect
   the Go DTO/handler and compare every actual field with the client model and
   screen. Dynamic filter configuration and raw reports need faithful structured
   handling; an opaque OpenAPI object alone cannot prove coverage.
3. Reconcile each feature branch's field/request/UI tests with the corresponding
   source-map entry. The dashboard has an 18-leaf field map and local test
   evidence; this map intentionally leaves other assessments unpromoted until
   their evidence has been checked.
4. Integrate #108's scope checks with the pending feature screens, finish scoped
   fake resource filtering/redaction, and obtain native Flutter/platform and
   server integration evidence after normal merges. Keep token rotation/resume
   and API-key lifecycle evidence separately.

## Refreshing the snapshot

Generation reads explicit existing worktrees and runs no builds, tests, GitHub
queries or writes outside this repository's manifest. It needs PyYAML locally;
the validator and CI tests use only Python's standard library.

```sh
python3 tool/ci/generate_admin_api_manifest.py \
  --server-root /path/to/server-scoped-worktree \
  --mobile-worktrees-root /path/to/mobile-worktrees \
  --state /path/to/overnight/state.json \
  --initial-server-audit /path/to/server-audit.json \
  --initial-mobile-audit /path/to/mobile-audit.json
```

The generator pins the explicitly supplied source revisions and verifies the
server route set against the audited baseline. Mobile source selection is
explicit in `source_groups`; adding a feature or new route requires reviewing
that mapping. The initial mobile audit supplies legacy method names, not
current coverage claims. Local field evidence is promoted only when its saved
head exactly matches the generated source revision.
