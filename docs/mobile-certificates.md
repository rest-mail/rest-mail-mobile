# Mobile certificate administration

Contract checked against the server certificate handler, model and route gates.

| Operation | Request and response | Mobile workflow |
| --- | --- | --- |
| `listCertificates` | `offset`, `limit`; total and all certificate metadata with optional domain association. Both PEM fields are absent. | Certificates list with paging, expiry, issuer and renewal state. |
| `createCertificate` | `domain_id`, exact `cert_pem`, exact `key_pem`, optional `auto_renew`; reads the returned certificate metadata. | Upload form accepts a domain number or case insensitive name across every domain page, public multiline PEM, hidden clipboard paste and Yes/No/Server default renewal. Opens the created certificate's fresh GET. |
| `getCertificate` | Certificate id; public PEM, validity, issuer, renewal, creation/update dates and complete domain association. No private key. | Fresh detail on entry, pull to refresh and retry. Pending/refused requests replace old data. Domain row opens fresh domain detail. |
| `deleteCertificate` | Certificate id; empty 204 response. | Existing confirmed delete with list reload. |

The server requires global `domains:read` for both reads and global
`domains:write` for upload and deletion. These operations do not accept a grant
on just one domain. The app uses those global gates; a modified app still gets
the server's 403 without refreshing or ending its session. Missing resources
and invalid input retain their server codes and messages.

The shared form preserves multiline certificate text and hidden key text
exactly, including CRLF and trailing newlines. It does not rewrite PEM blocks.
Private key input is obscured and disposed with the form. No response model
contains the key, and the detail shows only the public certificate. Server
storage encryption depends on server configuration.

## Verification

- 125 API package tests pass, including exact PEM bytes, all metadata, list
  paging, nullable associations, all four operations' 403 behavior, 400 and 404.
- 62 fake package tests pass, including actual X509 issuer/validity parsing,
  list/create redaction, public detail, renewal defaults, paging, delete and
  read/write refusals.
- Both package analyzers pass with `--fatal-infos`.
- Matching Dart format checks and `git diff --check` pass.
- Eight mobile workflow tests added: upload/detail/hidden key, correction after
  invalid PEM, read only, modified reader refusal, domain paging beyond 200,
  refresh in flight/refusal/recovery, and initial 403/404 with retry.
- Flutter analysis, widget execution and platform builds run in GitHub CI;
  they have not run locally on the Pi.

The fake reads public X509 metadata with `basic_utils`, already used elsewhere
in the app dependency graph. It never retains the private key. It simulates
HTTP behavior, not TLS trust, hostname checks or certificate/key matching;
passing fake tests is not evidence of a live TLS installation.
