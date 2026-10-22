import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/util/day_sections.dart';
import 'package:restmail_api/restmail_api.dart';

Message _message(int id, DateTime when) => Message(
  id: id,
  mailboxId: 1,
  folder: 'INBOX',
  sender: 'dana@restmail.dev',
  subject: 'message $id',
  receivedAt: when,
);

void main() {
  test('groups conversations by day and counts them', () {
    final entries = buildListEntries([
      [_message(1, DateTime(2026, 10, 20, 9))],
      [_message(2, DateTime(2026, 10, 20, 11))],
      [_message(3, DateTime(2026, 10, 19, 8))],
    ], withDays: true);

    expect(entries.length, 5);
    expect(entries[0], isA<DayEntry>());
    expect((entries[0] as DayEntry).count, 2);
    expect(entries[1], isA<ConversationEntry>());
    expect((entries[3] as DayEntry).count, 1);
  });

  test('without the panel the list is just conversations', () {
    final entries = buildListEntries([
      [_message(1, DateTime(2026, 10, 20))],
    ], withDays: false);

    expect(entries.single, isA<ConversationEntry>());
  });

  test('headings say today, yesterday, weekday, then date', () {
    final now = DateTime(2026, 10, 20, 12);
    expect(dayHeading(DateTime(2026, 10, 20), now: now), 'Today');
    expect(dayHeading(DateTime(2026, 10, 19), now: now), 'Yesterday');
    expect(dayHeading(DateTime(2026, 10, 15), now: now), 'Thursday');
    expect(dayHeading(DateTime(2025, 12, 1), now: now), 'December 1, 2025');
  });

  test('absolute headings always write the date', () {
    expect(
      dayHeading(DateTime(2026, 10, 20), absolute: true),
      'Tuesday, October 20, 2026',
    );
  });
}
