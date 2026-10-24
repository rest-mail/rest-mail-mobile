import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/state/app_scope.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
import 'package:restmail/ui/admin/overview_screen.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

import '../packages/restmail_api/test/fixtures/dashboard.dart';

class _DashboardTransport extends http.BaseClient {
  _DashboardTransport(this.inner);

  final http.Client inner;
  Map<String, Object?> data = dashboardFixture;
  var refuse = false;
  var reads = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await inner.send(request);
    if (!request.url.path.endsWith('/admin/stats')) return response;
    reads++;
    // Retain the fake's real authentication/permission checks.
    if (response.statusCode != 200) return response;
    await response.stream.drain<void>();
    return http.StreamedResponse(
      Stream.value(
        utf8.encode(
          jsonEncode(
            refuse
                ? {
                    'error': {
                      'code': 'forbidden',
                      'message': 'Insufficient permissions',
                    },
                  }
                : {'data': data},
          ),
        ),
      ),
      refuse ? 403 : 200,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  Future<(FakeRestmail, AppState, _DashboardTransport)> open(
    WidgetTester tester, {
    double width = 390,
    double scale = 1,
    bool allowed = true,
  }) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail()
      ..addAccount(
        'dashboard@${FakeAccounts.host}',
        capabilities: {if (allowed) Capability.domainsRead},
      );
    final transport = _DashboardTransport(fake.client);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => transport,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: 'dashboard@${FakeAccounts.host}',
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: ThemeData(extensions: const [RmColors.light]),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: OverviewScreen(account: state.current! as RestAccount),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (fake, state, transport);
  }

  Future<void> close(
    WidgetTester tester,
    FakeRestmail fake,
    AppState state,
  ) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> reveal(WidgetTester tester, String text) async {
    final target = find.text(text);
    for (var i = 0; i < 30 && target.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(ListView).last, const Offset(0, -250));
      await tester.pumpAndSettle();
    }
    expect(target, findsWidgets);
    await tester.ensureVisible(target.first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  for (final (width, scale) in [(320.0, 1.6), (1024.0, 1.0)]) {
    testWidgets(
      'Overview keeps full records readable at width $width and scale $scale',
      (tester) async {
        final (fake, state, transport) = await open(
          tester,
          width: width,
          scale: scale,
        );
        expect(transport.reads, 1);
        await reveal(tester, 'Being delivered');
        expect(find.text('3'), findsOneWidget);
        await reveal(tester, '84.2% of inbound deliveries');
        await reveal(tester, '15.8% of inbound deliveries');
        await reveal(tester, 'Unencrypted, sender authentication passed');
        expect(find.text('11'), findsOneWidget);
        await reveal(tester, 'Unencrypted, no passing sender authentication');
        expect(find.text('8'), findsOneWidget);
        await reveal(
          tester,
          'Domain mail.for-a-long-organisation.example.test was created',
        );
        await reveal(tester, 'Event type: domain_created');
        await reveal(tester, 'ID: domain-31');
        expect(tester.takeException(), isNull);
        await close(tester, fake, state);
      },
    );
  }

  testWidgets(
    'Overview refreshes, hides stale data on refusal and retries without losing login',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      transport.data = {...dashboardFixture, 'domainCount': 22};
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pumpAndSettle();
      expect(find.text('22'), findsOneWidget);
      transport.refuse = true;
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pumpAndSettle();
      expect(find.text("You don't have permission for this"), findsOneWidget);
      expect(find.text('22'), findsNothing);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      transport.refuse = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('22'), findsOneWidget);
      expect(transport.reads, 4);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'Overview requires global domains:read and sends no unauthorized request',
    (tester) async {
      final (fake, state, transport) = await open(tester, allowed: false);
      expect(find.text("You don't have permission for this"), findsOneWidget);
      expect(transport.reads, 0);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'zero inbound deliveries show an explanation without dividing by zero',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      transport.data = {
        ...dashboardFixture,
        'inboundTransportSecurity': {
          'totalInboundMX': 0,
          'overTLS': 0,
          'plaintext': 0,
          'tlsPercent': 0,
          'plaintextPercent': 0,
          'plaintextAuthPass': 0,
          'plaintextAuthFail': 0,
        },
      };
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pumpAndSettle();
      await reveal(tester, 'No inbound MX deliveries have been recorded yet.');
      await reveal(tester, 'Encrypted with TLS');
      expect(find.text('NaN'), findsNothing);
      expect(find.textContaining('Infinity'), findsNothing);
      await close(tester, fake, state);
    },
  );
}
