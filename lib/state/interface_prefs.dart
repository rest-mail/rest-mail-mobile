import 'dart:convert';

import 'package:flutter/foundation.dart';

/// The part of the app a panel belongs to.
enum PanelArea { list, reader, composer }

/// One configurable thing inside a panel. Options only change how a panel
/// renders what it already has; anything with a side effect is a setting,
/// not an option.
sealed class PanelOption {
  const PanelOption({required this.id, required this.label});

  /// Stable key inside the panel. Never rename it.
  final String id;
  final String label;
}

/// Pick one of a few renderings.
final class ChoiceOption extends PanelOption {
  const ChoiceOption({
    required super.id,
    required super.label,
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
    required super.label,
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
    required this.name,
    required this.description,
    this.defaultOn = false,
    this.options = const [],
  });

  final String id;
  final PanelArea area;
  final String name;
  final String description;
  final bool defaultOn;
  final List<PanelOption> options;
}

const dayStyleOption = ChoiceOption(
  id: 'style',
  label: 'Heading style',
  values: [('relative', 'Today / Yesterday'), ('absolute', 'Full date')],
  defaultValue: 'relative',
);

const dayCountOption = ToggleOption(
  id: 'count',
  label: 'How many messages that day',
);

const dateSeparatorsPanel = PanelSpec(
  id: 'date_separators',
  area: PanelArea.list,
  name: 'Date separator rows',
  description: 'A heading for each day, with that day mail under it.',
  options: [dayStyleOption, dayCountOption],
);

const trustDetailOption = ChoiceOption(
  id: 'detail',
  label: 'Detail',
  values: [('chip', 'Badge only'), ('receipt', 'Badge and checks')],
  defaultValue: 'chip',
);

const trustShowForOption = ChoiceOption(
  id: 'show_for',
  label: 'Show for',
  values: [('all', 'Every message'), ('warnings', 'Warnings only')],
  defaultValue: 'all',
);

const senderTrustPanel = PanelSpec(
  id: 'sender_trust',
  area: PanelArea.reader,
  name: 'Sender verification',
  description: 'Signed, forwarded or unverified, from the headers.',
  defaultOn: true,
  options: [trustDetailOption, trustShowForOption],
);

const previewLinesOption = ChoiceOption(
  id: 'lines',
  label: 'Lines',
  values: [('one', 'One line'), ('two', 'Two lines'), ('none', 'None')],
  defaultValue: 'two',
);

const listPreviewPanel = PanelSpec(
  id: 'list_preview',
  area: PanelArea.list,
  name: 'Message preview',
  description: 'How much of the body shows under each sender.',
  defaultOn: true,
  options: [previewLinesOption],
);

const listAttachmentsPanel = PanelSpec(
  id: 'list_attachments',
  area: PanelArea.list,
  name: 'Attachment marker',
  description: 'A paperclip on messages that carry files.',
  defaultOn: true,
);

const listCountPanel = PanelSpec(
  id: 'list_count',
  area: PanelArea.list,
  name: 'Conversation count',
  description: 'How many messages are in a thread, beside the sender.',
  defaultOn: true,
);

const listFlagPanel = PanelSpec(
  id: 'list_flag',
  area: PanelArea.list,
  name: 'Flag marker',
  description: 'Show which messages you have flagged.',
  defaultOn: true,
);

const composerCcPanel = PanelSpec(
  id: 'composer_cc',
  area: PanelArea.composer,
  name: 'Cc and Bcc fields',
  description: 'Keep the copy fields open instead of hiding them behind Cc.',
);

const composerFromPanel = PanelSpec(
  id: 'composer_from',
  area: PanelArea.composer,
  name: 'Sending account',
  description: 'Show which account the message goes from, even with one.',
);

const composerLaterPanel = PanelSpec(
  id: 'composer_later',
  area: PanelArea.composer,
  name: 'Send later',
  description: 'A Later button that holds the message until the time you pick.',
);

const composerUnsubscribePanel = PanelSpec(
  id: 'composer_unsubscribe',
  area: PanelArea.composer,
  name: 'Unsubscribe link',
  description:
      'Where recipients unsubscribe, for mail from a domain that sends '
      'newsletters or lists. It opens by itself when the domain needs one.',
);

const composerRequireTlsPanel = PanelSpec(
  id: 'composer_require_tls',
  area: PanelArea.composer,
  name: 'Require TLS',
  description:
      'A switch that sends the message only over verified TLS on every hop, '
      'or bounces it rather than let it travel in the clear.',
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
    required this.name,
    required this.description,
    required this.prefs,
  });

  final String id;
  final String name;
  final String description;
  final InterfacePrefs prefs;
}

/// The starting points the settings screen offers above the panels.
const classicPreset = InterfacePreset(
  id: 'classic',
  name: 'Classic',
  description: 'The list as a list, with sender verification in the reader.',
  prefs: InterfacePrefs(),
);

const triagePreset = InterfacePreset(
  id: 'triage',
  name: 'Triage',
  description: 'Day headings with counts, and only warn about senders.',
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
  name: 'Reading',
  description: 'Full sender checks, and the copy fields ready to write.',
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
