import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Future<RestmailClient> _signIn(
  FakeRestmail fake,
  String email, {
  String password = FakeAccounts.adminPassword,
}) async {
  final client = RestmailClient(
    server: Uri.parse('https://${fake.host}'),
    httpClient: fake.client,
  );
  await client.login(
    email: email,
    password: password,
    totpCode: FakeAccounts.totpCode,
  );
  return client;
}

void main() {
  late FakeRestmail fake;
  late RestmailClient admin;

  setUp(() async {
    fake = FakeRestmail();
    admin = await _signIn(fake, FakeAccounts.adminEmail);
  });
  tearDown(() {
    admin.close();
    fake.close();
  });

  /// The raw reply, for what the typed client would hide from a test.
  Future<http.Response> send(String path) async {
    final uri = Uri.parse(
      'https://${fake.host}/api/v1/admin/dmarc-reports$path',
    );
    return fake.client.get(
      uri,
      headers: {'authorization': 'Bearer ${admin.tokens!.accessToken}'},
    );
  }

  Future<void> expectFields(
    String path,
    Map<String, String> fields,
    String message,
  ) async {
    final reply = await send(path);
    expect(reply.statusCode, 422);
    final error = (jsonDecode(reply.body) as Map)['error'] as Map;
    expect(error['code'], 'validation_failed');
    expect(error['message'], message);
    expect((error['details'] as Map)['fields'], fields);
  }

  test('the list is newest first, with every field the client reads', () async {
    final page = await admin.dmarcReports();
    expect(page.total, 3);
    final times = [for (final report in page.items) report.receivedAt];
    expect(times, [...times]..sort((a, b) => b.compareTo(a)));
    final microsoft = page.items[1];
    expect(microsoft.reportingOrg, 'Microsoft Corporation');
    expect(microsoft.policy.domain, fake.host);
    expect(microsoft.passed, 96);
    expect(microsoft.failed, 3);
    final failing = microsoft.records.last;
    expect(failing.disposition, 'quarantine');
    expect(failing.reasons.single.type, 'other');
    expect(failing.dkimResults.single.humanResult, 'body hash mismatch');
    expect(failing.envelopeFrom, 'lists.example.net');
  });

  test('times answer as RFC 3339 in UTC, without fractions', () async {
    final reply = await send('');
    final row = ((jsonDecode(reply.body) as Map)['data'] as List).first as Map;
    expect(
      row['start_date'],
      matches(RegExp(r'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$')),
    );
    expect(
      row['received_at'],
      matches(RegExp(r'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$')),
    );
  });

  test('filters narrow by domain and literal reporter substring', () async {
    final report = (await admin.dmarcReports(reporter: 'GOOGLE')).items.single;
    expect(report.reporter, 'google.com');
    final filtered = await admin.dmarcReports(domainId: report.domainId);
    expect(filtered.total, 2);
    expect((await admin.dmarcReports(reporter: '%')).items, isEmpty);
    expect((await admin.dmarcReports(domainId: 99999)).items, isEmpty);
    expect((await admin.dmarcReports(limit: 1)).items, hasLength(1));
    expect((await admin.dmarcReports(limit: 1)).hasMore, isTrue);
    expect((await admin.dmarcReports(limit: 1, offset: 2)).hasMore, isFalse);
  });

  test('an empty page leaves its total out, as the server does', () async {
    final reply = await send('?domain_id=4294967295');
    expect(reply.statusCode, 200);
    expect(jsonDecode(reply.body), {
      'data': <Object>[],
      'pagination': {'has_more': false},
    });
  });

  test('filters are bound together, as the server does', () async {
    await expectFields(
      '?domain_id=-1&limit=500&offset=x&reporter=${'x' * 256}',
      {
        'domain_id': 'must be a non-negative integer',
        'limit': 'exceeds the maximum page size',
        'offset': 'must be an integer',
        'reporter': 'must be at most 255 characters',
      },
      'Query parameters failed validation',
    );
    await expectFields('?limit=not-an-integer', {
      'limit': 'must be an integer',
    }, 'Query parameters failed validation');
    final blank = await send('?domain_id=&limit=&reporter=');
    expect(blank.statusCode, 200);
  });

  test('one report: found, missing and malformed', () async {
    final first = (await admin.dmarcReports()).items.first;
    expect((await admin.dmarcReport(first.id)).reportId, first.reportId);
    final missing = await send('/4294967295');
    expect(missing.statusCode, 404);
    expect(jsonDecode(missing.body), {
      'error': {
        'code': 'dmarc_report_not_found',
        'message': 'DMARC report not found',
      },
    });
    await expectFields('/0', {
      'id': 'must be at least 1',
    }, 'Path parameters failed validation');
    await expectFields('/x', {
      'id': 'must be a non-negative integer',
    }, 'Path parameters failed validation');
  });

  test('no capability refuses both routes', () async {
    final client = await _signIn(
      fake,
      FakeAccounts.email,
      password: FakeAccounts.password,
    );
    addTearDown(client.close);
    final id = (await admin.dmarcReports()).items.first.id;
    for (final call in [
      () => client.dmarcReports(),
      () => client.dmarcReport(id),
    ]) {
      await expectLater(
        call(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 403)
              .having((e) => e.code, 'code', 'forbidden'),
        ),
      );
    }
  });

  test('a global read sees every domain', () async {
    final email = 'viewer@${fake.host}';
    fake.addAccount(email, capabilities: {Capability.domainsRead});
    final viewer = await _signIn(fake, email);
    addTearDown(viewer.close);
    expect((await viewer.dmarcReports()).total, 3);
  });

  group('at a scope', () {
    late RestmailClient scoped;
    late int own;
    late int foreign;

    Future<void> signInAt(String scope) async {
      final email = 'scoped@${fake.host}';
      fake.addAccount(email);
      final holder = (await admin.mailboxes(
        limit: 200,
      )).items.firstWhere((mailbox) => mailbox.address == email);
      await admin.createGrant(
        holder: GrantHolder.account(holder.id),
        role: 'admin',
        scope: scope,
      );
      scoped = await _signIn(fake, email);
      addTearDown(scoped.close);
    }

    setUp(() async {
      final reports = (await admin.dmarcReports()).items;
      own = reports.firstWhere((r) => r.policy.domain == fake.host).id;
      foreign = reports.firstWhere((r) => r.policy.domain != fake.host).id;
    });

    test('a domain reads its own reports and totals only', () async {
      await signInAt('domain:${fake.host}');
      final page = await scoped.dmarcReports();
      expect(page.total, 2);
      expect(page.items.map((r) => r.policy.domain), everyElement(fake.host));
      expect((await scoped.dmarcReport(own)).id, own);
      await expectLater(
        scoped.dmarcReport(foreign),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.code, 'code', 'dmarc_report_not_found'),
        ),
      );
    });

    test('a filter for another domain intersects to nothing', () async {
      await signInAt('domain:${fake.host}');
      final others = await admin.dmarcReport(foreign);
      final page = await scoped.dmarcReports(domainId: others.domainId);
      expect(page.items, isEmpty);
      expect(page.total, 0);
    });

    test('a mailbox is refused, after the filters are read', () async {
      await signInAt('mailbox:${FakeAccounts.email}');
      await expectLater(
        scoped.dmarcReports(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      await expectLater(
        scoped.dmarcReports(domainId: -1),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 422)),
      );
      await expectLater(
        scoped.dmarcReport(own),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
    });
  });

  test('an empty install has no reports', () async {
    final empty = FakeRestmail(scenario: FakeScenario.empty);
    addTearDown(empty.close);
    final client = await _signIn(empty, FakeAccounts.adminEmail);
    addTearDown(client.close);
    final page = await client.dmarcReports();
    expect(page.items, isEmpty);
    expect(page.total, 0);
  });
}
