import 'dart:convert';

import 'package:flutter/foundation.dart';

/// The part of the app a panel belongs to.
enum PanelArea { list, reader, composer }

/// One configurable thing inside a panel. Options only change how a panel
/// renders what it already has; anything with a side effect is a setting,
/// not an option.
sealed class PanelOption {
  const PanelOption({required this.id, required this.labelKey});

  /// Stable key inside the panel. Never rename it.
  final String id;
  final String labelKey;
}

/// Pick one of a few renderings.
final class ChoiceOption extends PanelOption {
  const ChoiceOption({
    required super.id,
    required super.labelKey,
    required this.values,
    required this.defaultValue,
  });

  /// Value and the words the settings screen shows for it.
  final List<(String, String)> values;
  final String defaultValue;
}

/// Turn one part of a panel on or off.
final class ToggleOption extends PanelOption {
  const ToggleOption({
    required super.id,
    required super.labelKey,
    this.defaultValue = false,
  });

  final bool defaultValue;
}

/// One optional component. The settings screen builds itself from
/// [panelRegistry], so adding a panel needs no new settings code, and every
/// screen asks the same registry whether to draw it.
@immutable
class PanelSpec {
  const PanelSpec({
    required this.id,
    required this.area,
    required this.nameKey,
    required this.descriptionKey,
    this.defaultOn = false,
    this.options = const [],
  });

  final String id;
  final PanelArea area;
  final String nameKey;
  final String descriptionKey;
  final bool defaultOn;
  final List<PanelOption> options;
}

const dayStyleOption = ChoiceOption(
  id: 'style',
  labelKey: 'interface.headingStyle',
  values: [
    ('relative', 'interface.todayYesterday'),
    ('absolute', 'interface.fullDate'),
  ],
  defaultValue: 'relative',
);

const dayCountOption = ToggleOption(
  id: 'count',
  labelKey: 'interface.howManyMessagesThatDay',
);

const dateSeparatorsPanel = PanelSpec(
  id: 'date_separators',
  area: PanelArea.list,
  nameKey: 'interface.dateSeparatorRows',
  descriptionKey: 'interface.aHeadingForEachDayWith',
  options: [dayStyleOption, dayCountOption],
);

const trustDetailOption = ChoiceOption(
  id: 'detail',
  labelKey: 'interface.detail',
  values: [
    ('chip', 'interface.badgeOnly'),
    ('receipt', 'interface.badgeAndChecks'),
  ],
  defaultValue: 'chip',
);

const trustShowForOption = ChoiceOption(
  id: 'show_for',
  labelKey: 'interface.showFor',
  values: [
    ('all', 'interface.everyMessage'),
    ('warnings', 'interface.warningsOnly'),
  ],
  defaultValue: 'all',
);

const senderTrustPanel = PanelSpec(
  id: 'sender_trust',
  area: PanelArea.reader,
  nameKey: 'interface.senderVerification',
  descriptionKey: 'interface.signedForwardedOrUnverifiedFromThe',
  defaultOn: true,
  options: [trustDetailOption, trustShowForOption],
);

const previewLinesOption = ChoiceOption(
  id: 'lines',
  labelKey: 'interface.lines',
  values: [
    ('one', 'interface.oneLine'),
    ('two', 'interface.twoLines'),
    ('none', 'interface.none'),
  ],
  defaultValue: 'two',
);

const listPreviewPanel = PanelSpec(
  id: 'list_preview',
  area: PanelArea.list,
  nameKey: 'interface.messagePreview',
  descriptionKey: 'interface.howMuchOfTheBodyShows',
  defaultOn: true,
  options: [previewLinesOption],
);

const listAttachmentsPanel = PanelSpec(
  id: 'list_attachments',
  area: PanelArea.list,
  nameKey: 'interface.attachmentMarker',
  descriptionKey: 'interface.aPaperclipOnMessagesThatCarry',
  defaultOn: true,
);

const listCountPanel = PanelSpec(
  id: 'list_count',
  area: PanelArea.list,
  nameKey: 'interface.conversationCount',
  descriptionKey: 'interface.howManyMessagesAreInA',
  defaultOn: true,
);

const listFlagPanel = PanelSpec(
  id: 'list_flag',
  area: PanelArea.list,
  nameKey: 'interface.flagMarker',
  descriptionKey: 'interface.showWhichMessagesYouHaveFlagged',
  defaultOn: true,
);

const composerCcPanel = PanelSpec(
  id: 'composer_cc',
  area: PanelArea.composer,
  nameKey: 'interface.ccAndBccFields',
  descriptionKey: 'interface.keepTheCopyFieldsOpenInstead',
);

const composerFromPanel = PanelSpec(
  id: 'composer_from',
  area: PanelArea.composer,
  nameKey: 'interface.sendingAccount',
  descriptionKey: 'interface.showWhichAccountTheMessageGoes',
);

const composerLaterPanel = PanelSpec(
  id: 'composer_later',
  area: PanelArea.composer,
  nameKey: 'interface.sendLater',
  descriptionKey: 'interface.aLaterButtonThatHoldsThe',
);

