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

  test('revoking one address leaves the other sessions signed in', () async {
    final fake = FakeRestmail();
    final dana = await _signedIn(fake);
    final other = await _signedIn(fake, email: FakeAccounts.otherEmail);

    fake.revokeSessionsOf(FakeAccounts.email);

    await expectLater(dana.accounts(), throwsA(isA<SessionExpiredException>()));
    expect(await other.accounts(), hasLength(1));
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

  group('first start of a fresh install', () {
    const chosen = 'a passphrase only I know';

    test('the bootstrap admin owes a password and an authenticator', () async {
      final client = _client(FakeRestmail(scenario: FakeScenario.freshInstall));

      final admin = await client.signInAdmin(
        username: FakeAccounts.adminUsername,
        password: FakeAccounts.bootstrapPassword,
      );

      expect(admin.setupRequired, [SetupStep.password, SetupStep.twoFactor]);
      expect(admin.isSetUp, isFalse);
    });

    test('the admin API refuses a session still in setup', () async {
      final client = _client(FakeRestmail(scenario: FakeScenario.freshInstall));
      await client.signInAdmin(
        username: FakeAccounts.adminUsername,
        password: FakeAccounts.bootstrapPassword,
      );

      await expectLater(
        client.createDomain('example.test'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 403)
              .having((e) => e.code, 'code', 'setup_required'),
        ),
      );
    });

    test('a wrong current password is reported, not taken for an expired '
        'session', () async {
      final client = _client(FakeRestmail(scenario: FakeScenario.freshInstall));
      await client.signInAdmin(
        username: FakeAccounts.adminUsername,
        password: FakeAccounts.bootstrapPassword,
      );

      await expectLater(
        client.changePassword(current: 'not it at all', next: chosen),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 401)
              .having(
                (e) => e.message,
                'message',
                'Current password is incorrect',
              ),
        ),
      );
      // Still signed in, so the user can simply try again.
      expect(client.tokens, isNotNull);
    });

    test(
      'the whole setup, then a domain and a mailbox to sign in to',
      () async {
        final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
        final client = _client(fake);
        await client.signInAdmin(
          username: FakeAccounts.adminUsername,
          password: FakeAccounts.bootstrapPassword,
        );

        final enrollment = await client.enrollTwoFactor();
        expect(enrollment.otpauthUri.scheme, 'otpauth');
        expect(enrollment.recoveryCodes, isNotEmpty);
        await client.confirmTwoFactor(FakeAccounts.totpCode);

        await client.changePassword(
          current: FakeAccounts.bootstrapPassword,
          next: chosen,
        );
        // The server ended every session; so did the client.
        expect(client.tokens, isNull);
        expect(fake.adminPassword, chosen);

        // Signing in now takes a code as well.
        await expectLater(
          client.signInAdmin(
            username: FakeAccounts.adminUsername,
            password: chosen,
          ),
          throwsA(isA<TotpRequiredException>()),
        );
        final done = await client.signInAdmin(
          username: FakeAccounts.adminUsername,
          password: chosen,
          totpCode: FakeAccounts.totpCode,
        );
        expect(done.isSetUp, isTrue);

        await client.createDomain('example.test');
        await client.createMailbox(
          address: 'me@example.test',
          password: 'my mailbox password',
          displayName: 'Me',
        );
        expect(fake.hasMailbox('me@example.test'), isTrue);

        // And that mailbox is an ordinary account now.
        final mail = _client(fake);
        final result = await mail.login(
          email: 'me@example.test',
          password: 'my mailbox password',
        );
        expect(result.user.email, 'me@example.test');
      },
    );

    test('a domain already there is reported as such', () async {
      final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
      final client = _client(fake);
      await client.signInAdmin(
        username: FakeAccounts.adminUsername,
        password: FakeAccounts.bootstrapPassword,
      );
      await client.enrollTwoFactor();
      await client.confirmTwoFactor(FakeAccounts.totpCode);
      await client.changePassword(
        current: FakeAccounts.bootstrapPassword,
        next: chosen,
      );
      await client.signInAdmin(
        username: FakeAccounts.adminUsername,
        password: chosen,
        totpCode: FakeAccounts.totpCode,
      );

      await client.createDomain('example.test');
      await expectLater(
        client.createDomain('example.test'),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'already_exists'),
        ),
      );
      await expectLater(
        client.createMailbox(address: 'me@elsewhere.test', password: 'x'),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'domain_not_found'),
        ),
      );
    });
  });

  group('the admin API, by capability', () {
    Future<RestmailClient> admin(
      FakeRestmail fake, [
      String username = FakeAccounts.adminUsername,
    ]) async {
      final client = _client(fake);
      await client.signInAdmin(
        username: username,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      return client;
    }

    Matcher refused(String code) => throwsA(
      isA<ApiException>()
          .having((e) => e.statusCode, 'status', 403)
          .having((e) => e.code, 'code', code),
    );

    test('a superadmin holds * and may do everything', () async {
      final fake = FakeRestmail();
      final client = await admin(fake);

      expect(client.tokens!.capabilities.names, {'*'});
      final queue = await client.queue();
      expect(queue.total, 4);
      final deferred = queue.items.firstWhere(
        (e) => e.status == QueueStatus.deferred,
      );
      await client.retryQueueEntry(deferred.id);
      expect(
        (await client.queueEntry(deferred.id)).status,
        QueueStatus.pending,
      );

      await client.createDomain('new.test');
      await client.createAlias(
        source: 'sales@new.test',
        destination: FakeAccounts.email,
      );
      expect((await client.aliases()).items.map((a) => a.source), [
        'hello@${FakeAccounts.host}',
        'sales@new.test',
      ]);
      expect((await client.mailboxes()).total, 2);
    });

    test('queue:read reads the queue and nothing else', () async {
      final fake = FakeRestmail();
      final client = await admin(fake, FakeAccounts.queueWatcher);

      expect(client.tokens!.capabilities.names, {'queue:read'});
      final entry = (await client.queue()).items.first;
      expect((await client.queueStats()).total, 4);
      await expectLater(client.retryQueueEntry(entry.id), refused('forbidden'));
      await expectLater(
        client.deleteQueueEntry(entry.id),
        refused('forbidden'),
      );
      await expectLater(client.domains(), refused('forbidden'));
      await expectLater(client.mailboxes(), refused('forbidden'));
      expect(fake.queue, hasLength(4));
    });

    test('write without delete edits but cannot delete', () async {
      final fake = FakeRestmail()
        ..addAdmin(
          'editor',
          capabilities: {'mailboxes:read', 'mailboxes:write'},
        );
      final client = await admin(fake, 'editor');

      final alias = (await client.aliases()).items.single;
      await client.updateAlias(alias.id, active: false);
      expect(fake.aliases.single.active, isFalse);
      await expectLater(client.deleteAlias(alias.id), refused('forbidden'));
      expect(fake.aliases, hasLength(1));
    });

    test('a mailbox session is refused', () async {
      final client = await _signedIn(FakeRestmail());

      expect(client.tokens!.capabilities.isEmpty, isTrue);
      await expectLater(client.queue(), refused('forbidden'));
    });

    test('a grant taken away goes at the next refresh', () async {
      final fake = FakeRestmail();
      final client = await admin(fake);
      fake.grant(FakeAccounts.adminUsername, {'queue:read'});

      // The access token keeps what it was minted with...
      await client.domains();
      // ...until it is renewed.
      fake.expireAccessTokens();
      await expectLater(client.domains(), refused('forbidden'));
      expect(client.tokens!.capabilities.names, {'queue:read'});
    });
  });
}
