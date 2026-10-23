import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_scope.dart';
import '../state/mailbox_state.dart';
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

/// The languages the app offers, and what each calls itself. `system` means
/// the phone's choice.
const languageNames = <String, String>{
  'system': 'System',
  'en': 'English',
  'de': 'Deutsch',
  'es': 'Español',
  'hi': 'हिन्दी',
  'ne': 'नेपाली',
};

String languageLabel(String code) => languageNames[code] ?? 'System';

/// The UI string [key] in the language the app is set to and the current
/// theme's voice.
String tr(BuildContext context, String key) {
  final app = context.dependOnInheritedWidgetOfExactType<AppScope>()?.notifier;
  return voiceLine(
    ThemePack.byId(app?.settings.packId ?? 'classic'),
    Localizations.localeOf(context),
    key,
  );
}

/// [key] with `{name}` placeholders replaced by [args].
String trArgs(BuildContext context, String key, Map<String, String> args) {
  var text = tr(context, key);
  for (final entry in args.entries) {
    text = text.replaceAll('{${entry.key}}', entry.value);
  }
  return text;
}

/// A standard folder's name in the current language; custom folders keep
/// their own name.
const _folderKeys = <String, String>{
  StandardFolder.inbox: 'folder.inbox',
  StandardFolder.drafts: 'folder.drafts',
  StandardFolder.sent: 'folder.sent',
  StandardFolder.archive: 'folder.archive',
  StandardFolder.spam: 'folder.spam',
  StandardFolder.trash: 'folder.trash',
};

String folderLabelOf(BuildContext context, String name) {
  final key = _folderKeys[name];
  return key == null ? name : tr(context, key);
}

String liveLabelOf(BuildContext context, LiveStatus status) => switch (status) {
  LiveStatus.live => tr(context, 'status.live'),
  LiveStatus.connecting => tr(context, 'status.connecting'),
  LiveStatus.offline => tr(context, 'status.offline'),
};

/// What a sender verdict calls itself, in the current language.
String trustLabelOf(BuildContext context, TrustVerdict verdict) =>
    tr(context, 'trust.${verdict.state.name}');

/// The sentence behind a sender verdict, naming the domain the header gave,
/// or saying which domain it means when it gave none.
String trustDetailOf(BuildContext context, TrustVerdict verdict) {
  final unnamed = switch (verdict.state) {
    TrustState.aligned => 'trust.fromDomain',
    TrustState.spfOnly => 'trust.envelopeDomain',
    _ => 'trust.sendingDomain',
  };
  return trArgs(context, 'trust.${verdict.state.name}.detail', {
    'domain': verdict.domain ?? tr(context, unnamed),
  });
}

/// The string for [key] in [pack]'s voice and [locale], falling back
/// voice+locale → base+locale → voice+en → base+en.
String voiceLine(ThemePack pack, Locale locale, String key) {
  final lang = locale.languageCode;
  final inLang = _voices[lang];
  final inEn = _voices['en']!;
  return inLang?[pack.id]?[key] ??
      inLang?['classic']?[key] ??
      inEn[pack.id]?[key] ??
      inEn['classic']?[key] ??
      key;
}