const composerUnsubscribePanel = PanelSpec(
  id: 'composer_unsubscribe',
  area: PanelArea.composer,
  nameKey: 'interface.unsubscribeLink',
  descriptionKey: 'interface.whereRecipientsUnsubscribeForMailFrom',
);

const composerRequireTlsPanel = PanelSpec(
  id: 'composer_require_tls',
  area: PanelArea.composer,
  nameKey: 'interface.requireTls',
  descriptionKey: 'interface.requireTlsDescription',
);

/// Everything the user can add to or remove from their client.
const panelRegistry = <PanelSpec>[
  dateSeparatorsPanel,
  listPreviewPanel,
  listAttachmentsPanel,
  listCountPanel,
  listFlagPanel,
  senderTrustPanel,
  composerCcPanel,
  composerFromPanel,
  composerLaterPanel,
  composerUnsubscribePanel,
  composerRequireTlsPanel,
];

/// The layout choices, kept on the device with the rest of the settings.
@immutable
class InterfacePrefs {
  const InterfacePrefs({this.enabled = const {}, this.values = const {}});

  factory InterfacePrefs.decode(Object? raw) {
    if (raw is! Map) return const InterfacePrefs();

    final enabled = <String, bool>{};
    final panels = raw['panels'];
    if (panels is Map) {
      for (final entry in panels.entries) {
        final key = entry.key;
        final value = entry.value;
        if (key is String && value is bool) enabled[key] = value;
      }
    }

    final values = <String, Map<String, Object>>{};
    final stored = raw['values'];
    if (stored is Map) {
      for (final entry in stored.entries) {
        final key = entry.key;
        final map = entry.value;
        if (key is! String || map is! Map) continue;
        final options = <String, Object>{};
        for (final option in map.entries) {
          final optionKey = option.key;
          final value = option.value;
          if (optionKey is! String) continue;
          if (value is bool) {
            options[optionKey] = value;
          } else if (value is String) {
            options[optionKey] = value;
          }
        }
        values[key] = options;
      }
    }

    return InterfacePrefs(enabled: enabled, values: values);
  }

  /// Panel id to on/off. A panel missing here uses its own default, so a
  /// build that adds a panel starts from the right state for existing users.
  final Map<String, bool> enabled;

  /// Panel id, then option id, to the chosen value.
  final Map<String, Map<String, Object>> values;

  bool isOn(PanelSpec spec) => enabled[spec.id] ?? spec.defaultOn;

  String choice(PanelSpec panel, ChoiceOption option) {
    final value = values[panel.id]?[option.id];
    return value is String ? value : option.defaultValue;
  }

  bool toggle(PanelSpec panel, ToggleOption option) {
    final value = values[panel.id]?[option.id];
    return value is bool ? value : option.defaultValue;
  }

  InterfacePrefs withPanel(String id, bool on) =>
      InterfacePrefs(enabled: {...enabled, id: on}, values: values);

  InterfacePrefs withValue(String panelId, String optionId, Object value) {
    final options = {...?values[panelId], optionId: value};
    return InterfacePrefs(
      enabled: enabled,
      values: {...values, panelId: options},
    );
  }

  Map<String, Object?> toJson() => {'panels': enabled, 'values': values};

  String encode() => jsonEncode(toJson());

  /// Whether this is exactly the same layout as [other]. Used to mark the
  /// preset that is in force without touching the stored form.
  bool matches(InterfacePrefs other) {
    if (enabled.length != other.enabled.length) return false;
    for (final entry in enabled.entries) {
      if (other.enabled[entry.key] != entry.value) return false;
    }
    if (values.length != other.values.length) return false;
    for (final panel in values.entries) {
      final theirs = other.values[panel.key];
      if (theirs == null || theirs.length != panel.value.length) return false;
      for (final option in panel.value.entries) {
        if (theirs[option.key] != option.value) return false;
      }
    }
    return true;
  }
}

/// A named set of panel choices. Applying one writes every panel and option,
/// so the result is the same whatever was set before.
@immutable
class InterfacePreset {
  const InterfacePreset({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.prefs,
  });

  final String id;
  final String nameKey;
  final String descriptionKey;
  final InterfacePrefs prefs;
}

/// The starting points the settings screen offers above the panels.
const classicPreset = InterfacePreset(
  id: 'classic',
  nameKey: 'interface.classic',
  descriptionKey: 'interface.theListAsAListWith',
  prefs: InterfacePrefs(),
);

const triagePreset = InterfacePreset(
  id: 'triage',
  nameKey: 'interface.triage',
  descriptionKey: 'interface.dayHeadingsWithCountsAndOnly',
  prefs: InterfacePrefs(
    enabled: {'date_separators': true},
    values: {
      'date_separators': {'style': 'absolute', 'count': true},
      'sender_trust': {'detail': 'chip', 'show_for': 'warnings'},
    },
  ),
);

const readingPreset = InterfacePreset(
  id: 'reading',
  nameKey: 'interface.reading',
  descriptionKey: 'interface.fullSenderChecksAndTheCopy',
  prefs: InterfacePrefs(
    enabled: {'composer_cc': true},
    values: {
      'sender_trust': {'detail': 'receipt', 'show_for': 'all'},
    },
  ),
);

const interfacePresets = <InterfacePreset>[
  classicPreset,
  triagePreset,
  readingPreset,
];
