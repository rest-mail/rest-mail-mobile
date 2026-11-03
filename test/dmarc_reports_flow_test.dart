import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/l10n/catalog.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

/// Lets a test break the DMARC routes while the rest of the fake keeps
/// answering, and counts what reached them.
class _Reports extends http.BaseClient {
  _Reports(this.inner);

  final http.Client inner;
  int? listFailure;
  int? detailFailure;
  final asked = <Uri>[];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.contains('/admin/dmarc-reports')) {
      asked.add(request.url);
      final detail = !request.url.path.endsWith('/dmarc-reports');
      final failure = detail ? detailFailure : listFailure;
      if (failure != null) {
        return http.StreamedResponse(
          Stream.value(
            utf8.encode(
              jsonEncode({
                'error': {
                  'code': failure == 404
                      ? 'dmarc_report_not_found'
                      : 'internal_error',
                  'message': failure == 404
                      ? 'DMARC report not found'
                      : 'Internal server error',
                },
              }),
            ),
          ),
          failure,
          headers: {'content-type': 'application/json'},
        );
      }
    }
    return inner.send(request);
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  /// Signs in and opens Administration from the drawer.
  Future<(FakeRestmail, AppState, _Reports)> open(
    WidgetTester tester, {
    FakeScenario scenario = FakeScenario.sample,
    String? name,
    Set<String>? capabilities,
    Capabilities? modified,
    String? grantScope,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: scenario);
    final email = name == null
        ? FakeAccounts.adminEmail
        : '$name@${FakeAccounts.host}';
    if (capabilities != null) {
      fake.addAccount(email, capabilities: capabilities);
    }
    if (grantScope != null) {
      fake.addAccount(email);
      final admin = RestmailClient(server: _server, httpClient: fake.client);
      await admin.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      final holder = (await admin.mailboxes(limit: 200)).items
          .firstWhere((mailbox) => mailbox.address == email);
      await admin.createGrant(
        holder: GrantHolder.account(holder.id),
        role: 'admin',
        scope: grantScope,
      );
      admin.close();
    }
    late _Reports reports;
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => reports = _Reports(fake.client),
    );
    await state.start();
    await state.signIn(
      server: _server,
      email: email,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    if (modified != null) {
      (state.current! as RestAccount).capabilities = modified;
    }
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Administration'));
    await tester.pumpAndSettle();
    return (fake, state, reports);
  }

  Future<void> reveal(WidgetTester tester, String text) async {
    final target = find.text(text);
    for (final step in const [-300.0, 300.0]) {
      for (var i = 0; i < 20 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, step));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(target.first);
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await reveal(tester, text);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
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

  testWidgets('an administrator reads the list beside TLS reports', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    await reveal(tester, 'TLS reports');
    expect(find.text('DMARC reports'), findsOneWidget);
    expect(
      find.text('What other servers report about mail from your domains'),
      findsOneWidget,
    );

    await tap(tester, 'DMARC reports');
    expect(find.text('Google Inc.'), findsOneWidget);
    expect(find.text('Microsoft Corporation'), findsOneWidget);
    expect(find.textContaining('214 passed, 0 failed'), findsOneWidget);
    expect(find.textContaining('96 passed, 3 failed'), findsOneWidget);
    expect(find.textContaining(FakeAccounts.host), findsWidgets);
    await close(tester, fake, state);
  });

  testWidgets('filters reach the server, and clear to everything again', (
    tester,
  ) async {
    final (fake, state, reports) = await open(tester);
    await tap(tester, 'DMARC reports');
    await tap(tester, 'Filters');
    await tester.enterText(find.byType(TextField).at(1), 'GOOGLE');
    await tap(tester, 'Apply filters');
    expect(reports.asked.last.queryParameters['reporter'], 'GOOGLE');
    expect(find.text('Google Inc.'), findsOneWidget);
    expect(find.text('Microsoft Corporation'), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('nothing received reads as empty', (tester) async {
    final (fake, state, _) = await open(tester, scenario: FakeScenario.empty);
    await tap(tester, 'DMARC reports');
    expect(find.text('No reports match.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('a filter nothing matches reads as empty', (tester) async {
    final (fake, state, _) = await open(tester);
    await tap(tester, 'DMARC reports');
    await tap(tester, 'Filters');
    await tester.enterText(find.byType(TextField).at(1), 'nobody.invalid');
    await tap(tester, 'Apply filters');
    expect(find.text('No reports match.'), findsOneWidget);
    expect(find.text('Google Inc.'), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('a failed list says so and tries again', (tester) async {
    final (fake, state, reports) = await open(tester);
    reports.listFailure = 500;
    await tap(tester, 'DMARC reports');
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Google Inc.'), findsNothing);

    reports.listFailure = null;
    await tap(tester, 'Try again');
    expect(find.text('Try again'), findsNothing);
    expect(find.text('Google Inc.'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('the detail shows what an operator needs of each source', (
    tester,
  ) async {
    final (fake, state, reports) = await open(tester);
    await tap(tester, 'DMARC reports');
    await tap(tester, 'Microsoft Corporation');
    expect(reports.asked.last.path, matches(RegExp(r'/dmarc-reports/\d+$')));

    expect(find.text('Reporting organisation'), findsOneWidget);
    expect(find.text('Microsoft Corporation'), findsWidgets);
    expect(find.text(FakeAccounts.host), findsWidgets);
    expect(find.text('Covers'), findsOneWidget);
    expect(find.text('96 passed, 3 failed'), findsOneWidget);

    expect(find.text('192.0.2.10'), findsOneWidget);
    expect(find.text('96'), findsOneWidget);
    expect(find.text('No action'), findsOneWidget);
    await reveal(tester, '198.51.100.7');
    expect(find.text('3'), findsOneWidget);
    await reveal(tester, 'Quarantined');
    expect(find.text('Quarantined'), findsOneWidget);
    await reveal(tester, 'Reason');
    expect(find.text('other'), findsOneWidget);
    expect(find.text('Sent through a mailing list'), findsOneWidget);
    await reveal(tester, 'lists.example.net');
    await reveal(tester, 'neutral');
    expect(find.text('neutral'), findsOneWidget);

    await reveal(tester, 'POLICY PUBLISHED');
    await reveal(tester, 'quarantine');
    expect(find.text('quarantine'), findsOneWidget);
    await reveal(tester, 'Report ID');
    expect(find.text('Reporter domain'), findsOneWidget);
    expect(find.text('enterprise.protection.outlook.com'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('a failed detail shows no rows and tries again', (tester) async {
    final (fake, state, reports) = await open(tester);
    await tap(tester, 'DMARC reports');
    reports.detailFailure = 404;
    await tap(tester, 'Google Inc.');
    expect(find.text('DMARC report not found'), findsOneWidget);
    expect(find.text('Reporting organisation'), findsNothing);
    expect(find.text('Try again'), findsOneWidget);

    reports.detailFailure = null;
    await tap(tester, 'Try again');
    expect(find.text('Reporting organisation'), findsOneWidget);
    expect(find.text('192.0.2.10'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('the section follows domains:read', (tester) async {
    final (fake, state, _) = await open(
      tester,
      name: 'viewer',
      capabilities: {Capability.domainsRead},
    );
    await tap(tester, 'DMARC reports');
    expect(find.text('Google Inc.'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('a domain administrator gets their own domain\'s reports', (
    tester,
  ) async {
    final (fake, state, _) = await open(
      tester,
      name: 'scoped',
      grantScope: 'domain:${FakeAccounts.host}',
    );
    expect(find.text('TLS reports'), findsNothing);
    await tap(tester, 'DMARC reports');
    expect(find.text('Google Inc.'), findsOneWidget);
    expect(find.text('Microsoft Corporation'), findsOneWidget);
    expect(find.text('Mail.Ru'), findsNothing);
    await tap(tester, 'Google Inc.');
    expect(find.text('192.0.2.10'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('without domains:read the section is not there', (tester) async {
    final (fake, state, _) = await open(
      tester,
      name: 'watcher',
      capabilities: {Capability.queueRead},
    );
    for (var i = 0; i < 8; i++) {
      await tester.drag(find.byType(ListView).last, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    expect(find.text('DMARC reports'), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('a modified app gets the server\'s refusal, and no reports', (
    tester,
  ) async {
    final (fake, state, _) = await open(
      tester,
      name: 'watcher',
      capabilities: {Capability.queueRead},
      modified: Capabilities.fromJson([
        Capability.queueRead,
        Capability.domainsRead,
      ]),
    );
    await tap(tester, 'DMARC reports');
    expect(
      find.text(
        languageLine('en', 'admin.adminwidgets.youDonTHavePermissionForThis'),
      ),
      findsOneWidget,
    );
    expect(find.text('Google Inc.'), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('the section speaks the language it is set to', (tester) async {
    expect(
      languageLine('de', 'admin.section.dmarcReports.title'),
      'DMARC-Berichte',
    );
    expect(
      languageLine('fa', 'admin.section.dmarcReports.title'),
      'گزارش‌های DMARC',
    );
    expect(
      languageLine(
        'es',
        'admin.dmarcreports.summary',
        args: {'passed': '1', 'failed': '2'},
      ),
      '1 aprobados, 2 fallidos',
    );
  });
}
