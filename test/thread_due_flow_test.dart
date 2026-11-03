import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/thread_due_control.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

class _DueGate extends http.BaseClient {
  _DueGate(this.inner);
  final http.Client inner;
  final calls = <Map<String, dynamic>>[];
  Completer<void>? hold;
  int? status;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/due')) {
      calls.add(
        jsonDecode((request as http.Request).body) as Map<String, dynamic>,
      );
      await hold?.future;
      if (status case final code?) {
        return http.StreamedResponse(
          Stream.value(
            utf8.encode(
              code == 404
                  ? '404 page not found\n'
                  : '{"error":{"code":"refused","message":"Refused due date"}}',
            ),
          ),
          code,
          headers: {
            'content-type': code == 404 ? 'text/plain' : 'application/json',
          },
        );
      }
    }
    return inner.send(request);
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<
    ({
      AppState app,
      _DueGate gate,
      FakeRestmail fake,
      FakeMessage message,
      Future<void> Function() close,
    })
  >
  open(
    WidgetTester tester, {
    DateTime? due,
    int? status,
    bool pending = false,
    bool thread = true,
    String? source = 'user',
    DateTime? seedDue,
    String? seedSource,
    bool newerThread = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: FakeScenario.empty);
    final message =
        fake.deliver(
            to: FakeAccounts.email,
            from: 'sender@example.test',
            subject: 'Due fixture',
            body: 'Read this message',
          )
          ..threadId = thread ? 'due-thread' : ''
          ..due = due
          ..dueSource = due == null ? null : source;
    fake
            .deliver(
              to: FakeAccounts.email,
              from: 'sender@example.test',
              subject: 'Sibling fixture',
            )
            .threadId =
        'due-thread';
    if (newerThread) {
      fake.deliver(
        to: FakeAccounts.email,
        from: 'sender@example.test',
        subject: 'Newer fixture',
      );
    }
    if (seedDue != null) {
      fake.seedThreadDue(
        address: FakeAccounts.email,
        threadId: 'due-thread',
        due: seedDue,
        source: seedSource!,
      );
    }
    final gate = _DueGate(fake.client)
      ..status = status
      ..hold = pending ? Completer<void>() : null;
    final app = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => gate,
    );
    await app.start();
    await app.updateSettings(app.settings.copyWith(languageCode: 'en'));
    await app.signIn(
      server: Uri.parse('https://${fake.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: app));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Due fixture').last);
    await tester.pumpAndSettle();
    Future<void> close() async {
      await tester.pumpWidget(const SizedBox());
      app.dispose();
      if (gate.hold case final hold? when !hold.isCompleted) hold.complete();
      fake.close();
      await tester.pump(const Duration(seconds: 5));
    }

    return (app: app, gate: gate, fake: fake, message: message, close: close);
  }

  Future<void> choose(WidgetTester tester, {String? day}) async {
    await tester.tap(find.byKey(const ValueKey('threadDue.choose')));
    await tester.pumpAndSettle();
    if (day != null) await tester.tap(find.text(day).last);
    await tester.tap(find.text('OK').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK').last);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'empty reader can set a local date, show user source, update its thread and clear both fields',
    (tester) async {
      final fixture = await open(tester);
      final order = fixture.app.mailbox!.messages
          .map((message) => message.id)
          .toList();
      expect(find.text('Due date'), findsOneWidget);
      expect(find.textContaining('set by you'), findsNothing);
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Set due date'))
            .onPressed,
        isNull,
      );
      await choose(tester);
      await tester.tap(find.text('Set due date'));
      await tester.pumpAndSettle();
      expect(fixture.gate.calls.single['due_source'], 'user');
      final saved = DateTime.parse(fixture.gate.calls.single['due'] as String);
      expect(saved.isUtc, isTrue);
      expect(saved.toLocal().day, DateTime.now().day);
      expect(find.textContaining('set by you'), findsOneWidget);
      expect(find.byTooltip('Deadline set by you.'), findsOneWidget);
      expect(
        fixture.app.mailbox!.messages.every(
          (message) => message.due == saved && message.dueSource == 'user',
        ),
        isTrue,
      );
      expect(fixture.app.mailbox!.messages.map((message) => message.id), order);
      expect(fixture.app.mailbox!.folder, 'INBOX');
      await tester.tap(find.text('Clear due date'));
      await tester.pumpAndSettle();
      expect(fixture.gate.calls.last, {'due': null, 'due_source': 'user'});
      expect(find.textContaining('set by you'), findsNothing);
      expect(find.text('Clear due date'), findsNothing);
      expect(
        fixture.app.mailbox!.messages.every(
          (message) => message.due == null && message.dueSource == null,
        ),
        isTrue,
      );
      await fixture.close();
    },
  );

  testWidgets('saved reader changes date in local time and preserves source', (
    tester,
  ) async {
    final fixture = await open(tester, due: DateTime(2026, 12, 1, 10, 15));
    expect(find.textContaining('set by you'), findsOneWidget);
    await choose(tester, day: '2');
    await tester.tap(find.text('Set due date'));
    await tester.pumpAndSettle();
    expect(
      DateTime.parse(fixture.gate.calls.single['due'] as String),
      DateTime(2026, 12, 2, 10, 15).toUtc(),
    );
    expect(fixture.message.due, DateTime(2026, 12, 2, 10, 15).toUtc());
    await fixture.close();
  });

  for (final status in [403, 404, 422, 500]) {
    testWidgets(
      'HTTP $status retains the saved date and reader, including a server without the route',
      (tester) async {
        final original = DateTime(2026, 12, 1, 10, 15);
        final fixture = await open(tester, due: original, status: status);
        await tester.tap(find.text('Clear due date'));
        await tester.pumpAndSettle();
        expect(
          find.text(
            status == 404 ? 'Could not save due date' : 'Refused due date',
          ),
          findsOneWidget,
        );
        expect(find.textContaining('set by you'), findsOneWidget);
        expect(find.text('Read this message'), findsOneWidget);
        expect(fixture.message.due, original);
        expect(
          tester
              .widget<TextButton>(
                find.widgetWithText(TextButton, 'Clear due date'),
              )
              .onPressed,
          isNotNull,
        );
        await fixture.close();
      },
    );
  }

  testWidgets(
    'pending save disables controls and late completion after closing is harmless',
    (tester) async {
      final fixture = await open(
        tester,
        due: DateTime(2026, 12, 1, 10, 15),
        pending: true,
      );
      await tester.tap(find.text('Clear due date'));
      await tester.pump();
      expect(find.text('Saving…'), findsOneWidget);
      expect(
        tester
            .widget<TextButton>(
              find.widgetWithText(TextButton, 'Clear due date'),
            )
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<OutlinedButton>(
              find.byKey(const ValueKey('threadDue.choose')),
            )
            .onPressed,
        isNull,
      );
      expect(find.textContaining('set by you'), findsOneWidget);
      await fixture.close();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('a pending completion cannot update another active account', (
    tester,
  ) async {
    final fixture = await open(
      tester,
      due: DateTime(2026, 12, 1),
      pending: true,
    );
    final mailbox = fixture.app.mailbox!;
    final before = mailbox.messages;
    await tester.tap(find.text('Clear due date'));
    await tester.pump();
    mailbox.account = const Account(
      id: 9999,
      address: 'other@example.test',
      displayName: 'Other',
      isPrimary: false,
    );
    fixture.gate.hold!.complete();
    await tester.pumpAndSettle();
    expect(mailbox.messages, same(before));
    expect(find.textContaining('set by you'), findsNothing);
    await fixture.close();
  });

  testWidgets('no thread means no due controls', (tester) async {
    final fixture = await open(tester, thread: false);
    expect(find.byType(ThreadDueControl), findsNothing);
    expect(fixture.gate.calls, isEmpty);
    await fixture.close();
  });

  testWidgets('labels match webmail rounding, local dates and visible source', (
    tester,
  ) async {
    final now = DateTime(2026, 11, 3, 10);
    final fixture = await open(tester, due: now, source: null);
    final context = tester.element(find.byType(ThreadDueControl));
    expect(
      threadDueLabel(
        context,
        now.subtract(const Duration(seconds: 30)),
        now: now,
      ),
      'past due 1m',
    );
    expect(
      threadDueLabel(
        context,
        now.subtract(const Duration(minutes: 60)),
        now: now,
      ),
      'past due 1h',
    );
    expect(
      threadDueLabel(
        context,
        now.subtract(const Duration(hours: 48)),
        now: now,
      ),
      'past due 2d',
    );
    expect(
      threadDueLabel(context, now.add(const Duration(hours: 1)), now: now),
      'due 11:00',
    );
    expect(
      threadDueLabel(context, now.add(const Duration(days: 1)), now: now),
      'due tomorrow',
    );
    expect(
      threadDueLabel(context, now.add(const Duration(days: 2)), now: now),
      'due Thu',
    );
    expect(
      threadDueLabel(context, now.add(const Duration(days: 7)), now: now),
      'due Nov 10',
    );
    expect(find.textContaining('set by you'), findsNothing);
    await fixture.close();
  });

  group('dates the person did not set', () {
    // Ten days out, so it reads as a future date whenever this runs, and with
    // seconds and microseconds a minute-precision picker could not keep.
    DateTime suggestedInstant() {
      final later = DateTime.now().toUtc().add(const Duration(days: 10));
      return DateTime.utc(
        later.year,
        later.month,
        later.day,
        10,
        0,
        37,
        250,
        123,
      );
    }

    Finder button(String label) => find.widgetWithText(TextButton, label);

    VoidCallback? pressable(WidgetTester tester, String label) =>
        tester.widget<TextButton>(button(label)).onPressed;

    Color? colorOf(WidgetTester tester, String text) =>
        tester.widget<Text>(find.textContaining(text)).style?.color;

    RmColors tokens(WidgetTester tester) =>
        tester.element(find.byType(ThreadDueControl)).rm;

    testWidgets('a parsed date shows as a suggestion with its source', (
      tester,
    ) async {
      final fixture = await open(
        tester,
        seedDue: suggestedInstant(),
        seedSource: 'parsed',
      );
      expect(
        find.textContaining(
          RegExp(r'^suggested: due .* · parsed from the message text$'),
        ),
        findsOneWidget,
      );
      expect(
        find.byTooltip(
          'Suggested date parsed from the message text. It is not a deadline until you accept it.',
        ),
        findsOneWidget,
      );
      expect(colorOf(tester, 'suggested'), tokens(tester).ink2);
      expect(button('Accept suggestion'), findsOneWidget);
      expect(button('Dismiss suggestion'), findsOneWidget);
      expect(button('Clear due date'), findsNothing);
      expect(fixture.gate.calls, isEmpty);
      await fixture.close();
    });

    testWidgets('a past parsed date stays neutral and can still be accepted', (
      tester,
    ) async {
      final past = DateTime.now().toUtc().subtract(const Duration(days: 3));
      final fixture = await open(tester, seedDue: past, seedSource: 'parsed');
      expect(
        find.text('suggested: 3d ago · parsed from the message text'),
        findsOneWidget,
      );
      expect(find.textContaining('past due'), findsNothing);
      expect(colorOf(tester, 'suggested'), tokens(tester).ink2);
      expect(colorOf(tester, 'suggested'), isNot(tokens(tester).danger));
      await tester.tap(button('Accept suggestion'));
      await tester.pumpAndSettle();
      expect(find.text('past due 3d · set by you'), findsOneWidget);
      expect(colorOf(tester, 'past due'), tokens(tester).danger);
      await fixture.close();
    });

    testWidgets(
      'accept sends the exact instant, the server records user, and nothing moves',
      (tester) async {
        final instant = suggestedInstant();
        final fixture = await open(
          tester,
          seedDue: instant,
          seedSource: 'parsed',
        );
        final order = fixture.app.mailbox!.messages
            .map((message) => message.id)
            .toList();
        await tester.tap(button('Accept suggestion'));
        await tester.pumpAndSettle();
        expect(fixture.gate.calls.single['due_source'], 'user');
        expect(
          DateTime.parse(fixture.gate.calls.single['due'] as String),
          instant,
        );
        expect(fixture.message.due, instant);
        expect(fixture.message.dueSource, 'user');
        expect(find.textContaining('suggested'), findsNothing);
        expect(find.textContaining('set by you'), findsOneWidget);
        expect(find.byTooltip('Deadline set by you.'), findsOneWidget);
        expect(button('Accept suggestion'), findsNothing);
        expect(button('Dismiss suggestion'), findsNothing);
        expect(button('Clear due date'), findsOneWidget);
        expect(
          fixture.app.mailbox!.messages.every(
            (message) => message.due == instant && message.dueSource == 'user',
          ),
          isTrue,
        );
        expect(
          fixture.app.mailbox!.messages.map((message) => message.id),
          order,
        );
        expect(fixture.message.folder, 'INBOX');
        await fixture.close();
      },
    );

    testWidgets('dismiss clears the suggestion and offers nothing to clear', (
      tester,
    ) async {
      final fixture = await open(
        tester,
        seedDue: suggestedInstant(),
        seedSource: 'parsed',
      );
      await tester.tap(button('Dismiss suggestion'));
      await tester.pumpAndSettle();
      expect(fixture.gate.calls.single, {'due': null, 'due_source': 'user'});
      expect(fixture.message.due, isNull);
      expect(fixture.message.dueSource, isNull);
      expect(find.textContaining('suggested'), findsNothing);
      expect(find.textContaining('parsed from'), findsNothing);
      expect(button('Accept suggestion'), findsNothing);
      expect(button('Dismiss suggestion'), findsNothing);
      expect(button('Clear due date'), findsNothing);
      expect(
        fixture.app.mailbox!.messages.every(
          (message) => message.due == null && message.dueSource == null,
        ),
        isTrue,
      );
      await fixture.close();
    });

    testWidgets(
      'the picker starts empty on a suggestion, and a chosen date is the person\'s own',
      (tester) async {
        final instant = suggestedInstant();
        final fixture = await open(
          tester,
          seedDue: instant,
          seedSource: 'parsed',
        );
        expect(find.text('Due date'), findsOneWidget);
        expect(pressable(tester, 'Set due date'), isNull);
        await tester.tap(find.byKey(const ValueKey('threadDue.choose')));
        await tester.pumpAndSettle();
        expect(
          DateUtils.isSameDay(
            tester
                .widget<DatePickerDialog>(find.byType(DatePickerDialog))
                .initialDate,
            DateTime.now(),
          ),
          isTrue,
        );
        await tester.tap(find.text('Cancel').last);
        await tester.pumpAndSettle();
        expect(find.text('Due date'), findsOneWidget);
        expect(pressable(tester, 'Set due date'), isNull);
        expect(fixture.gate.calls, isEmpty);

        await choose(tester);
        await tester.tap(find.text('Set due date'));
        await tester.pumpAndSettle();
        final saved = DateTime.parse(
          fixture.gate.calls.single['due'] as String,
        );
        expect(fixture.gate.calls.single['due_source'], 'user');
        expect(saved, isNot(instant));
        expect(saved.second, 0);
        expect(DateUtils.isSameDay(saved.toLocal(), DateTime.now()), isTrue);
        expect(fixture.message.dueSource, 'user');
        expect(find.textContaining('suggested'), findsNothing);
        await fixture.close();
      },
    );

    for (final (action, status, message) in [
      ('Accept suggestion', 403, 'Refused due date'),
      ('Accept suggestion', 404, 'Could not save due date'),
      ('Accept suggestion', 422, 'Refused due date'),
      ('Dismiss suggestion', 403, 'Refused due date'),
      ('Dismiss suggestion', 404, 'Could not save due date'),
    ]) {
      testWidgets('HTTP $status on $action keeps the suggestion offered', (
        tester,
      ) async {
        final instant = suggestedInstant();
        final fixture = await open(
          tester,
          seedDue: instant,
          seedSource: 'parsed',
          status: status,
        );
        await tester.tap(button(action));
        await tester.pumpAndSettle();
        expect(find.text(message), findsOneWidget);
        expect(find.textContaining('suggested'), findsOneWidget);
        expect(find.textContaining('set by you'), findsNothing);
        expect(colorOf(tester, 'suggested'), tokens(tester).ink2);
        expect(find.text('Read this message'), findsOneWidget);
        expect(fixture.message.due, instant);
        expect(fixture.message.dueSource, 'parsed');
        expect(pressable(tester, 'Accept suggestion'), isNotNull);
        expect(pressable(tester, 'Dismiss suggestion'), isNotNull);
        expect(pressable(tester, 'Set due date'), isNull);
        await fixture.close();
      });
    }

    testWidgets('a pending accept disables every control', (tester) async {
      final fixture = await open(
        tester,
        seedDue: suggestedInstant(),
        seedSource: 'parsed',
        pending: true,
      );
      await tester.tap(button('Accept suggestion'));
      await tester.pump();
      expect(find.text('Saving…'), findsOneWidget);
      expect(pressable(tester, 'Accept suggestion'), isNull);
      expect(pressable(tester, 'Dismiss suggestion'), isNull);
      expect(
        tester
            .widget<OutlinedButton>(
              find.byKey(const ValueKey('threadDue.choose')),
            )
            .onPressed,
        isNull,
      );
      await fixture.close();
    });

    testWidgets(
      'a suggestion with the soonest date on the oldest thread stays in place and off the list',
      (tester) async {
        final fixture = await open(
          tester,
          seedDue: DateTime.now().toUtc().add(const Duration(hours: 1)),
          seedSource: 'parsed',
          newerThread: true,
        );
        final subjects = fixture.app.mailbox!.messages
            .map((message) => message.subject)
            .toList();
        expect(subjects, ['Newer fixture', 'Sibling fixture', 'Due fixture']);
        expect(fixture.app.mailbox!.folder, 'INBOX');
        expect(fixture.message.folder, 'INBOX');
        Navigator.of(tester.element(find.byType(ThreadDueControl))).pop();
        await tester.pumpAndSettle();
        expect(find.text('Newer fixture'), findsWidgets);
        expect(find.textContaining('suggested'), findsNothing);
        expect(find.textContaining('parsed from'), findsNothing);
        expect(fixture.gate.calls, isEmpty);
        await fixture.close();
      },
    );

    testWidgets('a rule date shows its source and can be cleared', (
      tester,
    ) async {
      final fixture = await open(
        tester,
        seedDue: suggestedInstant(),
        seedSource: 'rule',
      );
      expect(
        find.textContaining(RegExp(r'^due .* · set by a rule$')),
        findsOneWidget,
      );
      expect(find.byTooltip('Deadline set by a rule.'), findsOneWidget);
      expect(find.textContaining('suggested'), findsNothing);
      expect(button('Accept suggestion'), findsNothing);
      expect(button('Dismiss suggestion'), findsNothing);
      await tester.tap(button('Clear due date'));
      await tester.pumpAndSettle();
      expect(fixture.gate.calls.single, {'due': null, 'due_source': 'user'});
      expect(fixture.message.due, isNull);
      expect(fixture.message.dueSource, isNull);
      expect(find.textContaining('set by a rule'), findsNothing);
      await fixture.close();
    });

    testWidgets('a rule date can be changed, and the change is the person\'s', (
      tester,
    ) async {
      final fixture = await open(
        tester,
        seedDue: suggestedInstant(),
        seedSource: 'rule',
      );
      expect(find.textContaining(RegExp(r'^Due date: ')), findsOneWidget);
      expect(pressable(tester, 'Set due date'), isNotNull);
      await choose(tester);
      await tester.tap(find.text('Set due date'));
      await tester.pumpAndSettle();
      expect(fixture.gate.calls.single['due_source'], 'user');
      expect(fixture.message.dueSource, 'user');
      expect(find.textContaining('set by you'), findsOneWidget);
      expect(find.textContaining('set by a rule'), findsNothing);
      await fixture.close();
    });

    testWidgets('a past rule date warns as a deadline does', (tester) async {
      final fixture = await open(
        tester,
        seedDue: DateTime.now().toUtc().subtract(const Duration(days: 3)),
        seedSource: 'rule',
      );
      expect(find.text('past due 3d · set by a rule'), findsOneWidget);
      expect(colorOf(tester, 'past due'), tokens(tester).danger);
      await fixture.close();
    });

    testWidgets('a plain user date keeps its controls and warning', (
      tester,
    ) async {
      final fixture = await open(
        tester,
        due: DateTime.now().toUtc().subtract(const Duration(days: 3)),
      );
      expect(find.text('past due 3d · set by you'), findsOneWidget);
      expect(colorOf(tester, 'past due'), tokens(tester).danger);
      expect(find.byTooltip('Deadline set by you.'), findsOneWidget);
      expect(find.textContaining(RegExp(r'^Due date: ')), findsOneWidget);
      expect(pressable(tester, 'Set due date'), isNotNull);
      expect(pressable(tester, 'Clear due date'), isNotNull);
      expect(find.textContaining('suggested'), findsNothing);
      expect(button('Accept suggestion'), findsNothing);
      expect(button('Dismiss suggestion'), findsNothing);
      await fixture.close();
    });

    testWidgets('a past suggestion label rounds as a past deadline does', (
      tester,
    ) async {
      final now = DateTime(2026, 11, 3, 10);
      final fixture = await open(tester);
      final context = tester.element(find.byType(ThreadDueControl));
      String label(Duration offset) =>
          threadDueSuggestionLabel(context, now.add(offset), now: now);
      expect(label(const Duration(seconds: -30)), 'suggested: 1m ago');
      expect(label(const Duration(minutes: -60)), 'suggested: 1h ago');
      expect(label(const Duration(hours: -48)), 'suggested: 2d ago');
      expect(label(const Duration(days: 1)), 'suggested: due tomorrow');
      await fixture.close();
    });
  });
}
