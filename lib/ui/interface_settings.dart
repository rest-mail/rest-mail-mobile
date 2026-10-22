import 'package:flutter/material.dart';

import '../state/interface_prefs.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// The panels of one screen, with their own options underneath. Adding a
/// panel to the registry adds it here too.
class PanelEditor extends StatelessWidget {
  const PanelEditor({
    super.key,
    required this.area,
    required this.prefs,
    required this.onChanged,
  });

  final PanelArea area;
  final InterfacePrefs prefs;
  final ValueChanged<InterfacePrefs> onChanged;

  @override
  Widget build(BuildContext context) {
    final panels = [
      for (final panel in panelRegistry)
        if (panel.area == area) panel,
    ];
    if (panels.isEmpty) {
      return Text(
        'Nothing to choose on this screen yet.',
        style: rmText(13, color: context.rm.ink3),
      );
    }
    return RmGroup(
      children: [
        for (final panel in panels) ...[
          RmRow(
            label: panel.name,
            subtitle: panel.description,
            trailing: RmSwitch(
              value: prefs.isOn(panel),
              label: panel.name,
              onChanged: (value) => onChanged(prefs.withPanel(panel.id, value)),
            ),
          ),
          if (prefs.isOn(panel))
            for (final option in panel.options) _option(context, panel, option),
        ],
      ],
    );
  }

  Widget _option(BuildContext context, PanelSpec panel, PanelOption option) {
    final c = context.rm;
    switch (option) {
      case ChoiceOption():
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(option.label, style: rmText(13.5, color: c.ink2)),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RmSegmented<String>(
                    options: option.values,
                    value: prefs.choice(panel, option),
                    onChanged: (value) =>
                        onChanged(prefs.withValue(panel.id, option.id, value)),
                  ),
                ),
              ),
            ],
          ),
        );
      case ToggleOption():
        return RmRow(
          label: option.label,
          trailing: RmSwitch(
            value: prefs.toggle(panel, option),
            label: option.label,
            onChanged: (value) =>
                onChanged(prefs.withValue(panel.id, option.id, value)),
          ),
        );
    }
  }
}

/// The named starting points, in a sheet.
Future<void> showInterfacePresets(
  BuildContext context, {
  required InterfacePrefs prefs,
  required ValueChanged<InterfacePrefs> onChanged,
}) => showModalBottomSheet<void>(
  context: context,
  useSafeArea: true,
  clipBehavior: Clip.antiAlias,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (sheet) {
    final c = sheet.rm;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Text(
              'Presets',
              style: rmText(
                17,
                color: c.ink,
                weight: FontWeight.w700,
                tracking: -0.02,
              ),
            ),
          ),
          RmGroup(
            children: [
              for (final preset in interfacePresets)
                RmRow(
                  label: preset.name,
                  subtitle: preset.description,
                  trailing: preset.prefs.matches(prefs)
                      ? Icon(Icons.check_rounded, size: 20, color: c.accent)
                      : const SizedBox(width: 20),
                  onTap: () {
                    onChanged(preset.prefs);
                    Navigator.pop(sheet);
                  },
                ),
            ],
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  },
);

String areaLabel(PanelArea area) => switch (area) {
  PanelArea.list => 'Message list',
  PanelArea.reader => 'Reading view',
  PanelArea.composer => 'Composer',
};
