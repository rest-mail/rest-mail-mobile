import 'package:flutter/material.dart';

import '../l10n/voice.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// Asks which of [labels] a message should carry, starting from
/// [selected]. Null if the sheet was closed without Done.
Future<Set<String>?> pickLabels(
  BuildContext context, {
  required List<String> labels,
  required Set<String> selected,
}) => showModalBottomSheet<Set<String>>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  clipBehavior: Clip.antiAlias,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (_) => _LabelsSheet(labels: labels, selected: selected),
);

class _LabelsSheet extends StatefulWidget {
  const _LabelsSheet({required this.labels, required this.selected});

  final List<String> labels;
  final Set<String> selected;

  @override
  State<_LabelsSheet> createState() => _LabelsSheetState();
}

class _LabelsSheetState extends State<_LabelsSheet> {
  late final _chosen = {...widget.selected};

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Text(
              tr(context, 'labels.title'),
              style: rmText(17, color: c.ink, weight: FontWeight.w800),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RmGroup(
                children: [
                  for (final label in widget.labels)
                    RmRow(
                      label: folderLabelOf(context, label),
                      trailing: Icon(
                        _chosen.contains(label)
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        size: 22,
                        color: _chosen.contains(label) ? c.accent : c.ink3,
                      ),
                      onTap: () => setState(() {
                        if (!_chosen.remove(label)) _chosen.add(label);
                      }),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: RmPrimaryButton(
              label: tr(context, 'common.done'),
              height: 44,
              radius: 11,
              fontSize: 14.5,
              onPressed: () => Navigator.pop(context, _chosen),
            ),
          ),
        ],
      ),
    );
  }
}
