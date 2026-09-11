import 'dart:async';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

RestmailClient _client(FakeRestmail fake) =>
    RestmailClient(server: _server, httpClient: fake.client);

Future<RestmailClient> _signedIn(
  FakeRestmail fake, {
  String email = FakeAccounts.email,
}) async {
  final client = _client(fake);
  await client.login(email: email, password: FakeAccounts.password);
  return client;
}

Future<Account> _account(RestmailClient client) async =>
    (await client.accounts()).firstWhere((a) => a.isPrimary);

void main() {
  test('signs in and lists the sample inbox, newest first', () async {
    final client = await _signedIn(FakeRestmail());
    final account = await _account(client);

    final page = await client.messages(account.id, StandardFolder.inbox);

    expect(account.address, FakeAccounts.email);
    expect(page.items, hasLength(7));
    expect(page.items.first.senderLabel, 'Nadia Osei');
    final times = [for (final m in page.items) m.receivedAt];
    expect(times, [...times]..sort((a, b) => b.compareTo(a)));
  });

  test('pages with the server’s cursor', () async {
    final client = await _signedIn(FakeRestmail());
    final account = await _account(client);

    final first = await client.messages(account.id, 'INBOX', limit: 4);
    final second = await client.messages(
      account.id,
      'INBOX',
      limit: 4,
      cursor: first.cursor,
    );

    expect(first.hasMore, isTrue);
    expect(second.hasMore, isFalse);
    expect(
      [...first.items, ...second.items].map((m) => m.id).toSet(),
      hasLength(7),
    );
  });

  test('refuses a wrong password', () async {
    await expectLater(
      _client(
        FakeRestmail(),
      ).login(email: FakeAccounts.email, password: 'nope'),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'unauthorized'),
      ),
    );
  });

  test(
    'asks for a second factor, then takes a code or a recovery code',
    () async {
      final fake = FakeRestmail(scenario: FakeScenario.twoFactor);

      await expectLater(
        _client(
          fake,
        ).login(email: FakeAccounts.email, password: FakeAccounts.password),
        throwsA(isA<TotpRequiredException>()),
      );
      final withCode = _client(fake);
      await withCode.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
        totpCode: FakeAccounts.totpCode,
      );
      final withRecovery = _client(fake);
      await withRecovery.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
        recoveryCode: FakeAccounts.recoveryCode,
      );

      expect(withCode.tokens, isNotNull);
      expect(withRecovery.tokens, isNotNull);
    },
  );

  test('a stale access token is renewed without the caller noticing', () async {
    final fake = FakeRestmail();
    final client = await _signedIn(fake);
    final before = client.tokens!.refreshToken;

    fake.expireAccessTokens();

    expect(await client.accounts(), hasLength(1));
    expect(client.tokens!.refreshToken, isNot(before));
  });

  test('a revoked session ends', () async {
    final fake = FakeRestmail();
    final client = await _signedIn(fake);

    fake.revokeSessions();

    await expectLater(
      client.accounts(),
      throwsA(isA<SessionExpiredException>()),
    );
  });

  test('mail between its mailboxes arrives, and the stream hears it', () async {
    final fake = FakeRestmail();
    final dana = await _signedIn(fake);
    final other = await _signedIn(fake, email: FakeAccounts.otherEmail);
    final otherAccount = await _account(other);
    final live = Completer<void>();
    final events = <MailEvent>[];
    final subscription = other
        .events(
          otherAccount.id,
          onLiveChanged: (up) {
            if (up && !live.isCompleted) live.complete();
          },
        )
        .listen(events.add);
    await live.future;

    await dana.send(
      const OutgoingMessage(
        from: FakeAccounts.email,
        to: [FakeAccounts.otherEmail],
        subject: 'Hello from home',
        bodyText: 'Testing',
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(events.map((e) => e.type), contains(MailEventType.newMessage));
    final inbox = await other.messages(otherAccount.id, 'INBOX');
    expect(inbox.items.first.subject, 'Hello from home');
    expect(
      fake.messagesIn(FakeAccounts.email, 'Sent').map((m) => m.subject),
      contains('Hello from home'),
    );
    await subscription.cancel();
    fake.close();
  });

  test('delete moves to Trash; deleting from Trash removes it', () async {
    final fake = FakeRestmail();
    final client = await _signedIn(fake);
    final account = await _account(client);
    final message = (await client.messages(account.id, 'INBOX')).items.first;

    await client.deleteMessage(message.id);
    expect((await client.message(message.id)).folder, 'Trash');

    await client.deleteMessage(message.id);
    await expectLater(
      client.message(message.id),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
    );
  });

  test('search filters by words and by sender', () async {
    final client = await _signedIn(FakeRestmail());
    final account = await _account(client);

    final byWords = await client.search(
      account.id,
      const SearchQuery(text: 'latency'),
    );
    final bySender = await client.search(
      account.id,
      const SearchQuery(from: 'tom'),
    );

    expect(
      byWords.items.map((m) => m.subject),
      everyElement(contains('latency')),
    );
    expect(
      bySender.items.map((m) => m.sender),
      everyElement('tom@ryeworks.test'),
    );
  });

  test('drafts save, change and send', () async {
    final fake = FakeRestmail();
    final client = await _signedIn(fake);

    final draft = await client.saveDraft(
      const OutgoingMessage(from: FakeAccounts.email, subject: 'Half-written'),
    );
    await client.updateDraft(
      draft.id,
      const OutgoingMessage(
        from: FakeAccounts.email,
        to: ['tom@ryeworks.test'],
        subject: 'Finished',
      ),
    );
    await client.sendDraft(draft.id);

    expect(
      fake.messagesIn(FakeAccounts.email, 'Drafts').map((m) => m.id),
      isNot(contains(draft.id)),
    );
    expect(
      fake.messagesIn(FakeAccounts.email, 'Sent').map((m) => m.subject),
      contains('Finished'),
    );
  });

  test('linking another mailbox needs its password, once', () async {
    final client = await _signedIn(FakeRestmail());

    await expectLater(
      client.linkAccount(address: FakeAccounts.otherEmail, password: 'nope'),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'unauthorized'),
      ),
    );
    await client.linkAccount(
      address: FakeAccounts.otherEmail,
      password: FakeAccounts.password,
    );
    await expectLater(
      client.linkAccount(
        address: FakeAccounts.otherEmail,
        password: FakeAccounts.password,
      ),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 409)),
    );

    expect(await client.accounts(), hasLength(2));
  });

  test('discovery finds it by domain; any other host is unreachable', () async {
    final fake = FakeRestmail();

    expect(
      await discoverServer(FakeAccounts.email, httpClient: fake.client),
      _server,
    );
    await expectLater(
      RestmailClient(
        server: Uri.parse('https://elsewhere.test'),
        httpClient: fake.client,
      ).health(),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'network_error'),
      ),
    );
  });

  test('offline, it acts like a server that cannot be reached', () async {
    final fake = FakeRestmail();
    final client = await _signedIn(fake);

    fake.online = false;

    await expectLater(
      client.accounts(),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'network_error'),
      ),
    );
  });
}
