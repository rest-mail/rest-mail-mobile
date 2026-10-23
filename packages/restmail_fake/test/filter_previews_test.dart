import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  setUp(() async {
    fake = FakeRestmail();
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
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

  const email = <String, dynamic>{
    'envelope': {'mail_from': 'a@example.test'},
    'headers': {'subject': 'Hello'},
  };

  Future<http.Response> send(String path, Object body) => fake.client.post(
    Uri.parse('https://${fake.host}/api/v1/admin/$path'),
    headers: {
      'authorization': 'Bearer ${client.tokens!.accessToken}',
      'content-type': 'application/json',
    },
    body: jsonEncode(body),
  );

  Map<String, dynamic> fields(http.Response response) =>
      ((jsonDecode(response.body) as Map<String, dynamic>)['error']
              as Map<String, dynamic>)['details']['fields']
          as Map<String, dynamic>;

  test('a saved pipeline runs over an email, each filter a step', () async {
    final pipeline = (await client.pipelines()).items.first;
    final result = await client.testPipeline(pipeline.id, email: email);
    expect(result.finalAction, 'continue');
    expect(result.finalEmail, email);
    expect(result.steps, hasLength(pipeline.filters.length));
    expect(result.steps.every((s) => s.action == 'continue'), isTrue);

    final missing = await send('pipelines/test', {
      'pipeline_id': 999999,
      'email': email,
    });
    expect(missing.statusCode, 404);
    final noEmail = await send('pipelines/test', {'pipeline_id': pipeline.id});
    expect(noEmail.statusCode, 422);
    expect(fields(noEmail), {'email': 'required'});
    final wrong = await send('pipelines/test', {
      'pipeline_id': 'x',
      'email': 'y',
      'z': 1,
    });
    expect(fields(wrong), {
      'pipeline_id': 'must be a non-negative integer',
      'email': 'must be an object',
      'z': 'not allowed',
    });
  });

  test(
    'one filter runs over an email; its name and email are required',
    () async {
      final result = await client.testFilter(
        filterName: 'spam_check',
        config: const {'threshold': 5},
        email: email,
      );
      expect(result.action, 'continue');
      expect(result.log['filter'], 'spam_check');
      final missing = await send('pipelines/test-filter', {
        'config': <String, Object>{},
      });
      expect(fields(missing), {'filter_name': 'required', 'email': 'required'});
      final config = await send('pipelines/test-filter', {
        'filter_name': 'spam_check',
        'config': <Object>[],
        'email': email,
      });
      expect(fields(config), {'config': 'must be an object'});
    },
  );

  test(
    'a script is validated, and dry-run when an email comes with it',
    () async {
      final valid = await client.validateCustomFilter(
        'return {action: "continue"};',
      );
      expect(valid.valid, isTrue);
      expect(valid.dryRun, isNull);
      final dryRun = await client.validateCustomFilter(
        'return {action: "continue"};',
        email: email,
      );
      expect(dryRun.dryRun?.logs, isEmpty);
      final broken = await client.validateCustomFilter('function f( {');
      expect(broken.valid, isFalse);
      expect(broken.phase, 'syntax');
      final empty = await send('custom-filters/validate', {'script': ''});
      expect(fields(empty), {'script': 'required'});
    },
  );

  test('a saved filter script runs; one without a script cannot', () async {
    final domainId = (await client.domains()).items.first.id;
    final scripted = await client.createCustomFilter(
      domainId: domainId,
      name: 'Tag',
      filterType: 'action',
      direction: 'inbound',
      config: const {'script': 'return {action: "continue"};'},
    );
    final ran = await client.testCustomFilter(scripted.id, email: email);
    expect(ran.error, isNull);
    expect(ran.logs, isEmpty);

    final plain = await client.createCustomFilter(
      domainId: domainId,
      name: 'Plain',
      filterType: 'action',
      direction: 'inbound',
      config: const {'header': 'X-Tag'},
    );
    final noScript = await send('custom-filters/${plain.id}/test', {});
    expect(noScript.statusCode, 400);
    final missing = await send('custom-filters/999999/test', {});
    expect(missing.statusCode, 404);
  });
}
