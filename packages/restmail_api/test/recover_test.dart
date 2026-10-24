import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

http.Response _json(
  Object body, [
  int status = 200,
  Map<String, String>? headers,
]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {'content-type': 'application/json', ...?headers},
);

void main() {
  late http.Request sent;
  late http.Response reply;
  late RestmailClient client;
  setUp(() {
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      httpClient: MockClient((request) async {
        sent = request;
        return reply;
      }),
    );
  });
  tearDown(() => client.close());

  Future<LoginResult> recover() => client.recoverAccount(
    email: 'ada@example.test',
    totpCode: '123456',
    recoveryCode: 'RECOVER-1234',
    newPassword: 'a brand new passphrase',
  );

  test(
    'sends both codes and the new password, and keeps the new session',
    () async {
      reply = _json({
        'data': {
          'expires_in': 900,
          'user': {'id': 4, 'email': 'ada@example.test', 'display_name': 'Ada'},
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
          'refresh_expires_in': 604800,
        },
      });
      final result = await recover();
      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/auth/recover');
      expect(sent.headers['authorization'], isNull);
      expect(jsonDecode(sent.body), {
        'email': 'ada@example.test',
        'totp_code': '123456',
        'recovery_code': 'RECOVER-1234',
        'new_password': 'a brand new passphrase',
        'client': 'native',
      });
      expect(result.user.email, 'ada@example.test');
      expect(result.isSetUp, isTrue);
      expect(client.tokens!.accessToken, 'access-1');
      expect(client.tokens!.refreshToken, 'refresh-1');
    },
  );

  test('a refusal, and a held-off address, are ApiExceptions', () async {
    reply = _json({
      'error': {
        'code': 'recovery_failed',
        'message': 'Invalid address, authenticator code or recovery code',
      },
    }, 401);
    await expectLater(
      recover(),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 401)
            .having((e) => e.code, 'code', 'recovery_failed'),
      ),
    );
    expect(client.tokens, isNull);

    reply = _json(
      {
        'error': {
          'code': 'rate_limited',
          'message':
              'Too many failed recoveries for this address; try again later',
        },
      },
      429,
      {'retry-after': '900'},
    );
    await expectLater(
      recover(),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 429)
            .having(
              (e) => e.retryAfter,
              'retryAfter',
              const Duration(seconds: 900),
            ),
      ),
    );
  });
}
