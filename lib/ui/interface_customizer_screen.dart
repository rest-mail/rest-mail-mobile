import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/voice.dart';
import '../state/app_scope.dart';
import '../state/interface_prefs.dart';
import '../theme/tokens.dart';
import 'interface_settings.dart';
import 'widgets/common.dart';

/// The screens people can arrange, in the order they meet them.
const _screens = <PanelArea>[
  PanelArea.list,
  PanelArea.reader,
  PanelArea.composer,
];

/// One page per screen: a live picture of it, then the components that make
/// it up. Swiping moves between screens; every choice is saved at once.
class InterfaceCustomizerScreen extends StatefulWidget {
  const InterfaceCustomizerScreen({super.key});

  @override
  State<InterfaceCustomizerScreen> createState() =>
      _InterfaceCustomizerScreenState();
}

class _InterfaceCustomizerScreenState extends State<InterfaceCustomizerScreen> {
  late final _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _update(InterfacePrefs prefs) {
    final app = AppScope.read(context);
    unawaited(app.updateSettings(app.settings.copyWith(interface: prefs)));
  }

  void _go(int index) {
    if (index == _index) return;
    setState(() => _index = index);
    unawaited(
      _pages.animateToPage(
        index,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final prefs = app.settings.interface;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'interface.title'),
              onBack: () => Navigator.pop(context),
              trailingText: tr(context, 'interface.presets'),
              onTrailing: () => unawaited(
                showInterfacePresets(context, prefs: prefs, onChanged: _update),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RmSegmented<PanelArea>(
                    options: [
                      (PanelArea.list, tr(context, 'interface.list')),
                      (PanelArea.reader, tr(context, 'interface.reader')),
                      (PanelArea.composer, tr(context, 'interface.composer')),
                    ],
                    value: _screens[_index],
                    onChanged: (area) => _go(_screens.indexOf(area)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: _screens.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  final area = _screens[index];
                  return ListView(
                    key: PageStorageKey(area),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
                    children: [
                      _PreviewFrame(area: area, prefs: prefs),
                      const SizedBox(height: 22),
                      SectionLabel(
                        tr(context, switch (area) {
                          PanelArea.list => 'interface.messageList',
                          PanelArea.reader => 'interface.readingView',
                          PanelArea.composer => 'interface.composerTitle',
                        }),
                      ),
                      const SizedBox(height: 9),
                      PanelEditor(area: area, prefs: prefs, onChanged: _update),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small, honest picture of the screen with the choices in force.
class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({required this.area, required this.prefs});

  final PanelArea area;
  final InterfacePrefs prefs;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.bg,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: c.surface,
              border: Border(bottom: BorderSide(color: c.line)),
            ),
            child: Row(
              children: [
                Icon(
                  switch (area) {
                    PanelArea.list => Icons.inbox_rounded,
                    PanelArea.reader => Icons.mail_outline_rounded,
                    PanelArea.composer => Icons.edit_outlined,
                  },
                  size: 15,
                  color: c.ink3,
                ),
                const SizedBox(width: 7),
                Text(switch (area) {
                  PanelArea.list => tr(context, 'folder.inbox'),
                  PanelArea.reader => tr(context, 'interface.reading'),
                  PanelArea.composer => tr(context, 'compose.title.fresh'),
                }, style: rmText(12.5, color: c.ink, weight: FontWeight.w700)),
                const Spacer(),
                _StatusPill(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: switch (area) {
              PanelArea.list => _ListPreview(prefs: prefs),
              PanelArea.reader => _ReaderPreview(prefs: prefs),
              PanelArea.composer => _ComposerPreview(prefs: prefs),
            },
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      width: 46,
      height: 3,
      decoration: BoxDecoration(
        color: c.line,
        borderRadius: BorderRadius.circular(9),
      ),
    );
  }
}

class _ListPreview extends StatelessWidget {
  const _ListPreview({required this.prefs});

  final InterfacePrefs prefs;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final lines = prefs.isOn(listPreviewPanel)
        ? switch (prefs.choice(listPreviewPanel, previewLinesOption)) {
            'one' => 1,
            'none' => 0,
            _ => 2,
          }
        : 2;
    final days = prefs.isOn(dateSeparatorsPanel);
    final count = prefs.toggle(dateSeparatorsPanel, dayCountOption);
    final attachments = prefs.isOn(listAttachmentsPanel);
    final showCount = prefs.isOn(listCountPanel);
    final flags = prefs.isOn(listFlagPanel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (days) ...[
          Row(
            children: [
              Text(
                tr(context, 'interfacecustomizer.today'),
                style: rmText(
                  9.5,
                  color: c.ink3,
                  weight: FontWeight.w700,
                  tracking: 0.08,
                ),
              ),
              if (count) ...[
                const SizedBox(width: 5),
                Text(
                  '3',
                  style: rmText(9.5, color: c.ink3, weight: FontWeight.w700),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
        ],
        _PreviewRow(
          initials: 'DR',
          sender: 'Dana Ruiz',
          subject: tr(context, 'interfacecustomizer.rotaForNextWeek'),
          lines: lines,
          attachment: attachments,
          count: showCount ? 2 : 0,
          flag: flags,
          unread: true,
        ),
        Divider(height: 12, color: c.line),
        _PreviewRow(
          initials: 'NO',
          sender: 'Nadia Oakline',
          subject: tr(context, 'interfacecustomizer.reSyncLatency'),
          lines: lines,
          attachment: attachments,
          count: 0,
          flag: flags,
          unread: false,
        ),
      ],
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.initials,
    required this.sender,
    required this.subject,
    required this.lines,
    required this.attachment,
    required this.count,
    required this.flag,
    required this.unread,
  });

  final String initials;
  final String sender;
  final String subject;
  final int lines;
  final bool attachment;
  final int count;
  final bool flag;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.accentSoft,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            initials,
            style: rmText(8.5, color: c.accent, weight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      sender,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(
                        11.5,
                        color: c.ink,
                        weight: unread ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 4),
                    Text('$count', style: rmText(9.5, color: c.ink3)),
                  ],
                  const Spacer(),
                  if (flag)
                    Icon(Icons.flag_rounded, size: 10, color: c.tintAmber),
                  const SizedBox(width: 4),
                  Text('09:41', style: rmText(9, color: c.ink3)),
                ],
              ),
              Text(
                subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: rmText(
                  11,
                  color: c.ink,
                  weight: unread ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              for (var i = 0; i < lines; i++)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Container(
                    height: 4,
                    width: i == 0 ? 190 : 145,
                    decoration: BoxDecoration(
                      color: c.line,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              if (attachment)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.attach_file_rounded, size: 9, color: c.ink3),
                      const SizedBox(width: 3),
                      Text('file.pdf', style: rmText(8.5, color: c.ink3)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReaderPreview extends StatelessWidget {
  const _ReaderPreview({required this.prefs});

  final InterfacePrefs prefs;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final trust = prefs.isOn(senderTrustPanel);
    final receipt =
        trust && prefs.choice(senderTrustPanel, trustDetailOption) == 'receipt';
    final warnings =
        trust &&
        prefs.choice(senderTrustPanel, trustShowForOption) == 'warnings';
    final showTrust = trust && !warnings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(context, 'interfacecustomizer.reSyncLatencyOnFlakyNetworks'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: rmText(13, color: c.ink, weight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                'NO',
                style: rmText(8, color: c.accent, weight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nadia Oakline',
                  style: rmText(10.5, color: c.ink, weight: FontWeight.w700),
                ),
                Text('nadia@oakline.test', style: rmText(9, color: c.ink3)),
              ],
            ),
            const Spacer(),
            if (showTrust && !receipt)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: c.accentSoft,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_rounded, size: 9, color: c.accent),
                    const SizedBox(width: 3),
                    Text(
                      'signed',
                      style: rmText(
                        8,
                        color: c.accent,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (receipt) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: c.surface,
              border: Border.all(color: c.line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 11, color: c.accent),
                const SizedBox(width: 5),
                Text(
                  tr(context, 'interfacecustomizer.spfDKIMAndDMARCAligned'),
                  style: rmText(8.5, color: c.ink2),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        for (final width in [240.0, 210.0, 250.0, 180.0])
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              height: 4,
              width: width,
              decoration: BoxDecoration(
                color: c.line,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
      ],
    );
  }
}

class _ComposerPreview extends StatelessWidget {
  const _ComposerPreview({required this.prefs});

  final InterfacePrefs prefs;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final from = prefs.isOn(composerFromPanel);
    final cc = prefs.isOn(composerCcPanel);
    final later = prefs.isOn(composerLaterPanel);
    final unsubscribe = prefs.isOn(composerUnsubscribePanel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              tr(context, 'compose.title.fresh'),
              style: rmText(11.5, color: c.ink, weight: FontWeight.w700),
            ),
            const Spacer(),
            if (later)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  tr(context, 'compose.later'),
                  style: rmText(10, color: c.accent, weight: FontWeight.w700),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: c.accent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                tr(context, 'compose.send'),
                style: rmText(9, color: Colors.white, weight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (from)
          _ComposerField(
            label: tr(context, 'compose.from'),
            value: 'dana@oakline.test',
          ),
        _ComposerField(
          label: tr(context, 'compose.to'),
          value: 'nadia@oakline.test',
        ),
        if (cc) ...[
          _ComposerField(label: tr(context, 'compose.cc'), value: ''),
          _ComposerField(label: tr(context, 'compose.bcc'), value: ''),
        ],
        _ComposerField(
          label: tr(context, 'compose.subject'),
          value: tr(context, 'interfacecustomizer.rotaForNextWeek'),
        ),
        if (unsubscribe)
          _ComposerField(
            label: tr(context, 'compose.unsubscribe'),
            value: 'leave@oakline.test',
          ),
        const SizedBox(height: 8),
        for (final width in [230.0, 200.0, 160.0])
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              height: 4,
              width: width,
              decoration: BoxDecoration(
                color: c.line,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
      ],
    );
  }
}

class _ComposerField extends StatelessWidget {
  const _ComposerField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(label, style: rmText(8.5, color: c.ink3)),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: rmText(9.5, color: value.isEmpty ? c.ink3 : c.ink),
            ),
          ),
        ],
      ),
    );
  }
}
