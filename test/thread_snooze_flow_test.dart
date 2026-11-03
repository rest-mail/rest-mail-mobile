import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/imap/imap_backend.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/mail_backend.dart';
import 'package:restmail/state/mailbox_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/thread_snooze_sheet.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

const _description =
    'Hide this thread from folders until the chosen time. Search can still '
    'find it. Times use your local time zone.';

/// Lets the fake answer unless a test wants the snooze route refused, as a
/// server without it would.
class _Gate extends http.BaseClient {
  _Gate(this.inner);

  final http.Client inner;
  http.StreamedResponse Function()? refuse;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/snooze')) {
      if (refuse case final answer?) return answer();
    }
    return inner.send(request);
  }
}

http.StreamedResponse _refusal(int status, String body) =>
    http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      status,
      headers: {'content-type': 'application/json'},
    );

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  late DateTime now;
  late FakeRestmail fake;
  late _Gate gate;
  late AppState state;

  /// Signs in with a thread of two messages and another message, on the inbox.
  Future<void> open(WidgetTester tester, {String language = 'en'}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    now = DateTime.now();
    fake = FakeRestmail(scenario: FakeScenario.empty, clock: () => now);
    fake
      ..deliver(
        to: FakeAccounts.email,
        from: 'sender@example.test',
        subject: 'Older in thread',
        threadId: 'thread/1',
      )
      ..deliver(
        to: FakeAccounts.email,
        from: 'sender@example.test',
        subject: 'Newer in thread',
        threadId: 'thread/1',
      )
      ..deliver(
        to: FakeAccounts.email,
        from: 'other@example.test',
        subject: 'Something else',
      );
    gate = _Gate(fake.client);
    state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => gate,
    );
    await state.start();
    await state.updateSettings(state.settings.copyWith(languageCode: language));
    await state.signIn(
      server: Uri.parse('https://${fake.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  Future<RestmailClient> secondDevice() async {
    final client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    return client;
  }

  Future<void> openSheet(WidgetTester tester) async {
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Snooze'));
    await tester.pumpAndSettle();
  }

  /// Takes the pickers' defaults: an hour from now, or the current deadline.
  Future<void> pickTime(WidgetTester tester) async {
    await tester.tap(find.text('Return at'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  Future<void> tapSnooze(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(RmPrimaryButton, 'Snooze thread'));
    await tester.pumpAndSettle();
  }

  testWidgets('snoozing from a folder hides the thread, and its return brings '
      'it back without a refresh', (tester) async {
    await open(tester);
    final inbox = fake.messagesIn(FakeAccounts.email, 'INBOX');
    await tester.tap(find.text('Newer in thread').last);
    await tester.pumpAndSettle();

    await openSheet(tester);
    expect(find.text('Snooze thread'), findsWidgets);
    expect(find.text(_description), findsOneWidget);
    expect(find.textContaining('Snoozed until'), findsNothing);
    expect(find.text('Cancel snooze'), findsNothing);
    final submit = tester.widget<RmPrimaryButton>(
      find.widgetWithText(RmPrimaryButton, 'Snooze thread'),
    );
    expect(submit.onPressed, isNull, reason: 'webmail requires a time');

    await pickTime(tester);
    await tapSnooze(tester);

    expect(find.text('Thread snoozed'), findsOneWidget);
    expect(find.text('Something else'), findsOneWidget);
    expect(find.text('Newer in thread'), findsNothing);
    expect(find.text('Older in thread'), findsNothing);
    expect(
      fake.messagesIn(FakeAccounts.email, 'INBOX'),
      hasLength(inbox.length),
      reason: 'snoozing never deletes',
    );
    final mailbox = state.mailbox!;
    expect(
      mailbox.folders.firstWhere((f) => f.name == 'INBOX').total,
      1,
      reason: 'the count hides the thread too',
    );

    now = now.add(const Duration(hours: 2));
    fake.returnSnoozedThreads();
    await tester.pumpAndSettle();

    expect(find.text('Newer in thread'), findsOneWidget);
    expect(find.text('Older in thread'), findsOneWidget);
    expect(mailbox.folders.firstWhere((f) => f.name == 'INBOX').total, 3);
    await close(tester);
  });

  testWidgets('a second device follows, without a refresh', (tester) async {
    await open(tester);
    final other = await secondDevice();
    addTearDown(other.close);
    final accountId = state.mailbox!.account!.id;
    final deadline = DateTime.now().add(const Duration(hours: 1));

    await tester.runAsync(
      () => other.snoozeThread(accountId, 'thread/1', deadline),
    );
    await tester.pumpAndSettle();
    expect(find.text('Newer in thread'), findsNothing);
    expect(find.text('Something else'), findsOneWidget);

    await tester.runAsync(
      () => other.snoozeThread(accountId, 'thread/1', null),
    );
    await tester.pumpAndSettle();
    expect(find.text('Newer in thread'), findsOneWidget);
    await close(tester);
  });

  testWidgets('a reader open from a folder closes when another device snoozes '
      'its thread', (tester) async {
    await open(tester);
    final other = await secondDevice();
    addTearDown(other.close);
    await tester.tap(find.text('Newer in thread').last);
    await tester.pumpAndSettle();
    expect(find.byTooltip('More'), findsOneWidget);

    await tester.runAsync(
      () => other.snoozeThread(
        state.mailbox!.account!.id,
        'thread/1',
        DateTime.now().add(const Duration(hours: 1)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('More'), findsNothing);
    expect(find.text('Newer in thread'), findsNothing);
    await close(tester);
  });

  testWidgets('another thread\'s snooze leaves the reader alone', (
    tester,
  ) async {
    await open(tester);
    final other = await secondDevice();
    addTearDown(other.close);
    await tester.tap(find.text('Newer in thread').last);
    await tester.pumpAndSettle();
    final elsewhere = fake
        .messagesIn(FakeAccounts.email, 'INBOX')
        .firstWhere((m) => m.subject == 'Something else');
    await tester.runAsync(
      () => other.snoozeThread(
        state.mailbox!.account!.id,
        elsewhere.threadId!,
        DateTime.now().add(const Duration(hours: 1)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('More'), findsOneWidget);
    await close(tester);
  });

  testWidgets('search still finds it, where the deadline shows and can be '
      'changed and cancelled', (tester) async {
    await open(tester);
    final accountId = state.mailbox!.account!.id;
    // Further off than the picker reaches by itself: webmail can set this.
    final deadline = DateTime.utc(2099, 1, 1, 10);
    final other = await secondDevice();
    addTearDown(other.close);
    await tester.runAsync(
      () => other.snoozeThread(accountId, 'thread/1', deadline),
    );
    await tester.pumpAndSettle();
    expect(find.text('Newer in thread'), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'Newer');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Newer in thread'), findsOneWidget);

    await tester.tap(find.text('Newer in thread'));
    await tester.pumpAndSettle();
    await openSheet(tester);
    expect(find.textContaining('Snoozed until'), findsOneWidget);

    // Changing it keeps the reader open: search can still see the thread.
    await pickTime(tester);
    await tapSnooze(tester);
    expect(find.text('Thread snoozed'), findsOneWidget);
    expect(find.byTooltip('More'), findsOneWidget);
    expect(
      fake
          .messagesIn(FakeAccounts.email, 'INBOX')
          .firstWhere((m) => m.subject == 'Newer in thread')
          .snoozedUntil,
      isNotNull,
    );

    await openSheet(tester);
    expect(find.textContaining('Snoozed until'), findsOneWidget);
    await tester.tap(find.text('Cancel snooze'));
    await tester.pumpAndSettle();
    expect(find.text('Snooze cancelled'), findsOneWidget);
    expect(find.byTooltip('More'), findsOneWidget);
    expect(
      fake
          .messagesIn(FakeAccounts.email, 'INBOX')
          .firstWhere((m) => m.subject == 'Newer in thread')
          .snoozedUntil,
      isNull,
    );

    await openSheet(tester);
    expect(find.textContaining('Snoozed until'), findsNothing);
    expect(find.text('Cancel snooze'), findsNothing);
    await close(tester);
  });

  for (final (name, status, body, shown) in [
    ('without the route', 404, '<html>404</html>', 'Could not snooze thread'),
    (
      'without the route, in its own words',
      404,
      '{"error":{"code":"not_found","message":"Not found"}}',
      'Not found',
    ),
    (
      'that refuses the time',
      422,
      '{"error":{"code":"validation_failed","message":"Request body failed validation"}}',
      'Request body failed validation',
    ),
  ]) {
    testWidgets('a server $name shows why and leaves everything be', (
      tester,
    ) async {
      await open(tester);
      gate.refuse = () => _refusal(status, body);
      await tester.tap(find.text('Newer in thread').last);
      await tester.pumpAndSettle();
      await openSheet(tester);
      await pickTime(tester);
      await tapSnooze(tester);

      expect(find.text(shown), findsOneWidget);
      expect(find.text('Thread snoozed'), findsNothing);
      expect(find.text(_description), findsOneWidget, reason: 'still open');

      // Closing the sheet leaves the reader and the thread where they were.
      await tester.tapAt(const Offset(195, 30));
      await tester.pumpAndSettle();
      expect(find.byTooltip('More'), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Newer in thread'), findsOneWidget);
      expect(
        fake
            .messagesIn(FakeAccounts.email, 'INBOX')
            .every((m) => m.snoozedUntil == null),
        isTrue,
      );
      await close(tester);
    });
  }

  testWidgets('a message with no thread cannot be snoozed', (tester) async {
    await open(tester);
    fake
            .messagesIn(FakeAccounts.email, 'INBOX')
            .firstWhere((m) => m.subject == 'Something else')
            .threadId =
        '';
    await tester.tap(find.text('Something else').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Snooze'));
    await tester.pumpAndSettle();
    expect(find.text(_description), findsNothing);
    await close(tester);
  });

  testWidgets('a time that has passed is refused here, in webmail\'s words', (
    tester,
  ) async {
    await open(tester);
    final mailbox = state.mailbox!;
    final message = await tester.runAsync(
      () => mailbox.backend.message(
        fake
            .messagesIn(FakeAccounts.email, 'INBOX')
            .firstWhere((m) => m.subject == 'Something else')
            .id,
      ),
    );
    var clock = DateTime.now();
    unawaited(
      Navigator.of(tester.element(find.text('Something else').last)).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: ThreadSnoozeSheet(
              mailbox: mailbox,
              message: message!,
              now: () => clock,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await pickTime(tester);
    clock = clock.add(const Duration(days: 2));
    await tapSnooze(tester);
    expect(find.text('Choose a time in the future'), findsOneWidget);
    expect(
      fake
          .messagesIn(FakeAccounts.email, 'INBOX')
          .firstWhere((m) => m.subject == 'Something else')
          .snoozedUntil,
      isNull,
    );
    await close(tester);
  });

  for (final (language, action, title) in [
    ('de', 'Zurückstellen', 'Unterhaltung zurückstellen'),
    ('ar', 'تأجيل', 'تأجيل المحادثة'),
  ]) {
    testWidgets('the words come from the $language pack, and fit', (
      tester,
    ) async {
      await open(tester, language: language);
      await tester.tap(find.text('Newer in thread').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      expect(find.text(title), findsWidgets);
      expect(find.text(_description), findsNothing);
      await close(tester);
    });
  }

  test('an IMAP account offers no snooze', () {
    final backend = ImapBackend(
      address: 'ada@example.test',
      displayName: 'Ada',
      password: 'secret',
      settings: const MailServerSettings(
        imapHost: 'imap.example.test',
        smtpHost: 'smtp.example.test',
      ),
      openSocket: (host, port, {required tls}) =>
          throw StateError('Asking about snooze opens no connection'),
    );
    expect(backend.canSnoozeThreads, isFalse);
    expect(
      () => backend.snoozeThread(1, 'thread', null),
      throwsA(isA<ApiException>()),
    );
  });

  group('the folder list', () {
    late FakeRestmail server;
    late RestmailClient client;
    late MailboxState mailbox;
    late DateTime clock;

    Future<void> settle() =>
        Future<void>.delayed(const Duration(milliseconds: 20));

    setUp(() async {
      clock = DateTime.now();
      server = FakeRestmail(scenario: FakeScenario.empty, clock: () => clock);
      client = RestmailClient(
        server: Uri.parse('https://${server.host}'),
        httpClient: server.client,
      );
      await client.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      mailbox = MailboxState(RestBackend(client));
    });
    tearDown(() {
      mailbox.dispose();
      client.close();
      server.close();
    });

    FakeMessage deliver(String subject, {String? thread}) {
      clock = clock.add(const Duration(seconds: 1));
      return server.deliver(
        to: FakeAccounts.email,
        from: 'sender@example.test',
        subject: subject,
        threadId: thread,
      );
    }

    test('keeps how far it was scrolled when an old thread returns', () async {
      final old = deliver('Old', thread: 'old');
      for (var i = 0; i < 60; i++) {
        deliver('Mail $i');
      }
      await mailbox.start();
      await settle();
      await mailbox.loadMore();
      expect(mailbox.messages, hasLength(61));

      await client.snoozeThread(
        mailbox.account!.id,
        'old',
        clock.add(const Duration(hours: 1)),
      );
      await settle();
      expect(mailbox.messages, hasLength(60));

      clock = clock.add(const Duration(hours: 2));
      server.returnSnoozedThreads();
      await settle();
      expect(mailbox.messages, hasLength(61));
      expect(mailbox.messages.last.id, old.id);
      expect(mailbox.hasMore, isFalse);
    });

    test('shows the server\'s state when the stream comes back', () async {
      final first = deliver('First', thread: 'first');
      await mailbox.start();
      await settle();
      expect(mailbox.messages.single.id, first.id);
      expect(mailbox.live, LiveStatus.live);

      // Hidden while the stream was down, with no event to say so: a server
      // restart loses what it would have replayed.
      server.close();
      await settle();
      expect(mailbox.live, LiveStatus.offline);
      await client.snoozeThread(
        mailbox.account!.id,
        'first',
        clock.add(const Duration(hours: 1)),
      );

      await Future<void>.delayed(const Duration(seconds: 2));
      expect(mailbox.live, LiveStatus.live);
      expect(mailbox.messages, isEmpty);
    });
  });
}
