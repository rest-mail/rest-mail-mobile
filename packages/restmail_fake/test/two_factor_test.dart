import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Future<RestmailClient> _login(
  FakeRestmail fake, {
  String email = FakeAccounts.email,
  String password = FakeAccounts.password,
  String? recovery,
}) async {
  final client = RestmailClient(
    server: Uri.parse('https://${fake.host}'),
    httpClient: fake.client,
  );
  await client.login(
    email: email,
    password: password,
    totpCode: recovery == null ? FakeAccounts.totpCode : null,
    recoveryCode: recovery,
  );
  return client;
}

void main() {
  test(
    'status tracks off, pending and confirmed without returning secrets',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _login(fake);
      addTearDown(client.close);
      expect((await client.twoFactorStatus()).enabled, isFalse);
      final enrollment = await client.enrollTwoFactor();
      expect(enrollment.recoveryCodes, isNotEmpty);
      expect((await client.twoFactorStatus()).pending, isTrue);
      await expectLater(
        client.confirmTwoFactor('000000'),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'invalid_totp'),
        ),
      );
      expect((await client.twoFactorStatus()).pending, isTrue);
      await client.confirmTwoFactor(FakeAccounts.totpCode);
      final status = await client.twoFactorStatus();
      expect(status.enabled, isTrue);
      expect(status.pending, isFalse);
      final http = fake.client;
      addTearDown(http.close);
      final raw = await http.get(
        Uri.parse('https://${fake.host}/api/v1/auth/2fa'),
        headers: {'authorization': 'Bearer ${client.tokens!.accessToken}'},
      );
      expect(jsonDecode(raw.body), {
        'data': {'enabled': true, 'pending': false},
      });
      await expectLater(
        client.enrollTwoFactor(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 409)),
      );
    },
  );

  test('invalid proofs preserve the enrollment and session', () async {
    final fake = FakeRestmail(scenario: FakeScenario.twoFactor);
    addTearDown(fake.close);
    final client = await _login(fake);
    addTearDown(client.close);
    final tokens = client.tokens;
    for (final recovery in [false, true]) {
      await expectLater(
        client.disableTwoFactor(
          totpCode: recovery ? null : '000000',
          recoveryCode: recovery ? 'wrong-code' : null,
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            recovery ? 'invalid_recovery_code' : 'invalid_totp',
          ),
        ),
      );
      expect(client.tokens, same(tokens));
      expect((await client.twoFactorStatus()).enabled, isTrue);
    }
  });

  test(
    'disable ends all owner sessions, preserves other accounts and allows password login',
    () async {
      final fake = FakeRestmail(scenario: FakeScenario.twoFactor);
      addTearDown(fake.close);
      final client = await _login(fake),
          peer = await _login(fake),
          other = await _login(
            fake,
            email: FakeAccounts.adminEmail,
            password: FakeAccounts.adminPassword,
          );
      addTearDown(client.close);
      addTearDown(peer.close);
      addTearDown(other.close);
      await client.disableTwoFactor(totpCode: FakeAccounts.totpCode);
      expect(client.tokens, isNull);
      await expectLater(
        peer.accounts(),
        throwsA(isA<SessionExpiredException>()),
      );
      expect(peer.tokens, isNull);
      expect((await other.accounts()), isNotEmpty);
      final signedIn = await client.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      expect(signedIn.isSetUp, isTrue);
      expect((await client.twoFactorStatus()).enabled, isFalse);
    },
  );

  test('unused recovery proof turns off 2FA', () async {
    final fake = FakeRestmail(scenario: FakeScenario.twoFactor);
    addTearDown(fake.close);
    final client = await _login(fake);
    addTearDown(client.close);
    await client.disableTwoFactor(recoveryCode: FakeAccounts.recoveryCode);
    expect(client.tokens, isNull);
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    expect((await client.twoFactorStatus()).enabled, isFalse);
  });

  test(
    'a recovery code used at login cannot be reused for disabling',
    () async {
      final fake = FakeRestmail(scenario: FakeScenario.twoFactor);
      addTearDown(fake.close);
      final client = await _login(fake, recovery: FakeAccounts.recoveryCode);
      addTearDown(client.close);
      await expectLater(
        client.disableTwoFactor(recoveryCode: FakeAccounts.recoveryCode),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'invalid_recovery_code',
          ),
        ),
      );
      expect(client.tokens, isNotNull);
      await client.disableTwoFactor(totpCode: FakeAccounts.totpCode);
      expect(client.tokens, isNull);
    },
  );

  test('required 2FA is refused even with correct proof', () async {
    final fake = FakeRestmail();
    addTearDown(fake.close);
    final email = 'required@${fake.host}';
    fake.addAccount(email, twoFactorRequired: true);
    final client = await _login(
      fake,
      email: email,
      password: FakeAccounts.adminPassword,
    );
    addTearDown(client.close);
    final tokens = client.tokens;
    await expectLater(
      client.disableTwoFactor(totpCode: FakeAccounts.totpCode),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          'two_factor_required',
        ),
      ),
    );
    expect(client.tokens, same(tokens));
    expect((await client.twoFactorStatus()).enabled, isTrue);
  });

  test('empty proof and disabling while off retain the session', () async {
    final fake = FakeRestmail();
    addTearDown(fake.close);
    final client = await _login(fake);
    addTearDown(client.close);
    final tokens = client.tokens;
    await expectLater(
      client.disableTwoFactor(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 422)),
    );
    await expectLater(
      client.disableTwoFactor(totpCode: FakeAccounts.totpCode),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 400)),
    );
    expect(client.tokens, same(tokens));
  });

  test(
    'status and enrollment are available to an account still finishing setup',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final email = 'setup@${fake.host}';
      fake.addAccount(email, twoFactor: false, twoFactorRequired: true);
      final client = await _login(
        fake,
        email: email,
        password: FakeAccounts.adminPassword,
      );
      addTearDown(client.close);
      expect((await client.twoFactorStatus()).enabled, isFalse);
      await client.enrollTwoFactor();
      expect((await client.twoFactorStatus()).pending, isTrue);
    },
  );

  test(
    'disabling keeps independent app credentials valid as on the server',
    () async {
      final fake = FakeRestmail(scenario: FakeScenario.twoFactor);
      addTearDown(fake.close);
      final client = await _login(fake);
      addTearDown(client.close);
      final account = (await client.accounts()).firstWhere((a) => a.isPrimary);
      final created = await client.createAppPassword(
        account.id,
        name: 'Fixture credential',
        password: FakeAccounts.password,
      );
      final secret = created.secret!;
      expect(fake.acceptsAppPassword(FakeAccounts.email, secret), isTrue);
      await client.disableTwoFactor(totpCode: FakeAccounts.totpCode);
      expect(fake.acceptsAppPassword(FakeAccounts.email, secret), isTrue);
    },
  );
}
