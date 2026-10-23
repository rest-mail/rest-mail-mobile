import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

import 'fixtures/dkim_key.dart';

Future<RestmailClient> _login(
  FakeRestmail fake, {
  String email = FakeAccounts.adminEmail,
}) async {
  final client = RestmailClient(
    server: Uri.parse('https://${fake.host}'),
    httpClient: fake.client,
  );
  await client.login(
    email: email,
    password: FakeAccounts.adminPassword,
    totpCode: FakeAccounts.totpCode,
  );
  return client;
}

void main() {
  test('legacy monitoring has unknown age, no key material', () async {
    final fake = FakeRestmail();
    addTearDown(fake.close);
    final client = await _login(fake);
    addTearDown(client.close);
    final keys = await client.dkimKeys();
    expect(keys, isNotEmpty);
    expect(keys.first.createdAt, isNull);
    expect(keys.first.ageSeconds, isNull);
    final transport = fake.client;
    addTearDown(transport.close);
    final raw = await transport.get(
      Uri.parse('https://${fake.host}/api/v1/admin/dkim'),
      headers: {'authorization': 'Bearer ${client.tokens!.accessToken}'},
    );
    expect(raw.statusCode, 200);
    expect(raw.body, isNot(contains('private_key')));
  });

  test(
    'new domains start unsigned; install, re-save and replacement preserve key age correctly',
    () async {
      var now = DateTime.now().toUtc();
      final fake = FakeRestmail(clock: () => now);
      addTearDown(fake.close);
      final client = await _login(fake);
      addTearDown(client.close);
      final domain = await client.createDomain('signing.test');
      expect(domain.dkimSelector, isEmpty);
      expect(
        (await client.dkimKeys()).map((k) => k.domainId),
        isNot(contains(domain.id)),
      );
      final installed = await client.setDkimKey(
        domain.id,
        selector: 'mail2026',
        privateKey: testDkimKey,
      );
      expect(installed.createdAt!.toUtc(), now);
      expect(installed.ageSeconds, 0);
      expect((await client.domain(domain.id)).dkimSelector, 'mail2026');
      final original = now;
      now = now.add(const Duration(seconds: 25, milliseconds: 500));
      final saved = await client.setDkimKey(
        domain.id,
        selector: 'mail2027',
        privateKey: testDkimKey,
      );
      expect(saved.createdAt!.toUtc(), original);
      expect(saved.ageSeconds, 25.5);
      final replacement = testDkimKey.replaceAll('HR4f', 'HR4e');
      final changed = await client.setDkimKey(
        domain.id,
        selector: 'new',
        privateKey: replacement,
      );
      expect(changed.createdAt!.toUtc(), now);
      expect(changed.ageSeconds, 0);
      final transport = fake.client;
      addTearDown(transport.close);
      for (final path in ['admin/dkim', 'admin/domains/${domain.id}']) {
        final raw = await transport.get(
          Uri.parse('https://${fake.host}/api/v1/$path'),
          headers: {'authorization': 'Bearer ${client.tokens!.accessToken}'},
        );
        expect(
          jsonEncode(jsonDecode(raw.body)),
          isNot(contains('PRIVATE KEY')),
        );
        expect(raw.body, isNot(contains('private_key')));
      }
    },
  );

  test(
    'rotation works before installation, validates boundaries and survives key removal',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _login(fake);
      addTearDown(client.close);
      final domain = await client.createDomain('rotation.test');
      expect((await client.dkimRotation(domain.id)).enabled, isFalse);
      expect(
        (await client.setDkimRotation(domain.id, 3650)).intervalDays,
        3650,
      );
      await client.setDkimKey(
        domain.id,
        selector: 'mail',
        privateKey: testDkimKey,
      );
      await client.deleteDkimKey(domain.id);
      expect((await client.domain(domain.id)).dkimSelector, isEmpty);
      expect(
        (await client.dkimKeys()).map((k) => k.domainId),
        isNot(contains(domain.id)),
      );
      expect((await client.dkimRotation(domain.id)).intervalDays, 3650);
      expect((await client.setDkimRotation(domain.id, 0)).enabled, isFalse);
      for (final days in [-1, 3651]) {
        await expectLater(
          client.setDkimRotation(domain.id, days),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'status', 422)
                .having(
                  (e) => e.fields.keys,
                  'field',
                  contains('rotation_interval_days'),
                ),
          ),
        );
      }
    },
  );

  test(
    'invalid selector, PEM, empty body and unknown domain are refused',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _login(fake);
      addTearDown(client.close);
      final domain = (await client.domains()).items.first;
      for (final selector in [
        'bad_selector',
        '-bad',
        'bad-',
        'bad..label',
        'a' * 64,
      ]) {
        await expectLater(
          client.setDkimKey(
            domain.id,
            selector: selector,
            privateKey: testDkimKey,
          ),
          throwsA(
            isA<ApiException>().having(
              (e) => e.fields.keys,
              'field',
              contains('selector'),
            ),
          ),
        );
      }
      await expectLater(
        client.setDkimKey(domain.id, selector: 'mail', privateKey: 'broken'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields.keys,
            'field',
            contains('private_key'),
          ),
        ),
      );
      await expectLater(
        client.setDkimKey(domain.id, selector: '', privateKey: ''),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'status', 422).having(
            (e) => e.fields,
            'fields',
            {
              'selector':
                  'Must be a DNS label (letters, digits, hyphens), at most 63 characters',
              'private_key': 'required',
            },
          ),
        ),
      );
      final transport = fake.client;
      addTearDown(transport.close);
      final unknown = await transport.put(
        Uri.parse(
          'https://${fake.host}/api/v1/admin/dkim/${domain.id}/rotation',
        ),
        headers: {
          'authorization': 'Bearer ${client.tokens!.accessToken}',
          'content-type': 'application/json',
        },
        body: '{"rotation_interval_days":30,"private_key":"x"}',
      );
      expect(unknown.statusCode, 422);
      expect(
        (jsonDecode(unknown.body)
            as Map<String, dynamic>)['error']['details']['fields'],
        {'private_key': 'not allowed'},
      );
      await expectLater(
        client.dkimRotation(999999),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    },
  );

  test(
    'rotation does not replace key, selector or installation time',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _login(fake);
      addTearDown(client.close);
      final domain = (await client.domains()).items.first;
      final key = await client.setDkimKey(
        domain.id,
        selector: 'before',
        privateKey: testDkimKey,
      );
      await client.setDkimRotation(domain.id, 60);
      final after = (await client.dkimKeys()).firstWhere(
        (k) => k.domainId == domain.id,
      );
      expect(after.selector, 'before');
      expect(after.createdAt, key.createdAt);
    },
  );

  test(
    'read-only sessions can inspect rotation but never change or remove keys',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final viewer = 'viewer@${fake.host}';
      fake.addAccount(viewer, capabilities: {Capability.domainsRead});
      final client = await _login(fake, email: viewer);
      addTearDown(client.close);
      final tokens = client.tokens;
      final key = (await client.dkimKeys()).first;
      expect((await client.dkimRotation(key.domainId)).domainId, key.domainId);
      for (final call in [
        () => client.setDkimKey(
          key.domainId,
          selector: 'mail',
          privateKey: testDkimKey,
        ),
        () => client.setDkimRotation(key.domainId, 90),
        () => client.deleteDkimKey(key.domainId),
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
}
