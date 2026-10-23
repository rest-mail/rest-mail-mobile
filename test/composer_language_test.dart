import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/compose_sheet.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('the composer speaks the language the app is set to', (
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

    await state.updateSettings(state.settings.copyWith(languageCode: 'de'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Neue Nachricht'));
    await tester.pumpAndSettle();

    // The fields and the buttons.
    expect(find.text('Neue Nachricht'), findsOneWidget);
    expect(find.text('An'), findsOneWidget);
    expect(find.text('Betreff'), findsWidgets);
    expect(find.text('Senden'), findsOneWidget);
    expect(find.byTooltip('Schließen'), findsOneWidget);
    expect(find.text('Send'), findsNothing);

    // What sending without a recipient, or with a bad one, says.
    await tester.tap(find.text('Senden'));
    await tester.pump();
    expect(
      find.text('Füge jemanden hinzu, an den sie gehen soll.'),
      findsOneWidget,
    );
    await tester.enterText(
      find
          .descendant(
            of: find.byType(ComposeSheet),
            matching: find.byType(TextField),
          )
          .first,
      'nobody',
    );
    await tester.pump();
    await tester.tap(find.text('Senden'));
    await tester.pump();
    expect(find.text('Keine Adresse: nobody'), findsOneWidget);

    // Closing with something typed asks about the draft.
    await tester.tap(find.byTooltip('Schließen'));
    await tester.pumpAndSettle();
    expect(find.text('Als Entwurf behalten?'), findsOneWidget);
    expect(find.text('Weiter bearbeiten'), findsOneWidget);
    expect(find.text('Entwurf speichern'), findsOneWidget);
    await tester.tap(find.text('Verwerfen'));
    await tester.pumpAndSettle();
    expect(find.byType(ComposeSheet), findsNothing);

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
