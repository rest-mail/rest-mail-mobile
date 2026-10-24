@TestOn('vm')
library;

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

const _hash =
    r'{SHA512-CRYPT}$6$importsalt$ObInO4qcr134i8FQT.XNC6Ma04n9aRTAUNHmm8Yb1idoDBOXKoDTmdosY1xwfageGXo4ZSSrkIPRk9zMWfsG7/';

void main() {
  test(
    'live account import keeps the old password and server refusals',
    () async {
      final admin = await LiveAdmin.setUp();
      addTearDown(admin.client.close);
      final domain = await admin.client.createDomain(
        'password-import.live.test',
      );
      addTearDown(() => admin.client.deleteDomain(domain.id));
      final account = await admin.client.createAccount(
        address: 'kept@${domain.name}',
        passwordHash: _hash,
      );
      addTearDown(() => admin.client.deleteMailbox(account.id));
      final imported = RestmailClient(server: liveServer);
      addTearDown(imported.close);
      await imported.login(email: account.address, password: 'old-password');
      expect((await imported.accounts()).first.id, account.id);
      await expectLater(
        imported.createAccount(
          address: 'forbidden@${domain.name}',
          passwordHash: _hash,
        ),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      for (final password in [null, 'chosen-password']) {
        await expectLater(
          admin.client.createAccount(
            address: 'invalid@${domain.name}',
            password: password,
            passwordHash: password == null ? '{PLAIN}private-password' : _hash,
          ),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'status', 422)
                .having(
                  (e) => e.fields.keys,
                  'fields',
                  contains('password_hash'),
                ),
          ),
        );
      }
    },
    skip: skipLive,
  );
}
