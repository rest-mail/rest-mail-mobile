import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _statusLabel(BuildContext context, String status) => switch (status) {
  'ok' => tr(context, 'admin.dnscheck.right'),
  'missing' => tr(context, 'admin.dnscheck.missing'),
  _ => tr(context, 'admin.dnscheck.couldnTCheck'),
};

/// The selector the server's check looks under for a DKIM key, whatever the
/// domain signs with.
const _checkedSelector = 'default';

/// Has the server look up a domain's DNS records, and shows which are right
/// and which are missing: MX, SPF, DMARC, DKIM, MTA-STS and TLS-RPT. Only
/// to look at; the records are changed where the domain's DNS is kept.
class DnsCheckScreen extends StatefulWidget {
  const DnsCheckScreen({
    super.key,
    required this.account,
    required this.domain,
  });

  final RestAccount account;
  final AdminDomain domain;

  @override
  State<DnsCheckScreen> createState() => _DnsCheckScreenState();
}

class _DnsCheckScreenState extends State<DnsCheckScreen> {
  DnsCheck? _check;
  ApiException? _error;
  var _checking = false;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(
      widget.account.capabilities,
      scope: CapabilityScope.domain(widget.domain.name),
    ).canRead(AdminSection.dnsCheck)) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    setState(() => _checking = true);
    try {
      final check = await widget.account.client.dnsCheck(widget.domain.id);
      if (mounted) {
        setState(() {
          _check = check;
          _error = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final check = _check, error = _error;
    final selector = widget.domain.dkimSelector;
    return AdminPage(
      scope: CapabilityScope.domain(widget.domain.name),
      account: widget.account,
      section: AdminSection.dnsCheck,
      title: tr(context, 'admin.section.dnsCheck.title'),
      body: (_) {
        if (error != null) {
          return AdminMessage(
            describeAdminError(
              context,
              error,
              host: widget.account.server.host,
            ),
            onRetry: () => unawaited(_load()),
          );
        }
        if (check == null) {
          return const Center(
            child: SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final right = check.records.where((r) => r.ok).length;
        final missesDkim = check.records.any((r) => r.type == 'DKIM' && !r.ok);
        return RefreshIndicator(
          color: c.accent,
          onRefresh: _load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
            children: [
              Text(
                right == check.records.length
                    ? trArgs(
                        context,
                        'admin.dnscheck.allLengthRecordsNameNeedsAreRight',
                        {
                          'length': (check.records.length).toString(),
                          'name': (widget.domain.name).toString(),
                        },
                      )
                    : trArgs(
                        context,
                        'admin.dnscheck.rightOfLengthRecordsNameNeedsAre',
                        {
                          'right': (right).toString(),
                          'length': (check.records.length).toString(),
                          'name': (widget.domain.name).toString(),
                        },
                      ),
                style: rmText(15, color: c.ink2, height: 1.45),
              ),
              const SizedBox(height: 14),
              RmGroup(
                children: [
                  for (final record in check.records)
                    RmRow(
                      label: record.type,
                      subtitle: [
                        record.name,
                        if (record.ok && record.value.isNotEmpty) record.value,
                        if (!record.ok && record.message.isNotEmpty)
                          record.message,
                      ].join('\n'),
                      // Beside the row rather than as its value, so a long
                      // record keeps the width it needs.
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 4),
                        child: Text(
                          _statusLabel(context, record.status),
                          style: rmText(
                            13.5,
                            color: record.ok ? c.ink3 : c.danger,
                            weight: record.ok
                                ? FontWeight.w400
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (missesDkim &&
                  selector.isNotEmpty &&
                  selector != _checkedSelector) ...[
                const SizedBox(height: 12),
                Text(
                  trArgs(context, 'admin.dnscheck.theCheckLooksForTheDKIMKey', {
                    'checkedSelector': (_checkedSelector).toString(),
                    'name': (widget.domain.name).toString(),
                    'selector': (selector).toString(),
                  }),
                  style: rmText(13, color: c.ink3, height: 1.4),
                ),
              ],
              const SizedBox(height: 22),
              RmOutlineButton(
                label: _checking
                    ? tr(context, 'server.checking')
                    : tr(context, 'admin.dnscheck.checkAgain'),
                onPressed: _checking ? null : () => unawaited(_load()),
              ),
            ],
          ),
        );
      },
    );
  }
}
