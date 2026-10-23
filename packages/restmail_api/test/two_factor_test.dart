import 'dart:async';
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
http.Response _data(Object value) =>
    http.Response(jsonEncode({'data': value}), 200);
http.Response _login() => _data({
  'user': {'id': 2, 'email': 'other@example.test'},
  'access_token': 'new-access',
  'refresh_token': 'new-refresh',
  'expires_in': 900,
});

RestmailClient _client(
  Future<http.Response> Function(http.Request) send, {
  SessionTokens? tokens,
  TokensChanged? changed,
}) => RestmailClient(
  server: Uri.parse('https://mail.example.test'),
  tokens: tokens ?? _tokens,
  httpClient: MockClient(send),
  onTokensChanged: changed,
);

void main() {
  for (final payload in [
    <String, Object?>{},
    {'enabled': 'yes', 'pending': false},
    {'enabled': true, 'pending': true},
  ]) {
    test(
      'unreadable status is an API error, never reported as 2FA off: $payload',
      () async {
        final client = _client((_) async => _data(payload));
        addTearDown(client.close);
        await expectLater(
          client.twoFactorStatus(),
          throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
          ),
        );
        expect(client.tokens, same(_tokens));
      },
    );
  }

  for (final payload in [
    <String, Object?>{},
    {
      'secret': 'test',
      'otpauth_url': 'https://example.test',
      'recovery_codes': ['one'],
    },
  ]) {
    test('unreadable enrollment stays an API refusal', () async {
      final client = _client((_) async => _data(payload));
      addTearDown(client.close);
      await expectLater(
        client.enrollTwoFactor(),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
        ),
      );
      expect(client.tokens, same(_tokens));
    });
  }

  for (final disable in [false, true]) {
    test(
      'unexpected ${disable ? 'disable' : 'confirm'} response does not end session',
      () async {
        final client = _client((_) async => _data({'unrecognized': true}));
        addTearDown(client.close);
        final request = disable
            ? client.disableTwoFactor(totpCode: '123456')
            : client.confirmTwoFactor('123456');
        await expectLater(
          request,
          throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
          ),
        );
        expect(client.tokens, same(_tokens));
      },
    );
  }

  for (final (enabled, pending) in [
    (false, false),
    (false, true),
    (true, false),
  ]) {
    test(
      'status parses enabled=$enabled pending=$pending without a request body',
      () async {
        final client = _client((r) async {
          expect(r.method, 'GET');
          expect(r.url.path, '/api/v1/auth/2fa');
          expect(r.body, isEmpty);
          expect(r.headers['authorization'], 'Bearer access');
          return _data({'enabled': enabled, 'pending': pending});
        });
        addTearDown(client.close);
        final status = await client.twoFactorStatus();
        expect(status.enabled, enabled);
        expect(status.pending, pending);
      },
    );
  }

  test(
    'enrollment parses all secrets and provisioning URI; confirmation is 204',
    () async {
      var calls = 0;
      final client = _client((r) async {
        expect(r.method, 'POST');
        calls++;
        if (calls == 1) {
          expect(r.url.path, '/api/v1/auth/2fa/enroll');
          return _data({
            'secret': 'PUBLIC_TEST_SECRET',
            'otpauth_url': 'otpauth://totp/example?secret=PUBLIC_TEST_SECRET',
            'recovery_codes': ['one', 'two'],
          });
        }
        expect(r.url.path, '/api/v1/auth/2fa/confirm');
        expect(jsonDecode(r.body), {'totp_code': '123456'});
        return http.Response('', 204);
      });
      addTearDown(client.close);
      final enrollment = await client.enrollTwoFactor();
      expect(enrollment.secret, 'PUBLIC_TEST_SECRET');
      expect(enrollment.otpauthUri.scheme, 'otpauth');
      expect(enrollment.recoveryCodes, ['one', 'two']);
      await client.confirmTwoFactor('123456');
      expect(client.tokens, same(_tokens));
    },
  );

  for (final recovery in [false, true]) {
    test(
      'disable with ${recovery ? 'recovery' : 'TOTP'} sends exact proof then ends session once',
      () async {
        final changes = <SessionTokens?>[];
        final client = _client((r) async {
          expect(r.method, 'POST');
          expect(r.url.path, '/api/v1/auth/2fa/disable');
          expect(
            jsonDecode(r.body),
            recovery
                ? {'recovery_code': 'unused-code'}
                : {'totp_code': '123456'},
          );
          return http.Response('', 204);
        }, changed: changes.add);
        addTearDown(client.close);
        await client.disableTwoFactor(
          totpCode: recovery ? null : '123456',
          recoveryCode: recovery ? 'unused-code' : null,
        );
        expect(client.tokens, isNull);
        expect(changes, [null]);
      },
    );
  }

  for (final (status, code) in [
    (403, 'invalid_totp'),
    (403, 'invalid_recovery_code'),
    (403, 'two_factor_required'),
    (400, 'bad_request'),
    (422, 'validation_failed'),
    (429, 'rate_limited'),
  ]) {
    test('$status $code retains session and never refreshes', () async {
      var calls = 0;
      final changes = <SessionTokens?>[];
      final client = _client((r) async {
        calls++;
        expect(r.url.path, '/api/v1/auth/2fa/disable');
        expect(jsonDecode(r.body), {
          'totp_code': 'bad',
          'recovery_code': 'also-bad',
        });
        return http.Response(
          jsonEncode({
            'error': {'code': code, 'message': 'Refused'},
          }),
          status,
          headers: {'retry-after': '3'},
        );
      }, changed: changes.add);
      addTearDown(client.close);
      await expectLater(
        client.disableTwoFactor(totpCode: 'bad', recoveryCode: 'also-bad'),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', code)),
      );
      expect(calls, 1);
      expect(changes, isEmpty);
      expect(client.tokens, same(_tokens));
    });
  }

  test('empty proof is an object and server field errors are retained', () async {
    final client = _client((r) async {
      expect(jsonDecode(r.body), <String, Object?>{});
      return http.Response(
        '{"error":{"code":"validation_failed","message":"Required","details":{"fields":{"totp_code":"required unless recovery_code is sent"}}}}',
        422,
      );
    });
    addTearDown(client.close);
    await expectLater(
      client.disableTwoFactor(totpCode: '', recoveryCode: ''),
      throwsA(
        isA<ApiException>().having(
          (e) => e.fields['totp_code'],
          'field',
          'required unless recovery_code is sent',
        ),
      ),
    );
  });

  test(
    'disable clears the rotated pair after a normal preflight refresh',
    () async {
      final changes = <SessionTokens?>[];
      var calls = 0;
      final client = _client(
        (r) async {
          calls++;
          if (r.url.path.endsWith('/refresh')) {
            return _data({
              'access_token': 'rotated',
              'refresh_token': 'rotated-refresh',
              'expires_in': 900,
            });
          }
          expect(r.headers['authorization'], 'Bearer rotated');
          return http.Response('', 204);
        },
        tokens: SessionTokens(
          accessToken: 'old',
          refreshToken: 'old-refresh',
          accessExpiresAt: DateTime.now(),
        ),
        changed: changes.add,
      );
      addTearDown(client.close);
      await client.disableTwoFactor(totpCode: '123456');
      expect(calls, 2);
      expect(changes, hasLength(2));
      expect(changes.first!.accessToken, 'rotated');
      expect(changes.last, isNull);
    },
  );

  for (final passwordChange in [false, true]) {
    test(
      'late ${passwordChange ? 'password change' : 'disable'} success cannot end a replacement login',
      () async {
        final response = Completer<http.Response>(),
            started = Completer<void>();
        final changes = <SessionTokens?>[];
        final client = _client((r) async {
          if (r.url.path.endsWith('/login')) return _login();
          started.complete();
          return response.future;
        }, changed: changes.add);
        addTearDown(client.close);
        final pending = passwordChange
            ? client.changePassword(current: 'old', next: 'a-new-password')
            : client.disableTwoFactor(totpCode: '123456');
        await started.future;
        await client.login(
          email: 'other@example.test',
          password: 'another-password',
        );
        final replacement = client.tokens;
        response.complete(http.Response('', 204));
        await pending;
        expect(client.tokens, same(replacement));
        expect(changes, [replacement]);
      },
    );
  }

  test(
    'a late success after logout does not emit a second session end',
    () async {
      final response = Completer<http.Response>(), started = Completer<void>();
      final changes = <SessionTokens?>[];
      final client = _client((r) async {
        if (r.url.path.endsWith('/logout')) return http.Response('', 204);
        started.complete();
        return response.future;
      }, changed: changes.add);
      addTearDown(client.close);
      final pending = client.disableTwoFactor(totpCode: '123456');
      await started.future;
      await client.logout();
      response.complete(http.Response('', 204));
      await pending;
      expect(changes, [null]);
      expect(client.tokens, isNull);
    },
  );
}
