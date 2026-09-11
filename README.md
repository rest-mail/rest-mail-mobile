# rest-mail mobile

The iOS and Android client for
[rest-mail](https://github.com/rest-mail/rest-mail-server). One Flutter app
builds for both platforms. It talks to the server over the same REST API the
webmail uses, not IMAP.

## What it does

- Signs in with an email address and password, plus a TOTP or recovery code
  when the account has two-factor authentication. It finds the server from the
  address's domain, or you can enter the server address yourself.
- Folders, message lists, reading, reply, reply all, forward, drafts, search
  and attachments. You can also link other mailboxes on the same server and
  switch between them.
- Live updates over the server's event stream while the app is open.
- HTML mail is cut down to the webmail's allowlist and drawn as native
  widgets. There is no web view and no JavaScript. Remote images stay blocked
  until you tap Load.
- HTTPS only. The app has no setting that turns off certificate checks.

## Layout

| Path | What |
|---|---|
| `lib/` | The app |
| `packages/restmail_api/` | The REST client as a plain Dart package: sign-in and token refresh, mail, the event stream, server discovery. It has no Flutter code, so its tests run with `dart test`. |
| `assets/fonts/` | Public Sans (SIL Open Font License) |

## Development

You need Flutter 3.47.1 (stable), Xcode 26 for iOS, and the Android SDK
(platform 36) with JDK 17 or 21 for Android. CocoaPods is not needed: every
plugin resolves through Swift Package Manager.

```sh
flutter pub get
flutter analyze
flutter test
(cd packages/restmail_api && dart pub get && dart analyze && dart test)
flutter run
```

### Against a local testbed

The testbed signs its certificates with its own CA. You can tell a debug build
to trust that CA:

```sh
mkdir -p .dev
python3 -c 'import json,sys; print(json.dumps({"RESTMAIL_DEV_CA": open(sys.argv[1]).read()}))' \
  path/to/testbed-ca.crt > .dev/testbed.json
flutter run --dart-define-from-file=.dev/testbed.json
```

Profile and release builds ignore this define. The simulator or emulator also
has to resolve the testbed's host names.

## Identity

The app ID is `com.antimatterstudios.restmail` on both platforms. It ships
under Apple Developer team `43UMKXZ8P4`.

## Not yet

- Notifications while the app is closed. The server needs to push through
  APNs and FCM first.
- Sending attachments. The send API has no field for them.
- Contacts, vacation replies, Sieve filters, quarantine and administration.
