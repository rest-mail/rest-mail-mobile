import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:restmail/util/day_sections.dart';
import 'package:restmail/util/format.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  tearDown(() => Intl.defaultLocale = 'en');

  test('German relative days are words, not English', () {
    Intl.defaultLocale = 'de';
    final now = DateTime(2026, 10, 22, 9);
    expect(timeLabel(DateTime(2026, 10, 22, 8), now: now), '08:00');
    expect(timeLabel(DateTime(2026, 10, 21), now: now), 'Gestern');
    expect(dayHeading(DateTime(2026, 10, 22), now: now), 'Heute');
    expect(dayHeading(DateTime(2026, 10, 21), now: now), 'Gestern');
  });

  test('German dates use German months and ordering', () {
    Intl.defaultLocale = 'de';
    final at = DateTime(2026, 10, 22, 14, 30);
    expect(longDate(at), contains('Okt'));
    expect(longDate(at), contains('22'));
    expect(dayHeading(at, absolute: true), contains('Oktober'));
  });

  test('Spanish and Nepali relative days', () {
    final now = DateTime(2026, 10, 22, 9);
    Intl.defaultLocale = 'es';
    expect(timeLabel(DateTime(2026, 10, 21), now: now), 'Ayer');
    Intl.defaultLocale = 'ne';
    expect(timeLabel(DateTime(2026, 10, 21), now: now), 'हिजो');
  });

  test('Arabic and Farsi relative days and full dates', () {
    final now = DateTime(2026, 10, 22, 9);
    for (final (language, today, yesterday) in [
      ('ar', 'اليوم', 'أمس'),
      ('fa', 'امروز', 'دیروز'),
    ]) {
      Intl.defaultLocale = language;
      expect(dayHeading(now, now: now), today);
      expect(dayHeading(DateTime(2026, 10, 21), now: now), yesterday);
      expect(timeLabel(DateTime(2026, 10, 21), now: now), yesterday);
      expect(longDate(now), contains(RegExp(r'[\u0600-\u06ff]')));
      expect(
        dayHeading(now, absolute: true),
        contains(RegExp(r'[\u0600-\u06ff]')),
      );
    }
  });
}
