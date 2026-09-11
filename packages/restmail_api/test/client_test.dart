import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

final _server = Uri.parse('https://mail.example.test');

const _user = {
  'id': 7,
  'email': 'ada@mail.example.test',
  'display_name': 'Ada',
};

const _loginBody = {
  'data': {'expires_in': 900, 'user': _user},
};

const _expired = {
  'error': {'code': 'unauthorized', 'message': 'Invalid or expired token'},
};

/// The Set-Cookie lines a login sets, folded into one value the way dart:io's
/// client hands them over — Expires dates and their commas included.
String _setCookie({required String access, required String refresh}) => [
  '$accessCookieName=$access; Path=/; Expires=Thu, 10 Sep 2026 22:15:00 GMT; HttpOnly; Secure; SameSite=Strict',
  '$refreshCookieName=$refresh; Path=/api/v1/auth; Expires=Thu, 17 Sep 2026 22:00:00 GMT; HttpOnly; Secure; SameSite=Strict',
  'restmail_csrf=csrf; Path=/; Secure; SameSite=Strict',
].join(', ');

/// JSON with no charset in its Content-Type, as the server sends it.
http.Response _json(
  Object body, {
  int status = 200,
  Map<String, String> headers = const {},
}) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {'content-type': 'application/json', ...headers},
);

http.Response _signedIn(String n) => _json(
  _loginBody,
  headers: {
    'set-cookie': _setCookie(access: 'access-$n', refresh: 'refresh-$n'),
  },
);

SessionTokens _tokens(
  String n, {
  Duration validFor = const Duration(minutes: 15),
}) => SessionTokens(
  accessToken: 'access-$n',
  refreshToken: 'refresh-$n',
  accessExpiresAt: DateTime.now().add(validFor),
);

bool _isRefresh(http.BaseRequest request) =>
    request.url.path.endsWith('/auth/refresh');

