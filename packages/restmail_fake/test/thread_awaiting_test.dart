import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late DateTime now;
  late int accountId;

  FakeMessage deliver({
    required String to,
    required String from,
    String folder = 'INBOX',
    String? threadId,
    String? inReplyTo,
  }) =>
      fake.deliver(
          to: to,
          from: from,
          subject: 'A question',
          threadId: threadId,
        )
        ..folder = folder
        ..inReplyTo = inReplyTo;

  setUp(() async {
    now = DateTime.utc(2026, 11, 3, 12);
    fake = FakeRestmail(scenario: FakeScenario.empty, clock: () => now);
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    accountId = (await client.accounts()).first.id;
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  test('own last sender waits across folders; a reply ends it', () async {
    final sent = deliver(
      to: FakeAccounts.email,
      from: FakeAccounts.email,
      folder: 'Sent',
      threadId: 'thread/1',
    );
    expect((await client.message(sent.id)).awaitingSince, now);
    final waiting = await client.awaitingThreads(accountId);
    expect(waiting.items.single.id, sent.id);
    expect(waiting.items.single.awaitingSince, now);
    now = now.add(const Duration(minutes: 1));
    deliver(
      to: FakeAccounts.email,
      from: 'friend@example.test',
      threadId: 'thread/1',
    );
    expect((await client.message(sent.id)).awaitingSince, isNull);
    expect((await client.awaitingThreads(accountId)).items, isEmpty);
  });

  test('pagination has no total, and snoozed threads stay waiting', () async {
    final first = deliver(
      to: FakeAccounts.email,
      from: FakeAccounts.email,
      folder: 'Sent',
    );
    now = now.add(const Duration(minutes: 1));
    final second = deliver(
      to: FakeAccounts.email,
      from: FakeAccounts.email,
      folder: 'Archive',
    );
    await client.snoozeThread(
      accountId,
      second.threadId!,
      now.add(const Duration(days: 1)),
    );
    final page = await client.awaitingThreads(accountId, limit: 1);
    expect(page.items.single.id, second.id);
    expect(page.items.single.snoozedUntil, isNotNull);
    expect(page.hasMore, isTrue);
    expect(page.total, isNull);
    final older = await client.awaitingThreads(
      accountId,
      limit: 1,
      cursor: page.cursor,
    );
    expect(older.items.single.id, first.id);
    expect(older.hasMore, isFalse);
  });

  test(
    'drafts and trash do not start a wait, split-thread replies end it',
    () async {
      deliver(
        to: FakeAccounts.email,
        from: FakeAccounts.email,
        folder: 'Drafts',
      );
      deliver(
        to: FakeAccounts.email,
        from: FakeAccounts.email,
        folder: 'Trash',
      );
      final sent = deliver(
        to: FakeAccounts.email,
        from: FakeAccounts.email,
        folder: 'Sent',
      );
      now = now.add(const Duration(minutes: 1));
      final reply = deliver(
        to: FakeAccounts.email,
        from: 'friend@example.test',
        inReplyTo: sent.messageId,
        threadId: 'split',
      );
      expect((await client.awaitingThreads(accountId)).items, isEmpty);
      await client.updateMessage(reply.id, folder: 'Trash');
      expect(
        (await client.awaitingThreads(accountId)).items.single.id,
        sent.id,
      );
    },
  );
}
