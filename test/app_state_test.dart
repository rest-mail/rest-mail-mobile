import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  test(
    'a saved session the server will not renew ends, and says why',
    () async {
      final store = MemoryKeyValueStore();
      await store.write(
        'session',
        jsonEncode({
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
      final state = AppState(
        store: store,
        httpClientFactory: () => MockClient(
          (_) async => http.Response(
            jsonEncode({
              'error': {
                'code': 'unauthorized',
                'message': 'Invalid refresh token',
              },
            }),
            401,
          ),
        ),
      );

      await state.start();
      expect(state.phase, AppPhase.signedIn);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(state.phase, AppPhase.signedOut);
      expect(state.signedOutReason, isNotNull);
      expect(store.values, isNot(contains('session')));
      expect(store.values.keys.where((k) => k.startsWith('account')), isEmpty);
    },
  );

  test(
    'an unreadable saved session means signing in again, not a crash',
    () async {
      final store = MemoryKeyValueStore();
      await store.write('session', '{not json');
      final state = AppState(
        store: store,
        httpClientFactory: () =>
            MockClient((_) async => http.Response('', 404)),
      );

      await state.start();

      expect(state.phase, AppPhase.signedOut);
      expect(state.signedOutReason, isNull);
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

    test(
      'an old single session moves into the list, still signed in',
      () async {
        final client = RestmailClient(server: _server, httpClient: fake.client);
        final login = await client.login(
          email: FakeAccounts.email,
          password: FakeAccounts.password,
        );
        await store.write(
          'session',
          jsonEncode({
            'server': _server.toString(),
            'user': login.user.toJson(),
            'tokens': login.tokens.toJson(),
          }),
        );

        final state = newState();
        await state.start();
        await _settle();

        expect(state.phase, AppPhase.signedIn);
        expect(_addresses(state), [FakeAccounts.email]);
        expect(state.mailbox!.account!.address, FakeAccounts.email);
        expect(requests, isNot(contains('/api/v1/auth/login')));
        expect(store.values.containsKey('session'), isFalse);
        expect(store.values.containsKey(_entry(FakeAccounts.email)), isTrue);

        // And it stays that way: the next launch reads the new layout.
        final again = newState();
        await again.start();
        expect(_addresses(again), [FakeAccounts.email]);
        expect(again.current!.address, FakeAccounts.email);
      },
    );

    test('signing out of the one on screen shows the other', () async {
      final state = await signedInToBoth();
      final notices = <String>[];
      state.notices.listen(notices.add);
      expect(_addresses(state), [FakeAccounts.email, FakeAccounts.otherEmail]);
      expect(state.current!.address, FakeAccounts.otherEmail);

      await state.signOut();
      await _settle();

      expect(state.phase, AppPhase.signedIn);
      expect(_addresses(state), [FakeAccounts.email]);
      expect(state.current!.address, FakeAccounts.email);
      expect(state.mailbox!.account!.address, FakeAccounts.email);
      expect(notices, ['Signed out of ${FakeAccounts.otherEmail}']);
      expect(
        store.values.containsKey(_entry(FakeAccounts.otherEmail)),
        isFalse,
      );

      final again = newState();
      await again.start();
      expect(_addresses(again), [FakeAccounts.email]);
    });

    test('signing out of one not on screen leaves the screen alone', () async {
      final state = await signedInToBoth();
      final mailbox = state.mailbox;

      await state.signOut(state.accounts.first);

      expect(_addresses(state), [FakeAccounts.otherEmail]);
      expect(state.current!.address, FakeAccounts.otherEmail);
      expect(state.mailbox, same(mailbox));
      expect(store.values.containsKey(_entry(FakeAccounts.email)), isFalse);
    });

    test('a session ending on an account not on screen says so, and leaves '
        'the one on screen alone', () async {
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
        'Your session for ${FakeAccounts.email} ended. Add the account again '
            'to carry on.',
      ]);
      expect(state.phase, AppPhase.signedIn);
      expect(_addresses(state), [FakeAccounts.otherEmail]);
      expect(state.mailbox, same(mailbox));
      expect(state.signedOutReason, isNull);
      expect(store.values.containsKey(_entry(FakeAccounts.email)), isFalse);
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
