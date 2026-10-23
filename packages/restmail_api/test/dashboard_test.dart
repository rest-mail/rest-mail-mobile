import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'fixtures/dashboard.dart';

void main() {
  RestmailClient client(MockClient transport) => RestmailClient(
    server: Uri.parse('https://mail.example.test'),
    tokens: SessionTokens(
      accessToken: 'dashboard-access',
      refreshToken: 'dashboard-refresh',
      accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    ),
    httpClient: transport,
  );

  test(
    'GET stats has no query/body and parses every DashboardStats field',
    () async {
      final api = client(
        MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/api/v1/admin/stats');
          expect(request.url.query, isEmpty);
          expect(request.body, isEmpty);
          expect(request.headers['authorization'], 'Bearer dashboard-access');
          return http.Response(jsonEncode({'data': dashboardFixture}), 200);
        }),
      );
      addTearDown(api.close);
      final stats = await api.stats();
      expect((stats.domains, stats.mailboxes), (7, 13));
      expect(
        (stats.queuePending, stats.queueProcessing, stats.queueFailed),
        (17, 3, 2),
      );
      expect(stats.volume, [
        (date: 'Oct 22', count: 91),
        (date: 'Oct 23', count: 42),
      ]);
      final activity = stats.recent.single;
      expect(activity.id, 'domain-31');
      expect(activity.type, 'domain_created');
      expect(
        activity.description,
        'Domain mail.for-a-long-organisation.example.test was created',
      );
      expect(activity.at!.toUtc(), DateTime.utc(2026, 10, 23, 4));
      expect(
        (stats.inboundMx, stats.inboundOverTls, stats.inboundPlaintext),
        (120, 101, 19),
      );
      expect(
        (stats.inboundTlsPercent, stats.inboundPlaintextPercent),
        (84.2, 15.8),
      );
      expect((stats.plaintextAuthPass, stats.plaintextAuthFail), (11, 8));
    },
  );

  test(
    'missing optional groups and old activity metadata have safe defaults',
    () {
      final stats = ServerStats.fromJson({
        'recentActivity': [
          {'description': 'Old event', 'timestamp': '2026-10-22T12:00:00Z'},
        ],
      });
      expect(
        (stats.domains, stats.mailboxes, stats.queueProcessing),
        (0, 0, 0),
      );
      expect(stats.volume, isEmpty);
      expect((stats.recent.single.id, stats.recent.single.type), ('', ''));
      expect(stats.recent.single.description, 'Old event');
      expect(
        (stats.inboundMx, stats.inboundOverTls, stats.inboundPlaintext),
        (0, 0, 0),
      );
      expect(
        (stats.inboundTlsPercent, stats.inboundPlaintextPercent),
        (0.0, 0.0),
      );
      expect((stats.plaintextAuthPass, stats.plaintextAuthFail), (0, 0));
    },
  );

  test('integer percentages and a zero denominator remain finite', () {
    final stats = ServerStats.fromJson({
      'inboundTransportSecurity': {
        'totalInboundMX': 0,
        'overTLS': 0,
        'plaintext': 0,
        'tlsPercent': 0,
        'plaintextPercent': 0,
        'plaintextAuthPass': 0,
        'plaintextAuthFail': 0,
      },
    });
    expect(stats.inboundTlsPercent, 0.0);
    expect(stats.inboundPlaintextPercent.isFinite, isTrue);
    expect(stats.recent, isEmpty);
  });

  test('activity keeps unknown types and handles absent timestamps', () {
    final item = DashboardActivity.fromJson({
      'id': 'future-1',
      'type': 'future_type',
      'description': 'Future event',
    });
    expect(item.id, 'future-1');
    expect(item.type, 'future_type');
    expect(item.at, isNull);
  });

  for (final status in [403, 500]) {
    test('$status preserves the session without a refresh', () async {
      var sent = 0;
      final api = client(
        MockClient((request) async {
          sent++;
          expect(request.url.path, '/api/v1/admin/stats');
          return http.Response(
            jsonEncode({
              'error': {
                'code': status == 403 ? 'forbidden' : 'internal_error',
                'message': 'Unavailable',
              },
            }),
            status,
          );
        }),
      );
      addTearDown(api.close);
      final before = api.tokens;
      await expectLater(
        api.stats(),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'status', status),
        ),
      );
      expect(sent, 1);
      expect(api.tokens, same(before));
    });
  }
}
