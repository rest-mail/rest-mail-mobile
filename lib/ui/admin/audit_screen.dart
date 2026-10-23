import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'report_filters.dart';

String _outcomeLabel(String outcome) => switch (outcome) {
  'success' => 'Allowed',
  'denied' => 'Denied',
  'failed' => 'Failed',
  'error' => 'Server error',
  _ => outcome,
};

String _actor(AuditEntry entry) => switch (entry.actorKind) {
  'system' => 'The server',
  _ when entry.actorName.isNotEmpty => entry.actorName,
  _ => 'Someone not signed in',
};

/// What was done on the server and by whom, newest first: the audit log's
/// entries that went through. Tapping one opens it as the audit log does.
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late final _list = AdminList<AuditEntry>.cursor(
    (cursor) => widget.account.client.audit(before: cursor, outcome: 'success'),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.activity)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.activity,
    title: 'Activity',
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: 'Nothing has been done yet.',
      row: (entry) => RmRow(
        label: [entry.action, ?entry.target['address']].join(' · '),
        subtitle: [
          'By ${_actor(entry)} · ${timeLabel(entry.occurredAt)}',
          if (entry.ip.isNotEmpty) 'From ${entry.ip}',
        ].join('\n'),
        onTap: () => pushScreen(
          context,
          AuditEntryScreen(account: widget.account, entry: entry),
        ),
      ),
    ),
  );
}

