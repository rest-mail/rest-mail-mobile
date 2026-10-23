import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  final clock = DateTime.utc(2026, 10, 23);
  setUp(() async {
    fake = FakeRestmail(clock: () => clock);
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
  Future<Ban> add(String ip, {String protocol = 'all', String? duration}) =>
      client.createBan(
        ip: ip,
        createdBy: FakeAccounts.adminEmail,
        protocol: protocol,
        durationText: duration,
      );

  test(
    'list filters before pagination and active false includes expired too',
    () async {
      await add('192.0.2.1', protocol: 'smtp');
      await add('192.0.2.2', protocol: 'imap');
      await add('192.0.2.3');
      await add('192.0.2.4', protocol: 'smtp', duration: '-1s');
      final all = (await client.bans(active: false)).items;
      final current = (await client.bans()).items;
      expect(all.any((ban) => ban.ip == '192.0.2.4'), isTrue);
      expect(current.any((ban) => ban.ip == '192.0.2.4'), isFalse);
      final smtp = await client.bans(protocol: 'smtp', active: false, limit: 1);
      final expected = all
          .where((ban) => ban.protocol == 'smtp' || ban.protocol == 'all')
          .length;
      expect(smtp.total, expected);
      expect(smtp.items, hasLength(1));
      expect(smtp.hasMore, isTrue);
      final ip = (await client.bans(ip: '192.0.2.2')).items;
      expect(ip.single.protocol, 'imap');
      expect(
        (await client.bans(
          protocol: 'all',
        )).items.every((ban) => ban.protocol == 'all'),
        isTrue,
      );
    },
  );
  test(
    'upsert preserves id and creation time, changes protocol and clears expiry',
    () async {
      final first = await add(
        '192.0.2.1',
        protocol: 'smtp',
        duration: '1h30m.5s',
      );
      expect(
        first.expiresAt!.toUtc(),
        clock.add(const Duration(hours: 1, minutes: 30, milliseconds: 500)),
      );
      final changed = await add('192.0.2.1', protocol: 'pop3');
      expect(changed.id, first.id);
      expect(changed.createdAt, first.createdAt);
      expect(changed.protocol, 'pop3');
      expect(changed.expiresAt, isNull);
      expect((await client.bans(ip: '192.0.2.1')).items, hasLength(1));
    },
  );
  test(
    'IPv6 unban removes exact IP and 404 on repeat; delete id stays idempotent',
    () async {
      final ban = await add('2001:db8::1');
      await add('2001:db8::2');
      await client.unbanIP(ban.ip);
      expect((await client.bans(ip: ban.ip)).items, isEmpty);
      expect((await client.bans(ip: '2001:db8::2')).items, hasLength(1));
      await expectLater(
        client.unbanIP(ban.ip),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
      await client.deleteBan(ban.id);
    },
  );
  test(
    'a create body is bound as the server binds it, every field at once',
    () async {
      Future<http.Response> create(Object body) => fake.client.post(
        Uri.parse('https://${FakeAccounts.host}/api/v1/admin/bans'),
        headers: {
          'authorization': 'Bearer ${client.tokens!.accessToken}',
          'content-type': 'application/json',
        },
        body: jsonEncode(body),
      );
      const protocolRule = 'protocol must be one of smtp, imap, pop3, all';
      final cases = <Map<String, Object?>, Map<String, String>>{
        {}: {
          'ip': 'IP address is required',
          'protocol': protocolRule,
          'created_by': 'required',
        },
        {
          'ip': '',
          'protocol': 'ftp',
          'duration': 'forever',
          'created_by': 'admin',
        }: {
          'ip': 'IP address is required',
          'protocol': protocolRule,
          'duration': 'invalid duration format (e.g. 24h, 168h)',
        },
        {
          'ip': 7,
          'protocol': 'all',
          'reason': null,
          'created_by': 'admin',
          'expires': 'soon',
        }: {
          'ip': 'must be a string',
          'reason': 'must not be null',
          'expires': 'not allowed',
        },
      };
      for (final MapEntry(key: body, value: want) in cases.entries) {
        final response = await create(body);
        expect(response.statusCode, 422, reason: '$body');
        expect(
          (jsonDecode(response.body)
              as Map<String, dynamic>)['error']['details']['fields'],
          want,
          reason: '$body',
        );
      }
      final made = await create({
        'ip': '192.0.2.9',
        'protocol': 'all',
        'created_by': '',
      });
      expect(made.statusCode, 201);
    },
  );

  test(
    'bad protocol and duration refuse before changing an existing ban',
    () async {
      final first = await add('192.0.2.1', protocol: 'smtp');
      await expectLater(
        add(first.ip, protocol: 'ftp'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields.containsKey('protocol'),
            'field',
            isTrue,
          ),
        ),
      );
      await expectLater(
        add(first.ip, duration: 'forever'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields.containsKey('duration'),
            'field',
            isTrue,
          ),
        ),
      );
      expect((await client.bans(ip: first.ip)).items.single.protocol, 'smtp');
    },
  );
  test(
    'read-only sessions cannot create or unban by IP and remain signed in',
    () async {
      final ban = await add('192.0.2.1');
      fake.addAccount(
        'reader@${FakeAccounts.host}',
        capabilities: {Capability.bansRead},
      );
      final reader = RestmailClient(
        server: Uri.parse('https://${FakeAccounts.host}'),
        httpClient: fake.client,
      );
      await reader.login(
        email: 'reader@${FakeAccounts.host}',
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      expect((await reader.bans(ip: ban.ip)).items, hasLength(1));
      await expectLater(
        reader.unbanIP(ban.ip),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      await expectLater(
        reader.createBan(ip: ban.ip, createdBy: 'reader'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(reader.tokens, isNotNull);
      reader.close();
    },
  );
}
