import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  group('session renewal', _sessionRefreshTests);

  test('a saved session the server will not renew signs the account out, and '
      'keeps it, with nothing to renew the next time', () async {
    final store = MemoryKeyValueStore();
    const key = 'https://mail.example.test|ada@example.test';
    await store.write(
      'accounts',
      jsonEncode({
        'order': [key],
        'current': key,
      }),
    );
    await store.write(
      'account:$key',
      jsonEncode({
        'kind': 'rest',
        'server': 'https://mail.example.test',
        'user': {'id': 1, 'email': 'ada@example.test', 'display_name': 'Ada'},
        'tokens': {
          'access_token': 'a',
          'refresh_token': 'r',
          'access_expires_at': DateTime.now()
              .subtract(const Duration(minutes: 1))
              .toUtc()
              .toIso8601String(),
        },
      }),
    );
    var asked = 0;
    AppState newState() => AppState(
      store: store,
      httpClientFactory: () => MockClient((_) async {
        asked++;
        return http.Response(
          jsonEncode({
            'error': {
              'code': 'unauthorized',
              'message': 'Invalid refresh token',
            },
          }),
          401,
        );
      }),
    );
    final state = newState();
    addTearDown(state.dispose);

    await state.start();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    // Still here, and on screen, saying why and waiting to sign in.
    expect(state.phase, AppPhase.signedIn);
    expect(
      state.current!.signedOut,
      'Your session for ada@example.test ended. Sign in again to carry on.',
    );
    final entry =
        jsonDecode(store.values['account:$key']!) as Map<String, dynamic>;
    expect(entry['user']['display_name'], 'Ada');
    expect(entry.containsKey('tokens'), isFalse);

    // The next launch starts it signed out, and asks the server nothing.
    asked = 0;
    final again = newState();
    addTearDown(again.dispose);
    await again.start();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(again.current!.address, 'ada@example.test');
    expect(again.current!.signedOut, isNotNull);
    expect(asked, 0);
  });

  test(
    'an unreadable saved session means signing in again, not a crash',
    () async {
      final store = MemoryKeyValueStore();
      const key = 'https://mail.example.test|ada@example.test';
      await store.write(
        'accounts',
        jsonEncode({
          'order': [key],
          'current': key,
        }),
      );
      await store.write('account:$key', '{not json');
      final state = AppState(
        store: store,
        httpClientFactory: () =>
            MockClient((_) async => http.Response('', 404)),
      );

      await state.start();

      expect(state.phase, AppPhase.signedOut);
    },
  );

  group('several accounts', () {
    late FakeRestmail fake;
    late List<String> requests;
    late MemoryKeyValueStore store;

    setUp(() {
      fake = FakeRestmail();
      requests = [];
      store = MemoryKeyValueStore();
    });
    tearDown(() => fake.close());

    AppState newState([KeyValueStore? on]) {
      final state = AppState(
        store: on ?? store,
        httpClientFactory: () => _Logged(fake.client, requests),
      );
      addTearDown(state.dispose);
      return state;
    }

    Future<AppState> signedInToBoth() async {
      final state = newState();
      await state.start();
      await state.signIn(
        server: _server,
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      await state.signIn(
        server: _server,
        email: FakeAccounts.otherEmail,
        password: FakeAccounts.password,
      );
      await _settle();
      return state;
    }

    test('a saved entry that is not the account its key names, such as an '
        'administrator session from before accounts were mailboxes, is '
        'dropped, and deleted', () async {
      final client = RestmailClient(server: _server, httpClient: fake.client);
      final login = await client.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      final key = '$_server|admin:admin';
      await store.write(
        'accounts',
        jsonEncode({
          'order': [key, _key(FakeAccounts.email)],
          'current': key,
        }),
      );
      await store.write(
        'account:$key',
        jsonEncode({
          'kind': 'rest',
          'server': _server.toString(),
          'user': {'id': 1, 'email': 'admin', 'display_name': 'admin'},
          'tokens': login.tokens.toJson(),
          'administrator': true,
        }),
      );
      await store.write(
        _entry(FakeAccounts.email),
        jsonEncode({
          'kind': 'rest',
          'server': _server.toString(),
          'user': login.user.toJson(),
          'tokens': login.tokens.toJson(),
        }),
      );

      final state = newState();
      await state.start();

      expect(_addresses(state), [FakeAccounts.email]);
      expect(store.values.containsKey('account:$key'), isFalse);
      final index =
          jsonDecode(store.values['accounts']!) as Map<String, dynamic>;
      expect(index['order'], [_key(FakeAccounts.email)]);
    });

    test('a saved entry must say what kind it is; one that does not is '
        'dropped', () async {
      final client = RestmailClient(server: _server, httpClient: fake.client);
      final login = await client.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      final key = _key(FakeAccounts.email);
      await store.write(
        'accounts',
        jsonEncode({
          'order': [key],
          'current': key,
        }),
      );
      await store.write(
        _entry(FakeAccounts.email),
        jsonEncode({
          'server': _server.toString(),
          'user': login.user.toJson(),
          'tokens': login.tokens.toJson(),
        }),
      );

      final state = newState();
      await state.start();

      expect(state.phase, AppPhase.signedOut);
      expect(store.values.containsKey(_entry(FakeAccounts.email)), isFalse);
      expect(store.values.containsKey('accounts'), isFalse);
    });

    test('signing out of the one on screen keeps it signed out', () async {
      final state = await signedInToBoth();
      final notices = <String>[];
      state.notices.listen(notices.add);
      expect(_addresses(state), [FakeAccounts.email, FakeAccounts.otherEmail]);
      expect(state.current!.address, FakeAccounts.otherEmail);

      await state.signOut();
      await _settle();

      expect(state.phase, AppPhase.signedIn);
      expect(_addresses(state), [FakeAccounts.email, FakeAccounts.otherEmail]);
      expect(state.current!.address, FakeAccounts.otherEmail);
      expect(state.current!.signedOut, isNotNull);
      expect(notices, ['Signed out of ${FakeAccounts.otherEmail}']);
      expect(store.values.containsKey(_entry(FakeAccounts.otherEmail)), isTrue);

      final again = newState();
      await again.start();
      expect(_addresses(again), [FakeAccounts.email, FakeAccounts.otherEmail]);
      expect(again.accounts.last.signedOut, isNotNull);
    });

    test('signing out of one not on screen keeps it signed out', () async {
      final state = await signedInToBoth();
      final mailbox = state.mailbox;

      await state.signOut(state.accounts.first);

      expect(_addresses(state), [FakeAccounts.email, FakeAccounts.otherEmail]);
      expect(state.current!.address, FakeAccounts.otherEmail);
      expect(state.mailbox, same(mailbox));
      expect(state.accounts.first.signedOut, isNotNull);
      expect(store.values.containsKey(_entry(FakeAccounts.email)), isTrue);
    });

    test('a session ending on an account not on screen says so, keeps the '
        'account, signed out, and leaves the one on screen alone; signing in '
        'again puts it back where it was', () async {
      final state = await signedInToBoth();
      final mailbox = state.mailbox;
      final notices = <String>[];
      state.notices.listen(notices.add);

      fake.revokeSessionsOf(FakeAccounts.email);
      // Something that account's client had in flight when it left the
      // screen.
      await expectLater(
        state.accounts.first.backend.accounts(),
        throwsA(isA<SessionExpiredException>()),
      );
      await _settle();

      expect(notices, [
        'Your session for ${FakeAccounts.email} ended. Sign in again to carry '
            'on.',
      ]);
      expect(state.phase, AppPhase.signedIn);
      expect(_addresses(state), [FakeAccounts.email, FakeAccounts.otherEmail]);
      expect(state.accounts.first.signedOut, isNotNull);
      expect(state.current!.address, FakeAccounts.otherEmail);
      expect(state.mailbox, same(mailbox));
      final entry = jsonDecode(
        store.values[_entry(FakeAccounts.email)]!,
      ) as Map<String, dynamic>;
      expect(entry.containsKey('tokens'), isFalse);

      await state.signIn(
        server: _server,
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      await _settle();

      expect(_addresses(state), [FakeAccounts.email, FakeAccounts.otherEmail]);
      expect(state.current!.address, FakeAccounts.email);
      expect(state.current!.signedOut, isNull);
      expect(state.mailbox!.error, isNull);
      expect(notices, hasLength(1));
    });

    for (final (kind, spoil) in [
      (
        'is garbage',
        (_FlakyStore store, String key) {
          store.values[key] = '{not json';
        },
      ),
      (
        "can't be read",
        (_FlakyStore store, String key) {
          store.unreadable.add(key);
        },
      ),
    ]) {
      test('an account whose saved session $kind is dropped; the other stays '
          'signed in', () async {
        final flaky = _FlakyStore();
        store = flaky;
        await signedInToBoth();
        spoil(flaky, _entry(FakeAccounts.otherEmail));

        final state = newState();
        await state.start();

        expect(state.phase, AppPhase.signedIn);
        expect(_addresses(state), [FakeAccounts.email]);
        expect(state.current!.address, FakeAccounts.email);
        expect(
          flaky.values.containsKey(_entry(FakeAccounts.otherEmail)),
          isFalse,
        );
        final index =
            jsonDecode(flaky.values['accounts']!) as Map<String, dynamic>;
        expect(index['order'], [_key(FakeAccounts.email)]);
      });
    }

    test('an administrator signs in as the account it is: its mail, beside '
        'the others, with the capabilities the server last sent', () async {
      final state = newState();
      await state.start();
      await state.signIn(
        server: _server,
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      await state.signIn(
        server: _server,
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      await _settle();

      final admin = state.current! as RestAccount;
      expect(_addresses(state), [FakeAccounts.email, FakeAccounts.adminEmail]);
      expect(state.mailbox!.account!.address, FakeAccounts.adminEmail);
      expect(admin.capabilities.names, {'*'});

      // A refresh brings the server's grants as they are now, and they are
      // what the next launch starts from.
      fake.grant(FakeAccounts.adminEmail, {'queue:read'});
      await admin.client.refresh();
      await _settle();
      expect(admin.capabilities.names, {'queue:read'});

      final again = newState();
      await again.start();
      final restored = again.current! as RestAccount;
      expect(restored.address, FakeAccounts.adminEmail);
      expect(restored.capabilities.names, {'queue:read'});
      expect(again.mailbox, isNotNull);
    });

    test('an account still in setup is not kept', () async {
      final fresh = FakeRestmail(scenario: FakeScenario.freshInstall);
      addTearDown(fresh.close);
      final state = AppState(
        store: store,
        httpClientFactory: () => fresh.client,
      );
      addTearDown(state.dispose);
      await state.start();

      await expectLater(
        state.signIn(
          server: _server,
          email: FakeAccounts.adminEmail,
          password: FakeAccounts.bootstrapPassword,
        ),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'setup_required'),
        ),
      );
      expect(state.accounts, isEmpty);
      expect(state.phase, AppPhase.signedOut);
    });
  });
}

final _server = Uri.parse('https://${FakeAccounts.host}');

String _key(String email) => '$_server|$email';

String _entry(String email) => 'account:${_key(email)}';

List<String> _addresses(AppState state) => [
  for (final a in state.accounts) a.address,
];

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 50));

