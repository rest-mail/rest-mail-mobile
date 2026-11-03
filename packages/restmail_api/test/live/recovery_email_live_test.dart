@TestOn('vm')
library;

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

/// The live fixture has no RESTMAIL_RECOVERY_EMAIL_BASE_URL, so the server can
/// report a recovery email but cannot send a link: both of those answers have
/// to reach the client as they are.
void main() {
  test('recovery email reads none, refuses a bad address at its field and says '
      'when it cannot send a link, on the real server', () async {
    final admin = await LiveAdmin.setUp();
    final client = admin.client;
    addTearDown(client.close);

    final status = await client.recoveryEmail();
    expect(status.stage, RecoveryEmailStage.none);

    await expectLater(
      client.registerRecoveryEmail(
        email: 'not an address',
        currentPassword: livePassword,
      ),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'status', 422).having(
          (e) => e.fields,
          'fields',
          {'email': 'must be a valid email'},
        ),
      ),
    );
    await expectLater(
      client.registerRecoveryEmail(
        email: 'backup@external.test',
        currentPassword: livePassword,
      ),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 503)
            .having((e) => e.code, 'code', 'unavailable'),
      ),
    );

    final anonymous = RestmailClient(server: liveServer);
    addTearDown(anonymous.close);
    for (final address in [liveEmail, 'nobody@live.test']) {
      await expectLater(
        anonymous.requestRecoveryEmail(address),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 503)
              .having((e) => e.code, 'code', 'unavailable'),
        ),
      );
    }
  }, skip: skipLive);
}
