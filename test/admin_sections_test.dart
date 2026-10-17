import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

/// The logs and reports, the audit log, keys and certificates, and
/// pipelines in Administration: what each shows, what each capability
/// allows of it, and that the fake refuses the rest.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester, {
    String username = FakeAccounts.adminUsername,
    Set<String>? capabilities,
    Capabilities? modified,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    if (capabilities != null) {
      fake.addAdmin(username, capabilities: capabilities);
    }
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signInAdmin(
      server: _server,
      username: username,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    // A modified app, which believes it may do more than it was given.
    if (modified != null) {
      (state.current! as RestAccount).capabilities = modified;
    }
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  /// Scrolls the screen's list to [text], below or above, built or not yet.
  Future<void> reveal(WidgetTester tester, String text) async {
    final target = find.text(text);
    for (final step in const [-300.0, 300.0]) {
      for (var i = 0; i < 20 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, step));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(target.first);
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await reveal(tester, text);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Back').last);
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

  const sections = [
    'Outbound queue',
    'Domains',
    'Mailboxes',
    'Aliases',
    'Administrators',
    'Bans',
    'Overview',
    'Delivery log',
    'Activity',
    'Message trace',
    'TLS reports',
    'Audit log',
    'DKIM keys',
    'Certificates',
    'Pipelines',
    'Custom filters',
  ];

  /// Which sections Administration shows, scrolling through all of it.
  Future<List<String>> shown(WidgetTester tester) async {
    final seen = <String>{};
    for (var i = 0; i < 8; i++) {
      seen.addAll(sections.where((s) => find.text(s).evaluate().isNotEmpty));
      await tester.drag(find.byType(ListView).last, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    await tester.drag(find.byType(ListView).last, const Offset(0, 3000));
    await tester.pumpAndSettle();
    return [
      for (final section in sections)
        if (seen.contains(section)) section,
    ];
  }

  testWidgets('a superadmin sees every section, under its heading', (
    tester,
  ) async {
    final (fake, state) = await open(tester);

    expect(await shown(tester), sections);
    await reveal(tester, 'SIGNING AND FILTERING');
    expect(find.text('LOGS AND REPORTS'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('the delivery log shows how each message went, and opens its '
      'trace', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Delivery log');
    expect(find.text('lee@harbor.test'), findsOneWidget);
    await tap(tester, 'Bounced');
    expect(find.text('lee@harbor.test'), findsNothing);
    await tap(tester, 'nobody@ryeworks.test');
    expect(find.text('550 5.1.1 No such user here'), findsOneWidget);

    await tap(tester, 'Trace');
    expect(find.text('Going out'), findsOneWidget);
    expect(find.text('Sent on its way'), findsOneWidget);
    for (final filter in ['sender_verify', 'header_cleanup', 'dkim_sign']) {
      expect(find.text(filter), findsOneWidget, reason: filter);
    }

    await close(tester, fake, state);
  });

  testWidgets('a trace found by its message number, and one that is not '
      'there', (tester) async {
    final (fake, state) = await open(tester);
    final inbox = fake.messagesIn(FakeAccounts.email, 'INBOX')
      ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

    await tap(tester, 'Message trace');
    await tester.enterText(find.byType(TextField), '${inbox.first.id}');
    await tester.pump();
    await tap(tester, 'Show trace');
    expect(find.text('Coming in'), findsOneWidget);
    expect(find.text('TLS'), findsOneWidget);
    expect(find.text('rspamd'), findsOneWidget);
    await back(tester);

    await tester.enterText(find.byType(TextField), '999999');
    await tester.pump();
    await tap(tester, 'Show trace');
    expect(
      find.textContaining('There is no trace for message 999999'),
      findsOneWidget,
    );

    await close(tester, fake, state);
  });

  testWidgets('activity and TLS reports', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Activity');
    expect(find.text('Banned 203.0.113.7'), findsOneWidget);
    await back(tester);

    await tap(tester, 'TLS reports');
    expect(find.text('Google Inc.'), findsOneWidget);
    expect(find.textContaining('3 failed'), findsOneWidget);
    await tap(tester, 'Microsoft Corporation');
    expect(find.text('WHAT FAILED'), findsOneWidget);
    expect(find.textContaining('certificate-expired'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('the audit log reads newest first, pages, filters, and '
      'verifies its chain', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Audit log');
    // The sign-in that opened this session is the newest entry.
    expect(find.textContaining('auth.sign_in · Allowed').first, findsOneWidget);
    final before = find.byType(RmRow).evaluate().length;
    await tap(tester, 'Load more');
    expect(find.text('Load more'), findsNothing);
    expect(find.byType(RmRow).evaluate().length, greaterThan(before));

    await tap(tester, 'Denied');
    expect(find.textContaining('· Allowed ·'), findsNothing);
    expect(find.textContaining('· Denied ·'), findsWidgets);
    await tap(tester, 'All');

    await tap(tester, 'Verify chain');
    expect(find.textContaining('The chain holds'), findsOneWidget);

    fake.tamperWithAudit(12);
    await tap(tester, 'Verify chain');
    expect(find.textContaining('The chain breaks at entry 12'), findsOneWidget);
    expect(
      find.textContaining('The 11 entries before it hold'),
      findsOneWidget,
    );

    await tap(tester, FakeAccounts.adminUsername);
    expect(find.text('ITS HASH, AND THE ONE BEFORE'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('a DKIM key and a certificate removed', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'DKIM keys');
    expect(find.text('mail._domainkey.${FakeAccounts.host}'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove the key for ${FakeAccounts.host}'));
    await tester.pumpAndSettle();
    await tap(tester, 'Remove key');
    expect(
      fake.domains.firstWhere((d) => d.name == FakeAccounts.host).signs,
      isFalse,
    );
    expect(find.text('mail._domainkey.${FakeAccounts.host}'), findsNothing);
    await back(tester);

    await tap(tester, 'Certificates');
    final count = fake.certificates.length;
    await tester.tap(
      find.byTooltip('Delete the certificate for ${FakeAccounts.host}'),
    );
    await tester.pumpAndSettle();
    await tap(tester, 'Delete');
    expect(fake.certificates, hasLength(count - 1));

    await close(tester, fake, state);
  });

  testWidgets('a pipeline and a custom filter turned off, and deleted', (
    tester,
  ) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Pipelines');
    await tap(tester, 'Coming in · 7 filters');
    expect(find.text('greylist'), findsOneWidget);
    await tester.tap(find.byType(RmSwitch));
    await tester.pumpAndSettle();
    expect(fake.pipelines.first.active, isFalse);
    await tap(tester, 'Delete pipeline');
    await tap(tester, 'Delete');
    expect(find.text('Deleted the pipeline'), findsOneWidget);
    expect(fake.pipelines, hasLength(1));
    await back(tester);

    await tap(tester, 'Custom filters');
    await tap(tester, 'Hold invoices from strangers');
    expect(find.text('WHAT IT DOES'), findsOneWidget);
    await tester.tap(find.byType(RmSwitch));
    await tester.pumpAndSettle();
    expect(fake.customFilters.single.enabled, isFalse);
    await tap(tester, 'Delete filter');
    await tap(tester, 'Delete');
    expect(fake.customFilters, isEmpty);

    await close(tester, fake, state);
  });

  testWidgets('with messages:read alone, the delivery log and no way into '
      'traces', (tester) async {
    final (fake, state) = await open(
      tester,
      username: 'postmaster',
      capabilities: {Capability.messagesRead},
    );

    expect(await shown(tester), ['Delivery log']);
    await tap(tester, 'Delivery log');
    await tap(tester, 'tom@ryeworks.test');
    expect(find.text('Trace'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('with domains:read alone, keys and certificates to look at, '
      'and nothing to remove', (tester) async {
    final (fake, state) = await open(
      tester,
      username: 'viewer',
      capabilities: {Capability.domainsRead},
    );

    expect(await shown(tester), [
      'Domains',
      'TLS reports',
      'DKIM keys',
      'Certificates',
    ]);
    await tap(tester, 'DKIM keys');
    expect(find.text('mail._domainkey.${FakeAccounts.host}'), findsOneWidget);
    expect(find.byType(RmIconButton), findsNWidgets(1)); // Back only.
    await back(tester);
    await tap(tester, 'Certificates');
    expect(find.textContaining('Runs out'), findsWidgets);
    expect(find.byType(RmIconButton), findsNWidgets(1));

    await close(tester, fake, state);
  });

  testWidgets('with pipelines:read alone, pipelines to look at, and no '
      'switch or delete', (tester) async {
    final (fake, state) = await open(
      tester,
      username: 'reader',
      capabilities: {Capability.pipelinesRead},
    );

    expect(await shown(tester), ['Pipelines', 'Custom filters']);
    await tap(tester, 'Pipelines');
    await tap(tester, 'Going out · 3 filters');
    expect(find.text('dkim_sign'), findsOneWidget);
    expect(find.byType(RmSwitch), findsNothing);
    expect(find.text('Delete pipeline'), findsNothing);
    // With no domains:read, the domain goes by its number.
    expect(find.textContaining('Domain '), findsWidgets);
    await back(tester);
    await back(tester);
    await tap(tester, 'Custom filters');
    await tap(tester, 'Hold invoices from strangers');
    expect(find.byType(RmSwitch), findsNothing);
    expect(find.text('Delete filter'), findsNothing);

    await close(tester, fake, state);
  });

  const readonly = {
    Capability.domainsRead,
    Capability.mailboxesRead,
    Capability.usersRead,
    Capability.queueRead,
    Capability.bansRead,
    Capability.pipelinesRead,
    Capability.messagesRead,
    Capability.observabilityRead,
  };

  testWidgets('audit:read alone shows the audit log, and the readonly role, '
      'which lacks it, sees everything else', (tester) async {
    final (fake, state) = await open(
      tester,
      username: 'auditor',
      capabilities: {Capability.auditRead},
    );
    expect(await shown(tester), ['Audit log']);
    await close(tester, fake, state);

    final (fake2, state2) = await open(
      tester,
      username: 'reader',
      capabilities: readonly,
    );
    expect(await shown(tester), [
      for (final section in sections)
        if (section != 'Audit log') section,
    ]);
    await close(tester, fake2, state2);
  });

  testWidgets('an app that shows the audit log without audit:read is '
      'refused by the server, and says only that', (tester) async {
    final (fake, state) = await open(
      tester,
      username: 'reader',
      capabilities: readonly,
      modified: const Capabilities({'*'}),
    );
    final recorded = fake.auditLog.length;

    await tap(tester, 'Audit log');
    expect(find.text(noPermission), findsOneWidget);
    expect(find.textContaining('auth.sign_in'), findsNothing);
    await tap(tester, 'Verify chain');
    expect(find.text(noPermission), findsNWidgets(2));
    expect(find.textContaining('The chain holds'), findsNothing);
    // The server recorded both refusals.
    expect(fake.auditLog.skip(recorded).map((e) => (e.action, e.outcome)), [
      ('audit.read', 'denied'),
      ('audit.read', 'denied'),
    ]);

    await close(tester, fake, state);
  });
}
