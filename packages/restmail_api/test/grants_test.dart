import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

final _server = Uri.parse('https://mail.example.test');

http.Response _json(
  Object body, {
  int status = 200,
  Map<String, String> headers = const {},
}) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {'content-type': 'application/json', ...headers},
);

http.Response _error(int status, String code, String message) => _json({
  'error': {'code': code, 'message': message},
}, status: status);

SessionTokens _tokens({Set<String> capabilities = const {'users:read'}}) =>
    SessionTokens(
      accessToken: 'access-1',
      refreshToken: 'refresh-1',
      accessExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
      capabilities: Capabilities(capabilities),
    );

/// A grant as `toGrantResponse` writes it, switched on when [activation].
Map<String, Object?> _grant({
  int id = 9,
  String mode = 'eligible',
  Object? activation,
  Object? expiresAt,
}) => {
  'id': id,
  'holder': {'kind': 'account', 'id': 3},
  'role': 'superadmin',
  'role_id': 1,
  'scope': '*',
  'mode': mode,
  'granted_by': {'kind': 'system', 'id': null},
  'granted_at': '2026-10-01T09:00:00Z',
  'expires_at': expiresAt,
  'activation': activation,
};

const _activation = {
  'id': 4,
  'activated_at': '2026-10-23T10:00:00Z',
  'expires_at': '2026-10-23T11:00:00Z',
  'reason': 'rotate DKIM',
  'seconds_left': 3540,
};

RestmailClient _client(
  Future<http.Response> Function(http.Request) handler, {
  SessionTokens? tokens,
  void Function(SessionTokens?)? onTokensChanged,
}) => RestmailClient(
  server: _server,
  tokens: tokens ?? _tokens(),
  onTokensChanged: onTokensChanged,
  httpClient: MockClient(handler),
);

