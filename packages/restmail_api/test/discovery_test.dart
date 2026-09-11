import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

http.Response _healthy() => http.Response(
  jsonEncode({
    'data': {'status': 'healthy', 'db': 'connected'},
  }),
  200,
);

void main() {
  test('finds a server on the domain itself', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/health');
      return request.url.host == 'example.test'
          ? _healthy()
          : http.Response('', 404);
    });
    expect(
      await discoverServer('ada@example.test', httpClient: client),
      Uri.parse('https://example.test'),
    );
  });

  test('falls back to mail.<domain>', () async {
    final client = MockClient(
      (request) async => request.url.host == 'mail.example.test'
          ? _healthy()
          : throw http.ClientException('No route to host'),
    );
    expect(
      await discoverServer('ada@example.test', httpClient: client),
      Uri.parse('https://mail.example.test'),
    );
  });

  test('a web page that is not rest-mail does not count', () async {
    final client = MockClient(
      (_) async => http.Response('<html>hello</html>', 200),
    );
    expect(
      await discoverServer('ada@example.test', httpClient: client),
      isNull,
    );
  });

  test('an address with no domain finds nothing without asking', () async {
    final client = MockClient((_) async => fail('should not be called'));
    expect(await discoverServer('ada@', httpClient: client), isNull);
    expect(await discoverServer('ada', httpClient: client), isNull);
  });
}
