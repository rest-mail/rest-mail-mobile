import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/state/mailbox_state.dart';
import 'package:restmail_api/restmail_api.dart';

Map<String, dynamic> _message(
  int id, {
  String received = '2026-09-10T10:00:00Z',
  bool read = false,
}) => {
  'id': id,
  'mailbox_id': 1,
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
    final mailbox = MailboxState(server.client);
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
    final mailbox = MailboxState(server.client);
    addTearDown(mailbox.dispose);
    await mailbox.start();
    await _settle();
    expect(mailbox.live, LiveStatus.live);

    server.inbox = [_message(2, received: '2026-09-10T11:00:00Z'), _message(1)];
    server.push(MailEventType.newMessage, {'message_id': 2, 'folder': 'INBOX'});
    await _settle();

    expect(mailbox.messages.map((m) => m.id), [2, 1]);
  });

  test('a message read on another device shows as read here', () async {
    final server = _Server()..inbox = [_message(1)];
    final mailbox = MailboxState(server.client);
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
    final mailbox = MailboxState(server.client);
    addTearDown(mailbox.dispose);
    await mailbox.start();

    await expectLater(
      mailbox.delete(mailbox.messages.single),
      throwsA(isA<ApiException>()),
    );

    expect(mailbox.messages.map((m) => m.id), [1]);
  });
}
