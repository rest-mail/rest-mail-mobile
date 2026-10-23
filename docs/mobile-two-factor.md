# Own-account two-factor management

Settings for the primary REST account now includes **Two-factor sign-in**.
Linked mailbox settings and IMAP accounts do not offer this action: all four
server routes operate on the account which signed in, without a mailbox id.

| Route | Request | Response and mobile workflow |
| --- | --- | --- |
| `GET /api/v1/auth/2fa` | Bearer session; no body | Parse both `enabled` and `pending`. Show On, Off or Not confirmed. Refresh removes stale controls while pending/refused; retry keeps the session after a network failure. |
| `POST /api/v1/auth/2fa/enroll` | Bearer session; no body | Parse `secret`, the `otpauth_url` and every recovery code. Open the authenticator or copy the setup key; copy recovery codes with the existing private clipboard helper. A pending enrollment can be restarted. |
| `POST /api/v1/auth/2fa/confirm` | `totp_code` | Empty 204. Require confirmation that recovery codes were saved. Wrong codes remain on the form. Discard setup secrets after confirmation; offer fresh sign-in so protected account actions get a session authenticated with 2FA. |
| `POST /api/v1/auth/2fa/disable` | `totp_code` and/or `recovery_code` | Empty 204. Native proof selection, explicit confirmation, then clear the local token pair. The server revokes every session for this owner, including this phone. |

Enrollment secrets are kept only in screen memory, hidden while the app is
inactive, and dropped when the screen closes. Recovery proof is obscured.
Clipboard copies use the existing platform policy: on iOS they stay on this
device and expire after two minutes; other platforms report their limitation.

The server's own-credential gate, setup rules and shared authentication throttle
remain authoritative. A wrong authenticator/recovery code is a 403; it never
refreshes or ends the session. A mandatory-2FA account gets a distinct refusal
even with correct proof. Missing proof, an already disabled authenticator and
rate limits retain the server's fields/codes. Malformed status/enrollment or an
unexpected confirm/disable response becomes `bad_response`, preserving tokens.

A session generation distinguishes login/sign-out from normal token rotation.
Late disable/password-change success cannot clear a newer login. Successful
disable after normal refresh still clears the rotated pair through the existing
ordered persistence callback, and the account stays on the phone signed out.

## Verification

- 148 API package tests pass, including 24 new status, lifecycle, refusal,
  malformed response, refresh and late-response cases.
- 72 fake package tests pass, including 9 new two-factor cases: pending/active
  state, setup access, wrong proof, mandatory 2FA, recovery-code consumption,
  all owner sessions ending, other owners and independent credentials surviving.
- Both package analyzers pass with `--fatal-infos`. Matching Dart format and
  `git diff --check` pass.
- Eight mobile workflow tests added for enrollment/copy/background/confirmation,
  pending enrollment restart, wrong proof/cancellation, persisted sign-out and
  reopening, recovery proof, mandatory 2FA, status retry and linked mailboxes.
- The existing light/dark CI screen tour now opens status and enrollment and
  exports both screens using only the fake's fixed public fixture secrets.
- Flutter analysis, widget execution and platform builds are **not run locally**;
  GitHub CI supplies that evidence. No live server was changed by these checks.

The fake uses fixed test codes, not real TOTP cryptography. It now consumes a
recovery code used at login, so reusing it for disable fails as on the server.
This is HTTP contract coverage, not evidence of a live authenticator deployment.
