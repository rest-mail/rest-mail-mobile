import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/http_contract.dart';

const _domain = {
  'id': 4,
  'name': 'example.test',
  'server_type': 'traditional',
  'active': true,
  'default_quota_bytes': 1073741824,
  'dkim_selector': 'mail',
  'sending_policy': 'bulk',
  'dmarc_policy': 'none',
  'created_at': '2026-10-20T09:00:00+01:00',
  'updated_at': '2026-10-21T09:00:00Z',
};
const _mailbox = {
  'id': 9,
  'domain_id': 4,
  'local_part': 'Ada',
  'address': 'Ada@example.test',
  'display_name': 'Ada Lovelace',
  'active': true,
  'quota_bytes': 1073741824,
  'quota_used_bytes': 600,
  'last_login_at': '2026-10-22T09:00:00Z',
  'password_change_required': true,
  'two_factor_required': true,
  'last_password_change': '2026-10-21T09:00:00Z',
  'created_at': '2026-10-20T09:00:00Z',
  'updated_at': '2026-10-22T09:00:00Z',
  'domain': _domain,
  'quota_usage': {
    'mailbox_id': 9,
    'subject_bytes': 100,
    'body_bytes': 200,
    'attachment_bytes': 300,
    'message_count': 7,
    'updated_at': '2026-10-22T09:00:00Z',
  },
};
const _alias = {
  'id': 12,
  'domain_id': 4,
  'source_address': 'sales@example.test',
  'destination_address': 'CaseSensitive@Remote.test',
  'active': false,
  'created_at': '2026-10-20T09:00:00Z',
  'domain': _domain,
};

http.Response _json(Object body, {int status = 200}) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {'content-type': 'application/json', ...contractSecurityHeaders},
);

RestmailClient _client(Future<http.Response> Function(http.Request) respond) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      httpClient: MockClient(respond),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
      ),
    );

void _domainFields(AdminDomain domain) {
  expect(domain.id, 4);
  expect(domain.name, 'example.test');
  expect(domain.serverType, 'traditional');
  expect(domain.active, isTrue);
  expect(domain.defaultQuotaBytes, 1073741824);
  expect(domain.dkimSelector, 'mail');
  expect(domain.sendingPolicy, 'bulk');
  expect(domain.createdAt?.toUtc(), DateTime.utc(2026, 10, 20, 8));
  expect(domain.updatedAt?.toUtc(), DateTime.utc(2026, 10, 21, 9));
}

