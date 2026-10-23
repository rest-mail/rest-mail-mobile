import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  for (final (action, acknowledgement, invoke)
      in <(String, String, Future<QueueActionResult> Function(RestmailClient))>[
        ('retry', 'retrying', (client) => client.retryQueueEntry(17)),
        ('bounce', 'bounced', (client) => client.bounceQueueEntry(17)),
      ]) {
    RestmailClient client(
      http.Response Function() answer,
      List<http.Request> sent,
    ) => RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: SessionTokens(
        accessToken: 'ack-access',
        refreshToken: 'ack-refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        sent.add(request);
        return answer();
      }),
    );

    test(
      '$action parses the actual server acknowledgement and sends the exact request',
      () async {
        final sent = <http.Request>[];
        final api = client(
          () => http.Response(
            jsonEncode({
              'data': {'status': acknowledgement},
            }),
            200,
          ),
          sent,
        );
        addTearDown(api.close);
        final result = await invoke(api);
        expect(result.status, acknowledgement);
        expect(sent, hasLength(1));
        expect(sent.single.method, 'POST');
        expect(sent.single.url.path, '/api/v1/admin/queue/17/$action');
        expect(sent.single.url.query, isEmpty);
        expect(sent.single.body, isEmpty);
        expect(sent.single.headers['authorization'], 'Bearer ack-access');
      },
    );

    for (final (label, body, status) in <(String, Object?, int)>[
      ('missing envelope', <String, Object?>{}, 200),
      ('missing status', {'data': <String, Object?>{}}, 200),
      (
        'null status',
        {
          'data': {'status': null},
        },
        200,
      ),
      (
        'wrong status type',
        {
          'data': {'status': 1},
        },
        200,
      ),
      (
        'unexpected acknowledgement',
        {
          'data': {'status': 'not_processed'},
        },
        200,
      ),
      (
        'unexpected created response',
        {
          'data': {'status': acknowledgement},
        },
        201,
      ),
      ('unexpected no-content response', null, 204),
    ]) {
      test(
        '$action rejects $label without retrying a mutation or ending the session',
        () async {
          final sent = <http.Request>[];
          final api = client(
            () => http.Response(body == null ? '' : jsonEncode(body), status),
            sent,
          );
          addTearDown(api.close);
          final before = api.tokens;
          await expectLater(
            invoke(api),
            throwsA(
              isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
            ),
          );
          expect(sent, hasLength(1));
          expect(api.tokens, same(before));
        },
      );
    }

    for (final status in [400, 403, 404]) {
      test(
        '$action preserves $status refusals and keeps the session',
        () async {
          final sent = <http.Request>[];
          final api = client(
            () => http.Response(
              jsonEncode({
                'error': {'code': 'refused', 'message': 'Operation refused'},
              }),
              status,
            ),
            sent,
          );
          addTearDown(api.close);
          final before = api.tokens;
          await expectLater(
            invoke(api),
            throwsA(
              isA<ApiException>().having(
                (e) => e.statusCode,
                'statusCode',
                status,
              ),
            ),
          );
          expect(sent, hasLength(1));
          expect(api.tokens, same(before));
        },
      );
    }
  }
}
