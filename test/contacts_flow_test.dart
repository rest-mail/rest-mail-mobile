import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/compose_sheet.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  Future<void> close(
    WidgetTester tester,
    FakeRestmail fake,
    AppState state,
  ) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> tap(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  /// Lets a toast clear: it sits over the bottom of the screen.
  Future<void> settleToast(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  Future<void> openContacts(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tap(tester, 'Contacts');
  }

  testWidgets('a contact is added, trusted less, and deleted', (tester) async {
    final (fake, state) = await open(tester);
    await openContacts(tester);
    expect(find.text('No contacts yet.'), findsOneWidget);

    await tap(tester, 'Add');
    expect(find.text('New contact'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'Ada <ada@x.test>');
    await tester.enterText(find.byType(TextField).at(1), 'Ada Lovelace');
    await tester.pump();
    await tap(tester, 'Save');
    expect(
      find.text('Enter an address like name@example.com.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField).at(0), 'ada@example.test');
    await tester.pump();
    await tap(tester, 'Save');
    await settleToast(tester);

    expect(find.text('1 CONTACT'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('ada@example.test · Trusted'), findsOneWidget);
    expect(
      fake.contactsOf(FakeAccounts.email).single['trust_level'],
      'trusted',
    );

    // The same address again is refused.
    await tap(tester, 'Add');
    await tester.enterText(find.byType(TextField).at(0), 'ada@example.test');
    await tester.pump();
    await tap(tester, 'Save');
    expect(find.text('That address is already a contact.'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    await tap(tester, 'Ada Lovelace');
    await tap(tester, 'Automatic');
    await tap(tester, 'Save');
    await settleToast(tester);
    expect(find.text('ada@example.test · Automatic'), findsOneWidget);
    expect(fake.contactsOf(FakeAccounts.email).single['trust_level'], 'auto');

    await tap(tester, 'Ada Lovelace');
    await tap(tester, 'Delete contact');
    expect(find.text('Delete this contact?'), findsOneWidget);
    await tap(tester, 'Delete');
    await settleToast(tester);
    expect(fake.contactsOf(FakeAccounts.email), isEmpty);
    expect(find.text('No contacts yet.'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('contacts are searched and filtered by trust', (tester) async {
    final (fake, state) = await open(tester);
    fake
      ..addContact(FakeAccounts.email, 'nadia@oakline.test', name: 'Nadia')
      ..addContact(
        FakeAccounts.email,
        'tom@oakline.test',
        name: 'Tom',
        trustLevel: 'trusted',
      )
      ..addContact(
        FakeAccounts.email,
        'deals@spam.test',
        trustLevel: 'blocked',
      );
    await openContacts(tester);
    expect(find.text('3 CONTACTS'), findsOneWidget);

    // The filter, above the list, where "Blocked" is also a row's trust.
    await tester.tap(find.text('Blocked').first);
    await tester.pumpAndSettle();
    expect(find.text('1 CONTACT'), findsOneWidget);
    expect(find.text('deals@spam.test'), findsOneWidget);
    expect(find.text('Nadia'), findsNothing);

    await tap(tester, 'All');
    await tester.enterText(find.byType(TextField).first, 'oakline');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('2 CONTACTS'), findsOneWidget);
    expect(find.text('deals@spam.test'), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'nobody');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('No contacts match.'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('a sender is blocked from their message', (tester) async {
    final (fake, state) = await open(tester);
    await tap(tester, 'Re: sync latency on flaky networks');
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tap(tester, 'Block sender');
    expect(find.text('Block nadia@oakline.test?'), findsOneWidget);
    await tap(tester, 'Block');
    expect(find.text('Blocked nadia@oakline.test'), findsOneWidget);
    final blocked = fake.contactsOf(FakeAccounts.email).single;
    expect(blocked['email'], 'nadia@oakline.test');
    expect(blocked['trust_level'], 'blocked');
    await settleToast(tester);

    await close(tester, fake, state);
  });

  testWidgets('contacts are suggested in the address fields, '
      'the blocked left out', (tester) async {
    final (fake, state) = await open(tester);
    fake
      ..addContact(FakeAccounts.email, 'nadia@oakline.test', name: 'Nadia Osei')
      ..addContact(
        FakeAccounts.email,
        'nadia@deals.test',
        name: 'Nadia deals',
        trustLevel: 'blocked',
      );
    await tester.tap(find.byTooltip('New message'));
    await tester.pumpAndSettle();
    final to = find
        .descendant(
          of: find.byType(ComposeSheet),
          matching: find.byType(TextField),
        )
        .first;

    await tester.enterText(to, 'n');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.textContaining('nadia@oakline.test'), findsNothing);

    await tester.enterText(to, 'nad');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Nadia Osei · nadia@oakline.test'), findsOneWidget);
    expect(find.textContaining('nadia@deals.test'), findsNothing);

    await tester.tap(find.text('Nadia Osei · nadia@oakline.test'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(to).controller!.text,
      'Nadia Osei <nadia@oakline.test>, ',
    );
    expect(find.text('Nadia Osei · nadia@oakline.test'), findsNothing);

    // One already in the field is not offered again.
    await tester.enterText(to, 'Nadia Osei <nadia@oakline.test>, nad');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Nadia Osei · nadia@oakline.test'), findsNothing);

    await close(tester, fake, state);
  });
}
