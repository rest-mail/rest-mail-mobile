import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');
const _eve = 'eve@${FakeAccounts.host}';

/// My permissions, under Settings → the account, against the fake, which
/// keeps escalation.go's rules: only the holder's own grants, a reason and
/// a fresh code to switch one on, and what the session holds after.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail()
      ..addAccount(_eve)
      ..addGrant(_eve, 'admin', mode: 'eligible');
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: _server,
      email: _eve,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  Future<void> tap(WidgetTester tester, Finder target) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) =>
      tap(tester, find.text(text).last);

  Finder field(String hint) =>
      find.ancestor(of: find.text(hint), matching: find.byType(TextField));

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

  testWidgets('an account holding only an eligible role reaches My '
      'permissions, and switches the role on with a fresh code', (
    tester,
  ) async {
    final (fake, state) = await open(tester);

    await tap(tester, find.byTooltip('Mailboxes'));
    await tap(tester, find.byTooltip('Mailbox settings'));
    await tapText(tester, _eve);
    // Nothing to administer yet, but its own grants are there.
    expect(find.text('Administration'), findsNothing);
    await tapText(tester, 'My permissions');
    expect(find.text('admin · Everywhere'), findsOneWidget);
    expect(find.text('Switch off'), findsNothing);

    await tapText(tester, 'Switch on…');
    await tester.enterText(field('What you need it for'), 'Clearing a bounce');
    await tester.enterText(field('6-digit code'), '000000');
    await tester.pump();
    await tapText(tester, 'Switch on');
    // A wrong code is explained, and the session is still signed in.
    expect(find.textContaining('That code is wrong'), findsOneWidget);
    expect((state.current! as RestAccount).signedOut, isNull);

    await tester.enterText(field('6-digit code'), FakeAccounts.totpCode);
    await tester.pump();
    await tapText(tester, 'Switch on');
    expect(find.textContaining('Switched on admin until'), findsWidgets);
    expect(find.text('Switch off'), findsOneWidget);
    expect(
      (state.current! as RestAccount).capabilities.allows(Capability.queueRead),
      isTrue,
    );

    // Back in Settings, Administration is there now.
    await tap(tester, find.byTooltip('Back').first);
    expect(find.text('Administration'), findsOneWidget);

    await close(tester, fake, state);
  });
}
