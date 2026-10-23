import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('welcome and sign-in speak the language the app is set to', (
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
    await state.updateSettings(state.settings.copyWith(languageCode: 'es'));
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();

    // Welcome.
    expect(find.text('Add an account'), findsNothing);
    expect(find.text('Añadir una cuenta'), findsOneWidget);
    expect(find.text('Introducir la dirección de un servidor'), findsOneWidget);
    expect(find.text('Configurar un servidor nuevo'), findsOneWidget);

    // Sign-in, and what it says while it finds the server.
    await tester.tap(find.text('Añadir una cuenta'));
    await tester.pumpAndSettle();
    expect(find.text('Añadir cuenta'), findsOneWidget);
    expect(find.text('CORREO ELECTRÓNICO'), findsOneWidget);
    expect(find.text('Configurar manualmente'), findsOneWidget);
    expect(find.text('Otro correo (IMAP)'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), FakeAccounts.email);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('Encontrado ${FakeAccounts.host}'), findsOneWidget);
    expect(find.text('CONTRASEÑA'), findsOneWidget);

    // A wrong password.
    await tester.enterText(find.byType(TextField).at(1), 'not the password');
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Dirección o contraseña incorrecta.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
