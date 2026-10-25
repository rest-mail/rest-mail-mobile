import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../imap/imap_backend.dart';
import '../state/app_scope.dart';
import '../state/mailbox_state.dart';
import '../theme/packs.dart';
import 'catalog.dart';

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
/// import, the registry entry in `catalog.dart`, the `Locale` in [supportedLocales],
/// and its self-name in [languageNames].

/// What the app can speak. A device set to anything else gets the first of
/// these rather than a half-translated mix.
const supportedLocales = <Locale>[
  Locale('en'),
  Locale('de'),
  Locale('es'),
  Locale('hi'),
  Locale('ne'),
  Locale('ar'),
  Locale('fa'),
];

/// The languages the app offers, and what each calls itself. `system` means
/// the phone's choice.
const languageNames = <String, String>{
  'system': 'settings.system',
  'en': 'English',
  'de': 'Deutsch',
  'es': 'Español',
  'hi': 'हिन्दी',
  'ne': 'नेपाली',
  'ar': 'العربية',
  'fa': 'فارسی',
};

String languageLabel(String code, {BuildContext? context}) =>
    code == 'system' || !languageNames.containsKey(code)
    ? (context == null
          ? languageLine('en', 'settings.system')
          : tr(context, 'settings.system'))
    : languageNames[code]!;

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
  return fillPlaceholders(tr(context, key), args);
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

const _systemFolderKeys = <String, String>{
  'All Mail': 'folder.allMail',
  'Important': 'folder.important',
  'Starred': 'folder.starred',
};

String folderLabelOf(BuildContext context, String name) {
  var key = _folderKeys[name];
  if (key == null) {
    final backend = context
        .dependOnInheritedWidgetOfExactType<AppScope>()
        ?.notifier
        ?.mailbox
        ?.backend;
    if (backend is ImapBackend && backend.isSystemFolder(name)) {
      key = _systemFolderKeys[name];
    }
  }
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
  return languageLine(locale.languageCode, key, voice: pack.id);
}

String trText(BuildContext context, UiText text) =>
    trArgs(context, text.key, text.args);
