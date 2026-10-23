import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Future<RestmailClient> _login(FakeRestmail fake, [String? email]) async {
  final client = RestmailClient(
    server: Uri.parse('https://${FakeAccounts.host}'),
    httpClient: fake.client,
  );
  await client.login(
    email: email ?? FakeAccounts.adminEmail,
    password: FakeAccounts.adminPassword,
    totpCode: FakeAccounts.totpCode,
  );
  return client;
}

void main() {
  test(
    'bulk retry and bounce preserve terminal entries and count actual changes',
    () async {
      final fake = FakeRestmail();
      final client = await _login(fake);
      final entries = (await client.queue()).items;
      final deferred = entries.firstWhere(
        (entry) => entry.status == QueueStatus.deferred,
      );
      final delivered = entries.firstWhere(
        (entry) => entry.status == QueueStatus.delivered,
      );
      expect(
        (await client.bulkRetryQueue(
          QueueSelection.ids([deferred.id, delivered.id]),
        )).affected,
        1,
      );
      expect(
        (await client.queueEntry(deferred.id)).status,
        QueueStatus.pending,
      );
      expect(
        (await client.queueEntry(delivered.id)).status,
        QueueStatus.delivered,
      );
      final eligible = (await client.queue()).items
          .where(
            (entry) => {
              QueueStatus.pending,
              QueueStatus.deferred,
              QueueStatus.delivering,
            }.contains(entry.status),
          )
          .length;
      expect(
        (await client.bulkBounceQueue(
          const QueueSelection.filter(QueueFilter()),
        )).affected,
        eligible,
      );
      expect(
        (await client.queueEntry(delivered.id)).status,
        QueueStatus.delivered,
      );
      client.close();
      fake.close();
    },
  );

  test(
    'list and bulk filters agree, sender and recipient matching is literal and case insensitive',
    () async {
      final fake = FakeRestmail();
      final client = await _login(fake);
      final first = (await client.queue()).items.first;
      final matching = await client.queue(
        domain: first.domain,
        sender: first.sender.toUpperCase(),
        recipient: first.recipient.toUpperCase(),
      );
      expect(matching.items.map((entry) => entry.id), contains(first.id));
      expect((await client.queue(sender: '%')).items, isEmpty);
      final changed = await client.bulkDeleteQueue(
        QueueSelection.filter(
          QueueFilter(
            domain: first.domain,
            sender: first.sender.toUpperCase(),
            recipient: first.recipient.toUpperCase(),
          ),
        ),
      );
      expect(changed.affected, matching.total);
      expect(
        (await client.queue()).items.map((entry) => entry.id),
        isNot(contains(first.id)),
      );
      client.close();
      fake.close();
    },
  );

  test(
    'an explicit empty filter deletes all entries across pagination',
    () async {
      final fake = FakeRestmail();
      final client = await _login(fake);
      final firstPage = await client.queue(limit: 1);
      expect(firstPage.hasMore, isTrue);
      expect(
        (await client.bulkDeleteQueue(
          const QueueSelection.filter(QueueFilter()),
        )).affected,
        firstPage.total,
      );
      expect((await client.queue()).total, 0);
      client.close();
      fake.close();
    },
  );

  test(
    'queue readers cannot run any bulk change, and keep their session',
    () async {
      final fake = FakeRestmail();
      final client = await _login(fake, FakeAccounts.queueWatcher);
      final tokens = client.tokens;
      final selection = const QueueSelection.filter(QueueFilter());
      final refused = throwsA(
        isA<ApiException>().having((error) => error.statusCode, 'status', 403),
      );
      await expectLater(client.bulkRetryQueue(selection), refused);
      await expectLater(client.bulkBounceQueue(selection), refused);
      await expectLater(client.bulkDeleteQueue(selection), refused);
      expect(client.tokens, same(tokens));
      expect((await client.queue()).total, 4);
      client.close();
      fake.close();
    },
  );
}
