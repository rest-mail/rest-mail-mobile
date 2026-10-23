import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/app_scope.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/admin/bans_screen.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);
  Future<(FakeRestmail, AppState, RestAccount)> open(
    WidgetTester tester, {
    bool readonly = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    if (readonly) fake.grant(FakeAccounts.adminEmail, {Capability.bansRead});
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    final account = state.current! as RestAccount;
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: ThemeData(extensions: const [RmColors.light]),
          home: BansScreen(account: account),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (fake, state, account);
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

  Future<void> reveal(WidgetTester tester, Finder target) async {
    for (final delta in [-300.0, 300.0]) {
      for (var i = 0; i < 20 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, delta));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String label) async {
    final target = find.text(label).last;
    await reveal(tester, target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, Finder target, String value) async {
    await reveal(tester, target);
    await tester.enterText(target, value);
    await tester.pump();
  }

  Finder labelled(String label) => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == label,
  );

  testWidgets(
    'ban creation chooses protocol and custom duration, with server fields kept',
    (tester) async {
      final (fake, state, _) = await open(tester);
      await tap(tester, 'Ban an address');
      await enter(tester, find.byType(TextField).first, '2001:db8::1');
      await tap(tester, 'IMAP');
      await tap(tester, 'Custom');
      await enter(tester, labelled('Duration'), '1h30m');
      await tap(tester, 'Ban');
      final made = fake.bans.firstWhere((ban) => ban.ip == '2001:db8::1');
      expect(made.protocol, 'imap');
      expect(made.createdBy, FakeAccounts.adminEmail);
      expect(made.expiresAt!.difference(made.createdAt).inMinutes, 90);
      expect(find.text('2001:db8::1'), findsOneWidget);
      await close(tester, fake, state);
    },
  );
  testWidgets(
    'unban by IPv6 confirms, cancel preserves ban, and missing ban stays editable',
    (tester) async {
      final (fake, state, account) = await open(tester);
      await account.client.createBan(
        ip: '2001:db8::1',
        createdBy: FakeAccounts.adminEmail,
      );
      await tap(tester, 'Lift a ban by IP');
      await enter(tester, find.byType(TextField), '2001:db8::1');
      await tap(tester, 'Lift ban');
      await tap(tester, 'Cancel');
      expect(fake.bans.any((ban) => ban.ip == '2001:db8::1'), isTrue);
      await tap(tester, 'Lift ban');
      await tap(tester, 'Lift ban');
      expect(fake.bans.any((ban) => ban.ip == '2001:db8::1'), isFalse);
      await tap(tester, 'Lift a ban by IP');
      await enter(tester, find.byType(TextField), '2001:db8::1');
      await tap(tester, 'Lift ban');
      await tap(tester, 'Lift ban');
      expect(find.text('No ban found for this IP'), findsOneWidget);
      expect(account.client.tokens, isNotNull);
      await close(tester, fake, state);
    },
  );
  testWidgets(
    'filters include expired bans only when requested and clear back to defaults',
    (tester) async {
      final (fake, state, account) = await open(tester);
      await account.client.createBan(
        ip: '192.0.2.20',
        createdBy: FakeAccounts.adminEmail,
        protocol: 'smtp',
        durationText: '-1s',
      );
      await tap(tester, 'Filter bans');
      await enter(tester, labelled('Exact IP address'), '192.0.2.20');
      await tap(tester, 'SMTP');
      await tap(tester, 'Apply filters');
      expect(find.text('No bans match these filters.'), findsOneWidget);
      await tap(tester, 'Filter bans');
      await tap(tester, 'Include expired bans');
      await tap(tester, 'Apply filters');
      expect(find.text('192.0.2.20'), findsOneWidget);
      expect(find.textContaining('expired '), findsWidgets);
      await tap(tester, 'Filter bans');
      await tap(tester, 'Clear filters');
      expect(find.text('192.0.2.20'), findsNothing);
      await close(tester, fake, state);
    },
  );
  testWidgets('bad custom duration shows validation and preserves the form', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    final count = fake.bans.length;
    await tap(tester, 'Ban an address');
    await enter(tester, find.byType(TextField).first, '192.0.2.20');
    await tap(tester, 'Custom');
    await enter(tester, labelled('Duration'), 'forever');
    await tap(tester, 'Ban');
    expect(find.textContaining('invalid duration format'), findsOneWidget);
    expect(fake.bans.length, count);
    await close(tester, fake, state);
  });
  testWidgets('read-only operators can filter but cannot ban or unban', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester, readonly: true);
    expect(find.text('Filter bans'), findsOneWidget);
    expect(find.text('Ban an address'), findsNothing);
    expect(find.text('Lift a ban by IP'), findsNothing);
    expect(find.byTooltip('Lift the ban on 203.0.113.7'), findsNothing);
    await close(tester, fake, state);
  });
}
