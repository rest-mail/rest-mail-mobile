import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

http.Response _json(
  Object body, [
  int status = 200,
  Map<String, String> headers = const {},
]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {
    'content-type': 'application/json',
    ...contractSecurityHeaders,
    ...headers,
  },
);

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

void main() {
  late http.Request sent;
  late http.Response reply;

  RestmailClient client({bool signedIn = false}) {
    final made = RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: signedIn
          ? SessionTokens(
              accessToken: 'access',
              refreshToken: 'refresh',
              accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
            )
          : null,
      httpClient: MockClient((request) async {
        sent = request;
        return reply;
      }),
    );
    addTearDown(made.close);
    return made;
  }

  group('acceptInvitation', () {
    test(
      'sends the code and the new password, and keeps the session',
      () async {
        final invited = client();
        reply = _json({
          'data': {
            'expires_in': 900,
            'user': {'id': 9, 'email': 'ada@example.test', 'display_name': ''},
            'access_token': 'access-1',
            'refresh_token': 'refresh-1',
            'refresh_expires_in': 604800,
            'setup_required': ['two_factor'],
          },
        });
        final result = await invited.acceptInvitation(
          token: 'invite-secret',
          password: 'a brand new passphrase',
        );
        expect(sent.method, 'POST');
        expect(sent.url.path, '/api/v1/auth/invitation');
        expect(sent.headers['authorization'], isNull);
        expect(jsonDecode(sent.body), {
          'token': 'invite-secret',
          'password': 'a brand new passphrase',
          'client': 'native',
        });
        expect(result.user.email, 'ada@example.test');
        expect(result.isSetUp, isFalse);
        expect(invited.tokens!.accessToken, 'access-1');
      },
    );

    test('a spent or unknown code is 401 invalid_token', () async {
      final invited = client();
      reply = _json({
        'error': {
          'code': 'invalid_token',
          'message': 'Invalid or expired token',
        },
      }, 401);
      await expectLater(
        invited.acceptInvitation(
          token: 'old',
          password: 'a brand new passphrase',
        ),
        _refused(401, 'invalid_token'),
      );
      expect(invited.tokens, isNull);
    });
  });

  group('inviteAccount', () {
    test('posts to the mailbox and reads the code and its expiry', () async {
      final admin = client(signedIn: true);
      reply = _json(
        {
          'data': {
            'token': 'invite-secret',
            'expires_at': '2026-11-11T15:30:00Z',
          },
        },
        201,
        {'cache-control': 'no-store'},
      );
      final invitation = await admin.inviteAccount(9);
      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/admin/mailboxes/9/invitation');
      expect(sent.headers['Authorization'], 'Bearer access');
      expect(invitation.token, 'invite-secret');
      expect(invitation.expiresAt.toUtc(), DateTime.utc(2026, 11, 11, 15, 30));
      expect(invitation.expiresAt.isUtc, isFalse);
      expect(invitation.toString(), isNot(contains('invite-secret')));
    });

    test('an account that has had credentials is 409, not a reset', () async {
      final admin = client(signedIn: true);
      reply = _json({
        'error': {
          'code': 'account_not_invitable',
          'message': 'only an active account that has never held credentials can be invited',
        },
      }, 409);
      await expectLater(
        admin.inviteAccount(9),
        _refused(409, 'account_not_invitable'),
      );
    });
  });
}
