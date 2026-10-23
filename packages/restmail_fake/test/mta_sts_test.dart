import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  test(
    'upsert reads every field and keeps creation time across reads and edits',
    () async {
      var now = DateTime.utc(2026, 10, 20, 10);
      final fake = FakeRestmail(clock: () => now);
      addTearDown(fake.close);
      final client = RestmailClient(
        server: Uri.parse('https://${FakeAccounts.host}'),
        httpClient: fake.client,
      );
      addTearDown(client.close);
      await client.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      final domain = fake.domains.firstWhere(
        (d) => d.name == FakeAccounts.host,
      );
      await client.deleteMtaStsPolicy(domain.id);
      expect(await client.mtaStsPolicy(domain.id), isNull);

      final created = await client.setMtaStsPolicy(
        domain.id,
        mode: MtaStsMode.none,
        mxHosts: ['mx.example.test', '*.example.test'],
        maxAgeSeconds: 0,
        active: false,
      );
      expect(created.id, isPositive);
      expect(created.domainId, domain.id);
      expect(created.mode, MtaStsMode.none);
      expect(created.mxHosts, ['mx.example.test', '*.example.test']);
      expect(created.maxAgeSeconds, 0);
      expect(created.active, isFalse);
      expect(created.domain, isNull);
      expect(created.createdAt, now.toLocal());
      expect(created.updatedAt, now.toLocal());
      final createdAt = created.createdAt;
      now = now.add(const Duration(minutes: 1));
      final read = (await client.mtaStsPolicy(domain.id))!;
      expect(read.createdAt, createdAt);
      expect(read.updatedAt, createdAt);
      final updated = await client.setMtaStsPolicy(
        domain.id,
        maxAgeSeconds: 12345,
      );
      expect(updated.id, created.id);
      expect(updated.createdAt, createdAt);
      expect(updated.updatedAt, now.toLocal());
      expect(updated.maxAgeSeconds, 12345);
      expect(updated.active, isFalse);
      expect(updated.mode, MtaStsMode.none);
      expect(updated.mxHosts, created.mxHosts);

      final unchanged = await client.setMtaStsPolicy(domain.id, mxHosts: []);
      expect(unchanged.mxHosts, created.mxHosts);
      const huge = 9223372036854775807;
      expect(
        (await client.setMtaStsPolicy(
          domain.id,
          maxAgeSeconds: huge,
        )).maxAgeSeconds,
        huge,
      );
      await client.deleteMtaStsPolicy(domain.id);
      expect(await client.mtaStsPolicy(domain.id), isNull);
      await expectLater(
        client.deleteMtaStsPolicy(domain.id),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    },
  );

  test(
    'unknown domain stays a 404, and bad lifetime validates before lookup',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = RestmailClient(
        server: Uri.parse('https://${FakeAccounts.host}'),
        httpClient: fake.client,
      );
      addTearDown(client.close);
      await client.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      await expectLater(
        client.mtaStsPolicy(99999),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'Domain not found',
          ),
        ),
      );
      await expectLater(
        client.setMtaStsPolicy(99999, maxAgeSeconds: -1),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields['max_age'],
            'max_age',
            'Must be a non-negative integer (seconds)',
          ),
        ),
      );
    },
  );

  test('read-only session can read but cannot upsert or delete', () async {
    final fake = FakeRestmail();
    addTearDown(fake.close);
    const email = 'policy-reader@${FakeAccounts.host}';
    fake.addAccount(email, capabilities: {Capability.domainsRead});
    final client = RestmailClient(
      server: Uri.parse('https://${FakeAccounts.host}'),
      httpClient: fake.client,
    );
    addTearDown(client.close);
    await client.login(
      email: email,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    final id = fake.domains.firstWhere((d) => d.name == FakeAccounts.host).id;
    final before = (await client.mtaStsPolicy(id))!;
    for (final request in [
      () => client.setMtaStsPolicy(id, maxAgeSeconds: 0),
      () => client.deleteMtaStsPolicy(id),
    ]) {
      await expectLater(
        request(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
    }
    expect(
      (await client.mtaStsPolicy(id))!.maxAgeSeconds,
      before.maxAgeSeconds,
    );
    expect(client.tokens, isNotNull);
  });
}
