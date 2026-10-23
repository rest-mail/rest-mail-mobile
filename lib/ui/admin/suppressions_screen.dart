import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _categoryLabel(String category) => switch (category) {
  'bad_mailbox' => 'No such mailbox',
  'bad_domain' => 'No such domain',
  '' => '',
  _ => category.replaceAll('_', ' '),
};

String _reasonLabel(String reason) => switch (reason) {
  'hard_bounce' => 'Bounced for good',
  '' => '',
  _ => reason.replaceAll('_', ' '),
};

/// The recipients a domain's mail is no longer sent to, because mail to
/// them bounced for good. Each lapses on its own; clearing one has mail to
/// it tried again now.
class SuppressionsScreen extends StatefulWidget {
  const SuppressionsScreen({
    super.key,
    required this.account,
    required this.domain,
  });

  final RestAccount account;
  final AdminDomain domain;

  @override
  State<SuppressionsScreen> createState() => _SuppressionsScreenState();
}

class _SuppressionsScreenState extends State<SuppressionsScreen> {
  late final _list = AdminList<Suppression>((_) async {
    final all = await widget.account.client.suppressions(widget.domain.id);
    return OffsetPage(all, offset: 0, total: all.length);
  });

  String get _host => widget.account.server.host;
  String get _name => widget.domain.name;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(
      widget.account.capabilities,
      scope: CapabilityScope.domain(widget.domain.name),
    ).canRead(AdminSection.suppressions)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _clear(Suppression suppression) async {
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.clearSuppression(
        widget.domain.id,
        suppression.id,
      ),
      confirm: (
        title: 'Send to ${suppression.address} again?',
        message:
            'Mail from $_name to them is tried again. If it bounces for '
            'good again, they are suppressed again.',
        action: 'Clear',
      ),
    );
    if (!ok || !mounted) return;
    showToast(context, 'Cleared ${suppression.address}');
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return AdminPage(
      scope: CapabilityScope.domain(widget.domain.name),
      account: widget.account,
      section: AdminSection.suppressions,
      title: 'Suppressed recipients',
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: 'Mail from $_name goes to every recipient.',
        header: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              'Mail from $_name is not sent to these addresses, because mail '
              'to them bounced for good. Each one lapses on its own.',
              style: rmText(13, color: c.ink3, height: 1.4),
            ),
          ),
        ],
        row: (suppression) => RmRow(
          label: suppression.address,
          subtitle: switch ([
            if (_reasonLabel(suppression.reason) case final reason
                when reason.isNotEmpty)
              reason,
            if (_categoryLabel(suppression.failureCategory) case final category
                when category.isNotEmpty)
              category,
            if (suppression.lastError.isNotEmpty) suppression.lastError,
            if (suppression.messageId case final id?) 'Message $id',
            if (suppression.createdAt case final at?)
              'First bounced ${timeLabel(at)}',
            if (suppression.updatedAt case final at?
                when at != suppression.createdAt)
              'Last bounced ${timeLabel(at)}',
            if (suppression.expiresAt case final at?) 'Lapses ${timeLabel(at)}',
          ]) {
            [] => null,
            final lines => lines.join('\n'),
          },
          trailing: access.canDelete(AdminSection.suppressions)
              ? RmIconButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Clear ${suppression.address}',
                  color: c.ink3,
                  onPressed: () => unawaited(_clear(suppression)),
                )
              : null,
        ),
      ),
    );
  }
}
