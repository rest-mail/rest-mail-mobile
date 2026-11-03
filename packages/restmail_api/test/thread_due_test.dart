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
      'data': {'thread_id': 'thread-42', 'due': null, 'due_source': null},
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

  test(
    'generated API sets and replaces UTC instants with user source',
    () async {
      for (final instant in [
        '2026-12-01T10:15:00+02:00',
        '2026-12-02T03:30:00-05:00',
      ]) {
        final due = DateTime.parse(instant);
        reply = {
          'data': {
            'thread_id': 'thread-42',
            'due': due.toUtc().toIso8601String(),
            'due_source': 'user',
          },
        };
        final saved = await client.setThreadDue(3, 'thread-42', due);
        expect(sent.method, 'POST');
        expect(sent.url.path, '/api/v1/accounts/3/threads/thread-42/due');
        expect(sent.headers['authorization'], 'Bearer access');
        expect(jsonDecode(sent.body), {
          'due': due.toUtc().toIso8601String(),
          'due_source': 'user',
        });
        expect(saved.threadId, 'thread-42');
        expect(saved.due, due);
        expect(saved.source, 'user');
      }
    },
  );

  test(
    'clear sends an explicit null and user, receives a cleared pair',
    () async {
      final saved = await client.setThreadDue(3, 'thread-42', null);
      expect(jsonDecode(sent.body), {'due': null, 'due_source': 'user'});
      expect(saved.due, isNull);
      expect(saved.source, isNull);
    },
  );

  for (final code in [403, 404, 422, 500, 503]) {
    test(
      'HTTP $code remains a refusal, including an older missing route',
      () async {
        status = code;
        reply = {
          'error': {'code': 'refused', 'message': 'Could not save due date'},
        };
        await expectLater(
          client.setThreadDue(3, 'thread-42', null),
          throwsA(
            isA<ApiException>().having(
              (error) => error.statusCode,
              'status',
              code,
            ),
          ),
        );
      },
    );
  }

  for (final data in [
    {'thread_id': 'thread-42', 'due': 'bad', 'due_source': 'user'},
    {'thread_id': 'thread-42', 'due': null, 'due_source': 'unknown'},
    {'due': null, 'due_source': null},
  ]) {
    test(
      'invalid generated response is not a successful save: $data',
      () async {
        reply = {'data': data};
        await expectLater(
          client.setThreadDue(3, 'thread-42', null),
          throwsA(
            isA<ApiException>().having(
              (error) => error.code,
              'code',
              'bad_response',
            ),
          ),
        );
      },
    );
  }

  test('due dates and snooze metadata survive independent updates', () {
    final due = DateTime.utc(2026, 12, 1);
    final until = DateTime.utc(2026, 11, 4);
    final message = Message.fromJson({
      'id': 42,
      'mailbox_id': 3,
      'folder': 'INBOX',
      'thread_id': 'thread-42',
      'received_at': '2026-11-03T00:00:00Z',
      'due': due.toIso8601String(),
      'due_source': 'user',
      'snoozed_until': until.toIso8601String(),
    });
    final moved = message.copyWith(isRead: true, folder: 'Archive');
    expect(moved.due, due);
    expect(moved.dueSource, 'user');
    expect(moved.snoozedUntil!.toUtc(), until);
    final cleared = moved.copyWith(
      threadDue: const ThreadDue(threadId: 'thread-42'),
    );
    expect(cleared.due, isNull);
    expect(cleared.dueSource, isNull);
    expect(cleared.snoozedUntil!.toUtc(), until);
    final returned = moved.copyWith(snoozedUntil: null);
    expect(returned.snoozedUntil, isNull);
    expect(returned.due, due);
    expect(returned.dueSource, 'user');
  });

  test(
    'message projections and flag/move copies preserve or clear both fields',
    () {
      final message = Message.fromJson({
        'id': 42,
        'mailbox_id': 3,
        'folder': 'INBOX',
        'thread_id': 'thread-42',
        'received_at': '2026-11-03T00:00:00Z',
        'due': '2026-12-01T10:15:00Z',
        'due_source': 'user',
      });
      final moved = message.copyWith(
        isRead: true,
        isFlagged: true,
        folder: 'Archive',
      );
      expect(moved.due, message.due);
      expect(moved.dueSource, 'user');
      final cleared = moved.copyWith(
        threadDue: const ThreadDue(threadId: 'thread-42'),
      );
      expect(cleared.due, isNull);
      expect(cleared.dueSource, isNull);
      expect(cleared.folder, 'Archive');
      final oldServer = Message.fromJson({
        'id': 42,
        'mailbox_id': 3,
        'folder': 'INBOX',
        'received_at': '2026-11-03T00:00:00Z',
      });
      expect(oldServer.due, isNull);
      expect(oldServer.dueSource, isNull);
    },
  );
}
