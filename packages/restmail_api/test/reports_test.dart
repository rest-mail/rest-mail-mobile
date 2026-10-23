import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

final _tokens = SessionTokens(
  accessToken: 'access',
  refreshToken: 'refresh',
  accessExpiresAt: DateTime.utc(2099),
);
final _start = DateTime.parse('2026-10-23T07:00:00+01:00');
final _end = DateTime.parse('2026-10-23T08:00:00+01:00');

RestmailClient _client(Future<http.Response> Function(http.Request) send) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      tokens: _tokens,
      httpClient: MockClient(send),
    );
http.Response _json(Object? data) => http.Response(
  jsonEncode({
    'data': data,
    'pagination': {
      'total': data is List ? data.length + 6 : 0,
      'has_more': true,
      'cursor': '42',
    },
  }),
  200,
  headers: {'content-type': 'application/json'},
);

void main() {
  test(
    'delivery sends all filters, preserves literal characters and offset',
    () async {
      final client = _client((r) async {
        expect(r.method, 'GET');
        expect(r.url.path, '/api/v1/admin/logs/delivery');
        expect(r.headers['authorization'], 'Bearer access');
        expect(r.url.queryParameters, {
          'status': 'expired',
          'domain': 'example.test',
          'sender': 'A+_%@example.test',
          'recipient': 'B+_%',
          'since': '2026-10-23T06:00:00.000Z',
          'until': '2026-10-23T07:00:00.000Z',
          'offset': '6',
          'limit': '17',
        });
        return _json([
          {
            'id': 12,
            'body_type': 'BINARYMIME',
            'failure_category': 'tls',
            'message_id': 4,
            'status': 'expired',
            'sender': 'a',
            'recipient': 'b',
            'domain': 'example.test',
            'last_error_code': 454,
            'last_error': 'TLS refused',
            'attempts': 3,
            'max_retries': 30,
            'created_at': '2026-10-23T06:00:00Z',
            'last_attempt': '2026-10-23T06:02:00Z',
            'next_attempt': '2026-10-23T06:05:00Z',
            'expires_at': '2026-10-24T06:00:00Z',
          },
        ]);
      });
      addTearDown(client.close);
      final page = await client.deliveryLog(
        status: QueueStatus.expired,
        domain: 'example.test',
        sender: 'A+_%@example.test',
        recipient: 'B+_%',
        since: _start,
        until: _end,
        offset: 6,
        limit: 17,
      );
      expect(page.offset, 6);
      expect(page.next, 7);
      expect(page.total, 7);
      final e = page.items.single;
      expect(e.bodyType, 'BINARYMIME');
      expect(e.failureCategory, 'tls');
      expect(e.messageId, 4);
      expect(e.status, QueueStatus.expired);
      expect(e.lastErrorCode, 454);
      expect(e.lastAttempt!.toUtc(), DateTime.utc(2026, 10, 23, 6, 2));
      expect(e.nextAttempt!.toUtc(), DateTime.utc(2026, 10, 23, 6, 5));
      expect(e.expiresAt!.toUtc(), DateTime.utc(2026, 10, 24, 6));
    },
  );

  test(
    'TLS list supports every query and preserves complete report metadata',
    () async {
      final client = _client((r) async {
        expect(r.url.path, '/api/v1/admin/tls-reports');
        expect(r.url.queryParameters, {
          'domain_id': '9',
          'policy_type': 'tlsa',
          'reporting_org': 'Acme+_%',
          'offset': '10',
          'limit': '20',
        });
        return _json([
          {
            'id': 7,
            'domain_id': 9,
            'reporting_org': 'Acme',
            'policy_type': 'tlsa',
            'policy_domain': 'example.test',
            'total_successful': 100,
            'total_failure': 2,
            'failure_details': {
              'unknown-format': ['kept', 2],
            },
            'raw_report': '{"original":true}',
            'created_at': '2026-10-23T06:01:00Z',
            'received_at': '2026-10-23T06:00:00Z',
            'start_date': '2026-10-22T00:00:00Z',
            'end_date': '2026-10-22T23:59:59Z',
            'domain': {
              'id': 9,
              'name': 'example.test',
              'server_type': 'restmail',
              'default_quota_bytes': 1000,
              'active': true,
              'sending_policy': 'bulk',
            },
          },
        ]);
      });
      addTearDown(client.close);
      final report = (await client.tlsReports(
        domainId: 9,
        policyType: 'tlsa',
        reportingOrg: 'Acme+_%',
        offset: 10,
        limit: 20,
      )).items.single;
      expect(report.createdAt!.toUtc(), DateTime.utc(2026, 10, 23, 6, 1));
      expect(report.rawReport, '{"original":true}');
      expect(report.failureDetails, {
        'unknown-format': ['kept', 2],
      });
      expect(report.domain!.sendingPolicy, 'bulk');
      expect(report.failed, 2);
    },
  );

  test(
    'pipeline list sends every filter and retains full trace and structured stages',
    () async {
      final client = _client((r) async {
        expect(r.url.path, '/api/v1/admin/pipelines/logs');
        expect(r.url.queryParameters, {
          'pipeline_id': '8',
          'direction': 'inbound',
          'action': 'defer',
          'outcome': 'deferred',
          'reason_code': 'greylist_defer',
          'rfc_message_id': '<a+b@remote.test>',
          'offset': '3',
          'limit': '15',
        });
        return _json([
          {
            'id': 42,
            'message_id': null,
            'pipeline_id': 8,
            'sampled': true,
            'expires_at': '2026-10-24T00:00:00Z',
            'duration_ms': 18,
            'final_action': 'defer',
            'stages': [
              {
                'filter_name': 'custom',
                'filter_type': 'action',
                'action': 'defer',
                'duration_ms': 18,
                'log': {
                  'result': {'nested': true},
                  'detail': [1, 2],
                  'extra': {'count': 1.25},
                },
              },
            ],
          },
        ]);
      });
      addTearDown(client.close);
      final trace = (await client.pipelineLog(
        pipelineId: 8,
        direction: 'inbound',
        action: 'defer',
        outcome: 'deferred',
        reasonCode: 'greylist_defer',
        rfcMessageId: '<a+b@remote.test>',
        offset: 3,
        limit: 15,
      )).items.single;
      expect(trace.pipelineId, 8);
      expect(trace.sampled, isTrue);
      expect(trace.messageId, isNull);
      expect(trace.expiresAt!.toUtc(), DateTime.utc(2026, 10, 24));
      expect(trace.durationMs, 18);
      final step = trace.stages.single;
      expect(step.durationMs, 18);
      expect(step.filterType, 'action');
      expect(step.log['extra'], {'count': 1.25});
      expect(step.result, '{"nested":true}');
      expect(step.detail, '[1,2]');
    },
  );

  test(
    'audit sends all filters and cursor, parses credential attribution',
    () async {
      final client = _client((r) async {
        expect(r.url.path, '/api/v1/admin/audit');
        expect(r.url.queryParameters, {
          'before_seq': '75',
          'actor_kind': 'account',
          'actor_id': '7',
          'actor': 'bot+_%',
          'action': 'admin.change',
          'outcome': 'denied',
          'since': '2026-10-23T06:00:00.000Z',
          'until': '2026-10-23T07:00:00.000Z',
          'limit': '23',
        });
        return _json([
          {
            'seq': 42,
            'credential_id': 12,
            'actor_id': 7,
            'session_id': 'session',
            'request_id': 'request',
            'target': {'id': '9'},
          },
        ]);
      });
      addTearDown(client.close);
      final page = await client.audit(
        before: '75',
        actorKind: 'account',
        actorId: 7,
        actor: 'bot+_%',
        action: 'admin.change',
        outcome: 'denied',
        since: _start,
        until: _end,
        limit: 23,
      );
      expect(page.cursor, '42');
      expect(page.hasMore, isTrue);
      expect(page.items.single.credentialId, 12);
      expect(page.items.single.target, {'id': '9'});
    },
  );

  test(
    'anchored verification preserves supplied external proof and parses echoed anchor',
    () async {
      final hash = List.filled(64, 'A').join();
      final client = _client((r) async {
        expect(r.url.path, '/api/v1/admin/audit/verify');
        expect(r.url.queryParameters, {'anchor': '42:$hash'});
        return _json({
          'ok': false,
          'checked': 41,
          'first_seq': 1,
          'last_seq': 41,
          'broken_at_seq': 42,
          'reason': 'hash does not match the anchor',
          'last_hash': 'last',
          'anchor': {'seq': 42, 'hash': hash.toLowerCase()},
        });
      });
      addTearDown(client.close);
      final result = await client.verifyAudit(anchor: '42:$hash');
      expect(result.ok, isFalse);
      expect(result.anchor!.value, '42:${hash.toLowerCase()}');
      expect(result.brokenAtSeq, 42);
      expect(result.lastHash, 'last');
    },
  );

  group('analytics windows', () {
    for (final (duration, expected) in [
      (const Duration(days: 1), '24h'),
      (const Duration(minutes: 90), '5400000000us'),
      (const Duration(microseconds: 125), '125us'),
    ]) {
      test('Duration $duration is not truncated', () async {
        final client = _client((r) async {
          expect(r.url.queryParameters, {'window': expected});
          return _json({});
        });
        addTearDown(client.close);
        await client.pipelineAnalytics(window: duration);
      });
    }
    test('raw Go duration is preserved', () async {
      final client = _client((r) async {
        expect(r.url.queryParameters, {'window': '1h30m0.5s'});
        return _json({});
      });
      addTearDown(client.close);
      await client.pipelineAnalytics(windowText: '1h30m0.5s');
    });
    test('explicit start takes precedence and is sent in UTC', () async {
      final client = _client((r) async {
        expect(r.url.queryParameters, {'since': '2026-10-23T06:00:00.000Z'});
        return _json({});
      });
      addTearDown(client.close);
      await client.pipelineAnalytics(since: _start, windowText: '1h30m');
    });
  });

  test(
    'analytics retains fractional rollups, label and independent cumulative counters',
    () {
      final result = PipelineAnalytics.fromJson({
        'window': {
          'label': '90m',
          'since': '2026-10-23T06:00:00Z',
          'until': '2026-10-23T07:30:00Z',
        },
        'funnel': {
          'received': [
            {'transport': 'tls', 'count': 1.125},
          ],
          'auth_verdicts': [
            {'mechanism': 'spf', 'result': 'pass', 'count': 2.25},
          ],
          'stage_decisions': [
            {'filter': 'a', 'action': 'continue', 'count': 3.5},
          ],
          'terminal_outcomes': [
            {'direction': 'inbound', 'outcome': 'delivered', 'count': 4.75},
          ],
          'top_reject_reasons': [
            {'reason_code': 'other', 'count': 5.875},
          ],
        },
        'live_totals': {
          'received': [
            {'transport': 'tls', 'count': 123.25},
          ],
          'auth_verdicts': null,
        },
      });
      expect(result.windowLabel, '90m');
      expect(result.received.single.count, 1.125);
      expect(result.senderChecks.single.count, 2.25);
      expect(result.decisions.single.count, 3.5);
      expect(result.outcomes.single.count, 4.75);
      expect(result.rejectReasons.single.count, 5.875);
      expect(result.liveTotals!.received.single.count, 123.25);
      expect(result.liveTotals!.senderChecks, isEmpty);
      expect(PipelineAnalytics.fromJson({}).liveTotals, isNull);
    },
  );

  test('omitted filters are absent, including unanchored proof', () async {
    final client = _client((r) async {
      expect(
        r.url.queryParameters.keys,
        everyElement(isIn(['limit', 'offset'])),
      );
      return _json(r.url.path.endsWith('verify') ? <String, Object?>{} : []);
    });
    addTearDown(client.close);
    await client.deliveryLog();
    await client.pipelineLog();
    await client.tlsReports();
    await client.audit();
    await client.verifyAudit();
  });

  for (final path in [
    'delivery',
    'pipeline',
    'tls',
    'audit',
    'verify',
    'analytics',
  ]) {
    test('$path 403 keeps session and makes no refresh request', () async {
      var sent = 0;
      final client = _client((r) async {
        sent++;
        expect(r.url.path, isNot(contains('/auth/refresh')));
        return http.Response(
          '{"error":{"code":"forbidden","message":"No permission"}}',
          403,
        );
      });
      addTearDown(client.close);
      final Future<Object?> request = switch (path) {
        'delivery' => client.deliveryLog(),
        'pipeline' => client.pipelineLog(),
        'tls' => client.tlsReports(),
        'audit' => client.audit(),
        'verify' => client.verifyAudit(),
        _ => client.pipelineAnalytics(),
      };
      await expectLater(
        request,
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(sent, 1);
      expect(client.tokens, same(_tokens));
    });
  }

  test(
    'anchor field validation and throttling preserve actionable errors',
    () async {
      var sent = 0;
      final client = _client(
        (r) async => ++sent == 1
            ? http.Response(
                jsonEncode({
                  'error': {
                    'code': 'validation_failed',
                    'message': 'Bad anchor',
                    'details': {
                      'fields': {'anchor': 'invalid'},
                    },
                  },
                }),
                422,
              )
            : http.Response(
                '{"error":{"code":"rate_limited","message":"Wait"}}',
                429,
                headers: {'retry-after': '37'},
              ),
      );
      addTearDown(client.close);
      await expectLater(
        client.verifyAudit(anchor: 'bad'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields['anchor'],
            'anchor',
            'invalid',
          ),
        ),
      );
      await expectLater(
        client.audit(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.retryAfter,
            'retry',
            const Duration(seconds: 37),
          ),
        ),
      );
      expect(client.tokens, same(_tokens));
    },
  );
}
