import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/voice.dart';
import '../state/app_scope.dart';
import '../state/whats_new.dart';
import '../theme/tokens.dart';
import '../version.dart';
import 'widgets/common.dart';

/// The release notes for the version on the phone. Shown by itself the first
/// time that version opens, and from App settings afterwards.
class WhatsNewScreen extends StatefulWidget {
  const WhatsNewScreen({
    super.key,
    this.notes,
    this.markSeen = false,
    this.onClose,
  });

  /// A loaded release, for tests and for opening a known version.
  final WhatsNewNotes? notes;

  /// Record this version as seen when the screen closes.
  final bool markSeen;

  /// Overrides what closing does, for tests. By default it pops.
  final VoidCallback? onClose;

  @override
  State<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends State<WhatsNewScreen> {
  static const _service = WhatsNewService();

  WhatsNewNotes? _notes;
  bool _loading = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _notes = widget.notes;
    if (_notes == null) unawaited(_load());
  }

  Future<void> _load({bool refresh = false}) async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final notes = await _service.load(appVersion, refresh: refresh);
    if (!mounted) return;
    setState(() {
      _notes = notes;
      _loading = false;
      _failed = notes == null;
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
    final notes = _notes;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(title: tr(context, 'whatsNew.title'), onBack: _close),
            Expanded(
              child: _loading
                  ? const Center(
                      child: SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : notes == null
                  ? _Empty(onRetry: () => unawaited(_load(refresh: true)))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      children: [
                        Text(
                          notes.title,
                          style: rmText(
                            25,
                            color: c.ink,
                            weight: FontWeight.w800,
                            height: 1.15,
                            tracking: -0.03,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          notes.summary,
                          style: rmText(14.5, color: c.ink2, height: 1.5),
                        ),
                        if (notes.items.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          SectionLabel(tr(context, 'whatsNew.fixed')),
                          const SizedBox(height: 10),
                          for (final item in notes.items) _ItemRow(item: item),
                        ],
                        const SizedBox(height: 28),
                        RmOutlineButton(
                          label: tr(context, 'whatsNew.close'),
                          onPressed: _close,
                        ),
                      ],
                    ),
            ),
            if (_failed) const SizedBox.shrink(),
          ],
        ),
      ),
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
