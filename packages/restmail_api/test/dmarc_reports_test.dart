import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

final _tokens = SessionTokens(
  accessToken: 'access',
  refreshToken: 'refresh',
  accessExpiresAt: DateTime.utc(2099),
);

RestmailClient _client(Future<http.Response> Function(http.Request) send) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: _tokens,
      httpClient: MockClient(send),
    );

http.Response _json(Object? body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json', ...contractSecurityHeaders},
);

/// The server's documented answer, every optional field present.
const _report = {
  'id': 7,
  'domain_id': 1,
  'reporter': 'reporter.test',
  'reporting_org': 'Reporter',
  'report_id': 'daily-1',
  'start_date': '2026-11-02T00:00:00Z',
  'end_date': '2026-11-02T23:59:59Z',
  'received_at': '2026-11-03T00:00:00Z',
  'policy_published': {
    'domain': 'a.test',
    'p': 'quarantine',
    'sp': 'reject',
    'np': 'none',
    'adkim': 's',
    'aspf': 'r',
    'pct': 50,
    'fo': '1',
    'testing': 'y',
    'discovery_method': 'treewalk',
  },
  'records': [
    {
      'row': {
        'source_ip': '192.0.2.1',
        'count': 12,
        'policy_evaluated': {
          'disposition': 'none',
          'dkim': 'pass',
          'spf': 'fail',
        },
      },
      'identifiers': {'header_from': 'a.test'},
      'auth_results': {
        'dkim': [
          {'domain': 'a.test', 'selector': 'mail', 'result': 'pass'},
        ],
      },
    },
    {
      'row': {
        'source_ip': '198.51.100.1',
        'count': 3,
        'policy_evaluated': {
          'disposition': 'reject',
          'dkim': 'fail',
          'spf': 'fail',
          'reasons': [
            {'type': 'other', 'comment': 'mailing list'},
            {'type': 'forwarded'},
          ],
        },
      },
      'identifiers': {
        'header_from': 'a.test',
        'envelope_from': 'b.test',
        'envelope_to': 'c.test',
      },
      'auth_results': {
        'spf': [
          {
            'domain': 'b.test',
            'scope': 'mfrom',
            'result': 'softfail',
            'human_result': 'not listed',
          },
        ],
      },
    },
  ],
};

