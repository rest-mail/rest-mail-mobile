import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

void main() {
  late RestmailClient client;
  late http.Request sent;
  var status = 200;
  Object reply = {};
  const schedule = QuietHoursSetting(
    enabled: true,
    start: '22:00',
    end: '08:00',
    timeZone: 'Europe/Berlin',
  );
  setUp(() {
    status = 200;
    reply = {
      'data': {
        'enabled': true,
        'start': '22:00',
        'end': '08:00',
        'time_zone': 'Europe/Berlin',
      },
    };
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        sent = request;
        return http.Response(
          jsonEncode(reply),
          status,
          headers: {
            'content-type': 'application/json',
            ...contractSecurityHeaders,
          },
        );
      }),
    );
  });
  tearDown(() => client.close());

  test('generated GET reads the setting with the account session', () async {
    final value = await client.quietHours(3);
    expect(sent.method, 'GET');
    expect(sent.url.path, '/api/v1/accounts/3/quiet-hours');
    expect(sent.headers['authorization'], 'Bearer access');
    expect(value.enabled, isTrue);
    expect(value.start, '22:00');
    expect(value.end, '08:00');
    expect(value.timeZone, 'Europe/Berlin');
  });

  test(
    'generated PUT adapter preserves boolean and every field in both variants',
    () async {
      for (final enabled in [true, false]) {
        final draft = schedule.copyWith(enabled: enabled);
        reply = {
          'data': {
            'enabled': enabled,
            'start': '22:00',
            'end': '08:00',
            'time_zone': 'Europe/Berlin',
          },
        };
        final value = await client.setQuietHours(3, draft);
        expect(sent.method, 'PUT');
        expect(sent.url.path, '/api/v1/accounts/3/quiet-hours');
        expect(jsonDecode(sent.body), (reply as Map)['data']);
        expect(value.enabled, enabled);
        expect(value.timeZone, 'Europe/Berlin');
      }
    },
  );

  test(
    'server field errors and permission refusal remain unmodified',
    () async {
      for (final code in [422, 403, 500]) {
        status = code;
        reply = {
          'error': {
            'code': 'refused',
            'message': 'Original server message',
            'details': {
              'fields': {'time_zone': 'Original zone refusal'},
            },
          },
        };
        await expectLater(
          client.setQuietHours(3, schedule),
          throwsA(
            isA<ApiException>()
                .having((error) => error.statusCode, 'status', code)
                .having(
                  (error) => error.message,
                  'message',
                  'Original server message',
                )
                .having(
                  (error) => error.fields['time_zone'],
                  'field',
                  'Original zone refusal',
                ),
          ),
        );
        expect(client.tokens, isNotNull);
      }
    },
  );
}
