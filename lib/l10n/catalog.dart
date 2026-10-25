import 'strings_ar.dart';
import 'strings_de.dart';
import 'strings_en.dart';
import 'strings_es.dart';
import 'strings_fa.dart';
import 'strings_hi.dart';
import 'strings_ne.dart';

const _voices = <String, Map<String, Map<String, String>>>{
  'en': stringsEn,
  'de': stringsDe,
  'es': stringsEs,
  'hi': stringsHi,
  'ne': stringsNe,
  'ar': stringsAr,
  'fa': stringsFa,
};

/// Resolve app-authored text without requiring a widget, including notifications.
String languageLine(
  String languageCode,
  String key, {
  String voice = 'classic',
  Map<String, String> args = const {},
}) {
  final language = languageCode.split(RegExp('[-_]')).first;
  final words = _voices[language];
  final english = _voices['en']!;
  final text =
      words?[voice]?[key] ??
      words?['classic']?[key] ??
      english[voice]?[key] ??
      english['classic']?[key] ??
      key;
  return fillPlaceholders(text, args);
}

/// Replace only slots in the template; inserted user content is never reparsed.
String fillPlaceholders(String text, Map<String, String> args) =>
    text.replaceAllMapped(
      RegExp(r'\{(\w+)\}'),
      (match) => args[match[1]] ?? match[0]!,
    );

/// A translation key and its values, kept unresolved until it is displayed.
/// Server messages and user content must never be wrapped as translation keys.
class UiText {
  const UiText(this.key, [this.args = const {}]);
  final String key;
  final Map<String, String> args;

  String resolve(String languageCode, {String voice = 'classic'}) =>
      languageLine(languageCode, key, voice: voice, args: args);

  String get inEnglish => resolve('en');
}
