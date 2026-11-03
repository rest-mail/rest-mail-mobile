import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late DateTime now;
  late FakeRestmail fake;
  late RestmailClient client;
  late int accountId;
  late FakeMessage first;
  late FakeMessage second;
  late FakeMessage other;
  late DateTime later;

  setUp(() async {
    now = DateTime.utc(2026, 11, 3, 12);
    later = now.add(const Duration(hours: 1));
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
    first = fake.deliver(
      to: FakeAccounts.email,
      from: 'a@example.test',
      subject: 'First',
      threadId: 'thread/1',
    );
    second = fake.deliver(
      to: FakeAccounts.email,
      from: 'a@example.test',
      subject: 'Second',
      threadId: 'thread/1',
    );
    other = fake.deliver(
      to: FakeAccounts.email,
      from: 'b@example.test',
      subject: 'Other',
    );
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  Future<List<int>> listed() async => [
    for (final m in (await client.messages(accountId, 'INBOX')).items) m.id,
  ];

  Future<int> counted() async => (await client.folders(
    accountId,
  )).firstWhere((f) => f.name == 'INBOX').total;

  test('a message has a thread, and a reply joins it', () async {
    expect(other.threadId, isNotEmpty);
    expect((await client.message(other.id)).threadId, other.threadId);
    final sent = await client.send(
      OutgoingMessage(
        from: FakeAccounts.email,
        to: const ['b@example.test'],
        subject: 'Re: Other',
        inReplyTo: other.messageId,
      ),
    );
    expect(sent.threadId, other.threadId);
  });

  test('snoozing hides the whole thread from folders, not from search '
      'or direct reads', () async {
    final stored = await client.snoozeThread(accountId, 'thread/1', later);
    expect(stored.threadId, 'thread/1');
    expect(stored.snoozedUntil!.toUtc(), later);

    expect(await listed(), [other.id]);
    expect(await counted(), 1);
    expect((await client.message(first.id)).snoozedUntil!.toUtc(), later);
    expect((await client.thread(accountId, 'thread/1')).map((m) => m.id), [
      first.id,
      second.id,
    ]);
    final found = await client.search(
      accountId,
      const SearchQuery(text: 'First'),
    );
    expect(found.items.single.id, first.id);
    expect(found.items.single.snoozedUntil!.toUtc(), later);
    expect(fake.messagesIn(FakeAccounts.email, 'INBOX'), hasLength(3));
  });

  test('mail arriving in a snoozed thread stays hidden with it', () async {
    await client.snoozeThread(accountId, 'thread/1', later);
    final third = fake.deliver(
      to: FakeAccounts.email,
      from: 'a@example.test',
      subject: 'Third',
      threadId: 'thread/1',
    );
    expect(await listed(), [other.id]);
    expect((await client.message(third.id)).snoozedUntil!.toUtc(), later);
  });

  test('a new deadline replaces the old, and null cancels', () async {
    await client.snoozeThread(accountId, 'thread/1', later);
    final further = later.add(const Duration(days: 1));
    await client.snoozeThread(accountId, 'thread/1', further);
    expect((await client.message(first.id)).snoozedUntil!.toUtc(), further);
    expect(await listed(), [other.id]);
    await client.snoozeThread(accountId, 'thread/1', null);
    expect((await client.message(first.id)).snoozedUntil, isNull);
    expect(await listed(), hasLength(3));
  });

  group('the event stream', () {
    late List<MailEvent> events;
    late StreamSubscription<MailEvent> stream;

    setUp(() async {
      events = [];
      final live = Completer<void>();
      stream = client
          .events(
            accountId,
            onLiveChanged: (up) {
              if (up && !live.isCompleted) live.complete();
            },
          )
          .listen(events.add);
      await live.future;
    });
    tearDown(() => stream.cancel());

    Future<void> settle() => Future<void>.delayed(Duration.zero);

    test(
      'announces a snooze, and the return when its deadline comes',
      () async {
        await client.snoozeThread(accountId, 'thread/1', later);
        await settle();
        expect(events.last.threadSnooze!.threadId, 'thread/1');
        expect(events.last.threadSnooze!.snoozedUntil!.toUtc(), later);

        events.clear();
        fake.returnSnoozedThreads();
        await settle();
        expect(events, isEmpty, reason: 'its deadline has not come');

        now = later;
        fake.returnSnoozedThreads();
        await settle();
        final back = events.single.threadSnooze!;
        expect(back.mailboxId, accountId);
        expect(back.threadId, 'thread/1');
        expect(back.snoozedUntil, isNull);
        expect(await listed(), hasLength(3));
        expect((await client.message(first.id)).snoozedUntil, isNull);
      },
    );

    test('announces a cancel', () async {
      await client.snoozeThread(accountId, 'thread/1', later);
      await client.snoozeThread(accountId, 'thread/1', null);
      await settle();
      expect(events.last.threadSnooze!.snoozedUntil, isNull);
    });

    test('a due thread returns ahead of the next request', () async {
      await client.snoozeThread(accountId, 'thread/1', later);
      now = later.add(const Duration(minutes: 1));
      expect(await listed(), hasLength(3));
      await settle();
      expect(events.last.threadSnooze!.snoozedUntil, isNull);
    });
  });

  group('refuses', () {
    Future<(int, Map<String, dynamic>)> post(
      String account,
      String thread,
      String body,
    ) async {
      final uri = Uri.parse(
        'https://${fake.host}/api/v1/accounts/$account/threads/$thread/snooze',
      );
      final response = await fake.client.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${client.tokens!.accessToken}',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      return (
        response.statusCode,
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    for (final (name, body, problem) in [
      ('a missing deadline', '{}', 'required'),
      ('a number', '{"snoozed_until":12345}', 'must be a date-time'),
      ('words', '{"snoozed_until":"tomorrow"}', 'must be a date-time'),
      ('a date alone', '{"snoozed_until":"2099-01-01"}', 'must be a date-time'),
      (
        'a past time',
        '{"snoozed_until":"2000-01-01T00:00:00Z"}',
        'must be in the future',
      ),
      (
        'the present moment',
        '{"snoozed_until":"2026-11-03T12:00:00Z"}',
        'must be in the future',
      ),
    ]) {
      test('$name with a 422', () async {
        final (status, json) = await post('$accountId', 'thread%2F1', body);
        expect(status, 422);
        final error = json['error'] as Map<String, dynamic>;
        expect(error['code'], 'validation_failed');
        expect(jsonEncode(error['details']), contains(problem));
        expect(await listed(), hasLength(3));
      });
    }

    test('an unknown thread with a 404', () async {
      await expectLater(
        client.snoozeThread(accountId, 'missing', later),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.message, 'message', 'Thread not found'),
        ),
      );
    });

    test('an account out of reach with a 403', () async {
      final (status, json) = await post(
        '999999',
        'thread%2F1',
        '{"snoozed_until":null}',
      );
      expect(status, 403);
      expect((json['error'] as Map<String, dynamic>)['code'], 'forbidden');
    });

    test('no session with a 401', () async {
      final response = await fake.client.post(
        Uri.parse(
          'https://${fake.host}/api/v1/accounts/$accountId/threads/thread%2F1/snooze',
        ),
        body: '{"snoozed_until":null}',
      );
      expect(response, isA<http.Response>());
      expect(response.statusCode, 401);
    });
  });
}
