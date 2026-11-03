import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/generated.dart' as wire;
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

const _headers = {
  'content-type': 'application/json',
  ...contractSecurityHeaders,
};

Map<String, dynamic> _message() => {
  'id': 1,
  'mailbox_id': 7,
  'folder': 'Sent',
  'thread_id': 'thread/1',
  'message_id': '<1@example.test>',
  'in_reply_to': '',
  'references': '',
  'class': 'person',
  'sender': 'me@example.test',
  'sender_name': '',
  'recipients_to': ['friend@example.test'],
  'recipients_cc': <String>[],
  'subject': 'A question',
  'size_bytes': 0,
  'raw_size': 0,
  'downgraded_size': 0,
  'has_attachments': false,
  'is_read': true,
  'is_dsn': false,
  'is_flagged': false,
  'is_starred': false,
  'is_draft': false,
  'is_deleted': false,
  'received_at': '2026-11-01T12:00:00Z',
  'date_header': null,
  'created_at': '2026-11-01T12:00:00Z',
  'updated_at': '2026-11-01T12:00:00Z',
};

void main() {
  for (final field in ['absent', 'null', 'timestamp']) {
    test('reads $field from folder, search, detail and thread reads', () async {
      final message = _message();
      if (field != 'absent') {
        message['awaiting_since'] = field == 'null'
            ? null
            : '2026-11-01T13:00:00+01:00';
      }
      final expected = field == 'timestamp'
          ? DateTime.utc(2026, 11, 1, 12)
          : null;
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: SessionTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
        ),
        httpClient: MockClient(
          (request) async => http.Response(
            jsonEncode({
              'data': request.url.path == '/api/v1/messages/1'
                  ? message
                  : [message],
            }),
            200,
            headers: _headers,
          ),
        ),
      );
      addTearDown(client.close);
      for (final parsed in [
        await client.message(1),
        (await client.messages(7, 'Sent')).items.single,
        (await client.search(
          7,
          const SearchQuery(text: 'question'),
        )).items.single,
        (await client.thread(7, 'thread/1')).single,
      ]) {
        expect(parsed.awaitingSince, expected);
        expect(
          parsed.copyWith(isRead: true, folder: 'Archive').awaitingSince,
          expected,
        );
        expect(parsed.copyWith(awaitingSince: null).awaitingSince, isNull);
      }
      expect(wire.Message.fromJson(message).awaitingSince?.toUtc(), expected);
    });
  }

  test(
    'generated waiting list sends state, account and cursor, not a folder',
    () async {
      late http.Request sent;
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: SessionTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
        ),
        httpClient: MockClient((request) async {
          sent = request;
          return http.Response(
            jsonEncode({
              'data': [
                {
                  'thread_id': 'thread/1',
                  'awaiting_since': '2026-11-01T12:00:00Z',
                  'last_message': _message(),
                },
              ],
              'pagination': {'cursor': 'next+page/==', 'has_more': true},
            }),
            200,
            headers: _headers,
          );
        }),
      );
      addTearDown(client.close);
      final page = await client.awaitingThreads(
        7,
        limit: 2,
        cursor: 'older+page/==',
      );
      expect(sent.method, 'GET');
      expect(sent.url.path, '/api/v1/accounts/7/threads');
      expect(sent.url.queryParameters, {
        'state': 'awaiting',
        'limit': '2',
        'cursor': 'older+page/==',
      });
      expect(sent.headers['authorization'], 'Bearer access');
      expect(page.items.single.threadId, 'thread/1');
      expect(page.items.single.awaitingSince, DateTime.utc(2026, 11, 1, 12));
      expect(page.cursor, 'next+page/==');
      expect(page.hasMore, isTrue);
      expect(page.total, isNull);
    },
  );

  for (final status in [403, 404, 500]) {
    test('waiting list refusal $status uses the shared API error', () async {
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: SessionTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
        ),
        httpClient: MockClient(
          (request) async => http.Response(
            '{"error":{"code":"refused","message":"Refused"}}',
            status,
            headers: _headers,
          ),
        ),
      );
      addTearDown(client.close);
      await expectLater(
        client.awaitingThreads(7),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'status',
            status,
          ),
        ),
      );
      expect(client.tokens, isNotNull);
    });
  }
}
