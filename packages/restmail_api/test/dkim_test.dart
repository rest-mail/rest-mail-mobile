import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

final _tokens = SessionTokens(
  accessToken: 'access',
  refreshToken: 'refresh',
  accessExpiresAt: DateTime.utc(2099),
);
RestmailClient _client(Future<http.Response> Function(http.Request) send) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: _tokens,
      httpClient: MockClient(send),
    );
http.Response _json(Object? body) =>
    http.Response(jsonEncode({'data': body}), 200);

void main() {
  test('key install preserves exact PEM bytes, metadata and fractional age', () async {
    const pem =
        '-----BEGIN PRIVATE KEY-----\r\npublic-test-fixture\r\n-----END PRIVATE KEY-----\r\n';
    final client = _client((r) async {
      expect(r.method, 'PUT');
      expect(r.url.path, '/api/v1/admin/dkim/42');
      expect(jsonDecode(r.body), {'selector': 'mail2026', 'private_key': pem});
      return _json({
        'domain_id': 42,
        'domain': 'example.test',
        'selector': 'mail2026',
        'has_key': true,
        'created_at': '2026-10-23T06:00:00Z',
        'age_seconds': 25.125,
      });
    });
    addTearDown(client.close);
    final key = await client.setDkimKey(
      42,
      selector: 'mail2026',
      privateKey: pem,
    );
    expect(key.createdAt!.toUtc(), DateTime.utc(2026, 10, 23, 6));
    expect(key.ageSeconds, 25.125);
  });

  test('legacy age and empty monitoring list are parsed', () async {
    var calls = 0;
    final client = _client(
      (r) async => ++calls == 1
          ? _json([
              {
                'domain_id': 42,
                'domain': 'example.test',
                'selector': 'legacy',
                'has_key': true,
                'created_at': null,
                'age_seconds': null,
              },
            ])
          : _json([]),
    );
    addTearDown(client.close);
    expect((await client.dkimKeys()).single.createdAt, isNull);
    expect(await client.dkimKeys(), isEmpty);
  });

  for (final op in ['list', 'install', 'rotation', 'saveRotation', 'delete']) {
    test('$op 403 does not refresh or discard session', () async {
      var calls = 0;
      final client = _client((r) async {
        calls++;
        expect(r.url.path, isNot(contains('/auth/refresh')));
        return http.Response(
          '{"error":{"code":"forbidden","message":"No permission"}}',
          403,
        );
      });
      addTearDown(client.close);
      final Future<Object?> request = switch (op) {
        'list' => client.dkimKeys(),
        'install' => client.setDkimKey(
          42,
          selector: 'mail',
          privateKey: 'test',
        ),
        'rotation' => client.dkimRotation(42),
        'saveRotation' => client.setDkimRotation(42, 90),
        _ => client.deleteDkimKey(42),
      };
      await expectLater(
        request,
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(calls, 1);
      expect(client.tokens, same(_tokens));
    });
  }

  for (final field in ['selector', 'private_key', 'rotation_interval_days']) {
    test('$field validation reaches form without ending session', () async {
      final client = _client(
        (r) async => http.Response(
          jsonEncode({
            'error': {
              'code': 'validation_failed',
              'message': 'Invalid value',
              'details': {
                'fields': {field: 'refused'},
              },
            },
          }),
          422,
        ),
      );
      addTearDown(client.close);
      final request = field == 'rotation_interval_days'
          ? client.setDkimRotation(42, -1)
          : client.setDkimKey(42, selector: 'bad', privateKey: 'bad');
      await expectLater(
        request,
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields[field],
            'field',
            'refused',
          ),
        ),
      );
      expect(client.tokens, same(_tokens));
    });
  }
}
