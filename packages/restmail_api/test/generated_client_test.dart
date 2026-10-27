import 'dart:async';
import 'dart:convert';
import 'dart:io' show HandshakeException;

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/generated.dart' as wire;
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

const _headers = {
  'content-type': 'application/json',
  'content-security-policy': "default-src 'none'",
  'referrer-policy': 'no-referrer',
  'strict-transport-security': 'max-age=63072000; includeSubDomains',
  'x-content-type-options': 'nosniff',
  'x-frame-options': 'DENY',
};

http.Response _json(Object body, [int status = 200]) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: _headers,
);

SessionTokens _tokens({bool expired = false}) => SessionTokens(
  accessToken: 'access-old',
  refreshToken: 'refresh-old',
  accessExpiresAt: DateTime.now().add(
    expired ? const Duration(seconds: -1) : const Duration(hours: 1),
  ),
);

http.Response _rotated() => _json({
  'data': {
    'access_token': 'access-new',
    'refresh_token': 'refresh-new',
    'expires_in': 900,
  },
});

const _domain = {
  'id': 8,
  'name': 'example.test',
  'server_type': 'restmail',
  'active': true,
  'default_quota_bytes': 500,
  'dkim_selector': 'mail',
  'sending_policy': 'transactional',
  'dmarc_policy': 'reject',
  'created_at': '2026-10-27T07:00:00Z',
  'updated_at': '2026-10-27T07:01:00Z',
};

Future<wire.ListDomainsResponse> _domains(RestmailClient client) =>
    client.generatedValue(
      wire.AdminDomainsApi(client.generatedSession)
          .listDomains(limit: 5, offset: 10),
    );

