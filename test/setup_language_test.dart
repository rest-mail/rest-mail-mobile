import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

Future<AppState> _german(WidgetTester tester, http.Client client) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final state = AppState(
    store: MemoryKeyValueStore(),
    httpClientFactory: () => client,
  );
  await state.start();
  await state.updateSettings(state.settings.copyWith(languageCode: 'de'));
  await tester.pumpWidget(RestmailApp(state: state));
  await tester.pumpAndSettle();
  return state;
}

Future<void> _tap(WidgetTester tester, String label) async {
  final button = find.text(label);
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('setting up a new server speaks German', (tester) async {
    final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
    final state = await _german(tester, fake.client);

    await _tap(tester, 'Neuen Server einrichten');
    await tester.enterText(find.byType(TextField), FakeAccounts.host);
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    await _tap(tester, 'Diesen Server verwenden');

    expect(find.text('Schritt 1 von 3'), findsOneWidget);
    expect(find.text('${FakeAccounts.host} einrichten'), findsOneWidget);
    expect(find.text('QR-Code scannen'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsNothing);
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeAccounts.bootstrapPassword,
    );
    await tester.pump();
    await _tap(tester, 'Weiter');

    expect(find.text('Schritt 2 von 3'), findsOneWidget);
    expect(find.text('Zwei-Faktor-Anmeldung'), findsOneWidget);
    await _tap(tester, 'Authenticator einrichten');
    expect(find.text('Authenticator-App öffnen'), findsOneWidget);
    expect(find.text('WIEDERHERSTELLUNGSCODES'), findsOneWidget);
    expect(
      find.text('Ich habe meine Wiederherstellungscodes gespeichert'),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('adding other mail speaks German', (tester) async {
    await _german(tester, MockClient((_) async => http.Response('', 404)));
    await _tap(tester, 'Konto hinzufügen');
    await _tap(tester, 'Andere Mail (IMAP)');
    expect(find.text('Andere Mail'), findsOneWidget);
    expect(find.text('Other mail'), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'ada@gmail.com');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('Gmail braucht ein App-Passwort'), findsOneWidget);
    expect(
      find.text('Bestätigung in zwei Schritten einschalten'),
      findsOneWidget,
    );
    expect(find.text('APP-PASSWORT'), findsOneWidget);
  });
}