/// Every sign-in and change on the server, newest first. Each entry carries
/// the hash of the one before, so the server can check that none was changed
/// or taken out: **Verify chain** asks it to. Reading the log is itself
/// recorded.
class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  Map<String, String> _filters = {};
  String? get _outcome => _filters['outcome'];
  late final _list = AdminList<AuditEntry>.cursor(
    (cursor) => widget.account.client.audit(
      before: cursor ?? _filters['before_seq'],
      outcome: _outcome,
      actorKind: _filters['actor_kind'],
      actorId: reportInt(_filters, 'actor_id'),
      actor: _filters['actor'],
      action: _filters['action'],
      since: reportDate(_filters, 'since'),
      until: reportDate(_filters, 'until'),
      limit: reportInt(_filters, 'limit') ?? 50,
    ),
  );
  var _checking = false;
  AuditCheck? _check;
  String? _checkError;

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.audit)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _verify({String? anchor}) async {
    setState(() {
      _checking = true;
      _checkError = null;
      _check = null;
    });
    try {
      final check = await widget.account.client.verifyAudit(anchor: anchor);
      if (mounted) setState(() => _check = check);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _checkError = describeAdminError(e, host: _host));
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _verifyAnchor() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Verify saved anchor',
        host: _host,
        intro:
            'Paste a sequence number and hash saved independently of this server. '
            'This checks that the chain still contains that entry unchanged.',
        fields: const [
          AdminField(
            'Saved anchor',
            hint: '42: followed by its 64-character hash',
          ),
        ],
        action: 'Verify anchor',
        submit: (values) async {
          if (!RegExp(r'^[1-9][0-9]{0,17}:[0-9a-fA-F]{64}$')
              .hasMatch(values[0])) {
            throw const ApiException(
              422,
              'validation_failed',
              'Invalid anchor',
              fields: {
                'anchor': 'must be a positive sequence number, a colon and 64 hex characters',
              },
            );
          }
          await _verify(anchor: values[0]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final check = _check, checkError = _checkError;
    return AdminPage(
      account: widget.account,
      section: AdminSection.audit,
      title: 'Audit log',
      body: (_) => AdminListView(
        list: _list,
        host: _host,
        empty: switch (_outcome) {
          'denied' => 'Nothing was denied.',
          'failed' => 'Nothing failed.',
          'error' => 'The server has had no errors.',
          _ => 'Nothing has been recorded yet.',
        },
        header: [
          ReportFiltersBar(
            host: _host,
            values: _filters,
            fields: const [
              ReportField(
                'actor_kind',
                'Actor kind',
                choices: [
                  ('', 'All'),
                  ('account', 'Account'),
                  ('system', 'Server'),
                  ('anonymous', 'Not signed in'),
                ],
              ),
              ReportField('actor_id', 'Account number', number: true),
              ReportField('actor', 'Actor name contains'),
              ReportField('action', 'Action'),
              ReportField(
                'outcome',
                'Outcome',
                choices: [
                  ('', 'All'),
                  ('success', 'Success'),
                  ('denied', 'Denied'),
                  ('failed', 'Failed'),
                  ('error', 'Server error'),
                ],
              ),
              reportSince,
              reportUntil,
              ReportField(
                'before_seq',
                'Before entry',
                number: true,
                positive: true,
              ),
              reportPageSize,
            ],
            onChanged: (values) {
              setState(() => _filters = values);
              unawaited(_list.reload());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RmOutlineButton(
              label: _checking ? 'Checking the chain…' : 'Verify chain',
              onPressed: _checking ? null : () => unawaited(_verify()),
            ),
          ),
          RmOutlineButton(
            label: 'Verify saved anchor',
            onPressed: _checking ? null : () => unawaited(_verifyAnchor()),
          ),
          const SizedBox(height: 14),
          if (check != null) ...[
            _ChainResult(check),
            const SizedBox(height: 16),
          ],
          if (checkError != null) ...[
            ErrorText(checkError),
            const SizedBox(height: 16),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RmSegmented<String?>(
                options: const [
                  (null, 'All'),
                  ('success', 'Success'),
                  ('denied', 'Denied'),
                  ('failed', 'Failed'),
                  ('error', 'Errors'),
                ],
                value: _outcome,
                onChanged: (outcome) {
                  setState(() => _filters = {..._filters}..remove('outcome'));
                  if (outcome != null) _filters['outcome'] = outcome;
                  unawaited(_list.reload());
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        row: (entry) => RmRow(
          label: _actor(entry),
          subtitle:
              '${entry.action} · ${_outcomeLabel(entry.outcome)} · '
              '${timeLabel(entry.occurredAt)}',
          onTap: () => pushScreen(
            context,
            AuditEntryScreen(account: widget.account, entry: entry),
          ),
        ),
      ),
    );
  }
}

/// What the server found when it walked the chain.
class _ChainResult extends StatelessWidget {
  const _ChainResult(this.check);

  final AuditCheck check;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final broken = check.brokenAtSeq;
    final entries = check.checked == 1
        ? '1 entry'
        : '${countLabel(check.checked)} entries';
    final text = [
      if (check.ok && check.checked == 0)
        'The chain holds: there is nothing in it yet.'
      else if (check.ok && check.checked == 1)
        'The chain holds: its one entry matches its hash.'
      else if (check.ok)
        'The chain holds: all $entries, from ${check.firstSeq} to '
            '${check.lastSeq}, follow one another and match their hashes.'
      else if (broken == null)
        'The chain could not be verified${check.reason.isEmpty ? '.' : ': ${check.reason}.'}'
      else
        [
          'The chain breaks at entry $broken'
              '${check.reason.isEmpty ? '' : ': ${check.reason}'}.',
          if (check.checked == 1)
            'The entry before it holds.'
          else if (check.checked > 1)
            'The $entries before it hold.',
        ].join(' '),
      if (check.note.isNotEmpty) check.note,
      if (check.anchor case final anchor?)
        'Checked against saved anchor ${anchor.value}.',
      if (check.lastHash.isNotEmpty)
        'Last verified entry: ${check.lastSeq}:${check.lastHash}',
      if (check.anchor == null) 'An independently saved anchor can also detect history that was rewritten and rehashed.',
    ].join('\n\n');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: check.ok ? c.good : c.danger),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            check.ok ? Icons.verified_outlined : Icons.gpp_bad_outlined,
            size: 20,
            color: check.ok ? c.good : c.danger,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SelectableText(
              text,
              style: rmText(14, color: c.ink, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

/// One entry, in full.
class AuditEntryScreen extends StatelessWidget {
  const AuditEntryScreen({
    super.key,
    required this.account,
    required this.entry,
  });

  final RestAccount account;
  final AuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final request = '${entry.method} ${entry.route}'.trim();
    return AdminPage(
      account: account,
      section: AdminSection.audit,
      title: 'Entry ${entry.seq}',
      body: (_) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(label: 'When', value: longDate(entry.occurredAt)),
              RmRow(label: 'Who', subtitle: _actor(entry)),
              RmRow(label: 'As', value: entry.actorKind),
              if (entry.actorId case final id?)
                RmRow(label: 'Account number', value: '$id'),
              if (entry.credentialId case final id?)
                RmRow(label: 'Credential number', value: '$id'),
              if (entry.sessionId.isNotEmpty)
                RmRow(label: 'Session', subtitle: entry.sessionId),
              if (entry.requestId.isNotEmpty)
                RmRow(label: 'Request ID', subtitle: entry.requestId),
              RmRow(label: 'Action', value: entry.action),
              RmRow(
                label: 'Outcome',
                value: [
                  _outcomeLabel(entry.outcome),
                  if (entry.status > 0) '${entry.status}',
                ].join(' · '),
              ),
              if (entry.errorCode.isNotEmpty)
                RmRow(label: 'Error', value: entry.errorCode),
              if (request.isNotEmpty)
                RmRow(label: 'Request', subtitle: request),
              for (final MapEntry(:key, :value) in entry.target.entries)
                RmRow(label: key, value: value),
              if (entry.ip.isNotEmpty) RmRow(label: 'From', value: entry.ip),
              if (entry.userAgent.isNotEmpty)
                RmRow(label: 'App', subtitle: entry.userAgent),
            ],
          ),
          const SizedBox(height: 22),
          const SectionLabel('Its hash, and the one before'),
          const SizedBox(height: 9),
          SelectableText(
            'Saved anchor: ${entry.seq}:${entry.hash}\nPrevious hash: ${entry.prevHash}',
            style: rmText(12.5, color: c.ink2, height: 1.5),
          ),
        ],
      ),
    );
  }
}