void main() {
  test('fresh domain GET and all metadata', () async {
    final client = _client((r) async {
      expect(r.method, 'GET');
      expect(r.url.path, '/api/v1/admin/domains/4');
      expect(r.body, isEmpty);
      expect(r.headers['Authorization'], 'Bearer access');
      return _json({'data': _domain});
    });
    addTearDown(client.close);
    _domainFields(await client.domain(4));
  });

  test(
    'fresh mailbox GET reads domain, setup flags and quota breakdown',
    () async {
      final client = _client((r) async {
        expect(r.method, 'GET');
        expect(r.url.path, '/api/v1/admin/mailboxes/9');
        expect(r.body, isEmpty);
        return _json({'data': _mailbox});
      });
      addTearDown(client.close);
      final box = await client.adminMailbox(9);
      expect(box.id, 9);
      expect(box.domainId, 4);
      expect(box.localPart, 'Ada');
      expect(box.address, 'Ada@example.test');
      expect(box.displayName, 'Ada Lovelace');
      expect(box.active, isTrue);
      expect(box.quotaBytes, 1073741824);
      expect(box.quotaUsedBytes, 600);
      expect(box.lastLoginAt?.toUtc(), DateTime.utc(2026, 10, 22, 9));
      expect(box.passwordChangeRequired, isTrue);
      expect(box.twoFactorRequired, isTrue);
      expect(box.lastPasswordChange?.toUtc(), DateTime.utc(2026, 10, 21, 9));
      expect(box.createdAt?.toUtc(), DateTime.utc(2026, 10, 20, 9));
      expect(box.updatedAt?.toUtc(), DateTime.utc(2026, 10, 22, 9));
      _domainFields(box.domain!);
      final usage = box.quotaUsage!;
      expect(usage.mailboxId, 9);
      expect(usage.subjectBytes, 100);
      expect(usage.bodyBytes, 200);
      expect(usage.attachmentBytes, 300);
      expect(usage.messageCount, 7);
      expect(usage.updatedAt?.toUtc(), DateTime.utc(2026, 10, 22, 9));
    },
  );

  test(
    'fresh alias GET reads its destination exactly and its domain',
    () async {
      final client = _client((r) async {
        expect(r.method, 'GET');
        expect(r.url.path, '/api/v1/admin/aliases/12');
        expect(r.body, isEmpty);
        return _json({'data': _alias});
      });
      addTearDown(client.close);
      final alias = await client.alias(12);
      expect(alias.id, 12);
      expect(alias.domainId, 4);
      expect(alias.source, 'sales@example.test');
      expect(alias.destination, 'CaseSensitive@Remote.test');
      expect(alias.active, isFalse);
      expect(alias.createdAt?.toUtc(), DateTime.utc(2026, 10, 20, 9));
      _domainFields(alias.domain!);
    },
  );

  test('older responses may omit optional detail metadata', () {
    final domain = AdminDomain.fromJson({'id': 4, 'name': 'example.test'});
    expect(domain.createdAt, isNull);
    expect(domain.updatedAt, isNull);
    final box = AdminMailbox.fromJson({'id': 9, 'address': 'ada@example.test'});
    expect(box.localPart, isEmpty);
    expect(box.domain, isNull);
    expect(box.quotaUsage, isNull);
    expect(box.passwordChangeRequired, isFalse);
    expect(box.twoFactorRequired, isFalse);
    expect(box.lastPasswordChange, isNull);
    expect(box.createdAt, isNull);
    expect(box.updatedAt, isNull);
    final alias = AdminAlias.fromJson({
      'id': 12,
      'source_address': 'a@example.test',
      'destination_address': 'B@c.test',
    });
    expect(alias.domain, isNull);
    expect(alias.createdAt, isNull);
  });

  test('alias create parses 201 and preserves destination spelling', () async {
    final client = _client((r) async {
      expect(r.method, 'POST');
      expect(r.url.path, '/api/v1/admin/aliases');
      expect(jsonDecode(r.body), {
        'source_address': 'sales@example.test',
        'destination_address': 'CaseSensitive@Remote.test',
      });
      return _json({'data': _alias}, status: 201);
    });
    addTearDown(client.close);
    final alias = await client.createAlias(
      source: 'sales@example.test',
      destination: 'CaseSensitive@Remote.test',
    );
    expect(alias.id, 12);
    expect(alias.destination, 'CaseSensitive@Remote.test');
  });

  test('core lists send all filters and pagination', () async {
    var calls = 0;
    final client = _client((r) async {
      calls++;
      expect(r.method, 'GET');
      expect(r.url.queryParameters, {
        'offset': '8',
        'limit': '2',
        if (!r.url.path.endsWith('/domains')) 'domain_id': '4',
      });
      final data = switch (r.url.path.split('/').last) {
        'domains' => _domain,
        'mailboxes' => _mailbox,
        _ => _alias,
      };
      return _json({
        'data': [data],
        'pagination': {'total': 20, 'has_more': true},
      });
    });
    addTearDown(client.close);
    final domains = await client.domains(offset: 8, limit: 2);
    final boxes = await client.mailboxes(domainId: 4, offset: 8, limit: 2);
    final aliases = await client.aliases(domainId: 4, offset: 8, limit: 2);
    for (final page in [domains, boxes, aliases]) {
      expect(page.offset, 8);
      expect(page.next, 9);
      expect(page.total, 20);
      expect(page.hasMore, isTrue);
    }
    expect(calls, 3);
  });

  for (final resource in ['domain', 'mailbox', 'alias']) {
    for (final status in [403, 404]) {
      test(
        '$resource $status never refreshes or discards the session',
        () async {
          var requests = 0;
          final client = _client((r) async {
            requests++;
            expect(r.url.path, isNot(contains('/auth/refresh')));
            return _json({
              'error': {
                'code': status == 403 ? 'forbidden' : 'not_found',
                'message': 'Unavailable',
              },
            }, status: status);
          });
          addTearDown(client.close);
          final before = client.tokens;
          final call = switch (resource) {
            'domain' => client.domain(4),
            'mailbox' => client.adminMailbox(9),
            _ => client.alias(12),
          };
          await expectLater(
            call,
            throwsA(
              isA<ApiException>().having((e) => e.statusCode, 'status', status),
            ),
          );
          expect(requests, 1);
          expect(client.tokens, same(before));
        },
      );
    }
  }
}
