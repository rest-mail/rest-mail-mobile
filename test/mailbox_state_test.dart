import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/state/mail_backend.dart';
import 'package:restmail/state/mailbox_state.dart';
import 'package:restmail_api/restmail_api.dart';

Map<String, dynamic> _message(
  int id, {
  String received = '2026-09-10T10:00:00Z',
  bool read = false,
  String? thread,
}) => {
  'id': id,
  'mailbox_id': 1,
  'thread_id': ?thread,
  'folder': 'INBOX',
  'sender': 'bob@example.test',
  'subject': 'Message $id',
  'is_read': read,
  'received_at': received,
};

/// Just enough of a rest-mail server for one mailbox, with an event stream
/// the test can push into.
class _Server {
  final events = StreamController<List<int>>();
  List<Map<String, dynamic>> inbox = [];
  bool refuseDeletes = false;
  bool refuseLists = false;

  late final client = RestmailClient(
    server: Uri.parse('https://mail.example.test'),
    tokens: SessionTokens(
      accessToken: 'a',
      refreshToken: 'r',
      accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    ),
    httpClient: MockClient.streaming((request, _) async {
      http.StreamedResponse json(Object body, [int status = 200]) =>
          http.StreamedResponse(
            Stream.value(utf8.encode(jsonEncode(body))),
            status,
          );
      final path = request.url.path;
      if (path.endsWith('/events')) {
        return http.StreamedResponse(events.stream, 200);
      }
      if (request.method == 'DELETE') {
        return refuseDeletes
            ? json({
                'error': {
                  'code': 'internal_error',
                  'message': 'Failed to delete message',
                },
              }, 500)
            : http.StreamedResponse(const Stream.empty(), 204);
      }
      if (refuseLists && path.endsWith('/messages')) {
        return json({
          'error': {'code': 'internal_error', 'message': 'Unavailable'},
        }, 500);
      }
      return switch (path) {
        '/api/v1/accounts' => json({
          'data': [
            {
              'id': 1,
              'mailbox_id': 1,
              'address': 'ada@example.test',
              'display_name': 'Ada',
              'is_primary': true,
            },
          ],
        }),
        '/api/v1/accounts/1/folders' => json({
          'data': [
            {'name': 'Trash', 'total': 0, 'unread': 0},
            {'name': 'INBOX', 'total': inbox.length, 'unread': 1},
            {'name': 'Receipts', 'total': 0, 'unread': 0},
            {'name': 'Sent', 'total': 0, 'unread': 0},
          ],
        }),
        '/api/v1/accounts/1/folders/INBOX/messages' => json({
          'data': inbox,
          'pagination': {'has_more': false},
        }),
        _ => json({
          'error': {'code': 'not_found', 'message': path},
        }, 404),
      };
    }),
  );

  void push(String type, Map<String, Object> data) =>
      events.add(utf8.encode('event: $type\ndata: ${jsonEncode(data)}\n\n'));
}

