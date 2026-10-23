import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('a server that cannot be reached is said so in Spanish', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => MockClient(
        (_) async => throw http.ClientException('Connection refused'),
      ),
    );
    await state.start();
    await state.updateSettings(state.settings.copyWith(languageCode: 'es'));
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Introducir la dirección de un servidor'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Atrás'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);

    await tester.enterText(find.byType(TextField), 'mail.unreachable.test');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    expect(
      find.text('No se puede conectar con mail.unreachable.test.'),
      findsOneWidget,
    );
    expect(find.textContaining("Can't reach"), findsNothing);
  });
}
