import 'dart:async';
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

const _expired = {
  'error': {'code': 'unauthorized', 'message': 'Invalid or expired token'},
};

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

/// What a native sign-in or refresh answers: the pair in the body.
http.Response _signedIn(String n) => _json({
  'data': {
    'expires_in': 900,
    'user': _user,
    'access_token': 'access-$n',
    'refresh_token': 'refresh-$n',
    'refresh_expires_in': 604800,
  },
});

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
    test(
      'signs in as a native client and reads the pair from the body',
      () async {
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
          'client': 'native',
        });
        expect(sent.headers.containsKey('Cookie'), isFalse);
        expect(result.user.displayName, 'Ada');
        expect(result.tokens.accessToken, 'access-1');
        expect(result.tokens.refreshToken, 'refresh-1');
        expect(
          result.tokens.expiresWithin(const Duration(minutes: 14)),
          isFalse,
        );
        expect(changes.single?.accessToken, 'access-1');
      },
    );

    test('a server that answers with cookies only is no session', () async {
      final client = RestmailClient(
        server: _server,
        httpClient: MockClient(
          (_) async => _json(
            {
              'data': {'expires_in': 900, 'user': _user},
            },
            headers: {
              'set-cookie':
                  'restmail_access=a; Path=/, restmail_refresh=r; Path=/api/v1/auth',
            },
          ),
        ),
      );
      await expectLater(
        client.login(email: 'a@b.test', password: 'pw'),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'missing_tokens'),
        ),
      );
      expect(client.tokens, isNull);
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
              request.headers['Authorization'] ??
              (jsonDecode(request.body) as Map)['refresh_token'];
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
        'POST /api/v1/auth/refresh refresh-1',
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

    test(
      'a 401 that survives a fresh token is the request’s own refusal',
      () async {
        // The renewal worked, so the session goes on: the 401 is reported
        // like any other error, not taken for the end of the session.
        final client = RestmailClient(
          server: _server,
          tokens: _tokens('1'),
          httpClient: MockClient((request) async {
            if (_isRefresh(request)) return _signedIn('2');
            return _json({
              'error': {'code': 'unauthorized', 'message': 'Not for you'},
            }, status: 401);
          }),
        );

        await expectLater(
          client.accounts(),
          throwsA(
            isA<ApiException>()
                .having(
                  (e) => e is SessionExpiredException,
                  'ends the session',
                  isFalse,
                )
                .having((e) => e.message, 'message', 'Not for you'),
          ),
        );
        expect(client.tokens?.accessToken, 'access-2');
      },
    );
  });

  group('logout', () {
    test(
      'ends the session here and sends the refresh token in the body',
      () async {
        late http.Request sent;
        final changes = <SessionTokens?>[];
        final client = RestmailClient(
          server: _server,
          tokens: _tokens('1'),
          onTokensChanged: changes.add,
          httpClient: MockClient((request) async {
            sent = request;
            return http.Response('', 204);
          }),
        );

        await client.logout();

        expect(sent.url.path, '/api/v1/auth/logout');
        expect(jsonDecode(sent.body), {'refresh_token': 'refresh-1'});
        expect(sent.headers.containsKey('Cookie'), isFalse);
        expect(client.tokens, isNull);
        expect(changes, [null]);
      },
    );
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

  group('accounts', () {
    test('lists accounts by id, the mailbox id, own first', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient(
          (_) async => _json({
            'data': [
              {
                'id': 4,
                'address': 'admin@example.test',
                'display_name': 'Admin',
                'is_primary': true,
              },
              {
                'id': 9,
                'address': 'chris@example.test',
                'display_name': '',
                'is_primary': false,
              },
            ],
          }),
        ),
      );
      final accounts = await client.accounts();
      expect([for (final a in accounts) a.id], [4, 9]);
      expect(accounts.first.isPrimary, isTrue);
      expect(accounts.last.label, 'chris@example.test');
    });

    test('creates an account with no password, owned by this one', () async {
      late http.Request sent;
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          sent = request;
          return _json({
            'data': {
              'id': 9,
              'address': 'chris@example.test',
              'display_name': 'Chris',
              'is_primary': false,
            },
          }, status: 201);
        }),
      );
      final created = await client.createAccount(
        address: 'chris@example.test',
        displayName: 'Chris',
      );
      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/accounts');
      expect(jsonDecode(sent.body), {
        'address': 'chris@example.test',
        'display_name': 'Chris',
      });
      expect(created.id, 9);
      expect(created.isPrimary, isFalse);
    });

    test('links by password, at /accounts/link, asking for the code when the '
        'account has two-factor authentication', () async {
      final bodies = <Map<String, dynamic>>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          expect(request.url.path, '/api/v1/accounts/link');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          bodies.add(body);
          if (body['totp_code'] == null) {
            return _json({
              'error': {
                'code': 'totp_required',
                'message': 'That account has two-factor authentication',
              },
            }, status: 403);
          }
          return _json({
            'data': {
              'id': 5,
              'address': 'other@example.test',
              'display_name': '',
              'is_primary': false,
            },
          }, status: 201);
        }),
      );

      await expectLater(
        client.linkAccount(address: 'other@example.test', password: 'pw'),
        throwsA(
          isA<TotpRequiredException>().having(
            (e) => e.statusCode,
            'status',
            403,
          ),
        ),
      );
      // Its own refusal: the session is not renewed for it.
      expect(client.tokens?.accessToken, 'access-1');
      final linked = await client.linkAccount(
        address: 'other@example.test',
        password: 'pw',
        totpCode: '123456',
      );
      expect(linked.id, 5);
      expect(bodies, [
        {'address': 'other@example.test', 'password': 'pw'},
        {
          'address': 'other@example.test',
          'password': 'pw',
          'totp_code': '123456',
        },
      ]);
    });

    for (final (code, message) in [
      ('invalid_credentials', 'Invalid email or password'),
      ('totp_required', 'That account has two-factor authentication'),
      ('invalid_totp', 'Invalid two-factor authentication code'),
    ]) {
      test('a refused link, $code, is sent once and leaves the session as it '
          'was', () async {
        // 403, not 401: the secrets were the other account's. Renewing the
        // session and sending them again would spend a refresh token and
        // count twice against the sign-in throttle.
        var sent = 0;
        final client = RestmailClient(
          server: _server,
          tokens: _tokens('1'),
          httpClient: MockClient((request) async {
            if (_isRefresh(request)) fail('renewed the session');
            sent++;
            return _json({
              'error': {'code': code, 'message': message},
            }, status: 403);
          }),
        );

        await expectLater(
          client.linkAccount(
            address: 'other@example.test',
            password: 'pw',
            totpCode: code == 'invalid_totp' ? '000000' : null,
          ),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'status', 403)
                .having((e) => e.code, 'code', code),
          ),
        );
        expect(sent, 1);
        expect(client.tokens?.accessToken, 'access-1');
      });
    }
  });

  group('app passwords', () {
    const secret =
        'rm_7Kq2xT9bLm4P_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQ';
    const credential = {
      'id': 4,
      'name': 'iPhone Mail',
      'kind': 'app_password',
      'public_id': '7Kq2xT9bLm4P',
      'created_at': '2026-10-17T09:00:00Z',
      'last_used_at': null,
      'expires_at': '2027-01-15T09:00:00Z',
    };

    test('lists, creates and revokes on the account', () async {
      final sent = <http.Request>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          sent.add(request);
          return switch (request.method) {
            'GET' => _json({
              'data': [credential],
            }),
            'POST' => _json({
              'data': {...credential, 'password': secret},
            }, status: 201),
            _ => http.Response('', 204),
          };
        }),
      );

      final listed = (await client.appPasswords(7)).single;
      final created = await client.createAppPassword(
        7,
        name: 'iPhone Mail',
        password: 'current password',
        expiresAt: DateTime.utc(2027, 1, 15, 9),
      );
      await client.revokeAppPassword(7, 4);

      expect(listed.name, 'iPhone Mail');
      expect(listed.lastUsedAt, isNull);
      expect(listed.expiresAt?.toUtc(), DateTime.utc(2027, 1, 15, 9));
      expect(listed.isExpiredAt(DateTime.utc(2027, 1, 15, 9)), isTrue);
      expect(created.appPassword.publicId, '7Kq2xT9bLm4P');
      expect(created.secret, secret);
      expect(
        [for (final r in sent) '${r.method} ${r.url.path}'],
        [
          'GET /api/v1/accounts/7/credentials',
          'POST /api/v1/accounts/7/credentials',
          'DELETE /api/v1/accounts/7/credentials/4',
        ],
      );
      expect(jsonDecode(sent[1].body), {
        'name': 'iPhone Mail',
        'password': 'current password',
        'expires_at': '2027-01-15T09:00:00.000Z',
      });
    });

    test('the secret stays out of toString, and goes when forgotten', () {
      final created = NewAppPassword.fromJson({
        ...credential,
        'password': secret,
      });

      expect('$created', isNot(contains(secret)));
      created.forget();
      expect(created.secret, isNull);
      expect(created.appPassword.name, 'iPhone Mail');
    });

    for (final code in ['reauth_required', 'invalid_password']) {
      test('$code is the request\'s own refusal: no refresh, and the '
          'session stays', () async {
        final seen = <String>[];
        final changes = <SessionTokens?>[];
        final client = RestmailClient(
          server: _server,
          tokens: _tokens('1'),
          onTokensChanged: changes.add,
          httpClient: MockClient((request) async {
            seen.add('${request.method} ${request.url.path}');
            if (_isRefresh(request)) return _signedIn('2');
            return _json({
              'error': {'code': code, 'message': 'The password is incorrect'},
            }, status: 403);
          }),
        );

        await expectLater(
          client.createAppPassword(7, name: 'Mail', password: 'wrong'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 403)
                .having((e) => e.code, 'code', code),
          ),
        );

        // Sent once, and nothing else: the password counted against the
        // sign-in budget once, and the refresh token was not spent.
        expect(seen, ['POST /api/v1/accounts/7/credentials']);
        expect(changes, isEmpty);
        expect(client.tokens?.accessToken, 'access-1');
      });
    }

    test('an expired token on create is still renewed, and the request '
        'sent again', () async {
      final seen = <String>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          seen.add('${request.method} ${request.url.path}');
          if (_isRefresh(request)) return _signedIn('2');
          if (request.headers['Authorization'] == 'Bearer access-1') {
            return _json(_expired, status: 401);
          }
          return _json({
            'data': {...credential, 'password': secret},
          }, status: 201);
        }),
      );

      final created = await client.createAppPassword(
        7,
        name: 'Mail',
        password: 'right',
      );

      expect(created.secret, secret);
      expect(seen, [
        'POST /api/v1/accounts/7/credentials',
        'POST /api/v1/auth/refresh',
        'POST /api/v1/accounts/7/credentials',
      ]);
    });

    test('a 429 says how long to wait', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient(
          (_) async => _json(
            {
              'error': {
                'code': 'rate_limited',
                'message': 'Too many requests; please slow down',
              },
            },
            status: 429,
            headers: {'retry-after': '42'},
          ),
        ),
      );

      await expectLater(
        client.createAppPassword(7, name: 'Mail', password: 'pw'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 429)
              .having(
                (e) => e.retryAfter,
                'retryAfter',
                const Duration(seconds: 42),
              ),
        ),
      );
    });

    test('a server from before app passwords answers 404', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient(
          (_) async => http.Response(
            '404 page not found',
            404,
            headers: {'content-type': 'text/plain; charset=utf-8'},
          ),
        ),
      );

      await expectLater(
        client.appPasswords(7),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.code, 'code', 'http_404'),
        ),
      );
    });
  });

  group('push devices', () {
    test('lists, registers and removes this session\'s devices', () async {
      final sent = <http.Request>[];
      const device = {
        'id': 'd-1',
        'platform': 'apns',
        'environment': 'production',
        'created_at': '2026-10-17T09:00:00Z',
      };
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          sent.add(request);
          return switch (request.method) {
            'GET' => _json({
              'data': {
                'platforms': ['apns'],
                'devices': [device],
              },
            }),
            'POST' => _json({'data': device}, status: 201),
            _ => http.Response('', 204),
          };
        }),
      );

      final listed = await client.pushDevices();
      final registered = await client.registerPushDevice(
        platform: PushPlatform.apns,
        token: 'ab12',
        environment: ApnsEnvironment.production,
        appId: 'com.antimatterstudios.restmail',
      );
      await client.removePushDevice(registered.id);

      expect(listed.supports(PushPlatform.apns), isTrue);
      expect(listed.supports(PushPlatform.fcm), isFalse);
      expect(listed.devices.single.id, 'd-1');
      expect(registered.environment, 'production');
      expect(registered.createdAt?.toUtc(), DateTime.utc(2026, 10, 17, 9));
      expect(
        [for (final r in sent) '${r.method} ${r.url.path}'],
        [
          'GET /api/v1/devices',
          'POST /api/v1/devices',
          'DELETE /api/v1/devices/d-1',
        ],
      );
      expect(jsonDecode(sent[1].body), {
        'platform': 'apns',
        'token': 'ab12',
        'environment': 'production',
        'app_id': 'com.antimatterstudios.restmail',
      });
      expect(sent[1].headers['authorization'], 'Bearer access-1');
    });

    test('a server without push answers 404, as an ApiException', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient(
          (_) async => http.Response('404 page not found\n', 404),
        ),
      );

      await expectLater(
        client.pushDevices(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    });

    test('a numeric device id is read as a string', () {
      expect(PushDevice.fromJson({'id': 12, 'platform': 'apns'}).id, '12');
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

  group('admin', () {
    test('sign-in and every refresh carry the capabilities', () async {
      final changes = <SessionTokens?>[];
      var refreshed = false;
      final client = RestmailClient(
        server: _server,
        onTokensChanged: changes.add,
        httpClient: MockClient((request) async {
          if (_isRefresh(request)) {
            refreshed = true;
            // A role taken away: the refresh says so.
            return _json({
              'data': {
                'expires_in': 900,
                'user': _user,
                'capabilities': ['queue:read'],
                'access_token': 'access-2',
                'refresh_token': 'refresh-2',
              },
            });
          }
          if (!refreshed && request.url.path.endsWith('/auth/login')) {
            return _json({
              'data': {
                'expires_in': 900,
                'user': {
                  'id': 1,
                  'email': 'ops@mail.example.test',
                  'display_name': 'Ops',
                },
                'capabilities': ['queue:read', 'queue:manage'],
                'access_token': 'access-1',
                'refresh_token': 'refresh-1',
              },
            });
          }
          return _json(_expired, status: 401);
        }),
      );

      final admin = await client.login(
        email: 'ops@mail.example.test',
        password: 'pw',
        totpCode: '123456',
      );
      expect(admin.isSetUp, isTrue);
      expect(admin.tokens.capabilities.names, {'queue:read', 'queue:manage'});
      expect(client.tokens!.capabilities, admin.tokens.capabilities);

      await client.refresh();
      expect(changes.last!.capabilities.names, {'queue:read'});
    });

    test('an account in setup is signed in, and says what it owes', () async {
      final client = RestmailClient(
        server: _server,
        httpClient: MockClient(
          (_) async => _json({
            'data': {
              'expires_in': 900,
              'user': {
                'id': 1,
                'email': 'admin@mail.example.test',
                'display_name': '',
              },
              'setup_required': ['password', 'two_factor'],
              'access_token': 'access-1',
              'refresh_token': 'refresh-1',
            },
          }),
        ),
      );
      final result = await client.login(
        email: 'admin@mail.example.test',
        password: 'from-the-deploy',
      );
      expect(result.isSetUp, isFalse);
      expect(result.setupRequired, [SetupStep.password, SetupStep.twoFactor]);
      expect(result.tokens.capabilities.isEmpty, isTrue);
    });

    test('sets a DKIM key and reads and changes its rotation', () async {
      final seen = <String>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          seen.add('${request.method} ${request.url.path}');
          if (request.url.path == '/api/v1/admin/dkim/4' &&
              request.method == 'PUT') {
            expect(jsonDecode(request.body), {
              'selector': 'mail2026',
              'private_key': 'PEM',
            });
            return _json({
              'data': {
                'domain_id': 4,
                'domain': 'example.test',
                'selector': 'mail2026',
                'has_key': true,
                'created_at': '2026-10-20T00:00:00Z',
                'age_seconds': 86400.5,
              },
            });
          }
          if (request.url.path == '/api/v1/admin/dkim/4/rotation') {
            if (request.method == 'PUT') {
              expect(jsonDecode(request.body), {'rotation_interval_days': 0});
              return _json({
                'data': {'domain_id': 4, 'rotation_interval_days': 0},
              });
            }
            return _json({
              'data': {'domain_id': 4, 'rotation_interval_days': 90},
            });
          }
          return _json({
            'error': {
              'code': 'validation_failed',
              'message': 'Invalid DKIM rotation interval',
            },
          }, status: 422);
        }),
      );

      final key = await client.setDkimKey(
        4,
        selector: 'mail2026',
        privateKey: 'PEM',
      );
      expect(key.domainId, 4);
      expect(key.selector, 'mail2026');
      expect(key.hasKey, isTrue);
      expect(key.createdAt, DateTime.utc(2026, 10, 20).toLocal());
      expect(key.ageSeconds, 86400.5);

      final rotation = await client.dkimRotation(4);
      expect(rotation.domainId, 4);
      expect(rotation.intervalDays, 90);
      expect(rotation.enabled, isTrue);

      final off = await client.setDkimRotation(4, 0);
      expect(off.intervalDays, 0);
      expect(off.enabled, isFalse);

      await expectLater(
        client.setDkimRotation(5, 9999),
        throwsA(isA<ApiException>()),
      );
      expect(seen, [
        'PUT /api/v1/admin/dkim/4',
        'GET /api/v1/admin/dkim/4/rotation',
        'PUT /api/v1/admin/dkim/4/rotation',
        'PUT /api/v1/admin/dkim/5/rotation',
      ]);
    });

    test('reads the queue page and the domain list as the server sends '
        'them', () async {
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((request) async {
          if (request.url.path.endsWith('/admin/queue')) {
            expect(request.url.queryParameters, {
              'status': 'deferred',
              'limit': '50',
              'offset': '0',
            });
            return _json({
              'data': {
                'items': [
                  {
                    'id': 3,
                    'message_id': null,
                    'sender': 'ada@mail.example.test',
                    'recipient': 'bob@far.test',
                    'domain': 'far.test',
                    'status': 'deferred',
                    'attempts': 2,
                    'last_attempt': '2026-10-17T03:00:00Z',
                    'next_attempt': '2026-10-17T03:15:00Z',
                    'last_error': '451 try later',
                    'last_error_code': 451,
                    'max_retries': 30,
                    'created_at': '2026-10-17T02:00:00Z',
                    'expires_at': '2026-10-22T02:00:00Z',
                  },
                ],
                'total': 51,
                'limit': 50,
                'offset': 0,
              },
            });
          }
          return _json({
            'data': [
              {
                'id': 1,
                'name': 'example.test',
                'server_type': 'restmail',
                'active': true,
                'default_quota_bytes': 1073741824,
                'dkim_selector': 'mail',
                'created_at': '2026-10-01T00:00:00Z',
                'updated_at': '2026-10-01T00:00:00Z',
              },
            ],
            'pagination': {'total': 1, 'has_more': false},
          });
        }),
      );

      final queue = await client.queue(status: QueueStatus.deferred);
      expect(queue.items.single.recipient, 'bob@far.test');
      expect(queue.items.single.status.canRetry, isTrue);
      expect(queue.items.single.lastErrorCode, 451);
      expect(queue.hasMore, isTrue);
      expect(queue.next, 1);

      final domains = await client.domains();
      expect(domains.items.single.name, 'example.test');
      expect(domains.hasMore, isFalse);
    });

    group('domain and mailbox changes', () {
      late List<http.Request> sent;
      late RestmailClient client;

      const domain = {
        'id': 4,
        'name': 'new.test',
        'server_type': 'traditional',
        'active': false,
        'default_quota_bytes': 524288000,
        'sending_policy': 'bulk',
      };
      const mailbox = {
        'id': 9,
        'domain_id': 4,
        'address': 'ada@new.test',
        'display_name': 'Ada',
        'active': true,
        'quota_bytes': 2097152,
        'quota_used_bytes': 0,
      };

      setUp(() {
        sent = [];
        client = RestmailClient(
          server: _server,
          tokens: _tokens('1'),
          httpClient: MockClient((request) async {
            sent.add(request);
            if (request.url.path.endsWith('/sessions')) {
              return http.Response('', 204);
            }
            return _json({
              'data': request.url.path.contains('/mailboxes/')
                  ? mailbox
                  : domain,
            });
          }),
        );
      });

      Map<String, dynamic> body(http.Request r) =>
          jsonDecode(r.body) as Map<String, dynamic>;

      test('createDomain sends type, quota and policy and reads the domain '
          'back', () async {
        final created = await client.createDomain(
          'new.test',
          serverType: 'traditional',
          defaultQuotaBytes: 524288000,
          sendingPolicy: 'bulk',
        );

        expect(sent.single.method, 'POST');
        expect(sent.single.url.path, '/api/v1/admin/domains');
        expect(body(sent.single), {
          'name': 'new.test',
          'server_type': 'traditional',
          'default_quota_bytes': 524288000,
          'sending_policy': 'bulk',
        });
        expect(created.id, 4);
        expect(created.serverType, 'traditional');
        expect(created.active, isFalse);
        expect(created.defaultQuotaBytes, 524288000);
        expect(created.sendingPolicy, 'bulk');
      });

      test('createDomain leaves out what was not given', () async {
        await client.createDomain('new.test');

        expect(body(sent.single), {
          'name': 'new.test',
          'server_type': 'restmail',
        });
      });

      test('updateDomain sends only what changes; an empty policy clears '
          'it', () async {
        await client.updateDomain(4, defaultQuotaBytes: 1048576);
        await client.updateDomain(4, sendingPolicy: '');
        final updated = await client.updateDomain(4, active: true);

        expect(sent.map((r) => r.method), everyElement('PATCH'));
        expect(
          sent.map((r) => r.url.path),
          everyElement('/api/v1/admin/domains/4'),
        );
        expect(body(sent[0]), {'default_quota_bytes': 1048576});
        expect(body(sent[1]), {'sending_policy': ''});
        expect(body(sent[2]), {'active': true});
        expect(updated.sendingPolicy, 'bulk');
      });

      test('a domain without a sending policy reads as empty', () {
        final read = AdminDomain.fromJson({
          'id': 1,
          'name': 'old.test',
          'server_type': 'restmail',
          'active': true,
          'default_quota_bytes': 0,
        });

        expect(read.sendingPolicy, '');
      });

      test('updateMailbox sends a new quota alone', () async {
        final updated = await client.updateMailbox(9, quotaBytes: 2097152);

        expect(sent.single.method, 'PATCH');
        expect(sent.single.url.path, '/api/v1/admin/mailboxes/9');
        expect(body(sent.single), {'quota_bytes': 2097152});
        expect(updated.quotaBytes, 2097152);
        expect(updated.address, 'ada@new.test');
      });

      test('endMailboxSessions deletes the mailbox sessions', () async {
        await client.endMailboxSessions(9);

        expect(sent.single.method, 'DELETE');
        expect(sent.single.url.path, '/api/v1/admin/mailboxes/9/sessions');
        expect(sent.single.body, isEmpty);
      });
    });
  });

  group('renewal', () {
    test('a refresh answered after sign-out neither revives the session nor '
        'reports new tokens', () async {
      final answer = Completer<http.Response>();
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        onTokensChanged: changes.add,
        httpClient: MockClient(
          (request) => _isRefresh(request)
              ? answer.future
              : Future.value(_json({'data': null})),
        ),
      );

      final refreshing = client.refresh();
      await Future<void>.delayed(Duration.zero);
      await client.logout();
      answer.complete(_signedIn('2'));

      await expectLater(refreshing, throwsA(isA<SessionExpiredException>()));
      expect(client.tokens, isNull);
      expect(changes, [null]);
    });

    test(
      'a refusal answered after sign-out does not report a second end',
      () async {
        final answer = Completer<http.Response>();
        final changes = <SessionTokens?>[];
        final client = RestmailClient(
          server: _server,
          tokens: _tokens('1'),
          onTokensChanged: changes.add,
          httpClient: MockClient(
            (request) => _isRefresh(request)
                ? answer.future
                : Future.value(_json({'data': null})),
          ),
        );

        final refreshing = client.refresh();
        await Future<void>.delayed(Duration.zero);
        await client.logout();
        answer.complete(_json(_expired, status: 401));

        await expectLater(refreshing, throwsA(isA<SessionExpiredException>()));
        expect(changes, [null]);
      },
    );

    test('renewIfExpiring leaves a token with time left alone', () async {
      var asked = 0;
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1'),
        httpClient: MockClient((_) async {
          asked++;
          return _signedIn('2');
        }),
      );

      await client.renewIfExpiring();

      expect(asked, 0);
      expect(client.tokens!.refreshToken, 'refresh-1');
    });

    test('renewIfExpiring renews a token about to run out, once however '
        'often it is asked', () async {
      var refreshes = 0;
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1', validFor: const Duration(seconds: 20)),
        onTokensChanged: changes.add,
        httpClient: MockClient((request) async {
          if (_isRefresh(request)) refreshes++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return _signedIn('2');
        }),
      );

      await Future.wait([
        client.renewIfExpiring(),
        client.renewIfExpiring(),
        client.renewIfExpiring(),
      ]);

      expect(refreshes, 1);
      expect(client.tokens!.refreshToken, 'refresh-2');
      expect(changes.map((t) => t?.refreshToken), ['refresh-2']);
    });

    test('renewIfExpiring with the server unreachable keeps the refresh '
        'token', () async {
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: _server,
        tokens: _tokens('1', validFor: Duration.zero),
        onTokensChanged: changes.add,
        httpClient: MockClient(
          (_) async => throw http.ClientException('Connection refused'),
        ),
      );

      await expectLater(
        client.renewIfExpiring(),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'network_error'),
        ),
      );
      expect(client.tokens!.refreshToken, 'refresh-1');
      expect(changes, isEmpty);
    });

    test(
      'renewIfExpiring with the refresh token refused ends the session',
      () async {
        final changes = <SessionTokens?>[];
        final client = RestmailClient(
          server: _server,
          tokens: _tokens('1', validFor: Duration.zero),
          onTokensChanged: changes.add,
          httpClient: MockClient((_) async => _json(_expired, status: 401)),
        );

        await expectLater(
          client.renewIfExpiring(),
          throwsA(isA<SessionExpiredException>()),
        );
        expect(client.tokens, isNull);
        expect(changes, [null]);
      },
    );
  });

  group('domain delivery', () {
    RestmailClient clientFor(
      FutureOr<http.Response> Function(http.Request) handler,
    ) => RestmailClient(
      server: _server,
      tokens: _tokens('1'),
      httpClient: MockClient((request) async => handler(request)),
    );

    test('reads a domain relay without its password', () async {
      final client = clientFor((request) {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/admin/domains/4/relay');
        return _json({
          'data': {
            'domain_id': 4,
            'transport': 'relay',
            'host': 'smtp.relay.test',
            'port': 587,
            'tls_mode': 'starttls',
            'username': 'ada',
            'password_set': true,
          },
        });
      });
      final relay = await client.domainRelay(4);
      expect(relay.domainId, 4);
      expect(relay.transport, OutboundTransport.relay);
      expect(relay.host, 'smtp.relay.test');
      expect(relay.port, 587);
      expect(relay.tlsMode, RelayTlsMode.starttls);
      expect(relay.username, 'ada');
      expect(relay.passwordSet, isTrue);
    });

    test('reads a direct transport with no relay fields', () async {
      final client = clientFor(
        (_) => _json({
          'data': {
            'domain_id': 4,
            'transport': 'direct',
            'password_set': false,
          },
        }),
      );
      final relay = await client.domainRelay(4);
      expect(relay.transport, OutboundTransport.direct);
      expect(relay.host, '');
      expect(relay.port, isNull);
      expect(relay.tlsMode, isNull);
      expect(relay.passwordSet, isFalse);
    });

    test('sets a relay, leaving the password out to keep it', () async {
      late Map<String, dynamic> sent;
      final client = clientFor((request) {
        expect(request.method, 'PUT');
        expect(request.url.path, '/api/v1/admin/domains/4/relay');
        sent = jsonDecode(request.body) as Map<String, dynamic>;
        return _json({
          'data': {
            'domain_id': 4,
            'transport': 'relay',
            'host': 'smtp.relay.test',
            'port': 465,
            'tls_mode': 'implicit',
            'username': 'ada',
            'password_set': true,
          },
        });
      });
      final saved = await client.setDomainRelay(
        4,
        transport: OutboundTransport.relay,
        host: 'smtp.relay.test',
        port: 465,
        tlsMode: RelayTlsMode.implicit,
        username: 'ada',
      );
      expect(sent, {
        'transport': 'relay',
        'host': 'smtp.relay.test',
        'port': 465,
        'tls_mode': 'implicit',
        'username': 'ada',
      });
      expect(saved.tlsMode, RelayTlsMode.implicit);
      expect(saved.passwordSet, isTrue);
    });

    test('sends a new or empty relay password as given', () async {
      final bodies = <Map<String, dynamic>>[];
      final client = clientFor((request) {
        bodies.add(jsonDecode(request.body) as Map<String, dynamic>);
        return _json({
          'data': {'domain_id': 4, 'transport': 'relay', 'password_set': false},
        });
      });
      await client.setDomainRelay(
        4,
        transport: OutboundTransport.relay,
        host: 'smtp.relay.test',
        port: 587,
        tlsMode: RelayTlsMode.starttls,
        username: 'ada',
        password: 's3cret',
      );
      await client.setDomainRelay(
        4,
        transport: OutboundTransport.relay,
        host: 'smtp.relay.test',
        port: 587,
        tlsMode: RelayTlsMode.starttls,
        password: '',
      );
      expect(bodies[0]['password'], 's3cret');
      expect(bodies[1]['username'], '');
      expect(bodies[1]['password'], '');
    });

    test('switches to direct with only the transport', () async {
      late Map<String, dynamic> sent;
      final client = clientFor((request) {
        sent = jsonDecode(request.body) as Map<String, dynamic>;
        return _json({
          'data': {
            'domain_id': 4,
            'transport': 'direct',
            'password_set': false,
          },
        });
      });
      await client.setDomainRelay(4, transport: OutboundTransport.direct);
      expect(sent, {'transport': 'direct'});
    });

    test('lists suppressions with every field the server sends', () async {
      final client = clientFor((request) {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/admin/domains/4/suppressions');
        return _json({
          'data': [
            {
              'id': 9,
              'domain_id': 4,
              'address': 'gone@far.test',
              'reason': 'hard_bounce',
              'failure_category': 'bad_mailbox',
              'last_error': '550 5.1.1 no such user',
              'message_id': 31,
              'created_at': '2026-10-20T08:00:00Z',
              'updated_at': '2026-10-21T08:00:00Z',
              'expires_at': '2026-11-20T08:00:00Z',
            },
            {
              'id': 10,
              'domain_id': 4,
              'address': 'nobody@nowhere.test',
              'reason': 'hard_bounce',
              'failure_category': 'bad_domain',
              'last_error': '',
              'message_id': null,
              'created_at': '2026-10-19T08:00:00Z',
              'updated_at': '2026-10-19T08:00:00Z',
              'expires_at': '2026-11-19T08:00:00Z',
            },
          ],
        });
      });
      final list = await client.suppressions(4);
      expect(list, hasLength(2));
      final first = list.first;
      expect(first.id, 9);
      expect(first.domainId, 4);
      expect(first.address, 'gone@far.test');
      expect(first.reason, 'hard_bounce');
      expect(first.failureCategory, 'bad_mailbox');
      expect(first.lastError, '550 5.1.1 no such user');
      expect(first.messageId, 31);
      expect(first.createdAt!.toUtc(), DateTime.utc(2026, 10, 20, 8));
      expect(first.updatedAt!.toUtc(), DateTime.utc(2026, 10, 21, 8));
      expect(first.expiresAt!.toUtc(), DateTime.utc(2026, 11, 20, 8));
      expect(list.last.messageId, isNull);
    });

    test('clears a suppression', () async {
      late http.Request sent;
      final client = clientFor((request) {
        sent = request;
        return http.Response('', 204);
      });
      await client.clearSuppression(4, 9);
      expect(sent.method, 'DELETE');
      expect(sent.url.path, '/api/v1/admin/domains/4/suppressions/9');
    });
  });
}
