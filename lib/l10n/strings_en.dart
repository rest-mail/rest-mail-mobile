/// The base language pack: every string in the neutral voice, the one the
/// classic theme speaks. A voice overlay in `voice.dart`'s registry may
/// override any of these per theme; anything it leaves out stays neutral.
///
/// To add a language: copy this file, translate the values, then register it
/// in `voice.dart` (one import, one map entry, one `Locale`).
const Map<String, Map<String, String>> stringsEn = {
  'classic': {'splash.tagline': 'Opening your mail'},
  'brand': {'splash.tagline': 'Mail that keeps up with you.'},
  'ledger': {'splash.tagline': "Opening the day's correspondence."},
  'nightops': {'splash.tagline': '// opening_your_mail'},
};
