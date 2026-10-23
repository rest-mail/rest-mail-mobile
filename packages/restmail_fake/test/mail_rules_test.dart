import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

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

  test('a vacation reply is set, kept when turned off, and checked', () async {
    expect((await client.vacation(account)).enabled, isFalse);
    final on = await client.setVacation(
      account,
      enabled: true,
      subject: 'Away',
      body: 'Back Monday',
      startDate: DateTime.utc(2026, 10, 24),
      endDate: DateTime.utc(2026, 10, 26),
    );
    expect(on.enabled, isTrue);
    expect(on.startDate!.toUtc(), DateTime.utc(2026, 10, 24));

    await client.disableVacation(account);
    final off = await client.vacation(account);
    expect(off.enabled, isFalse);
    expect(off.subject, 'Away');
    expect(fake.vacationOf(FakeAccounts.adminEmail)?['body'], 'Back Monday');

    await expectFields(
      'PUT',
      '$account/vacation',
      {'enabled': true},
      {'subject': 'required when enabled', 'body': 'required when enabled'},
    );
    await expectFields(
      'PUT',
      '$account/vacation',
      {
        'enabled': false,
        'start_date': '2026-10-26T00:00:00Z',
        'end_date': '2026-10-24T00:00:00Z',
      },
      {'end_date': 'must be after start_date'},
    );
    await expectFields(
      'PUT',
      '$account/vacation',
      {'enabled': null},
      {'enabled': 'required'},
    );
    // Binding comes first, before the account is looked up.
    await expectFields(
      'PUT',
      '999999/vacation',
      {'subject': null, 'start_date': 'monday', 'reply_to': 'x'},
      {
        'enabled': 'required',
        'subject': 'must not be null',
        'start_date': 'must be a date-time',
        'reply_to': 'not allowed',
      },
    );
    final elsewhere = await send('PUT', '999999/vacation', {'enabled': false});
    expect(elsewhere.statusCode, 403);
    await expectFields('GET', '0/vacation', null, {'id': 'must be at least 1'});
  });

  test('a Sieve script is checked, saved, replaced and deleted', () async {
    final none = await client.sieveScript(account);
    expect(none.stored, isFalse);
    expect(none.mailboxId, account);

    const script =
        'require "fileinto";\nif header :contains "subject" "x" '
        '{ fileinto "X"; }';
    expect((await client.validateSieveScript(account, script)).valid, isTrue);
    expect(
      (await client.validateSieveScript(account, '')).message,
      'Empty script is valid',
    );
    final missing = await client.validateSieveScript(
      account,
      'if true { fileinto "X"; }',
    );
    expect(missing.valid, isFalse);
    expect(missing.message, contains('require "fileinto";'));
    expect(fake.sieveScriptOf(FakeAccounts.adminEmail), isNull);

    final created = await send('PUT', '$account/sieve', {'script': script});
    expect(created.statusCode, 201);
    final saved = await client.sieveScript(account);
    expect(saved.stored, isTrue);
    expect(saved.active, isTrue);
    expect(saved.scriptHash, hasLength(64));

    final replaced = await client.putSieveScript(
      account,
      'keep;',
      active: false,
    );
    expect(replaced.id, saved.id);
    expect(replaced.active, isFalse);
    expect(replaced.scriptHash, isNot(saved.scriptHash));

    await expectLater(
      client.putSieveScript(account, 'if true { reject "no"; }'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 400)
            .having((e) => e.code, 'code', 'invalid_sieve'),
      ),
    );
    expect((await client.sieveScript(account)).script, 'keep;');

    await client.deleteSieveScript(account);
    expect((await client.sieveScript(account)).stored, isFalse);
    await client.deleteSieveScript(account);

    await expectFields(
      'PUT',
      '$account/sieve',
      {'active': 'yes'},
      {'script': 'required', 'active': 'must be a boolean'},
    );
    await expectFields(
      'PUT',
      '$account/sieve',
      {'script': null},
      {'script': 'required'},
    );
    await expectFields(
      'POST',
      '$account/sieve/validate',
      {'script': 7},
      {'script': 'must be a string'},
    );
    final elsewhere = await send('GET', '999999/sieve');
    expect(elsewhere.statusCode, 403);
  });
}
