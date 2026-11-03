# Generated REST client

The owner decision in server #895/mobile #116 is Tonik, pinned exactly, with
committed generated code and a regeneration gate. `contract.lock.json` records
the server revision/version/document checksum, generator archive checksum,
Dart version, backend and output directory. The same lock pins the immutable
server image used by the real-server integration fixture; its OCI revision label
must match the contract revision before tests start. The generator's complete dependency
resolution is committed in `pubspec.lock`. Do not edit `restmail_generated`.

The committed document is the exact JSON served by the `main` image of server
revision `39483178c1084aeb70004c7c935018989543b69f`, which carries the thread-snooze,
receipt-seal, contact reply-time, received DMARC report and quiet-hours routes:
200 operations. No release holds that revision yet, so
`info.version` and the lock's version read `main`, and the revision and image
digest name it. A future server pin change must update the complete document
and checksum, then regenerate; new operations are not held to the old fixed
81-operation manifest.

The server registers its push device routes only with APNs configured, and
describes only what it registers. Capture the document from the locked image
with all of `RESTMAIL_APNS_KEY_FILE` (a throwaway P-256 key will do),
`RESTMAIL_APNS_KEY_ID` and `RESTMAIL_APNS_TEAM_ID` set, as production has them,
or the three push operations disappear from the generated client.

On the pinned Dart SDK:

```sh
python3 tool/rest_api/generate.py --write
python3 tool/rest_api/generate.py --check
```

The GitHub `Generated REST client` job regenerates in a temporary directory,
compares all output files and analyzes the generated package. The explicit
workflow bootstrap switch resolves the generator lock for a deliberate version
change; normal generation enforces the committed lock.

## Account adapter

`package:restmail_api/generated.dart` exports the generated API groups/models.
Pass `RestmailClient.generatedSession` to authenticated groups and
`generatedPublic` to public discovery. Use `generatedValue` to preserve the
app's existing error exceptions while receiving the generated status union:

```dart
final result = await client.generatedValue(
  AdminDomainsApi(client.generatedSession).listDomains(limit: 100, offset: 0),
);
if (result case ListDomainsResponse200(:final body)) {
  final domains = body.body.data;
}
```

Both adapters borrow the account's existing HTTP client, including configured
TLS trust. Authenticated calls share the existing refresh policy and persistence
callbacks, including coalescing mixed legacy/generated requests. Retrying copies
the already encoded bytes and URL, preserving repeated query parameters. 403s
never refresh; a second request-level 401 retains a successfully rotated session.
The public adapter strips Authorization. Both reject destinations outside the
account's origin/base path. Generated response parse failures become
`bad_response`; HTTP errors retain the server's error code/fields/Retry-After.

Login, logout, refresh, persisted account state and the SSE stream continue
through the existing account methods. This adapter buffers ordinary requests;
do not move the event stream onto it.

## Remaining migration

The quiet-hours facade uses the generated notifications operations and `Setting`
DTO for both responses and request serialization. Tonik 0.10.0 loses the parent
properties of the served `quietHoursBody` schema's `anyOf`: its generated request
variants cannot encode the boolean `enabled` or retain all fields when disabled.
A narrow `QuietHoursBody` subclass delegates `toJson` to the generated `Setting`
DTO instead. Generated output and the served description are unchanged. The
facade's wire test asserts all four fields in both enabled and disabled requests;
the real-server test exercises both through the generated operation.

The fake persists account-local schedules and returns the server's field errors
and mail-capability refusals. It validates IANA names against bundled time-zone
data, not a hand-maintained list. It does not suppress mail or notifications: the
production server owns notification holding and summary delivery.

Generating a package and adding a transport is not the complete client migration.
The domain and mailbox facade batch, and the contact reply-time setting, migrate
the operations listed in `migrated_operations.json`, including DNS and ending
sessions.

The receipt-seal facade also calls `verifyMessageSeal` through the generated
messages API. Its three wire verdicts are separate from the reader's checking
and unavailable states. An absent seal remains `not_sealed`; neither hash
presence nor a failed request is an integrity verdict.

The fake serves seeded server results: set `FakeMessage.sealedHash` and
`sealMismatch` to exercise intact and mismatch receipts. Without a hash it
reports `not_sealed`, including for pre-seal sample mail. It does not implement
the server's hashing algorithm or claim to verify stored bytes.

The thread-snooze facade calls `snoozeThread` through the generated messages
API, and null cancels. The fake keeps each thread's deadline on its messages,
hides them from folder listings and counts as the server does, and takes
returning from its clock: `returnSnoozedThreads` does what the server's worker
does, and the fake also does it ahead of each request.

The received DMARC report facades call `listDmarcReports` and `getDmarcReport`
through the generated domain mail policy API. The server leaves a page's total
out when it is zero, so the facade counts what it was given. The fake answers
with the server's shape, including that, and scopes reports as the server does.

Existing screens reach generated operations through their unchanged facade
methods. Generated code validates status, headers and wire fields; typed projections preserve the
current display model, timestamp handling, quotas and setup flags.

Nullable request fields follow the generated document: Tonik may serialize an
unspecified nullable field as explicit `null`. The domain/mailbox Go handlers
treat these pointer fields as unchanged (or the creation default), while empty
strings, `false` and zero retain their distinct meanings. Exact-body tests assert
that generated payload, and fake behavioral tests verify unrelated state is kept.

Other `RestmailClient` endpoint groups still encode/decode by hand. Continue
migrating coherent API groups to generated request/response types with
contract-shaped fake data and widget coverage. Preserve required fields and
header semantics rather than weakening the generated document to fit old mocks.
The integration tests in `generated_client_test.dart` exercise generated domain
requests, parsing, authentication/error behavior and transport replay. The
legacy endpoint manifest still needs a server-derived drift guard and the
invitation workflows remain separate confirmed gaps.
