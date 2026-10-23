import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/admin/overview_screen.dart';
import 'package:restmail/ui/mailboxes_screen.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// The Mailboxes list: lazy, so rows far down are built only once scrolled
/// to.
final _mailboxesList = find
    .descendant(
      of: find.byType(MailboxesScreen),
      matching: find.byType(Scrollable),
    )
    .first;

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester,
    String email,
    String password,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: email,
      password: password,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    return (fake, state);
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

  testWidgets('an admin sees the server health below Administration', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      FakeAccounts.adminEmail,
      FakeAccounts.adminPassword,
    );
    final title = find.text('SERVER HEALTH');
    await tester.scrollUntilVisible(title, 200, scrollable: _mailboxesList);
    await tester.pumpAndSettle();
    expect(title, findsOneWidget);
    expect(find.text('Domains'), findsOneWidget);
    expect(find.text('Mailboxes'), findsWidgets);
    expect(find.text('Waiting to go out'), findsOneWidget);
    expect(find.text('Given up on'), findsOneWidget);
    expect(
      find.text('95% of 120 incoming deliveries were encrypted.'),
      findsOneWidget,
    );

    final link = find.text('Open the full overview');
    await tester.scrollUntilVisible(link, 200, scrollable: _mailboxesList);
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(find.byType(OverviewScreen), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('an ordinary mailbox does not see the server health', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      FakeAccounts.email,
      FakeAccounts.password,
    );
    // To the end of the list, so a missing row is not just one not built.
    await tester.drag(_mailboxesList, const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(find.text('SERVER HEALTH'), findsNothing);
    expect(find.text('Open the full overview'), findsNothing);
    await close(tester, fake, state);
  });
}
