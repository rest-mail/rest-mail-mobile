import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

const _domain = {
  'id': 4,
  'name': 'Example.test',
  'server_type': 'traditional',
  'active': false,
  'default_quota_bytes': 0,
  'dkim_selector': 'mail',
  'sending_policy': '',
  'dmarc_policy': 'quarantine',
  'created_at': '2026-10-27T07:00:00Z',
  'updated_at': '2026-10-27T07:01:00Z',
};
const _box = {
  'id': 9,
  'domain_id': 4,
  'local_part': 'Ada',
  'address': 'Ada@Example.test',
  'display_name': 'Ada',
  'active': false,
  'quota_bytes': 0,
  'quota_used_bytes': 6,
  'last_login_at': null,
  'password_change_required': true,
  'two_factor_required': true,
  'created_at': '2026-10-27T07:00:00Z',
  'updated_at': '2026-10-27T07:01:00Z',
  'domain': _domain,
  'quota_usage': {
    'mailbox_id': 9,
    'subject_bytes': 1,
    'body_bytes': 2,
    'attachment_bytes': 3,
    'message_count': 1,
    'updated_at': '2026-10-27T07:01:00Z',
  },
};

http.Response _json(Object value, [int status = 200]) => http.Response.bytes(
  utf8.encode(jsonEncode(value)),
  status,
  headers: {'content-type': 'application/json', ...contractSecurityHeaders},
);

RestmailClient _client(Future<http.Response> Function(http.Request) send) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient(send),
    );

