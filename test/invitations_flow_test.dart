import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// Invitations in a message, answered there, and listed from Mailboxes,
/// against the fake.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  const organizer = 'ada@example.test';

  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester,
    void Function(FakeRestmail fake) mail,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    mail(fake);
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

  testWidgets('an invitation is answered from its message', (tester) async {
    final (fake, state) = await open(
      tester,
      (fake) => fake.invite(
        to: FakeAccounts.email,
        from: organizer,
        summary: 'Engine review',
        location: 'Room 4',
      ),
    );
    await tap(tester, 'Invitation: Engine review');
    expect(find.text('Invitation'), findsOneWidget);
    expect(find.text('Room 4'), findsOneWidget);
    expect(find.text('From $organizer'), findsOneWidget);

    await tap(tester, 'Accept');
    expect(find.text('Reply sent to $organizer'), findsOneWidget);
    expect(find.text('You accepted.'), findsOneWidget);
    final reply = fake.messagesIn(FakeAccounts.email, 'Sent').last;
    expect(reply.subject, 'Accepted: Engine review');
    expect(reply.to.single.address, organizer);

    await close(tester, fake, state);
  });

  testWidgets('a cancellation says so, with nothing to answer', (tester) async {
    final (fake, state) = await open(
      tester,
      (fake) => fake.invite(
        to: FakeAccounts.email,
        from: organizer,
        summary: 'Engine review',
        method: 'CANCEL',
        sequence: 1,
      ),
    );
    await tap(tester, 'Cancelled: Engine review');
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('The organizer called this event off.'), findsOneWidget);
    expect(find.text('Accept'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('Invitations lists each event once and opens its message', (
    tester,
  ) async {
    final (fake, state) = await open(tester, (fake) {
      fake
        ..invite(
          to: FakeAccounts.email,
          from: organizer,
          summary: 'Engine review',
        )
        ..invite(
          to: FakeAccounts.email,
          from: organizer,
          summary: 'Engine review, moved',
          sequence: 1,
        );
    });
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Invitations'),
      200,
      scrollable: find
          .ancestor(
            of: find.text('Quarantine'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tap(tester, 'Invitations');
    expect(find.text('Engine review, moved'), findsOneWidget);
    expect(find.text('2 versions'), findsOneWidget);

    await tap(tester, 'Engine review, moved');
    expect(find.text('Invitation'), findsOneWidget);

    await close(tester, fake, state);
  });
}
