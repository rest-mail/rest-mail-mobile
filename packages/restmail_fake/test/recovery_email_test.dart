import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

/// The external recovery email, as REST Mail's RecoveryEmailHandler answers.
void main() {
  const account = 'ada@restmail.test', password = FakeAccounts.adminPassword;
  const backup = 'backup@external.test';
  late FakeRestmail fake;
  late RestmailClient client;
  var now = DateTime.utc(2026, 11, 3, 12);

  Uri url(String path) => Uri.parse('https://${fake.host}/api/v1/$path');

  Future<http.Response> post(String path, Object body) => fake.client.post(
    url(path),
    headers: {'content-type': 'application/json'},
    body: jsonEncode(body),
  );

  Future<void> register([String email = backup, String with_ = password]) =>
      client.registerRecoveryEmail(email: email, currentPassword: with_);

  Matcher refused(int status, String code, [Map<String, String>? fields]) =>
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', status)
            .having((e) => e.code, 'code', code)
            .having((e) => e.fields, 'fields', fields ?? isEmpty),
      );

  setUp(() async {
    now = DateTime.utc(2026, 11, 3, 12);
    fake = FakeRestmail(clock: () => now)..addAccount(account);
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: account,
      password: password,
      totpCode: FakeAccounts.totpCode,
    );
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  test('none, then pending, then verified by the link', () async {
    expect((await client.recoveryEmail()).stage, RecoveryEmailStage.none);

    await register('BACKUP@External.test');
    final status = await client.recoveryEmail();
    expect(status.email, backup);
    expect(status.stage, RecoveryEmailStage.pending);
    final mail = fake.recoveryMail.single;
    expect(mail.to, backup);
    expect(mail.mode, 'verify');
    expect(
      mail.link,
      'https://${fake.host}/api/v1/auth/recovery-email/link'
      '?mode=verify#${mail.token}',
    );

    final verified = await post('auth/recovery-email/verify', {
      'token': mail.token,
    });
    expect(verified.statusCode, 200);
    expect(jsonDecode(verified.body), {
      'data': {'message': 'Recovery email verified.'},
    });
    expect((await client.recoveryEmail()).stage, RecoveryEmailStage.verified);

    // Single use.
    final again = await post('auth/recovery-email/verify', {
      'token': mail.token,
    });
    expect(again.statusCode, 401);
    expect((jsonDecode(again.body) as Map)['error']['code'], 'invalid_token');
  });

  test('a link lasts 15 minutes', () async {
    await register();
    now = now.add(const Duration(minutes: 15));
    final late = await post('auth/recovery-email/verify', {
      'token': fake.recoveryMail.single.token,
    });
    expect(late.statusCode, 401);
    expect((await client.recoveryEmail()).stage, RecoveryEmailStage.pending);
  });

  test(
    'replacing the address clears verification and ends its links',
    () async {
      await register();
      final first = fake.recoveryMail.single.token;
      await register('other@external.test');
      expect(
        (await post('auth/recovery-email/verify', {'token': first})).statusCode,
        401,
      );
      final status = await client.recoveryEmail();
      expect(status.email, 'other@external.test');
      expect(status.stage, RecoveryEmailStage.pending);

      fake.setRecoveryEmail(account, backup);
      await register('third@external.test');
      expect((await client.recoveryEmail()).stage, RecoveryEmailStage.pending);
    },
  );

  test('registering refuses in the handler\'s words and order', () async {
    await expectLater(
      register('not an address', 'wrong'),
      refused(422, 'validation_failed', {'email': 'must be a valid email'}),
    );
    await expectLater(
      register(backup, ''),
      refused(422, 'validation_failed', {
        'current_password': 'must be at least 1 character',
      }),
    );
    await expectLater(
      register('${'a' * 250}@external.test'),
      refused(422, 'validation_failed', {
        'email': 'must be at most 255 characters',
      }),
    );
    // The password is checked before the address's domain.
    await expectLater(
      register('other@restmail.test', 'wrong'),
      refused(403, 'invalid_password'),
    );
    await expectLater(
      register('other@restmail.test'),
      refused(422, 'validation_failed', {
        'email': "must be outside this server's hosted domains",
      }),
    );
    await expectLater(
      register(account),
      refused(422, 'validation_failed', {
        'email': "must be outside this server's hosted domains",
      }),
    );
    expect((await client.recoveryEmail()).stage, RecoveryEmailStage.none);
    expect(fake.recoveryMail, isEmpty);
    expect(
      fake.auditLog.where((e) => e.action == 'auth.recovery_email.register'),
      hasLength(6),
    );
  });

  test('no session, no recovery email', () async {
    final response = await fake.client.get(url('auth/recovery-email'));
    expect(response.statusCode, 401);
    final closed = await post('auth/recover/email', {
      'email': account,
      'extra': true,
    });
    expect(closed.statusCode, 422);
    expect((jsonDecode(closed.body) as Map)['error']['details']['fields'], {
      'extra': 'not allowed',
    });
  });

  test('an address on a domain now hosted here stops counting', () async {
    fake.setRecoveryEmail(account, 'backup@restmail.test');
    expect((await client.recoveryEmail()).stage, RecoveryEmailStage.pending);
    await post('auth/recover/email', {'email': account});
    expect(fake.recoveryMail, isEmpty);
  });

  group('asking for a link', () {
    Future<http.Response> ask(String address) =>
        post('auth/recover/email', {'email': address});

    test('answers the same for every kind of address', () async {
      fake
        ..addAccount('verified@restmail.test')
        ..setRecoveryEmail('verified@restmail.test', backup)
        ..addAccount('pending@restmail.test')
        ..setRecoveryEmail(
          'pending@restmail.test',
          'pending@external.test',
          verified: false,
        )
        ..addAccount('none@restmail.test')
        ..addAccount('disabled@restmail.test')
        ..setRecoveryEmail('disabled@restmail.test', 'gone@external.test');
      fake.disableAccount('disabled@restmail.test');

      final answers = <String>{};
      for (final address in [
        'verified@restmail.test',
        'pending@restmail.test',
        'none@restmail.test',
        'disabled@restmail.test',
        'nobody@restmail.test',
      ]) {
        final response = await ask(address);
        expect(response.statusCode, 200, reason: address);
        answers.add(response.body);
      }
      expect(answers, hasLength(1));
      expect(jsonDecode(answers.single), {
        'data': {
          'message':
              'If this account has a verified recovery email, a recovery '
              'link will be sent.',
        },
      });
      // Only the verified one gets mail, at its recovery address.
      final mail = fake.recoveryMail.single;
      expect(mail.to, backup);
      expect(mail.mode, 'recover');
      // And only that one records anything.
      expect(
        fake.auditLog.where((e) => e.action == 'auth.recovery_email.issue'),
        hasLength(1),
      );
    });

    test('every address has the same budget, five then one per 15 '
        'minutes', () async {
      fake.setRecoveryEmail(account, backup);
      for (final address in [account, 'nobody@restmail.test']) {
        for (var i = 0; i < 5; i++) {
          expect((await ask(address)).statusCode, 200);
        }
        final held = await ask(address);
        expect(held.statusCode, 429);
        expect(held.headers['retry-after'], '900');
        expect((jsonDecode(held.body) as Map)['error'], {
          'code': 'rate_limited',
          'message':
              'Too many recovery requests for this address; try again later',
        });
      }
      now = now.add(const Duration(minutes: 15));
      expect((await ask(account)).statusCode, 200);
      expect((await ask(account)).statusCode, 429);
    });

    test('another request replaces the earlier link', () async {
      fake.setRecoveryEmail(account, backup);
      await ask(account);
      await ask(account);
      final [first, second] = fake.recoveryMail;
      expect(
        (await post('auth/recover/email/redeem', {
          'token': first.token,
          'new_password': 'a brand new passphrase',
        })).statusCode,
        401,
      );
      expect(
        (await post('auth/recover/email/redeem', {
          'token': second.token,
          'new_password': 'a brand new passphrase',
        })).statusCode,
        200,
      );
    });

    test('a server that cannot send links says so for any address', () async {
      fake.recoveryEmailConfigured = false;
      final answers = <String>{};
      for (final address in [account, 'nobody@restmail.test']) {
        final response = await ask(address);
        expect(response.statusCode, 503);
        answers.add(response.body);
      }
      expect(answers, hasLength(1));
      await expectLater(register(), refused(503, 'unavailable'));
    });

    test('the form of the address is refused before anything else', () async {
      final response = await ask('not an address');
      expect(response.statusCode, 422);
      expect((jsonDecode(response.body) as Map)['error']['details']['fields'], {
        'email': 'must be a valid email',
      });
    });
  });

  group('the recovery link', () {
    const fresh = 'a brand new passphrase';
    late String token;

    setUp(() async {
      fake.setRecoveryEmail(account, backup);
      await post('auth/recover/email', {'email': account});
      token = fake.recoveryMail.single.token;
    });

    test('sets the password, ends sessions, freezes the address and does not '
        'sign in', () async {
      final response = await post('auth/recover/email/redeem', {
        'token': token,
        'new_password': fresh,
      });
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body), {
        'data': {
          'message':
              'Password changed. Sign in again with the new password and '
              'your existing second factor.',
        },
      });
      expect(fake.passwordOf(account), fresh);
      await expectLater(client.recoveryEmail(), throwsA(isA<ApiException>()));
      // The authenticator stays.
      await expectLater(
        client.login(email: account, password: fresh),
        throwsA(isA<TotpRequiredException>()),
      );
      await client.login(
        email: account,
        password: fresh,
        totpCode: FakeAccounts.totpCode,
      );

      await expectLater(
        register('other@external.test', fresh),
        refused(403, 'recovery_method_frozen'),
      );
      now = now.add(const Duration(hours: 72, seconds: 1));
      await client.login(
        email: account,
        password: fresh,
        totpCode: FakeAccounts.totpCode,
      );
      await register('other@external.test', fresh);
      expect((await client.recoveryEmail()).email, 'other@external.test');
    });

    test('is refused with a short password, and is not spent', () async {
      final short = await post('auth/recover/email/redeem', {
        'token': token,
        'new_password': 'short',
      });
      expect(short.statusCode, 422);
      expect((jsonDecode(short.body) as Map)['error']['details']['fields'], {
        'new_password': 'must be at least 12 characters',
      });
      expect(
        (await post('auth/recover/email/redeem', {
          'token': token,
          'new_password': fresh,
        })).statusCode,
        200,
      );
    });

    test('a verification link does not reset a password', () async {
      await register('other@external.test');
      final verify = fake.recoveryMail.last.token;
      final response = await post('auth/recover/email/redeem', {
        'token': verify,
        'new_password': fresh,
      });
      expect(response.statusCode, 401);
      expect(fake.passwordOf(account), password);
    });

    test('ends when the password changes another way', () async {
      await client.recoverAccount(
        email: account,
        totpCode: FakeAccounts.totpCode,
        recoveryCode: FakeAccounts.recoveryCode,
        newPassword: 'chosen another way, by codes',
      );
      expect(
        (await post('auth/recover/email/redeem', {
          'token': token,
          'new_password': fresh,
        })).statusCode,
        401,
      );
    });
  });

  test('a server older than recovery email answers 404', () async {
    fake.recoveryEmailRoutes = false;
    await expectLater(
      client.recoveryEmail(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
    );
    expect(
      (await post('auth/recover/email', {'email': account})).statusCode,
      404,
    );
  });
}
