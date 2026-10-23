import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Future<RestmailClient> _login(
  FakeRestmail fake, {
  String email = FakeAccounts.adminEmail,
}) async {
  final client = RestmailClient(
    server: Uri.parse('https://${FakeAccounts.host}'),
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
  for (final list in SenderList.values) {
    test(
      '${list.path} lifecycle, duplicate409 and independent other list',
      () async {
        var now = DateTime.utc(2026, 10, 23, 1);
        final fake = FakeRestmail(clock: () => now);
        addTearDown(fake.close);
        final client = await _login(fake);
        addTearDown(client.close);
        final domain = fake.domains.firstWhere(
          (d) => d.name == FakeAccounts.host,
        );
        final other = list == SenderList.allow
            ? SenderList.block
            : SenderList.allow;
        final first = await client.addSenderRule(
          domain.id,
          list,
          pattern: '@reviewed.test',
          reason: 'Reviewed today',
        );
        expect(first.id, isPositive);
        expect(first.domainId, domain.id);
        expect(first.list, list);
        expect(first.pattern, '@reviewed.test');
        expect(first.reason, 'Reviewed today');
        expect(first.createdAt, now.toLocal());
        expect(first.createdBy, isNull);
        await expectLater(
          client.addSenderRule(domain.id, list, pattern: '@reviewed.test'),
          throwsA(
            isA<ApiException>().having(
              (e) => (e.statusCode, e.code, e.message),
              'refusal',
              (409, 'already_exists', 'Sender is already on the ${list.path}'),
            ),
          ),
        );
        final otherRule = await client.addSenderRule(
          domain.id,
          other,
          pattern: '@reviewed.test',
        );
        expect(otherRule.list, other);
        now = now.add(const Duration(seconds: 1));
        final second = await client.addSenderRule(
          domain.id,
          list,
          pattern: 'new@reviewed.test',
        );
        final rules = await client.senderRules(domain.id, list);
        expect(rules.first.id, second.id);
        expect(rules.first.createdAt, now.toLocal());
        expect(rules.first.createdBy, isNull);
        expect(
          rules.where((r) => r.id == first.id).single.createdAt,
          first.createdAt,
        );
        expect(
          rules.every((r) => r.list == list && r.domainId == domain.id),
          isTrue,
        );

        // Neither the wrong list nor another existing domain can remove a rule.
        final otherDomain = fake.domains.firstWhere((d) => d.id != domain.id);
        for (final request in [
          () => client.removeSenderRule(domain.id, other, first.id),
          () => client.removeSenderRule(otherDomain.id, list, first.id),
        ]) {
          await expectLater(
            request(),
            throwsA(
              isA<ApiException>().having((e) => e.statusCode, 'status', 404),
            ),
          );
        }
        await client.removeSenderRule(domain.id, list, first.id);
        expect(
          (await client.senderRules(
            domain.id,
            list,
          )).any((r) => r.id == first.id),
          isFalse,
        );
        expect(
          (await client.senderRules(
            domain.id,
            other,
          )).any((r) => r.id == otherRule.id),
          isTrue,
        );
        await expectLater(
          client.removeSenderRule(domain.id, list, first.id),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 404),
          ),
        );
        expect(client.tokens, isNotNull);
      },
    );

    test('${list.path} empty pattern and read-only write refusals', () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final admin = await _login(fake);
      addTearDown(admin.close);
      final domain = fake.domains.firstWhere(
        (d) => d.name == FakeAccounts.host,
      );
      await expectLater(
        admin.addSenderRule(domain.id, list, pattern: ''),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields['pattern'],
            'pattern',
            'required',
          ),
        ),
      );
      const reader = 'sender-reader@${FakeAccounts.host}';
      fake.addAccount(reader, capabilities: {Capability.domainsRead});
      final client = await _login(fake, email: reader);
      addTearDown(client.close);
      final before = await client.senderRules(domain.id, list);
      for (final request in <Future<Object?> Function()>[
        () => client.addSenderRule(domain.id, list, pattern: '@reviewed.test'),
        () => client.removeSenderRule(domain.id, list, before.first.id),
      ]) {
        await expectLater(
          request(),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 403),
          ),
        );
      }
      expect((await client.senderRules(domain.id, list)).length, before.length);
      expect(client.tokens, isNotNull);
    });
  }
}
