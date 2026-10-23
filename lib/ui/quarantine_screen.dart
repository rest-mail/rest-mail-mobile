import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/common.dart';

/// Why the server held a message, from the reason code of the filter step
/// that held it.
String quarantineReasonLabel(String code) => switch (code) {
  'spam_threshold' => 'Scored as spam',
  'dmarc_quarantine' || 'dmarc_reject' => 'Failed DMARC',
  'spf_fail' => 'Failed SPF',
  'dkim_fail' => 'Failed DKIM',
  'virus_detected' => 'Carried a virus',
  'header_invalid' => 'Broken headers',
  'custom_reject' => 'Held by a filter rule',
  'greylist_defer' => 'Greylisted',
  'size_exceeded' => 'Too large',
  'rate_limited' => 'Sent too fast',
  _ => 'Held by your filters',
};

/// What a reason means, for the message's own screen.
String quarantineReasonHelp(String code) => switch (code) {
  'spam_threshold' => 'The spam filter scored it above the line.',
  'dmarc_quarantine' || 'dmarc_reject' =>
    "It claims to be from a domain whose DMARC policy it didn't pass.",
  'spf_fail' => "It came from a server the sender's domain doesn't allow.",
  'dkim_fail' => "Its signature didn't check out.",
  'virus_detected' => 'The virus scanner found something in it.',
  'header_invalid' => "Its headers aren't well formed.",
  'custom_reject' => 'One of your filter rules held it.',
  _ => 'Your mail filters held it back.',
};

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
      if (mounted) showToast(context, describeError(e, host: _host));
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
            ? 'Delete this message?'
            : 'Delete ${ids.length} messages?',
        message: 'They are gone for good, and never reach your inbox.',
        action: 'Delete',
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
      showToast(
        context,
        release
            ? (done.length == 1
                  ? 'Released to your inbox'
                  : 'Released ${done.length} to your inbox')
            : (done.length == 1 ? 'Deleted' : 'Deleted ${done.length}'),
      );
      if (release) unawaited(_mailbox.refresh());
    } on ApiException catch (e) {
      if (!mounted) return;
      _gone(done);
      showToast(context, describeError(e, host: _host));
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
              title: 'Quarantine',
              onBack: () => Navigator.pop(context),
              trailingText: canSelect ? (_selecting ? 'Done' : 'Select') : null,
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
              label: ids.isEmpty ? 'Delete' : 'Delete ${ids.length}',
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
              label: ids.isEmpty ? 'Release' : 'Release ${ids.length}',
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
                describeError(error, host: _host),
                textAlign: TextAlign.center,
                style: rmText(14, color: c.ink2, height: 1.4),
              ),
              const SizedBox(height: 14),
              RmOutlineButton(
                label: 'Try again',
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
              'Nothing is held back.',
              textAlign: TextAlign.center,
              style: rmText(14.5, color: c.ink2, weight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Mail your filters doubt waits here for you to release or '
              'delete.',
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
          SectionLabel(_total == 1 ? '1 held' : '${countLabel(_total)} held'),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              for (final item in _items)
                RmRow(
                  label: item.subject.trim().isEmpty
                      ? '(no subject)'
                      : item.subject,
                  subtitle:
                      '${quarantineReasonLabel(item.reason)} · '
                      '${item.sender.isEmpty ? 'Unknown sender' : item.sender}',
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
              label: _loadingMore ? 'Loading…' : 'Show more',
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
      showToast(context, 'Released to your inbox');
      unawaited(widget.mailbox.refresh());
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, describeError(e, host: widget.mailbox.backend.host));
    }
  }

  Future<void> _delete() async {
    final sure = await confirmAction(
      context,
      title: 'Delete this message?',
      message: 'It is gone for good, and never reaches your inbox.',
      action: 'Delete',
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.mailbox.backend.deleteQuarantined(widget.accountId, _m.id);
      if (!mounted) return;
      showToast(context, 'Deleted');
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, describeError(e, host: widget.mailbox.backend.host));
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
              title: 'Held message',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                children: [
                  RmGroup(
                    children: [
                      RmRow(
                        label: 'Subject',
                        value: _m.subject.trim().isEmpty
                            ? '(no subject)'
                            : _m.subject,
                      ),
                      RmRow(label: 'From', value: _m.sender),
                      RmRow(
                        label: 'Why',
                        value: quarantineReasonLabel(_m.reason),
                        subtitle: quarantineReasonHelp(_m.reason),
                      ),
                      if (_m.spamScore case final score?)
                        RmRow(
                          label: 'Spam score',
                          value: score.toStringAsFixed(1),
                        ),
                      if (_m.receivedAt case final at?)
                        RmRow(label: 'Arrived', value: longDate(at)),
                      if (_m.expiresAt case final at?)
                        RmRow(label: 'Deleted after', value: longDate(at)),
                    ],
                  ),
                  if (_m.bodyPreview.trim().isNotEmpty) ...[
                    const SizedBox(height: 22),
                    const SectionLabel('Preview'),
                    const SizedBox(height: 9),
                    Text(
                      _m.bodyPreview.trim(),
                      style: rmText(14, color: c.ink2, height: 1.45),
                    ),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: 'Release to inbox',
                    busy: _busy,
                    onPressed: _busy ? null : () => unawaited(_release()),
                  ),
                  const SizedBox(height: 10),
                  RmOutlineButton(
                    label: 'Delete',
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
