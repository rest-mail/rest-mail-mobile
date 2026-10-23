import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;

  setUp(() async {
    fake = FakeRestmail();
    client = RestmailClient(
      server: Uri.parse('https://${FakeAccounts.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  test('fresh detail observes edits after an older list snapshot', () async {
    final domain = (await client.domains()).items.first;
    final saved = await client.updateDomain(domain.id, sendingPolicy: 'bulk');
    expect(saved.sendingPolicy, 'bulk');
    expect((await client.domain(domain.id)).sendingPolicy, 'bulk');
    expect(domain.sendingPolicy, isEmpty);

    final box = (await client.mailboxes()).items.first;
    await client.updateMailbox(box.id, displayName: 'Changed elsewhere');
    final fresh = await client.adminMailbox(box.id);
    expect(fresh.displayName, 'Changed elsewhere');
    expect(fresh.domain?.name, contains('.'));
    expect(fresh.localPart, fresh.address.split('@').first);
    expect(box.displayName, isNot('Changed elsewhere'));

    final alias = (await client.aliases()).items.first;
    await client.updateAlias(
      alias.id,
      destination: 'CaseSensitive@Remote.test',
    );
    final current = await client.alias(alias.id);
    expect(current.destination, 'CaseSensitive@Remote.test');
    expect(current.domain?.name, FakeAccounts.host);
    expect(alias.destination, isNot(current.destination));
  });

  test(
    'alias creation returns metadata and preserves remote address case',
    () async {
      final alias = await client.createAlias(
        source: 'details@${FakeAccounts.host}',
        destination: 'MixedCase@Remote.test',
      );
      expect(alias.source, 'details@${FakeAccounts.host}');
      expect(alias.destination, 'MixedCase@Remote.test');
      expect(alias.createdAt, isNotNull);
      expect(
        (await client.alias(alias.id)).destination,
        'MixedCase@Remote.test',
      );
    },
  );

  test('deleted resources answer 404 on their detail operation', () async {
    final domain = await client.createDomain('gone.test');
    await client.deleteDomain(domain.id);
    final alias = await client.createAlias(
      source: 'gone@${FakeAccounts.host}',
      destination: 'User@Remote.test',
    );
    await client.deleteAlias(alias.id);
    final box = await client.createAccount(
      address: 'gone@${FakeAccounts.host}',
    );
    await client.deleteMailbox(box.id);
    for (final call in [
      () => client.domain(domain.id),
      () => client.adminMailbox(box.id),
      () => client.alias(alias.id),
    ]) {
      await expectLater(
        call(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    }
  });

  test('unrelated capabilities cannot read any core resource detail', () async {
    final domain = (await client.domains()).items.first;
    final box = (await client.mailboxes()).items.first;
    final alias = (await client.aliases()).items.first;
    fake.addAccount(
      'queue-only@${FakeAccounts.host}',
      capabilities: {'queue:read'},
    );
    final limited = RestmailClient(
      server: Uri.parse('https://${FakeAccounts.host}'),
      httpClient: fake.client,
    );
    addTearDown(limited.close);
    await limited.login(
      email: 'queue-only@${FakeAccounts.host}',
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    for (final call in [
      () => limited.domain(domain.id),
      () => limited.adminMailbox(box.id),
      () => limited.alias(alias.id),
    ]) {
      await expectLater(
        call(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
    }
    expect(limited.tokens, isNotNull);
  });
}
