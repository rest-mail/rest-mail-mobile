import 'dart:convert';

import 'package:http/http.dart' as http;
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
    'bulk bodies are bound as the server binds them, and a missing entry is 404',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _login(fake);
      addTearDown(client.close);
      final transport = fake.client;
      addTearDown(transport.close);
      Future<http.Response> bulk(String body) => transport
          .send(
            http.Request(
                'DELETE',
                Uri.parse(
                  'https://${fake.host}/api/v1/admin/queue/bulk-delete',
                ),
              )
              ..headers['authorization'] =
                  'Bearer ${client.tokens!.accessToken}'
              ..headers['content-type'] = 'application/json'
              ..body = body,
          )
          .then(http.Response.fromStream);
      Object? fields(http.Response response) =>
          (jsonDecode(response.body)
              as Map<String, dynamic>)['error']['details']['fields'];
      final cases = {
        '{"ids":"1"}': {'ids': 'must be an array'},
        '{"ids":[-1,2]}': {'ids[0]': 'must be a non-negative integer'},
        jsonEncode({'ids': List.filled(1001, 1)}): {
          'ids': 'max 1000 IDs per request',
        },
        '{"filter":[]}': {'filter': 'must be an object'},
        '{"filter":{"status":1,"colour":"red"}}': {
          'filter.status': 'must be a string',
          'filter.colour': 'not allowed',
        },
        '{"ids":[1],"everything":true}': {'everything': 'not allowed'},
      };
      for (final MapEntry(key: body, value: want) in cases.entries) {
        final response = await bulk(body);
        expect(response.statusCode, 422, reason: body);
        expect(fields(response), want, reason: body);
      }
      for (final body in ['{}', '{"ids":[]}', '{"filter":null}']) {
        final response = await bulk(body);
        expect(response.statusCode, 400, reason: body);
        expect(response.body, contains('ids or filter required'), reason: body);
      }
      await expectLater(
        client.deleteQueueEntry(999999),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.code, 'code', 'not_found'),
        ),
      );
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
