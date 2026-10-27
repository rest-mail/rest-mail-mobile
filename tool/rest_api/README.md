# Generated REST client

The owner decision in server #895/mobile #116 is Tonik, pinned exactly, with
committed generated code and a regeneration gate. `contract.lock.json` records
the server revision/version/document checksum, generator archive checksum,
Dart version, backend and output directory. The generator's complete dependency
resolution is committed in `pubspec.lock`. Do not edit `restmail_generated`.

The first committed document is the exact JSON served by production 0.28.0,
revision `2bac2b0f06291effd4ba0c9cc036548f6b24a0bd`: 171 operations, including
82 production admin operations. A future server pin change must update the
complete document and checksum, then regenerate; new operations are not held to
the old fixed 81-operation manifest.

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

Generating a package and adding a transport is not the complete client migration.
Existing `RestmailClient` endpoint methods and UI DTOs still encode/decode by
hand. Migrate coherent API groups to generated request/response types with
contract-shaped fake data and widget coverage. Preserve required fields and
header semantics rather than weakening the generated document to fit old mocks.
The integration tests in `generated_client_test.dart` exercise generated domain
requests, parsing, authentication/error behavior and transport replay. The
legacy endpoint manifest still needs a server-derived drift guard and the
invitation workflows remain separate confirmed gaps.
