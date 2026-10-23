# Scoped grants: mobile integration and fake contract

## Integrated branch

PR #108 merges parent #99 through `b2fa1b1`. The merge retains scoped login,
refresh and escalation metadata; scoped token persistence; the session-epoch
guard for late privilege changes; own two-factor management; per-domain DKIM
authorization/pickers; and My permissions expiry/resume behavior. It remains
stacked on #99 until that parent merges. Retarget to main and merge current main
at that point, then require fresh CI. Server #619 remains necessary for real
scoped administration, after scoped API keys #618 and the older server queue.

## Source contract

The fake's built-ins now follow `internal/bootstrap/bootstrap.go`:

| Role | Capabilities |
| --- | --- |
| superadmin | `*` |
| admin | Standard domain/mailbox/pipeline/queue/ban/message/observability/audit administration **and `users:read`**, without grant mutation |
| readonly | The eight seeded read capabilities, including `users:read`; no audit or writes |
| owner | `mail:read`, `mail:write`, `mail:send`, `mailbox:manage` |

Scope parsing/hierarchy follows `internal/grants/scope.go`; grant authorization
follows `Held.CanGrant` and `grants.Authorize`; the usable last-superadmin check
follows `internal/grants/change.go`.

The fake implements scope rules independently of the mobile helper:

- Trim/lowercase scopes; validate labels and mailbox local parts as the server
  does, including single-label domains. Global scope covers all, domain covers
  itself/its mailboxes, and a mailbox covers only itself.
- Grant creation and removal require every capability of the role at a covering
  scope **now**. Global grant-management permission alone cannot expand a role.
  Eligible or expired grants give nothing unless currently activated/unexpired.
- Cached token snapshots never authorize global admin routes or grant changes.
  Static `grant()` fixture holdings remain supported as global grants.
- Owner capabilities apply to active own/linked mailboxes. Login, refresh and
  escalation return sorted/deduplicated scoped capabilities separately from
  global capabilities. Narrow wildcard never becomes global wildcard.
- Account creation reads live `mailboxes:write` covering the destination domain.
- A scoped wildcard, expired grant, inactive holder, or eligible grant without
  an enrolled authenticator cannot stand in for the last usable global
  superadmin. Fixture accounts with an active global wildcard are also counted.

My permissions shows escalation scope details grouped by scope, with wrapped
capability names. A scoped-only reply is no longer described as having no
capabilities; the server's global and scoped snapshots remain distinct.

## Evidence

- **204 API tests pass**, including scoped snapshot/rotation tests and the parent
  session-generation, expiry-boundary and security regressions.
- **99 fake tests pass**, including **23 new scoped-grant tests**: ten scope
  boundary cases, scoped wildcard, target/current-authority deletion, eligible
  activation/deactivation, expiry with a fresh token, owner limits/deduplication,
  two account-creation scopes, scope grammar/normalization, four unusable
  last-superadmin alternatives, and a usable replacement.
- Both package analyses pass with `--fatal-infos`; package/root pinned
  formatting and diff checks pass.
- The first API run caught an outdated scoped test returning activation 200;
  it is corrected to the server's 201 and includes activation metadata. The
  client status guard was retained. Failure log is preserved in the overnight
  evidence; the full rerun passes.
- One additional mobile workflow checks scoped activation summary and retains
  global-vs-domain boundaries. This and the combined Flutter app analysis,
  tests/tour and Android/iOS builds have **not run locally**; normal PR CI must
  supply that evidence.

## Remaining limits

This improves the fake's grants/auth snapshots, not every scoped API route.
Core domain/mailbox/alias collection filtering and response redaction remain
covered by server #619's contract/integration work and the existing mobile
transport scenarios; most general fake resource routes still require global
capabilities. No live server, production credential, release or whole admin
parity completion is claimed here. Other feature PRs still need main integration.
