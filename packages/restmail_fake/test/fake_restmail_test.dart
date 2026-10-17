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

    test(
      'a role changed on an admin ends its sessions, as on the server',
      () async {
        final fake = FakeRestmail();
        final superadmin = await admin(fake);
        final watcher = await admin(fake, FakeAccounts.queueWatcher);
        final roles = await superadmin.roles();
        final users = (await superadmin.adminUsers()).items;
        final target = users.firstWhere(
          (u) => u.username == FakeAccounts.queueWatcher,
        );

        await superadmin.updateAdminUser(
          target.id,
          roleIds: [roles.firstWhere((r) => r.name == 'readonly').id],
        );

        expect(fake.rolesOf(FakeAccounts.queueWatcher), ['readonly']);
        fake.expireAccessTokens();
        await expectLater(
          watcher.queue(),
          throwsA(isA<SessionExpiredException>()),
        );
      },
    );

    test('an admin made by another signs in with its password alone, and '
        'may do what its roles say', () async {
      final fake = FakeRestmail();
      final superadmin = await admin(fake);
      final readonly = (await superadmin.roles()).firstWhere(
        (r) => r.name == 'readonly',
      );
      await superadmin.createAdminUser(
        username: 'ops',
        password: 'ops password',
        roleIds: [readonly.id],
      );

      final ops = _client(fake);
      final signedIn = await ops.signInAdmin(
        username: 'ops',
        password: 'ops password',
      );
      expect(signedIn.isSetUp, isTrue);
      expect(signedIn.capabilities.allows(Capability.domainsRead), isTrue);
      await ops.domains();
      await expectLater(ops.createDomain('x.test'), refused('forbidden'));
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
      fake.grant(FakeAccounts.adminUsername, {'queue:read'});

      // The access token keeps what it was minted with...
      await client.domains();
      // ...until it is renewed.
      fake.expireAccessTokens();
      await expectLater(client.domains(), refused('forbidden'));
      expect(client.tokens!.capabilities.names, {'queue:read'});
    });

    test('logs, traces and reports each need their own capability', () async {
      final fake = FakeRestmail()
        ..addAdmin('postmaster', capabilities: {'messages:read'});
      final client = await admin(fake, 'postmaster');

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
      await expectLater(client.activityLog(), refused('forbidden'));
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
      expect(
        (await superadmin.activityLog()).items.first.detail,
        contains('203.0.113.7'),
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
      expect(first.items.first.actorName, FakeAccounts.adminUsername);
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
        ..addAdmin('deleter', capabilities: {'domains:read', 'domains:delete'})
        ..addAdmin('writer', capabilities: {'domains:read', 'domains:write'});
      final deleter = await admin(fake, 'deleter');

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

      final writer = await admin(fake, 'writer');
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
        ..addAdmin('reader', capabilities: {'pipelines:read'})
        ..addAdmin(
          'editor',
          capabilities: {'pipelines:read', 'pipelines:write'},
        );
      final reader = await admin(fake, 'reader');
      final pipelines = (await reader.pipelines()).items;
      expect(pipelines.map((p) => p.direction), ['inbound', 'outbound']);
      expect(pipelines.first.filters.first.name, 'size_check');
      final filter = (await reader.customFilters()).items.single;
      expect(filter.config, isA<Map<String, Object?>>());
      await expectLater(
        reader.updatePipeline(pipelines.first.id, active: false),
        refused('forbidden'),
      );

      final editor = await admin(fake, 'editor');
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
        refused(401, 'reauth_required'),
      );
      await expectLater(
        client.createAppPassword(account.id, name: 'Mail', password: 'nope'),
        refused(401, 'invalid_password'),
      );

      expect(fake.appPasswordsOf(FakeAccounts.email), isEmpty);
      expect(client.tokens, same(tokens));
      expect(await client.appPasswords(account.id), isEmpty);
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

    test('only for the session\'s own mailbox, never a linked one', () async {
      final fake = FakeRestmail();
      final client = await _signedIn(fake);
      final linked = await client.linkAccount(
        address: FakeAccounts.otherEmail,
        password: FakeAccounts.password,
      );

      await expectLater(
        client.appPasswords(linked.id),
        refused(404, 'not_found'),
      );
      await expectLater(
        client.createAppPassword(
          linked.id,
          name: 'Mail',
          password: FakeAccounts.password,
        ),
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
      await admin.signInAdmin(
        username: FakeAccounts.adminUsername,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );

      final box = (await admin.mailboxes()).items.firstWhere(
        (b) => b.address == FakeAccounts.email,
      );
      await admin.updateMailbox(box.id, password: 'a new password');

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

    test('a server from before them answers 404 in plain text', () async {
      final client = await _signedIn(FakeRestmail(appPasswords: false));
      final account = await _account(client);

      await expectLater(
        client.appPasswords(account.id),
        refused(404, 'http_404'),
      );
    });
  });
}
