import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/common.dart';

/// Why the server held a message, from the reason code of the filter step
/// that held it.
String quarantineReasonLabel(BuildContext context, String code) =>
    tr(context, switch (code) {
      'spam_threshold' => 'quarantine.reason.spam',
      'dmarc_quarantine' || 'dmarc_reject' => 'quarantine.reason.dmarc',
      'spf_fail' => 'quarantine.reason.spf',
      'dkim_fail' => 'quarantine.reason.dkim',
      'virus_detected' => 'quarantine.reason.virus',
      'header_invalid' => 'quarantine.reason.headers',
      'custom_reject' => 'quarantine.reason.rule',
      'greylist_defer' => 'quarantine.reason.greylist',
      'size_exceeded' => 'quarantine.reason.size',
      'rate_limited' => 'quarantine.reason.rate',
      _ => 'quarantine.reason.other',
    });

/// What a reason means, for the message's own screen.
String quarantineReasonHelp(BuildContext context, String code) =>
    tr(context, switch (code) {
      'spam_threshold' => 'quarantine.help.spam',
      'dmarc_quarantine' || 'dmarc_reject' => 'quarantine.help.dmarc',
      'spf_fail' => 'quarantine.help.spf',
      'dkim_fail' => 'quarantine.help.dkim',
      'virus_detected' => 'quarantine.help.virus',
      'header_invalid' => 'quarantine.help.headers',
      'custom_reject' => 'quarantine.help.rule',
      _ => 'quarantine.help.other',
    });

/// Mail the account's filters held back instead of delivering: why each one
/// was held, and a way to release it into the inbox or delete it, one at a
/// time or several at once. REST Mail only.
class QuarantineScreen extends StatefulWidget {
  const QuarantineScreen({
    super.key,
    required this.mailbox,
    required this.accountId,
  });

  final MailboxState mailbox;
  final int accountId;

  @override
  State<QuarantineScreen> createState() => _QuarantineScreenState();
}

class _QuarantineScreenState extends State<QuarantineScreen> {
  final _items = <QuarantinedMessage>[];
  int _total = 0;
  bool _loaded = false;
  bool _loadingMore = false;
  Object? _error;
  bool _selecting = false;
  final _selected = <int>{};
  bool _busy = false;

