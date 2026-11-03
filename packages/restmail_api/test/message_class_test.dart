import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_api/generated.dart' as wire;
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

Map<String, dynamic> _message(Object? messageClass) => {
  'id': 1,
  'mailbox_id': 2,
  'folder': 'INBOX',
  'sender': 'person@example.test',
  'subject': 'A receipt with List-Id headers',
  'headers': {'List-Id': '<list.example.test>'},
  'received_at': '2026-11-03T12:00:00Z',
  'class': ?messageClass,
};

void main() {
  for (final value in [
    'person',
    'newsletter',
    'receipt',
    'notification',
    'future',
    '',
    null,
    42,
  ]) {
    test(
      'reads $value from list, search, direct and thread responses',
      () async {
        final client = RestmailClient(
          server: Uri.parse('https://mail.example.test'),
          tokens: SessionTokens(
            accessToken: 'access',
            refreshToken: 'refresh',
            accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
          ),
          httpClient: MockClient((request) async {
            final single = request.url.path == '/api/v1/messages/1';
            return http.Response(
              jsonEncode({
                'data': single ? _message(value) : [_message(value)],
                if (!single) 'pagination': {'has_more': false},
              }),
              200,
              headers: {
                'content-type': 'application/json',
                ...contractSecurityHeaders,
              },
            );
          }),
        );
        addTearDown(client.close);
        final expected = value is String ? value : null;
        final messages = [
          await client.message(1),
          (await client.messages(2, 'INBOX')).items.single,
          (await client.search(
            2,
            const SearchQuery(text: 'receipt'),
          )).items.single,
          (await client.thread(2, 'thread')).single,
        ];
        for (final message in messages) {
          expect(message.messageClass, expected);
          expect(
            message
                .copyWith(isRead: true, isFlagged: true, folder: 'Archive')
                .messageClass,
            expected,
          );
        }
      },
    );
  }

  test('the generated contract already knows all four classes', () {
    expect(wire.MessageClassModel.values.map((value) => value.toJson()), [
      'newsletter',
      'receipt',
      'notification',
      'person',
    ]);
  });
}
