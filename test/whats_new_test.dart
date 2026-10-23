import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/settings.dart';
import 'package:restmail/state/whats_new.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/theme/theme.dart';
import 'package:restmail/ui/whats_new_screen.dart';

class _HistoryService extends WhatsNewService {
  _HistoryService(this.cached, this.result);
  final WhatsNewHistory? cached;
  final Future<WhatsNewHistory?> result;

  @override
  Future<WhatsNewHistory?> readCache() async => cached;

  @override
  Future<WhatsNewHistory?> load({bool refresh = false}) => result;
}

WhatsNewHistory _history(int latest) => WhatsNewHistory.fromJson({
  'schema': 1,
  'releases': [
    for (var n = 1; n <= latest; n++)
      {'tag_name': 'v0.3.$n', 'name': 'Release $n', 'body': 'Changes for $n.'},
  ],
});

void main() {
  test('a GitHub release body becomes a title, summary and items', () {
    final notes = parseRelease(
      version: '0.3.69',
      name: 'rest-mail 0.3.69',
      body:
          'A small release with a clearer shell.\n\n'
          '## What\'s Changed\n'
          '* feat: app settings apart from mailbox settings by @chris in '
          'https://github.com/rest-mail/rest-mail-mobile/pull/89\n'
          '* fix: the header brand mark by @chris in '
          'https://github.com/rest-mail/rest-mail-mobile/pull/90\n\n'
          '**Full Changelog**: https://github.com/rest-mail/rest-mail-mobile/'
          'compare/v0.3.68...v0.3.69',
    );

    expect(notes.title, 'rest-mail 0.3.69');
    expect(notes.summary, 'A small release with a clearer shell.');
    expect(notes.items, hasLength(2));
    expect(notes.items.first.number, 89);
    expect(
      notes.items.first.title,
      'feat: app settings apart from mailbox settings',
    );
    expect(notes.items.last.number, 90);
  });

  test('the version shown as seen survives storage', () {
    final back = AppSettings.decode(
      const AppSettings().copyWith(lastSeenVersion: '0.3.69').encode(),
    );
    expect(back.lastSeenVersion, '0.3.69');
  });

  testWidgets('the screen shows the notes and closes where it is told', (
    tester,
  ) async {
    var closed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(ThemePack.classic, Brightness.light),
        home: WhatsNewScreen(
          notes: const WhatsNewNotes(
            version: '0.3.69',
            title: 'A clearer shell',
            summary: 'Mailboxes and settings are easier to reach.',
            items: [
              WhatsNewItem(
                number: 89,
                title: 'App settings apart from mailbox settings',
              ),
              WhatsNewItem(number: 90, title: 'The header brand mark'),
            ],
          ),
          onClose: () => closed = true,
        ),
      ),
    );

    expect(find.text('A clearer shell'), findsOneWidget);
    expect(
      find.text('Mailboxes and settings are easier to reach.'),
      findsOneWidget,
    );
    expect(find.text('#89'), findsOneWidget);
    expect(
      find.text('App settings apart from mailbox settings'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Close'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Close'));
    expect(closed, isTrue);
  });

  testWidgets('latest appears first and older releases are labelled previous '
      'versions', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(ThemePack.classic, Brightness.light),
        home: WhatsNewScreen(history: _history(3), onClose: () {}),
      ),
    );
    expect(find.text('LATEST RELEASE'), findsOneWidget);
    expect(find.text('PREVIOUS VERSIONS'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Release 3')).dy,
      lessThan(tester.getTopLeft(find.text('PREVIOUS VERSIONS')).dy),
    );
    expect(
      tester.getTopLeft(find.text('PREVIOUS VERSIONS')).dy,
      lessThan(tester.getTopLeft(find.text('Release 2')).dy),
    );
    await tester.scrollUntilVisible(find.text('Release 1'), 180);
    expect(find.text('Release 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the ten releases remain readable on a narrow phone and close '
      'after the oldest entry', (tester) async {
    tester.view.physicalSize = const Size(960, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    var closed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(ThemePack.classic, Brightness.light),
        home: WhatsNewScreen(
          history: _history(12),
          onClose: () => closed = true,
        ),
      ),
    );
    expect(find.text('Release 12'), findsOneWidget);
    for (var n = 11; n >= 3; n--) {
      await tester.scrollUntilVisible(find.text('Release $n'), 180);
      expect(find.text('Release $n'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Release 2'), findsNothing);
    expect(find.text('Release 1'), findsNothing);
    await tester.scrollUntilVisible(find.text('Close'), 180);
    await tester.tap(find.text('Close'));
    expect(closed, isTrue);
  });

  testWidgets('cached notes stay readable while the latest history loads', (
    tester,
  ) async {
    final result = Completer<WhatsNewHistory?>();
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(ThemePack.classic, Brightness.light),
        home: WhatsNewScreen(
          service: _HistoryService(_history(1), result.future),
          onClose: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Release 1'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    result.complete(_history(2));
    await tester.pumpAndSettle();
    expect(find.text('Release 2'), findsOneWidget);
    expect(find.text('PREVIOUS VERSIONS'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Release 2')).dy,
      lessThan(tester.getTopLeft(find.text('Release 1')).dy),
    );
  });
}
