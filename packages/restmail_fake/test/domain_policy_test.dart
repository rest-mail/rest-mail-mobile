import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late AdminDomain domain;
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
    domain = (await client.domains()).items.firstWhere(
      (d) => d.name == FakeAccounts.host,
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

  group('relay', () {
    test('a domain sends direct until a relay is set, and the password '
        'is never answered', () async {
      expect(
        (await client.domainRelay(domain.id)).transport,
        OutboundTransport.direct,
      );
      final relay = await client.setDomainRelay(
        domain.id,
        transport: OutboundTransport.relay,
        host: 'smtp.relay.test',
        port: 587,
        tlsMode: RelayTlsMode.starttls,
        username: 'robot',
        password: 's3cret',
      );
      expect(relay.transport, OutboundTransport.relay);
      expect(relay.host, 'smtp.relay.test');
      expect(relay.port, 587);
      expect(relay.passwordSet, isTrue);
      final raw = await send('GET', 'domains/${domain.id}/relay');
      expect(raw.body, isNot(contains('s3cret')));

      // Left out, the password is kept; empty, it is cleared, and so must
      // the username be.
      final kept = await client.setDomainRelay(
        domain.id,
        transport: OutboundTransport.relay,
        host: '192.0.2.7',
        port: 465,
        tlsMode: RelayTlsMode.implicit,
        username: 'robot',
      );
      expect(kept.passwordSet, isTrue);
      await expectFields(
        'PUT',
        'domains/${domain.id}/relay',
        {
          'transport': 'relay',
          'host': '192.0.2.7',
          'port': 465,
          'tls_mode': 'implicit',
          'username': 'robot',
          'password': '',
        },
        {'password': 'A username and a password are set together, or neither'},
      );

      final direct = await client.setDomainRelay(
        domain.id,
        transport: OutboundTransport.direct,
      );
      expect(direct.transport, OutboundTransport.direct);
      expect(direct.passwordSet, isFalse);
    });

    test('a relay body is bound, then shaped, then checked', () async {
      final path = 'domains/${domain.id}/relay';
      await expectFields('PUT', path, {}, {
        'transport': 'Must be one of: direct, relay',
      });
      await expectFields(
        'PUT',
        path,
        {
          'transport': 'smoke',
          'host': null,
          'port': 70000,
          'tls_mode': 'tls',
          'username': 5,
          'colour': 'red',
        },
        {
          'transport': 'Must be one of: direct, relay',
          'host': 'must not be null',
          'port': 'Must be between 1 and 65535',
          'tls_mode': 'Must be one of: starttls, implicit',
          'username': 'must be a string',
          'colour': 'not allowed',
        },
      );
      await expectFields(
        'PUT',
        path,
        {'transport': 'relay', 'port': '587'},
        {'port': 'must be an integer'},
      );
      await expectFields(
        'PUT',
        path,
        {'transport': 'relay', 'host': 'smtp://relay.test:587'},
        {
          'host':
              'Must be a bare host name or IP address, with no scheme, port '
              'or path',
          'port': 'Must be between 1 and 65535',
          'tls_mode': 'Must be one of: starttls, implicit',
        },
      );
      // Direct keeps no relay, but a field's shape is checked all the same.
      await expectFields(
        'PUT',
        path,
        {'transport': 'direct', 'password': 'a\r\nRCPT TO:<x@y>'},
        {'password': 'Must not contain control characters'},
      );
      await expectFields('GET', 'domains/0/relay', null, {
        'id': 'must be at least 1',
      });
      final missing = await send('GET', 'domains/999999/relay');
      expect(missing.statusCode, 404);
      expect(missing.body, contains('"not_found"'));
    });
  });

  group('suppressions', () {
    test(
      'listed newest first while in force, and cleared one by one',
      () async {
        final older = fake.addSuppression(
          domain.name,
          'gone@elsewhere.test',
          lastError: '550 5.1.1 No such user',
        );
        final newer = fake.addSuppression(
          domain.name,
          'nobody@nowhere.test',
          failureCategory: 'bad_domain',
        );
        fake.addSuppression(
          domain.name,
          'once@elsewhere.test',
          lasts: const Duration(days: -1),
        );

        final listed = await client.suppressions(domain.id);
        expect(listed.map((s) => s.id), [newer, older]);
        expect(listed.last.lastError, '550 5.1.1 No such user');
        expect(listed.first.failureCategory, 'bad_domain');
        expect(listed.first.reason, 'hard_bounce');

        final other = (await client.domains()).items.firstWhere(
          (d) => d.id != domain.id,
        );
        expect(await client.suppressions(other.id), isEmpty);
        final elsewhere = await send(
          'DELETE',
          'domains/${other.id}/suppressions/$older',
        );
        expect(elsewhere.statusCode, 404);

        await client.clearSuppression(domain.id, older);
        expect((await client.suppressions(domain.id)).map((s) => s.id), [
          newer,
        ]);
        await expectFields(
          'DELETE',
          'domains/${domain.id}/suppressions/nope',
          null,
          {'sid': 'must be a non-negative integer'},
        );
      },
    );
  });

  test('sender lists and MTA-STS bind their bodies first', () async {
    await expectFields(
      'POST',
      'domains/${domain.id}/blocklist',
      {'pattern': '', 'reason': null, 'list_type': 'allow'},
      {
        'pattern': 'required',
        'reason': 'must not be null',
        'list_type': 'not allowed',
      },
    );
    await expectFields(
      'POST',
      'domains/999999/allowlist',
      {'pattern': 7},
      {'pattern': 'must be a string'},
    );
    await expectFields('DELETE', 'domains/${domain.id}/allowlist/0', null, {
      'eid': 'must be at least 1',
    });
    await expectFields(
      'PUT',
      'domains/${domain.id}/mta-sts',
      {'mode': 'strict', 'max_age': -1, 'active': 'yes', 'mx': 'mx.test'},
      {
        'mode': 'Must be one of: none, testing, enforce',
        'max_age': 'Must be a non-negative integer (seconds)',
        'active': 'must be a boolean',
        'mx': 'not allowed',
      },
    );
    await expectFields(
      'PUT',
      'domains/${domain.id}/mta-sts',
      {'max_age': '86400'},
      {'max_age': 'must be an integer'},
    );
    // A refused body reaches nothing: the domain is looked up after it.
    await expectFields(
      'PUT',
      'domains/999999/mta-sts',
      {'mode': 'strict'},
      {'mode': 'Must be one of: none, testing, enforce'},
    );
  });

  test('TLS report filters are bound together, as the server does', () async {
    await expectFields(
      'GET',
      'tls-reports?domain_id=-1&limit=500&offset=x&policy_type=STS',
      null,
      {
        'domain_id': 'must be a non-negative integer',
        'limit': 'exceeds the maximum page size',
        'offset': 'must be an integer',
        'policy_type': 'must be one of sts, tlsa, no-policy',
      },
    );
    await expectFields('GET', 'tls-reports?policy_type=', null, {
      'policy_type': 'must be one of sts, tlsa, no-policy',
    });
    final blank = await send('GET', 'tls-reports?domain_id=&limit=');
    expect(blank.statusCode, 200);
  });
}
