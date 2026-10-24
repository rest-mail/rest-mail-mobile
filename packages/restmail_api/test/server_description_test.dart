import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  late http.Request sent;
  late http.Response reply;
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
        return reply;
      }),
    );
  });
  tearDown(() => client.close());

  http.Response json(Object body, [int status = 200]) => http.Response.bytes(
    utf8.encode(jsonEncode(body)),
    status,
    headers: {'content-type': 'application/json'},
  );

  test('reads the product and version, without the session', () async {
    reply = json({
      'data': {'product': 'rest-mail', 'version': '0.21.0'},
    });
    final server = await client.describeServer();
    expect(sent.method, 'GET');
    expect(sent.url.path, '/api/v1/server');
    expect(sent.headers['authorization'], isNull);
    expect((server.product, server.version), ('rest-mail', '0.21.0'));
  });

  test('an answer without a version is unreadable', () async {
    for (final data in <Map<String, Object?>>[
      {'product': 'rest-mail'},
      {'product': 'rest-mail', 'version': ''},
      {'version': '0.21.0'},
      {'product': 'rest-mail', 'version': 21},
    ]) {
      reply = json({'data': data});
      await expectLater(
        client.describeServer(),
        throwsA(isA<ApiException>()),
        reason: '$data',
      );
    }
  });
}
