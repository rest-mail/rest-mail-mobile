import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/settings.dart';
import 'package:restmail/state/whats_new.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/theme/theme.dart';
import 'package:restmail/ui/whats_new_screen.dart';

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

    await tester.tap(find.text('Close'));
    expect(closed, isTrue);
  });
}
