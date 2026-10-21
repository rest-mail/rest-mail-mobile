import 'package:flutter/material.dart';

import '../state/interface_prefs.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// Every panel in the registry, grouped by the area it belongs to, with its
/// own options underneath. Adding a panel to the registry adds it here too.
class InterfaceSettings extends StatelessWidget {
  const InterfaceSettings({
    super.key,
    required this.prefs,
    required this.onChanged,
  });

  final InterfacePrefs prefs;
  final ValueChanged<InterfacePrefs> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final area in PanelArea.values) ..._area(context, area)],
    );
  }

  List<Widget> _area(BuildContext context, PanelArea area) {
    final panels = [
      for (final panel in panelRegistry)
        if (panel.area == area) panel,
    ];
    if (panels.isEmpty) return const <Widget>[];
    return [
      const SizedBox(height: 22),
      SectionLabel(_areaLabel(area)),
      const SizedBox(height: 9),
      RmGroup(
        children: [
          for (final panel in panels) ...[
            RmRow(
              label: panel.name,
              subtitle: panel.description,
              trailing: RmSwitch(
                value: prefs.isOn(panel),
                label: panel.name,
                onChanged: (value) =>
                    onChanged(prefs.withPanel(panel.id, value)),
              ),
            ),
            if (prefs.isOn(panel))
              for (final option in panel.options)
                _option(context, panel, option),
          ],
        ],
      ),
    ];
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
              RmSegmented<String>(
                options: option.values,
                value: prefs.choice(panel, option),
                onChanged: (value) =>
                    onChanged(prefs.withValue(panel.id, option.id, value)),
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

  String _areaLabel(PanelArea area) => switch (area) {
    PanelArea.list => 'Message list',
    PanelArea.reader => 'Reading view',
    PanelArea.composer => 'Composer',
  };
}
