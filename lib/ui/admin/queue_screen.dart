import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _statusLabel(QueueStatus status) => switch (status) {
  QueueStatus.pending => 'Pending',
  QueueStatus.delivering => 'Delivering',
  QueueStatus.deferred => 'Deferred',
  QueueStatus.delivered => 'Delivered',
  QueueStatus.bounced => 'Bounced',
  QueueStatus.expired => 'Expired',
  QueueStatus.unknown => 'Unknown',
};

String _attempts(int n) => n == 1 ? '1 attempt' : '$n attempts';

/// Mail on its way out to other servers: what is waiting, what was put off
/// and why, and what bounced. With `queue:manage`, an entry can be retried,
/// bounced or dropped.
class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  QueueStatus? _status;
  QueueStats? _stats;
  late final _list = AdminList<QueueEntry>(
    (offset) => widget.account.client.queue(status: _status, offset: offset),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.queue)) {
      unawaited(_reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _reload() => Future.wait([_list.reload(), _loadStats()]);

  Future<void> _loadStats() async {
    try {
      final stats = await widget.account.client.queueStats();
      if (mounted) setState(() => _stats = stats);
    } on ApiException {
      // The list says what went wrong.
    }
  }

  Future<void> _open(QueueEntry entry) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => QueueEntryScreen(account: widget.account, entry: entry),
      ),
    );
    if (done == null || !mounted) return;
    showToast(context, done);
    unawaited(_reload());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final stats = _stats;
    return AdminPage(
      account: widget.account,
      section: AdminSection.queue,
      title: 'Outbound queue',
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: _status == null
            ? 'Nothing in the queue.'
            : 'Nothing ${_statusLabel(_status!).toLowerCase()}.',
        onRefresh: _reload,
        header: [
          if (stats != null) ...[
            Text(
              '${countLabel(stats.of(QueueStatus.pending))} pending · '
              '${countLabel(stats.of(QueueStatus.deferred))} deferred · '
              '${countLabel(stats.of(QueueStatus.bounced))} bounced',
              style: rmText(13, color: c.ink3),
            ),
            const SizedBox(height: 12),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RmSegmented<QueueStatus?>(
                options: const [
                  (null, 'All'),
                  (QueueStatus.deferred, 'Deferred'),
                  (QueueStatus.pending, 'Pending'),
                  (QueueStatus.bounced, 'Bounced'),
                ],
                value: _status,
                onChanged: (status) {
                  setState(() => _status = status);
                  unawaited(_list.reload());
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        row: (entry) => RmRow(
          label: entry.recipient,
          subtitle: [
            '${_statusLabel(entry.status)} · ${_attempts(entry.attempts)} · '
                '${timeLabel(entry.createdAt)}',
            if (entry.lastError.isNotEmpty) entry.lastError,
          ].join('\n'),
          onTap: () => unawaited(_open(entry)),
        ),
      ),
    );
  }
}

/// One queued message, and what can be done with it. Pops with what was
/// done, for the queue to say.
class QueueEntryScreen extends StatefulWidget {
  const QueueEntryScreen({
    super.key,
    required this.account,
    required this.entry,
  });

  final RestAccount account;
  final QueueEntry entry;

  @override
  State<QueueEntryScreen> createState() => _QueueEntryScreenState();
}

class _QueueEntryScreenState extends State<QueueEntryScreen> {
  var _busy = false;

  Future<void> _act(
    Future<void> Function() change,
    String done, {
    ({String title, String message, String action})? confirm,
  }) async {
    setState(() => _busy = true);
    final ok = await runAdminChange(
      context,
      host: widget.account.server.host,
      change: change,
      confirm: confirm,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, done);
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final entry = widget.entry;
    final client = widget.account.client;
    final next = entry.nextAttempt;
    return AdminPage(
      account: widget.account,
      section: AdminSection.queue,
      title: 'Queued message',
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(label: 'To', value: entry.recipient),
              RmRow(label: 'From', value: entry.sender),
              RmRow(label: 'Status', value: _statusLabel(entry.status)),
              RmRow(
                label: 'Attempts',
                value: entry.maxRetries > 0
                    ? '${entry.attempts} of ${entry.maxRetries}'
                    : '${entry.attempts}',
              ),
              RmRow(label: 'Queued', value: longDate(entry.createdAt)),
              if (next != null && entry.status.canRetry)
                RmRow(label: 'Next try', value: longDate(next)),
            ],
          ),
          if (entry.lastError.isNotEmpty) ...[
            const SizedBox(height: 22),
            const SectionLabel('Last answer'),
            const SizedBox(height: 9),
            SelectableText(
              entry.lastError,
              style: rmText(14, color: c.ink2, height: 1.45),
            ),
          ],
          if (access.canWrite(AdminSection.queue) ||
              access.canDelete(AdminSection.queue)) ...[
            const SizedBox(height: 22),
            RmGroup(
              children: [
                if (access.canWrite(AdminSection.queue) &&
                    entry.status.canRetry)
                  RmRow(
                    label: 'Retry now',
                    onTap: _busy
                        ? null
                        : () => unawaited(
                            _act(
                              () => client.retryQueueEntry(entry.id),
                              'Retrying ${entry.recipient}',
                            ),
                          ),
                  ),
                if (access.canWrite(AdminSection.queue) &&
                    entry.status.canRetry)
                  RmRow(
                    label: 'Bounce to sender',
                    onTap: _busy
                        ? null
                        : () => unawaited(
                            _act(
                              () => client.bounceQueueEntry(entry.id),
                              'Bounced',
                              confirm: (
                                title: 'Bounce this message?',
                                message:
                                    'It is not tried again, and '
                                    '${entry.sender} is told it was not '
                                    'delivered to ${entry.recipient}.',
                                action: 'Bounce',
                              ),
                            ),
                          ),
                  ),
                if (access.canDelete(AdminSection.queue))
                  RmRow(
                    label: 'Delete',
                    danger: true,
                    onTap: _busy
                        ? null
                        : () => unawaited(
                            _act(
                              () => client.deleteQueueEntry(entry.id),
                              'Deleted',
                              confirm: (
                                title: 'Delete this message?',
                                message:
                                    'It leaves the queue without being '
                                    'delivered, and no one is told.',
                                action: 'Delete',
                              ),
                            ),
                          ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