void main() {
  test('the list sends its filters and reads the whole report', () async {
    late Uri asked;
    final client = _client((request) async {
      asked = request.url;
      expect(request.headers['authorization'], 'Bearer access');
      return _json({
        'data': [_report],
        'pagination': {'total': 11, 'has_more': true},
      });
    });
    addTearDown(client.close);

    final page = await client.dmarcReports(
      domainId: 1,
      reporter: 'A+_%',
      offset: 10,
      limit: 1,
    );

    expect(asked.path, '/api/v1/admin/dmarc-reports');
    expect(asked.queryParameters, {
      'domain_id': '1',
      'reporter': 'A+_%',
      'limit': '1',
      'offset': '10',
    });
    expect(page.total, 11);
    expect(page.offset, 10);
    final report = page.items.single;
    expect(report.id, 7);
    expect(report.domainId, 1);
    expect(report.reporter, 'reporter.test');
    expect(report.reportingOrg, 'Reporter');
    expect(report.reportId, 'daily-1');
    expect(report.startDate, DateTime.utc(2026, 11, 2));
    expect(report.endDate, DateTime.utc(2026, 11, 2, 23, 59, 59));
    expect(report.receivedAt, DateTime.utc(2026, 11, 3));
    expect(report.passed, 12);
    expect(report.failed, 3);

    final policy = report.policy;
    expect(policy.domain, 'a.test');
    expect(policy.policy, 'quarantine');
    expect(policy.subdomainPolicy, 'reject');
    expect(policy.nonexistentDomainPolicy, 'none');
    expect(policy.dkimAlignment, 's');
    expect(policy.spfAlignment, 'r');
    expect(policy.percentage, 50);
    expect(policy.failureOptions, '1');
    expect(policy.testing, 'y');
    expect(policy.discoveryMethod, 'treewalk');

    final [first, second] = report.records;
    expect(first.sourceIp, '192.0.2.1');
    expect(first.count, 12);
    expect(first.disposition, 'none');
    expect(first.dkim, 'pass');
    expect(first.spf, 'fail');
    expect(first.passed, isTrue);
    expect(first.headerFrom, 'a.test');
    expect(first.dkimResults.single.selector, 'mail');
    expect(first.spfResults, isEmpty);
    expect(first.reasons, isEmpty);
    expect(second.passed, isFalse);
    expect(second.disposition, 'reject');
    expect(second.envelopeFrom, 'b.test');
    expect(second.envelopeTo, 'c.test');
    expect(second.reasons.map((reason) => reason.type), ['other', 'forwarded']);
    expect(second.reasons.first.comment, 'mailing list');
    expect(second.reasons.last.comment, isNull);
    expect(second.spfResults.single.scope, 'mfrom');
    expect(second.spfResults.single.result, 'softfail');
    expect(second.spfResults.single.humanResult, 'not listed');
    expect(second.dkimResults, isEmpty);
  });

  test('a page the server gives no total for is the whole of it', () async {
    final client = _client(
      (_) async => _json({
        'data': <Object>[],
        'pagination': {'has_more': false},
      }),
    );
    addTearDown(client.close);

    final page = await client.dmarcReports();

    expect(page.items, isEmpty);
    expect(page.total, 0);
    expect(page.hasMore, isFalse);
  });

  test('a filter left out is not sent', () async {
    late Uri asked;
    final client = _client((request) async {
      asked = request.url;
      return _json({
        'data': <Object>[],
        'pagination': {'has_more': false},
      });
    });
    addTearDown(client.close);

    await client.dmarcReports();

    expect(asked.queryParameters.keys, unorderedEquals(['limit', 'offset']));
  });

  test('one report comes from its own path', () async {
    late Uri asked;
    final client = _client((request) async {
      asked = request.url;
      return _json({'data': _report});
    });
    addTearDown(client.close);

    final report = await client.dmarcReport(7);

    expect(asked.path, '/api/v1/admin/dmarc-reports/7');
    expect(report.reportId, 'daily-1');
    expect(report.records, hasLength(2));
  });

  test('refusals keep the server\'s status, code and fields', () async {
    final tokens = <String>[];
    Future<void> refused(
      int status,
      Map<String, Object?> error,
      Future<void> Function(RestmailClient) call,
      void Function(ApiException) check,
    ) async {
      final client = _client((_) async => _json({'error': error}, status));
      addTearDown(client.close);
      final before = client.tokens;
      await expectLater(
        call(client),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'status', status),
        ),
      );
      try {
        await call(client);
      } on ApiException catch (error) {
        check(error);
      }
      expect(client.tokens, same(before));
      tokens.add('$status');
    }

    await refused(
      404,
      {'code': 'dmarc_report_not_found', 'message': 'DMARC report not found'},
      (client) => client.dmarcReport(9),
      (error) => expect(error.code, 'dmarc_report_not_found'),
    );
    await refused(
      403,
      {'code': 'forbidden', 'message': 'Insufficient permissions'},
      (client) => client.dmarcReports(),
      (error) => expect(error.code, 'forbidden'),
    );
    await refused(
      422,
      {
        'code': 'validation_failed',
        'message': 'Query parameters failed validation',
        'details': {
          'fields': {'domain_id': 'must be a non-negative integer'},
        },
      },
      (client) => client.dmarcReports(domainId: -1),
      (error) =>
          expect(error.fields, {'domain_id': 'must be a non-negative integer'}),
    );
    expect(tokens, ['404', '403', '422']);
  });
}
