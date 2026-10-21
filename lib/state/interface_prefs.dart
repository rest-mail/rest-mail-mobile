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

/// Everything the user can add to or remove from their client.
const panelRegistry = <PanelSpec>[dateSeparatorsPanel, senderTrustPanel];

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
}
