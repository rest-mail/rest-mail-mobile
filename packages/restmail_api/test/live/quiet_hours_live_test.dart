@TestOn('vm')
library;

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

void main() {
  test(
    'generated quiet hours load, enable, edit, refuse and disable on the real server',
    () async {
      final admin = await LiveAdmin.setUp();
      final client = admin.client;
      addTearDown(client.close);
      final account = (await client.accounts()).first.id;
      final before = await client.quietHours(account);
      addTearDown(() => client.setQuietHours(account, before));
      const setting = QuietHoursSetting(
        enabled: true,
        start: '22:00',
        end: '08:00',
        timeZone: 'Europe/Berlin',
      );
      expect(before.enabled, isFalse);
      expect((await client.setQuietHours(account, setting)).enabled, isTrue);
      expect((await client.quietHours(account)).start, '22:00');
      final edited = await client.setQuietHours(
        account,
        setting.copyWith(start: '23:30', timeZone: 'Asia/Kathmandu'),
      );
      expect(edited.timeZone, 'Asia/Kathmandu');
      for (final (invalid, field, message) in [
        (setting.copyWith(end: '22:00'), 'end', 'must differ from start'),
        (
          setting.copyWith(timeZone: 'Mars/Olympus'),
          'time_zone',
          'must be an IANA time zone name',
        ),
        (
          setting.copyWith(start: '9:00'),
          'start',
          r'must match ^$|^([01][0-9]|2[0-3]):[0-5][0-9]$',
        ),
      ]) {
        await expectLater(
          client.setQuietHours(account, invalid),
          throwsA(
            isA<ApiException>()
                .having((error) => error.statusCode, 'status', 422)
                .having((error) => error.fields[field], 'field', message),
          ),
        );
      }
      expect((await client.quietHours(account)).start, '23:30');
      expect(
        (await client.setQuietHours(
          account,
          edited.copyWith(enabled: false),
        )).enabled,
        isFalse,
      );
    },
    skip: skipLive,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
