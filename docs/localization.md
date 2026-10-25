# App localization

The seven language packs in `lib/l10n/strings_*.dart` own app-authored UI text.
The expanded catalog includes theme names and descriptions, presets, panels,
settings, security flows, administration, statuses, dialogs, accessibility labels,
client errors, notification summaries, and generated reply/forward headings.
Translations added in this migration are machine translated and can be corrected
in the packs without changing their keys or placeholders.

Use `tr(context, key)` for labels and `trArgs(context, key, values)` for complete
sentences. Theme, panel, preset, and administration metadata store explicit
translation keys. Their persisted IDs, option values, and API values stay stable.
The `catalog.dart` resolver also supports code that runs outside a widget.
`UiText` carries a key and arguments until display; `LocalizedApiException`
distinguishes client-authored errors from server errors. Placeholder replacement
runs once, so inserted content containing braces is preserved verbatim.

Received email subjects and bodies, sender/contact names, custom folder names,
server messages and field errors, logs, release notes, and unknown server enum
values remain as supplied. Known status codes have app-owned translated labels.
Protocol identifiers, regular expressions, executable examples, addresses, font
names, and canonical folder IDs are technical values. Standard folder IDs get
translated display labels without changing the stored ID.

The iOS camera permission explanation also comes from the packs. Run
`dart tool/ci/generate_ios_localizations.dart` after changing `native.cameraUsage`.
The generated `InfoPlist.strings` files and the fallback Info.plist explanation
are checked in; CI verifies that they agree with the catalog.

The migration used a Dart AST inventory of literals across the app, followed by
review of dynamic helpers and non-widget text paths. CI's
`tool/ci/check_ui_text.py` rejects new literals in common display constructors,
named UI fields, and constructor defaults. It does not translate or inspect
runtime content. Catalog parity/placeholder tests, metadata coverage tests, and
German, Arabic, and Farsi screen tests complement that guard.
