// The admin API, called through the client against a real server
// (tool/ci/live_server.sh): every request the client builds is one the server
// accepts, and every answer is one the client reads.
@TestOn('vm')
library;

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

Matcher refused(int status, [String? code]) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code ?? anything),
);

void main() {
  late LiveAdmin admin;
  RestmailClient client() => admin.client;

  setUpAll(() async {
    if (skipLive != null) return;
    admin = await LiveAdmin.setUp();
  });
  tearDownAll(() {
    if (skipLive == null) admin.client.close();
  });

  group('live admin API', skip: skipLive, () {
    test('stats', () async {
      final stats = await client().stats();
      expect(stats, isNotNull);
    });

    test('a domain: created, read, changed, listed, refused twice', () async {
      final created = await client().createDomain(
        'one.live.test',
        serverType: 'restmail',
        defaultQuotaBytes: 5 * 1024 * 1024,
        sendingPolicy: 'transactional',
      );
      expect(created.name, 'one.live.test');
      expect(created.active, isFalse);
      expect(created.defaultQuotaBytes, 5 * 1024 * 1024);
      expect(created.sendingPolicy, 'transactional');
      expect(created.createdAt, isNotNull);

      final read = await client().domain(created.id);
      expect(read.name, created.name);

      final changed = await client().updateDomain(
        created.id,
        sendingPolicy: '',
        defaultQuotaBytes: 7 * 1024 * 1024,
      );
      expect(changed.sendingPolicy, '');
      expect(changed.defaultQuotaBytes, 7 * 1024 * 1024);

      final page = await client().domains();
      expect(page.items.map((d) => d.name), contains('one.live.test'));

      await expectLater(
        client().createDomain('one.live.test'),
        refused(409, 'already_exists'),
      );
      await expectLater(
        client().updateDomain(created.id, active: true),
        refused(409, 'certificate_required'),
      );

      await client().deleteDomain(created.id);
      await expectLater(
        client().domain(created.id),
        refused(404, 'domain_not_found'),
      );
    });

    test('an account, its mailbox and an alias, end to end', () async {
      final domain = await client().createDomain('two.live.test');
      final account = await client().createAccount(
        address: 'tom@two.live.test',
        displayName: 'Tom',
        password: 'a mailbox password, long enough',
      );
      expect(account.address, 'tom@two.live.test');

      final mailboxes = await client().mailboxes(domainId: domain.id);
      final mailbox = mailboxes.items.singleWhere(
        (m) => m.address == 'tom@two.live.test',
      );
      expect(mailbox.domainId, domain.id);
      expect(mailbox.localPart, 'tom');
      expect(mailbox.displayName, 'Tom');

      final updated = await client().updateMailbox(
        mailbox.id,
        displayName: 'Tom Rye',
        quotaBytes: 3 * 1024 * 1024,
      );
      expect(updated.displayName, 'Tom Rye');
      expect(updated.quotaBytes, 3 * 1024 * 1024);
      expect((await client().adminMailbox(mailbox.id)).displayName, 'Tom Rye');
      await expectLater(
        client().updateMailbox(mailbox.id, password: 'short'),
        refused(422),
      );
      await client().endMailboxSessions(mailbox.id);

      final alias = await client().createAlias(
        source: 'hello@two.live.test',
        destination: 'tom@two.live.test',
      );
      expect(alias.domainId, domain.id);
      expect(alias.active, isTrue);
      final paused = await client().updateAlias(alias.id, active: false);
      expect(paused.active, isFalse);
      expect((await client().alias(alias.id)).active, isFalse);
      expect(
        (await client().aliases(domainId: domain.id)).items.map((a) => a.id),
        contains(alias.id),
      );

      await expectLater(
        client().deleteDomain(domain.id),
        refused(409, 'domain_not_empty'),
      );
      await client().deleteAlias(alias.id);
      await client().deleteMailbox(mailbox.id);
      await client().deleteDomain(domain.id);
    });
  });
}
