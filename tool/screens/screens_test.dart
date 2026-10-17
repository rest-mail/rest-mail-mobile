// Walks the app through its screens, light and dark, against the fake
// server, and saves each one as a picture in build/screens/. It checks
// nothing; it is for looking at. Run it with `chore screens`.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/settings.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _out = '${Directory.current.path}/build/screens';
final _frame = GlobalKey();

Future<ByteData> _bytes(String path) async =>
    ByteData.sublistView(await File(path).readAsBytes());

/// Tests draw text in a placeholder font; these are the real ones.
Future<void> _loadFonts() async {
  final sans = FontLoader('PublicSans');
  for (final weight in [
    'Regular',
    'Italic',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
  ]) {
    sans.addFont(_bytes('assets/fonts/PublicSans-$weight.ttf'));
  }
  await sans.load();
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) return; // icons draw as boxes, the rest is fine
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      _bytes(
        '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ),
    );
  await icons.load();
}

Future<void> _shot(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  await expectLater(find.byKey(_frame), matchesGoldenFile('$_out/$name.png'));
}

Future<void> _tour(WidgetTester tester, {required bool dark}) async {
  // An iPhone 15-sized screen, with its notch and home bar.
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  tester.view.padding = const FakeViewPadding(top: 162, bottom: 102);
  tester.view.viewPadding = const FakeViewPadding(top: 162, bottom: 102);
  addTearDown(tester.view.reset);

  final suffix = dark ? '-dark' : '';
  final fake = FakeRestmail();
  final state = AppState(
    store: MemoryKeyValueStore(),
    httpClientFactory: () => fake.client,
  );
  await state.start();
  state.settings = AppSettings(
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    signature: 'Dana Ruiz',
    signReplies: true,
  );
  await tester.pumpWidget(
    RepaintBoundary(
      key: _frame,
      // A 1px black edge, painted over the app rather than around it so
      // the screen keeps its size, keeps the mostly-white pictures from
      // disappearing into a white page.
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(border: Border.all()),
        child: RestmailApp(state: state),
      ),
    ),
  );
  await _shot(tester, '01-welcome$suffix');

  await tester.tap(find.text('Add an account'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), FakeAccounts.email);
  await tester.pump(const Duration(milliseconds: 600));
  await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
  await _shot(tester, '02-sign-in$suffix');

  await tester.tap(find.text('Continue'));
  await _shot(tester, '03-inbox$suffix');

  tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
  await _shot(tester, '04-folders$suffix');
  await tester.tap(find.text('Settings'));
  await _shot(tester, '05-settings$suffix');
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Re: sync latency on flaky networks'));
  await _shot(tester, '06-message$suffix');
  await tester.tap(find.text('Reply'));
  await _shot(tester, '07-reply$suffix');
  await tester.tap(find.byTooltip('Close'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();

  const newsletter = 'Issue 742: the case against background sync';
  await tester.scrollUntilVisible(
    find.text(newsletter),
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(find.text(newsletter));
  await _shot(tester, '08-html-message$suffix');
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();

  await tester.tap(find.byTooltip('Search'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'latency');
  await tester.pump(const Duration(milliseconds: 500));
  await _shot(tester, '09-search$suffix');
  await tester.tap(find.text('Done'));
  await tester.pumpAndSettle();

  // A second account, added from Settings. Its domain has no server of its
  // own, so the server is chosen by hand.
  tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
  await tester.pumpAndSettle();
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Add an account'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), FakeAccounts.otherEmail);
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Configure manually'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), FakeAccounts.host);
  await tester.testTextInput.receiveAction(TextInputAction.go);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Use this server'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
  await tester.pump();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
  await _shot(tester, '10-accounts$suffix');
  await tester.tap(find.text('Settings'));
  await _shot(tester, '11-accounts-settings$suffix');

  // An administrator beside them, which opens on Administration.
  await tester.tap(find.text('Add an account'));
  await tester.pumpAndSettle();
  final administrator = find.text('Sign in as an administrator');
  await tester.ensureVisible(administrator);
  await tester.pumpAndSettle();
  await tester.tap(administrator);
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byType(TextField).at(1),
    FakeAccounts.adminUsername,
  );
  await tester.enterText(
    find.byType(TextField).at(2),
    FakeAccounts.adminPassword,
  );
  await tester.pump();
  await tester.tap(find.text('Sign in'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(3), FakeAccounts.totpCode);
  await _shot(tester, '12-admin-sign-in$suffix');
  await tester.tap(find.text('Sign in'));
  await _shot(tester, '13-administration$suffix');
  await tester.tap(find.text('Outbound queue'));
  await _shot(tester, '14-queue$suffix');
  await tester.tap(find.text('tom@ryeworks.test'));
  await _shot(tester, '15-queue-entry$suffix');
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Domains'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(FakeAccounts.host));
  await _shot(tester, '16-domain$suffix');
  await tester.tap(find.text('Mailboxes'));
  await _shot(tester, '17-mailboxes$suffix');
  await tester.tap(find.text(FakeAccounts.email));
  await _shot(tester, '18-mailbox$suffix');
  for (var i = 0; i < 4; i++) {
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.text('Administrators'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(FakeAccounts.queueWatcher));
  await _shot(tester, '19-administrator$suffix');
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Bans'));
  await _shot(tester, '20-bans$suffix');
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Overview'));
  await _shot(tester, '21-overview$suffix');

  await tester.pumpWidget(const SizedBox());
  state.dispose();
  fake.close();
  await tester.pump(const Duration(seconds: 5));
}

void main() {
  setUpAll(() async {
    EditableText.debugDeterministicCursor = true;
    await _loadFonts();
  });

  testWidgets('light', (tester) => _tour(tester, dark: false));
  testWidgets('dark', (tester) => _tour(tester, dark: true));
}
