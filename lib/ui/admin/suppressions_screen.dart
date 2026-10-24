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

String _categoryLabel(BuildContext context, String category) =>
    switch (category) {
      'bad_mailbox' => tr(context, 'admin.suppressions.noSuchMailbox'),
      'bad_domain' => tr(context, 'admin.suppressions.noSuchDomain'),
      '' => '',
      _ => category.replaceAll('_', ' '),
    };

String _reasonLabel(BuildContext context, String reason) => switch (reason) {
  'hard_bounce' => tr(context, 'admin.suppressions.bouncedForGood'),
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
        title: trArgs(context, 'admin.suppressions.sendToAddressAgain', {
          'address': (suppression.address).toString(),
        }),
        message: trArgs(
          context,
          'admin.suppressions.mailFromNameToThemIsTried',
          {'name': (_name).toString()},
        ),
        action: tr(context, 'admin.suppressions.clear'),
      ),
    );
    if (!ok || !mounted) return;
    showToast(
      context,
      trArgs(context, 'admin.suppressions.clearedAddress', {
        'address': (suppression.address).toString(),
      }),
    );
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return AdminPage(
      scope: CapabilityScope.domain(widget.domain.name),
      account: widget.account,
      section: AdminSection.suppressions,
      title: tr(context, 'admin.suppressions.suppressedRecipients'),
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: trArgs(
          context,
          'admin.suppressions.mailFromNameGoesToEveryRecipient',
          {'name': (_name).toString()},
        ),
        header: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              trArgs(context, 'admin.suppressions.mailFromNameIsNotSentTo', {
                'name': (_name).toString(),
              }),
              style: rmText(13, color: c.ink3, height: 1.4),
            ),
          ),
        ],
        row: (suppression) => RmRow(
          label: suppression.address,
          subtitle: switch ([
            if (_reasonLabel(context, suppression.reason) case final reason
                when reason.isNotEmpty)
              reason,
            if (_categoryLabel(context, suppression.failureCategory)
                case final category when category.isNotEmpty)
              category,
            if (suppression.lastError.isNotEmpty) suppression.lastError,
            if (suppression.messageId case final id?)
              trArgs(context, 'admin.pipelinelog.messageId', {
                'id': (id).toString(),
              }),
            if (suppression.createdAt case final at?)
              trArgs(context, 'admin.suppressions.firstBouncedValue', {
                'value': (timeLabel(at)).toString(),
              }),
            if (suppression.updatedAt case final at?
                when at != suppression.createdAt)
              trArgs(context, 'admin.suppressions.lastBouncedValue', {
                'value': (timeLabel(at)).toString(),
              }),
            if (suppression.expiresAt case final at?)
              trArgs(context, 'admin.suppressions.lapsesValue', {
                'value': (timeLabel(at)).toString(),
              }),
          ]) {
            [] => null,
            final lines => lines.join('\n'),
          },
          trailing: access.canDelete(AdminSection.suppressions)
              ? RmIconButton(
                  icon: Icons.close_rounded,
                  tooltip: trArgs(context, 'admin.suppressions.clearAddress', {
                    'address': (suppression.address).toString(),
                  }),
                  color: c.ink3,
                  onPressed: () => unawaited(_clear(suppression)),
                )
              : null,
        ),
      ),
    );
  }
}
