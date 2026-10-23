import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

const _held = <String, dynamic>{
  'id': 7,
  'mailbox_id': 3,
  'sender': 'deals@spam.test',
  'subject': 'You won',
  'body_preview': 'Click here to claim',
  'spam_score': 9.5,
  'quarantine_reason': 'spam_threshold',
  'received_at': '2026-10-23T09:00:00Z',
  'expires_at': '2026-11-22T09:00:00Z',
  'released': false,
};

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object reply;
  late int status;
  late int calls;
  setUp(() {
    reply = {
      'data': [_held],
      'pagination': {'has_more': false, 'total': 1},
    };
    status = 200;
    calls = 0;
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        calls++;
        sent = request;
        return http.Response.bytes(
          utf8.encode(jsonEncode(reply)),
          status,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  });
  tearDown(() => client.close());

  test('the list pages and reads every field', () async {
    final page = await client.quarantine(3, offset: 50, limit: 25);
    expect(sent.method, 'GET');
    expect(sent.url.path, '/api/v1/accounts/3/quarantine');
    expect(sent.url.queryParameters, {'limit': '25', 'offset': '50'});
    expect(sent.headers['Authorization'], 'Bearer access');
    expect(page.total, 1);
    final item = page.items.single;
    expect(item.id, 7);
    expect(item.mailboxId, 3);
    expect(item.sender, 'deals@spam.test');
    expect(item.subject, 'You won');
    expect(item.bodyPreview, 'Click here to claim');
    expect(item.reason, 'spam_threshold');
    expect(item.spamScore, 9.5);
    expect(item.receivedAt!.toUtc(), DateTime.utc(2026, 10, 23, 9));
    expect(item.expiresAt!.toUtc(), DateTime.utc(2026, 11, 22, 9));
  });

  test('an unset time and a missing score read as none', () async {
    reply = {
      'data': [
        {
          ..._held,
          'spam_score': null,
          'received_at': '0001-01-01T00:00:00Z',
          'expires_at': '0001-01-01T00:00:00Z',
        },
      ],
      'pagination': {'has_more': false, 'total': 1},
    };
    final item = (await client.quarantine(3)).items.single;
    expect(item.spamScore, isNull);
    expect(item.receivedAt, isNull);
    expect(item.expiresAt, isNull);
  });

  test('release delivers and returns the new message id', () async {
    reply = {
      'data': {'status': 'released', 'message_id': '42'},
    };
    final id = await client.releaseQuarantined(3, 7);
    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/accounts/3/quarantine/7/release');
    expect(id, 42);
  });

  for (final (what, body) in <(String, Object)>[
    (
      'another status',
      {
        'data': {'status': 'queued', 'message_id': '42'},
      },
    ),
    (
      'no message id',
      {
        'data': {'status': 'released'},
      },
    ),
    ('no data', <String, Object?>{}),
  ]) {
    test('release with $what is not taken as done', () async {
      reply = body;
      await expectLater(
        client.releaseQuarantined(3, 7),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
        ),
      );
    });
  }

  test('delete reads the deleted acknowledgement', () async {
    reply = {
      'data': {'status': 'deleted'},
    };
    await client.deleteQuarantined(3, 7);
    expect(sent.method, 'DELETE');
    expect(sent.url.path, '/api/v1/accounts/3/quarantine/7');
    expect(calls, 1);
  });

  test('delete with another status is not taken as done', () async {
    reply = {
      'data': {'status': 'kept'},
    };
    await expectLater(
      client.deleteQuarantined(3, 7),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
      ),
    );
  });

  for (final call in [
    (RestmailClient c) => c.releaseQuarantined(3, 7),
    (RestmailClient c) => c.deleteQuarantined(3, 7),
  ]) {
    test('a message gone already is a 404 the session survives', () async {
      reply = {
        'error': {
          'code': 'not_found',
          'message': 'Quarantined message not found',
        },
      };
      status = 404;
      await expectLater(
        call(client),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.code, 'code', 'not_found'),
        ),
      );
      expect(client.tokens!.accessToken, 'access');
    });
  }
}
