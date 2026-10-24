import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

/// A forgotten password reset with the authenticator and a recovery code,
/// as REST Mail answers POST /api/v1/auth/recover.
void main() {
  const address = 'ada@restmail.test', newPassword = 'a brand new passphrase';
  late FakeRestmail fake;
  late RestmailClient client;
  setUp(() {
    fake = FakeRestmail()..addAccount(address);
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  Future<LoginResult> recover({
    String email = address,
    String totp = FakeAccounts.totpCode,
    String recovery = FakeAccounts.recoveryCode,
    String password = newPassword,
  }) => client.recoverAccount(
    email: email,
    totpCode: totp,
    recoveryCode: recovery,
    newPassword: password,
  );

  test('the new password signs in, and the recovery code is spent', () async {
    final other = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    addTearDown(other.close);
    await other.login(
      email: address,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );

    final result = await recover(email: '  ADA@restmail.test ');
    expect(result.user.email, address);
    expect(result.isSetUp, isTrue);
    expect(client.tokens, isNotNull);
    expect(fake.passwordOf(address), newPassword);
    // The account's other sessions end.
    await expectLater(other.accounts(), _refused(401, 'session_expired'));

    // The authenticator stays; the recovery code is gone.
    await expectLater(recover(), _refused(401, 'recovery_failed'));
    await expectLater(
      client.login(email: address, password: newPassword),
      throwsA(isA<TotpRequiredException>()),
    );
  });

  test(
    'every refusal is the same, whether the address is an account or not',
    () async {
      for (final attempt in [
        () => recover(totp: '000000'),
        () => recover(recovery: 'WRONG-0000'),
        () => recover(email: 'nobody@restmail.test'),
      ]) {
        await expectLater(attempt(), _refused(401, 'recovery_failed'));
      }
      // An account without two-factor has no way back on its own.
      fake.addAccount('bo@restmail.test', twoFactor: false);
      await expectLater(
        recover(email: 'bo@restmail.test'),
        _refused(401, 'recovery_failed'),
      );
      expect(fake.passwordOf(address), FakeAccounts.adminPassword);
    },
  );

  test('five refusals for an address hold it off, from anywhere', () async {
    for (var i = 0; i < 5; i++) {
      await expectLater(
        recover(totp: '000000'),
        _refused(401, 'recovery_failed'),
      );
    }
    await expectLater(
      recover(),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 429)
            .having((e) => e.code, 'code', 'rate_limited')
            .having((e) => e.retryAfter, 'retryAfter', isNotNull),
      ),
    );
    // Another address is not held off.
    fake.addAccount('cy@restmail.test');
    expect(
      (await recover(email: 'cy@restmail.test')).user.email,
      'cy@restmail.test',
    );
  });

  test('what is missing or short is said, field by field', () async {
    final response = await fake.client.post(
      Uri.parse('https://${fake.host}/api/v1/auth/recover'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'new_password': 'short', 'client': 'web'}),
    );
    expect(response.statusCode, 422);
    expect(
      (jsonDecode(response.body)
          as Map<String, dynamic>)['error']['details']['fields'],
      {
        'email': "required: the account's address",
        'totp_code': "required: a code from the account's authenticator",
        'recovery_code': "required: one of the account's recovery codes",
        'new_password': 'must be at least 12 characters',
        'client': 'must be "native" or omitted',
      },
    );
    for (final (body, field, want) in [
      ({'email': 5}, 'email', 'must be a string'),
      ({'email': address, 'remember': true}, 'remember', 'not allowed'),
    ]) {
      final refused = await fake.client.post(
        Uri.parse('https://${fake.host}/api/v1/auth/recover'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(body),
      );
      expect(refused.statusCode, 422, reason: '$body');
      expect(
        (jsonDecode(refused.body)
            as Map<String, dynamic>)['error']['details']['fields'][field],
        want,
      );
    }
    expect(fake.passwordOf(address), FakeAccounts.adminPassword);
  });

  test('the attempt is in the audit log', () async {
    await recover();
    final admin = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    addTearDown(admin.close);
    await admin.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    final log = await admin.audit();
    expect(log.items.map((e) => e.action), contains('auth.recover'));
  });
}
