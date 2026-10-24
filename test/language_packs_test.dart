import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/l10n/strings_ar.dart';
import 'package:restmail/l10n/strings_de.dart';
import 'package:restmail/l10n/strings_en.dart';
import 'package:restmail/l10n/strings_es.dart';
import 'package:restmail/l10n/strings_fa.dart';
import 'package:restmail/l10n/strings_hi.dart';
import 'package:restmail/l10n/strings_ne.dart';

final _placeholder = RegExp(r'\{\w+\}');

List<String> _placeholders(String text) =>
    _placeholder.allMatches(text).map((m) => m[0]!).toList()..sort();

void main() {
  const packs = {
    'de': stringsDe,
    'es': stringsEs,
    'hi': stringsHi,
    'ne': stringsNe,
    'ar': stringsAr,
    'fa': stringsFa,
  };
  final english = stringsEn['classic']!;

  for (final MapEntry(key: language, value: pack) in packs.entries) {
    test('$language says everything English says', () {
      final words = pack['classic']!;
      expect(
        english.keys.where((key) => !words.containsKey(key)),
        isEmpty,
        reason: 'keys English has that $language does not',
      );
      expect(
        words.keys.where((key) => !english.containsKey(key)),
        isEmpty,
        reason: 'keys $language has that English does not',
      );
    });

    test('$language fills in the same blanks as English', () {
      final words = pack['classic']!;
      for (final MapEntry(:key, value: text) in english.entries) {
        final translated = words[key];
        if (translated == null) continue;
        expect(
          _placeholders(translated),
          _placeholders(text),
          reason: '$language $key',
        );
      }
    });
  }
}
