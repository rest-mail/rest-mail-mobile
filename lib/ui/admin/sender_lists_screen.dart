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
  late final _list = AdminList<SenderRule>((_) async {
    final rules = await widget.account.client.senderRules(
      widget.domain.id,
      _shown,
    );
    return OffsetPage(rules, offset: 0, total: rules.length);
  });

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
    if (added && mounted) unawaited(_list.reload());
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
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final block = _shown == SenderList.block;
    return AdminPage(
      account: widget.account,
      section: AdminSection.senderLists,
      title: 'Sender lists',
      body: (access) => AdminListView(
        list: _list,
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
                setState(() => _shown = list);
                unawaited(_list.reload());
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
          if (access.canWrite(AdminSection.senderLists))
            AdminAddButton(
              label: block ? 'Turn a sender away' : 'Let a sender in',
              onTap: () => unawaited(_add()),
            ),
        ],
        row: (rule) => RmRow(
          label: rule.pattern,
          subtitle: switch ([
            if (rule.reason.isNotEmpty) rule.reason,
            if (rule.createdAt case final at?) 'Added ${timeLabel(at)}',
          ]) {
            [] => null,
            final lines => lines.join('\n'),
          },
          trailing: access.canDelete(AdminSection.senderLists)
              ? RmIconButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Remove ${rule.pattern}',
                  color: c.ink3,
                  onPressed: () => unawaited(_remove(rule)),
                )
              : null,
        ),
      ),
    );
  }
}
