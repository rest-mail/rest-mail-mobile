import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _policyLabel(String type) => switch (type) {
  'sts' => 'MTA-STS',
  'tlsa' => 'DANE',
  'no-policy' => 'None',
  _ => type,
};

String _sessions(int n) => n == 1 ? '1 session' : '${countLabel(n)} sessions';

String _period(TlsReport report) {
  final day = DateFormat.MMMd();
  final start = day.format(report.startDate), end = day.format(report.endDate);
  return start == end ? start : '$start to $end';
}

/// What other servers report about delivering to this one over TLS
/// (RFC 8460), newest first: how many sessions worked, and why any failed.
class TlsReportsScreen extends StatefulWidget {
  const TlsReportsScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<TlsReportsScreen> createState() => _TlsReportsScreenState();
}

class _TlsReportsScreenState extends State<TlsReportsScreen> {
  late final _list = AdminList<TlsReport>(
    (offset) => widget.account.client.tlsReports(offset: offset),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.tlsReports)) {
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
    section: AdminSection.tlsReports,
    title: 'TLS reports',
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: 'No server has sent a report yet.',
      row: (report) => RmRow(
        label: report.reportingOrg,
        subtitle: [
          '${report.policyDomain} · ${_period(report)}',
          report.failed == 0
              ? '${_sessions(report.successful)}, none failed'
              : '${_sessions(report.successful)} worked, '
                    '${countLabel(report.failed)} failed',
        ].join('\n'),
        onTap: () => pushScreen(
          context,
          TlsReportScreen(account: widget.account, report: report),
        ),
      ),
    ),
  );
}

/// One report, with what went wrong as the reporting server put it.
class TlsReportScreen extends StatelessWidget {
  const TlsReportScreen({
    super.key,
    required this.account,
    required this.report,
  });

  final RestAccount account;
  final TlsReport report;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final details = report.failureDetails;
    return AdminPage(
      account: account,
      section: AdminSection.tlsReports,
      title: report.reportingOrg,
      body: (_) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(label: 'Domain', value: report.policyDomain),
              RmRow(label: 'Policy', value: _policyLabel(report.policyType)),
              RmRow(label: 'Covers', value: _period(report)),
              RmRow(label: 'Worked', value: countLabel(report.successful)),
              RmRow(label: 'Failed', value: countLabel(report.failed)),
              RmRow(label: 'Received', value: longDate(report.receivedAt)),
            ],
          ),
          if (details is List && details.isNotEmpty) ...[
            const SizedBox(height: 22),
            const SectionLabel('What failed'),
            const SizedBox(height: 9),
            SelectableText(
              prettyJson(details),
              style: rmText(13, color: c.ink2, height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}
