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

The checked-in source links were generated from server revision `831a0b4`
(the scoped-admin feature snapshot, including #618 and #619) and the mobile
feature branches. The route inventory was revalidated on 2026-10-26 against
server `main` `48b81639` and mobile `main` `6eb7d66`: the same 81 production
operations and operation IDs are present. Server #618-#621 and mobile
#102-#114 are now merged. Test-only routes are excluded. Auth, token rotation
and API-key lifecycle routes outside `/admin` remain additional completion
criteria and are not hidden inside the 81 count.

## Sources represented

| Mobile source | Surface | Integration caveat |
| --- | --- | --- |
| #108, including #99/#98/#103/#107 | Grants, domains, mailboxes, aliases, DKIM and domain delivery | Merged on main; scoped source links remain pinned |
| #102 | Queue detail, filters and bulk actions | Merged on main |
| #104 | Certificate upload/detail | Merged on main |
| #105 | Pipeline/custom filter editing, validation and testing | Merged on main |
| #106 | Ban filters, creation and IP removal | Merged on main |
| #109 | Delivery/pipeline logs, trace, analytics, TLS reports and audit | Merged on main |
| #111 | Full MTA-STS policy fields | Merged on main; server #621 merged |
| #112 | Sender allow/block lists | Merged on main |
| #114 | Complete dashboard DTO and activity records | Merged on main; Flutter CI runs on main |

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
guards router/OpenAPI inventory. The 2026-10-26 revalidation above checked the
route set only; the JSON's source links still point at the pinned revisions.
Refresh this consumer snapshot when that server contract changes.

## Findings to resolve

1. `retryQueueEntry` and `bounceQueueEntry` now return a typed
   `QueueActionResult`. `deletePipeline` and `deleteCustomFilter` still return
   `Future<void>`, but explicitly require 200 and `data.status == "deleted"`.
   The validator's `void_clients_with_success_json` report still names those
   deletes by design; it is not an unhandled response.
2. Fourteen success contracts contain opaque objects or dynamic JSON. Inspect
   the Go DTO/handler and compare every actual field with the client model and
   screen. Dynamic filter configuration and raw reports need faithful structured
   handling; an opaque OpenAPI object alone cannot prove coverage.
3. All listed mobile feature PRs are merged, but 80 of 81 operations remain
   `needs_field_review`. Reconcile each handler/DTO and request field with the
   client model and screen; source coverage is not field certification.
4. #108's scoped access is merged, and its scoped fake filtering/tests are on
   main. Native Flutter/platform and deployed-server integration evidence is
   still not implied by this snapshot. Keep token rotation/resume and API-key
   lifecycle evidence separately.

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
head exactly matches the generated source revision. Until it is regenerated,
this checklist is a historical source map with a revalidated route inventory,
not a current line-by-line snapshot.