void main() {
  test(
    'all six domain operations use generated requests and UI projections',
    () async {
      final requests = <http.Request>[];
      final client = _client((request) async {
        requests.add(request);
        expect(request.headers['Authorization'], 'Bearer access');
        if (request.method == 'DELETE') {
          return http.Response('', 204, headers: contractSecurityHeaders);
        }
        if (request.url.path.endsWith('/dns')) {
          return _json({
            'data': {
              'domain': 'Example.test',
              'summary': '1/2 records verified',
              'records': [
                {
                  'type': 'MX',
                  'name': 'Example.test',
                  'status': 'ok',
                  'value': 'mx.Example.test',
                },
                {
                  'type': 'DMARC',
                  'name': '_dmarc.Example.test',
                  'status': 'missing',
                  'message': 'No DMARC record found',
                },
              ],
            },
          });
        }
        if (request.method == 'GET' && request.url.path.endsWith('/domains')) {
          return _json({
            'data': [_domain],
            'pagination': {'total': 30, 'has_more': true},
          });
        }
        return _json({'data': _domain}, request.method == 'POST' ? 201 : 200);
      });
      addTearDown(client.close);
      final page = await client.domains(offset: 3, limit: 7);
      expect(page.total, 30);
      expect(page.offset, 3);
      expect(page.hasMore, isTrue);
      expect(requests.last.url.queryParameters, {'offset': '3', 'limit': '7'});
      final detail = await client.domain(4);
      expect(detail.name, 'Example.test');
      expect(detail.dmarcPolicy, 'quarantine');
      expect(detail.createdAt?.toUtc(), DateTime.utc(2026, 10, 27, 7));
      await client.createDomain(
        'Example.test',
        serverType: 'traditional',
        defaultQuotaBytes: 0,
        sendingPolicy: '',
        dmarcPolicy: 'quarantine',
      );
      expect(jsonDecode(requests.last.body), {
        'name': 'Example.test',
        'server_type': 'traditional',
        'default_quota_bytes': 0,
        'sending_policy': '',
        'dmarc_policy': 'quarantine',
      });
      await client.updateDomain(
        4,
        active: false,
        defaultQuotaBytes: 0,
        sendingPolicy: '',
        dmarcPolicy: 'quarantine',
      );
      expect(jsonDecode(requests.last.body), {
        'active': false,
        'default_quota_bytes': 0,
        'sending_policy': '',
        'dmarc_policy': 'quarantine',
      });
      final dns = await client.dnsCheck(4);
      expect(dns.summary, '1/2 records verified');
      expect(dns.records.first.ok, isTrue);
      expect(dns.records.last.value, '');
      expect(dns.records.last.message, 'No DMARC record found');
      await client.deleteDomain(4);
      expect(requests.map((r) => '${r.method} ${r.url.path}'), [
        'GET /api/v1/admin/domains',
        'GET /api/v1/admin/domains/4',
        'POST /api/v1/admin/domains',
        'PATCH /api/v1/admin/domains/4',
        'GET /api/v1/admin/domains/4/dns',
        'DELETE /api/v1/admin/domains/4',
      ]);
    },
  );

  test('all five existing mailbox operations preserve filters, quota and setup state', () async {
    final requests = <http.Request>[];
    final client = _client((request) async {
      requests.add(request);
      if (request.method == 'DELETE') {
        return http.Response('', 204, headers: contractSecurityHeaders);
      }
      if (request.url.path.endsWith('/mailboxes')) {
        return _json({
          'data': [_box],
          'pagination': {'total': 20, 'has_more': true},
        });
      }
      return _json({'data': _box});
    });
    addTearDown(client.close);
    final page = await client.mailboxes(domainId: 4, offset: 3, limit: 7);
    expect(requests.last.url.queryParameters, {
      'domain_id': '4',
      'offset': '3',
      'limit': '7',
    });
    expect(page.total, 20);
    final box = await client.adminMailbox(9);
    expect(box.address, 'Ada@Example.test');
    expect(box.domain?.name, 'Example.test');
    expect(box.quotaUsage?.attachmentBytes, 3);
    expect(
      box.quotaUsage?.updatedAt?.toUtc(),
      DateTime.utc(2026, 10, 27, 7, 1),
    );
    expect(box.passwordChangeRequired, isTrue);
    expect(box.twoFactorRequired, isTrue);
    expect(box.lastLoginAt, isNull);
    await client.updateMailbox(
      9,
      displayName: '',
      password: 'new-password',
      active: false,
      quotaBytes: 0,
    );
    expect(jsonDecode(requests.last.body), {
      'display_name': '',
      'password': 'new-password',
      'active': false,
      'quota_bytes': 0,
    });
    await client.endMailboxSessions(9);
    await client.deleteMailbox(9);
    expect(requests.map((r) => '${r.method} ${r.url.path}'), [
      'GET /api/v1/admin/mailboxes',
      'GET /api/v1/admin/mailboxes/9',
      'PATCH /api/v1/admin/mailboxes/9',
      'DELETE /api/v1/admin/mailboxes/9/sessions',
      'DELETE /api/v1/admin/mailboxes/9',
    ]);
    expect(
      requests.where((r) => r.method == 'DELETE').map((r) => r.body),
      everyElement(isEmpty),
    );
  });

  test('missing declared fields or headers and wrong creation status fail decoding', () async {
    final responses = [
      _json({
        'data': {'id': 4},
      }),
      http.Response(
        jsonEncode({'data': _domain}),
        200,
        headers: {'content-type': 'application/json'},
      ),
      _json({'data': _domain}),
    ];
    final client = _client((_) async => responses.removeAt(0));
    addTearDown(client.close);
    for (final read in [
      () => client.domain(4),
      () => client.domain(4),
      () => client.createDomain('Example.test'),
    ]) {
      await expectLater(
        read(),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
        ),
      );
    }
  });

  test(
    'scope refusal keeps the session and original server field errors',
    () async {
      var calls = 0;
      final client = _client((_) async {
        calls++;
        return _json({
          'error': {
            'code': 'forbidden',
            'message': 'Outside the granted domain',
          },
        }, 403);
      });
      addTearDown(client.close);
      await expectLater(
        client.updateMailbox(9, quotaBytes: 0),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'forbidden')),
      );
      expect(calls, 1);
      expect(client.tokens?.refreshToken, 'refresh');
    },
  );

  test('invalid legacy string choices identify the field without sending malformed wire data', () async {
    var calls = 0;
    final client = _client((_) async {
      calls++;
      return _json({'data': _domain}, 201);
    });
    addTearDown(client.close);
    await expectLater(
      client.createDomain('Example.test', sendingPolicy: 'spam'),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'status', 422).having(
          (e) => e.fields.keys,
          'fields',
          ['sending_policy'],
        ),
      ),
    );
    expect(calls, 0);
  });
}
