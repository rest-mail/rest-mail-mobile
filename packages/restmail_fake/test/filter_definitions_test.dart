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
  const step = PipelineFilter(
    name: 'sieve',
    type: 'transform',
    enabled: true,
    unskippable: true,
    config: {'script': 'keep;'},
  );

  test('create, filter and patch pipelines without losing configs', () async {
    final domain = (await client.domains()).items.first;
    final created = await client.createPipeline(
      domainId: domain.id,
      direction: 'inbound',
      filters: [step],
      active: false,
    );
    expect(created.active, isFalse);
    expect(created.filters.single.toJson(), step.toJson());
    final page = await client.pipelines(domainId: domain.id, limit: 1);
    expect(page.items.every((p) => p.domainId == domain.id), isTrue);
    final updated = await client.updatePipeline(
      created.id,
      filters: [],
      active: true,
    );
    expect(updated.active, isTrue);
    expect(updated.filters, isEmpty);
    await client.deletePipeline(created.id);
    expect(
      (await client.pipelines()).items.any((p) => p.id == created.id),
      isFalse,
    );
  });
  test(
    'custom definition create, direct GET, full edit, filter and delete',
    () async {
      final domain = (await client.domains()).items.first;
      final created = await client.createCustomFilter(
        domainId: domain.id,
        name: 'native',
        filterType: 'action',
        direction: 'both',
        description: 'description',
        config: {'script': 'original'},
        enabled: false,
      );
      expect(created.enabled, isFalse);
      expect((await client.customFilter(created.id)).config, {
        'script': 'original',
      });
      final updated = await client.updateCustomFilter(
        created.id,
        name: 'changed',
        description: '',
        filterType: 'transform',
        direction: 'outbound',
        config: {},
        enabled: true,
      );
      expect(updated.name, 'changed');
      expect(updated.description, '');
      expect(updated.config, isEmpty);
      expect(updated.direction, 'outbound');
      expect(updated.filterType, 'transform');
      expect(updated.enabled, isTrue);
      expect(
        (await client.customFilters(
          domainId: domain.id,
        )).items.every((f) => f.domainId == domain.id),
        isTrue,
      );
      await client.deleteCustomFilter(created.id);
      await expectLater(
        client.customFilter(created.id),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    },
  );
  test('invalid update leaves stored definition unchanged', () async {
    final existing = (await client.customFilters()).items.first;
    await expectLater(
      client.updateCustomFilter(
        existing.id,
        name: 'changed',
        direction: 'invalid',
      ),
      throwsA(
        isA<ApiException>().having(
          (e) => e.fields['direction'],
          'field',
          'must be inbound, outbound or both',
        ),
      ),
    );
    expect((await client.customFilter(existing.id)).name, existing.name);
  });
  test('read-only operators cannot mutate definitions', () async {
    fake.grant(FakeAccounts.adminEmail, {Capability.pipelinesRead});
    final readonly = RestmailClient(
      server: Uri.parse('https://${FakeAccounts.host}'),
      httpClient: fake.client,
    );
    await readonly.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    final pipeline = (await readonly.pipelines()).items.first;
    final filter = (await readonly.customFilters()).items.first;
    expect((await readonly.customFilter(filter.id)).id, filter.id);
    for (final action in <Future<Object?> Function()>[
      () => readonly.createPipeline(
        domainId: pipeline.domainId,
        direction: 'inbound',
        filters: [],
      ),
      () => readonly.updatePipeline(pipeline.id, filters: []),
      () => readonly.createCustomFilter(
        domainId: filter.domainId,
        name: 'no',
        filterType: 'action',
        direction: 'both',
        config: {},
      ),
      () => readonly.updateCustomFilter(filter.id, config: {}),
    ]) {
      await expectLater(
        action(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
    }
    expect(readonly.tokens, isNotNull);
    readonly.close();
  });
}
