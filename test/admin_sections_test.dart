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

/// The logs and reports, the audit log, keys and certificates, pipelines,
/// and each domain's DNS check, sender lists and MTA-STS policy in
/// Administration: what each shows, what each capability allows
/// of it, and that the fake refuses the rest.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  /// Signs in as the administrator, or as [name] at the fake's domain
  /// holding [capabilities], and opens Administration from the drawer.
  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester, {
    String? name,
    Set<String>? capabilities,
    Capabilities? modified,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final email = name == null
        ? FakeAccounts.adminEmail
        : '$name@${FakeAccounts.host}';
    if (capabilities != null) {
      fake.addAccount(email, capabilities: capabilities);
    }
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: _server,
      email: email,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    // A modified app, which believes it may do more than it was given.
    if (modified != null) {
      (state.current! as RestAccount).capabilities = modified;
    }
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Folders and accounts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Administration'));
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
    'Bans',
    'Overview',
    'Delivery log',
    'Activity',
    'Message trace',
    'Pipeline log',
    'Pipeline analytics',
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
    await reveal(tester, 'LOGS AND REPORTS');
    await reveal(tester, 'SIGNING AND FILTERING');

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

  testWidgets('activity, from the audit log, and TLS reports', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Activity');
    // What went through, newest first: this session's sign-in on top, and
    // nothing refused.
    expect(
      find.textContaining('By ${FakeAccounts.adminEmail}').first,
      findsOneWidget,
    );
    expect(find.text('auth.sign_in'), findsWidgets);
    expect(find.textContaining('root@'), findsNothing);
    await tester.tap(find.text('auth.sign_in').first);
    await tester.pumpAndSettle();
    expect(find.text('ITS HASH, AND THE ONE BEFORE'), findsOneWidget);
    expect(find.text('Allowed · 200'), findsOneWidget);
    await back(tester);
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

    await tap(tester, FakeAccounts.adminEmail);
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
      name: 'postmaster',
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
      name: 'viewer',
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
      name: 'reader',
      capabilities: {Capability.pipelinesRead},
    );

    expect(await shown(tester), [
      'Pipeline log',
      'Pipelines',
      'Custom filters',
    ]);
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

  testWidgets('audit:read alone shows the audit log and the activity read '
      'from it, and the readonly role, which lacks it, sees everything else', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      name: 'auditor',
      capabilities: {Capability.auditRead},
    );
    expect(await shown(tester), ['Activity', 'Audit log']);
    await close(tester, fake, state);

    final (fake2, state2) = await open(
      tester,
      name: 'reader',
      capabilities: readonly,
    );
    expect(await shown(tester), [
      for (final section in sections)
        if (section != 'Audit log' && section != 'Activity') section,
    ]);
    await close(tester, fake2, state2);
  });

  testWidgets('an app that shows the audit log without audit:read is '
      'refused by the server, and says only that', (tester) async {
    final (fake, state) = await open(
      tester,
      name: 'reader',
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

  testWidgets('the pipeline log shows mail turned away, and opens its '
      'trace', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Pipeline log');
    expect(find.text('lee@harbor.test'), findsOneWidget);
    await tap(tester, 'Turned away');
    expect(find.text('lee@harbor.test'), findsNothing);
    expect(find.textContaining('Scored as spam'), findsOneWidget);
    // Mail turned away never became a message; its trace is in the log.
    await tap(tester, 'promo@deals.test');
    expect(find.text('Trace'), findsOneWidget);
    // How it ended, and what rspamd did.
    expect(find.text('Turned away'), findsNWidgets(2));
    expect(find.text('Scored as spam'), findsOneWidget);
    expect(find.text('rspamd'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('pipeline analytics for a day, and for a week', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Pipeline analytics');
    expect(find.text('HOW IT ENDED'), findsOneWidget);
    expect(find.text('Scored as spam'), findsOneWidget);
    expect(find.text('Failed DMARC'), findsNothing);
    await tap(tester, 'A week');
    expect(find.text('Scored as spam'), findsOneWidget);
    await reveal(tester, 'Failed DMARC');
    expect(find.text('Turned away by a filter'), findsOneWidget);
    await reveal(tester, 'WHAT EACH FILTER DID');
    expect(find.text('rspamd'), findsWidgets);

    await close(tester, fake, state);
  });

  testWidgets("a domain's DNS check, and what it says is missing", (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    // Each is about one domain, so not in Administration's list.
    for (final title in ['DNS check', 'Sender lists', 'MTA-STS']) {
      expect(find.text(title), findsNothing, reason: title);
    }

    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);
    await tap(tester, 'DNS check');
    expect(
      find.text('All 6 records ${FakeAccounts.host} needs are right.'),
      findsOneWidget,
    );
    expect(find.text('Right'), findsNWidgets(6));
    // The check looks under "default", and the domain signs with "mail".
    expect(find.textContaining('selector "default"'), findsNothing);
    await back(tester);
    await back(tester);

    final other = FakeAccounts.otherEmail.split('@').last;
    await tap(tester, other);
    await tap(tester, 'DNS check');
    expect(find.text('2 of 6 records $other needs are right.'), findsOneWidget);
    expect(find.text('Missing'), findsNWidgets(4));
    expect(find.textContaining('No DMARC record found'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('selector "default"'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tap(tester, 'Check again');
    expect(find.text('Missing'), findsNWidgets(4));

    await close(tester, fake, state);
  });

  testWidgets("a domain's sender lists: a sender turned away, one taken "
      'off, and one that is not a sender', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);
    await tap(tester, 'Sender lists');
    expect(find.text('@deals.test'), findsOneWidget);
    expect(find.text('ana@harbor.test'), findsNothing);

    await tap(tester, 'Turn a sender away');
    await tester.enterText(find.byType(TextField).at(0), 'deals.test');
    await tester.pump();
    await tap(tester, 'Turn away');
    expect(
      find.text('Sender must be an address, or @ and a domain.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField).at(0), 'Spam@X.test');
    await tester.enterText(find.byType(TextField).at(1), 'Phishing');
    await tester.pump();
    await tap(tester, 'Turn away');
    expect(find.text('spam@x.test'), findsOneWidget);
    expect(
      fake.senderRules.map((r) => (r.pattern, r.list, r.reason)),
      contains(('spam@x.test', 'block', 'Phishing')),
    );

    await tester.tap(find.byTooltip('Remove @deals.test'));
    await tester.pumpAndSettle();
    await tap(tester, 'Remove');
    expect(find.text('Removed @deals.test'), findsOneWidget);
    expect(
      fake.senderRules.map((r) => r.pattern),
      isNot(contains('@deals.test')),
    );

    await tap(tester, 'Let in');
    expect(find.text('ana@harbor.test'), findsOneWidget);
    expect(find.text('spam@x.test'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets("a domain's MTA-STS policy: unpublished, enforced, deleted, "
      'and set up again', (tester) async {
    final (fake, state) = await open(tester);
    FakeMtaStsPolicy? policy() =>
        fake.domains.firstWhere((d) => d.name == FakeAccounts.host).mtaSts;

    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);
    await tap(tester, 'MTA-STS');
    expect(find.text('Testing'), findsOneWidget);
    expect(find.text('mx.${FakeAccounts.host}'), findsOneWidget);
    expect(find.text('A week'), findsOneWidget);

    await tester.tap(find.byType(RmSwitch));
    await tester.pumpAndSettle();
    expect(policy()!.active, isFalse);

    await tap(tester, 'Change the policy');
    await tap(tester, 'Enforce');
    await tap(tester, 'A day');
    await tap(tester, 'Save');
    expect(
      find.text('Saved the policy for ${FakeAccounts.host}'),
      findsOneWidget,
    );
    expect(find.text('Enforce'), findsOneWidget);
    expect((policy()!.mode, policy()!.maxAge), ('enforce', 86400));
    // Let the toast go before reaching below it.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tap(tester, 'Delete policy');
    await tap(tester, 'Delete');
    expect(policy(), isNull);
    expect(
      find.textContaining('${FakeAccounts.host} has no MTA-STS policy'),
      findsOneWidget,
    );

    await tap(tester, 'Set up a policy');
    await tester.enterText(
      find.byType(TextField),
      'MX.restmail.test *.restmail.test',
    );
    await tester.pump();
    await tap(tester, 'Save');
    expect(policy()!.mxHosts, 'mx.restmail.test,*.restmail.test');
    expect(policy()!.mode, 'testing');

    await close(tester, fake, state);
  });

  testWidgets('with domains:read alone, a domain\'s DNS check, sender lists '
      'and MTA-STS to look at, and nothing to change', (tester) async {
    final (fake, state) = await open(
      tester,
      name: 'viewer',
      capabilities: {Capability.domainsRead},
    );

    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);
    for (final title in ['DNS check', 'Sender lists', 'MTA-STS']) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    await tap(tester, 'Sender lists');
    expect(find.text('@deals.test'), findsOneWidget);
    expect(find.text('Turn a sender away'), findsNothing);
    expect(find.byType(RmIconButton), findsNWidgets(1)); // Back only.
    await back(tester);

    await tap(tester, 'MTA-STS');
    expect(find.text('Testing'), findsOneWidget);
    expect(find.byType(RmSwitch), findsNothing);
    expect(find.text('On'), findsOneWidget);
    expect(find.text('Change the policy'), findsNothing);
    expect(find.text('Delete policy'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('without domains:read, no domain, so none of its sections; '
      'with mailboxes:read alone, mailboxes to look at', (tester) async {
    final (fake, state) = await open(
      tester,
      name: 'helpdesk',
      capabilities: {Capability.mailboxesRead},
    );

    expect(await shown(tester), ['Mailboxes', 'Aliases']);
    await tap(tester, 'Mailboxes');
    expect(find.text(FakeAccounts.email), findsOneWidget);
    expect(find.text('Add a mailbox'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('with observability:read alone, the overview, traces and '
      'pipeline analytics, and no pipeline log', (tester) async {
    final (fake, state) = await open(
      tester,
      name: 'watcher',
      capabilities: {Capability.observabilityRead},
    );

    expect(await shown(tester), [
      'Overview',
      'Message trace',
      'Pipeline analytics',
    ]);

    await close(tester, fake, state);
  });

  testWidgets('an app that shows changes the readonly role may not make is '
      'refused by the server, and says only that', (tester) async {
    final (fake, state) = await open(
      tester,
      name: 'reader',
      capabilities: readonly,
      modified: const Capabilities({'*'}),
    );
    final rules = fake.senderRules.length;

    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);
    await tap(tester, 'Sender lists');
    await tap(tester, 'Turn a sender away');
    await tester.enterText(find.byType(TextField).at(0), '@spam.test');
    await tester.pump();
    await tap(tester, 'Turn away');
    expect(find.text(noPermission), findsOneWidget);
    await back(tester);
    await tester.tap(find.byTooltip('Remove @deals.test'));
    await tester.pumpAndSettle();
    await tap(tester, 'Remove');
    expect(find.text(noPermission), findsOneWidget);
    expect(fake.senderRules, hasLength(rules));
    await back(tester);

    await tap(tester, 'MTA-STS');
    await tester.tap(find.byType(RmSwitch));
    await tester.pumpAndSettle();
    expect(find.text(noPermission), findsOneWidget);
    expect(
      fake.domains.firstWhere((d) => d.name == FakeAccounts.host).mtaSts,
      isNotNull,
    );

    await close(tester, fake, state);
  });
}
