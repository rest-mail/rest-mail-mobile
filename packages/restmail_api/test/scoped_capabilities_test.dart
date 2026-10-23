import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

const _scoped = [
  {'capability': 'domains:read', 'scope': 'domain:a.test'},
  {'capability': 'mailboxes:read', 'scope': 'domain:a.test'},
  {'capability': 'mailboxes:write', 'scope': 'mailbox:x@b.test'},
];

http.Response _response(
  String access,
  String refresh, {
  Object? scoped = _scoped,
}) => http.Response(
  jsonEncode({
    'data': {
      'access_token': access,
      'refresh_token': refresh,
      'expires_in': 900,
      'capabilities': <String>[],
      'scoped_capabilities': scoped,
      'user': {'id': 1, 'email': 'x@a.test', 'display_name': 'X'},
    },
  }),
  200,
  headers: {'content-type': 'application/json'},
);

void main() {
  test('domain scopes cover their own mailboxes but never global access', () {
    final caps = Capabilities.fromJson([], scoped: _scoped);
    expect(caps.isEmpty, isFalse);
    expect(caps.names, isEmpty);
    expect(caps.allows(Capability.domainsRead), isFalse);
    expect(caps.allows(Capability.domainsRead, scope: 'domain:A.TEST'), isTrue);
    expect(
      caps.allows(Capability.mailboxesRead, scope: 'mailbox:Other@A.test'),
      isTrue,
    );
    expect(
      caps.allows(Capability.mailboxesRead, scope: 'mailbox:other@b.test'),
      isFalse,
    );
    expect(
      caps.allows(Capability.mailboxesWrite, scope: 'mailbox:X@B.TEST'),
      isTrue,
    );
    expect(
      caps.allows(Capability.mailboxesWrite, scope: 'domain:b.test'),
      isFalse,
    );
    expect(
      caps.allows(Capability.mailboxesWrite, scope: 'mailbox:y@b.test'),
      isFalse,
    );
    expect(
      caps.allows(Capability.mailboxesRead, scope: 'mailbox:x@evil-a.test'),
      isFalse,
    );
  });

  test('filtered collections distinguish a mailbox from its parent domain', () {
    final caps = Capabilities.fromJson(
      [],
      scoped: [
        {'capability': 'mailboxes:read', 'scope': 'mailbox:x@a.test'},
      ],
    );
    expect(caps.allowsSomewhere(Capability.mailboxesRead), isTrue);
    expect(
      caps.allowsSomewhere(Capability.mailboxesRead, domainsOnly: true),
      isFalse,
    );
    expect(
      caps.allowsSomewhere(Capability.mailboxesRead, within: 'domain:a.test'),
      isTrue,
    );
    expect(
      caps.allowsSomewhere(Capability.mailboxesRead, within: 'domain:b.test'),
      isFalse,
    );
  });

  test('scope wildcard stays narrow and global wildcard still covers all', () {
    final narrow = Capabilities.fromJson(
      [],
      scoped: [
        {'capability': '*', 'scope': 'domain:a.test'},
      ],
    );
    expect(
      narrow.allows(Capability.mailboxesDelete, scope: 'mailbox:x@a.test'),
      isTrue,
    );
    expect(narrow.allows(Capability.usersWrite), isFalse);
    expect(const Capabilities({'*'}).allows(Capability.usersWrite), isTrue);
    expect(
      const Capabilities({'*'}).allows(Capability.usersWrite, scope: 'invalid'),
      isFalse,
    );
  });

  test('bad or missing snapshots cannot create permissions', () {
    for (final invalid in [null, <String, Object?>{}, 'domain:a.test', 42]) {
      expect(Capabilities.fromJson(null, scoped: invalid), Capabilities.none);
    }
    final caps = Capabilities.fromJson(
      [],
      scoped: [
        null,
        {'capability': 'domains:read'},
        {'capability': '', 'scope': '*'},
        {'capability': 'domains:read', 'scope': 'domain:'},
        {'capability': 'domains:read', 'scope': 'mailbox:x@@a.test'},
        {'capability': 'domains:read', 'scope': 'mailbox:has space@a.test'},
        {'capability': 'domains:read', 'scope': 'domain:a.test.evil/'},
      ],
    );
    expect(caps, Capabilities.none);
  });

  test(
    'scope equality ignores wire order and duplicates but detects removal',
    () {
      final a = Capabilities.fromJson([], scoped: _scoped);
      final b = Capabilities.fromJson(
        [],
        scoped: [..._scoped.reversed, _scoped.first],
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(
        a,
        isNot(Capabilities.fromJson([], scoped: _scoped.skip(1).toList())),
      );
    },
  );

  test('persisted tokens keep scopes separate from global capabilities', () {
    final original = SessionTokens(
      accessToken: 'a',
      refreshToken: 'r',
      accessExpiresAt: DateTime.utc(2026, 10, 23),
      capabilities: Capabilities.fromJson(['queue:read'], scoped: _scoped),
    );
    final json = original.toJson();
    expect(json['capabilities'], ['queue:read']);
    final restored = SessionTokens.fromJson(
      jsonDecode(jsonEncode(json)) as Map<String, dynamic>,
    );
    expect(restored.capabilities, original.capabilities);
    expect(restored.capabilities.allows(Capability.domainsRead), isFalse);
  });

  test(
    'login, rotation and a later removal update the scoped snapshot',
    () async {
      final changes = <SessionTokens?>[];
      var requests = 0;
      final client = RestmailClient(
        server: Uri.parse('https://a.test'),
        onTokensChanged: changes.add,
        httpClient: MockClient((r) async {
          requests++;
          return _response(
            'access-$requests',
            'refresh-$requests',
            scoped: requests < 3 ? _scoped : null,
          );
        }),
      );
      addTearDown(client.close);
      await client.login(email: 'x@a.test', password: 'fixture');
      expect(client.tokens!.capabilities.scoped, hasLength(3));
      await client.refresh();
      expect(client.tokens!.refreshToken, 'refresh-2');
      expect(client.tokens!.capabilities.scoped, hasLength(3));
      await client.refresh();
      expect(client.tokens!.refreshToken, 'refresh-3');
      expect(client.tokens!.capabilities, Capabilities.none);
      expect(changes, hasLength(3));
    },
  );

  test('a redacted zero domain association is not shown as a real domain', () {
    expect(
      AdminMailbox.fromJson({
        'id': 1,
        'address': 'x@a.test',
        'domain': {'id': 0, 'name': ''},
      }).domain,
      isNull,
    );
    expect(
      AdminAlias.fromJson({
        'id': 1,
        'source_address': 'x@a.test',
        'destination_address': 'z@b.test',
        'domain': {'id': 0, 'name': ''},
      }).domain,
      isNull,
    );
  });

  test(
    'privilege changes during refresh retain new scopes and rotated credentials',
    () async {
      final rotating = Completer<http.Response>();
      final client = RestmailClient(
        server: Uri.parse('https://a.test'),
        tokens: SessionTokens(
          accessToken: 'old-access',
          refreshToken: 'old-refresh',
          accessExpiresAt: DateTime.now().add(const Duration(minutes: 5)),
        ),
        httpClient: MockClient((r) async {
          if (r.url.path.endsWith('/auth/refresh')) return rotating.future;
          return http.Response(
            jsonEncode({
              'data': {
                'grant': {
                  'id': 1,
                  'holder': {'kind': 'account', 'id': 1},
                  'role': 'admin',
                  'role_id': 2,
                  'scope': 'domain:a.test',
                  'mode': 'eligible',
                  'granted_by': {'kind': 'account', 'id': 1},
                  'granted_at': '2026-10-23T00:00:00Z',
                },
                'capabilities': <String>[],
                'scoped_capabilities': _scoped,
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      addTearDown(client.close);
      final pending = client.refresh();
      await Future<void>.delayed(Duration.zero);
      await client.activateGrant(1, reason: 'Routine administration');
      expect(client.tokens!.capabilities.scoped, hasLength(3));
      rotating.complete(
        _response('rotated-access', 'rotated-refresh', scoped: []),
      );
      await pending;
      expect(client.tokens!.refreshToken, 'rotated-refresh');
      expect(client.tokens!.capabilities.scoped, hasLength(3));
    },
  );
}
