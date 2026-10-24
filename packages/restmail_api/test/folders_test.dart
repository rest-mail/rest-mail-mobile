import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object? reply;
  late int status;
  setUp(() {
    reply = {
      'data': {'name': 'Receipts'},
    };
    status = 201;
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
          reply == null ? const [] : utf8.encode(jsonEncode(reply)),
          status,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  });
  tearDown(() => client.close());

  test('a folder is created with its name, and the stored name read', () async {
    reply = {
      'data': {'name': 'INBOX'},
    };
    expect(await client.createFolder(3, 'inbox'), 'INBOX');
    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/accounts/3/folders');
    expect(jsonDecode(sent.body), {'name': 'inbox'});
  });

  test('a rename names the folder in one escaped segment', () async {
    status = 200;
    reply = {
      'data': {'name': 'Work/2026'},
    };
    expect(
      await client.renameFolder(3, 'Work/Old mail', 'Work/2026'),
      'Work/2026',
    );
    expect(sent.method, 'PATCH');
    expect(
      sent.url.toString(),
      'https://mail.example.com/api/v1/accounts/3/folders/Work%2FOld%20mail',
    );
    expect(jsonDecode(sent.body), {'name': 'Work/2026'});
  });

  test('a delete expects no content', () async {
    status = 204;
    reply = null;
    await client.deleteFolder(3, 'Receipts');
    expect(sent.method, 'DELETE');
    expect(sent.url.path, '/api/v1/accounts/3/folders/Receipts');

    status = 200;
    reply = {'data': <String, Object?>{}};
    await expectLater(
      client.deleteFolder(3, 'Receipts'),
      throwsA(isA<ApiException>()),
    );
  });

  test(
    'an answer without the name, or with another status, is unreadable',
    () async {
      for (final (code, body) in [
        (201, <String, Object?>{'data': <String, Object?>{}}),
        (
          201,
          {
            'data': {'name': ''},
          },
        ),
        (
          201,
          {
            'data': {'name': 7},
          },
        ),
        (
          200,
          {
            'data': {'name': 'Receipts'},
          },
        ),
      ]) {
        status = code;
        reply = body;
        await expectLater(
          client.createFolder(3, 'Receipts'),
          throwsA(isA<ApiException>()),
          reason: '$code $body',
        );
      }
    },
  );

  test('a refusal carries its code and message', () async {
    status = 400;
    reply = {
      'error': {
        'code': 'bad_request',
        'message': 'Cannot rename standard folder',
      },
    };
    await expectLater(
      client.renameFolder(3, 'INBOX', 'Old'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 400)
            .having((e) => e.code, 'code', 'bad_request')
            .having(
              (e) => e.message,
              'message',
              'Cannot rename standard folder',
            ),
      ),
    );
  });
}
