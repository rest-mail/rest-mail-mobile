import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/util/format.dart';
import 'package:restmail/util/search_parser.dart';

void main() {
  group('timeLabel', () {
    final now = DateTime(2026, 9, 10, 15); // a Thursday

    test('shows the clock today', () {
      expect(timeLabel(DateTime(2026, 9, 10, 9, 42), now: now), '09:42');
    });

    test('says Yesterday, then the weekday within a week', () {
      expect(timeLabel(DateTime(2026, 9, 9, 23), now: now), 'Yesterday');
      expect(timeLabel(DateTime(2026, 9, 8, 12), now: now), 'Tue');
    });

    test('gives a date after that, with the year once it is not this one', () {
      expect(timeLabel(DateTime(2026, 8, 1), now: now), 'Aug 1');
      expect(timeLabel(DateTime(2025, 8, 1), now: now), 'Aug 1, 2025');
    });
  });

  test('sizeLabel', () {
    expect(sizeLabel(512), '512 B');
    expect(sizeLabel(412 * 1024), '412 KB');
    expect(sizeLabel((1.1 * 1024 * 1024).round()), '1.1 MB');
  });

  test('initialsOf', () {
    expect(initialsOf('Nadia Osei'), 'NO');
    expect(initialsOf('dana.ruiz@example.test'), 'DR');
    expect(initialsOf('GitHub'), 'GI');
    expect(initialsOf(''), '?');
  });

  group('parseSearch', () {
    test('reads from:, in: and has:attachment, leaving the rest as text', () {
      final query = parseSearch(
        'from:nadia latency has:attachment in:sent bench',
      );

      expect(query.from, 'nadia');
      expect(query.folder, 'Sent');
      expect(query.hasAttachment, isTrue);
      expect(query.text, 'latency bench');
    });

    test('passes a folder of the user’s own through as typed', () {
      expect(parseSearch('in:Receipts').folder, 'Receipts');
    });
  });
}
