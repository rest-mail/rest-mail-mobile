import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import '../../restmail_fake/test/fixtures/certificate.dart';

final _tokens = SessionTokens(
  accessToken: 'access',
  refreshToken: 'refresh',
  accessExpiresAt: DateTime.utc(2099),
);
RestmailClient _client(Future<http.Response> Function(http.Request) send) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: _tokens,
      httpClient: MockClient(send),
    );
http.Response _json(Object? body, {int status = 200}) =>
    http.Response(jsonEncode({'data': body}), status);

Map<String, Object?> _metadata() => {
  'id': 12,
  'domain_id': 42,
  'issuer': testCertificateIssuer,
  'not_before': testCertificateNotBefore.toIso8601String(),
  'not_after': testCertificateNotAfter.toIso8601String(),
  'auto_renew': false,
  'created_at': '2026-10-23T06:00:00Z',
  'updated_at': '2026-10-23T06:01:00Z',
  'domain': {
    'id': 42,
    'name': 'fixture.restmail.test',
    'active': false,
    'server_type': 'traditional',
    'default_quota_bytes': 1000,
    'sending_policy': 'bulk',
    'dkim_selector': 'mail',
  },
};

void main() {
  test(
    'exact certificate/key bytes, optional renewal and complete returned metadata',
    () async {
      final key = testCertificateKey.replaceAll('\n', '\r\n');
      final client = _client((r) async {
        expect(r.method, 'POST');
        expect(r.url.path, '/api/v1/admin/certificates');
        expect(jsonDecode(r.body), {
          'domain_id': 42,
          'cert_pem': testCertificatePem,
          'key_pem': key,
          'auto_renew': false,
        });
        return _json(_metadata(), status: 201);
      });
      addTearDown(client.close);
      final cert = await client.uploadCertificate(
        domainId: 42,
        certPem: testCertificatePem,
        keyPem: key,
        autoRenew: false,
      );
      expect(cert.certPem, isEmpty);
      expect(cert.autoRenew, isFalse);
      expect(cert.domainDetails!.sendingPolicy, 'bulk');
      expect(cert.domainDetails!.defaultQuotaBytes, 1000);
      expect(cert.domainDetails!.dkimSelector, 'mail');
      expect(cert.createdAt!.toUtc(), DateTime.utc(2026, 10, 23, 6));
      expect(cert.updatedAt!.toUtc(), DateTime.utc(2026, 10, 23, 6, 1));
    },
  );

  test(
    'detail reads public PEM while preserving validity and full domain association',
    () async {
      final client = _client((r) async {
        expect(r.method, 'GET');
        expect(r.url.path, '/api/v1/admin/certificates/12');
        return _json({..._metadata(), 'cert_pem': testCertificatePem});
      });
      addTearDown(client.close);
      final cert = await client.certificate(12);
      expect(cert.certPem, testCertificatePem);
      expect(cert.issuer, testCertificateIssuer);
      expect(cert.notBefore.toUtc(), testCertificateNotBefore);
      expect(cert.notAfter.toUtc(), testCertificateNotAfter);
      expect(cert.domain, 'fixture.restmail.test');
    },
  );

  test(
    'list queries page precisely and parses nullable or omitted domain/PEM',
    () async {
      final client = _client((r) async {
        expect(r.url.queryParameters, {'offset': '7', 'limit': '3'});
        return http.Response(
          jsonEncode({
            'data': [
              {..._metadata(), 'domain': null},
            ],
            'pagination': {'total': 8},
          }),
          200,
        );
      });
      addTearDown(client.close);
      final page = await client.certificates(offset: 7, limit: 3);
      expect(page.total, 8);
      expect(page.offset, 7);
      expect(page.items.single.domainDetails, isNull);
      expect(page.items.single.domain, isEmpty);
      expect(page.items.single.certPem, isEmpty);
    },
  );

  for (final operation in ['list', 'get', 'upload', 'delete']) {
    test('$operation 403 retains session and never refreshes', () async {
      var calls = 0;
      final client = _client((r) async {
        calls++;
        expect(r.url.path, isNot(contains('/auth/refresh')));
        return http.Response(
          '{"error":{"code":"forbidden","message":"No permission"}}',
          403,
        );
      });
      addTearDown(client.close);
      final Future<Object?> request = switch (operation) {
        'list' => client.certificates(),
        'get' => client.certificate(12),
        'upload' => client.uploadCertificate(
          domainId: 42,
          certPem: testCertificatePem,
          keyPem: testCertificateKey,
        ),
        _ => client.deleteCertificate(12),
      };
      await expectLater(
        request,
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(calls, 1);
      expect(client.tokens, same(_tokens));
    });
  }

  test(
    'missing certificate and invalid input preserve server codes and login',
    () async {
      var calls = 0;
      final client = _client(
        (r) async => ++calls == 1
            ? http.Response(
                '{"error":{"code":"not_found","message":"Certificate not found"}}',
                404,
              )
            : http.Response(
                '{"error":{"code":"validation_failed","message":"Request body failed validation","details":{"fields":{"cert_pem":"Invalid certificate PEM"}}}}',
                422,
              ),
      );
      addTearDown(client.close);
      await expectLater(
        client.certificate(999),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'not_found')),
      );
      await expectLater(
        client.uploadCertificate(
          domainId: 42,
          certPem: 'bad',
          keyPem: testCertificateKey,
        ),
        throwsA(
          isA<ApiException>().having((e) => e.fields, 'fields', {
            'cert_pem': 'Invalid certificate PEM',
          }),
        ),
      );
      expect(client.tokens, same(_tokens));
    },
  );
}
