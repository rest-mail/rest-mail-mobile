import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

http.Response _json(
  Object body, [
  int status = 200,
  Map<String, String>? headers,
]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {
    'content-type': 'application/json',
    ...contractSecurityHeaders,
    ...?headers,
  },
);

void main() {
  late http.Request sent;
  late http.Response reply;
  late RestmailClient client;
  setUp(() {
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        sent = request;
        return reply;
      }),
    );
  });
  tearDown(() => client.close());

  group('recoveryEmail', () {
    for (final (email, verified, stage) in [
      ('', false, RecoveryEmailStage.none),
      ('backup@external.test', false, RecoveryEmailStage.pending),
      ('backup@external.test', true, RecoveryEmailStage.verified),
    ]) {
      test('reads $stage', () async {
        reply = _json({
          'data': {'email': email, 'verified': verified},
        });
        final status = await client.recoveryEmail();
        expect(sent.method, 'GET');
        expect(sent.url.path, '/api/v1/auth/recovery-email');
        expect(status.email, email);
        expect(status.stage, stage);
      });
    }
  });

  group('registerRecoveryEmail', () {
    Future<void> register() => client.registerRecoveryEmail(
      email: 'backup@external.test',
      currentPassword: 'original password chosen',
    );

    test('sends the address and the current password', () async {
      reply = _json({
        'data': {
          'message':
              'Verification link sent. The address cannot recover your '
              'account until verified.',
        },
      });
      await register();
      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/auth/recovery-email');
      expect(jsonDecode(sent.body), {
        'email': 'backup@external.test',
        'current_password': 'original password chosen',
      });
    });

    test('keeps the server\'s refusals', () async {
      for (final (status, code, message, fields, headers) in [
        (
          403,
          'invalid_password',
          'Current password is incorrect',
          const <String, String>{},
          const <String, String>{},
        ),
        (
          403,
          'recovery_method_frozen',
          'recovery address changes are frozen for three days after email '
              'recovery',
          const <String, String>{},
          const <String, String>{},
        ),
        (
          422,
          'validation_failed',
          'Request body failed validation',
          const {'email': "must be outside this server's hosted domains"},
          const <String, String>{},
        ),
        (
          429,
          'rate_limited',
          'Too many requests; please slow down',
          const <String, String>{},
          const {'retry-after': '120'},
        ),
        (
          503,
          'unavailable',
          'Email recovery requires an HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL',
          const <String, String>{},
          const <String, String>{},
        ),
      ]) {
        reply = _json(
          {
            'error': {
              'code': code,
              'message': message,
              if (fields.isNotEmpty) 'details': {'fields': fields},
            },
          },
          status,
          headers,
        );
        await expectLater(
          register(),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'status', status)
                .having((e) => e.code, 'code', code)
                .having((e) => e.fields, 'fields', fields)
                .having(
                  (e) => e.retryAfter,
                  'retryAfter',
                  headers.isEmpty ? isNull : const Duration(seconds: 120),
                ),
          ),
        );
      }
    });
  });

  group('requestRecoveryEmail', () {
    test('sends the account address, with no session', () async {
      reply = _json({
        'data': {
          'message':
              'If this account has a verified recovery email, a recovery '
              'link will be sent.',
        },
      });
      await client.requestRecoveryEmail('person@example.test');
      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/auth/recover/email');
      // Public: this client holds a session, and it stays out of the request.
      expect(sent.headers['authorization'], isNull);
      expect(jsonDecode(sent.body), {'email': 'person@example.test'});
    });

    test('keeps the hold-off', () async {
      reply = _json(
        {
          'error': {
            'code': 'rate_limited',
            'message':
                'Too many recovery requests for this address; try again later',
          },
        },
        429,
        {'retry-after': '900'},
      );
      await expectLater(
        client.requestRecoveryEmail('person@example.test'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.retryAfter,
            'retryAfter',
            const Duration(minutes: 15),
          ),
        ),
      );
    });
  });
}
