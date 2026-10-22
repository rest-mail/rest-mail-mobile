import 'package:flutter/material.dart';

import '../theme/packs.dart';
import 'strings_de.dart';
import 'strings_en.dart';
import 'strings_es.dart';
import 'strings_hi.dart';
import 'strings_ne.dart';

/// Two layers of words, resolved per string.
///
/// The base layer is a language pack — one file per locale, every string in
/// the neutral voice the classic theme speaks. The overlay is a theme's
/// voice: the tone it wants, overriding only the strings it has opinions
/// about. Night Ops writes comments, Ledger writes prose, Brand writes
/// promises; anything a voice leaves out stays neutral, so adding a language
/// is one file plus one line here, not one file per voice.
///
/// To add a language: copy `strings_en.dart`, translate the values, add the
/// import, the entry in [_voices] and the `Locale` in [supportedLocales].
const _voices = <String, Map<String, Map<String, String>>>{
  'en': stringsEn,
  'de': stringsDe,
  'es': stringsEs,
  'hi': stringsHi,
  'ne': stringsNe,
};

/// What the app can speak. A device set to anything else gets the first of
/// these rather than a half-translated mix.
const supportedLocales = <Locale>[
  Locale('en'),
  Locale('de'),
  Locale('es'),
  Locale('hi'),
  Locale('ne'),
];

/// The string for [key] in [pack]'s voice and [locale], falling back
/// voice+locale → base+locale → voice+en → base+en.
String voiceLine(ThemePack pack, Locale locale, String key) {
  final lang = locale.languageCode;
  final inLang = _voices[lang];
  final inEn = _voices['en']!;
  return inLang?[pack.id]?[key] ??
      inLang?['classic']?[key] ??
      inEn[pack.id]?[key] ??
      inEn['classic']![key]!;
}