  MailboxState get _mailbox => widget.mailbox;
  String get _host => _mailbox.backend.host;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final page = await _mailbox.backend.quarantine(widget.accountId);
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.items);
        _total = page.total;
        _loaded = true;
        _error = null;
        _selected.removeWhere((id) => !_items.any((m) => m.id == id));
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loaded = true;
      });
    }
  }

  Future<void> _more() async {
    if (_loadingMore) return;
    setState(() => _loadingMore = true);
    try {
      final page = await _mailbox.backend.quarantine(
        widget.accountId,
        offset: _items.length,
      );
      if (!mounted) return;
      setState(() {
        final known = {for (final m in _items) m.id};
        _items.addAll(page.items.where((m) => !known.contains(m.id)));
        _total = page.total;
      });
    } on ApiException catch (e) {
      if (mounted) showToast(context, describeError(context, e, host: _host));
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _gone(Iterable<int> ids) {
    final set = ids.toSet();
    setState(() {
      _items.removeWhere((m) => set.contains(m.id));
      _total = math.max(0, _total - set.length);
      _selected.removeAll(set);
      if (_items.isEmpty) _selecting = false;
    });
  }

  /// Releases or deletes [ids] one by one; stops at the first refusal and
  /// says how far it got.
  Future<void> _apply(List<int> ids, {required bool release}) async {
    if (ids.isEmpty || _busy) return;
    if (!release) {
      final sure = await confirmAction(
        context,
        title: ids.length == 1
            ? tr(context, 'quarantine.deleteOne')
            : trArgs(context, 'quarantine.deleteMany', {
                'count': '${ids.length}',
              }),
        message: tr(context, 'quarantine.deleteManyBody'),
        action: tr(context, 'quarantine.delete'),
      );
      if (!sure || !mounted) return;
    }
    setState(() => _busy = true);
    final done = <int>[];
    try {
      for (final id in ids) {
        if (release) {
          await _mailbox.backend.releaseQuarantined(widget.accountId, id);
        } else {
          await _mailbox.backend.deleteQuarantined(widget.accountId, id);
        }
        done.add(id);
      }
      if (!mounted) return;
      _gone(done);
      showToast(context, switch ((release, done.length == 1)) {
        (true, true) => tr(context, 'quarantine.released'),
        (true, false) => trArgs(context, 'quarantine.releasedMany', {
          'count': '${done.length}',
        }),
        (false, true) => tr(context, 'quarantine.deleted'),
        (false, false) => trArgs(context, 'quarantine.deletedMany', {
          'count': '${done.length}',
        }),
      });
      if (release) unawaited(_mailbox.refresh());
    } on ApiException catch (e) {
      if (!mounted) return;
      _gone(done);
      showToast(context, describeError(context, e, host: _host));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(QuarantinedMessage item) async {
    final outcome = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => QuarantinedMessageScreen(
          mailbox: _mailbox,
          accountId: widget.accountId,
          message: item,
        ),
      ),
    );
    if (outcome == true && mounted) _gone([item.id]);
  }

  void _toggle(int id) => setState(() {
    if (!_selected.remove(id)) _selected.add(id);
  });

  @override
  Widget build(BuildContext context) {
    final canSelect = _loaded && _error == null && _items.isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'mailboxes.quarantine'),
              onBack: () => Navigator.pop(context),
              trailingText: canSelect
                  ? tr(
                      context,
                      _selecting ? 'quarantine.done' : 'quarantine.select',
                    )
                  : null,
              onTrailing: canSelect
                  ? () => setState(() {
                      _selecting = !_selecting;
                      _selected.clear();
                    })
                  : null,
            ),
            Expanded(child: _body(context)),
            if (_selecting) _bulkBar(context),
          ],
        ),
      ),
    );
  }

  Widget _bulkBar(BuildContext context) {
    final c = context.rm;
    final ids = _selected.toList();
    final none = ids.isEmpty || _busy;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: RmOutlineButton(
              label: ids.isEmpty
                  ? tr(context, 'quarantine.delete')
                  : trArgs(context, 'quarantine.deleteCount', {
                      'count': '${ids.length}',
                    }),
              height: 44,
              color: c.danger,
              onPressed: none
                  ? null
                  : () => unawaited(_apply(ids, release: false)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RmPrimaryButton(
              label: ids.isEmpty
                  ? tr(context, 'quarantine.release')
                  : trArgs(context, 'quarantine.releaseCount', {
                      'count': '${ids.length}',
                    }),
              height: 44,
              busy: _busy,
              onPressed: none
                  ? null
                  : () => unawaited(_apply(ids, release: true)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final c = context.rm;
    if (!_loaded) {
      return Center(
        child: SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
        ),
      );
    }
    if (_error case final error?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                describeError(context, error, host: _host),
                textAlign: TextAlign.center,
                style: rmText(14, color: c.ink2, height: 1.4),
              ),
              const SizedBox(height: 14),
              RmOutlineButton(
                label: tr(context, 'quarantine.retry'),
                height: 44,
                onPressed: () => unawaited(_load()),
              ),
            ],
          ),
        ),
      );
    }
    if (_items.isEmpty) {
      return RefreshIndicator(
        color: c.accent,
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Icon(Icons.shield_outlined, size: 34, color: c.ink3),
            const SizedBox(height: 12),
            Text(
              tr(context, 'quarantine.empty'),
              textAlign: TextAlign.center,
              style: rmText(14.5, color: c.ink2, weight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              tr(context, 'quarantine.emptyNote'),
              textAlign: TextAlign.center,
              style: rmText(12.5, color: c.ink3, height: 1.4),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: c.accent,
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        children: [
          SectionLabel(
            _total == 1
                ? tr(context, 'quarantine.heldOne')
                : trArgs(context, 'quarantine.held', {
                    'count': countLabel(_total),
                  }),
          ),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              for (final item in _items)
                RmRow(
                  label: item.subject.trim().isEmpty
                      ? tr(context, 'quarantine.noSubject')
                      : item.subject,
                  subtitle:
                      '${quarantineReasonLabel(context, item.reason)} · '
                      '${item.sender.isEmpty ? tr(context, 'quarantine.unknownSender') : item.sender}',
                  value: switch (item.receivedAt) {
                    final at? => timeLabel(at),
                    null => null,
                  },
                  trailing: _selecting
                      ? Checkbox(
                          value: _selected.contains(item.id),
                          onChanged: _busy ? null : (_) => _toggle(item.id),
                        )
                      : null,
                  onTap: _busy
                      ? null
                      : () => _selecting
                            ? _toggle(item.id)
                            : unawaited(_open(item)),
                ),
            ],
          ),
          if (_items.length < _total) ...[
            const SizedBox(height: 14),
            RmOutlineButton(
              label: tr(
                context,
                _loadingMore ? 'quarantine.loading' : 'quarantine.more',
              ),
              height: 44,
              onPressed: _loadingMore ? null : () => unawaited(_more()),
            ),
          ],
        ],
      ),
    );
  }
}

