/// An in-memory rest-mail server.
///
/// It answers the same JSON, cookies and event stream as the real API, from
/// state it keeps in memory, through an `http.Client` that any
/// `RestmailClient` can use. Tests use it to exercise the app without a
/// network, and a debug build can run on it to try the app on a device with
/// no server at all.
///
/// It covers what the mobile client uses and nothing more; it is not a
/// rest-mail emulator.
library;

export 'src/fake_restmail.dart' show FakeRestmail, FakeScenario;
export 'src/model.dart';
export 'src/sample_mail.dart' show FakeAccounts;
