import 'dart:async';

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
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.senderLists)) {
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
        title: block ? 'Turn a sender away' : 'Let a sender in',
        intro: block
            ? 'Mail from them to $_name is turned away.'
            : 'Mail from them to $_name skips the spam checks, when SPF or '
                  'DKIM shows it really is theirs.',
        fields: const [
          AdminField(
            'Sender',
            hint: 'someone@example.com, or @example.com',
            email: true,
          ),
          AdminField('Why', hint: 'Optional', optional: true),
        ],
        action: block ? 'Turn away' : 'Let in',
        host: _host,
        submit: (values) async {
          final pattern = values[0].toLowerCase();
          if (!_pattern.hasMatch(pattern)) {
            throw const ApiException(
              422,
              'validation_failed',
              'Not a sender',
              fields: {'sender': 'must be an address, or @ and a domain'},
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
        title: 'Take ${rule.pattern} off the list?',
        message: rule.list == SenderList.block
            ? 'Mail from them is let in again, and checked like any other.'
            : 'Mail from them is checked for spam like any other.',
        action: 'Remove',
      ),
    );
    if (!ok || !mounted) return;
    showToast(context, 'Removed ${rule.pattern}');
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
            Text('Sender rule', style: rmText(20, color: sheet.rm.ink)),
            const SizedBox(height: 18),
            const SectionLabel('Sender'),
            SelectableText(rule.pattern),
            const SizedBox(height: 14),
            RmGroup(
              children: [
                RmRow(label: 'Rule ID', value: '${rule.id}'),
                RmRow(label: 'Domain', value: _name),
                RmRow(label: 'Domain ID', value: '${rule.domainId}'),
                RmRow(
                  label: 'List',
                  value: rule.list == SenderList.block
                      ? 'Turned away'
                      : 'Let in',
                ),
                RmRow(
                  label: 'Created by',
                  value: rule.createdBy == null
                      ? 'Not recorded'
                      : 'Account ${rule.createdBy}',
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SectionLabel('Reason'),
            SelectableText(rule.reason.isEmpty ? 'None given' : rule.reason),
            if (rule.createdAt case final at?) ...[
              const SizedBox(height: 14),
              const SectionLabel('Added'),
              SelectableText(at.toLocal().toIso8601String()),
            ],
            const SizedBox(height: 18),
            RmOutlineButton(
              label: 'Done',
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
      account: widget.account,
      section: AdminSection.senderLists,
      title: 'Sender lists',
      body: (access) => ListenableBuilder(
        listenable: _list,
        builder: (context, _) => AdminListView(
          list: _list,
          onRefresh: () => _reload(_shown),
          host: _host,
          empty: block
              ? 'No sender is turned away.'
              : 'No sender skips the spam checks.',
          header: [
            Align(
              alignment: Alignment.centerLeft,
              child: RmSegmented<SenderList>(
                options: const [
                  (SenderList.block, 'Turned away'),
                  (SenderList.allow, 'Let in'),
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
                    ? 'Mail to $_name from these senders is turned away, even '
                          'if they are also let in.'
                    : 'Mail to $_name from these senders skips the spam '
                          'checks, when SPF or DKIM shows it really is theirs.',
                style: rmText(13, color: c.ink3, height: 1.4),
              ),
            ),
            if (!_list.loading &&
                _list.error == null &&
                access.canWrite(AdminSection.senderLists))
              AdminAddButton(
                label: block ? 'Turn a sender away' : 'Let a sender in',
                onTap: () => unawaited(_add()),
              ),
          ],
          row: (rule) => RmRow(
            label: rule.pattern,
            onTap: _list.loading ? null : () => unawaited(_details(rule)),
            subtitle: switch ([
              if (rule.reason.isNotEmpty) rule.reason,
              if (rule.createdAt case final at?) 'Added ${timeLabel(at)}',
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
                    tooltip: 'Remove ${rule.pattern}',
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
