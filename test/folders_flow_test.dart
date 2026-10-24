import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// Folders made, renamed and deleted from Mailboxes, against the fake.
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

  /// Mailboxes → Edit, beside the folders' heading.
  Future<void> openFolders(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Manage folders'));
    await tester.pumpAndSettle();
  }

  Future<void> enterName(WidgetTester tester, String name) async {
    await tester.enterText(find.byType(TextField).first, name);
    await tester.pump();
  }

  testWidgets('a folder is made, renamed and deleted', (tester) async {
    final (fake, state) = await open(tester);
    await openFolders(tester);
    expect(find.text('YOUR FOLDERS'), findsOneWidget);
    expect(find.text('Receipts'), findsOneWidget);
    expect(find.text('STANDARD FOLDERS'), findsOneWidget);
    expect(find.text("These can't be renamed or deleted."), findsOneWidget);

    await tap(tester, 'New');
    expect(find.text('New folder'), findsOneWidget);
    // The server's name rule, and a name the account has, INBOX in any case.
    await enterName(tester, 'Work/../Receipts');
    await tap(tester, 'Save');
    expect(find.textContaining("That name can't be used."), findsOneWidget);
    await enterName(tester, 'inbox');
    await tap(tester, 'Save');
    expect(
      find.text('There is already a folder with that name.'),
      findsOneWidget,
    );
    await enterName(tester, 'Projects');
    await tap(tester, 'Save');
    expect(find.text('Folder created'), findsOneWidget);
    await settleToast(tester);
    expect(find.text('Projects'), findsOneWidget);

    // Renamed, its mail goes with it; onto another folder or a standard
    // one, it is refused.
    await tap(tester, 'Receipts');
    expect(find.text('Folder'), findsOneWidget);
    await enterName(tester, 'Projects');
    await tap(tester, 'Save');
    expect(
      find.text('There is already a folder with that name.'),
      findsOneWidget,
    );
    await enterName(tester, 'Sent');
    await tap(tester, 'Save');
    expect(find.text("That is a standard folder's name."), findsOneWidget);
    await enterName(tester, 'Paid');
    await tap(tester, 'Save');
    expect(find.text('Folder renamed'), findsOneWidget);
    await settleToast(tester);
    expect(fake.messagesIn(FakeAccounts.email, 'Paid'), hasLength(1));
    expect(fake.messagesIn(FakeAccounts.email, 'Receipts'), isEmpty);
    expect(find.text('Receipts'), findsNothing);

    await tap(tester, 'Paid');
    await tap(tester, 'Delete folder');
    expect(find.text('Delete Paid?'), findsOneWidget);
    expect(
      find.text('The folder and every message in it are deleted for good.'),
      findsOneWidget,
    );
    await tap(tester, 'Delete');
    expect(find.text('Folder deleted'), findsOneWidget);
    await settleToast(tester);
    expect(fake.messagesIn(FakeAccounts.email, 'Paid'), isEmpty);
    expect(find.text('Paid'), findsNothing);
    expect(state.mailbox!.folders.map((f) => f.name), contains('Projects'));

    await close(tester, fake, state);
  });

  testWidgets('the folder on screen is followed when renamed, '
      'and the inbox opens when it is deleted', (tester) async {
    final (fake, state) = await open(tester);
    final mailbox = state.mailbox!;
    await mailbox.selectFolder('Receipts');
    await tester.pumpAndSettle();
    await openFolders(tester);

    await tap(tester, 'Receipts');
    await enterName(tester, 'Old receipts');
    await tap(tester, 'Save');
    await settleToast(tester);
    expect(mailbox.folder, 'Old receipts');
    expect(mailbox.messages, hasLength(1));

    await tap(tester, 'Old receipts');
    await tap(tester, 'Delete folder');
    await tap(tester, 'Delete');
    await settleToast(tester);
    expect(mailbox.folder, 'INBOX');

    await close(tester, fake, state);
  });

  testWidgets('a standard folder opens nothing to change', (tester) async {
    final (fake, state) = await open(tester);
    await openFolders(tester);
    await tap(tester, 'Inbox');
    expect(find.text('Folder'), findsNothing);
    expect(find.text('Delete folder'), findsNothing);
    expect(find.text('STANDARD FOLDERS'), findsOneWidget);

    await close(tester, fake, state);
  });
}
