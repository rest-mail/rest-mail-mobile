import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object reply;
  late int status;
  setUp(() {
    status = 200;
    reply = {
      'data': {
        'algorithm': 'restmail-seal-v1',
        'state': 'intact',
        'sealed_hash': 'a' * 64,
        'computed_hash': 'a' * 64,
      },
    };
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        sent = request;
        return http.Response(
          jsonEncode(reply),
          status,
          headers: {
            'content-type': 'application/json',
            ...contractSecurityHeaders,
          },
        );
      }),
    );
  });
  tearDown(() => client.close());

  for (final (wire, state) in [
    ('intact', MessageSealState.intact),
    ('mismatch', MessageSealState.mismatch),
    ('not_sealed', MessageSealState.notSealed),
  ]) {
    test('the generated seal call decodes $wire', () async {
      reply = {
        'data': {
          'algorithm': 'restmail-seal-v1',
          'state': wire,
          if (wire != 'not_sealed') ...{
            'sealed_hash': 'a' * 64,
            'computed_hash': (wire == 'mismatch' ? 'b' : 'a') * 64,
          },
        },
      };
      final seal = await client.verifyMessageSeal(42);
      expect(sent.method, 'GET');
      expect(sent.url.path, '/api/v1/messages/42/seal');
      expect(sent.headers['authorization'], 'Bearer access');
      expect(seal.state, state);
      expect(seal.algorithm, 'restmail-seal-v1');
      expect(seal.sealedHash, wire == 'not_sealed' ? null : 'a' * 64);
      expect(
        seal.computedHash,
        wire == 'not_sealed' ? null : (wire == 'mismatch' ? 'b' : 'a') * 64,
      );
    });
  }

  for (final code in [403, 404, 500]) {
    test('$code is an error, never an integrity verdict', () async {
      status = code;
      reply = {
        'error': {'code': 'not_available', 'message': 'Unavailable'},
      };
      await expectLater(
        client.verifyMessageSeal(42),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'status',
            code,
          ),
        ),
      );
    });
  }

  for (final data in [
    {'algorithm': 'restmail-seal-v1', 'state': 'checking'},
    {'algorithm': 'restmail-seal-v1', 'state': 'unknown'},
    {'algorithm': 'unknown', 'state': 'intact'},
    {'sealed_hash': 'a' * 64},
  ]) {
    test('a malformed or future response is unavailable: $data', () async {
      reply = {'data': data};
      await expectLater(
        client.verifyMessageSeal(42),
        throwsA(
          isA<ApiException>().having(
            (error) => error.code,
            'code',
            'bad_response',
          ),
        ),
      );
    });
  }

  test('a pending request cannot yield a verdict', () async {
    final answer = Completer<http.Response>();
    final pending = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: client.tokens,
      httpClient: MockClient((_) => answer.future),
    );
    addTearDown(pending.close);
    var completed = false;
    final result = pending.verifyMessageSeal(42).then((value) {
      completed = true;
      return value;
    });
    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);
    answer.complete(
      http.Response(
        jsonEncode(reply),
        200,
        headers: {
          'content-type': 'application/json',
          ...contractSecurityHeaders,
        },
      ),
    );
    expect((await result).state, MessageSealState.intact);
  });

  test('message parsing and flag copies preserve seal and stored checks', () {
    final message = Message.fromJson({
      'id': 42,
      'mailbox_id': 3,
      'folder': 'INBOX',
      'received_at': '2026-11-03T00:00:00Z',
      'sealed_hash': 'a' * 64,
      'auth_results': [
        {
          'method': 'dkim',
          'result': 'pass',
          'property': 'header.d',
          'domain': 'example.com',
        },
        {'method': 'spf', 'result': 'future'},
      ],
    });
    final copy = message.copyWith(isRead: true, folder: 'Archive');
    expect(copy.sealedHash, 'a' * 64);
    expect(copy.authResults.first.method, 'dkim');
    expect(copy.authResults.first.domain, 'example.com');
    expect(copy.authResults.first.identity, 'header.d');
    expect(copy.authResults.last.result, 'unknown');
    expect(message.copyWith(isFlagged: true).sealedHash, message.sealedHash);
  });
}
