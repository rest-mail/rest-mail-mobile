import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late int domainId;
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
    domainId = (await client.domains()).items.first.id;
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  Future<http.Response> send(String method, String path, [Object? body]) {
    final request = http.Request(
      method,
      Uri.parse('https://${fake.host}/api/v1/admin/$path'),
    );
    request.headers['authorization'] = 'Bearer ${client.tokens!.accessToken}';
    if (body != null) {
      request.headers['content-type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    return fake.client.send(request).then(http.Response.fromStream);
  }

  Future<void> expectFields(
    String method,
    String path,
    Object? body,
    Map<String, String> want,
  ) async {
    final response = await send(method, path, body);
    expect(response.statusCode, 422, reason: '$method $path $body');
    final error =
        (jsonDecode(response.body) as Map<String, dynamic>)['error']
            as Map<String, dynamic>;
    expect(error['message'], 'Request body failed validation');
    expect(error['details']['fields'], want, reason: '$method $path $body');
  }

  test('the pipeline log refuses every bad filter at once', () async {
    await expectFields(
      'GET',
      'pipelines/logs?direction=sideways&action=&outcome=lost'
          '&pipeline_id=x&limit=500&offset=y',
      null,
      {
        'direction': 'must be one of inbound, outbound',
        'action': 'must be one of continue, reject, quarantine, discard, defer',
        'outcome':
            'must be one of delivered, queued, rejected, quarantined, '
            'discarded, deferred',
        'pipeline_id': 'must be an integer',
        'limit': 'must be at most 200',
        'offset': 'must be an integer',
      },
    );
    final blank = await send('GET', 'pipelines/logs?pipeline_id=&limit=');
    expect(blank.statusCode, 200);
    await expectFields('GET', 'messages/0/trace', null, {
      'id': 'must be at least 1',
    });
  });

  test('the lists bind their domain and paging', () async {
    for (final list in ['pipelines', 'custom-filters']) {
      await expectFields('GET', '$list?domain_id=x&limit=ten', null, {
        'domain_id': 'must be an integer',
        'limit': 'must be an integer',
      });
      final none = await send('GET', '$list?domain_id=999999');
      expect(
        (jsonDecode(none.body) as Map<String, dynamic>)['data'],
        isEmpty,
        reason: list,
      );
    }
  });

  test('a pipeline body is bound, then checked as the server does', () async {
    await expectFields(
      'POST',
      'pipelines',
      {'domain_id': 'x', 'direction': '', 'active': 'y', 'colour': 1},
      {
        'domain_id': 'must be a non-negative integer',
        'direction': "must be 'inbound' or 'outbound'",
        'active': 'must be a boolean',
        'colour': 'not allowed',
      },
    );
    await expectFields(
      'POST',
      'pipelines',
      {'domain_id': domainId, 'filters': <Object>[]},
      {'direction': "must be 'inbound' or 'outbound'"},
    );
    await expectFields(
      'POST',
      'pipelines',
      {'domain_id': domainId, 'direction': 'inbound', 'filters': 'spam'},
      {'filters': 'must be an array of filter objects'},
    );
    await expectFields('PATCH', 'pipelines/nope', {}, {
      'id': 'must be a non-negative integer',
    });
    // Binding comes before the lookup: a field the body does not declare is
    // refused for a pipeline that is not there.
    await expectFields(
      'PATCH',
      'pipelines/999999',
      {'name': 'x'},
      {'name': 'not allowed'},
    );
    // Webmail's domain_id and direction are accepted and ignored.
    final pipeline = (await client.pipelines()).items.first;
    final kept = await send('PATCH', 'pipelines/${pipeline.id}', {
      'domain_id': domainId,
      'direction': 'outbound',
      'active': false,
    });
    expect(kept.statusCode, 200, reason: kept.body);
    expect(
      (jsonDecode(kept.body) as Map<String, dynamic>)['data']['direction'],
      pipeline.direction,
    );
  });

  test('a custom filter is checked in the server order', () async {
    // Missing name, type or direction: all three, together.
    await expectFields(
      'POST',
      'custom-filters',
      {'domain_id': domainId, 'name': 'Tag', 'config': <String, Object>{}},
      {'name': 'required', 'filter_type': 'required', 'direction': 'required'},
    );
    // An empty type is outside its enum, which binding refuses first.
    await expectFields(
      'POST',
      'custom-filters',
      {
        'domain_id': domainId,
        'name': null,
        'filter_type': '',
        'direction': 'sideways',
        'enabled': 'yes',
      },
      {
        'name': 'must not be null',
        'filter_type': 'must be action or transform',
        'direction': 'must be inbound, outbound or both',
        'enabled': 'must be a boolean',
      },
    );
    await expectFields(
      'POST',
      'custom-filters',
      {
        'domain_id': domainId,
        'name': 'Tag',
        'filter_type': 'action',
        'direction': 'inbound',
        'config': <Object>[],
      },
      {'config': 'must be an object'},
    );

    final made = await send('POST', 'custom-filters', {
      'domain_id': domainId,
      'name': 'Tag',
      'filter_type': 'action',
      'direction': 'inbound',
      'config': {'header': 'X-Tag'},
    });
    expect(made.statusCode, 201, reason: made.body);
    final id =
        (jsonDecode(made.body) as Map<String, dynamic>)['data']['id'] as int;

    // Null leaves a field as it is; a null config is refused.
    final renamed = await send('PATCH', 'custom-filters/$id', {
      'name': null,
      'description': 'Tags mail',
    });
    expect(renamed.statusCode, 200, reason: renamed.body);
    final data =
        (jsonDecode(renamed.body) as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
    expect(data['name'], 'Tag');
    expect(data['description'], 'Tags mail');
    await expectFields(
      'PATCH',
      'custom-filters/$id',
      {'config': null},
      {'config': 'must be an object'},
    );
    await expectFields(
      'PATCH',
      'custom-filters/$id',
      {'name': ''},
      {'name': 'required'},
    );
    await expectFields('GET', 'custom-filters/0', null, {
      'id': 'must be at least 1',
    });
    await expectFields('DELETE', 'custom-filters/nope', null, {
      'id': 'must be a non-negative integer',
    });
  });
}
