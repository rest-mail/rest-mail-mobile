import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  test('the source is asked for as message/rfc822 and read as bytes', () async {
    late http.Request sent;
    final client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        sent = request;
        return http.Response.bytes(
          [...utf8.encode('Subject: caf'), 0xe9, ...utf8.encode('\r\n\r\nx')],
          200,
          headers: {'content-type': 'message/rfc822'},
        );
      }),
    );
    addTearDown(client.close);
    final bytes = await client.rawMessage(42);
    expect(sent.method, 'GET');
    expect(sent.url.path, '/api/v1/messages/42/raw');
    expect(sent.headers['accept'], 'message/rfc822');
    expect(sent.headers['authorization'], 'Bearer access');
    // Not UTF-8 on the wire: the bytes come back untouched.
    expect(bytes[12], 0xe9);
  });
}
