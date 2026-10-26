import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/push/push_service.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/push_state.dart';
import 'package:restmail/state/settings.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'fake_push_service.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

/// Passes requests on to the fake, noting each one.
class _Recording extends http.BaseClient {
  _Recording(this._inner, this.log);

  final http.Client _inner;
  final List<String> log;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    log.add('${request.method} ${request.url.path}');
    return _inner.send(request);
  }
}

void main() {
  late FakeRestmail fake;
  late FakePushService push;
  late MemoryKeyValueStore store;
  late List<String> requests;
  late AppState state;

  Future<void> start({Set<String> pushPlatforms = const {'apns'}}) async {
    fake = FakeRestmail(pushPlatforms: pushPlatforms);
    state = AppState(
      store: store,
      httpClientFactory: () => _Recording(fake.client, requests),
      pushService: push,
    );
    await state.start();
    await state.push.start();
  }

  Future<void> signIn(String email) async {
    await state.signIn(
      server: _server,
      email: email,
      password: FakeAccounts.password,
    );
    await state.push.sync();
    await state.push.reconcileBadge();
  }

  SignedInAccount accountOf(String email) =>
      state.accounts.firstWhere((a) => a.address == email);

  int unreadIn(String email) =>
      fake.messagesIn(email, 'INBOX').where((m) => !m.isRead).length;

  Iterable<String> devicesRequests() =>
      requests.where((r) => r.contains('/api/v1/devices'));

  setUp(() {
    push = FakePushService();
    store = MemoryKeyValueStore();
    requests = [];
  });

  tearDown(() {
    state.dispose();
    fake.close();
  });

  test('nothing is registered until the user says yes; then each REST Mail '
      'account registers this phone with its server, once', () async {
    await start();
    await signIn(FakeAccounts.email);

    expect(state.push.available, isTrue);
    expect(state.push.shouldOffer, isTrue);
    expect(push.prompts, 0);
    expect(fake.devicesOf(FakeAccounts.email), isEmpty);

    expect(await state.push.enable(), isTrue);
    await signIn(FakeAccounts.otherEmail);

    expect(push.prompts, 1);
    expect(state.settings.notifications, NotificationChoice.on);
    expect(state.push.shouldOffer, isFalse);
    for (final email in [FakeAccounts.email, FakeAccounts.otherEmail]) {
      final device = fake.devicesOf(email).single;
      expect(device.token, push.deviceToken);
      expect(device.platform, 'apns');
      expect(device.environment, 'sandbox');
      expect(device.appId, 'com.antimatterstudios.restmail');
      expect(state.push.statusOf(accountOf(email)), PushStatus.on);
    }

    // Nothing changed: nothing is sent again.
    requests.clear();
    await state.push.sync();
    expect(devicesRequests(), isEmpty);
  });

  test(
    'a later launch keeps the registration rather than making another',
    () async {
      await start();
      await signIn(FakeAccounts.email);
      await state.push.enable();
      final device = fake.devicesOf(FakeAccounts.email).single;
      // The phone restarts the app; the server is the same one.
      final relaunched = AppState(
        store: store,
        httpClientFactory: () => _Recording(fake.client, requests),
        pushService: FakePushService(
          permissionState: NotificationPermission.granted,
        ),
      );
      addTearDown(relaunched.dispose);
      await relaunched.start();
      await relaunched.push.sync();

      expect(fake.devicesOf(FakeAccounts.email).single.id, device.id);
      expect(
        relaunched.push.statusOf(relaunched.accounts.single),
        PushStatus.on,
      );
    },
  );

  test('signing out takes this phone off that server first; the other '
      'account keeps its registration', () async {
    await start();
    await signIn(FakeAccounts.email);
    await state.push.enable();
    await signIn(FakeAccounts.otherEmail);
    requests.clear();

    await state.signOut(accountOf(FakeAccounts.email));

    expect(fake.devicesOf(FakeAccounts.email), isEmpty);
    expect(fake.devicesOf(FakeAccounts.otherEmail), hasLength(1));
    final removed = requests.indexWhere(
      (r) => r.startsWith('DELETE /api/v1/devices/'),
    );
    expect(removed, isNonNegative);
    expect(removed, lessThan(requests.indexOf('POST /api/v1/auth/logout')));
    expect(store.values.keys.where((k) => k.startsWith('push:')), hasLength(1));
  });

  test('signing in again to the same account moves the registration to the '
      'new session', () async {
    await start();
    await signIn(FakeAccounts.email);
    await state.push.enable();
    final before = fake.devicesOf(FakeAccounts.email).single;

    await signIn(FakeAccounts.email);
    // The old session is ended in the background.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final after = fake.devicesOf(FakeAccounts.email).single;
    expect(after.id, isNot(before.id));
    expect(state.push.statusOf(state.accounts.single), PushStatus.on);
  });

  test('turning them off takes this phone off every server, and the badge '
      'with it', () async {
    await start();
    await signIn(FakeAccounts.email);
    await state.push.enable();

    await state.push.disable();

    expect(fake.devicesOf(FakeAccounts.email), isEmpty);
    expect(state.push.statusOf(state.accounts.single), PushStatus.off);
    expect(push.badges.last, 0);
  });

  test('a server without push: no offer, no prompt, nothing registered and '
      'nothing to remove at sign-out', () async {
    await start(pushPlatforms: const {});
    await signIn(FakeAccounts.email);

    expect(state.push.available, isFalse);
    expect(state.push.shouldOffer, isFalse);
    expect(state.push.statusOf(state.accounts.single), PushStatus.unsupported);

    await state.signOut();

    expect(devicesRequests(), ['GET /api/v1/devices']);
    expect(push.prompts, 0);
    expect(push.shown, isEmpty);
    // No notifications asked for, so the badge stays clear even though the
    // inbox has mail the app could count.
    expect(push.badges.last, 0);
  });

  test(
    'a build without the push entitlement asks the server nothing',
    () async {
      push.deviceToken = null;
      await start();
      await signIn(FakeAccounts.email);

      expect(state.push.available, isFalse);
      expect(state.push.shouldOffer, isFalse);
      expect(devicesRequests(), isEmpty);
      expect(push.prompts, 0);
    },
  );

  test('"Not now" is not asked again, and registers nothing', () async {
    await start();
    await signIn(FakeAccounts.email);

    await state.push.decline();
    await state.push.sync();

    expect(state.push.shouldOffer, isFalse);
    expect(state.settings.notifications, NotificationChoice.off);
    expect(push.prompts, 0);
    expect(fake.devicesOf(FakeAccounts.email), isEmpty);
  });

  test("iOS's prompt answered no: nothing registered", () async {
    push.answer = false;
    await start();
    await signIn(FakeAccounts.email);

    expect(await state.push.enable(), isFalse);

    expect(state.settings.notifications, NotificationChoice.off);
    expect(state.push.permission, NotificationPermission.denied);
    expect(state.push.shouldOffer, isFalse);
    expect(fake.devicesOf(FakeAccounts.email), isEmpty);
  });

  group('the badge', () {
    test('sums every inbox across accounts, follows reads, and drops a '
        'signed-out account', () async {
      await start();
      await signIn(FakeAccounts.email);
      await signIn(FakeAccounts.otherEmail);
      await state.push.enable();
      await state.push.reconcileBadge();

      final both =
          unreadIn(FakeAccounts.email) + unreadIn(FakeAccounts.otherEmail);
      expect(push.badges.last, both);

      final read = fake
          .messagesIn(FakeAccounts.email, 'INBOX')
          .firstWhere((m) => !m.isRead);
      read.isRead = true;
      await state.push.reconcileBadge();
      expect(push.badges.last, both - 1);

      await state.signOut(accountOf(FakeAccounts.otherEmail));
      await state.push.reconcileBadge();
      expect(push.badges.last, unreadIn(FakeAccounts.email));

      for (final message in fake.messagesIn(FakeAccounts.email, 'INBOX')) {
        message.isRead = true;
      }
      await state.push.reconcileBadge();
      expect(push.badges.last, 0);
    });

    test('follows the inbox on screen without waiting for a push', () async {
      await start();
      await signIn(FakeAccounts.email);
      await state.push.enable();
      await state.push.reconcileBadge();
      final before = push.badges.last;

      final read = fake
          .messagesIn(FakeAccounts.email, 'INBOX')
          .firstWhere((m) => !m.isRead);
      read.isRead = true;
      await state.mailbox!.refresh();
      // The mailbox listener applies the new count asynchronously.
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(push.badges.last, before - 1);
    });
  });

  group('a push', () {
    setUp(() async {
      await start();
      await signIn(FakeAccounts.email);
      await state.push.enable();
      // In the background, as when a push wakes the app.
      state.push.foreground = false;
    });

    test('carries no mail: the app fetches it and shows what the server '
        'says, whatever else the payload holds', () async {
      fake.deliver(
        to: FakeAccounts.email,
        from: 'nadia@example.test',
        fromName: 'Nadia Osei',
        subject: 'Quarterly numbers',
        body: 'The figures are attached.',
      );
      final payload = fake.pushes.single.payload;
      final ours = payload['restmail']! as Map<String, Object?>;
      final tampered = <String, Object?>{
        'aps': {
          'content-available': 1,
          'alert': {'title': 'Injected title', 'body': 'Injected body'},
        },
        'restmail': {
          ...ours,
          'subject': 'Injected subject',
          'sender': 'mallory@example.test',
        },
      };

      expect(await push.deliver(tampered), isTrue);

      final shown = push.shown.single;
      expect(shown.title, 'Quarterly numbers');
      expect(shown.body, startsWith('Nadia Osei'));
      expect(shown.subtitle, FakeAccounts.email);
      for (final text in [shown.title, shown.body, shown.subtitle ?? '']) {
        expect(text, isNot(contains('Injected')));
        expect(text, isNot(contains('mallory')));
      }
      expect(shown.data['account'], state.accounts.single.key);
      expect(push.badges.last, unreadIn(FakeAccounts.email));
    });

    test('for mail already seen is no news', () async {
      fake.deliver(
        to: FakeAccounts.email,
        from: 'nadia@example.test',
        subject: 'Quarterly numbers',
      );
      final payload = fake.pushes.single.payload;
      await push.deliver(payload);
      push.shown.clear();

      expect(await push.deliver(payload), isFalse);
      expect(push.shown, isEmpty);
    });

    test(
      'with nothing of ours in it fetches every registered account',
      () async {
        await signIn(FakeAccounts.otherEmail);
        state.push.foreground = false;
        fake.deliver(
          to: FakeAccounts.otherEmail,
          from: 'sam@example.test',
          fromName: 'Sam',
          subject: 'Rota swap',
        );

        expect(
          await push.deliver({
            'aps': {'content-available': 1},
          }),
          isTrue,
        );

        final shown = push.shown.single;
        expect(shown.title, 'Rota swap');
        expect(shown.body, startsWith('Sam'));
        // Every notification names the account it belongs to.
        expect(shown.subtitle, FakeAccounts.otherEmail);
        expect(
          push.badges.last,
          unreadIn(FakeAccounts.email) + unreadIn(FakeAccounts.otherEmail),
        );
      },
    );

    test('for the inbox on screen, with the app open, shows in the list, '
        'not as a notification', () async {
      state.push.foreground = true;
      fake.deliver(
        to: FakeAccounts.email,
        from: 'nadia@example.test',
        subject: 'Quarterly numbers',
      );

      expect(await push.deliver(fake.pushes.single.payload), isTrue);
      expect(push.shown, isEmpty);
    });

    test('tapped, its notification puts its account on screen', () async {
      await signIn(FakeAccounts.otherEmail);
      state.push.foreground = false;
      expect(state.current?.address, FakeAccounts.otherEmail);
      fake.deliver(
        to: FakeAccounts.email,
        from: 'nadia@example.test',
        subject: 'Quarterly numbers',
      );
      await push.deliver(fake.pushes.last.payload);

      push.tap(push.shown.single);
      await Future<void>.delayed(Duration.zero);

      expect(state.current?.address, FakeAccounts.email);
    });
  });
}
