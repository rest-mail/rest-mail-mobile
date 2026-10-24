import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'report_filters.dart';

String _outcomeLabel(BuildContext context, String outcome) => switch (outcome) {
  'success' => tr(context, 'admin.audit.allowed'),
  'denied' => tr(context, 'admin.audit.denied'),
  'failed' => tr(context, 'admin.audit.failed'),
  'error' => tr(context, 'admin.audit.serverError'),
  _ => outcome,
};

String _actor(BuildContext context, AuditEntry entry) =>
    switch (entry.actorKind) {
      'system' => tr(context, 'admin.audit.theServer'),
      _ when entry.actorName.isNotEmpty => entry.actorName,
      _ => tr(context, 'admin.audit.someoneNotSignedIn'),
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
    title: tr(context, 'admin.section.activity.title'),
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: tr(context, 'admin.audit.nothingHasBeenDoneYet'),
      row: (entry) => RmRow(
        label: [entry.action, ?entry.target['address']].join(' · '),
        subtitle: [
          trArgs(context, 'admin.audit.byValueValue2', {
            'value': (_actor(context, entry)).toString(),
            'value2': (timeLabel(entry.occurredAt)).toString(),
          }),
          if (entry.ip.isNotEmpty)
            trArgs(context, 'admin.audit.fromIp', {
              'ip': (entry.ip).toString(),
            }),
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
        setState(
          () => _checkError = describeAdminError(context, e, host: _host),
        );
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _verifyAnchor() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'admin.audit.verifySavedAnchor'),
        host: _host,
        intro: tr(context, 'admin.audit.pasteASequenceNumberAndHashSaved'),
        fields: [
          AdminField(
            tr(context, 'admin.audit.savedAnchor'),
            hint: tr(context, 'admin.audit.42FollowedByIts64CharacterHash'),
          ),
        ],
        action: tr(context, 'admin.audit.verifyAnchor'),
        submit: (values) async {
          if (!RegExp(r'^[1-9][0-9]{0,17}:[0-9a-fA-F]{64}$')
              .hasMatch(values[0])) {
            throw ApiException(
              422,
              'validation_failed',
              tr(context, 'admin.audit.invalidAnchor'),
              fields: {
                'anchor': tr(
                  context,
                  'admin.audit.mustBeAPositiveSequenceNumberA',
                ),
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
      title: tr(context, 'admin.section.audit.title'),
      body: (_) => AdminListView(
        list: _list,
        host: _host,
        empty: switch (_outcome) {
          'denied' => tr(context, 'admin.audit.nothingWasDenied'),
          'failed' => tr(context, 'admin.audit.nothingFailed'),
          'error' => tr(context, 'admin.audit.theServerHasHadNoErrors'),
          _ => tr(context, 'admin.audit.nothingHasBeenRecordedYet'),
        },
        header: [
          ReportFiltersBar(
            host: _host,
            values: _filters,
            fields: [
              ReportField(
                'actor_kind',
                tr(context, 'admin.audit.actorKind'),
                choices: [
                  ('', tr(context, 'contacts.all')),
                  ('account', tr(context, 'admin.audit.account')),
                  ('system', tr(context, 'settings.server')),
                  ('anonymous', tr(context, 'admin.audit.notSignedIn')),
                ],
              ),
              ReportField(
                'actor_id',
                tr(context, 'admin.audit.accountNumber'),
                number: true,
              ),
              ReportField(
                'actor',
                tr(context, 'admin.audit.actorNameContains'),
              ),
              ReportField('action', tr(context, 'admin.audit.action')),
              ReportField(
                'outcome',
                tr(context, 'admin.audit.outcome'),
                choices: [
                  ('', tr(context, 'contacts.all')),
                  ('success', tr(context, 'admin.audit.success')),
                  ('denied', tr(context, 'admin.audit.denied')),
                  ('failed', tr(context, 'admin.audit.failed')),
                  ('error', tr(context, 'admin.audit.serverError')),
                ],
              ),
              reportSince,
              reportUntil,
              ReportField(
                'before_seq',
                tr(context, 'admin.audit.beforeEntry'),
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
              label: _checking
                  ? tr(context, 'admin.audit.checkingTheChain')
                  : tr(context, 'admin.audit.verifyChain'),
              onPressed: _checking ? null : () => unawaited(_verify()),
            ),
          ),
          RmOutlineButton(
            label: tr(context, 'admin.audit.verifySavedAnchor'),
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
                options: [
                  (null, tr(context, 'contacts.all')),
                  ('success', tr(context, 'admin.audit.success')),
                  ('denied', tr(context, 'admin.audit.denied')),
                  ('failed', tr(context, 'admin.audit.failed')),
                  ('error', tr(context, 'admin.audit.errors')),
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
          label: _actor(context, entry),
          subtitle:
              '${entry.action} · ${_outcomeLabel(context, entry.outcome)} · '
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
        ? tr(context, 'ui.1Entry')
        : trArgs(context, 'ui.valueEntries', {
            'value': (countLabel(check.checked)).toString(),
          });
    final text = [
      if (check.ok && check.checked == 0)
        tr(context, 'admin.audit.theChainHoldsThereIsNothingIn')
      else if (check.ok && check.checked == 1)
        tr(context, 'admin.audit.theChainHoldsItsOneEntryMatches')
      else if (check.ok)
        trArgs(context, 'admin.audit.theChainHoldsAllEntriesFromFirstSeq', {
          'entries': (entries).toString(),
          'firstSeq': (check.firstSeq).toString(),
          'lastSeq': (check.lastSeq).toString(),
        })
      else if (broken == null)
        trArgs(context, 'admin.audit.theChainCouldNotBeVerifiedValue', {
          'value': (check.reason.isEmpty ? '.' : ': ${check.reason}.')
              .toString(),
        })
      else
        [
          trArgs(context, 'admin.audit.theChainBreaksAtEntryBrokenValue', {
            'broken': (broken).toString(),
            'value': (check.reason.isEmpty ? '' : ': ${check.reason}')
                .toString(),
          }),
          if (check.checked == 1)
            tr(context, 'admin.audit.theEntryBeforeItHolds')
          else if (check.checked > 1)
            trArgs(context, 'admin.audit.theEntriesBeforeItHold', {
              'entries': (entries).toString(),
            }),
        ].join(' '),
      if (check.note.isNotEmpty) check.note,
      if (check.anchor case final anchor?)
        trArgs(context, 'admin.audit.checkedAgainstSavedAnchorValue', {
          'value': (anchor.value).toString(),
        }),
      if (check.lastHash.isNotEmpty)
        trArgs(context, 'admin.audit.lastVerifiedEntryLastSeqLastHash', {
          'lastSeq': (check.lastSeq).toString(),
          'lastHash': (check.lastHash).toString(),
        }),
      if (check.anchor == null)
        tr(context, 'admin.audit.anIndependentlySavedAnchorCanAlsoDetect'),
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
      title: trArgs(context, 'admin.audit.entrySeq', {
        'seq': (entry.seq).toString(),
      }),
      body: (_) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(
                label: tr(context, 'admin.audit.when'),
                value: longDate(entry.occurredAt),
              ),
              RmRow(
                label: tr(context, 'admin.audit.who'),
                subtitle: _actor(context, entry),
              ),
              RmRow(
                label: tr(context, 'admin.audit.as'),
                value: entry.actorKind,
              ),
              if (entry.actorId case final id?)
                RmRow(
                  label: tr(context, 'admin.audit.accountNumber'),
                  value: '$id',
                ),
              if (entry.credentialId case final id?)
                RmRow(
                  label: tr(context, 'admin.audit.credentialNumber'),
                  value: '$id',
                ),
              if (entry.sessionId.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.audit.session'),
                  subtitle: entry.sessionId,
                ),
              if (entry.requestId.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.audit.requestID'),
                  subtitle: entry.requestId,
                ),
              RmRow(
                label: tr(context, 'admin.audit.action'),
                value: entry.action,
              ),
              RmRow(
                label: tr(context, 'admin.audit.outcome'),
                value: [
                  _outcomeLabel(context, entry.outcome),
                  if (entry.status > 0) '${entry.status}',
                ].join(' · '),
              ),
              if (entry.errorCode.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.audit.error'),
                  value: entry.errorCode,
                ),
              if (request.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.audit.request'),
                  subtitle: request,
                ),
              for (final MapEntry(:key, :value) in entry.target.entries)
                RmRow(label: key, value: value),
              if (entry.ip.isNotEmpty)
                RmRow(label: tr(context, 'compose.from'), value: entry.ip),
              if (entry.userAgent.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.audit.app'),
                  subtitle: entry.userAgent,
                ),
            ],
          ),
          const SizedBox(height: 22),
          SectionLabel(tr(context, 'admin.audit.itsHashAndTheOneBefore')),
          const SizedBox(height: 9),
          SelectableText(
            trArgs(
              context,
              'admin.audit.savedAnchorSeqHashPreviousHashPrevHash',
              {
                'seq': (entry.seq).toString(),
                'hash': (entry.hash).toString(),
                'prevHash': (entry.prevHash).toString(),
              },
            ),
            style: rmText(12.5, color: c.ink2, height: 1.5),
          ),
        ],
      ),
    );
  }
}
