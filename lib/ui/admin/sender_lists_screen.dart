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

/// An address, or `@` and a domain for everyone there: what the server's
/// filter matches a sender against. Anything else would never match.
final _pattern = RegExp(r'^[^@\s]*@[^@\s]+\.[^@\s]+$');

/// A domain's two lists of senders: those turned away, and those let past
/// the spam checks. Turned away wins when a sender is on both.
class SenderListsScreen extends StatefulWidget {
  const SenderListsScreen({
    super.key,
    required this.account,
    required this.domain,
  });

  final RestAccount account;
  final AdminDomain domain;

  @override
  State<SenderListsScreen> createState() => _SenderListsScreenState();
}

class _SenderListsScreenState extends State<SenderListsScreen> {
  var _shown = SenderList.block;
  late var _list = _newList(_shown);

  AdminList<SenderRule> _newList(SenderList list) => AdminList((_) async {
    final rules = await widget.account.client.senderRules(
      widget.domain.id,
      list,
    );
    return OffsetPage(rules, offset: 0, total: rules.length);
  });

  // Each selection starts with no rows. An older request belongs to a
  // disposed list and cannot replace the current selection's results.
  Future<void> _reload(SenderList list) async {
    final previous = _list;
    final next = _newList(list);
    setState(() {
      _shown = list;
      _list = next;
    });
    previous.dispose();
    await next.reload();
  }

