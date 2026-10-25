import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypt/crypt.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

const _serverHash =
    r'{SHA512-CRYPT}$6$importsalt$ObInO4qcr134i8FQT.XNC6Ma04n9aRTAUNHmm8Yb1idoDBOXKoDTmdosY1xwfageGXo4ZSSrkIPRk9zMWfsG7/';
const _password = 'old-password';

void main() {
  RestmailClient client(FakeRestmail fake) {
    final result = RestmailClient(
      server: Uri.parse('https://${FakeAccounts.host}'),
      httpClient: fake.client,
    );
    addTearDown(result.close);
    return result;
  }

  Future<RestmailClient> admin(FakeRestmail fake) async {
    final result = client(fake);
    await result.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    return result;
  }

  final bcrypt = BCrypt.hashpw(_password, BCrypt.gensalt(logRounds: 4));
  final sha256 = Crypt.sha256(
    _password,
    salt: 'importsalt',
    rounds: 1000,
  ).toString();
  for (final (name, hash) in [
    ('sha512-prefixed', _serverHash),
    ('sha512-raw', _serverHash.substring('{SHA512-CRYPT}'.length)),
    ('sha256-raw', sha256),
    ('sha256-prefixed', '{SHA256-CRYPT}$sha256'),
    ('bcrypt-2a', bcrypt),
    ('bcrypt-2b', bcrypt.replaceFirst(r'$2a$', r'$2b$')),
    ('bcrypt-2y', bcrypt.replaceFirst(r'$2a$', r'$2y$')),
    ('bcrypt-prefixed', '{BLF-CRYPT}$bcrypt'),
  ]) {
    test(
      '$name import keeps the password, ownership and secret response boundary',
      () async {
        final fake = FakeRestmail();
        addTearDown(fake.close);
        final owner = await admin(fake);
        final account = await owner.createAccount(
          address: 'import@${FakeAccounts.host}',
          passwordHash: hash,
        );
        expect(fake.passwordOf(account.address), isNull);
        expect(
          (await owner.accounts()).map((a) => a.address),
          contains(account.address),
        );
        expect(
          fake.ownedBy(FakeAccounts.adminEmail),
          contains(account.address),
        );
        final imported = client(fake);
        await expectLater(
          imported.login(email: account.address, password: 'wrong-password'),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 401),
          ),
        );
        await imported.login(email: account.address, password: _password);
        expect((await imported.accounts()).first.address, account.address);
        await imported.changePassword(
          current: _password,
          next: 'replacement-password',
        );
        await expectLater(
          imported.login(email: account.address, password: _password),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 401),
          ),
        );
        await imported.login(
          email: account.address,
          password: 'replacement-password',
        );
      },
    );
  }

  test('the HTTP account response does not return an imported hash', () async {
    final fake = FakeRestmail();
    addTearDown(fake.close);
    final owner = await admin(fake);
    final response = await fake.client.post(
      Uri.parse('https://${FakeAccounts.host}/api/v1/accounts'),
      headers: {
        'authorization': 'Bearer ${owner.tokens!.accessToken}',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'address': 'private@${FakeAccounts.host}',
        'password_hash': _serverHash,
      }),
    );
    expect(response.statusCode, 201);
    expect(response.body, isNot(contains(_serverHash)));
    expect(
      (jsonDecode(response.body) as Map)['data'],
      isNot(contains('password_hash')),
    );
  });

  test(
    'invalid, mismatched, excessive-work and combined credentials are refused without echoing the hash',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final owner = await admin(fake);
      for (final hash in [
        '{PLAIN}private-password',
        _serverHash.replaceFirst('SHA512', 'SHA256'),
        _serverHash.replaceFirst(r'$6$', r'$6$rounds=1000001$'),
        bcrypt.replaceFirst(r'$04$', r'$15$'),
        '$_serverHash\n',
      ]) {
        await expectLater(
          owner.createAccount(
            address: 'bad@${FakeAccounts.host}',
            passwordHash: hash,
          ),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'status', 422)
                .having(
                  (e) => e.fields.keys,
                  'fields',
                  contains('password_hash'),
                )
                .having(
                  (e) => e.toString(),
                  'safe error',
                  isNot(contains(hash)),
                ),
          ),
        );
      }
      await expectLater(
        owner.createAccount(
          address: 'both@${FakeAccounts.host}',
          password: 'chosen-password',
          passwordHash: _serverHash,
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields['password_hash'],
            'field',
            'send password or password_hash, not both',
          ),
        ),
      );
      expect(fake.hasMailbox('bad@${FakeAccounts.host}'), isFalse);
      expect(fake.hasMailbox('both@${FakeAccounts.host}'), isFalse);
    },
  );

  test(
    'imports require a live mailbox-write grant covering the target domain',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final user = client(fake);
      await user.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      fake.addGrant(
        FakeAccounts.email,
        'admin',
        scope: 'mailbox:${FakeAccounts.email}',
      );
      await expectLater(
        user.createAccount(
          address: 'scoped@${FakeAccounts.host}',
          passwordHash: _serverHash,
        ),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      fake.addGrant(
        FakeAccounts.email,
        'admin',
        scope: 'domain:${FakeAccounts.host}',
      );
      final account = await user.createAccount(
        address: 'scoped@${FakeAccounts.host}',
        passwordHash: _serverHash,
      );
      expect(account.address, 'scoped@${FakeAccounts.host}');
    },
  );
}