/// One held message: who sent it, why it was held, the start of it, and
/// release or delete. Pops `true` once it has been released or deleted.
class QuarantinedMessageScreen extends StatefulWidget {
  const QuarantinedMessageScreen({
    super.key,
    required this.mailbox,
    required this.accountId,
    required this.message,
  });

  final MailboxState mailbox;
  final int accountId;
  final QuarantinedMessage message;

  @override
  State<QuarantinedMessageScreen> createState() =>
      _QuarantinedMessageScreenState();
}

class _QuarantinedMessageScreenState extends State<QuarantinedMessageScreen> {
  bool _busy = false;

  QuarantinedMessage get _m => widget.message;

  Future<void> _release() async {
    setState(() => _busy = true);
    try {
      await widget.mailbox.backend.releaseQuarantined(widget.accountId, _m.id);
      if (!mounted) return;
      showToast(context, tr(context, 'quarantine.released'));
      unawaited(widget.mailbox.refresh());
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(
        context,
        describeError(context, e, host: widget.mailbox.backend.host),
      );
    }
  }

  Future<void> _delete() async {
    final sure = await confirmAction(
      context,
      title: tr(context, 'quarantine.deleteOne'),
      message: tr(context, 'quarantine.deleteOneBody'),
      action: tr(context, 'quarantine.delete'),
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.mailbox.backend.deleteQuarantined(widget.accountId, _m.id);
      if (!mounted) return;
      showToast(context, tr(context, 'quarantine.deleted'));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(
        context,
        describeError(context, e, host: widget.mailbox.backend.host),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'quarantine.heldMessage'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                children: [
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'quarantine.subject'),
                        value: _m.subject.trim().isEmpty
                            ? tr(context, 'quarantine.noSubject')
                            : _m.subject,
                      ),
                      RmRow(
                        label: tr(context, 'quarantine.from'),
                        value: _m.sender,
                      ),
                      RmRow(
                        label: tr(context, 'quarantine.why'),
                        value: quarantineReasonLabel(context, _m.reason),
                        subtitle: quarantineReasonHelp(context, _m.reason),
                      ),
                      if (_m.spamScore case final score?)
                        RmRow(
                          label: tr(context, 'quarantine.score'),
                          value: score.toStringAsFixed(1),
                        ),
                      if (_m.receivedAt case final at?)
                        RmRow(
                          label: tr(context, 'quarantine.arrived'),
                          value: longDate(at),
                        ),
                      if (_m.expiresAt case final at?)
                        RmRow(
                          label: tr(context, 'quarantine.expires'),
                          value: longDate(at),
                        ),
                    ],
                  ),
                  if (_m.bodyPreview.trim().isNotEmpty) ...[
                    const SizedBox(height: 22),
                    SectionLabel(tr(context, 'quarantine.preview')),
                    const SizedBox(height: 9),
                    Text(
                      _m.bodyPreview.trim(),
                      style: rmText(14, color: c.ink2, height: 1.45),
                    ),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: tr(context, 'quarantine.releaseToInbox'),
                    busy: _busy,
                    onPressed: _busy ? null : () => unawaited(_release()),
                  ),
                  const SizedBox(height: 10),
                  RmOutlineButton(
                    label: tr(context, 'quarantine.delete'),
                    color: c.danger,
                    onPressed: _busy ? null : () => unawaited(_delete()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