  String get _host => widget.account.server.host;
  String get _name => widget.domain.name;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(
      widget.account.capabilities,
      scope: CapabilityScope.domain(widget.domain.name),
    ).canRead(AdminSection.senderLists)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final list = _shown;
    final block = list == SenderList.block;
    final added = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: block
            ? tr(context, 'admin.senderlists.turnASenderAway')
            : tr(context, 'admin.senderlists.letASenderIn'),
        intro: block
            ? trArgs(context, 'admin.senderlists.mailFromThemToNameIsTurned', {
                'name': (_name).toString(),
              })
            : trArgs(context, 'admin.senderlists.mailFromThemToNameSkipsThe', {
                'name': (_name).toString(),
              }),
        fields: [
          AdminField(
            tr(context, 'admin.queue.sender'),
            hint: 'someone@example.com, or @example.com',
            email: true,
          ),
          AdminField(
            tr(context, 'quarantine.why'),
            hint: tr(context, 'contacts.nameHint'),
            optional: true,
          ),
        ],
        action: block
            ? tr(context, 'admin.senderlists.turnAway')
            : tr(context, 'admin.senderlists.letIn'),
        host: _host,
        submit: (values) async {
          final pattern = values[0].toLowerCase();
          if (!_pattern.hasMatch(pattern)) {
            throw ApiException(
              422,
              'validation_failed',
              tr(context, 'admin.senderlists.notASender'),
              fields: {
                'sender': tr(
                  context,
                  'admin.senderlists.mustBeAnAddressOrAndA',
                ),
              },
            );
          }
          await widget.account.client.addSenderRule(
            widget.domain.id,
            list,
            pattern: pattern,
            reason: values[1],
          );
        },
      ),
    );
    if (added && mounted) unawaited(_reload(_shown));
  }

  Future<void> _remove(SenderRule rule) async {
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.removeSenderRule(
        widget.domain.id,
        rule.list,
        rule.id,
      ),
      confirm: (
        title: trArgs(context, 'admin.senderlists.takePatternOffTheList', {
          'pattern': (rule.pattern).toString(),
        }),
        message: rule.list == SenderList.block
            ? tr(context, 'admin.senderlists.mailFromThemIsLetInAgain')
            : tr(context, 'admin.senderlists.mailFromThemIsCheckedForSpam'),
        action: tr(context, 'common.remove'),
      ),
    );
    if (!ok || !mounted) return;
    showToast(
      context,
      trArgs(context, 'admin.senderlists.removedPattern', {
        'pattern': (rule.pattern).toString(),
      }),
    );
    unawaited(_reload(_shown));
  }

  Future<void> _details(SenderRule rule) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheet) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(context, 'admin.senderlists.senderRule'),
              style: rmText(20, color: sheet.rm.ink),
            ),
            const SizedBox(height: 18),
            SectionLabel(tr(context, 'admin.queue.sender')),
            SelectableText(rule.pattern),
            const SizedBox(height: 14),
            RmGroup(
              children: [
                RmRow(
                  label: tr(context, 'admin.senderlists.ruleID'),
                  value: '${rule.id}',
                ),
                RmRow(label: tr(context, 'admin.aliases.domain'), value: _name),
                RmRow(
                  label: tr(context, 'admin.filtereditors.domainID'),
                  value: '${rule.domainId}',
                ),
                RmRow(
                  label: tr(context, 'interface.list'),
                  value: rule.list == SenderList.block
                      ? tr(context, 'admin.pipelinelog.turnedAway')
                      : tr(context, 'admin.senderlists.letIn'),
                ),
                RmRow(
                  label: tr(context, 'admin.senderlists.createdBy'),
                  value: rule.createdBy == null
                      ? tr(context, 'admin.senderlists.notRecorded')
                      : trArgs(context, 'admin.senderlists.accountCreatedBy', {
                          'createdBy': (rule.createdBy).toString(),
                        }),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SectionLabel(tr(context, 'admin.granttext.reason')),
            SelectableText(
              rule.reason.isEmpty
                  ? tr(context, 'admin.senderlists.noneGiven')
                  : rule.reason,
            ),
            if (rule.createdAt case final at?) ...[
              const SizedBox(height: 14),
              SectionLabel(tr(context, 'admin.aliases.added')),
              SelectableText(at.toLocal().toIso8601String()),
            ],
            const SizedBox(height: 18),
            RmOutlineButton(
              label: tr(context, 'common.done'),
              onPressed: () => Navigator.pop(sheet),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final block = _shown == SenderList.block;
    return AdminPage(
      scope: CapabilityScope.domain(widget.domain.name),
      account: widget.account,
      section: AdminSection.senderLists,
      title: tr(context, 'admin.section.senderLists.title'),
      body: (access) => ListenableBuilder(
        listenable: _list,
        builder: (context, _) => AdminListView(
          list: _list,
          onRefresh: () => _reload(_shown),
          host: _host,
          empty: block
              ? tr(context, 'admin.senderlists.noSenderIsTurnedAway')
              : tr(context, 'admin.senderlists.noSenderSkipsTheSpamChecks'),
          header: [
            Align(
              alignment: Alignment.centerLeft,
              child: RmSegmented<SenderList>(
                options: [
                  (
                    SenderList.block,
                    tr(context, 'admin.pipelinelog.turnedAway'),
                  ),
                  (SenderList.allow, tr(context, 'admin.senderlists.letIn')),
                ],
                value: _shown,
                onChanged: (list) {
                  if (list != _shown) unawaited(_reload(list));
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                block
                    ? trArgs(
                        context,
                        'admin.senderlists.mailToNameFromTheseSendersIs',
                        {'name': (_name).toString()},
                      )
                    : trArgs(
                        context,
                        'admin.senderlists.mailToNameFromTheseSendersSkips',
                        {'name': (_name).toString()},
                      ),
                style: rmText(13, color: c.ink3, height: 1.4),
              ),
            ),
            if (!_list.loading &&
                _list.error == null &&
                access.canWrite(AdminSection.senderLists))
              AdminAddButton(
                label: block
                    ? tr(context, 'admin.senderlists.turnASenderAway')
                    : tr(context, 'admin.senderlists.letASenderIn'),
                onTap: () => unawaited(_add()),
              ),
          ],
          row: (rule) => RmRow(
            label: rule.pattern,
            onTap: _list.loading ? null : () => unawaited(_details(rule)),
            subtitle: switch ([
              if (rule.reason.isNotEmpty) rule.reason,
              if (rule.createdAt case final at?)
                trArgs(context, 'admin.senderlists.addedValue', {
                  'value': (timeLabel(at)).toString(),
                }),
            ]) {
              [] => null,
              final lines => lines.join('\n'),
            },
            trailing:
                !_list.loading &&
                    _list.error == null &&
                    access.canDelete(AdminSection.senderLists)
                ? RmIconButton(
                    icon: Icons.close_rounded,
                    tooltip: trArgs(
                      context,
                      'admin.senderlists.removePattern',
                      {'pattern': (rule.pattern).toString()},
                    ),
                    color: c.ink3,
                    onPressed: () => unawaited(_remove(rule)),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
