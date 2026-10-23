import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('the message view speaks the language the app is set to', (
    tester,
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
    await tester.pumpWidget(RestmailApp(state: state));

    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), FakeAccounts.email);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Re: sync latency on flaky networks'));
    await tester.pumpAndSettle();
    expect(find.text('Reply'), findsOneWidget);
    expect(find.text('Reply all'), findsOneWidget);
    expect(find.textContaining('to me'), findsOneWidget);

    await state.updateSettings(state.settings.copyWith(languageCode: 'de'));
    await tester.pumpAndSettle();

    // The actions, the header and the attachment.
    expect(find.text('Reply'), findsNothing);
    expect(find.text('Antworten'), findsOneWidget);
    expect(find.text('Allen antworten'), findsOneWidget);
    expect(find.byTooltip('Zurück'), findsOneWidget);
    expect(find.byTooltip('Weiterleiten'), findsOneWidget);
    expect(find.textContaining('an mich'), findsOneWidget);
    expect(find.textContaining('Cc '), findsOneWidget);

    // The menu.
    await tester.tap(find.byTooltip('Mehr'));
    await tester.pumpAndSettle();
    expect(find.text('Als ungelesen markieren'), findsOneWidget);
    expect(find.text('Kennzeichnen'), findsOneWidget);
    expect(find.text('In Spam verschieben'), findsOneWidget);

    // The note sheet.
    await tester.tap(find.text('Notiz hinzufügen'));
    await tester.pumpAndSettle();
    expect(find.text('Private Notiz'), findsOneWidget);
    expect(find.text('Notiz schreiben…'), findsOneWidget);
    expect(find.text('Speichern'), findsOneWidget);
    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();

    // And what deleting it says, with its Undo.
    await tester.tap(find.byTooltip('Löschen'));
    await tester.pumpAndSettle();
    expect(find.text('In den Papierkorb verschoben'), findsOneWidget);
    expect(find.text('Rückgängig'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
