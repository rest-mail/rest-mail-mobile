import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/theme/theme.dart';
import 'package:restmail/ui/widgets/message_row.dart';
import 'package:restmail/ui/widgets/waiting_chip.dart';
import 'package:restmail_api/restmail_api.dart';

void main() {
  final now = DateTime.utc(2026, 11, 3, 12);
  for (final (age, expected) in [
    (const Duration(seconds: -30), 'waiting 0m'),
    (Duration.zero, 'waiting 0m'),
    (const Duration(milliseconds: 29999), 'waiting 0m'),
    (const Duration(seconds: 30), 'waiting 1m'),
    (
      const Duration(minutes: 59, seconds: 29, milliseconds: 999),
      'waiting 59m',
    ),
    (const Duration(minutes: 59, seconds: 30), 'waiting 1h'),
    (const Duration(minutes: 89, seconds: 29, milliseconds: 999), 'waiting 1h'),
    (const Duration(minutes: 89, seconds: 30), 'waiting 2h'),
    (
      const Duration(hours: 47, minutes: 29, seconds: 29, milliseconds: 999),
      'waiting 47h',
    ),
    (const Duration(hours: 47, minutes: 29, seconds: 30), 'waiting 2d'),
    (
      const Duration(
        days: 13,
        hours: 11,
        minutes: 29,
        seconds: 29,
        milliseconds: 999,
      ),
      'waiting 13d',
    ),
    (
      const Duration(days: 13, hours: 11, minutes: 29, seconds: 30),
      'waiting 2w',
    ),
    (const Duration(days: 21), 'waiting 3w'),
  ]) {
    testWidgets('webmail age boundary $age is $expected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(ThemePack.classic, Brightness.light),
          home: Scaffold(
            body: WaitingChip(since: now.subtract(age), now: now),
          ),
        ),
      );
      expect(find.text(expected), findsOneWidget);
    });
  }

  for (final dense in [false, true]) {
    for (final state in ['absent', 'null', 'waiting']) {
      testWidgets('$state waiting chip, dense=$dense', (tester) async {
        final message = Message.fromJson({
          'id': 1,
          'mailbox_id': 7,
          'folder': 'Sent',
          'sender': 'me@example.test',
          'subject': 'A question',
          'received_at': '2026-11-01T12:00:00Z',
          if (state != 'absent')
            'awaiting_since': state == 'waiting'
                ? DateTime.now()
                      .toUtc()
                      .subtract(const Duration(days: 2))
                      .toIso8601String()
                : null,
        });
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(ThemePack.classic, Brightness.light),
            home: Scaffold(
              body: MessageRow(message: message, dense: dense, onTap: () {}),
            ),
          ),
        );
        expect(
          find.text('waiting 2d'),
          state == 'waiting' ? findsOneWidget : findsNothing,
        );
      });
    }
  }
}
