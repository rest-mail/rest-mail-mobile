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
        // Linking a mailbox with the wrong password answers 401 as well; that
        // must not be taken for the end of the session.
        final client = RestmailClient(
          server: _server,
          tokens: _tokens('1'),
          httpClient: MockClient((request) async {
            if (_isRefresh(request)) return _signedIn('2');
            return _json({
              'error': {
                'code': 'unauthorized',
                'message': 'Invalid email or password',
              },
            }, status: 401);
          }),
        );

        await expectLater(
          client.linkAccount(address: 'other@example.test', password: 'wrong'),
          throwsA(
            isA<ApiException>()
                .having(
                  (e) => e is SessionExpiredException,
                  'ends the session',
                  isFalse,
                )
                .having(
                  (e) => e.message,
                  'message',
                  'Invalid email or password',
                ),
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
            }, status: 401);
          }),
        );

        await expectLater(
          client.createAppPassword(7, name: 'Mail', password: 'wrong'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 401)
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
                'user': {'id': 1, 'email': 'ops', 'display_name': 'ops'},
                'capabilities': ['queue:read', 'queue:manage'],
                'access_token': 'access-1',
                'refresh_token': 'refresh-1',
              },
            });
          }
          return _json(_expired, status: 401);
        }),
      );

      final admin = await client.signInAdmin(
        username: 'ops',
        password: 'pw',
        totpCode: '123456',
      );
      expect(admin.capabilities.names, {'queue:read', 'queue:manage'});
      expect(client.tokens!.capabilities, admin.capabilities);

      await client.refresh();
      expect(changes.last!.capabilities.names, {'queue:read'});
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
  });
}
