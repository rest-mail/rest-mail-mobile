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

  test('linking another mailbox needs its password, once, and unlinking '
      'gives it up', () async {
    final client = await _signedIn(FakeRestmail());
    final session = client.tokens?.accessToken;

    // A wrong password is 403: this session is not renewed for it.
    await expectLater(
      client.linkAccount(address: FakeAccounts.otherEmail, password: 'nope'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 403)
            .having((e) => e.code, 'code', 'invalid_credentials'),
      ),
    );
    expect(client.tokens?.accessToken, session);
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

    final accounts = await client.accounts();
    expect(accounts.map((a) => a.address), [
      FakeAccounts.email,
      FakeAccounts.otherEmail,
    ]);
    await client.unlinkAccount(accounts.last.id);
    expect(await client.accounts(), hasLength(1));
    await expectLater(
      client.unlinkAccount(accounts.first.id),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'own_account')),
    );
  });

  test(
    'linking an account with two-factor authentication takes its code',
    () async {
      final fake = FakeRestmail()..enableTwoFactor(FakeAccounts.otherEmail);
      final client = await _signedIn(fake);
      final session = client.tokens?.accessToken;

      // A missing or wrong code is 403: this session is not renewed for it.
      await expectLater(
        client.linkAccount(
          address: FakeAccounts.otherEmail,
          password: FakeAccounts.password,
        ),
        throwsA(
          isA<TotpRequiredException>().having(
            (e) => e.statusCode,
            'status',
            403,
          ),
        ),
      );
      await expectLater(
        client.linkAccount(
          address: FakeAccounts.otherEmail,
          password: FakeAccounts.password,
          totpCode: '000000',
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 403)
              .having((e) => e.code, 'code', 'invalid_totp'),
        ),
      );
      expect(client.tokens?.accessToken, session);
      await client.linkAccount(
        address: FakeAccounts.otherEmail,
        password: FakeAccounts.password,
        totpCode: FakeAccounts.totpCode,
      );
      expect(fake.ownedBy(FakeAccounts.email), [FakeAccounts.otherEmail]);
    },
  );

  group('creating an account', () {
    Future<RestmailClient> admin(FakeRestmail fake) async {
      final client = _client(fake);
      await client.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      return client;
    }

    test(
      'with no password, owned by its creator, listed and sendable',
      () async {
        final fake = FakeRestmail();
        final client = await admin(fake);

        final chris = await client.createAccount(
          address: 'chris@${FakeAccounts.host}',
          displayName: 'Chris',
        );
        expect(chris.isPrimary, isFalse);
        expect(fake.passwordOf(chris.address), isNull);
        expect((await client.accounts()).map((a) => a.address), [
          FakeAccounts.adminEmail,
          'chris@${FakeAccounts.host}',
        ]);
        expect(fake.auditLog.last.action, 'accounts.create');

        // Its owner sends as it, and reads its mail.
        await client.send(
          const OutgoingMessage(
            from: 'chris@${FakeAccounts.host}',
            to: [FakeAccounts.email],
            subject: 'Hello from Chris',
            bodyText: 'Hi',
          ),
        );
        expect(
          fake.messagesIn('chris@${FakeAccounts.host}', 'Sent'),
          hasLength(1),
        );
        fake.deliver(
          to: 'chris@${FakeAccounts.host}',
          from: 'tom@ryeworks.test',
          subject: 'Hi Chris',
        );
        final inbox = await client.messages(chris.id, StandardFolder.inbox);
        expect(inbox.items.single.subject, 'Hi Chris');

        // Nobody signs in to it.
        await expectLater(
          _client(fake).login(email: chris.address, password: ''),
          throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'unauthorized'),
          ),
        );
      },
    );

    test('403 without mailboxes:write, 409 for an address taken, 422 for a '
        'domain not hosted', () async {
      final fake = FakeRestmail();
      final client = await admin(fake);

      await expectLater(
        client.createAccount(address: FakeAccounts.email),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 409)),
      );
      await expectLater(
        client.createAccount(address: 'someone@nowhere.test'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 422)
              .having(
                (e) => e.fields['address'],
                'field',
                'this server does not host nowhere.test',
              ),
        ),
      );
      await expectLater(
        client.createAccount(
          address: 'pat@${FakeAccounts.host}',
          password: 'short',
        ),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 422)),
      );

      final dana = await _signedIn(fake);
      await expectLater(
        dana.createAccount(address: 'pat@${FakeAccounts.host}'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(fake.hasMailbox('pat@${FakeAccounts.host}'), isFalse);
    });
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

    test('the bootstrap account owes a password and an authenticator, and '
        'signs in by its address only', () async {
      final client = _client(FakeRestmail(scenario: FakeScenario.freshInstall));

      final admin = await client.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.bootstrapPassword,
      );

      expect(admin.setupRequired, [SetupStep.password, SetupStep.twoFactor]);
      expect(admin.isSetUp, isFalse);
      expect(admin.tokens.capabilities.isEmpty, isTrue);
      await expectLater(
        client.accounts(),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'setup_required'),
        ),
      );
    });

    test('the admin API refuses a session still in setup', () async {
      final client = _client(FakeRestmail(scenario: FakeScenario.freshInstall));
      await client.login(
        email: FakeAccounts.adminEmail,
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
      await client.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.bootstrapPassword,
      );

      await expectLater(
        client.changePassword(current: 'not it at all', next: chosen),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 403)
              .having((e) => e.code, 'code', 'invalid_password')
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
      'the whole setup, then the account is an administrator with mail',
      () async {
        final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
        final client = _client(fake);
        await client.login(
          email: FakeAccounts.adminEmail,
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
        expect(fake.passwordOf(FakeAccounts.adminEmail), chosen);

        // Signing in now takes a code as well.
        await expectLater(
          client.login(email: FakeAccounts.adminEmail, password: chosen),
          throwsA(isA<TotpRequiredException>()),
        );
        final done = await client.login(
          email: FakeAccounts.adminEmail,
          password: chosen,
          totpCode: FakeAccounts.totpCode,
        );
        expect(done.isSetUp, isTrue);

        expect(
          done.tokens.capabilities.allows(Capability.mailboxesWrite),
          isTrue,
        );
        final accounts = await client.accounts();
        expect(accounts.single.address, FakeAccounts.adminEmail);
        await client.createDomain('example.test');
      },
    );

    test('a domain already there is reported as such', () async {
      final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
      final client = _client(fake);
      await client.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.bootstrapPassword,
      );
      await client.enrollTwoFactor();
      await client.confirmTwoFactor(FakeAccounts.totpCode);
      await client.changePassword(
        current: FakeAccounts.bootstrapPassword,
        next: chosen,
      );
      await client.login(
        email: FakeAccounts.adminEmail,
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
    });
  });

  group('the admin API, by capability', () {
    Future<RestmailClient> admin(
      FakeRestmail fake, [
      String email = FakeAccounts.adminEmail,
    ]) async {
      final client = _client(fake);
      await client.login(
        email: email,
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
      expect((await client.mailboxes()).total, 4);
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
        ..addAccount(
          'editor@${FakeAccounts.host}',
          capabilities: {'mailboxes:read', 'mailboxes:write'},
        );
      final client = await admin(fake, 'editor@${FakeAccounts.host}');

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

    test('bans need bans:*', () async {
      final fake = FakeRestmail();
      final watcher = await admin(fake, FakeAccounts.queueWatcher);
      await expectLater(watcher.bans(), refused('forbidden'));

      final superadmin = await admin(fake);
      await superadmin.createBan(
        ip: '198.51.100.4',
        createdBy: 'admin',
        duration: const Duration(days: 1),
      );
      final bans = (await superadmin.bans()).items;
      expect(bans.map((b) => b.ip), ['198.51.100.4', '203.0.113.7']);
      expect(bans.first.expiresAt, isNotNull);
      await superadmin.deleteBan(bans.first.id);
      expect(fake.bans.single.ip, '203.0.113.7');
    });

    test('a grant taken away goes at the next refresh', () async {
      final fake = FakeRestmail();
      final client = await admin(fake);
      fake.grant(FakeAccounts.adminEmail, {'queue:read'});

      // The access token keeps what it was minted with...
      await client.domains();
      // ...until it is renewed.
      fake.expireAccessTokens();
      await expectLater(client.domains(), refused('forbidden'));
      expect(client.tokens!.capabilities.names, {'queue:read'});
    });

    test('logs, traces and reports each need their own capability', () async {
      final fake = FakeRestmail()
        ..addAccount(
          'postmaster@${FakeAccounts.host}',
          capabilities: {'messages:read'},
        );
      final client = await admin(fake, 'postmaster@${FakeAccounts.host}');

      final log = await client.deliveryLog();
      expect(log.total, 4);
      expect(log.items.first.recipient, 'ana@harbor.test');
      expect(
        (await client.deliveryLog(
          status: QueueStatus.bounced,
        )).items.map((e) => e.recipient),
        ['nobody@ryeworks.test'],
      );
      final messageId = log.items.first.messageId!;
      await expectLater(client.messageTrace(messageId), refused('forbidden'));
      await expectLater(client.tlsReports(), refused('forbidden'));
      await expectLater(client.audit(), refused('forbidden'));
      await expectLater(client.verifyAudit(), refused('forbidden'));

      final superadmin = await admin(fake);
      final trace = await superadmin.messageTrace(messageId);
      expect(trace.direction, 'outbound');
      expect(trace.rcptTo, 'ana@harbor.test');
      expect(trace.stages.map((s) => s.filter), [
        'sender_verify',
        'header_cleanup',
        'dkim_sign',
      ]);
      await expectLater(
        superadmin.messageTrace(999999),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
      final reports = (await superadmin.tlsReports()).items;
      expect(reports.map((r) => r.failed), [0, 3]);
      expect(reports.last.failureDetails, isA<List<Object?>>());
    });

    test('the audit log reads newest first a page at a time, filters, and '
        'its chain shows tampering', () async {
      final fake = FakeRestmail();
      final client = await admin(fake);

      final first = await client.audit();
      expect(first.items, hasLength(50));
      expect(first.hasMore, isTrue);
      // The sign-in just made is the newest.
      expect(first.items.first.action, 'auth.sign_in');
      expect(first.items.first.actorName, FakeAccounts.adminEmail);
      final seqs = first.items.map((e) => e.seq).toList();
      expect(seqs, [...seqs]..sort((a, b) => b.compareTo(a)));

      final second = await client.audit(before: first.cursor);
      expect(second.items.first.seq, seqs.last - 1);
      expect(second.hasMore, isFalse);

      final denied = await client.audit(outcome: 'denied');
      expect(denied.items, isNotEmpty);
      expect(denied.items.every((e) => e.outcome == 'denied'), isTrue);

      // Reading it is recorded too.
      expect(fake.auditLog.last.action, 'audit.read');

      final check = await client.verifyAudit();
      expect(check.ok, isTrue);
      expect(check.checked, fake.auditLog.length - 1);
      expect(check.brokenAtSeq, isNull);

      fake.tamperWithAudit(12);
      final broken = await client.verifyAudit();
      expect(broken.ok, isFalse);
      expect(broken.brokenAtSeq, 12);
      expect(broken.checked, 11);
      expect(broken.reason, isNotEmpty);
    });

    test('a change is audited with how it went, refused or not', () async {
      final fake = FakeRestmail();
      final watcher = await admin(fake, FakeAccounts.queueWatcher);
      final entry = (await watcher.queue()).items.first;
      await expectLater(
        watcher.retryQueueEntry(entry.id),
        refused('forbidden'),
      );

      final last = fake.auditLog.last;
      expect(last.action, 'admin.change');
      expect(last.actorName, FakeAccounts.queueWatcher);
      expect(last.outcome, 'denied');
      expect(last.status, 403);
    });

    test('DKIM keys and certificates are read with domains:read, and '
        'removed with domains:write, as the server asks', () async {
      final fake = FakeRestmail()
        ..addAccount(
          'deleter@${FakeAccounts.host}',
          capabilities: {'domains:read', 'domains:delete'},
        )
        ..addAccount(
          'writer@${FakeAccounts.host}',
          capabilities: {'domains:read', 'domains:write'},
        );
      final deleter = await admin(fake, 'deleter@${FakeAccounts.host}');

      final keys = await deleter.dkimKeys();
      expect(keys.map((k) => k.domain), contains(FakeAccounts.host));
      final key = keys.firstWhere((k) => k.domain == FakeAccounts.host);
      expect(key.selector, 'mail');
      final certificates = (await deleter.certificates()).items;
      expect(certificates.first.domain, isNotEmpty);
      await expectLater(
        deleter.deleteDkimKey(key.domainId),
        refused('forbidden'),
      );
      await expectLater(
        deleter.deleteCertificate(certificates.first.id),
        refused('forbidden'),
      );

      final writer = await admin(fake, 'writer@${FakeAccounts.host}');
      await writer.deleteDkimKey(key.domainId);
      await writer.deleteCertificate(certificates.first.id);
      expect(
        (await writer.dkimKeys()).map((k) => k.domain),
        isNot(contains(FakeAccounts.host)),
      );
      expect(fake.certificates, hasLength(certificates.length - 1));
    });

    test('pipelines and custom filters need pipelines:*', () async {
      final fake = FakeRestmail()
        ..addAccount(
          'reader@${FakeAccounts.host}',
          capabilities: {'pipelines:read'},
        )
        ..addAccount(
          'editor@${FakeAccounts.host}',
          capabilities: {'pipelines:read', 'pipelines:write'},
        );
      final reader = await admin(fake, 'reader@${FakeAccounts.host}');
      final pipelines = (await reader.pipelines()).items;
      expect(pipelines.map((p) => p.direction), ['inbound', 'outbound']);
      expect(pipelines.first.filters.first.name, 'size_check');
      final filter = (await reader.customFilters()).items.single;
      expect(filter.config, isA<Map<String, Object?>>());
      await expectLater(
        reader.updatePipeline(pipelines.first.id, active: false),
        refused('forbidden'),
      );

      final editor = await admin(fake, 'editor@${FakeAccounts.host}');
      expect(
        (await editor.updatePipeline(pipelines.first.id, active: false)).active,
        isFalse,
      );
      await editor.updateCustomFilter(filter.id, enabled: false);
      expect(fake.customFilters.single.enabled, isFalse);
      await expectLater(
        editor.deletePipeline(pipelines.first.id),
        refused('forbidden'),
      );
      await expectLater(
        editor.deleteCustomFilter(filter.id),
        refused('forbidden'),
      );

      final superadmin = await admin(fake);
      await superadmin.deletePipeline(pipelines.first.id);
      await superadmin.deleteCustomFilter(filter.id);
      expect(fake.pipelines, hasLength(1));
      expect(fake.customFilters, isEmpty);
    });

    test('the pipeline log needs pipelines:read, and its analytics '
        'observability:read', () async {
      final fake = FakeRestmail()
        ..addAccount(
          'reader@${FakeAccounts.host}',
          capabilities: {'pipelines:read'},
        )
        ..addAccount(
          'watcher@${FakeAccounts.host}',
          capabilities: {'observability:read'},
        );
      final reader = await admin(fake, 'reader@${FakeAccounts.host}');

      final log = await reader.pipelineLog();
      final times = log.items.map((t) => t.createdAt).toList();
      expect(times, [...times]..sort((a, b) => b.compareTo(a)));
      final rejected = await reader.pipelineLog(outcome: 'rejected');
      expect(rejected.items.map((t) => t.mailFrom), [
        'promo@deals.test',
        'billing@paypa1.test',
        'news@deals.test',
      ]);
      // Mail turned away never became a message.
      expect(rejected.items.every((t) => t.messageId == null), isTrue);
      expect(rejected.items.first.reasonCode, 'spam_threshold');
      expect(
        (await reader.pipelineLog(direction: 'outbound')).items,
        hasLength(4),
      );
      await expectLater(reader.pipelineAnalytics(), refused('forbidden'));

      final watcher = await admin(fake, 'watcher@${FakeAccounts.host}');
      await expectLater(watcher.pipelineLog(), refused('forbidden'));
      final day = await watcher.pipelineAnalytics();
      expect(day.until.difference(day.since), const Duration(days: 1));
      expect(day.rejectReasons, [(reason: 'spam_threshold', count: 1)]);
      final week = await watcher.pipelineAnalytics(
        window: const Duration(days: 7),
      );
      expect(week.rejectReasons.map((r) => r.reason), [
        'custom_reject',
        'dmarc_reject',
        'spam_threshold',
      ]);
      expect(
        week.outcomes,
        contains((direction: 'inbound', outcome: 'quarantined', count: 1)),
      );
      expect(
        week.senderChecks,
        contains((mechanism: 'dmarc', result: 'fail', count: 1)),
      );
      expect(week.received.map((r) => r.transport), ['plaintext', 'tls']);
    });

    test('sender lists are read with domains:read, and changed with '
        'domains:write, as the server asks', () async {
      final fake = FakeRestmail()
        ..addAccount(
          'deleter@${FakeAccounts.host}',
          capabilities: {'domains:read', 'domains:delete'},
        )
        ..addAccount(
          'writer@${FakeAccounts.host}',
          capabilities: {'domains:read', 'domains:write'},
        );
      final deleter = await admin(fake, 'deleter@${FakeAccounts.host}');
      final domain = (await deleter.domains()).items.firstWhere(
        (d) => d.name == FakeAccounts.host,
      );

      final blocked = await deleter.senderRules(domain.id, SenderList.block);
      expect(blocked.map((r) => (r.pattern, r.reason)), [
        ('@deals.test', 'Sends spam'),
      ]);
      expect(
        (await deleter.senderRules(domain.id, SenderList.allow)).single.pattern,
        'ana@harbor.test',
      );
      await expectLater(
        deleter.addSenderRule(domain.id, SenderList.block, pattern: '@x.test'),
        refused('forbidden'),
      );
      await expectLater(
        deleter.removeSenderRule(domain.id, SenderList.block, blocked.first.id),
        refused('forbidden'),
      );

      final writer = await admin(fake, 'writer@${FakeAccounts.host}');
      await writer.addSenderRule(
        domain.id,
        SenderList.block,
        pattern: 'spam@x.test',
        reason: 'Phishing',
      );
      expect(
        (await writer.senderRules(
          domain.id,
          SenderList.block,
        )).map((r) => r.pattern),
        ['spam@x.test', '@deals.test'],
      );
      // The server's unique index refuses the same sender twice.
      await expectLater(
        writer.addSenderRule(
          domain.id,
          SenderList.block,
          pattern: '@deals.test',
        ),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 500)),
      );
      // A rule is removed only from the list it is on.
      await expectLater(
        writer.removeSenderRule(domain.id, SenderList.allow, blocked.first.id),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
      await writer.removeSenderRule(
        domain.id,
        SenderList.block,
        blocked.first.id,
      );
      expect(fake.senderRules.map((r) => r.pattern), [
        'ana@harbor.test',
        'spam@x.test',
      ]);
    });

    test('an MTA-STS policy is read with domains:read, and set and deleted '
        'with domains:write', () async {
      final fake = FakeRestmail()
        ..addAccount(
          'reader@${FakeAccounts.host}',
          capabilities: {'domains:read'},
        )
        ..addAccount(
          'writer@${FakeAccounts.host}',
          capabilities: {'domains:read', 'domains:write'},
        );
      final reader = await admin(fake, 'reader@${FakeAccounts.host}');
      final domains = (await reader.domains()).items;
      final host = domains.firstWhere((d) => d.name == FakeAccounts.host);
      final other = domains.firstWhere((d) => d.name != FakeAccounts.host);

      final policy = (await reader.mtaStsPolicy(host.id))!;
      expect(policy.mode, MtaStsMode.testing);
      expect(policy.mxHosts, ['mx.${FakeAccounts.host}']);
      expect(policy.maxAge, const Duration(days: 7));
      expect(policy.active, isTrue);
      expect(await reader.mtaStsPolicy(other.id), isNull);
      await expectLater(
        reader.setMtaStsPolicy(other.id, mode: MtaStsMode.enforce),
        refused('forbidden'),
      );
      await expectLater(
        reader.deleteMtaStsPolicy(host.id),
        refused('forbidden'),
      );

      final writer = await admin(fake, 'writer@${FakeAccounts.host}');
      final made = await writer.setMtaStsPolicy(
        other.id,
        mode: MtaStsMode.enforce,
        mxHosts: ['mx.${FakeAccounts.host}', '*.oakline.test'],
        maxAge: const Duration(days: 1),
      );
      expect(made.mxHosts, hasLength(2));
      // What is left out stays as it was.
      final off = await writer.setMtaStsPolicy(other.id, active: false);
      expect(
        (off.mode, off.active, off.maxAge),
        (MtaStsMode.enforce, false, const Duration(days: 1)),
      );
      await writer.deleteMtaStsPolicy(other.id);
      expect(await writer.mtaStsPolicy(other.id), isNull);
      await expectLater(
        writer.deleteMtaStsPolicy(other.id),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    });

    test(
      'the DNS check needs domains:read, and says what is missing',
      () async {
        final fake = FakeRestmail()
          ..addAccount(
            'reader@${FakeAccounts.host}',
            capabilities: {'domains:read'},
          );
        final reader = await admin(fake, 'reader@${FakeAccounts.host}');
        final domains = (await reader.domains()).items;
        final host = domains.firstWhere((d) => d.name == FakeAccounts.host);
        final other = domains.firstWhere((d) => d.name != FakeAccounts.host);

        final full = await reader.dnsCheck(host.id);
        expect(full.records.map((r) => r.type), [
          'MX',
          'SPF',
          'DMARC',
          'DKIM',
          'MTA-STS',
          'TLS-RPT',
        ]);
        expect(full.records.every((r) => r.ok), isTrue);
        expect(full.summary, '6/6 records verified');
        final half = await reader.dnsCheck(other.id);
        expect(half.records.where((r) => r.ok).map((r) => r.type), [
          'MX',
          'SPF',
        ]);
        expect(
          half.records.firstWhere((r) => r.type == 'DMARC').message,
          'No DMARC record found',
        );

        final watcher = await admin(fake, FakeAccounts.queueWatcher);
        await expectLater(watcher.dnsCheck(host.id), refused('forbidden'));
      },
    );
  });

  group('app passwords', () {
    Matcher refused(int status, String code) => throwsA(
      isA<ApiException>()
          .having((e) => e.statusCode, 'status', status)
          .having((e) => e.code, 'code', code),
    );

    test('made with the current password, shown once, listed without its '
        'secret, and stopped at once by revoking', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final account = await _account(client);

      final created = await client.createAppPassword(
        account.id,
        name: '  iPhone Mail ',
        password: FakeAccounts.password,
      );
      final secret = created.secret!;

      expect(secret, matches(RegExp(r'^rm_[A-Za-z0-9]{12}_[A-Za-z0-9]{43}$')));
      expect(secret, startsWith('rm_${created.appPassword.publicId}_'));
      expect(created.appPassword.name, 'iPhone Mail');
      final listed = (await client.appPasswords(account.id)).single;
      expect(listed.publicId, created.appPassword.publicId);
      expect(listed.lastUsedAt, isNull);

      // A mail client signs in with it, and the list hears of it.
      expect(fake.acceptsAppPassword(FakeAccounts.email, secret), isTrue);
      expect(fake.acceptsAppPassword(FakeAccounts.otherEmail, secret), isFalse);
      expect(
        (await client.appPasswords(account.id)).single.lastUsedAt,
        isNotNull,
      );

      await client.revokeAppPassword(account.id, listed.id);
      expect(fake.acceptsAppPassword(FakeAccounts.email, secret), isFalse);
      expect(await client.appPasswords(account.id), isEmpty);
      expect(fake.appPasswordsOf(FakeAccounts.email).single.isRevoked, isTrue);
      await expectLater(
        client.revokeAppPassword(account.id, listed.id),
        refused(404, 'not_found'),
      );
    });

    test('a missing or wrong password is refused, makes nothing, and leaves '
        'the session as it was', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final account = await _account(client);
      final tokens = client.tokens;

      await expectLater(
        client.createAppPassword(account.id, name: 'Mail', password: ''),
        refused(403, 'reauth_required'),
      );
      await expectLater(
        client.createAppPassword(account.id, name: 'Mail', password: 'nope'),
        refused(403, 'invalid_password'),
      );

      expect(fake.appPasswordsOf(FakeAccounts.email), isEmpty);
      expect(client.tokens, same(tokens));
      expect(await client.appPasswords(account.id), isEmpty);
      // Both recorded as refused, and neither holds the password.
      final refusals = fake.auditLog.where(
        (e) => e.action == 'credentials.create',
      );
      expect(refusals.map((e) => (e.outcome, e.status)), [
        ('denied', 403),
        ('denied', 403),
      ]);
      expect(refusals.map((e) => e.content).join(), isNot(contains('nope')));
    });

    test('a mailbox with two-factor authentication needs a session that '
        'took the code', () async {
      final fake = FakeRestmail();
      final before = await _signedIn(fake);
      final account = await _account(before);
      fake.enableTwoFactor(FakeAccounts.email);

      await expectLater(
        before.createAppPassword(
          account.id,
          name: 'Mail',
          password: FakeAccounts.password,
        ),
        refused(403, 'two_factor_required'),
      );

      final withCode = _client(fake);
      await withCode.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
        totpCode: FakeAccounts.totpCode,
      );
      // A refresh keeps the mark.
      fake.expireAccessTokens();
      final created = await withCode.createAppPassword(
        account.id,
        name: 'Mail',
        password: FakeAccounts.password,
      );
      expect(created.secret, isNotNull);
    });

    test('for an account it owns too, with its own password; never for one '
        'it does not', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final linked = await client.linkAccount(
        address: FakeAccounts.otherEmail,
        password: FakeAccounts.password,
      );

      final made = await client.createAppPassword(
        linked.id,
        name: 'Mail',
        password: FakeAccounts.password,
      );
      expect(
        fake.acceptsAppPassword(FakeAccounts.otherEmail, made.secret!),
        isTrue,
      );
      expect(await client.appPasswords(linked.id), hasLength(1));

      final adminId = (await _client(fake).login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      )).user.id;
      await expectLater(
        client.appPasswords(adminId),
        refused(404, 'not_found'),
      );
    });

    test('names and expiry are checked as the server checks them', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final account = await _account(client);

      Future<NewAppPassword> create(String name, [DateTime? expiresAt]) =>
          client.createAppPassword(
            account.id,
            name: name,
            password: FakeAccounts.password,
            expiresAt: expiresAt,
          );

      await expectLater(create('  '), refused(422, 'validation_failed'));
      await expectLater(create('x' * 101), refused(422, 'validation_failed'));
      await expectLater(create('a\nb'), refused(422, 'validation_failed'));
      await expectLater(
        create('Mail', DateTime.now().subtract(const Duration(minutes: 1))),
        refused(422, 'validation_failed'),
      );

      final later = DateTime.now().add(const Duration(days: 30));
      final created = await create('Mail', later);
      expect(
        created.appPassword.expiresAt?.millisecondsSinceEpoch,
        later.millisecondsSinceEpoch,
      );
    });

    test('an expired one is listed but no longer let in', () async {
      var now = DateTime(2026, 10, 17, 9);
      final fake = FakeRestmail(clock: () => now);
      final client = await _signedIn(fake);
      final account = await _account(client);
      final created = await client.createAppPassword(
        account.id,
        name: 'Mail',
        password: FakeAccounts.password,
        expiresAt: now.add(const Duration(days: 1)),
      );

      now = now.add(const Duration(days: 2));
      fake.expireAccessTokens();

      expect(
        fake.acceptsAppPassword(FakeAccounts.email, created.secret!),
        isFalse,
      );
      expect(
        (await client.appPasswords(account.id)).single.isExpiredAt(now),
        isTrue,
      );
    });

    test('a new password for the mailbox revokes them all', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final account = await _account(client);
      final created = await client.createAppPassword(
        account.id,
        name: 'Mail',
        password: FakeAccounts.password,
      );
      final admin = _client(fake);
      await admin.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );

      final box = (await admin.mailboxes()).items.firstWhere(
        (b) => b.address == FakeAccounts.email,
      );
      await admin.updateMailbox(box.id, password: 'a new password here');

      expect(
        fake.acceptsAppPassword(FakeAccounts.email, created.secret!),
        isFalse,
      );
    });

    test('shares sign-in\'s budget: a 429 with the wait', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final account = await _account(client);
      fake.throttleSignIns(const Duration(seconds: 30));

      await expectLater(
        client.createAppPassword(
          account.id,
          name: 'Mail',
          password: FakeAccounts.password,
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 429)
              .having(
                (e) => e.retryAfter,
                'retryAfter',
                const Duration(seconds: 30),
              ),
        ),
      );
      await expectLater(
        _client(
          fake,
        ).login(email: FakeAccounts.email, password: FakeAccounts.password),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 's', 429)),
      );
    });
  });

  group('push devices', () {
    final token = 'ab' * 32;

    test('registered once per session, listed, and removed', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);

      final first = await client.registerPushDevice(
        platform: PushPlatform.apns,
        token: token,
        environment: ApnsEnvironment.sandbox,
      );
      final again = await client.registerPushDevice(
        platform: PushPlatform.apns,
        token: token,
        environment: ApnsEnvironment.sandbox,
      );
      final listed = await client.pushDevices();

      expect(again.id, first.id);
      expect(listed.platforms, {PushPlatform.apns});
      expect([for (final d in listed.devices) d.id], [first.id]);
      expect(fake.devicesOf(FakeAccounts.email).single.token, token);

      await client.removePushDevice(first.id);
      expect(fake.devicesOf(FakeAccounts.email), isEmpty);
      await expectLater(
        client.removePushDevice(first.id),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 's', 404)),
      );
    });

    test('a device goes with its session: signing out removes it', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      await client.registerPushDevice(
        platform: PushPlatform.apns,
        token: token,
      );
      // Another session on the same phone keeps its own.
      final other = await _signedIn(fake, email: FakeAccounts.otherEmail);
      await other.registerPushDevice(platform: PushPlatform.apns, token: token);

      await client.logout();

      expect(fake.devicesOf(FakeAccounts.email), isEmpty);
      expect(fake.devicesOf(FakeAccounts.otherEmail), hasLength(1));
    });

    test('new mail pushes the account and its unread count, and nothing of '
        'the message', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final account = await _account(client);
      final device = await client.registerPushDevice(
        platform: PushPlatform.apns,
        token: token,
      );

      fake.deliver(
        to: FakeAccounts.email,
        from: 'nadia@example.test',
        fromName: 'Nadia Osei',
        subject: 'Quarterly numbers',
        body: 'The figures are attached.',
      );

      final push = fake.pushes.single;
      expect(push.token, token);
      final unread = (await client.folders(
        account.id,
      )).firstWhere((f) => f.name == StandardFolder.inbox).unread;
      expect(push.payload, {
        'aps': {'content-available': 1},
        'restmail': {
          'v': 1,
          'device': device.id,
          'account': account.id,
          'unread': unread,
        },
      });
      final everything = '${push.payload}';
      for (final secret in ['Nadia', 'nadia@', 'Quarterly', 'figures']) {
        expect(everything, isNot(contains(secret)));
      }
    });

    test('a server without push has no route for devices', () async {
      final client = await _signedIn(FakeRestmail(pushPlatforms: const {}));

      await expectLater(
        client.pushDevices(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 's', 404)),
      );
    });

    test('refuses a platform it has no credentials for', () async {
      final client = await _signedIn(FakeRestmail());

      await expectLater(
        client.registerPushDevice(platform: PushPlatform.fcm, token: 'x'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 422)
              .having((e) => e.code, 'c', 'validation_failed'),
        ),
      );
    });
  });
}
