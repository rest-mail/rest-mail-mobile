import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

import '../packages/restmail_fake/test/fixtures/certificate.dart';
import '../packages/restmail_fake/test/fixtures/dkim_key.dart';

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
    http.Client Function(http.Client fake)? through,
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
      httpClientFactory: () => through?.call(fake.client) ?? fake.client,
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
    await tester.tap(find.byTooltip('Mailboxes'));
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

  Future<void> certificateField(
    WidgetTester tester,
    int index,
    String value,
  ) async {
    final field = find.byKey(ValueKey('admin-field-$index'));
    for (final step in const [300.0, -300.0]) {
      for (var i = 0; i < 15 && field.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, step));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(field);
    await tester.enterText(field, value);
    await tester.pump();
  }

  Future<void> fillCertificate(
    WidgetTester tester, {
    required String domain,
    String certificate = testCertificatePem,
    String renewal = 'No',
  }) async {
    final key = testCertificateKey.replaceAll('\n', '\r\n');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? <String, Object>{'text': key}
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await certificateField(tester, 0, domain);
    await certificateField(tester, 1, certificate);
    await tap(tester, 'Paste');
    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('admin-field-2')),
    );
    expect(field.readOnly, isTrue);
    expect(field.obscureText, isTrue);
    expect(field.controller!.text, key);
    // Check rendered text separately: an obscured EditableText still contains
    // its controller's secret and must not be searched with find.text.
    expect(
      find.byWidgetPredicate((w) => w is Text && w.data == key),
      findsNothing,
    );
    await tap(tester, renewal);
  }

  const sections = [
    'Outbound queue',
    'Domains',
    'Mailboxes',
    'Aliases',
    'Bans',
    'Permissions',
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

  testWidgets(
    'delivery filters validate times, apply from page one and clear',
    (tester) async {
      final (fake, state) = await open(tester);
      await tap(tester, 'Delivery log');
      await tap(tester, 'Filters');
      await tester.enterText(find.byType(TextField).at(0), 'harbor.test');
      await tester.enterText(find.byType(TextField).at(2), 'LEE');
      await tester.enterText(find.byType(TextField).at(3), 'yesterday');
      await tap(tester, 'Apply filters');
      expect(
        find.textContaining('must be a date and time with a timezone'),
        findsOneWidget,
      );
      await tester.enterText(
        find.byType(TextField).at(3),
        '2026-02-31T06:00:00Z',
      );
      await tap(tester, 'Apply filters');
      expect(
        find.textContaining('must be a date and time with a timezone'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField).at(3), '');
      await tap(tester, 'Apply filters');
      expect(find.text('lee@harbor.test'), findsOneWidget);
      expect(find.text('nobody@ryeworks.test'), findsNothing);
      expect(find.text('Filters (2)'), findsOneWidget);
      await tap(tester, 'Clear filters');
      expect(find.text('nobody@ryeworks.test'), findsOneWidget);
      expect(find.text('Filters'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets('TLS report filters and complete detail are usable', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    await tap(tester, 'TLS reports');
    await tap(tester, 'Filters');
    await tester.enterText(find.byType(TextField).at(1), 'MICROSOFT');
    await tap(tester, 'Apply filters');
    expect(find.text('Google Inc.'), findsNothing);
    await tap(tester, 'Microsoft Corporation');
    await reveal(tester, 'Report');
    expect(find.text('Report'), findsOneWidget);
    expect(find.text('Domain number'), findsOneWidget);
    expect(find.text('Added'), findsOneWidget);
    await reveal(tester, 'WHAT FAILED');
    expect(find.textContaining('certificate-expired'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets(
    'pipeline correlation filters open full filter log and step timing',
    (tester) async {
      final (fake, state) = await open(tester);
      final account = state.current! as RestAccount;
      final trace = (await account.client.pipelineLog(
        reasonCode: 'custom_reject',
      )).items.single;
      await tap(tester, 'Pipeline log');
      await tap(tester, 'Filters');
      await tester.enterText(find.byKey(const ValueKey('admin-field-0')), '0');
      // The form's own list, found from the list itself: every text field
      // holds a Scrollable of its own, and a field scrolled away is gone.
      final form = find
          .descendant(
            of: find.byType(ListView).last,
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('admin-field-4')),
        200,
        scrollable: form,
      );
      await tester.enterText(
        find.byKey(const ValueKey('admin-field-4')),
        trace.rfcMessageId,
      );
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('admin-field-5')),
        200,
        scrollable: form,
      );
      await tester.enterText(
        find.byKey(const ValueKey('admin-field-5')),
        'custom_reject',
      );
      await tap(tester, 'Apply filters');
      expect(find.text('news@deals.test'), findsOneWidget);
      expect(find.text('promo@deals.test'), findsNothing);
      await tap(tester, 'news@deals.test');
      await tap(tester, 'domain_allowlist');
      expect(find.textContaining('18 ms'), findsOneWidget);
      expect(find.textContaining('"result": "blocked"'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets('audit actor/action filters and independently saved anchor', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    final anchor = fake.auditLog.first;
    await tap(tester, 'Audit log');
    await tap(tester, 'Filters');
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeAccounts.adminEmail,
    );
    await tester.enterText(find.byType(TextField).at(2), 'auth.sign_in');
    await tap(tester, 'Apply filters');
    expect(find.textContaining('admin.change'), findsNothing);
    expect(find.textContaining('auth.sign_in'), findsWidgets);
    await tap(tester, 'Verify saved anchor');
    await tester.enterText(find.byType(TextField), 'bad');
    await tap(tester, 'Verify anchor');
    expect(
      find.textContaining('must be a positive sequence number'),
      findsOneWidget,
    );
    await tester.enterText(
      find.byType(TextField),
      '${anchor.seq}:${anchor.hash}',
    );
    await tap(tester, 'Verify anchor');
    expect(find.textContaining('The chain holds'), findsOneWidget);
    expect(find.textContaining('Checked against saved anchor'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets(
    'analytics accepts a custom period and shows cumulative counters separately',
    (tester) async {
      final (fake, state) = await open(tester);
      await tap(tester, 'Pipeline analytics');
      await tap(tester, 'Custom period');
      await tester.enterText(find.byType(TextField).at(0), 'wrong');
      await tap(tester, 'Apply filters');
      expect(find.textContaining('must be a duration such as'), findsOneWidget);
      await tester.enterText(find.byType(TextField).at(0), '90m');
      await tap(tester, 'Apply filters');
      expect(find.textContaining('90m'), findsWidgets);
      await tap(tester, 'Since process start');
      expect(
        find.text('Cumulative since this server process started'),
        findsOneWidget,
      );
      await reveal(tester, 'Failed DMARC');
      expect(find.text('Failed DMARC'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

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

  Future<void> pickDkimDomain(WidgetTester tester, String name) async {
    // The global list remains behind the sheet and may have the same name.
    final tile = find.widgetWithText(ListTile, name);
    await tester.scrollUntilVisible(
      tile,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(tile);
    await tester.pumpAndSettle();
  }

  void clipboard(WidgetTester tester, String text) {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.getData') return {'text': text};
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
  }

  testWidgets(
    'domain DKIM management never calls the global list and preserves pasted PEM',
    (tester) async {
      late _DkimTransport transport;
      final (fake, state) = await open(
        tester,
        through: (inner) =>
            transport = _DkimTransport(inner)..denyGlobal = true,
      );
      clipboard(tester, testDkimKey);
      await tap(tester, 'Domains');
      await tap(tester, FakeAccounts.host);
      await tap(tester, 'DKIM signing');
      await tap(tester, 'Install or replace key');
      await tester.enterText(find.byType(TextField).first, 'mobile2026');
      await tap(tester, 'Paste');
      // Hidden multiline input retains its bytes and never renders a PEM label.
      expect(
        tester.widget<TextField>(find.byType(TextField).last).obscureText,
        isTrue,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && (w.data?.contains('MC4CAQAwBQYDK2Vw') ?? false),
        ),
        findsNothing,
      );
      await tap(tester, 'Set key');
      expect(transport.installedKey, testDkimKey);
      expect(transport.globalLists, 0);
      expect(
        fake.domains
            .firstWhere((d) => d.name == FakeAccounts.host)
            .dkimSelector,
        'mobile2026',
      );
      await tap(tester, FakeAccounts.host);
      await tap(tester, 'Key rotation');
      await tester.enterText(find.byType(TextField), '4000');
      await tap(tester, 'Save');
      expect(find.textContaining('between 0 and 3650'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '91');
      await tap(tester, 'Save');
      final account = state.current! as RestAccount;
      final domain = fake.domains.firstWhere(
        (d) => d.name == FakeAccounts.host,
      );
      expect((await account.client.dkimRotation(domain.id)).intervalDays, 91);
      await tester.tap(
        find.byTooltip('Remove the key for ${FakeAccounts.host}'),
      );
      await tester.pumpAndSettle();
      await tap(tester, 'Cancel');
      expect(domain.signs, isTrue);
      await tester.tap(
        find.byTooltip('Remove the key for ${FakeAccounts.host}'),
      );
      await tester.pumpAndSettle();
      await tap(tester, 'Remove key');
      expect(domain.signs, isFalse);
      expect(find.text('No signing selector is configured'), findsOneWidget);
      expect((await account.client.dkimRotation(domain.id)).intervalDays, 91);
      await close(tester, fake, state);
    },
  );

  testWidgets('a previously unsigned domain can install a key', (tester) async {
    final (fake, state) = await open(tester);
    final account = state.current! as RestAccount;
    final domain = await account.client.createDomain('unsigned.test');
    clipboard(tester, testDkimKey);
    await tap(tester, 'DKIM keys');
    await tap(tester, 'Set a key for a domain');
    await pickDkimDomain(tester, 'unsigned.test');
    await tester.enterText(find.byType(TextField).first, 'newkey');
    await tap(tester, 'Paste');
    await tap(tester, 'Set key');
    expect((await account.client.domain(domain.id)).dkimSelector, 'newkey');
    expect(find.text('unsigned.test'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('DKIM field refusals remain on the form and preserve login', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    clipboard(tester, testDkimKey);
    await tap(tester, 'DKIM keys');
    await tap(tester, 'Set a key for a domain');
    await pickDkimDomain(tester, FakeAccounts.host);
    await tester.enterText(find.byType(TextField).first, 'bad_selector');
    await tap(tester, 'Paste');
    await tap(tester, 'Set key');
    expect(find.textContaining('must be DNS labels'), findsOneWidget);
    expect((state.current! as RestAccount).client.tokens, isNotNull);
    await tester.enterText(find.byType(TextField).first, 'valid');
    await tap(tester, 'Set key');
    expect(
      fake.domains.firstWhere((d) => d.name == FakeAccounts.host).dkimSelector,
      'valid',
    );
    await close(tester, fake, state);
  });

  testWidgets('read-only DKIM rotation opens without mutation controls', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      name: 'keyviewer',
      capabilities: {Capability.domainsRead},
    );
    await tap(tester, 'DKIM keys');
    expect(find.text('Set a key for a domain'), findsNothing);
    expect(
      find.byTooltip('Remove the key for ${FakeAccounts.host}'),
      findsNothing,
    );
    await tap(tester, FakeAccounts.host);
    expect(find.textContaining('Never rotated.'), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    await tap(tester, 'Done');
    await close(tester, fake, state);
  });

  testWidgets(
    'DKIM write permission is enforced when an altered app shows the form',
    (tester) async {
      final (fake, state) = await open(
        tester,
        name: 'keyreader',
        capabilities: {Capability.domainsRead},
        modified: const Capabilities({'*'}),
      );
      clipboard(tester, testDkimKey);
      await tap(tester, 'DKIM keys');
      await tap(tester, 'Set a key for a domain');
      await pickDkimDomain(tester, FakeAccounts.host);
      await tester.enterText(find.byType(TextField).first, 'refused');
      await tap(tester, 'Paste');
      await tap(tester, 'Set key');
      expect(find.text(noPermission), findsOneWidget);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      expect(
        fake.domains
            .firstWhere((d) => d.name == FakeAccounts.host)
            .dkimSelector,
        isNot('refused'),
      );
      await close(tester, fake, state);
    },
  );

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

  testWidgets(
    'certificate upload preserves PEM and opens fresh public detail',
    (tester) async {
      late _CertificateTransport transport;
      final (fake, state) = await open(
        tester,
        through: (inner) => transport = _CertificateTransport(inner),
      );
      await tap(tester, 'Certificates');
      await tap(tester, 'Add a certificate');
      await fillCertificate(tester, domain: FakeAccounts.host.toUpperCase());
      await tap(tester, 'Add certificate');
      expect(transport.lastUpload!['cert_pem'], testCertificatePem);
      expect(
        transport.lastUpload!['key_pem'],
        testCertificateKey.replaceAll('\n', '\r\n'),
      );
      expect(transport.lastUpload!['auto_renew'], isFalse);
      expect(transport.detailRequests, 1);
      final created = fake.certificates.last;
      expect(created.autoRenew, isFalse);
      expect(created.issuer, testCertificateIssuer);
      expect(find.text('Certificate'), findsOneWidget);
      await reveal(tester, 'CERTIFICATE');
      expect(
        find.byWidgetPredicate(
          (w) => w is SelectableText && w.data == testCertificatePem.trim(),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is SelectableText && (w.data?.contains('PRIVATE KEY') ?? false),
        ),
        findsNothing,
      );
      await close(tester, fake, state);
    },
  );

  testWidgets('a bad certificate stays on the form and can be corrected', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    final count = fake.certificates.length;
    await tap(tester, 'Certificates');
    await tap(tester, 'Add a certificate');
    await fillCertificate(
      tester,
      domain: '${fake.domains.first.id}',
      certificate: 'not PEM',
    );
    await tap(tester, 'Add certificate');
    expect(find.text('Invalid certificate PEM'), findsOneWidget);
    expect(fake.certificates, hasLength(count));
    await certificateField(tester, 1, testCertificatePem);
    await tap(tester, 'Add certificate');
    expect(fake.certificates, hasLength(count + 1));
    expect(find.text('Certificate'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('certificate readers get detail without mutation controls', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      name: 'certificate-reader',
      capabilities: {Capability.domainsRead},
    );
    await tap(tester, 'Certificates');
    expect(find.text('Add a certificate'), findsNothing);
    expect(
      find.byTooltip('Delete the certificate for ${FakeAccounts.host}'),
      findsNothing,
    );
    await tap(tester, FakeAccounts.host);
    expect(find.text('Issuer'), findsOneWidget);
    expect(find.text('Certificate'), findsOneWidget);
    expect((state.current! as RestAccount).client.tokens, isNotNull);
    await close(tester, fake, state);
  });

  testWidgets(
    'the server refuses certificate upload by a modified reader app',
    (tester) async {
      final (fake, state) = await open(
        tester,
        name: 'certificate-modified',
        capabilities: {Capability.domainsRead},
        modified: const Capabilities({'*'}),
      );
      final count = fake.certificates.length;
      final tokens = (state.current! as RestAccount).client.tokens;
      await tap(tester, 'Certificates');
      await tap(tester, 'Add a certificate');
      await fillCertificate(tester, domain: '${fake.domains.first.id}');
      await tap(tester, 'Add certificate');
      expect(find.text(noPermission), findsOneWidget);
      expect(find.text('Add a certificate'), findsOneWidget);
      expect(fake.certificates, hasLength(count));
      expect((state.current! as RestAccount).client.tokens, same(tokens));
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'certificate domain names page beyond 200 and use server renewal default',
    (tester) async {
      late _CertificateTransport transport;
      final (fake, state) = await open(
        tester,
        through: (inner) => transport = _CertificateTransport(inner),
      );
      for (var i = 0; i < 201; i++) {
        fake.addAccount('user@page-$i.test');
      }
      fake.addAccount('user@zz-last.test');
      await tap(tester, 'Certificates');
      await tap(tester, 'Add a certificate');
      await fillCertificate(
        tester,
        domain: 'ZZ-LAST.TEST',
        renewal: 'Server default',
      );
      await tap(tester, 'Add certificate');
      expect(transport.domainOffsets, containsAllInOrder([0, 200]));
      expect(transport.lastUpload!.containsKey('auto_renew'), isFalse);
      expect(fake.certificates.last.domain, 'zz-last.test');
      expect(fake.certificates.last.autoRenew, isTrue);
      expect(find.text('Certificate'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'certificate refresh clears stale data while pending and after refusal',
    (tester) async {
      late _CertificateTransport transport;
      final (fake, state) = await open(
        tester,
        through: (inner) =>
            transport = _CertificateTransport(inner)
              ..detailIssuer = 'O=Fresh issuer',
      );
      await tap(tester, 'Certificates');
      await tap(tester, FakeAccounts.host);
      expect(transport.detailRequests, 1);
      expect(find.text('Fresh issuer'), findsOneWidget);
      final refresh = tester.widget<RefreshIndicator>(
        find.byType(RefreshIndicator).last,
      );
      final gate = Completer<void>();
      transport.detailGate = gate;
      final pending = refresh.onRefresh();
      await tester.pump();
      expect(find.text('Fresh issuer'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      gate.complete();
      await pending;
      await tester.pumpAndSettle();
      expect(transport.detailRequests, 2);
      expect(find.text('Fresh issuer'), findsOneWidget);
      transport.failureStatus = 403;
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator).last)
          .onRefresh();
      await tester.pumpAndSettle();
      expect(find.text('Fresh issuer'), findsNothing);
      expect(find.text(noPermission), findsOneWidget);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      transport.failureStatus = null;
      await tap(tester, 'Try again');
      expect(find.text('Fresh issuer'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  for (final status in [403, 404]) {
    testWidgets(
      'certificate GET $status is explained and retry keeps the session',
      (tester) async {
        late _CertificateTransport transport;
        final (fake, state) = await open(
          tester,
          through: (inner) =>
              transport = _CertificateTransport(inner)..failureStatus = status,
        );
        await tap(tester, 'Certificates');
        await tap(tester, FakeAccounts.host);
        expect(find.text('Try again'), findsOneWidget);
        if (status == 403) expect(find.text(noPermission), findsOneWidget);
        expect((state.current! as RestAccount).client.tokens, isNotNull);
        transport.failureStatus = null;
        await tap(tester, 'Try again');
        expect(find.text('Issuer'), findsOneWidget);
        expect(transport.detailRequests, 2);
        await close(tester, fake, state);
      },
    );
  }

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
      'Overview',
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
    expect(find.text('Turned away'), findsAtLeastNWidgets(2));
    expect(find.text('Scored as spam'), findsOneWidget);
    expect(find.text('rspamd'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('pipeline analytics for a day, and for a week', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Pipeline analytics');
    expect(find.text('HOW IT ENDED'), findsOneWidget);
    await reveal(tester, 'Scored as spam');
    expect(find.text('Scored as spam'), findsOneWidget);
    expect(find.text('Failed DMARC'), findsNothing);
    await tap(tester, 'A week');
    await reveal(tester, 'Scored as spam');
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
    // The toast goes first: it sits over the form's Save.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tap(tester, 'Set up a policy');
    await tester.enterText(
      find.byKey(const ValueKey('mta-sts-hosts')),
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

  testWidgets('with observability:read alone, traces and pipeline '
      'analytics, and no overview, which needs domains:read, or pipeline log', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      name: 'watcher',
      capabilities: {Capability.observabilityRead},
    );

    expect(await shown(tester), ['Message trace', 'Pipeline analytics']);

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

  testWidgets('a domain added as Postfix and Dovecot, Bulk, with a mailbox '
      'size, opens as the server made it', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Domains');
    await tap(tester, 'Add a domain');
    expect(find.text('MAIL KEPT BY'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'New.test');
    await tap(tester, 'Postfix and Dovecot');
    await tap(tester, 'Bulk');
    // The size takes digits only.
    await tester.enterText(find.byType(TextField).at(1), '5x0a0');
    await tester.pump();
    expect(find.text('500'), findsOneWidget);
    await tap(tester, 'Add domain');

    final made = fake.domains.firstWhere((d) => d.name == 'new.test');
    expect(made.serverType, 'traditional');
    expect(made.sendingPolicy, 'bulk');
    expect(made.defaultQuotaBytes, 500 * 1024 * 1024);
    expect(made.active, isFalse);
    // The domain screen opens on what the server answered.
    expect(find.text('Add a domain'), findsNothing);
    expect(find.text('new.test'), findsWidgets);
    expect(find.text('Postfix and Dovecot'), findsOneWidget);
    expect(find.text('Bulk'), findsOneWidget);
    expect(find.text('500 MB'), findsOneWidget);

    // Back on the list, it is there.
    await back(tester);
    expect(find.text('new.test'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('a domain added with no choices made is REST Mail, no policy '
      'and the server default size', (tester) async {
    final (fake, state) = await open(tester);

    await tap(tester, 'Domains');
    await tap(tester, 'Add a domain');
    await tester.enterText(find.byType(TextField).at(0), 'plain.test');
    await tester.pump();
    await tap(tester, 'Add domain');

    final made = fake.domains.firstWhere((d) => d.name == 'plain.test');
    expect(made.serverType, 'restmail');
    expect(made.sendingPolicy, '');
    expect(made.defaultQuotaBytes, 1073741824);
    expect(find.text('REST Mail'), findsOneWidget);
    expect(find.text('None'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('a field the server refuses is named on the form, which '
      'stays open', (tester) async {
    final (fake, state) = await open(
      tester,
      through: (inner) => _Refusing(inner),
    );

    await tap(tester, 'Domains');
    await tap(tester, 'Add a domain');
    await tester.enterText(find.byType(TextField).at(0), 'new.test');
    await tap(tester, 'Transactional');
    await tap(tester, 'Add domain');

    expect(
      find.text("Sending policy must be 'transactional', 'bulk' or empty."),
      findsOneWidget,
    );
    expect(find.text('Add a domain'), findsOneWidget);
    expect(fake.domains.map((d) => d.name), isNot(contains('new.test')));
    // Choosing again clears it.
    await tap(tester, 'Bulk');
    expect(
      find.text("Sending policy must be 'transactional', 'bulk' or empty."),
      findsNothing,
    );

    await close(tester, fake, state);
  });

  testWidgets("a domain's mailbox size and sending policy changed, and the "
      'policy cleared', (tester) async {
    final (fake, state) = await open(tester);
    FakeDomain domain() =>
        fake.domains.firstWhere((d) => d.name == FakeAccounts.host);

    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);

    await tap(tester, 'Mailbox size');
    expect(find.text('1024'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '250');
    await tester.pump();
    await tap(tester, 'Save');
    expect(domain().defaultQuotaBytes, 250 * 1024 * 1024);
    expect(find.text('250 MB'), findsOneWidget);

    await tap(tester, 'Sending policy');
    await tap(tester, 'Transactional');
    await tap(tester, 'Save');
    expect(domain().sendingPolicy, 'transactional');
    expect(find.text('Transactional'), findsOneWidget);

    await tap(tester, 'Sending policy');
    await tap(tester, 'None');
    await tap(tester, 'Save');
    expect(domain().sendingPolicy, '');
    expect(find.text('None'), findsOneWidget);
    // The other settings stayed.
    expect(domain().defaultQuotaBytes, 250 * 1024 * 1024);

    await close(tester, fake, state);
  });

  testWidgets("a mailbox's size changed, and its sessions ended once "
      'confirmed', (tester) async {
    final (fake, state) = await open(tester);
    final dana = RestmailClient(server: _server, httpClient: fake.client);
    await dana.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await dana.accounts();

    await tap(tester, 'Mailboxes');
    await tap(tester, FakeAccounts.email);

    await tap(tester, 'Mailbox size');
    expect(find.text('5120'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '250');
    await tester.pump();
    await tap(tester, 'Save');
    expect(find.text('250 MB'), findsOneWidget);
    final admin = (state.current! as RestAccount).client;
    final boxes = await admin.mailboxes();
    expect(
      boxes.items.firstWhere((b) => b.address == FakeAccounts.email).quotaBytes,
      250 * 1024 * 1024,
    );

    // Cancelled, nothing ends.
    await tap(tester, 'End sessions');
    expect(
      find.text('Sign ${FakeAccounts.email} out everywhere?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await dana.accounts();

    await tap(tester, 'End sessions');
    await tester.tap(find.text('End sessions').last);
    await tester.pumpAndSettle();
    expect(find.text('Signed out everywhere'), findsOneWidget);
    await expectLater(dana.accounts(), throwsA(isA<ApiException>()));
    // The administrator's own session carries on.
    await admin.mailboxes();

    dana.close();
    await close(tester, fake, state);
  });
  for (final (resource, section, selected, fresh, delete) in [
    ('domains', 'Domains', FakeAccounts.host, 'Bulk', 'Delete domain'),
    (
      'mailboxes',
      'Mailboxes',
      FakeAccounts.email,
      'Fresh detail name',
      'Delete mailbox',
    ),
    (
      'aliases',
      'Aliases',
      'hello@${FakeAccounts.host}',
      'MixedCase@Remote.test',
      'Delete alias',
    ),
  ]) {
    testWidgets('$resource detail fetches fresh values and refreshes', (
      tester,
    ) async {
      late _DetailTransport transport;
      final (fake, state) = await open(
        tester,
        through: (inner) => transport = _DetailTransport(inner, resource),
      );
      await tap(tester, section);
      await tap(tester, selected);
      expect(transport.detailRequests, 1);
      expect(find.text(fresh), findsOneWidget);
      final refresh = tester.widget<RefreshIndicator>(
        find.byType(RefreshIndicator).last,
      );
      await refresh.onRefresh();
      await tester.pumpAndSettle();
      expect(transport.detailRequests, 2);
      expect(find.text(fresh), findsOneWidget);
      await close(tester, fake, state);
    });

    for (final status in [403, 404]) {
      testWidgets('$resource $status hides stale actions and can be retried', (
        tester,
      ) async {
        late _DetailTransport transport;
        final (fake, state) = await open(
          tester,
          through: (inner) =>
              transport = _DetailTransport(inner, resource)
                ..failureStatus = status,
        );
        await tap(tester, section);
        await tap(tester, selected);
        expect(transport.detailRequests, 1);
        expect(find.text(delete), findsNothing);
        expect(find.text('Try again'), findsOneWidget);
        if (status == 403) expect(find.text(noPermission), findsOneWidget);
        expect((state.current! as RestAccount).client.tokens, isNotNull);
        transport.failureStatus = null;
        await tap(tester, 'Try again');
        expect(transport.detailRequests, 2);
        expect(find.text(fresh), findsOneWidget);
        expect(find.text('Try again'), findsNothing);
        await close(tester, fake, state);
      });
    }
  }

  testWidgets('a refresh refusal removes previously loaded mailbox actions', (
    tester,
  ) async {
    late _DetailTransport transport;
    final (fake, state) = await open(
      tester,
      through: (inner) => transport = _DetailTransport(inner, 'mailboxes'),
    );
    await tap(tester, 'Mailboxes');
    await tap(tester, FakeAccounts.email);
    expect(find.text('Fresh detail name'), findsOneWidget);
    transport.failureStatus = 403;
    await tester
        .widget<RefreshIndicator>(find.byType(RefreshIndicator).last)
        .onRefresh();
    await tester.pumpAndSettle();
    expect(find.text('Fresh detail name'), findsNothing);
    expect(find.text('End sessions'), findsNothing);
    expect(find.text('Delete mailbox'), findsNothing);
    expect(find.text(noPermission), findsOneWidget);
    expect((state.current! as RestAccount).client.tokens, isNotNull);
    transport.failureStatus = null;
    await tap(tester, 'Try again');
    expect(find.text('Fresh detail name'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets(
    'alias creation opens its response and preserves destination case',
    (tester) async {
      final (fake, state) = await open(tester);
      await tap(tester, 'Aliases');
      await tap(tester, 'Add an alias');
      await tester.enterText(
        find.byType(TextField).at(0),
        'new-alias@${FakeAccounts.host}',
      );
      await tester.enterText(
        find.byType(TextField).at(1),
        'MixedCase@Remote.test',
      );
      await tester.pump();
      await tap(tester, 'Add alias');
      expect(find.text('Delivers to'), findsOneWidget);
      expect(find.text('MixedCase@Remote.test'), findsOneWidget);
      expect(
        fake.aliases
            .singleWhere((a) => a.source.startsWith('new-alias@'))
            .destination,
        'MixedCase@Remote.test',
      );
      await tap(tester, 'Delivers to');
      await tester.enterText(
        find.byType(TextField),
        'AnotherCase@Elsewhere.test',
      );
      await tester.pump();
      await tap(tester, 'Save');
      expect(find.text('AnotherCase@Elsewhere.test'), findsOneWidget);
      expect(
        fake.aliases
            .singleWhere((a) => a.source.startsWith('new-alias@'))
            .destination,
        'AnotherCase@Elsewhere.test',
      );
      await close(tester, fake, state);
    },
  );
}

/// Records certificate requests without logging secret bodies. Detail responses
/// can differ from list data, wait in flight, or be refused by the server.
class _CertificateTransport extends http.BaseClient {
  _CertificateTransport(this.inner);

  final http.Client inner;
  Map<String, dynamic>? lastUpload;
  final domainOffsets = <int>[];
  int detailRequests = 0;
  int? failureStatus;
  String? detailIssuer;
  Completer<void>? detailGate;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method == 'GET' &&
        request.url.path.endsWith('/admin/domains')) {
      domainOffsets.add(
        int.parse(request.url.queryParameters['offset'] ?? '0'),
      );
    }
    if (request.method == 'POST' &&
        request.url.path.endsWith('/admin/certificates') &&
        request is http.Request) {
      lastUpload = jsonDecode(request.body) as Map<String, dynamic>;
    }
    if (request.method != 'GET' ||
        !RegExp(r'/admin/certificates/[0-9]+$').hasMatch(request.url.path)) {
      return inner.send(request);
    }
    detailRequests++;
    final gate = detailGate;
    detailGate = null;
    if (gate != null) await gate.future;
    final status = failureStatus;
    if (status != null) {
      return http.StreamedResponse(
        Stream.value(
          utf8.encode(
            jsonEncode({
              'error': {
                'code': status == 403 ? 'forbidden' : 'not_found',
                'message': 'Certificate unavailable',
              },
            }),
          ),
        ),
        status,
        headers: {'content-type': 'application/json'},
      );
    }
    final response = await http.Response.fromStream(await inner.send(request));
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final issuer = detailIssuer;
    if (issuer != null && response.statusCode == 200) {
      (body['data'] as Map<String, dynamic>)['issuer'] = issuer;
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(body))),
      response.statusCode,
      headers: response.headers,
    );
  }
}

/// Answers creating a domain as a server with other sending policies would:
/// a 422 naming the field. Everything else reaches [_inner].
class _Refusing extends http.BaseClient {
  _Refusing(this._inner);

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method == 'POST' &&
        request.url.path.endsWith('/admin/domains')) {
      return http.StreamedResponse(
        Stream.value(
          utf8.encode(
            jsonEncode({
              'error': {
                'code': 'validation_failed',
                'message': 'Request body failed validation',
                'details': {
                  'fields': {
                    'sending_policy':
                        "must be 'transactional', 'bulk' or empty",
                  },
                },
              },
            }),
          ),
        ),
        422,
        headers: {'content-type': 'application/json'},
      );
    }
    return _inner.send(request);
  }
}

/// Lists carry older data; each resource GET answers with the latest values.
class _DetailTransport extends http.BaseClient {
  _DetailTransport(this.inner, this.resource);
  final http.Client inner;
  final String resource;
  int detailRequests = 0;
  int? failureStatus;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method != 'GET' ||
        !RegExp('/api/v1/admin/$resource/[0-9]+\$')
            .hasMatch(request.url.path)) {
      return inner.send(request);
    }
    detailRequests++;
    final status = failureStatus;
    if (status != null) {
      return http.StreamedResponse(
        Stream.value(
          utf8.encode(
            jsonEncode({
              'error': {
                'code': status == 403 ? 'forbidden' : 'not_found',
                'message': 'Resource unavailable',
              },
            }),
          ),
        ),
        status,
        headers: {'content-type': 'application/json'},
      );
    }
    final response = await http.Response.fromStream(await inner.send(request));
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    switch (resource) {
      case 'domains':
        data['sending_policy'] = 'bulk';
      case 'mailboxes':
        data['display_name'] = 'Fresh detail name';
      case 'aliases':
        data['destination_address'] = 'MixedCase@Remote.test';
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(body))),
      response.statusCode,
      headers: response.headers,
    );
  }
}

// Records only a public test fixture, never production key material.
class _DkimTransport extends http.BaseClient {
  _DkimTransport(this.inner);
  final http.Client inner;
  bool denyGlobal = false;
  int globalLists = 0;
  String? installedKey;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (request.method == 'GET' && request.url.path == '/api/v1/admin/dkim') {
      globalLists++;
      if (denyGlobal) {
        return Future.value(
          http.StreamedResponse(
            Stream.value(
              utf8.encode(
                '{"error":{"code":"forbidden","message":"Global listing refused"}}',
              ),
            ),
            403,
          ),
        );
      }
    }
    if (request is http.Request &&
        request.method == 'PUT' &&
        RegExp(r'/api/v1/admin/dkim/[0-9]+$').hasMatch(request.url.path)) {
      installedKey =
          (jsonDecode(request.body) as Map<String, dynamic>)['private_key']
              as String?;
    }
    return inner.send(request);
  }
}
