import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

final _server = Uri.parse('https://mail.example.test');
SessionTokens _tokens() => SessionTokens(
  accessToken: 'access',
  refreshToken: 'refresh',
  accessExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
);
http.Response _json(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json'},
);

void main() {
  test('listing sends every supported filter and pagination field', () async {
    late http.Request sent;
    final client = RestmailClient(
      server: _server,
      tokens: _tokens(),
      httpClient: MockClient((request) async {
        sent = request;
        return _json({
          'data': {'items': <Object>[], 'offset': 50, 'total': 75},
        });
      }),
    );
    final result = await client.queue(
      status: QueueStatus.delivering,
      domain: 'destination.test',
      sender: 'a+b_%',
      recipient: 'user@remote.test',
      offset: 50,
      limit: 25,
    );
    expect(sent.method, 'GET');
    expect(sent.url.path, '/api/v1/admin/queue');
    expect(sent.url.queryParameters, {
      'status': 'delivering',
      'domain': 'destination.test',
      'sender': 'a+b_%',
      'recipient': 'user@remote.test',
      'offset': '50',
      'limit': '25',
    });
    expect(result.offset, 50);
    expect(result.total, 75);
  });

  for (final (verb, path, action)
      in <
        (
          String,
          String,
          Future<BulkQueueResult> Function(RestmailClient, QueueSelection),
        )
      >[
        (
          'POST',
          'bulk-retry',
          (client, selection) => client.bulkRetryQueue(selection),
        ),
        (
          'POST',
          'bulk-bounce',
          (client, selection) => client.bulkBounceQueue(selection),
        ),
        (
          'DELETE',
          'bulk-delete',
          (client, selection) => client.bulkDeleteQueue(selection),
        ),
      ]) {
    test('$path sends IDs without a filter and reads affected count', () async {
      late http.Request sent;
      final client = RestmailClient(
        server: _server,
        tokens: _tokens(),
        httpClient: MockClient((request) async {
          sent = request;
          return _json({
            'data': {'affected': 2},
          });
        }),
      );
      expect((await action(client, QueueSelection.ids([2, 9]))).affected, 2);
      expect(sent.method, verb);
      expect(sent.url.path, '/api/v1/admin/queue/$path');
      expect(jsonDecode(sent.body), {
        'ids': [2, 9],
      });
    });

    test('$path sends all filter fields without IDs', () async {
      late http.Request sent;
      final client = RestmailClient(
        server: _server,
        tokens: _tokens(),
        httpClient: MockClient((request) async {
          sent = request;
          return _json({
            'data': {'affected': 0},
          });
        }),
      );
      final result = await action(
        client,
        const QueueSelection.filter(
          QueueFilter(
            status: QueueStatus.deferred,
            domain: 'remote.test',
            sender: 'sender',
            recipient: 'recipient',
          ),
        ),
      );
      expect(result.affected, 0);
      expect(jsonDecode(sent.body), {
        'filter': {
          'status': 'deferred',
          'domain': 'remote.test',
          'sender': 'sender',
          'recipient': 'recipient',
        },
      });
    });
  }

  test('explicit empty filter selects all pages, missing selection cannot be constructed', () {
    expect(const QueueSelection.filter(QueueFilter()).toJson(), {
      'filter': <String, String>{},
    });
    expect(() => QueueSelection.ids([]), throwsArgumentError);
    expect(() => QueueSelection.ids(List.filled(1001, 1)), throwsArgumentError);
    expect(() => QueueSelection.ids([0]), throwsArgumentError);
    final ids = [1];
    final selection = QueueSelection.ids(ids);
    ids.add(2);
    expect(selection.ids, [1]);
  });

  test(
    'bulk 403 keeps the session, malformed result is bad_response',
    () async {
      var sent = 0;
      final tokens = _tokens();
      var refused = true;
      final client = RestmailClient(
        server: _server,
        tokens: tokens,
        httpClient: MockClient((request) async {
          sent++;
          return refused
              ? _json({
                  'error': {'code': 'forbidden', 'message': 'No permission'},
                }, 403)
              : _json({'data': <String, Object>{}});
        }),
      );
      await expectLater(
        client.bulkRetryQueue(QueueSelection.ids([1])),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(client.tokens, same(tokens));
      expect(sent, 1);
      refused = false;
      await expectLater(
        client.bulkDeleteQueue(QueueSelection.ids([1])),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
        ),
      );
    },
  );

  test('queue detail retains every response field, including failure and body type', () async {
    late http.Request sent;
    final client = RestmailClient(
      server: _server,
      tokens: _tokens(),
      httpClient: MockClient((request) async {
        sent = request;
        return _json({
          'data': {
            'id': 9,
            'message_id': 3,
            'sender': 'a@local.test',
            'recipient': 'b@remote.test',
            'domain': 'remote.test',
            'body_type': '8BITMIME',
            'failure_category': 'mailbox_full',
            'status': 'deferred',
            'attempts': 2,
            'max_retries': 30,
            'last_error': 'Mailbox full',
            'last_error_code': 452,
            'created_at': '2026-10-22T12:00:00Z',
            'last_attempt': '2026-10-22T12:01:00Z',
            'next_attempt': '2026-10-22T12:05:00Z',
            'expires_at': '2026-10-27T12:00:00Z',
          },
        });
      }),
    );
    final entry = await client.queueEntry(9);
    expect(sent.url.path, '/api/v1/admin/queue/9');
    expect(entry.bodyType, '8BITMIME');
    expect(entry.failureCategory, 'mailbox_full');
    expect(entry.messageId, 3);
    expect(entry.lastErrorCode, 452);
    expect(entry.lastAttempt, isNotNull);
    expect(entry.nextAttempt, isNotNull);
    expect(entry.expiresAt, isNotNull);
  });
}
