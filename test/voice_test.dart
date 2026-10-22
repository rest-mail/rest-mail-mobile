import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/l10n/voice.dart';
import 'package:restmail/theme/packs.dart';

void main() {
  const key = 'splash.tagline';

  test('every shipped locale speaks in every voice', () {
    for (final locale in supportedLocales) {
      for (final pack in ThemePack.all) {
        expect(voiceLine(pack, locale, key), isNotEmpty);
      }
    }
  });

  test('the voice wins over the base pack in its own language', () {
    expect(
      voiceLine(ThemePack.nightops, const Locale('de'), key),
      '// öffne_deine_post',
    );
    expect(
      voiceLine(ThemePack.ledger, const Locale('es'), key),
      'Abriendo la correspondencia del día.',
    );
  });

  test('an unknown locale falls back to English, voice first', () {
    expect(
      voiceLine(ThemePack.brand, const Locale('fr'), key),
      'Mail that keeps up with you.',
    );
    expect(
      voiceLine(ThemePack.classic, const Locale('fr'), key),
      'Opening your mail',
    );
  });

  test('the Devanagari packs survive the journey', () {
    expect(
      voiceLine(ThemePack.classic, const Locale('hi'), key),
      contains('मेल'),
    );
    expect(
      voiceLine(ThemePack.classic, const Locale('ne'), key),
      contains('मेल'),
    );
  });
}