void main() {
  group('roles and capabilities', () {
    test('lists the roles, each with its capabilities', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': [
            {
              'id': 1,
              'name': 'superadmin',
              'description': 'Everything',
              'system_role': true,
              'capabilities': ['*'],
            },
            {
              'id': 5,
              'name': 'helpdesk',
              'description': '',
              'system_role': false,
              'capabilities': <String>[],
            },
          ],
        });
      });

      final roles = await client.roles();

      expect(sent.method, 'GET');
      expect(
        sent.url.toString(),
        'https://mail.example.test/api/v1/admin/roles',
      );
      expect(sent.headers['Authorization'], 'Bearer access-1');
      expect(roles.map((r) => r.name), ['superadmin', 'helpdesk']);
      expect(roles.first.id, 1);
      expect(roles.first.description, 'Everything');
      expect(roles.first.systemRole, isTrue);
      expect(roles.first.capabilities, ['*']);
      expect(roles.last.systemRole, isFalse);
      expect(roles.last.capabilities, isEmpty);
    });

    test('lists every capability with its resource and action', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': [
            {
              'id': 2,
              'name': 'audit:read',
              'description': 'Read the audit log',
              'resource': 'audit',
              'action': 'read',
            },
          ],
        });
      });

      final capabilities = await client.capabilityDefinitions();

      expect(
        sent.url.toString(),
        'https://mail.example.test/api/v1/admin/capabilities',
      );
      expect(capabilities.single.id, 2);
      expect(capabilities.single.name, Capability.auditRead);
      expect(capabilities.single.description, 'Read the audit log');
      expect(capabilities.single.resource, 'audit');
      expect(capabilities.single.action, 'read');
    });

    test('an empty list Go sent as null is no roles', () async {
      final client = _client((_) async => _json({'data': null}));
      expect(await client.roles(), isEmpty);
    });
  });

  group('grants', () {
    test('sends the holder and scope filters and reads the page', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': [
            _grant(mode: 'active', expiresAt: '2026-12-31T00:00:00Z'),
            _grant(id: 10, activation: _activation),
          ],
          'pagination': {'total': 12, 'has_more': true},
        });
      });

      final page = await client.grants(
        holder: const GrantHolder.account(3),
        scope: 'mailbox:chris@example.com',
        offset: 0,
        limit: 2,
      );

      expect(sent.method, 'GET');
      expect(sent.url.path, '/api/v1/admin/grants');
      expect(sent.url.queryParameters, {
        'holder_kind': 'account',
        'holder_id': '3',
        'scope': 'mailbox:chris@example.com',
        'limit': '2',
        'offset': '0',
      });
      expect(page.total, 12);
      expect(page.hasMore, isTrue);

      final always = page.items.first;
      expect(always.id, 9);
      expect(always.holder, const GrantHolder(kind: 'account', id: 3));
      expect(always.role, 'superadmin');
      expect(always.roleId, 1);
      expect(always.scope, '*');
      expect(always.mode, GrantMode.active);
      expect(always.grantedBy.kind, 'system');
      expect(always.grantedBy.id, isNull);
      expect(always.grantedAt.toUtc(), DateTime.utc(2026, 10, 1, 9));
      expect(always.expiresAt!.toUtc(), DateTime.utc(2026, 12, 31));
      expect(always.activation, isNull);
      expect(always.isInForce, isTrue);

      final switchedOn = page.items.last;
      expect(switchedOn.mode, GrantMode.eligible);
      expect(switchedOn.expiresAt, isNull);
      expect(switchedOn.isInForce, isTrue);
      final activation = switchedOn.activation!;
      expect(activation.id, 4);
      expect(activation.activatedAt.toUtc(), DateTime.utc(2026, 10, 23, 10));
      expect(activation.expiresAt.toUtc(), DateTime.utc(2026, 10, 23, 11));
      expect(activation.reason, 'rotate DKIM');
      expect(activation.secondsLeft, 3540);
    });

    test('sends no filters it was not given', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': [_grant()],
          'pagination': {'total': 1, 'has_more': false},
        });
      });

      final page = await client.grants();

      expect(sent.url.queryParameters, {'limit': '100', 'offset': '0'});
      expect(page.items.single.isInForce, isFalse);
      expect(page.hasMore, isFalse);
    });

    test('grants a role with every field the server takes', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': _grant(id: 11, expiresAt: '2026-11-01T12:00:00Z')
            ..['granted_by'] = {'kind': 'account', 'id': 1},
        }, status: 201);
      });

      final grant = await client.createGrant(
        holder: const GrantHolder.account(3),
        role: 'superadmin',
        scope: '*',
        mode: GrantMode.eligible,
        expiresAt: DateTime.utc(2026, 11, 1, 12),
      );

      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/admin/grants');
      expect(sent.headers['Content-Type'], startsWith('application/json'));
      expect(jsonDecode(sent.body), {
        'holder': {'kind': 'account', 'id': 3},
        'role': 'superadmin',
        'scope': '*',
        'mode': 'eligible',
        'expires_at': '2026-11-01T12:00:00.000Z',
      });
      expect(grant.id, 11);
      expect(grant.mode, GrantMode.eligible);
      expect(grant.grantedBy.kind, 'account');
      expect(grant.grantedBy.id, 1);
      expect(grant.expiresAt!.toUtc(), DateTime.utc(2026, 11, 1, 12));
    });

    test('leaves the mode and expiry to the server when not given', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({'data': _grant(mode: 'active')}, status: 201);
      });

      await client.createGrant(
        holder: const GrantHolder.account(3),
        role: 'admin',
        scope: 'domain:a.com',
      );

      expect(jsonDecode(sent.body), {
        'holder': {'kind': 'account', 'id': 3},
        'role': 'admin',
        'scope': 'domain:a.com',
      });
    });

    test('reports the fields the server refused', () async {
      final client = _client(
        (_) async => _json({
          'error': {
            'code': 'validation_failed',
            'message': 'Validation failed',
            'details': {'role': 'no such role', 'scope': 'unknown scope'},
          },
        }, status: 422),
      );

      await expectLater(
        client.createGrant(
          holder: const GrantHolder.account(3),
          role: 'nope',
          scope: 'planet:mars',
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'validation_failed')
              .having((e) => e.fields, 'fields', {
                'role': 'no such role',
                'scope': 'unknown scope',
              }),
        ),
      );
    });

    for (final (status, code) in [
      (403, GrantErrorCode.twoFactorRequired),
      (403, GrantErrorCode.exceedsHeld),
      (409, GrantErrorCode.conflict),
      (409, GrantErrorCode.lastSuperadmin),
    ]) {
      test('a $code refusal keeps the session', () async {
        var refreshes = 0;
        final changes = <SessionTokens?>[];
        final client = _client((request) async {
          if (request.url.path.endsWith('/auth/refresh')) refreshes++;
          return _error(status, code, 'Refused');
        }, onTokensChanged: changes.add);

        await expectLater(
          client.deleteGrant(9),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', status)
                .having((e) => e.code, 'code', code),
          ),
        );
        expect(refreshes, 0);
        expect(changes, isEmpty);
        expect(client.tokens, isNotNull);
      });
    }

    test('removes a grant', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return http.Response('', 204);
      });

      await client.deleteGrant(9);

      expect(sent.method, 'DELETE');
      expect(sent.url.path, '/api/v1/admin/grants/9');
    });

    test("lists the account's own grants", () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': [
            _grant(activation: _activation),
            _grant(id: 12, mode: 'active'),
          ],
        });
      });

      final mine = await client.myGrants();

      expect(sent.method, 'GET');
      expect(sent.url.path, '/api/v1/admin/grants/mine');
      expect(sent.url.query, isEmpty);
      expect(mine.map((g) => g.id), [9, 12]);
      expect(mine.first.activation!.secondsLeft, 3540);
      expect(mine.last.mode, GrantMode.active);
    });

    test('an unknown mode is read as unknown, not as active', () {
      final grant = Grant.fromJson(_grant(mode: 'sometimes'));
      expect(grant.mode, GrantMode.unknown);
      expect(grant.isInForce, isFalse);
    });
  });

  group('escalation', () {
    test(
      'switches a grant on and takes the capabilities it answers with',
      () async {
        late http.Request sent;
        final changes = <SessionTokens?>[];
        final client = _client((request) async {
          sent = request;
          return _json({
            'data': {
              'grant': _grant(activation: _activation),
              'capabilities': ['*'],
            },
          }, status: 201);
        }, onTokensChanged: changes.add);

        final step = await client.activateGrant(
          9,
          reason: 'rotate DKIM',
          minutes: 60,
          totpCode: '123456',
        );

        expect(sent.method, 'POST');
        expect(sent.url.path, '/api/v1/admin/grants/9/activate');
        expect(jsonDecode(sent.body), {
          'reason': 'rotate DKIM',
          'minutes': 60,
          'totp_code': '123456',
        });
        expect(step.grant.id, 9);
        expect(step.grant.isInForce, isTrue);
        expect(step.grant.activation!.reason, 'rotate DKIM');
        expect(
          step.grant.activation!.expiresAt.toUtc(),
          DateTime.utc(2026, 10, 23, 11),
        );
        expect(step.capabilities.names, {'*'});

        expect(changes, hasLength(1));
        expect(changes.single!.capabilities.names, {'*'});
        expect(changes.single!.accessToken, 'access-1');
        expect(changes.single!.refreshToken, 'refresh-1');
        expect(
          client.tokens!.capabilities.allows(Capability.auditRead),
          isTrue,
        );
      },
    );

    test('switches on with a recovery code and the default length', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': {
            'grant': _grant(activation: _activation),
            'capabilities': ['*'],
          },
        }, status: 201);
      });

      await client.activateGrant(
        9,
        reason: 'locked out of my phone',
        recoveryCode: 'abcd-efgh',
      );

      expect(jsonDecode(sent.body), {
        'reason': 'locked out of my phone',
        'recovery_code': 'abcd-efgh',
      });
    });

    test('without a fresh code it is a TotpRequiredException', () async {
      final changes = <SessionTokens?>[];
      final client = _client(
        (_) async => _error(
          403,
          'totp_required',
          'A code from your authenticator (totp_code), or a recovery code '
              '(recovery_code), is required',
        ),
        onTokensChanged: changes.add,
      );

      await expectLater(
        client.activateGrant(9, reason: 'why'),
        throwsA(isA<TotpRequiredException>()),
      );
      expect(changes, isEmpty);
    });

    test('a wrong code is a 403, and not a sign-out', () async {
      var refreshes = 0;
      final client = _client((request) async {
        if (request.url.path.endsWith('/auth/refresh')) refreshes++;
        return _error(403, 'invalid_totp', 'Invalid two-factor code');
      });

      await expectLater(
        client.activateGrant(9, reason: 'why', totpCode: '000000'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 403)
              .having((e) => e.code, 'code', GrantErrorCode.invalidTotp),
        ),
      );
      expect(refreshes, 0);
      expect(client.tokens!.accessToken, 'access-1');
    });

    test('a throttled attempt says when to try again', () async {
      final client = _client(
        (_) async => _json(
          {
            'error': {'code': 'rate_limited', 'message': 'Too many attempts'},
          },
          status: 429,
          headers: {'retry-after': '30'},
        ),
      );

      await expectLater(
        client.activateGrant(9, reason: 'why', totpCode: '123456'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.retryAfter,
            'retryAfter',
            const Duration(seconds: 30),
          ),
        ),
      );
    });

    for (final code in [
      GrantErrorCode.notEligible,
      GrantErrorCode.alreadyActive,
      GrantErrorCode.grantExpired,
    ]) {
      test('a $code conflict is reported with its code', () async {
        final client = _client((_) async => _error(409, code, 'Refused'));
        await expectLater(
          client.activateGrant(9, reason: 'why', totpCode: '123456'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 409)
                .having((e) => e.code, 'code', code),
          ),
        );
      });
    }

    test('switches a grant off and drops what it gave', () async {
      late http.Request sent;
      final changes = <SessionTokens?>[];
      final client = _client(
        (request) async {
          sent = request;
          return _json({
            'data': {
              'grant': _grant(),
              'capabilities': ['domains:read', 'users:read'],
            },
          });
        },
        tokens: _tokens(capabilities: {'*'}),
        onTokensChanged: changes.add,
      );

      final step = await client.deactivateGrant(9);

      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/admin/grants/9/deactivate');
      expect(sent.body, isEmpty);
      expect(step.grant.activation, isNull);
      expect(step.grant.isInForce, isFalse);
      expect(changes.single!.capabilities.names, {
        'domains:read',
        'users:read',
      });
      expect(client.tokens!.capabilities.allows(Capability.auditRead), isFalse);
    });

    test('makes a grant eligible with a fresh code', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _json({
          'data': {'grant': _grant(), 'capabilities': null},
        });
      }, tokens: _tokens(capabilities: {'*'}));

      final step = await client.makeGrantEligible(9, totpCode: '123456');

      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/admin/grants/9/make-eligible');
      expect(jsonDecode(sent.body), {'totp_code': '123456'});
      expect(step.grant.mode, GrantMode.eligible);
      expect(step.capabilities.isEmpty, isTrue);
      expect(client.tokens!.capabilities.isEmpty, isTrue);
    });

    test('making eligible always sends a body the server can decode', () async {
      late http.Request sent;
      final client = _client((request) async {
        sent = request;
        return _error(403, 'totp_required', 'A code is required');
      });

      await expectLater(
        client.makeGrantEligible(9),
        throwsA(isA<TotpRequiredException>()),
      );
      expect(jsonDecode(sent.body), <String, Object?>{});
    });

    test('an escalation during refresh keeps rotated credentials and newer '
        'capabilities', () async {
      final answer = Completer<http.Response>();
      final client = _client((request) async {
        if (request.url.path.endsWith('/auth/refresh')) return answer.future;
        return _json({
          'data': {
            'grant': _grant(activation: _activation),
            'capabilities': ['*'],
          },
        }, status: 201);
      });
      final refreshing = client.refresh();
      await Future<void>.delayed(Duration.zero);

      await client.activateGrant(9, reason: 'Maintenance', totpCode: '123456');
      answer.complete(
        _json({
          'data': {
            'access_token': 'access-2',
            'refresh_token': 'refresh-2',
            'expires_in': 900,
            'capabilities': ['users:read'],
          },
        }),
      );
      await refreshing;

      expect(client.tokens!.accessToken, 'access-2');
      expect(client.tokens!.refreshToken, 'refresh-2');
      expect(client.tokens!.capabilities.names, {'*'});
    });

    test('an escalation answer with no grant is unreadable', () async {
      final changes = <SessionTokens?>[];
      final client = _client(
        (_) async => _json({
          'data': {
            'capabilities': ['*'],
          },
        }),
        onTokensChanged: changes.add,
      );

      await expectLater(
        client.deactivateGrant(9),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
        ),
      );
      expect(changes, isEmpty);
    });
  });
}