void main() {
  test(
    'generated query and every domain field use the shared TLS client',
    () async {
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test/proxy'),
        tokens: _tokens(),
        httpClient: MockClient((request) async {
          expect(request.url.path, '/proxy/api/v1/admin/domains');
          expect(request.url.queryParameters, {'limit': '5', 'offset': '10'});
          expect(request.headers['Authorization'], 'Bearer access-old');
          expect(request.headers['User-Agent'], 'restmail-mobile');
          return _json({
            'data': [_domain],
          });
        }),
      );
      addTearDown(client.close);
      final result = await _domains(client) as wire.ListDomainsResponse200;
      final domain = result.body.body.data.single;
      expect(domain.name, 'example.test');
      expect(domain.defaultQuotaBytes, 500);
      expect(domain.sendingPolicy.toJson(), 'transactional');
      expect(domain.dmarcPolicy.toJson(), 'reject');
      expect(domain.createdAt.toUtc(), DateTime.utc(2026, 10, 27, 7));
    },
  );

  test('generated create serializes the complete typed request body', () async {
    final client = RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: _tokens(),
      httpClient: MockClient((request) async {
        expect(request.method, 'POST');
        expect(jsonDecode(request.body), {
          'name': 'example.test',
          'server_type': 'restmail',
          'default_quota_bytes': 500,
          'sending_policy': 'transactional',
          'dmarc_policy': 'reject',
        });
        return _json({'data': _domain}, 201);
      }),
    );
    addTearDown(client.close);
    final result = await client.generatedValue(
      wire.AdminDomainsApi(client.generatedSession).createDomain(
        body: wire.CreateDomainRequest.fromJson({
          'name': 'example.test',
          'server_type': 'restmail',
          'default_quota_bytes': 500,
          'sending_policy': 'transactional',
          'dmarc_policy': 'reject',
        }),
      ),
    );
    expect(result, isA<wire.CreateDomainResponse201>());
  });

  test(
    'old and generated calls coalesce renewal and persist the rotated pair',
    () async {
      final changes = <SessionTokens?>[];
      var renewals = 0;
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: _tokens(expired: true),
        onTokensChanged: changes.add,
        httpClient: MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) {
            renewals++;
            await Future<void>.delayed(Duration.zero);
            return _rotated();
          }
          expect(request.headers['Authorization'], 'Bearer access-new');
          return _json({'data': <Object>[]});
        }),
      );
      addTearDown(client.close);
      await Future.wait<Object>([
        _domains(client),
        client.domains(),
        _domains(client),
      ]);
      expect(renewals, 1);
      expect(changes.single?.refreshToken, 'refresh-new');
      expect(client.tokens?.accessToken, 'access-new');
    },
  );

  test(
    'a 403 preserves scope errors and never refreshes or signs out',
    () async {
      var requests = 0;
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: _tokens(),
        onTokensChanged: changes.add,
        httpClient: MockClient((request) async {
          requests++;
          return _json({
            'error': {'code': 'forbidden', 'message': 'Outside your domain'},
          }, 403);
        }),
      );
      addTearDown(client.close);
      await expectLater(
        _domains(client),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'forbidden')),
      );
      expect(requests, 1);
      expect(changes, isEmpty);
      expect(client.tokens?.refreshToken, 'refresh-old');
    },
  );

  test(
    'one refresh retries a 401; a second 401 keeps the rotated session',
    () async {
      var attempts = 0;
      var renewals = 0;
      final changes = <SessionTokens?>[];
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: _tokens(),
        onTokensChanged: changes.add,
        httpClient: MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) {
            renewals++;
            return _rotated();
          }
          attempts++;
          expect(
            request.headers['Authorization'],
            attempts == 1 ? 'Bearer access-old' : 'Bearer access-new',
          );
          return _json({
            'error': {'code': 'unauthorized', 'message': 'Refused'},
          }, 401);
        }),
      );
      addTearDown(client.close);
      await expectLater(
        _domains(client),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 401)),
      );
      expect([attempts, renewals], [2, 1]);
      expect(changes.single?.refreshToken, 'refresh-new');
      expect(client.tokens, isNotNull);
    },
  );

  test('request retries preserve exact bytes and repeated query parameters', () async {
    final sent = <http.Request>[];
    final client = RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: _tokens(),
      httpClient: MockClient((request) async {
        if (request.url.path.endsWith('/auth/refresh')) return _rotated();
        sent.add(request);
        return _json({'data': <Object>[]}, sent.length == 1 ? 401 : 200);
      }),
    );
    addTearDown(client.close);
    final request =
        http.Request(
            'POST',
            Uri.parse(
              'https://mail.example.test/api/v1/admin/domains?x=a%20b&x=c%2Bd',
            ),
          )
          ..headers['content-type'] = 'application/json'
          ..bodyBytes = [123, 32, 34, 120, 34, 58, 49, 32, 125];
    await client.generatedSession.client.send(request);
    expect(sent, hasLength(2));
    expect(sent[0].url.toString(), sent[1].url.toString());
    expect(sent[1].url.queryParametersAll['x'], ['a b', 'c+d']);
    expect(sent[1].bodyBytes, sent[0].bodyBytes);
    expect(sent[1].body, '{ "x":1 }');
  });

  test('public calls strip authorization and need no session', () async {
    for (final tokens in <SessionTokens?>[null, _tokens()]) {
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: tokens,
        httpClient: MockClient((request) async {
          expect(request.headers.containsKey('authorization'), isFalse);
          return _json({
            'data': {'status': 'healthy', 'db': 'connected'},
          });
        }),
      );
      addTearDown(client.close);
      await client.generatedPublic.client.send(
        http.Request('GET', Uri.parse('https://mail.example.test/api/health'))
          ..headers['Authorization'] = 'must-not-leak',
      );
    }
  });

  test('foreign origin and paths outside the server base are rejected before sending', () async {
    var sent = false;
    final client = RestmailClient(
      server: Uri.parse('https://mail.example.test/proxy'),
      tokens: _tokens(),
      httpClient: MockClient((_) async {
        sent = true;
        return _json({});
      }),
    );
    addTearDown(client.close);
    for (final uri in [
      'https://evil.test/proxy/api/v1/admin/domains',
      'https://mail.example.test/api/v1/admin/domains',
    ]) {
      await expectLater(
        client.generatedSession.client.send(
          http.Request('GET', Uri.parse(uri)),
        ),
        throwsA(isA<ApiException>()),
      );
    }
    expect(sent, isFalse);
  });

  test('malformed generated success response is a bad_response', () async {
    final client = RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: _tokens(),
      httpClient: MockClient(
        (_) async => _json({
          'data': [
            {'id': 'wrong'},
          ],
        }),
      ),
    );
    addTearDown(client.close);
    await expectLater(
      _domains(client),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
      ),
    );
    expect(client.tokens, isNotNull);
  });

  test(
    'network and TLS failures preserve established errors and tokens',
    () async {
      for (final entry in <(Object, String)>[
        (http.ClientException('offline'), 'network_error'),
        (const HandshakeException('untrusted'), 'tls_error'),
      ]) {
        final client = RestmailClient(
          server: Uri.parse('https://mail.example.test'),
          tokens: _tokens(),
          httpClient: MockClient((_) async => throw entry.$1),
        );
        addTearDown(client.close);
        await expectLater(
          _domains(client),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', entry.$2)),
        );
        expect(client.tokens?.refreshToken, 'refresh-old');
      }
    },
  );
  test(
    'an aborted generated request stays cancelled without ending the session',
    () async {
      final client = RestmailClient(
        server: Uri.parse('https://mail.example.test'),
        tokens: _tokens(),
        httpClient: MockClient(
          (request) async => throw http.RequestAbortedException(request.url),
        ),
      );
      addTearDown(client.close);
      await expectLater(
        _domains(client),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'cancelled')),
      );
      expect(client.tokens, isNotNull);
    },
  );
}