/// Passes requests on, noting each one's path.
void _sessionRefreshTests() {
  const key = 'https://mail.example.test|ada@example.test';

  Future<void> saveSession(
    MemoryKeyValueStore store,
    Duration validFor, {
    List<String> capabilities = const [],
  }) async {
    await store.write(
      'accounts',
      jsonEncode({
        'order': [key],
        'current': key,
      }),
    );
    await store.write(
      'account:$key',
      jsonEncode({
        'kind': 'rest',
        'server': 'https://mail.example.test',
        'user': {'id': 1, 'email': 'ada@example.test', 'display_name': 'Ada'},
        'tokens': {
          'access_token': 'a',
          'refresh_token': 'r',
          'capabilities': capabilities,
          'access_expires_at': DateTime.now()
              .add(validFor)
              .toUtc()
              .toIso8601String(),
        },
      }),
    );
  }

  String? savedRefreshToken(MemoryKeyValueStore store) {
    final entry = store.values['account:$key'];
    if (entry == null) return null;
    final tokens = (jsonDecode(entry) as Map<String, dynamic>)['tokens'];
    return (tokens as Map<String, dynamic>?)?['refresh_token'] as String?;
  }

  var issued = 0;
  http.Response renewed() => http.Response(
    jsonEncode({
      'data': {
        'access_token': 'a${++issued}',
        'refresh_token': 'r$issued',
        'expires_in': 900,
      },
    }),
    200,
    headers: {'content-type': 'application/json'},
  );

  http.Response respond(http.Request request) =>
      request.url.path.endsWith('/auth/refresh')
      ? renewed()
      : http.Response('{"data":[]}', 200);

  test('rotated tokens are kept in the order the server issued them, '
      'however slowly the Keychain writes the older pair', () async {
    issued = 0;
    final store = _SlowStore()..slowWhen = (value) => value.contains('"r1"');
    await saveSession(store, const Duration(minutes: 15));
    final state = AppState(
      store: store,
      httpClientFactory: () => MockClient((request) async => respond(request)),
    );
    addTearDown(state.dispose);
    await state.start();
    final account = state.current! as RestAccount;

    await account.client.refresh();
    await account.client.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(savedRefreshToken(store), 'r2');
  });

  test('a renewal that lands after the account is removed does not bring '
      'it back', () async {
    issued = 0;
    final store = _SlowStore()..slowWhen = (value) => value.contains('"r1"');
    await saveSession(store, const Duration(minutes: 15));
    final state = AppState(
      store: store,
      httpClientFactory: () => MockClient((request) async => respond(request)),
    );
    addTearDown(state.dispose);
    await state.start();
    final account = state.current! as RestAccount;

    await account.client.refresh();
    await state.removeAccount(account);
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(store.values.containsKey('account:$key'), isFalse);
  });

  test(
    'an old Keychain write cannot overwrite a replacement sign-in',
    () async {
      issued = 0;
      final store = _SlowStore()..slowWhen = (value) => value.contains('"r1"');
      await saveSession(store, const Duration(minutes: 15));
      final state = AppState(
        store: store,
        httpClientFactory: () =>
            MockClient((request) async => respond(request)),
      );
      addTearDown(state.dispose);
      await state.start();
      final old = state.current! as RestAccount;
      await old.client.refresh();

      await state.keep(
        Uri.parse('https://mail.example.test'),
        old.user,
        SessionTokens(
          accessToken: 'replacement-access',
          refreshToken: 'replacement-refresh',
          accessExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(savedRefreshToken(store), 'replacement-refresh');
      expect(
        (state.current! as RestAccount).client.tokens!.refreshToken,
        'replacement-refresh',
      );
    },
  );

  test(
    'coming back on screen renews a session about to run out, once',
    () async {
      issued = 0;
      var refreshes = 0;
      final store = MemoryKeyValueStore();
      // Startup's 30-second margin leaves this token alone; resume must
      // renew it and its permissions.
      await saveSession(store, const Duration(seconds: 90));
      final state = AppState(
        store: store,
        httpClientFactory: () => MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) refreshes++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return respond(request);
        }),
      );
      addTearDown(state.dispose);
      await state.start();
      refreshes = 0;

      await Future.wait([state.resumed(), state.resumed()]);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(refreshes, 1);
      expect(state.current!.signedOut, isNull);
      expect(
        (state.current! as RestAccount).client.tokens!.expiresWithin(
          const Duration(minutes: 2),
        ),
        isFalse,
      );
    },
  );

  test('resume reconciles removed permissions even with a fresh access token, '
      'coalesces concurrent calls and persists the rotated pair', () async {
    issued = 0;
    var refreshes = 0;
    final store = MemoryKeyValueStore();
    await saveSession(
      store,
      const Duration(minutes: 15),
      capabilities: [Capability.queueRead],
    );
    final state = AppState(
      store: store,
      httpClientFactory: () => MockClient((request) async {
        if (request.url.path.endsWith('/auth/refresh')) refreshes++;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return respond(request);
      }),
    );
    addTearDown(state.dispose);
    await state.start();
    final account = state.current! as RestAccount;
    expect(account.capabilities.allows(Capability.queueRead), isTrue);
    expect(refreshes, 0);

    await Future.wait([state.resumed(), state.resumed()]);
    await _settle();

    expect(refreshes, 1);
    expect(account.capabilities.allows(Capability.queueRead), isFalse);
    expect(account.signedOut, isNull);
    expect(savedRefreshToken(store), 'r1');
    final saved =
        jsonDecode(store.values['account:$key']!) as Map<String, dynamic>;
    final tokens = SessionTokens.fromJson(
      saved['tokens'] as Map<String, dynamic>,
    );
    expect(tokens.capabilities.allows(Capability.queueRead), isFalse);
  });

  test(
    'resume signs out a fresh access session whose refresh was revoked',
    () async {
      final store = MemoryKeyValueStore();
      await saveSession(store, const Duration(minutes: 15));
      final state = AppState(
        store: store,
        httpClientFactory: () => MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) {
            return http.Response(
              '{"error":{"code":"unauthorized","message":"Revoked"}}',
              401,
            );
          }
          return http.Response('{"data":[]}', 200);
        }),
      );
      addTearDown(state.dispose);
      await state.start();

      await state.resumed();
      await _settle();

      expect(state.current!.signedOut, isNotNull);
      expect(savedRefreshToken(store), isNull);
    },
  );

  test('coming back on screen with the server unreachable keeps the session '
      'and its refresh token', () async {
    final store = MemoryKeyValueStore();
    await saveSession(store, Duration.zero);
    final state = AppState(
      store: store,
      httpClientFactory: () => MockClient(
        (_) async => throw http.ClientException('Connection refused'),
      ),
    );
    addTearDown(state.dispose);
    await state.start();

    await state.resumed();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(state.current!.signedOut, isNull);
    expect(savedRefreshToken(store), 'r');
  });
}

/// A Keychain that takes its time over the writes [slowWhen] picks, so a
/// later write can finish first.
class _SlowStore extends MemoryKeyValueStore {
  bool Function(String value) slowWhen = (_) => false;

  @override
  Future<void> write(String key, String value) async {
    if (slowWhen(value)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }
    await super.write(key, value);
  }
}

class _Logged extends http.BaseClient {
  _Logged(this._inner, this._paths);

  final http.Client _inner;
  final List<String> _paths;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    _paths.add(request.url.path);
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

/// A Keychain where some entries throw when read, as a Keystore whose key
/// was lost does.
class _FlakyStore extends MemoryKeyValueStore {
  final unreadable = <String>{};

  @override
  Future<String?> read(String key) async {
    if (unreadable.contains(key)) throw Exception('Keychain read failed');
    return super.read(key);
  }

  @override
  Future<void> delete(String key) async {
    unreadable.remove(key);
    await super.delete(key);
  }
}
