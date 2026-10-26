import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/app.dart';
import 'package:restmail/imap/oauth.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/imap_account_screen.dart';

/// The setup screen's own list, not the screen under it or a text field.
final _setupList = find
    .descendant(
      of: find.byType(ImapAccountScreen),
      matching: find.byType(Scrollable),
    )
    .first;

/// A build given client ids for both, as `--dart-define` would.
final _clients = OAuthClients(
  microsoft: OAuthProvider.microsoft('ms-client'),
  google: OAuthProvider.google(
    'g-client.apps.googleusercontent.com',
    redirectUri: OAuthProvider.googleAndroidRedirect,
  ),
);

Future<AppState> _app(
  WidgetTester tester, {
  OAuthClients oauth = OAuthClients.none,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final state = AppState(
    store: MemoryKeyValueStore(),
    httpClientFactory: () => MockClient((_) async => http.Response('', 404)),
    oauth: oauth,
  );
  await state.start();
  await tester.pumpWidget(RestmailApp(state: state));
  await tester.pumpAndSettle();
  return state;
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('a Gmail address is recognised and set up with an app '
      'password, step by step', (tester) async {
    await _app(tester);
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'ada@gmail.com');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // No REST Mail server is looked for, and no Google password asked for.
    expect(find.text('Gmail'), findsOneWidget);
    expect(find.text('Password'), findsNothing);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Gmail needs an app password'), findsOneWidget);
    expect(find.text('Turn on 2-Step Verification'), findsOneWidget);
    expect(find.text('Make an app password'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('APP PASSWORD'),
      150,
      scrollable: _setupList,
    );
    expect(find.text('APP PASSWORD'), findsOneWidget);
    final servers = find.text('imap.gmail.com · smtp.gmail.com');
    await tester.scrollUntilVisible(servers, 200, scrollable: _setupList);
    expect(servers, findsOneWidget);
    // A build with no Google client offers no Google sign-in.
    final add = find.text('Add account');
    await tester.scrollUntilVisible(add, 200, scrollable: _setupList);
    expect(add, findsOneWidget);
    expect(find.text('Sign in with Google (personal use)'), findsNothing);
  });

  testWidgets('with a Google client, Gmail still sets up with an app '
      'password, and Sign in with Google is offered under it, for personal '
      'use', (tester) async {
    await _app(tester, oauth: _clients);
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'ada@gmail.com');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Gmail needs an app password'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('APP PASSWORD'),
      150,
      scrollable: _setupList,
    );
    expect(find.text('APP PASSWORD'), findsOneWidget);
    final note = find.textContaining('For personal use only.');
    await tester.scrollUntilVisible(note, 200, scrollable: _setupList);
    expect(note, findsOneWidget);
    expect(find.text('Sign in with Google (personal use)'), findsOneWidget);
    expect(find.textContaining('at most 100 people'), findsOneWidget);
    expect(find.text('Add account'), findsOneWidget);
  });

  testWidgets('with a Microsoft client, Outlook.com signs in with Microsoft '
      'and asks for no password', (tester) async {
    await _app(tester, oauth: _clients);
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'ada@outlook.com');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Added over IMAP and SMTP, signed in with Microsoft. Continue to set '
        'it up.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Outlook.com signs in with Microsoft'), findsOneWidget);
    expect(find.text('Outlook.com needs Microsoft sign-in'), findsNothing);
    expect(find.text('PASSWORD'), findsNothing);
    expect(find.text('APP PASSWORD'), findsNothing);
    final button = find.text('Sign in with Microsoft');
    await tester.scrollUntilVisible(button, 200, scrollable: _setupList);
    expect(button, findsOneWidget);
    expect(find.text('Add account'), findsNothing);
  });

  testWidgets('Other mail (IMAP): Outlook.com says it needs Microsoft '
      'sign-in, and anything unknown asks for its servers', (tester) async {
    await _app(tester);
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other mail (IMAP)'));
    await tester.pumpAndSettle();
    expect(find.text('Other mail'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'ada@outlook.com');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Outlook.com needs Microsoft sign-in'), findsOneWidget);
    expect(find.text('APP PASSWORD'), findsNothing);
    // A build with no Microsoft client has no button for it.
    expect(find.text('Sign in with Microsoft'), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'ada@nowhere.example');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    final notFound = find.textContaining("Couldn't find the servers");
    await tester.scrollUntilVisible(notFound, 200, scrollable: _setupList);
    expect(find.text('IMAP SERVER (TLS)'), findsOneWidget);
    expect(find.text('imap.nowhere.example'), findsOneWidget);
    final check = find.text('Check connection');
    await tester.scrollUntilVisible(check, 200, scrollable: _setupList);
    expect(check, findsOneWidget);
  });
}
