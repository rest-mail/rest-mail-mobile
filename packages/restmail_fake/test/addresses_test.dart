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
    expect(
      (jsonDecode(response.body)
          as Map<String, dynamic>)['error']['details']['fields'],
      want,
      reason: '$method $path $body',
    );
  }

  test('a path id is bound before the mailbox or alias is looked up', () async {
    for (final path in ['mailboxes/nope', 'mailboxes/-1', 'aliases/1.5']) {
      await expectFields('GET', path, null, {
        'id': 'must be a non-negative integer',
      });
    }
    await expectFields('GET', 'mailboxes/0', null, {
      'id': 'must be at least 1',
    });
    await expectFields('DELETE', 'mailboxes/nope/sessions', null, {
      'id': 'must be a non-negative integer',
    });
    // An undeclared field is refused before a missing alias is.
    await expectFields(
      'PATCH',
      'aliases/999999',
      {'source_address': 'forged@${FakeAccounts.host}'},
      {'source_address': 'not allowed'},
    );
    final missing = await send('PATCH', 'aliases/999999', {'active': true});
    expect(missing.statusCode, 404);
  });

  test('a domain filter no domain has lists nothing', () async {
    final domain = (await client.domains()).items.first;
    expect((await client.mailboxes(domainId: domain.id)).items, isNotEmpty);
    expect((await client.mailboxes(domainId: 999999)).items, isEmpty);
    expect((await client.aliases(domainId: 999999)).items, isEmpty);
    await expectFields('GET', 'mailboxes?domain_id=nope', null, {
      'domain_id': 'must be an integer',
    });
    final blank = await send('GET', 'aliases?domain_id=');
    expect(blank.statusCode, 200);
  });

  test('a mailbox update is bound as the server binds it', () async {
    final box = (await client.mailboxes()).items.first;
    await expectFields(
      'PATCH',
      'mailboxes/${box.id}',
      {
        'password': 12,
        'display_name': false,
        'quota_bytes': 1.5,
        'active': 'yes',
        'domain_id': 2,
      },
      {
        'password': 'must be a string',
        'display_name': 'must be a string',
        'quota_bytes': 'must be an integer',
        'active': 'must be a boolean',
        'domain_id': 'not allowed',
      },
    );
    // Eleven bytes in six characters.
    await expectFields(
      'PATCH',
      'mailboxes/${box.id}',
      {'password': 'éééééa'},
      {'password': 'must be at least 12 characters'},
    );
    final missing = await send('PATCH', 'mailboxes/999999', {});
    expect(missing.statusCode, 404);

    // Null leaves a field as it is; twelve bytes in six characters are
    // long enough.
    final updated = await send('PATCH', 'mailboxes/${box.id}', {
      'display_name': null,
      'password': 'éééééé',
      'quota_bytes': 2048,
    });
    expect(updated.statusCode, 200, reason: updated.body);
    final data =
        (jsonDecode(updated.body) as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
    expect(data['quota_bytes'], 2048);
    expect(data['display_name'], box.displayName);
  });

  test('an alias create answers in the server order', () async {
    final host = FakeAccounts.host;
    await expectFields('POST', 'aliases', {}, {
      'source_address': 'required',
      'destination_address': 'required',
    });
    await expectFields(
      'POST',
      'aliases',
      {'source_address': 5, 'destination_address': null, 'note': 'x'},
      {
        'source_address': 'must be a string',
        'destination_address': 'must not be null',
        'note': 'not allowed',
      },
    );
    // The destination is checked first; the source only once it passes.
    await expectFields(
      'POST',
      'aliases',
      {'source_address': 'nope', 'destination_address': 'nope'},
      {'destination_address': 'must be a valid email address'},
    );
    await expectFields(
      'POST',
      'aliases',
      {'source_address': '  ', 'destination_address': 'a@example.test'},
      {'source_address': 'must be a valid email address'},
    );
    final made = await send('POST', 'aliases', {
      'source_address': 'Sales@$host',
      'destination_address': 'a@example.test',
    });
    expect(made.statusCode, 201);
    final id =
        (jsonDecode(made.body) as Map<String, dynamic>)['data']['id'] as int;

    await expectFields(
      'PATCH',
      'aliases/$id',
      {'destination_address': 7, 'active': 'no'},
      {
        'destination_address': 'must be a string',
        'active': 'must be a boolean',
      },
    );
    await expectFields(
      'PATCH',
      'aliases/$id',
      {'destination_address': 'nobody'},
      {'destination_address': 'must be a valid email address'},
    );
    final alias = await client.updateAlias(id, active: false);
    expect(alias.destination, 'a@example.test');
    expect(alias.active, isFalse);
  });
}
