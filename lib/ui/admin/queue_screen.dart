import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String queueStatusLabel(QueueStatus status) => switch (status) {
  QueueStatus.pending => 'Pending',
  QueueStatus.delivering => 'Delivering',
  QueueStatus.deferred => 'Deferred',
  QueueStatus.delivered => 'Delivered',
  QueueStatus.bounced => 'Bounced',
  QueueStatus.expired => 'Expired',
  QueueStatus.unknown => 'Unknown',
};

String attemptsLabel(int n) => n == 1 ? '1 attempt' : '$n attempts';

enum _BulkAction { retry, bounce, delete }

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
  QueueFilter _filter = const QueueFilter();
  final _domain = TextEditingController();
  final _sender = TextEditingController();
  final _recipient = TextEditingController();
  final _selected = <int>{};
  var _selecting = false;
  var _allMatching = false;
  var _changing = false;
  var _opening = false;
  QueueStats? _stats;
  late final _list = AdminList<QueueEntry>(
    (offset) => widget.account.client.queue(
      status: _filter.status,
      domain: _filter.domain,
      sender: _filter.sender,
      recipient: _filter.recipient,
      offset: offset,
    ),
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
    _domain.dispose();
    _sender.dispose();
    _recipient.dispose();
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
    if (_selecting) {
      _select(entry.id);
      return;
    }
    if (_opening) return;
    _opening = true;
    QueueEntry fresh;
    try {
      fresh = await widget.account.client.queueEntry(entry.id);
    } on ApiException catch (error) {
      if (mounted) {
        showToast(context, describeAdminError(context, error, host: _host));
      }
      return;
    } finally {
      _opening = false;
    }
    if (!mounted) return;
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => QueueEntryScreen(account: widget.account, entry: fresh),
      ),
    );
    if (done == null || !mounted) return;
    showToast(context, done);
    unawaited(_reload());
  }

  String? _value(TextEditingController controller) =>
      controller.text.trim().isEmpty ? null : controller.text.trim();

  void _apply({QueueStatus? status, bool useFields = false}) {
    setState(() {
      _filter = QueueFilter(
        status: status,
        domain: useFields ? _value(_domain) : _filter.domain,
        sender: useFields ? _value(_sender) : _filter.sender,
        recipient: useFields ? _value(_recipient) : _filter.recipient,
      );
      _selected.clear();
      _allMatching = false;
    });
    unawaited(_list.reload());
  }

  void _select(int id) {
    if (_allMatching || _changing) return;
    if (!_selected.contains(id) && _selected.length == 1000) {
      showToast(context, 'Select at most 1000 messages, or use all matches.');
      return;
    }
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
  }

  Future<void> _bulk(_BulkAction action) async {
    if (_changing || (!_allMatching && _selected.isEmpty)) return;
    final selection = _allMatching
        ? QueueSelection.filter(_filter)
        : QueueSelection.ids(_selected.toList());
    final target = _allMatching
        ? _filter.toJson().isEmpty
              ? 'the entire queue'
              : 'all entries matching ${_filter.toJson().entries.map((e) => '${e.key}: ${e.value}').join(', ')}'
        : '${_selected.length} selected messages';
    final verb = switch (action) {
      _BulkAction.retry => 'Retry',
      _BulkAction.bounce => 'Bounce',
      _BulkAction.delete => 'Delete',
    };
    final sure = await confirmAction(
      context,
      title: '$verb these messages?',
      message:
          '$verb $target across all matching pages. ${switch (action) {
            _BulkAction.retry => 'Only pending or deferred entries will be retried.',
            _BulkAction.bounce => 'Only entries still in flight will be marked bounced.',
            _BulkAction.delete => 'They leave the queue without delivery or notification.',
          }}',
      action: verb,
    );
    if (!sure || !mounted) return;
    setState(() => _changing = true);
    try {
      final client = widget.account.client;
      final result = await switch (action) {
        _BulkAction.retry => client.bulkRetryQueue(selection),
        _BulkAction.bounce => client.bulkBounceQueue(selection),
        _BulkAction.delete => client.bulkDeleteQueue(selection),
      };
      if (!mounted) return;
      setState(() {
        _selected.clear();
        _allMatching = false;
        _selecting = false;
      });
      showToast(context, '${result.affected} queue entries changed');
      await _reload();
    } on ApiException catch (error) {
      if (mounted) {
        showToast(context, describeAdminError(context, error, host: _host));
      }
    } finally {
      if (mounted) setState(() => _changing = false);
    }
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
        empty: _filter.status == null
            ? 'Nothing in the queue.'
            : 'Nothing ${queueStatusLabel(_filter.status!).toLowerCase()}.',
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
            Text(
              '${stats.total} total · ${stats.of(QueueStatus.delivering)} delivering · '
              '${stats.of(QueueStatus.delivered)} delivered · ${stats.of(QueueStatus.expired)} expired',
              style: rmText(13, color: c.ink3),
            ),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RmSegmented<QueueStatus?>(
                options: [
                  (null, 'All'),
                  for (final status in QueueStatus.values)
                    if (status != QueueStatus.unknown)
                      (status, queueStatusLabel(status)),
                ],
                value: _filter.status,
                onChanged: (status) {
                  if (!_changing) _apply(status: status);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          ExpansionTile(
            title: const Text('Filter queue'),
            children: [
              for (final (label, controller) in [
                ('Domain', _domain),
                ('Sender', _sender),
                ('Recipient', _recipient),
              ])
                TextField(
                  controller: controller,
                  enabled: !_changing,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(labelText: label),
                ),
              Wrap(
                children: [
                  TextButton(
                    onPressed: _changing
                        ? null
                        : () => _apply(status: _filter.status, useFields: true),
                    child: const Text('Apply filters'),
                  ),
                  TextButton(
                    onPressed: _changing
                        ? null
                        : () {
                            _domain.clear();
                            _sender.clear();
                            _recipient.clear();
                            _apply(useFields: true);
                          },
                    child: const Text('Clear filters'),
                  ),
                ],
              ),
            ],
          ),
          if (access.canWrite(AdminSection.queue)) ...[
            TextButton(
              onPressed: _changing
                  ? null
                  : () => setState(() {
                      _selecting = !_selecting;
                      _selected.clear();
                      _allMatching = false;
                    }),
              child: Text(_selecting ? 'Cancel selection' : 'Select messages'),
            ),
            if (_selecting) ...[
              CheckboxListTile(
                value: _allMatching,
                title: const Text('All matching entries'),
                subtitle: const Text('Includes every matching page'),
                onChanged: _changing
                    ? null
                    : (value) => setState(() {
                        _allMatching = value ?? false;
                        _selected.clear();
                      }),
              ),
              TextButton(
                onPressed: _changing || _allMatching
                    ? null
                    : () => setState(() {
                        _selected.addAll(
                          _list.items
                              .map((e) => e.id)
                              .where((id) => !_selected.contains(id))
                              .take(1000 - _selected.length),
                        );
                      }),
                child: const Text('Select loaded messages'),
              ),
              Text(
                _allMatching
                    ? 'All matching entries selected'
                    : '${_selected.length} selected',
              ),
              Wrap(
                children: [
                  for (final action in _BulkAction.values)
                    TextButton(
                      onPressed:
                          _changing || (!_allMatching && _selected.isEmpty)
                          ? null
                          : () => unawaited(_bulk(action)),
                      child: Text(
                        '${switch (action) {
                          _BulkAction.retry => 'Retry',
                          _BulkAction.bounce => 'Bounce',
                          _BulkAction.delete => 'Delete',
                        }} messages',
                      ),
                    ),
                ],
              ),
            ],
          ],
        ],
        row: (entry) => Row(
          children: [
            if (_selecting)
              Checkbox(
                value: _allMatching || _selected.contains(entry.id),
                onChanged: _changing || _allMatching
                    ? null
                    : (_) => _select(entry.id),
              ),
            Expanded(
              child: RmRow(
                label: entry.recipient,
                subtitle: [
                  '${queueStatusLabel(entry.status)} · ${attemptsLabel(entry.attempts)} · '
                      '${timeLabel(entry.createdAt)}',
                  if (entry.lastError.isNotEmpty) entry.lastError,
                ].join('\n'),
                onTap: () => unawaited(_open(entry)),
              ),
            ),
          ],
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
              RmRow(label: 'Queue ID', value: '${entry.id}'),
              if (entry.messageId case final id?)
                RmRow(label: 'Message ID', value: '$id'),
              RmRow(label: 'Destination domain', value: entry.domain),
              if (entry.bodyType.isNotEmpty)
                RmRow(label: 'Body type', value: entry.bodyType),
              RmRow(label: 'Status', value: queueStatusLabel(entry.status)),
              RmRow(
                label: 'Attempts',
                value: entry.maxRetries > 0
                    ? '${entry.attempts} of ${entry.maxRetries}'
                    : '${entry.attempts}',
              ),
              RmRow(label: 'Queued', value: longDate(entry.createdAt)),
              if (entry.lastAttempt case final at?)
                RmRow(label: 'Last try', value: longDate(at)),
              if (entry.expiresAt case final at?)
                RmRow(label: 'Expires', value: longDate(at)),
              if (entry.failureCategory.isNotEmpty)
                RmRow(
                  label: 'Failure type',
                  value: entry.failureCategory.replaceAll('_', ' '),
                ),
              if (entry.lastErrorCode != 0)
                RmRow(label: 'SMTP response', value: '${entry.lastErrorCode}'),
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
