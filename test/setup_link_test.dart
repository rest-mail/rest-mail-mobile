import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// The app opened with the installer's sign-in link starts setting that server
/// up, the sign-in already filled in.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  const password = FakeAccounts.bootstrapPassword;
  const address = FakeAccounts.adminEmail;
  final withServer = Uri.parse(
    'rest-mail://setup?server=https%3A%2F%2F${FakeAccounts.host}'
    '&address=$address&password=$password',
  );
  final withoutServer = Uri.parse(
    'rest-mail://setup?address=$address&password=$password',
  );
  final webLink = Uri.parse(
    'https://rest-mail.com/setup#server=https%3A%2F%2F${FakeAccounts.host}'
    '&address=$address&password=$password',
  );

  group('AppState.openLink', () {
    AppState newState() => AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => FakeRestmail().client,
    );

    test('a sign-in link waits, once', () {
      final state = newState();
      state.openLink(withServer);
      expect(state.pendingSetup?.password, password);
      expect(state.pendingSetup?.address, address);
      expect(state.pendingSetup?.server?.host, FakeAccounts.host);
      expect(state.takePendingSetup()?.password, password);
      expect(state.pendingSetup, isNull);
      // The same link again (at launch and from the stream) is not a second.
      state.openLink(withServer);
      expect(state.pendingSetup, isNull);
    });

    test('a web link is a sign-in link too', () {
      final state = newState();
      state.openLink(webLink);
      expect(state.pendingSetup?.password, password);
      expect(state.pendingSetup?.server?.host, FakeAccounts.host);
    });

    test('anything else is ignored', () {
      final state = newState();
      for (final link in [
        'rest-mail://reset?token=abc',
        'https://example.com/setup?password=$password',
        'https://rest-mail.com/#password=$password',
        // A setup code, from a server before rest-mail 0.7.
        'rest-mail://setup?token=7KQ2-M9XD-4TPA-HV3N-8RWC-ZB6E',
      ]) {
        state.openLink(Uri.parse(link));
      }
      expect(state.pendingSetup, isNull);
    });
  });

  Future<(FakeRestmail, AppState)> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    final button = find.text(label);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('a link naming the server opens its setup, signed in on a tap', (
    tester,
  ) async {
    final (fake, state) = await openApp(tester);
    state.openLink(withServer);
    await tester.pumpAndSettle();

    expect(find.text('Set up ${FakeAccounts.host}'), findsWidgets);
    expect(find.text(address), findsOneWidget);
    expect(find.text(password), findsOneWidget);

    // Nothing to type: the bootstrap account is signed in, and owes the rest.
    await tapButton(tester, 'Continue');
    expect(find.text('Step 2 of 3'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
  });

  testWidgets('a link naming no server asks which, then opens its setup', (
    tester,
  ) async {
    final (fake, state) = await openApp(tester);
    state.openLink(withoutServer);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), FakeAccounts.host);
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use this server'));
    await tester.pumpAndSettle();

    expect(find.text('Set up ${FakeAccounts.host}'), findsWidgets);
    expect(find.text(password), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
  });
}
