# Single queue mutation acknowledgements

The actual server handlers (`internal/api/handlers/queue.go`, server source
`831a0b4ccb388df9245d62acf942c7f1d93e4b3b`) return:

- `POST /api/v1/admin/queue/{id}/retry`: 200 `{"data":{"status":"retrying"}}`.
- `POST /api/v1/admin/queue/{id}/bounce`: 200 `{"data":{"status":"bounced"}}`.

Both requests have no body or query and require global `queue:manage`.
The OpenAPI operations are `retryQueueEntry` and `bounceQueueEntry`; the fake
already returns the same acknowledgements.

Both client methods now return typed `QueueActionResult`, validate HTTP200,
parse the `data.status` field and require the acknowledgement for the requested
action. Empty, malformed, wrong-action and unexpected 2xx responses throw
`ApiException` with `bad_response`. These responses do not retry the mutation
or end the session. Normal non-2xx refusals preserve the existing error path.

The mobile success action occurs after this validation, so it cannot claim a
retry/bounce succeeded from an unread response. Existing callers awaiting the
operation can ignore its return value; consumers can now inspect `.status`.

`queue_acknowledgement_test.dart` has 22 request/response/refusal regressions.
The complete API and fake package suites and analyses are run locally; Flutter
widgets and platform builds run in normal PR CI. This is consumer-side contract
validation, not a claim that a new live Vertrag run has happened.
