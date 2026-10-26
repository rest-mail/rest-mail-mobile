import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

http.Response _json(Object value, int status) => http.Response.bytes(
  utf8.encode(jsonEncode(value)),
  status,
  headers: {'content-type': 'application/json'},
);

Map<String, Object> get _sent => {
  'id': 19,
  'mailbox_id': 7,
  'folder': 'Sent',
  'sender': 'ada@example.test',
  'subject': 'Fwd: receipt',
  'body_text': 'Please review\n\noriginal receipt',
  'has_attachments': true,
  'received_at': '2026-10-26T12:00:00Z',
};

RestmailClient _client(Future<http.Response> Function(http.Request) handler) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      httpClient: MockClient(handler),
      tokens: SessionTokens(
        accessToken: 'access-one',
        refreshToken: 'refresh-one',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
    );

void main() {
  test(
    'forwards by stored ID with only sender, recipients and new note',
    () async {
      late http.Request request;
      final client = _client((r) async {
        request = r;
        return _json({'data': _sent}, 201);
      });
      addTearDown(client.close);
      final result = await client.forwardMessage(
        9,
        from: 'ada@example.test',
        to: ['reader@example.test', 'other@example.test'],
        bodyText: 'Please review',
      );
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/messages/9/forward');
      expect(request.headers['authorization'], 'Bearer access-one');
      expect(jsonDecode(request.body), {
        'from': 'ada@example.test',
        'to': ['reader@example.test', 'other@example.test'],
        'body_text': 'Please review',
      });
      expect(result, isA<ForwardSent>());
      final message = (result as ForwardSent).message;
      expect(message.id, 19);
      expect(message.hasAttachments, isTrue);
      expect(message.bodyText, contains('original receipt'));
    },
  );

  test('outbound policy discard is a distinct successful result', () async {
    final client = _client(
      (_) async => _json({
        'data': {'status': 'discarded'},
      }, 200),
    );
    addTearDown(client.close);
    expect(
      await client.forwardMessage(
        9,
        from: 'ada@example.test',
        to: ['reader@example.test'],
      ),
      isA<ForwardDiscarded>(),
    );
  });

  for (final (status, code) in [
    (400, 'bad_request'),
    (403, 'forbidden'),
    (404, 'message_not_found'),
    (413, 'message_too_large'),
    (422, 'mailbox_full'),
    (500, 'attachment_unavailable'),
    (503, 'deferred'),
  ]) {
    test('preserves $status $code and never falls back to send', () async {
      var attempts = 0;
      final client = _client((r) async {
        attempts++;
        expect(r.url.path, '/api/v1/messages/9/forward');
        return _json({
          'error': {'code': code, 'message': 'Refused'},
        }, status);
      });
      addTearDown(client.close);
      await expectLater(
        client.forwardMessage(
          9,
          from: 'ada@example.test',
          to: ['reader@example.test'],
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', status)
              .having((e) => e.code, 'code', code),
        ),
      );
      expect(attempts, 1);
    });
  }

  test('preserves validation details', () async {
    final client = _client(
      (_) async => _json({
        'error': {
          'code': 'validation_failed',
          'message': 'Invalid',
          'details': {
            'fields': {'to[0]': 'Invalid email address'},
          },
        },
      }, 422),
    );
    addTearDown(client.close);
    await expectLater(
      client.forwardMessage(9, from: 'ada@example.test', to: ['bad']),
      throwsA(
        isA<ApiException>().having((e) => e.fields, 'fields', {
          'to[0]': 'Invalid email address',
        }),
      ),
    );
  });

  for (final (status, data) in [
    (200, _sent),
    (201, <String, Object>{'status': 'discarded'}),
    (202, _sent),
    (
      201,
      <String, Object>{
        'id': 19,
        'mailbox_id': 7,
        'folder': 7,
        'received_at': '2026-10-26T12:00:00Z',
      },
    ),
  ]) {
    test(
      'unexpected $status result (${data['status'] ?? data['folder'] ?? 'message'}) becomes a readable protocol error',
      () async {
        final client = _client((_) async => _json({'data': data}, status));
        addTearDown(client.close);
        await expectLater(
          client.forwardMessage(
            9,
            from: 'ada@example.test',
            to: ['reader@example.test'],
          ),
          throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
          ),
        );
      },
    );
  }
}
