import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher refused(int code) => throwsA(
  isA<ApiException>().having((error) => error.statusCode, 'status', code),
);

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late FakeMessage message;
  late int account;

  setUp(() async {
    fake = FakeRestmail(scenario: FakeScenario.twoFactor);
    message = fake.messagesIn(FakeAccounts.email, 'INBOX').first
      ..threadId = 'due-thread';
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
      totpCode: FakeAccounts.totpCode,
    );
    account = (await client.accounts()).first.id;
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  test(
    'set, replace and clear project across detail, folder, thread and search without filing or reordering',
    () async {
      final second =
          fake.deliver(
              to: FakeAccounts.email,
              from: 'sender@example.test',
              subject: 'same thread',
              body: 'body',
            )
            ..threadId = message.threadId
            ..folder = 'Archive';
      final otherAccount = fake.deliver(
        to: FakeAccounts.adminEmail,
        from: 'sender@example.test',
        subject: 'other account',
      )..threadId = message.threadId;
      final before = (await client.messages(
        account,
        'INBOX',
      )).items.map((item) => item.id).toList();
      for (final instant in ['2026-12-01T10:15:00Z', '2026-12-02T03:30:00Z']) {
        final due = DateTime.parse(instant);
        await client.setThreadDue(account, message.threadId!, due);
        expect((await client.message(message.id)).due, due);
        expect((await client.message(second.id)).dueSource, 'user');
        expect(
          (await client.thread(
            account,
            message.threadId!,
          )).every((item) => item.due == due),
          isTrue,
        );
        expect(
          (await client.search(
            account,
            SearchQuery(text: 'same thread'),
          )).items.single.due,
          due,
        );
        expect(
          (await client.messages(
            account,
            'INBOX',
          )).items.map((item) => item.id),
          before,
        );
        expect(otherAccount.due, isNull);
        expect(message.folder, 'INBOX');
        expect(second.folder, 'Archive');
        expect(second.bodyText, 'body');
      }
      final later = fake.deliver(
        to: FakeAccounts.email,
        from: 'sender@example.test',
        subject: 'later',
      )..threadId = message.threadId;
      expect((await client.message(later.id)).dueSource, 'user');
      await client.updateMessage(message.id, isRead: true, isFlagged: true);
      expect((await client.message(message.id)).dueSource, 'user');
      await client.setThreadDue(account, message.threadId!, null);
      for (final item in await client.thread(account, message.threadId!)) {
        expect(item.due, isNull);
        expect(item.dueSource, isNull);
      }
    },
  );

  test('due dates and snoozing coexist across thread projections', () async {
    final due = DateTime.now().toUtc().add(const Duration(days: 2));
    final until = DateTime.now().toUtc().add(const Duration(hours: 2));
    await client.setThreadDue(account, message.threadId!, due);
    await client.snoozeThread(account, message.threadId!, until);
    final later = fake.deliver(
      to: FakeAccounts.email,
      from: 'sender@example.test',
      subject: 'later snoozed message',
      threadId: message.threadId,
    );
    final detail = await client.message(later.id);
    expect(detail.due, due);
    expect(detail.dueSource, 'user');
    expect(detail.snoozedUntil!.toUtc(), until);
    for (final item in await client.thread(account, message.threadId!)) {
      expect(item.due, due);
      expect(item.dueSource, 'user');
      expect(item.snoozedUntil!.toUtc(), until);
    }
    final search = (await client.search(
      account,
      SearchQuery(text: 'later snoozed message'),
    )).items.single;
    expect(search.due, due);
    expect(search.snoozedUntil!.toUtc(), until);
    expect(
      (await client.messages(account, 'INBOX')).items.map((item) => item.id),
      isNot(contains(later.id)),
    );
    await client.setThreadDue(account, message.threadId!, null);
    for (final item in await client.thread(account, message.threadId!)) {
      expect(item.due, isNull);
      expect(item.dueSource, isNull);
      expect(item.snoozedUntil!.toUtc(), until);
    }
    await client.setThreadDue(account, message.threadId!, due);
    await client.snoozeThread(account, message.threadId!, null);
    final returned = (await client.messages(
      account,
      'INBOX',
    )).items.firstWhere((item) => item.id == later.id);
    expect(returned.due, due);
    expect(returned.dueSource, 'user');
    expect(returned.snoozedUntil, isNull);
  });

  test('unknown and other-account threads are 404 without mutation', () async {
    final other = fake.deliver(
      to: FakeAccounts.adminEmail,
      from: FakeAccounts.email,
      subject: 'other',
    )..threadId = 'foreign';
    await expectLater(
      client.setThreadDue(account, 'foreign', null),
      refused(404),
    );
    await expectLater(
      client.setThreadDue(other.mailboxId, 'foreign', null),
      refused(404),
    );
    await expectLater(
      client.setThreadDue(account, 'unknown', null),
      refused(404),
    );
    expect(other.due, isNull);
  });

  test(
    'route refuses invalid dates, missing fields and reserved sources',
    () async {
      final transport = fake.client;
      addTearDown(transport.close);
      for (final body in [
        for (final due in ['bad', '2026-02-30T10:00:00Z', '2026-12-01', '', 42])
          {'due': due, 'due_source': 'user'},
        for (final source in ['rule', 'parsed', 'other', null])
          {'due': null, 'due_source': source},
        {'due_source': 'user'},
        {'due': null},
      ]) {
        final response = await transport.post(
          Uri.parse(
            'https://${fake.host}/api/v1/accounts/$account/threads/due-thread/due',
          ),
          headers: {
            'authorization': 'Bearer ${client.tokens!.accessToken}',
            'content-type': 'application/json',
          },
          body: jsonEncode(body),
        );
        expect(response.statusCode, 422, reason: '$body');
        expect(message.due, isNull);
      }
      final anonymous = await transport.post(
        Uri.parse(
          'https://${fake.host}/api/v1/accounts/$account/threads/due-thread/due',
        ),
        body: '{}',
      );
      expect(anonymous.statusCode, 401);
    },
  );

  test(
    'read-only scoped API keys are forbidden, writable keys can set',
    () async {
      for (final capability in ['mail:read', 'mail:write']) {
        final key = await client.createAPIKey(
          account,
          name: capability,
          password: FakeAccounts.password,
          permissions: [
            APIKeyPermission(
              capability: capability,
              scope: 'mailbox:${FakeAccounts.email}',
            ),
          ],
        );
        final transport = fake.client;
        addTearDown(transport.close);
        final response = await transport.post(
          Uri.parse(
            'https://${fake.host}/api/v1/accounts/$account/threads/due-thread/due',
          ),
          headers: {
            'authorization': 'Bearer ${key.token}',
            'content-type': 'application/json',
          },
          body: '{"due":"2026-12-01T10:00:00Z","due_source":"user"}',
        );
        expect(response.statusCode, capability == 'mail:read' ? 403 : 200);
      }
    },
  );
}
