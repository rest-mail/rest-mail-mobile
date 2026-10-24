import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  late http.Request sent;
  late Object reply;
  late RestmailClient client;
  setUp(() {
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        sent = request;
        return http.Response.bytes(
          utf8.encode(jsonEncode(reply)),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  });
  tearDown(() => client.close());

  test('the list reads every field', () async {
    reply = {
      'data': [
        {
          'uid': 'u1',
          'method': 'request',
          'status': 'CONFIRMED',
          'summary': 'Review',
          'sequence': 3,
          'is_cancelled': false,
          'message_id': 41,
          'versions': 2,
        },
        {
          'uid': 'u2',
          'method': 'CANCEL',
          'status': '',
          'summary': 'Lunch',
          'sequence': 0,
          'is_cancelled': true,
          'versions': 1,
        },
      ],
    };
    final events = await client.calendarEvents(7);
    expect(sent.url.path, '/api/v1/accounts/7/calendar-events');
    expect(events.first.method, 'REQUEST');
    expect(
      (
        events.first.status,
        events.first.sequence,
        events.first.messageId,
        events.first.versions,
      ),
      ('CONFIRMED', 3, 41, 2),
    );
    expect(
      (events.last.isCancelled, events.last.status, events.last.messageId),
      (true, null, null),
    );
  });

  test(
    'a reply sends the response and from, and reads what was sent',
    () async {
      reply = {
        'data': {'response': 'DECLINED', 'status': 'sent'},
      };
      final answered = await client.respondToCalendar(
        5,
        response: CalendarResponse.declined,
        from: 'me@example.test',
      );
      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/messages/5/calendar-reply');
      expect(jsonDecode(sent.body), {
        'response': 'DECLINED',
        'from': 'me@example.test',
      });
      expect(answered, CalendarResponse.declined);

      reply = {
        'data': {'response': 'DECLINED', 'status': 'queued'},
      };
      await expectLater(
        client.respondToCalendar(
          5,
          response: CalendarResponse.declined,
          from: 'me@example.test',
        ),
        throwsA(isA<ApiException>()),
      );
    },
  );

  test('an event Go wrote without an end reads as none', () {
    final event = CalendarInvite.fromJson({
      'method': 'REQUEST',
      'uid': 'u',
      'summary': 's',
      'dtstart': '2026-11-02T09:00:00Z',
      'dtend': '0001-01-01T00:00:00Z',
      'organizer': {'address': ''},
      'status': 'cancelled',
    });
    expect(event.start, DateTime.utc(2026, 11, 2, 9));
    expect(event.end, isNull);
    expect(event.organizer, isNull);
    expect(event.canReply, isFalse);
  });
}
