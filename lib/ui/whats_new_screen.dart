import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/voice.dart';
import '../state/app_scope.dart';
import '../state/whats_new.dart';
import '../theme/tokens.dart';
import '../version.dart';
import 'widgets/common.dart';

/// The latest release followed by nine previous versions. Shown once when
/// an installed version first opens, and from App settings afterwards.
class WhatsNewScreen extends StatefulWidget {
  const WhatsNewScreen({
    super.key,
    this.notes,
    this.history,
    this.service = const WhatsNewService(),
    this.markSeen = false,
    this.onClose,
  }) : assert(notes == null || history == null);

  /// A loaded release, for tests and for opening a known version.
  final WhatsNewNotes? notes;
  final WhatsNewHistory? history;
  final WhatsNewService service;

  /// Record this version as seen when the screen closes.
  final bool markSeen;

  /// Overrides what closing does, for tests. By default it pops.
  final VoidCallback? onClose;

  @override
  State<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends State<WhatsNewScreen> {
  WhatsNewHistory? _history;
  bool _loading = false;
  var _loadEpoch = 0;

  @override
  void initState() {
    super.initState();
    _history = widget.history;
    if (widget.notes case final notes?) {
      _history = WhatsNewHistory(releases: [notes]);
    }
    if (_history == null) unawaited(_load());
  }

  Future<void> _load() async {
    final epoch = ++_loadEpoch;
    setState(() => _loading = true);
    // A saved history is readable immediately while the latest file loads.
    final cached = await widget.service.readCache();
    if (!mounted || epoch != _loadEpoch) return;
    if (cached != null) setState(() => _history ??= cached);
    final history = await widget.service.load(refresh: true);
    if (!mounted || epoch != _loadEpoch) return;
    setState(() {
      _history = history ?? _history;
      _loading = false;
    });
  }

  void _close() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      if (widget.markSeen && appVersion != 'dev') {
        final app = AppScope.read(context);
        unawaited(
          app.updateSettings(
            app.settings.copyWith(lastSeenVersion: appVersion),
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final releases = _history?.releases.take(WhatsNewHistory.limit).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(title: tr(context, 'whatsNew.title'), onBack: _close),
            Expanded(
              child: _loading && releases == null
                  ? const Center(
                      child: SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : releases == null || releases.isEmpty
                  ? _Empty(onRetry: () => unawaited(_load()))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        children: [
                          for (var i = 0; i < releases.length; i++) ...[
                            if (i < 2) ...[
                              SectionLabel(
                                tr(
                                  context,
                                  i == 0
                                      ? 'whatsNew.latest'
                                      : 'whatsNew.previous',
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            _ReleaseNotes(notes: releases[i], latest: i == 0),
                            const SizedBox(height: 24),
                            if (i < releases.length - 1) ...[
                              Divider(color: c.line),
                              const SizedBox(height: 18),
                            ],
                          ],
                          RmOutlineButton(
                            label: tr(context, 'whatsNew.close'),
                            onPressed: _close,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReleaseNotes extends StatelessWidget {
  const _ReleaseNotes({required this.notes, required this.latest});

  final WhatsNewNotes notes;
  final bool latest;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notes.version,
          style: rmText(12, color: c.accent, weight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          notes.title,
          style: rmText(
            latest ? 25 : 20,
            color: c.ink,
            weight: FontWeight.w800,
            height: 1.15,
            tracking: -0.03,
          ),
        ),
        const SizedBox(height: 10),
        Text(notes.summary, style: rmText(14.5, color: c.ink2, height: 1.5)),
        if (notes.items.isNotEmpty) ...[
          const SizedBox(height: 20),
          SectionLabel(tr(context, 'whatsNew.fixed')),
          const SizedBox(height: 10),
          for (final item in notes.items) _ItemRow(item: item),
        ],
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final WhatsNewItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.number != null)
            Container(
              margin: const EdgeInsets.only(top: 1, right: 9),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '#${item.number}',
                style: rmText(11, color: c.accent, weight: FontWeight.w700),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 7, right: 9),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: c.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Expanded(
            child: Text(
              item.title,
              style: rmText(13.5, color: c.ink, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notes_rounded, size: 32, color: c.ink3),
            const SizedBox(height: 12),
            Text(
              tr(context, 'whatsNew.unavailable'),
              textAlign: TextAlign.center,
              style: rmText(14, color: c.ink2, height: 1.45),
            ),
            const SizedBox(height: 14),
            RmOutlineButton(
              label: tr(context, 'whatsNew.retry'),
              height: 44,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
