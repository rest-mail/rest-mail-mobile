import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

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
  String? _outcome;
  late final _list = AdminList<AuditEntry>.cursor(
    (cursor) => widget.account.client.audit(before: cursor, outcome: _outcome),
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

  Future<void> _verify() async {
    setState(() {
      _checking = true;
      _checkError = null;
    });
    try {
      final check = await widget.account.client.verifyAudit();
      if (mounted) setState(() => _check = check);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _checkError = describeAdminError(e, host: _host));
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
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
        empty: _outcome == null
            ? 'Nothing has been recorded yet.'
            : 'Nothing ${_outcomeLabel(_outcome!).toLowerCase()}.',
        header: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RmOutlineButton(
              label: _checking ? 'Checking the chain…' : 'Verify chain',
              onPressed: _checking ? null : () => unawaited(_verify()),
            ),
          ),
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
                  ('denied', 'Denied'),
                  ('failed', 'Failed'),
                  ('error', 'Errors'),
                ],
                value: _outcome,
                onChanged: (outcome) {
                  setState(() => _outcome = outcome);
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
      else if (check.ok)
        'The chain holds: all $entries, from ${check.firstSeq} to '
            '${check.lastSeq}, follow one another and match their hashes.'
      else
        'The chain breaks at entry $broken'
            '${check.reason.isEmpty ? '' : ': ${check.reason}'}. '
            'The $entries before it hold.',
      if (check.note.isNotEmpty) check.note,
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
            child: Text(text, style: rmText(14, color: c.ink, height: 1.45)),
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
            '${entry.hash}\n${entry.prevHash}',
            style: rmText(12.5, color: c.ink2, height: 1.5),
          ),
        ],
      ),
    );
  }
}
