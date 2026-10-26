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
          201,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  });
  tearDown(() => client.close());

  test(
    'a forward sends from, to and the note, and reads the sent message',
    () async {
      reply = {
        'data': {
          'id': 42,
          'mailbox_id': 2,
          'folder': 'Sent',
          'sender': 'me@example.test',
          'subject': 'Fwd: Hello',
          'recipients_to': [
            {'address': 'them@example.test'},
          ],
          'is_read': true,
          'is_flagged': false,
          'is_starred': false,
          'is_draft': false,
          'is_deleted': false,
          'received_at': '2026-01-01T00:00:00Z',
          'created_at': '2026-01-01T00:00:00Z',
          'updated_at': '2026-01-01T00:00:00Z',
        },
      };
      final message = await client.forwardMessage(
        5,
        from: 'me@example.test',
        to: ['them@example.test'],
        bodyText: 'note',
      );
      expect(sent.method, 'POST');
      expect(sent.url.path, '/api/v1/messages/5/forward');
      expect(jsonDecode(sent.body), {
        'from': 'me@example.test',
        'to': ['them@example.test'],
        'body_text': 'note',
      });
      expect(message.id, 42);
      expect(message.subject, 'Fwd: Hello');
      expect(message.folder, StandardFolder.sent);
    },
  );

  test('a forward without a note leaves body_text out', () async {
    reply = {
      'data': {
        'id': 7,
        'mailbox_id': 2,
        'folder': 'Sent',
        'sender': 'me@example.test',
        'subject': 'Fwd: Hi',
        'recipients_to': [
          {'address': 'them@example.test'},
        ],
        'is_read': true,
        'is_flagged': false,
        'is_starred': false,
        'is_draft': false,
        'is_deleted': false,
        'received_at': '2026-01-01T00:00:00Z',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
      },
    };
    await client.forwardMessage(
      9,
      from: 'me@example.test',
      to: ['them@example.test'],
    );
    expect(jsonDecode(sent.body), {
      'from': 'me@example.test',
      'to': ['them@example.test'],
    });
  });
}
