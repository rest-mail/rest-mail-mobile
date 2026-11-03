import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object reply;
  late int status;
  setUp(() {
    status = 200;
    reply = {
      'data': {
        'thread_id': 'thread/2026@example.net',
        'snoozed_until': '2099-01-01T10:00:00Z',
      },
    };
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        sent = request;
        return http.Response(
          jsonEncode(reply),
          status,
          headers: {
            'content-type': 'application/json',
            ...contractSecurityHeaders,
          },
        );
      }),
    );
  });
  tearDown(() => client.close());

  test('a deadline goes as RFC 3339 and the stored one comes back', () async {
    final local = DateTime.utc(2099, 1, 1, 10).toLocal();
    final stored = await client.snoozeThread(
      7,
      'thread/2026@example.net',
      local,
    );
    expect(sent.method, 'POST');
    expect(
      sent.url.path,
      '/api/v1/accounts/7/threads/thread%2F2026%40example.net/snooze',
    );
    expect(sent.headers['authorization'], 'Bearer access');
    final body = jsonDecode(sent.body) as Map<String, dynamic>;
    expect(body.keys, ['snoozed_until']);
    expect(
      DateTime.parse(body['snoozed_until'] as String),
      DateTime.utc(2099, 1, 1, 10),
    );
    expect(stored.mailboxId, 7);
    expect(stored.threadId, 'thread/2026@example.net');
    expect(stored.snoozedUntil!.toUtc(), DateTime.utc(2099, 1, 1, 10));
  });

  test('cancelling sends an explicit null', () async {
    reply = {
      'data': {'thread_id': 'thread-1', 'snoozed_until': null},
    };
    final stored = await client.snoozeThread(7, 'thread-1', null);
    expect(sent.body, '{"snoozed_until":null}');
    expect(stored.snoozedUntil, isNull);
  });

  for (final (code, wireStatus, message) in [
    ('validation_failed', 422, 'Request body failed validation'),
    ('not_found', 404, 'Thread not found'),
    ('forbidden', 403, 'Access denied'),
  ]) {
    test('a $wireStatus keeps the server\'s refusal', () async {
      status = wireStatus;
      reply = {
        'error': {
          'code': code,
          'message': message,
          if (wireStatus == 422)
            'details': {
              'fields': {'snoozed_until': 'must be in the future'},
            },
        },
      };
      await expectLater(
        client.snoozeThread(7, 'thread-1', DateTime.utc(2000)),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', wireStatus)
              .having((e) => e.code, 'code', code)
              .having((e) => e.message, 'message', message),
        ),
      );
    });
  }

  test('a response that is not a snooze is a bad response', () async {
    reply = {
      'data': {'thread_id': 'thread-1', 'snoozed_until': 'tomorrow'},
    };
    await expectLater(
      client.snoozeThread(7, 'thread-1', null),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
      ),
    );
  });

  group('a message', () {
    Map<String, dynamic> json([Map<String, dynamic> more = const {}]) => {
      'id': 1,
      'mailbox_id': 7,
      'folder': 'INBOX',
      'sender': 'a@example.test',
      'subject': 's',
      'received_at': '2026-09-10T10:00:00Z',
      ...more,
    };

    test('reads its deadline, and an older server has none', () {
      expect(Message.fromJson(json()).snoozedUntil, isNull);
      expect(
        Message.fromJson(json({'snoozed_until': '2099-01-01T10:00:00Z'}))
            .snoozedUntil!
            .toUtc(),
        DateTime.utc(2099, 1, 1, 10),
      );
    });

    test('keeps its deadline across other changes, until told', () {
      final snoozed = Message.fromJson(
        json({'snoozed_until': '2099-01-01T10:00:00Z'}),
      );
      expect(
        snoozed.copyWith(isRead: true).snoozedUntil!.toUtc(),
        DateTime.utc(2099, 1, 1, 10),
      );
      expect(snoozed.copyWith(snoozedUntil: null).snoozedUntil, isNull);
    });
  });

  group('an event', () {
    MailEvent event(Map<String, dynamic> data, {String? type}) =>
        MailEvent(type: type ?? MailEventType.folderUpdate, data: data);

    test('announcing a return or a snooze is read', () {
      final back = event({
        'mailbox_id': 7,
        'thread_id': 'thread-1',
        'snoozed_until': null,
      }).threadSnooze!;
      expect(back.mailboxId, 7);
      expect(back.threadId, 'thread-1');
      expect(back.snoozedUntil, isNull);
      expect(
        event({
          'mailbox_id': 7,
          'thread_id': 'thread-1',
          'snoozed_until': '2099-01-01T10:00:00Z',
        }).threadSnooze!.snoozedUntil!.toUtc(),
        DateTime.utc(2099, 1, 1, 10),
      );
    });

    for (final data in <Map<String, dynamic>>[
      {'folder': 'INBOX', 'unread_count': 2},
      {'mailbox_id': 7, 'thread_id': 'thread-1'},
      {'mailbox_id': '7', 'thread_id': 'thread-1', 'snoozed_until': null},
      {'mailbox_id': 7, 'thread_id': 1, 'snoozed_until': null},
      {'mailbox_id': 7, 'thread_id': 'thread-1', 'snoozed_until': 12},
      {'mailbox_id': 7, 'thread_id': 'thread-1', 'snoozed_until': 'tomorrow'},
    ]) {
      test('is not about a snooze: $data', () {
        expect(event(data).threadSnooze, isNull);
      });
    }

    test('of another type is not about a snooze', () {
      expect(
        event({
          'mailbox_id': 7,
          'thread_id': 'thread-1',
          'snoozed_until': null,
        }, type: MailEventType.messageUpdated).threadSnooze,
        isNull,
      );
    });
  });
}
