import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late int account;
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
    account = (await client.accounts()).first.id;
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  Future<http.Response> send(String method, String path, [Object? body]) {
    final request = http.Request(
      method,
      Uri.parse('https://${fake.host}/api/v1/accounts/$path'),
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

  test('a contact is added, found, changed and deleted', () async {
    final ada = await client.createContact(
      account,
      email: 'ada@example.test',
      name: 'Ada',
    );
    expect(ada.trustLevel, TrustLevel.trusted);
    expect(ada.source, 'manual');
    await client.createContact(
      account,
      email: 'bob@example.test',
      trustLevel: TrustLevel.auto,
    );
    await expectLater(
      client.createContact(account, email: 'ada@example.test'),
      _refused(409, 'already_exists'),
    );

    final all = await client.contacts(account);
    expect(all.items.map((c) => c.email), [
      'ada@example.test',
      'bob@example.test',
    ]);
    expect(all.total, 2);
    expect(
      (await client.contacts(account, search: 'bob')).items.single.email,
      'bob@example.test',
    );
    expect(
      (await client.contacts(
        account,
        trustLevel: TrustLevel.auto,
      )).items.single.email,
      'bob@example.test',
    );

    final changed = await client.updateContact(
      account,
      ada.id,
      trustLevel: TrustLevel.blocked,
    );
    expect(changed.name, 'Ada');
    expect(changed.trustLevel, TrustLevel.blocked);

    await client.deleteContact(account, ada.id);
    await expectLater(
      client.deleteContact(account, ada.id),
      _refused(404, 'not_found'),
    );
    expect((await client.contacts(account)).total, 1);
  });

  test('blocking makes a contact or changes the one there is', () async {
    final made = await send('POST', '$account/contacts/block', {
      'email': 'spam@example.test',
    });
    expect(made.statusCode, 201);
    final ada = await client.createContact(account, email: 'ada@example.test');
    final changed = await send('POST', '$account/contacts/block', {
      'email': 'ada@example.test',
    });
    expect(changed.statusCode, 200);
    final blocked = await client.blockSender(account, 'ada@example.test');
    expect(blocked.id, ada.id);
    expect(blocked.trustLevel, TrustLevel.blocked);
  });

  test('an import checks every address first and skips contacts', () async {
    await client.createContact(account, email: 'ada@example.test');
    await expectLater(
      client.importContacts(account, [
        (email: 'new@example.test', name: null),
        (email: 'Bob <bob@example.test>', name: null),
      ]),
      throwsA(
        isA<ApiException>().having((e) => e.fields, 'fields', {
          'contacts[1].email': 'must be an email address',
        }),
      ),
    );
    expect((await client.contacts(account)).total, 1);

    final imported = await client.importContacts(account, [
      (email: 'ada@example.test', name: 'Ada'),
      (email: 'bob@example.test', name: 'Bob'),
    ]);
    expect(imported, 1);
    final bob = (await client.contacts(account, search: 'bob')).items.single;
    expect(bob.trustLevel, TrustLevel.auto);
    expect(bob.source, 'import');
    expect(bob.name, 'Bob');
  });

  test('suggestions match address or name, leave out the blocked, '
      'and stop at ten', () async {
    final host = FakeAccounts.adminEmail.split('@').last;
    for (var i = 0; i < 12; i++) {
      fake.addContact(
        FakeAccounts.adminEmail,
        'p${i.toString().padLeft(2, '0')}@example.test',
        name: 'Person $i',
      );
    }
    fake.addContact(FakeAccounts.adminEmail, 'carol@$host', name: 'Carol');
    fake.addContact(
      FakeAccounts.adminEmail,
      'mallory@example.test',
      name: 'Carol too',
      trustLevel: 'blocked',
    );
    expect(await client.suggestContacts(account, ''), isEmpty);
    expect(
      (await client.suggestContacts(account, 'Carol')).map((c) => c.email),
      ['carol@$host'],
    );
    final people = await client.suggestContacts(account, 'Person');
    expect(people, hasLength(10));
    expect(people.first.name, 'Person 0');
  });

  test(
    'the path, query and body are bound before the account is checked',
    () async {
      await expectFields('GET', '0/contacts', null, {
        'id': 'must be at least 1',
      });
      await expectFields('GET', '999999/contacts?trust_level=&limit=x', null, {
        'trust_level': 'must be one of auto, trusted, blocked',
        'limit': 'must be an integer',
      });
      await expectFields(
        'POST',
        '999999/contacts',
        {'name': null, 'note': 1},
        {
          'email': 'required',
          'name': 'must not be null',
          'note': 'not allowed',
        },
      );
      await expectFields('PATCH', '$account/contacts/nope', {}, {
        'cid': 'must be a non-negative integer',
      });
      await expectFields(
        'PATCH',
        '$account/contacts/999999',
        {'trust_level': 'friend'},
        {'trust_level': 'must be auto, trusted, or blocked'},
      );
      await expectFields(
        'POST',
        '$account/contacts/import',
        {'contacts': 'x'},
        {'contacts': 'must be an array'},
      );
      await expectFields(
        'POST',
        '$account/contacts/import',
        {
          'contacts': [
            'ada@example.test',
            {'email': null, 'note': 1},
          ],
        },
        {
          'contacts[0]': 'must be an object',
          'contacts[1].email': 'must not be null',
          'contacts[1].note': 'not allowed',
        },
      );
      await expectFields(
        'POST',
        '$account/contacts/import',
        {'contacts': <Object>[]},
        {'contacts': 'required'},
      );

      // Then the handler's own rules, together.
      await expectFields(
        'POST',
        '$account/contacts',
        {'email': 'Ada <ada@example.test>', 'trust_level': 'friend'},
        {
          'email': 'must be an email address',
          'trust_level': 'must be auto, trusted, or blocked',
        },
      );
      await expectFields(
        'POST',
        '$account/contacts/block',
        {'email': ''},
        {'email': 'required'},
      );

      final elsewhere = await send('GET', '999999/contacts');
      expect(elsewhere.statusCode, 403);
      expect(elsewhere.body, contains('"forbidden"'));
      final missing = await send('PATCH', '$account/contacts/999999', {});
      expect(missing.statusCode, 404);
    },
  );
}