void main() {
  group('login', () {
    test('lifts both tokens out of Set-Cookie', () async {
      late http.Request sent;
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: _server,
        onTokensChanged: changes.add,
        httpClient: MockClient((request) async {
          sent = request;
          return _signedIn('1');
        }),
      );

      final result = await client.login(
        email: 'ada@mail.example.test',
        password: 'pw',
      );

      expect(
        sent.url.toString(),
        'https://mail.example.test/api/v1/auth/login',
      );
      expect(jsonDecode(sent.body), {
        'email': 'ada@mail.example.test',
        'password': 'pw',
      });
      expect(result.user.displayName, 'Ada');
      expect(result.tokens.accessToken, 'access-1');
      expect(result.tokens.refreshToken, 'refresh-1');
      expect(result.tokens.expiresWithin(const Duration(minutes: 14)), isFalse);
      expect(changes.single?.accessToken, 'access-1');
    });

    test('asks for a second factor when the account has one', () async {
      final client = RestmailClient(
        server: _server,
        httpClient: MockClient(
          (_) async => _json({
            'error': {
              'code': 'totp_required',
              'message': 'Two-factor authentication code required',
            },
          }, status: 401),
        ),
      );
      await expectLater(
        client.login(email: 'a@b.test', password: 'pw'),
        throwsA(isA<TotpRequiredException>()),
      );
      expect(client.tokens, isNull);
    });

    test('sends the second factor it is given', () async {
      late Map<String, dynamic> body;
      final client = RestmailClient(
        server: _server,
        httpClient: MockClient((request) async {
          body = jsonDecode(request.body) as Map<String, dynamic>;
          return _signedIn('1');
        }),
      );
      await client.login(email: 'a@b.test', password: 'pw', totpCode: '123456');
      expect(body['totp_code'], '123456');
      expect(body.containsKey('recovery_code'), isFalse);
    });
  });

  group('session renewal', () {
    test('refreshes once on 401 and retries with the new token', () async {
      final seen = <String>[];
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        onTokensChanged: changes.add,
        httpClient: MockClient((request) async {
          final credential =
              request.headers['Authorization'] ?? request.headers['Cookie'];
          seen.add('${request.method} ${request.url.path} $credential');
          if (_isRefresh(request)) return _signedIn('2');
          if (request.headers['Authorization'] == 'Bearer access-1') {
            return _json(_expired, status: 401);
          }
          return _json({
            'data': [
              {
                'id': 1,
                'mailbox_id': 1,
                'address': 'ada@mail.example.test',
                'display_name': 'Ada',
                'is_primary': true,
              },
            ],
          });
        }),
      );

      final accounts = await client.accounts();

      expect(accounts.single.address, 'ada@mail.example.test');
      expect(seen, [
        'GET /api/v1/accounts Bearer access-1',
        'POST /api/v1/auth/refresh restmail_refresh=refresh-1',
        'GET /api/v1/accounts Bearer access-2',
      ]);
      expect(changes.single?.refreshToken, 'refresh-2');
    });

    test('concurrent requests share one refresh', () async {
      var refreshes = 0;
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          if (_isRefresh(request)) {
            refreshes++;
            return _signedIn('2');
          }
          if (request.headers['Authorization'] == 'Bearer access-1') {
            return _json(_expired, status: 401);
          }
          return _json({'data': <Object>[]});
        }),
      );

      await Future.wait([
        client.folders(1),
        client.folders(2),
        client.accounts(),
      ]);

      expect(refreshes, 1);
    });

    test('a token about to expire is renewed before it is sent', () async {
      final paths = <String>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1', validFor: const Duration(seconds: 5)),
        httpClient: MockClient((request) async {
          paths.add(request.url.path);
          return _isRefresh(request)
              ? _signedIn('2')
              : _json({'data': <Object>[]});
        }),
      );

      await client.accounts();

      expect(paths, ['/api/v1/auth/refresh', '/api/v1/accounts']);
    });

    test('a refused refresh ends the session', () async {
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        onTokensChanged: changes.add,
        httpClient: MockClient((_) async => _json(_expired, status: 401)),
      );

      await expectLater(
        client.accounts(),
        throwsA(isA<SessionExpiredException>()),
      );

      expect(client.tokens, isNull);
      expect(changes, [null]);
    });

    test('an unreachable server does not end the session', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1', validFor: Duration.zero),
        httpClient: MockClient(
          (_) async => throw http.ClientException('Connection refused'),
        ),
      );

      await expectLater(
        client.accounts(),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'network_error'),
        ),
      );

      expect(client.tokens, isNotNull);
    });
  });

  group('requests', () {
    test('a folder name is one path segment, slashes and all', () async {
      late Uri url;
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          url = request.url;
          return _json({
            'data': <Object>[],
            'pagination': {'has_more': false},
          });
        }),
      );

      await client.messages(3, 'Archive/2024', cursor: 'abc');

      expect(url.path, '/api/v1/accounts/3/folders/Archive%2F2024/messages');
      expect(url.queryParameters, {'limit': '50', 'cursor': 'abc'});
    });

    test('keeps a server path prefix', () async {
      late Uri url;
      final client = RestmailClient(
        server: Uri.parse('https://example.test/mail'),
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          url = request.url;
          return _json({'data': <Object>[]});
        }),
      );

      await client.accounts();

      expect(url.path, '/mail/api/v1/accounts');
    });

    test('reads a validation error envelope', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient(
          (_) async => _json({
            'error': {
              'code': 'validation_failed',
              'message': 'Request body failed validation',
              'details': {
                'fields': {'to': 'required'},
              },
            },
          }, status: 422),
        ),
      );

      await expectLater(
        client.send(const OutgoingMessage(from: 'ada@mail.example.test')),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'validation_failed')
              .having((e) => e.fields, 'fields', {'to': 'required'}),
        ),
      );
    });

    test('decodes UTF-8 though the Content-Type names no charset', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient(
          (_) async => _json({
            'data': {
              'id': 1,
              'mailbox_id': 1,
              'folder': 'INBOX',
              'sender': 'bob@example.test',
              'subject': 'Grüße ☃',
              'received_at': '2026-09-10T20:00:00Z',
            },
          }),
        ),
      );

      expect((await client.message(1)).subject, 'Grüße ☃');
    });

    test("reads Go's null for an empty list as an empty list", () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((_) async => _json({'data': null})),
      );

      expect(await client.folders(1), isEmpty);
    });
  });

  group('events', () {
    test('delivers events and resumes from the last id after a drop', () async {
      final lastEventIds = <String?>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient.streaming((request, _) async {
          lastEventIds.add(request.headers['Last-Event-ID']);
          final body = lastEventIds.length == 1
              ? 'id: 7\nevent: new_message\ndata: {"message_id": 42, "folder": "INBOX"}\n\n'
              : ': keepalive\n\nid: 8\nevent: message_deleted\ndata: {"message_id": 41}\n\n';
          return http.StreamedResponse(Stream.value(utf8.encode(body)), 200);
        }),
      );

      final live = <bool>[];
      final events = await client
          .events(3, retryDelay: Duration.zero, onLiveChanged: live.add)
          .take(2)
          .toList();

      expect(events.map((e) => (e.type, e.messageId)), [
        (MailEventType.newMessage, 42),
        (MailEventType.messageDeleted, 41),
      ]);
      expect(lastEventIds.take(2), [null, '7']);
      // Up, down when the first connection closed, up again.
      expect(live.take(3), [true, false, true]);
    });

    test('ends with an error once the session cannot be renewed', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient.streaming((request, _) async {
          final body = _isRefresh(request)
              ? utf8.encode(jsonEncode(_expired))
              : <int>[];
          return http.StreamedResponse(Stream.value(body), 401);
        }),
      );

      await expectLater(
        client.events(3, retryDelay: Duration.zero),
        emitsError(isA<SessionExpiredException>()),
      );
      expect(client.tokens, isNull);
    });
  });
}
