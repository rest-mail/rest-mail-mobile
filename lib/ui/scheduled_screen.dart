import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// The messages the server is holding to send later, with a way to call one
/// back before its time.
class ScheduledScreen extends StatefulWidget {
  const ScheduledScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<ScheduledScreen> createState() => _ScheduledScreenState();
}

class _ScheduledScreenState extends State<ScheduledScreen> {
  List<ScheduledSend>? _items;
  Object? _error;
  final _cancelling = <int>{};

  MailboxState get _mailbox => widget.mailbox;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final items = await _mailbox.backend.scheduledSends();
      if (!mounted) return;
      setState(() {
        _items = items;
        _error = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _cancel(ScheduledSend item) async {
    if (!_cancelling.add(item.id)) return;
    setState(() {});
    try {
      await _mailbox.backend.cancelScheduledSend(item.id);
      if (!mounted) return;
      setState(
        () => _items = [...?_items]..removeWhere((each) => each.id == item.id),
      );
      showToast(context, 'Cancelled');
    } on ApiException catch (e) {
      if (!mounted) return;
      showToast(context, describeError(e, host: _mailbox.backend.host));
    } finally {
      _cancelling.remove(item.id);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(title: 'Scheduled', onBack: () => Navigator.pop(context)),
            Expanded(child: _body(context)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final c = context.rm;
    final items = _items;
    if (items == null && _error == null) {
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
                describeError(error, host: _mailbox.backend.host),
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
    if (items!.isEmpty) {
      return RefreshIndicator(
        color: c.accent,
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Icon(Icons.schedule_send_rounded, size: 34, color: c.ink3),
            const SizedBox(height: 12),
            Text(
              'Nothing is waiting to be sent.',
              textAlign: TextAlign.center,
              style: rmText(14.5, color: c.ink2, weight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'A message you send later appears here until its time.',
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
          const SectionLabel('Waiting'),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              for (final item in items)
                RmRow(
                  label: item.subject.trim().isEmpty
                      ? '(no subject)'
                      : item.subject,
                  subtitle: 'To ${item.to.join(', ')}',
                  value: _when(item.scheduledAt),
                  trailing: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: _cancelling.contains(item.id)
                        ? null
                        : () => unawaited(_cancel(item)),
                    child: Text(
                      'Cancel',
                      style: rmText(
                        13,
                        color: c.danger,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _when(DateTime at) {
    final now = DateTime.now();
    final days = DateTime.utc(
      at.year,
      at.month,
      at.day,
    ).difference(DateTime.utc(now.year, now.month, now.day)).inDays;
    final clock = DateFormat.Hm().format(at);
    if (days == 0) return 'Today $clock';
    if (days == 1) return 'Tomorrow $clock';
    if (days > 1 && days < 7) return '${DateFormat.E().format(at)} $clock';
    return DateFormat('d MMM, HH:mm').format(at);
  }
}