/// Lets the stream and the requests it sets off finish.
Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  test('starts on the primary account, rest-mail folders first', () async {
    final server = _Server()..inbox = [_message(1)];
    final mailbox = MailboxState(RestBackend(server.client));
    addTearDown(mailbox.dispose);

    await mailbox.start();

    expect(mailbox.account?.address, 'ada@example.test');
    expect(mailbox.folders.map((f) => f.name), [
      'INBOX',
      'Sent',
      'Trash',
      'Receipts',
    ]);
    expect(mailbox.messages.map((m) => m.id), [1]);
    expect(mailbox.loading, isFalse);
  });

  test('a new message in the folder on screen lands at the top', () async {
    final server = _Server()..inbox = [_message(1)];
    final mailbox = MailboxState(RestBackend(server.client));
    addTearDown(mailbox.dispose);
    await mailbox.start();
    await _settle();
    expect(mailbox.live, LiveStatus.live);

    server.inbox = [_message(2, received: '2026-09-10T11:00:00Z'), _message(1)];
    server.push(MailEventType.newMessage, {'message_id': 2, 'folder': 'INBOX'});
    await _settle();

    expect(mailbox.messages.map((m) => m.id), [2, 1]);
  });

  group('a thread snooze announced on the stream', () {
    Map<String, Object> announced(
      Object? until, {
      int mailbox = 1,
      String thread = 'thread-1',
    }) => {'mailbox_id': mailbox, 'thread_id': thread, 'snoozed_until': ?until};

    late _Server server;
    late MailboxState mailbox;

    setUp(() async {
      server = _Server()
        ..inbox = [
          _message(3, thread: 'thread-1'),
          _message(2, thread: 'thread-1'),
          _message(1, thread: 'thread-2'),
        ];
      mailbox = MailboxState(RestBackend(server.client));
      await mailbox.start();
      await _settle();
    });
    tearDown(() => mailbox.dispose());

    test('takes the whole thread out, even if a read says otherwise', () async {
      server.refuseLists = true;
      server.push(
        MailEventType.folderUpdate,
        announced('2099-01-01T10:00:00Z'),
      );
      await _settle();
      expect(mailbox.messages.map((m) => m.id), [1]);
      expect(mailbox.error, isNull);
    });

    test('tells an open reader of the change', () async {
      final heard = <ThreadSnooze>[];
      final listening = mailbox.threadSnoozes.listen(heard.add);
      addTearDown(listening.cancel);
      server.push(
        MailEventType.folderUpdate,
        announced('2099-01-01T10:00:00Z'),
      );
      await _settle();
      expect(heard.single.threadId, 'thread-1');
      expect(heard.single.snoozedUntil!.toUtc(), DateTime.utc(2099, 1, 1, 10));
    });

    test('brings it back when the deadline is cleared', () async {
      server.inbox = [_message(1, thread: 'thread-2')];
      server.push(
        MailEventType.folderUpdate,
        announced('2099-01-01T10:00:00Z'),
      );
      await _settle();
      expect(mailbox.messages.map((m) => m.id), [1]);

      server.inbox = [
        _message(3, thread: 'thread-1'),
        _message(2, thread: 'thread-1'),
        _message(1, thread: 'thread-2'),
      ];
      server.events.add(
        utf8.encode(
          'event: folder_update\ndata: '
          '{"mailbox_id":1,"thread_id":"thread-1","snoozed_until":null}\n\n',
        ),
      );
      await _settle();
      expect(mailbox.messages.map((m) => m.id), [3, 2, 1]);
    });

    test('keeps the list when reading it again fails', () async {
      server.refuseLists = true;
      server.events.add(
        utf8.encode(
          'event: folder_update\ndata: '
          '{"mailbox_id":1,"thread_id":"thread-1","snoozed_until":null}\n\n',
        ),
      );
      await _settle();
      expect(mailbox.messages.map((m) => m.id), [3, 2, 1]);
      expect(mailbox.error, isNull);
    });

    test('for another mailbox changes nothing here', () async {
      server.inbox = [];
      server.push(
        MailEventType.folderUpdate,
        announced('2099-01-01T10:00:00Z', mailbox: 2),
      );
      await _settle();
      expect(mailbox.messages.map((m) => m.id), [3, 2, 1]);
    });

    test('without its deadline is an ordinary folder update', () async {
      server.inbox = [];
      server.push(MailEventType.folderUpdate, announced(null));
      await _settle();
      expect(mailbox.messages.map((m) => m.id), [3, 2, 1]);
    });
  });

  test('a message read on another device shows as read here', () async {
    final server = _Server()..inbox = [_message(1)];
    final mailbox = MailboxState(RestBackend(server.client));
    addTearDown(mailbox.dispose);
    await mailbox.start();
    await _settle();

    server.push(MailEventType.messageUpdated, {
      'message_id': 1,
      'folder': 'INBOX',
      'is_read': true,
    });
    await _settle();

    expect(mailbox.messages.single.isRead, isTrue);
  });

  test('a delete the server refuses puts the message back', () async {
    final server = _Server()
      ..inbox = [_message(1)]
      ..refuseDeletes = true;
    final mailbox = MailboxState(RestBackend(server.client));
    addTearDown(mailbox.dispose);
    await mailbox.start();

    await expectLater(
      mailbox.delete(mailbox.messages.single),
      throwsA(isA<ApiException>()),
    );

    expect(mailbox.messages.map((m) => m.id), [1]);
  });
}
