import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Future<RestmailClient> _login(
  FakeRestmail fake, {
  String email = FakeAccounts.adminEmail,
  bool withCode = true,
}) async {
  final client = RestmailClient(
    server: Uri.parse('https://${fake.host}'),
    httpClient: fake.client,
  );
  await client.login(
    email: email,
    password: FakeAccounts.adminPassword,
    totpCode: withCode ? FakeAccounts.totpCode : null,
  );
  return client;
}

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

Matcher _field(String field, String message) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', 422)
      .having((e) => e.fields[field], field, message),
);

void main() {
  late FakeRestmail fake;
  setUp(() => fake = FakeRestmail());
  tearDown(() => fake.close());

  test('a key is made once, listed without its token, then revoked', () async {
    final client = await _login(fake);
    addTearDown(client.close);
    final account = (await client.accounts()).first;
    final created = await client.createAPIKey(
      account.id,
      name: '  Provisioning  ',
      password: FakeAccounts.adminPassword,
      permissions: [
        APIKeyPermission(
          capability: 'mail:read',
          scope: 'MAILBOX:${account.address.toUpperCase()}',
        ),
        APIKeyPermission(
          capability: 'mail:read',
          scope: 'mailbox:${account.address}',
        ),
      ],
    );
    expect(created.token, startsWith('rmk_${created.key.publicId}_'));
    expect(created.token, hasLength(60));
    expect(created.key.name, 'Provisioning');
    expect(created.key.kind, 'api_key');
    expect(created.key.permissions.map((p) => '${p.capability} ${p.scope}'), [
      'mail:read mailbox:${account.address.toLowerCase()}',
    ]);
    expect(created.key.expiresAt, isNotNull);

    final listed = await client.apiKeys(account.id);
    expect(listed.map((k) => k.id), [created.key.id]);
    final raw = await fake.client.get(
      Uri.parse('https://${fake.host}/api/v1/accounts/${account.id}/api-keys'),
      headers: {'authorization': 'Bearer ${client.tokens!.accessToken}'},
    );
    expect(raw.body, isNot(contains('token')));
    expect(raw.body, isNot(contains(created.token)));

    await client.revokeAPIKey(account.id, created.key.id);
    expect(await client.apiKeys(account.id), isEmpty);
    await expectLater(
      client.revokeAPIKey(account.id, created.key.id),
      _refused(404, 'not_found'),
    );
  });

  test(
    'refusals come in the server order and leave the session signed in',
    () async {
      final client = await _login(fake);
      addTearDown(client.close);
      final account = (await client.accounts()).first;
      final mine = APIKeyPermission(
        capability: 'mail:read',
        scope: 'mailbox:${account.address}',
      );
      Future<CreatedAPIKey> create({
        String name = 'Robot',
        String password = FakeAccounts.adminPassword,
        List<APIKeyPermission>? permissions,
        DateTime? expiresAt,
      }) => client.createAPIKey(
        account.id,
        name: name,
        password: password,
        permissions: permissions ?? [mine],
        expiresAt: expiresAt,
      );

      await expectLater(create(name: '  '), _field('name', 'required'));
      await expectLater(
        create(permissions: []),
        _field(
          'permissions',
          'must contain between 1 and 64 scoped permissions',
        ),
      );
      for (final bad in [
        APIKeyPermission(capability: '*', scope: '*'),
        APIKeyPermission(capability: 'mail:read', scope: 'team:ops'),
        APIKeyPermission(capability: 'mail:read', scope: 'mailbox:nobody'),
      ]) {
        await expectLater(
          create(permissions: [bad]),
          _field(
            'permissions',
            'each permission needs a named capability and a valid scope',
          ),
        );
      }
      await expectLater(
        create(expiresAt: DateTime.now().subtract(const Duration(days: 1))),
        _field('expires_at', 'must be in the future'),
      );
      await expectLater(create(password: ''), _refused(403, 'reauth_required'));
      await expectLater(
        create(password: 'not it'),
        _refused(403, 'invalid_password'),
      );
      // The superadmin holds everything, so only the catalogue refuses this.
      await expectLater(
        create(
          permissions: [APIKeyPermission(capability: 'mail:fly', scope: '*')],
        ),
        _field('permissions', 'contains an unknown capability'),
      );
      expect(client.tokens, isNotNull);
      expect(await client.apiKeys(account.id), isEmpty);
    },
  );

  test('a key never holds more than its creator does', () async {
    fake.addAccount(
      'watcher@${FakeAccounts.host}',
      capabilities: {'queue:read'},
    );
    final client = await _login(fake, email: 'watcher@${FakeAccounts.host}');
    addTearDown(client.close);
    final account = (await client.accounts()).first;
    await expectLater(
      client.createAPIKey(
        account.id,
        name: 'Too much',
        password: FakeAccounts.adminPassword,
        permissions: [
          APIKeyPermission(capability: 'domains:write', scope: '*'),
        ],
      ),
      _refused(403, 'forbidden'),
    );
    final made = await client.createAPIKey(
      account.id,
      name: 'Queue reader',
      password: FakeAccounts.adminPassword,
      permissions: [APIKeyPermission(capability: 'queue:read', scope: '*')],
    );
    expect(made.key.permissions.single.capability, 'queue:read');
  });

  test(
    'without a two-factor sign-in a key is neither made nor revoked',
    () async {
      fake.addAccount(
        'plain@${FakeAccounts.host}',
        capabilities: {'queue:read'},
        twoFactor: false,
      );
      final client = await _login(
        fake,
        email: 'plain@${FakeAccounts.host}',
        withCode: false,
      );
      addTearDown(client.close);
      final account = (await client.accounts()).first;
      await expectLater(
        client.createAPIKey(
          account.id,
          name: 'Robot',
          password: FakeAccounts.adminPassword,
          permissions: [APIKeyPermission(capability: 'queue:read', scope: '*')],
        ),
        _refused(403, 'two_factor_required'),
      );
      await expectLater(
        client.revokeAPIKey(account.id, 1),
        _refused(403, 'two_factor_required'),
      );
    },
  );

  group('changing a key', () {
    late Account account;
    late RestmailClient client;
    late CreatedAPIKey made;
    final mine = APIKeyPermission(capability: 'mail:read', scope: '*');
    final other = APIKeyPermission(capability: 'mail:send', scope: '*');

    Future<void> prepare([FakeRestmail? on]) async {
      client = await _login(on ?? fake);
      addTearDown(client.close);
      account = (await client.accounts()).first;
      made = await client.createAPIKey(
        account.id,
        name: 'Robot',
        password: FakeAccounts.adminPassword,
        permissions: [mine],
      );
    }

    Future<APIKey> change({
      String password = FakeAccounts.adminPassword,
      List<APIKeyPermission>? permissions,
      int? key,
    }) => client.updateAPIKey(
      account.id,
      key ?? made.key.id,
      password: password,
      permissions: permissions ?? [other],
    );

    test('replaces the permissions, keeps everything else, and the answer '
        'never carries the secret', () async {
      await prepare();
      final raw = await fake.client.patch(
        Uri.parse(
          'https://${fake.host}/api/v1/accounts/${account.id}/api-keys/'
          '${made.key.id}',
        ),
        headers: {
          'authorization': 'Bearer ${client.tokens!.accessToken}',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'password': FakeAccounts.adminPassword,
          'permissions': [
            {'capability': 'mail:send', 'scope': 'DOMAIN:EXAMPLE.COM'},
            {'capability': 'mail:send', 'scope': 'domain:example.com'},
            other.toJson(),
          ],
        }),
      );
      expect(raw.statusCode, 200);
      expect(raw.body, isNot(contains('token')));
      expect(raw.body, isNot(contains(made.token)));

      final listed = (await client.apiKeys(account.id)).single;
      // Stored as the server stores any key: lower case, without duplicates.
      expect(listed.permissions, [
        const APIKeyPermission(
          capability: 'mail:send',
          scope: 'domain:example.com',
        ),
        other,
      ]);
      expect(listed.id, made.key.id);
      expect(listed.name, made.key.name);
      expect(listed.publicId, made.key.publicId);
      expect(listed.createdAt, made.key.createdAt);
      expect(listed.expiresAt, made.key.expiresAt);
    });

    test('the client reads back what the server stored', () async {
      await prepare();
      final saved = await change();
      expect(saved.permissions, [other]);
      expect(saved.name, 'Robot');
      expect((await client.apiKeys(account.id)).single.permissions, [other]);
    });

    test(
      'refusals come in the server order and leave the key and session alone',
      () async {
        await prepare();
        await expectLater(
          change(password: '', permissions: []),
          _field(
            'permissions',
            'must contain between 1 and 64 scoped permissions',
          ),
        );
        await expectLater(
          change(
            password: '',
            permissions: [
              APIKeyPermission(capability: 'mail:read', scope: 'team:ops'),
            ],
          ),
          _field(
            'permissions',
            'each permission needs a named capability and a valid scope',
          ),
        );
        await expectLater(
          change(password: ''),
          _refused(403, 'reauth_required'),
        );
        await expectLater(
          change(password: 'not it'),
          _refused(403, 'invalid_password'),
        );
        await expectLater(
          change(
            permissions: [APIKeyPermission(capability: 'mail:fly', scope: '*')],
          ),
          _field('permissions', 'contains an unknown capability'),
        );
        // The password is read before the key is looked up.
        await expectLater(
          change(password: 'not it', key: 9999),
          _refused(403, 'invalid_password'),
        );
        await expectLater(change(key: 9999), _refused(404, 'not_found'));
        expect(client.tokens, isNotNull);
        expect((await client.apiKeys(account.id)).single.permissions, [mine]);
      },
    );

    test('a key is not changed to hold more than its creator does', () async {
      fake.addAccount(
        'watcher@${FakeAccounts.host}',
        capabilities: {'queue:read'},
      );
      final watcher = await _login(fake, email: 'watcher@${FakeAccounts.host}');
      addTearDown(watcher.close);
      final own = (await watcher.accounts()).first;
      const held = APIKeyPermission(capability: 'queue:read', scope: '*');
      final key = await watcher.createAPIKey(
        own.id,
        name: 'Queue reader',
        password: FakeAccounts.adminPassword,
        permissions: [held],
      );
      await expectLater(
        watcher.updateAPIKey(
          own.id,
          key.key.id,
          password: FakeAccounts.adminPassword,
          permissions: const [
            APIKeyPermission(capability: 'queue:manage', scope: '*'),
          ],
        ),
        _refused(403, 'forbidden'),
      );
      expect((await watcher.apiKeys(own.id)).single.permissions, [held]);
    });

    test('a revoked key and a key of another account are not found', () async {
      await prepare();
      await client.revokeAPIKey(account.id, made.key.id);
      await expectLater(change(), _refused(404, 'not_found'));

      await prepare();
      fake.addAccount(
        'other@${FakeAccounts.host}',
        capabilities: {'mail:send'},
      );
      final others = await _login(fake, email: 'other@${FakeAccounts.host}');
      addTearDown(others.close);
      final own = (await others.accounts()).first;
      expect(own.id, isNot(account.id));
      await expectLater(
        others.updateAPIKey(
          account.id,
          made.key.id,
          password: FakeAccounts.adminPassword,
          permissions: [other],
        ),
        _refused(404, 'not_found'),
      );
    });

    test('a session without a second factor cannot change a key', () async {
      fake.addAccount(
        'plain@${FakeAccounts.host}',
        capabilities: {'queue:read'},
        twoFactor: false,
      );
      final plain = await _login(
        fake,
        email: 'plain@${FakeAccounts.host}',
        withCode: false,
      );
      addTearDown(plain.close);
      final own = (await plain.accounts()).first;
      await expectLater(
        plain.updateAPIKey(
          own.id,
          1,
          password: FakeAccounts.adminPassword,
          permissions: [other],
        ),
        _refused(403, 'two_factor_required'),
      );
    });

    test('a second factor proved too long ago is refused, a refresh does not '
        'renew it, and signing in again does', () async {
      var now = DateTime.utc(2026, 11, 3, 12);
      final timed = FakeRestmail(clock: () => now);
      addTearDown(timed.close);
      await prepare(timed);

      now = now.add(const Duration(minutes: 15));
      await change();

      now = now.add(const Duration(seconds: 1));
      // The access token has expired too, so this request refreshes first.
      await expectLater(change(), _refused(403, 'recent_two_factor_required'));
      expect(client.tokens, isNotNull);
      await expectLater(change(), _refused(403, 'recent_two_factor_required'));

      await client.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      expect((await change(permissions: [mine])).permissions, [mine]);
    });

    test('ageing the proofs reaches the sessions already open', () async {
      await prepare();
      await change();
      fake.ageTwoFactorProofs();
      await expectLater(change(), _refused(403, 'recent_two_factor_required'));
    });

    test('shares sign-in\'s budget', () async {
      await prepare();
      fake.throttleSignIns(const Duration(minutes: 1));
      await expectLater(change(), _refused(429, 'rate_limited'));
    });

    test('a body is bound as the server binds it', () async {
      await prepare();
      Future<http.Response> send(Object body) => fake.client.patch(
        Uri.parse(
          'https://${fake.host}/api/v1/accounts/${account.id}/api-keys/'
          '${made.key.id}',
        ),
        headers: {
          'authorization': 'Bearer ${client.tokens!.accessToken}',
          'content-type': 'application/json',
        },
        body: jsonEncode(body),
      );
      final cases = <Map<String, Object?>, Map<String, String>>{
        {'password': FakeAccounts.adminPassword}: {
          'permissions': 'must contain between 1 and 64 scoped permissions',
        },
        {'password': 7, 'permissions': 'mail:read', 'name': 'Renamed'}: {
          'password': 'must be a string',
          'permissions': 'must be an array',
          'name': 'not allowed',
        },
      };
      for (final MapEntry(key: body, value: want) in cases.entries) {
        final response = await send(body);
        expect(response.statusCode, 422, reason: '$body');
        expect(
          (jsonDecode(response.body)
              as Map<String, dynamic>)['error']['details']['fields'],
          want,
          reason: '$body',
        );
      }
      expect((await client.apiKeys(account.id)).single.name, 'Robot');
    });
  });

  test('a create body is bound as the server binds it', () async {
    final client = await _login(fake);
    addTearDown(client.close);
    final account = (await client.accounts()).first;
    Future<http.Response> create(Object body) => fake.client.post(
      Uri.parse('https://${fake.host}/api/v1/accounts/${account.id}/api-keys'),
      headers: {
        'authorization': 'Bearer ${client.tokens!.accessToken}',
        'content-type': 'application/json',
      },
      body: jsonEncode(body),
    );
    final cases = <Map<String, Object?>, Map<String, String>>{
      {}: {'name': 'required'},
      {
        'name': 7,
        'permissions': 'mail:read',
        'expires_at': 'soon',
        'colour': 'red',
      }: {
        'name': 'must be a string',
        'permissions': 'must be an array',
        'expires_at': 'must be a date-time',
        'colour': 'not allowed',
      },
      {
        'name': 'Robot',
        'permissions': [
          'mail:read',
          {'capability': 'mail:read', 'scope': 1, 'note': 'x'},
        ],
      }: {
        'permissions[0]': 'must be an object',
        'permissions[1].scope': 'must be a string',
        'permissions[1].note': 'not allowed',
      },
    };
    for (final MapEntry(key: body, value: want) in cases.entries) {
      final response = await create(body);
      expect(response.statusCode, 422, reason: '$body');
      expect(
        (jsonDecode(response.body)
            as Map<String, dynamic>)['error']['details']['fields'],
        want,
        reason: '$body',
      );
    }
  });
}
