import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

import 'fixtures/certificate.dart';

Future<RestmailClient> _client(
  FakeRestmail fake, {
  String email = FakeAccounts.adminEmail,
}) async {
  final client = RestmailClient(
    server: Uri.parse('https://${fake.host}'),
    httpClient: fake.client,
  );
  await client.login(
    email: email,
    password: email == FakeAccounts.email
        ? FakeAccounts.password
        : FakeAccounts.adminPassword,
    totpCode: FakeAccounts.totpCode,
  );
  return client;
}

void main() {
  test(
    'upload returns parsed X509 metadata, detail alone includes public PEM',
    () async {
      final now = DateTime.now().toUtc();
      final fake = FakeRestmail(clock: () => now);
      addTearDown(fake.close);
      final client = await _client(fake);
      addTearDown(client.close);
      final domain = await client.createDomain('fixture.restmail.test');
      final created = await client.uploadCertificate(
        domainId: domain.id,
        certPem: testCertificatePem,
        keyPem: testCertificateKey,
        autoRenew: false,
      );
      expect(created.domain, domain.name);
      expect(created.certPem, isEmpty);
      expect(created.issuer, testCertificateIssuer);
      expect(created.notBefore.toUtc(), testCertificateNotBefore);
      expect(created.notAfter.toUtc(), testCertificateNotAfter);
      expect(created.autoRenew, isFalse);
      expect(created.createdAt!.toUtc(), now);
      expect(created.updatedAt!.toUtc(), now);
      expect(created.domainDetails!.serverType, domain.serverType);
      final detail = await client.certificate(created.id);
      expect(detail.certPem, testCertificatePem);
      expect(detail.issuer, created.issuer);
      final listed = (await client.certificates()).items.singleWhere(
        (c) => c.id == created.id,
      );
      expect(listed.certPem, isEmpty);
      expect(listed.domainId, domain.id);
      final transport = fake.client;
      addTearDown(transport.close);
      for (final path in [
        'admin/certificates',
        'admin/certificates/${created.id}',
      ]) {
        final response = await transport.get(
          Uri.parse('https://${fake.host}/api/v1/$path'),
          headers: {'authorization': 'Bearer ${client.tokens!.accessToken}'},
        );
        final body = jsonEncode(jsonDecode(response.body));
        expect(body, isNot(contains('key_pem')));
        expect(body, isNot(contains('PRIVATE KEY')));
      }
    },
  );

  test(
    'renewal default, explicit false, list pagination and deletion',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _client(fake);
      addTearDown(client.close);
      final domain = (await client.domains()).items.first;
      final created = await client.uploadCertificate(
        domainId: domain.id,
        certPem: testCertificatePem,
        keyPem: testCertificateKey,
      );
      expect(created.autoRenew, isTrue);
      final first = await client.certificates(limit: 1);
      final second = await client.certificates(offset: first.next, limit: 1);
      expect(first.hasMore, isTrue);
      expect(first.items.single.id, isNot(second.items.single.id));
      expect(first.total, second.total);
      await client.deleteCertificate(created.id);
      await expectLater(
        client.certificate(created.id),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
      await expectLater(
        client.deleteCertificate(created.id),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    },
  );

  test(
    'bad certificate, missing fields and missing domain follow server statuses',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _client(fake);
      addTearDown(client.close);
      final domain = (await client.domains()).items.first;
      for (final pem in [
        '',
        'not PEM',
        '-----BEGIN CERTIFICATE-----\nMAA=\n-----END CERTIFICATE-----',
      ]) {
        await expectLater(
          client.uploadCertificate(
            domainId: domain.id,
            certPem: pem,
            keyPem: testCertificateKey,
          ),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 400),
          ),
        );
      }
      await expectLater(
        client.uploadCertificate(
          domainId: domain.id,
          certPem: testCertificatePem,
          keyPem: '',
        ),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 400)),
      );
      await expectLater(
        client.uploadCertificate(
          domainId: 999999,
          certPem: testCertificatePem,
          keyPem: testCertificateKey,
        ),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    },
  );

  test(
    'read-only sessions inspect detail and cannot upload or delete',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final email = 'certreader@${fake.host}';
      fake.addAccount(email, capabilities: {Capability.domainsRead});
      final client = await _client(fake, email: email);
      addTearDown(client.close);
      final tokens = client.tokens;
      final cert = (await client.certificates()).items.first;
      expect((await client.certificate(cert.id)).id, cert.id);
      for (final call in [
        () => client.uploadCertificate(
          domainId: cert.domainId,
          certPem: testCertificatePem,
          keyPem: testCertificateKey,
        ),
        () => client.deleteCertificate(cert.id),
      ]) {
        await expectLater(
          call(),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 403),
          ),
        );
        expect(client.tokens, same(tokens));
      }
    },
  );

  test('mail sessions cannot read certificate lists or details', () async {
    final fake = FakeRestmail();
    addTearDown(fake.close);
    final client = await _client(fake, email: FakeAccounts.email);
    addTearDown(client.close);
    final tokens = client.tokens;
    for (final call in [
      () => client.certificates(),
      () => client.certificate(fake.certificates.first.id),
    ]) {
      await expectLater(
        call(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(client.tokens, same(tokens));
    }
  });
}
