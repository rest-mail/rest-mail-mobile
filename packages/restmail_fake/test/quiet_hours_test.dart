import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late int account;
  const setting = QuietHoursSetting(
    enabled: true,
    start: '22:00',
    end: '08:00',
    timeZone: 'Europe/Berlin',
  );
  setUp(() async {
    fake = FakeRestmail(scenario: FakeScenario.twoFactor);
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
      totpCode: FakeAccounts.totpCode,
    );
    account = (await client.accounts()).first.id;
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  Future<http.Response> put(Object body, {int? id}) => fake.client.put(
    Uri.parse(
      'https://${fake.host}/api/v1/accounts/${id ?? account}/quiet-hours',
    ),
    headers: {
      'authorization': 'Bearer ${client.tokens!.accessToken}',
      'content-type': 'application/json',
    },
    body: jsonEncode(body),
  );

  test(
    'served contract named request examples have exact matching answers',
    () async {
      final document =
          jsonDecode(File('../../api_contract/openapi.json').readAsStringSync())
              as Map<String, dynamic>;
      final route =
          document['paths']['/api/v1/accounts/{id}/quiet-hours']
              as Map<String, dynamic>;
      final get =
          route['get']['responses']['200']['content']['application/json']['examples']['disabled']['value'];
      final disabled = await fake.client.get(
        Uri.parse('https://${fake.host}/api/v1/accounts/$account/quiet-hours'),
        headers: {'authorization': 'Bearer ${client.tokens!.accessToken}'},
      );
      expect(jsonDecode(disabled.body), get);
      final operation = route['put'] as Map<String, dynamic>;
      for (final (name, status) in [
        ('enabled', 200),
        ('turned_off', 200),
        ('equal_times', 422),
        ('invalid_zone', 422),
        ('enabled_missing', 422),
        ('enabled_invalid', 422),
      ]) {
        final body =
            operation['requestBody']['content']['application/json']['examples'][name]['value'];
        final expected =
            operation['responses']['$status']['content']['application/json']['examples'][name]['value'];
        final response = await put(body as Object);
        expect(response.statusCode, status, reason: name);
        expect(jsonDecode(response.body), expected, reason: name);
      }
    },
  );

  test(
    'off default, enable, edit and disable without mutating mail or another mailbox',
    () async {
      expect((await client.quietHours(account)).enabled, isFalse);
      await client.setQuietHours(account, setting);
      expect((await client.quietHours(account)).timeZone, 'Europe/Berlin');
      await client.setQuietHours(
        account,
        setting.copyWith(start: '23:15', timeZone: 'Asia/Kathmandu'),
      );
      fake.deliver(
        to: FakeAccounts.email,
        from: 'someone@example.test',
        subject: 'Delivered during quiet hours',
      );
      expect(
        (await client.messages(account, 'INBOX')).items.any(
          (message) => message.subject == 'Delivered during quiet hours',
        ),
        isTrue,
      );
      final disabled = await client.setQuietHours(
        account,
        setting.copyWith(enabled: false),
      );
      expect(disabled.enabled, isFalse);
      expect(disabled.start, '22:00');
      expect(disabled.timeZone, 'Europe/Berlin');
      expect(
        (await client.setQuietHours(
          account,
          const QuietHoursSetting(),
        )).timeZone,
        isEmpty,
      );
    },
  );

  test(
    'invalid schedules, including disabled nonempty values, do not mutate',
    () async {
      await client.setQuietHours(account, setting);
      for (final invalid in [
        setting.copyWith(start: '9:00'),
        setting.copyWith(start: '24:00'),
        setting.copyWith(end: '08:60'),
        setting.copyWith(start: '22:00:00'),
        setting.copyWith(end: '22:00'),
        setting.copyWith(timeZone: 'Local'),
        setting.copyWith(timeZone: 'Mars/Olympus'),
        setting.copyWith(timeZone: ''),
        setting.copyWith(enabled: false, start: 'invalid'),
        setting.copyWith(enabled: false, timeZone: 'CET+99'),
      ]) {
        await expectLater(
          client.setQuietHours(account, invalid),
          throwsA(
            isA<ApiException>().having(
              (error) => error.statusCode,
              'status',
              422,
            ),
          ),
        );
        expect((await client.quietHours(account)).start, '22:00');
      }
    },
  );

  test(
    'binding refuses missing, unknown, null and wrong-typed fields',
    () async {
      for (final body in [
        <String, Object?>{},
        {'enabled': true},
        {'enabled': null, 'start': '', 'end': '', 'time_zone': ''},
        {'enabled': false, 'start': 1, 'end': '', 'time_zone': ''},
        {
          'enabled': false,
          'start': '',
          'end': '',
          'time_zone': '',
          'extra': true,
        },
      ]) {
        expect((await put(body)).statusCode, 422);
      }
    },
  );

  test('scoped API keys require the real read/write capabilities', () async {
    for (final capability in ['mail:read', 'mail:write']) {
      final key = await client.createAPIKey(
        account,
        name: capability,
        password: FakeAccounts.password,
        permissions: [
          APIKeyPermission(
            capability: capability,
            scope: 'mailbox:${FakeAccounts.email}',
          ),
        ],
      );
      final transport = fake.client;
      addTearDown(transport.close);
      final url = Uri.parse(
        'https://${fake.host}/api/v1/accounts/$account/quiet-hours',
      );
      final headers = {
        'authorization': 'Bearer ${key.token}',
        'content-type': 'application/json',
      };
      expect(
        (await transport.get(url, headers: headers)).statusCode,
        capability == 'mail:read' ? 200 : 403,
      );
      expect(
        (await transport.put(
          url,
          headers: headers,
          body: jsonEncode({
            'enabled': false,
            'start': '',
            'end': '',
            'time_zone': '',
          }),
        )).statusCode,
        capability == 'mail:write' ? 200 : 403,
      );
    }
  });

  test(
    'mail read/write grants, unseen and missing accounts match refusals',
    () async {
      final admin = RestmailClient(
        server: Uri.parse('https://${fake.host}'),
        httpClient: fake.client,
      );
      addTearDown(admin.close);
      await admin.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      final other = (await admin.accounts()).first.id;
      final notFound = throwsA(
        isA<ApiException>().having((error) => error.statusCode, 'status', 404),
      );
      await expectLater(client.quietHours(other), notFound);
      await expectLater(client.quietHours(99999), notFound);
      fake.grant(FakeAccounts.email, {'mail:read'});
      expect((await client.quietHours(other)).enabled, isFalse);
      await expectLater(
        client.setQuietHours(other, setting),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'status',
            403,
          ),
        ),
      );
      fake.grant(FakeAccounts.email, {'mail:write'});
      await expectLater(
        client.quietHours(other),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'status',
            403,
          ),
        ),
      );
      expect((await client.setQuietHours(other, setting)).enabled, isTrue);
      expect((await client.quietHours(account)).enabled, isFalse);
      fake.grant(FakeAccounts.email, {'mailbox:manage'});
      await expectLater(
        client.quietHours(other),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'status',
            403,
          ),
        ),
      );
    },
  );
}
