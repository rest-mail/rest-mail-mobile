import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/state/recovery_email_state.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// A connection that goes down for every GET.
class _NoReads extends http.BaseClient {
  _NoReads(this._inner);

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      request.method == 'GET'
      ? Future.error(http.ClientException('Connection refused', request.url))
      : _inner.send(request);
}

void main() {
  const account = 'ada@restmail.test', password = FakeAccounts.adminPassword;
  late FakeRestmail fake;
  late RestmailClient client;
  late RecoveryEmailState state;

  setUp(() async {
    fake = FakeRestmail()..addAccount(account);
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: account,
      password: password,
      totpCode: FakeAccounts.totpCode,
    );
    state = RecoveryEmailState(client: client);
  });
  tearDown(() {
    state.dispose();
    client.close();
    fake.close();
  });

  test('none, then pending with the link sent, then verified', () async {
    await state.load();
    expect(state.status!.stage, RecoveryEmailStage.none);
    expect(state.linkSent, isFalse);

    expect(
      await state.register(
        email: 'Backup@External.test',
        currentPassword: password,
      ),
      isTrue,
    );
    expect(state.status!.email, 'backup@external.test');
    expect(state.status!.stage, RecoveryEmailStage.pending);
    expect(state.linkSent, isTrue);
    expect(state.saving, isFalse);

    fake.setRecoveryEmail(account, 'backup@external.test');
    await state.load();
    expect(state.status!.stage, RecoveryEmailStage.verified);
    expect(state.linkSent, isFalse);
  });

  test('a refusal stays, and leaves the status as it was', () async {
    await state.load();
    expect(
      await state.register(
        email: 'backup@external.test',
        currentPassword: 'wrong',
      ),
      isFalse,
    );
    expect(state.saveError!.code, 'invalid_password');
    expect(state.status!.stage, RecoveryEmailStage.none);
    expect(state.linkSent, isFalse);
    state.clearSaveError();
    expect(state.saveError, isNull);
  });

  test('a failed read keeps what was shown', () async {
    fake.setRecoveryEmail(account, 'backup@external.test');
    await state.load();
    fake.online = false;
    await state.load();
    expect(state.loadError!.code, 'network_error');
    expect(state.status!.stage, RecoveryEmailStage.verified);
    expect(state.loading, isFalse);
    fake.online = true;
    await state.load();
    expect(state.loadError, isNull);
  });

  test('a read started before a registration cannot put the old address '
      'back', () async {
    final slow = FakeRestmail(latency: const Duration(milliseconds: 40))
      ..addAccount(account)
      ..setRecoveryEmail(account, 'old@external.test');
    addTearDown(slow.close);
    final slowClient = RestmailClient(
      server: Uri.parse('https://${slow.host}'),
      httpClient: slow.client,
    );
    addTearDown(slowClient.close);
    await slowClient.login(
      email: account,
      password: password,
      totpCode: FakeAccounts.totpCode,
    );
    final other = RecoveryEmailState(client: slowClient);
    addTearDown(other.dispose);
    final stale = other.load();
    await Future<void>.delayed(const Duration(milliseconds: 5));
    final registered = other.register(
      email: 'new@external.test',
      currentPassword: password,
    );
    await Future.wait([stale, registered]);
    expect(other.status!.email, 'new@external.test');
    expect(other.loading, isFalse);
    expect(other.saving, isFalse);
  });

  test('a registration that succeeds with a failing read still shows '
      'pending', () async {
    final failing = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      tokens: client.tokens,
      httpClient: _NoReads(fake.client),
    );
    addTearDown(failing.close);
    final other = RecoveryEmailState(client: failing);
    addTearDown(other.dispose);
    expect(
      await other.register(
        email: 'backup@external.test',
        currentPassword: password,
      ),
      isTrue,
    );
    expect(other.status!.stage, RecoveryEmailStage.pending);
    expect(other.linkSent, isTrue);
    expect(other.loadError, isNotNull);
    expect(other.loading, isFalse);
  });

  test('nothing happens after dispose', () async {
    final other = RecoveryEmailState(client: client);
    final loading = other.load();
    other.dispose();
    await loading;
    expect(other.status, isNull);
  });
}
