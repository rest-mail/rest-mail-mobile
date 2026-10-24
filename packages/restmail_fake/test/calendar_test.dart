import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher _refused(int status, String code, [Object? message]) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code)
      .having((e) => e.message, 'message', message ?? anything),
);

/// Invitations in messages, the account's list of them, and replies, as
/// REST Mail answers them.
void main() {
  const organizer = 'ada@example.test';
  late FakeRestmail fake;
  late RestmailClient client;
  late int account;
  setUp(() async {
    fake = FakeRestmail();
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    account = (await client.accounts()).first.id;
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  test('a message carries its invitation, every field read', () async {
    final start = DateTime.utc(2026, 11, 2, 9);
    final sent = fake.invite(
      to: FakeAccounts.email,
      from: organizer,
      summary: 'Engine review',
      location: 'Room 4',
      start: start,
      sequence: 2,
    );
    final event = (await client.message(sent.id)).calendarEvents.single;
    expect(event.method, 'REQUEST');
    expect(event.uid, 'event-1@fake.restmail.test');
    expect(event.summary, 'Engine review');
    expect(event.location, 'Room 4');
    expect(event.start, start);
    expect(event.end, start.add(const Duration(hours: 1)));
    expect(event.organizer!.address, organizer);
    expect(event.attendees.single.partStat, 'NEEDS-ACTION');
    expect(event.sequence, 2);
    expect(event.canReply, isTrue);
    // Mail without one has none.
    final plain = fake.deliver(
      to: FakeAccounts.email,
      from: 'a@b.test',
      subject: 'x',
    );
    expect((await client.message(plain.id)).calendarEvents, isEmpty);
  });

  test('the list has each event once, its latest version first', () async {
    fake
      ..invite(
        to: FakeAccounts.email,
        from: organizer,
        summary: 'Review',
        uid: 'b',
      )
      ..invite(
        to: FakeAccounts.email,
        from: organizer,
        summary: 'Review, moved',
        uid: 'b',
        sequence: 1,
      )
      ..invite(
        to: FakeAccounts.email,
        from: organizer,
        summary: 'Lunch',
        uid: 'a',
      )
      ..invite(
        to: FakeAccounts.email,
        from: organizer,
        summary: 'Lunch',
        uid: 'a',
        method: 'CANCEL',
        sequence: 1,
      );
    final events = await client.calendarEvents(account);
    expect(events.map((e) => e.uid), ['a', 'b']);
    final lunch = events.first, review = events.last;
    expect(
      (lunch.method, lunch.isCancelled, lunch.versions),
      ('CANCEL', true, 2),
    );
    expect(
      (review.summary, review.sequence, review.versions, review.isCancelled),
      ('Review, moved', 1, 2, false),
    );
    final latest = await client.message(review.messageId!);
    expect(latest.calendarEvents.single.summary, 'Review, moved');
    await expectLater(
      client.calendarEvents(account + 1000),
      _refused(403, 'forbidden'),
    );
  });

  test('a reply goes to the organizer and is kept in Sent', () async {
    fake.addAccount(organizer.replaceFirst('example.test', 'restmail.test'));
    final local = organizer.replaceFirst('example.test', 'restmail.test');
    final sent = fake.invite(
      to: FakeAccounts.email,
      from: local,
      summary: 'Engine review',
    );
    expect(
      await client.respondToCalendar(
        sent.id,
        response: CalendarResponse.tentative,
        from: FakeAccounts.email,
      ),
      CalendarResponse.tentative,
    );
    final kept = fake.messagesIn(FakeAccounts.email, 'Sent').last;
    expect(kept.subject, 'Tentative: Engine review');
    expect(kept.to.single.address, local);
    expect(kept.calendarEvents.single['method'], 'REPLY');
    final arrived = fake.messagesIn(local, 'INBOX').last;
    expect(arrived.subject, 'Tentative: Engine review');
    expect((arrived.calendarEvents.single['attendees']! as List).single, {
      'address': FakeAccounts.email,
      'partstat': 'TENTATIVE',
    });
  });

  test('refusals are the server\'s, in its order', () async {
    final sent = fake.invite(
      to: FakeAccounts.email,
      from: organizer,
      summary: 'Review',
    );
    final plain = fake.deliver(
      to: FakeAccounts.email,
      from: 'a@b.test',
      subject: 'x',
    );
    fake.addAccount('other@restmail.test');
    final theirs = fake.invite(
      to: 'other@restmail.test',
      from: organizer,
      summary: 'Theirs',
    );
    await expectLater(
      client.respondToCalendar(
        999999,
        response: CalendarResponse.accepted,
        from: FakeAccounts.email,
      ),
      _refused(404, 'message_not_found'),
    );
    await expectLater(
      client.respondToCalendar(
        theirs.id,
        response: CalendarResponse.accepted,
        from: FakeAccounts.email,
      ),
      _refused(403, 'forbidden', 'Access denied'),
    );
    await expectLater(
      client.respondToCalendar(
        plain.id,
        response: CalendarResponse.accepted,
        from: FakeAccounts.email,
      ),
      _refused(400, 'bad_request', 'Message does not contain calendar events'),
    );
    await expectLater(
      client.respondToCalendar(
        sent.id,
        response: CalendarResponse.accepted,
        from: 'other@restmail.test',
      ),
      _refused(
        403,
        'forbidden',
        'You are not authorized to send from this address',
      ),
    );
    await expectLater(
      client.respondToCalendar(
        sent.id,
        response: CalendarResponse.accepted,
        from: '',
      ),
      _refused(400, 'bad_request', 'from is required'),
    );
    // What the client cannot send: another response, another field.
    for (final (body, status, words) in [
      (
        {'response': 'MAYBE', 'from': FakeAccounts.email},
        400,
        'response must be ACCEPTED, DECLINED, or TENTATIVE',
      ),
      (
        {'response': 'ACCEPTED', 'from': FakeAccounts.email, 'note': 'x'},
        422,
        'not allowed',
      ),
    ]) {
      final reply = await fake.client.post(
        Uri.parse(
          'https://${fake.host}/api/v1/messages/${sent.id}/calendar-reply',
        ),
        headers: {
          'authorization': 'Bearer ${client.tokens!.accessToken}',
          'content-type': 'application/json',
        },
        body: jsonEncode(body),
      );
      expect(reply.statusCode, status, reason: '$body');
      expect(reply.body, contains(words));
    }
    expect(
      fake
          .messagesIn(FakeAccounts.email, 'Sent')
          .where((m) => m.subject.contains('Review')),
      isEmpty,
    );
  });
}
