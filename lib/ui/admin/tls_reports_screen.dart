import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'report_filters.dart';

String _policyLabel(BuildContext context, String type) => switch (type) {
  'sts' => 'MTA-STS',
  'tlsa' => 'DANE',
  'no-policy' => tr(context, 'interface.none'),
  _ => type,
};

String _sessions(BuildContext context, int n) => n == 1
    ? tr(context, 'ui.1Session')
    : trArgs(context, 'ui.valueSessions', {
        'value': (countLabel(n)).toString(),
      });

String _period(BuildContext context, TlsReport report) {
  final day = DateFormat.MMMd();
  final start = day.format(report.startDate), end = day.format(report.endDate);
  return start == end
      ? start
      : trArgs(context, 'ui.startToEnd', {
          'start': (start).toString(),
          'end': (end).toString(),
        });
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
  Map<String, String> _filters = {};
  late final _list = AdminList<TlsReport>(
    (offset) => widget.account.client.tlsReports(
      offset: offset,
      domainId: reportInt(_filters, 'domain_id'),
      policyType: _filters['policy_type'],
      reportingOrg: _filters['reporting_org'],
      limit: reportInt(_filters, 'limit') ?? 50,
    ),
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
    title: tr(context, 'admin.section.tlsReports.title'),
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: tr(context, 'admin.tlsreports.noReportsMatch'),
      header: [
        ReportFiltersBar(
          host: widget.account.server.host,
          values: _filters,
          intro: tr(
            context,
            'admin.tlsreports.leaveFieldsEmptyToIncludeEveryReport',
          ),
          fields: [
            ReportField(
              'domain_id',
              tr(context, 'admin.keys.domainNumber'),
              number: true,
            ),
            ReportField(
              'policy_type',
              tr(context, 'admin.tlsreports.policy'),
              choices: [
                ('', tr(context, 'contacts.all')),
                ('sts', 'MTA-STS'),
                ('tlsa', 'DANE'),
                ('no-policy', tr(context, 'admin.tlsreports.noPolicy')),
              ],
            ),
            ReportField(
              'reporting_org',
              tr(context, 'admin.tlsreports.reportingOrganisationContains'),
            ),
            reportPageSize,
          ],
          onChanged: (values) {
            setState(() => _filters = values);
            unawaited(_list.reload());
          },
        ),
      ],
      row: (report) => RmRow(
        label: report.reportingOrg,
        subtitle: [
          '${report.policyDomain} · ${_period(context, report)}',
          report.failed == 0
              ? trArgs(context, 'admin.tlsreports.valueNoneFailed', {
                  'value': (_sessions(context, report.successful)).toString(),
                })
              : trArgs(context, 'tlsReports.sessionSummary', {
                  'worked': _sessions(context, report.successful),
                  'failed': countLabel(report.failed),
                }),
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
              RmRow(
                label: tr(context, 'admin.aliases.domain'),
                value: report.policyDomain,
              ),
              RmRow(
                label: tr(context, 'admin.tlsreports.policy'),
                value: _policyLabel(context, report.policyType),
              ),
              RmRow(
                label: tr(context, 'admin.tlsreports.covers'),
                value: _period(context, report),
              ),
              RmRow(
                label: tr(context, 'admin.tlsreports.worked'),
                value: countLabel(report.successful),
              ),
              RmRow(
                label: tr(context, 'admin.audit.failed'),
                value: countLabel(report.failed),
              ),
              RmRow(
                label: tr(context, 'admin.tlsreports.received'),
                value: longDate(report.receivedAt),
              ),
            ],
          ),
          if (details != null) ...[
            const SizedBox(height: 22),
            SectionLabel(tr(context, 'admin.tlsreports.whatFailed')),
            const SizedBox(height: 9),
            SelectableText(
              prettyJson(details),
              style: rmText(13, color: c.ink2, height: 1.45),
            ),
          ],
          if (report.rawReport.isNotEmpty) ...[
            const SizedBox(height: 22),
            SectionLabel(tr(context, 'admin.tlsreports.originalReport')),
            const SizedBox(height: 9),
            SelectableText(
              report.rawReport,
              style: rmText(13, color: c.ink2, height: 1.45),
            ),
          ],
          const SizedBox(height: 22),
          RmGroup(
            children: [
              RmRow(
                label: tr(context, 'admin.tlsreports.report'),
                value: '${report.id}',
              ),
              RmRow(
                label: tr(context, 'admin.keys.domainNumber'),
                value: '${report.domainId}',
              ),
              if (report.domain case final domain?)
                RmRow(
                  label: tr(context, 'admin.tlsreports.domainName'),
                  value: domain.name,
                ),
              if (report.createdAt case final at?)
                RmRow(
                  label: tr(context, 'admin.aliases.added'),
                  value: longDate(at),
                ),
              RmRow(
                label: tr(context, 'admin.tlsreports.starts'),
                value: longDate(report.startDate),
              ),
              RmRow(
                label: tr(context, 'admin.tlsreports.ends'),
                value: longDate(report.endDate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
