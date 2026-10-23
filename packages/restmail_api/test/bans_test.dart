import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

const _ban = {
  'id': 12,
  'ip': '2001:db8::1',
  'protocol': 'imap',
  'reason': 'Repeated failures',
  'created_by': 'admin@example.com',
  'created_at': '2026-10-01T00:00:00Z',
  'expires_at': '2026-10-02T00:00:00Z',
};

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object reply;
  late int status;
  late int calls;
  setUp(() {
    reply = {'data': _ban};
    status = 201;
    calls = 0;
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        calls++;
        sent = request;
        return http.Response.bytes(
          utf8.encode(status == 204 ? '' : jsonEncode(reply)),
          status,
          headers: {
            'content-type': 'application/json',
            if (status == 429) 'retry-after': '15',
          },
        );
      }),
    );
  });
  tearDown(() => client.close());

  test('list sends all filters and parses all fields and pagination', () async {
    reply = {
      'data': [_ban],
      'pagination': {'total': 10, 'has_more': true},
    };
    status = 200;
    final page = await client.bans(
      ip: '2001:db8::1',
      protocol: 'imap',
      active: false,
      offset: 2,
      limit: 3,
    );
    expect(sent.method, 'GET');
    expect(sent.url.path, '/api/v1/admin/bans');
    expect(sent.url.queryParameters, {
      'ip': '2001:db8::1',
      'protocol': 'imap',
      'active': 'false',
      'offset': '2',
      'limit': '3',
    });
    expect(page.total, 10);
    expect(page.hasMore, isTrue);
    final ban = page.items.single;
    expect(ban.id, 12);
    expect(ban.ip, '2001:db8::1');
    expect(ban.protocol, 'imap');
    expect(ban.reason, 'Repeated failures');
    expect(ban.createdBy, 'admin@example.com');
    expect(ban.createdAt.toUtc(), DateTime.utc(2026, 10));
    expect(ban.expiresAt!.toUtc(), DateTime.utc(2026, 10, 2));
  });
  test('omitted filters remain omitted and active true is explicit', () async {
    reply = {
      'data': <Object?>[],
      'pagination': {'total': 0},
    };
    status = 200;
    await client.bans();
    expect(sent.url.queryParameters, {'offset': '0', 'limit': '100'});
    await client.bans(active: true);
    expect(sent.url.queryParameters['active'], 'true');
  });
  for (final statusCode in [200, 201]) {
    test(
      'create parses $statusCode response with all request fields',
      () async {
        status = statusCode;
        final ban = await client.createBan(
          ip: '2001:db8::1',
          protocol: 'imap',
          reason: 'Repeated failures',
          createdBy: 'admin@example.com',
          durationText: '1h30m0.5s',
        );
        expect(sent.method, 'POST');
        expect(sent.url.path, '/api/v1/admin/bans');
        expect(jsonDecode(sent.body), {
          'ip': '2001:db8::1',
          'protocol': 'imap',
          'reason': 'Repeated failures',
          'created_by': 'admin@example.com',
          'duration': '1h30m0.5s',
        });
        expect(ban.id, 12);
        expect(ban.protocol, 'imap');
      },
    );
  }
  test('permanent ban omits duration and parses missing expiry', () async {
    reply = {
      'data': {..._ban}..remove('expires_at'),
    };
    final ban = await client.createBan(
      ip: '2001:db8::1',
      createdBy: 'admin@example.com',
    );
    expect(jsonDecode(sent.body), {
      'ip': '2001:db8::1',
      'created_by': 'admin@example.com',
      'reason': '',
      'protocol': 'all',
    });
    expect(ban.expiresAt, isNull);
  });
  test(
    'typed duration retains seconds and microseconds rather than truncating to minutes',
    () async {
      await client.createBan(
        ip: '192.0.2.1',
        createdBy: 'admin',
        duration: const Duration(seconds: 30, microseconds: 12),
      );
      expect(
        (jsonDecode(sent.body) as Map<String, dynamic>)['duration'],
        '30000012us',
      );
      await client.createBan(
        ip: '192.0.2.1',
        createdBy: 'admin',
        duration: const Duration(hours: 1),
      );
      expect(
        (jsonDecode(sent.body) as Map<String, dynamic>)['duration'],
        '60m',
      );
    },
  );
  test('ambiguous durations are refused before sending', () async {
    await expectLater(
      client.createBan(
        ip: '192.0.2.1',
        createdBy: 'admin',
        duration: const Duration(hours: 1),
        durationText: '1h',
      ),
      throwsArgumentError,
    );
    expect(calls, 0);
  });
  for (final ip in ['192.0.2.1', '2001:db8::1']) {
    test(
      'unban $ip uses one complete path segment and empty 204 response',
      () async {
        status = 204;
        await client.unbanIP(ip);
        expect(sent.method, 'DELETE');
        expect(sent.url.pathSegments, ['api', 'v1', 'admin', 'bans', 'ip', ip]);
        expect(sent.body, isEmpty);
        expect(sent.url.query, isEmpty);
      },
    );
  }
  for (final code in [400, 403, 404, 422, 429, 500]) {
    test('unban $code refusal retains session and server details', () async {
      status = code;
      reply = {
        'error': {'code': 'example', 'message': 'No ban found for this IP'},
      };
      await expectLater(
        client.unbanIP('192.0.2.1'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', code)
              .having((e) => e.message, 'message', 'No ban found for this IP')
              .having(
                (e) => e.retryAfter,
                'retry',
                code == 429 ? const Duration(seconds: 15) : null,
              ),
        ),
      );
      expect(calls, 1);
      expect(client.tokens!.accessToken, 'access');
    });
  }
}
