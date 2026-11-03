import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'report_filters.dart';

String _disposition(BuildContext context, String value) => switch (value) {
  'none' => tr(context, 'admin.dmarcreports.dispositionNone'),
  'pass' => tr(context, 'admin.dmarcreports.dispositionPass'),
  'quarantine' => tr(context, 'admin.dmarcreports.dispositionQuarantine'),
  'reject' => tr(context, 'admin.dmarcreports.dispositionReject'),
  _ => value,
};

String _result(BuildContext context, String value) => switch (value) {
  'pass' => tr(context, 'admin.dmarcreports.resultPass'),
  'fail' => tr(context, 'admin.dmarcreports.resultFail'),
  _ => value,
};

/// The report's days, as the reporter counted them: in UTC.
String _period(BuildContext context, DmarcReport report) {
  final day = DateFormat.MMMd();
  final start = day.format(report.startDate), end = day.format(report.endDate);
  return start == end
      ? start
      : trArgs(context, 'ui.startToEnd', {'start': start, 'end': end});
}

String _summary(BuildContext context, DmarcReport report) => trArgs(
  context,
  'admin.dmarcreports.summary',
  {'passed': countLabel(report.passed), 'failed': countLabel(report.failed)},
);

/// What other servers report about mail claiming to be from this server's
/// domains (RFC 9990), newest first. A domain-scoped administrator gets the
/// reports of their own domains.
class DmarcReportsScreen extends StatefulWidget {
  const DmarcReportsScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<DmarcReportsScreen> createState() => _DmarcReportsScreenState();
}

class _DmarcReportsScreenState extends State<DmarcReportsScreen> {
  Map<String, String> _filters = {};
  late final _list = AdminList<DmarcReport>(
    (offset) => widget.account.client.dmarcReports(
      offset: offset,
      domainId: reportInt(_filters, 'domain_id'),
      reporter: _filters['reporter'],
      limit: reportInt(_filters, 'limit') ?? 50,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.dmarcReports)) {
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
    section: AdminSection.dmarcReports,
    title: tr(context, 'admin.section.dmarcReports.title'),
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
              'reporter',
              tr(context, 'admin.dmarcreports.reporterContains'),
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
          '${report.policy.domain} · ${_period(context, report)}',
          _summary(context, report),
        ].join('\n'),
        onTap: () => pushScreen(
          context,
          DmarcReportScreen(
            account: widget.account,
            id: report.id,
            title: report.reportingOrg,
          ),
        ),
      ),
    ),
  );
}

/// One report, read fresh from the server: what it covers, the policy the
/// reporter found, and each source's messages and results.
class DmarcReportScreen extends StatefulWidget {
  const DmarcReportScreen({
    super.key,
    required this.account,
    required this.id,
    required this.title,
  });

  final RestAccount account;
  final int id;
  final String title;

  @override
  State<DmarcReportScreen> createState() => _DmarcReportScreenState();
}

class _DmarcReportScreenState extends State<DmarcReportScreen> {
  DmarcReport? _report;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.dmarcReports)) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    try {
      final report = await widget.account.client.dmarcReport(widget.id);
      if (mounted) {
        setState(() {
          _report = report;
          _error = null;
        });
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _report = null;
          _error = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.dmarcReports,
    title: _report?.reportingOrg ?? widget.title,
    body: (_) => AdminDetailBody(
      ready: _report != null,
      error: _error,
      host: widget.account.server.host,
      onRefresh: _load,
      child: _report == null ? const SizedBox.shrink() : _details(_report!),
    ),
  );

  Widget _details(DmarcReport report) {
    final policy = report.policy;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
      children: [
        RmGroup(
          children: [
            RmRow(
              label: tr(context, 'admin.dmarcreports.reportingOrganisation'),
              value: report.reportingOrg,
            ),
            RmRow(
              label: tr(context, 'admin.aliases.domain'),
              value: policy.domain,
            ),
            RmRow(
              label: tr(context, 'admin.tlsreports.covers'),
              value: _period(context, report),
            ),
            RmRow(
              label: tr(context, 'mailboxes.messages'),
              value: _summary(context, report),
            ),
            RmRow(
              label: tr(context, 'admin.tlsreports.received'),
              value: longDate(report.receivedAt.toLocal()),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SectionLabel(tr(context, 'admin.dmarcreports.records')),
        const SizedBox(height: 9),
        for (final record in report.records) ...[
          _record(record),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 10),
        SectionLabel(tr(context, 'admin.dmarcreports.policyPublished')),
        const SizedBox(height: 9),
        RmGroup(
          children: [
            RmRow(
              label: tr(context, 'admin.domains.dmarcPolicy'),
              value: policy.policy,
            ),
            if (policy.subdomainPolicy case final value?)
              RmRow(
                label: tr(context, 'admin.dmarcreports.subdomainPolicy'),
                value: value,
              ),
            if (policy.nonexistentDomainPolicy case final value?)
              RmRow(
                label: tr(
                  context,
                  'admin.dmarcreports.nonexistentDomainPolicy',
                ),
                value: value,
              ),
            if (policy.dkimAlignment case final value?)
              RmRow(
                label: tr(context, 'admin.dmarcreports.dkimAlignment'),
                value: value,
              ),
            if (policy.spfAlignment case final value?)
              RmRow(
                label: tr(context, 'admin.dmarcreports.spfAlignment'),
                value: value,
              ),
            if (policy.percentage case final value?)
              RmRow(
                label: tr(context, 'admin.dmarcreports.percentage'),
                value: '$value',
              ),
            if (policy.failureOptions case final value?)
              RmRow(
                label: tr(context, 'admin.dmarcreports.failureOptions'),
                value: value,
              ),
            if (policy.testing case final value?)
              RmRow(
                label: tr(context, 'admin.dmarcreports.testing'),
                value: value,
              ),
            if (policy.discoveryMethod case final value?)
              RmRow(
                label: tr(context, 'admin.dmarcreports.discoveryMethod'),
                value: value,
              ),
          ],
        ),
        const SizedBox(height: 22),
        RmGroup(
          children: [
            RmRow(
              label: tr(context, 'admin.tlsreports.report'),
              value: '${report.id}',
            ),
            RmRow(
              label: tr(context, 'admin.dmarcreports.reportId'),
              value: report.reportId,
            ),
            RmRow(
              label: tr(context, 'admin.dmarcreports.reporter'),
              value: report.reporter,
            ),
            RmRow(
              label: tr(context, 'admin.keys.domainNumber'),
              value: '${report.domainId}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _record(DmarcRecord record) => RmGroup(
    children: [
      RmRow(
        label: tr(context, 'admin.dmarcreports.source'),
        value: record.sourceIp,
      ),
      RmRow(
        label: tr(context, 'mailboxes.messages'),
        value: countLabel(record.count),
      ),
      RmRow(
        label: tr(context, 'admin.dmarcreports.disposition'),
        value: _disposition(context, record.disposition),
      ),
      RmRow(label: 'DKIM', value: _result(context, record.dkim)),
      RmRow(label: 'SPF', value: _result(context, record.spf)),
      RmRow(
        label: tr(context, 'admin.dmarcreports.headerFrom'),
        value: record.headerFrom,
      ),
      if (record.envelopeFrom case final value?)
        RmRow(
          label: tr(context, 'admin.dmarcreports.envelopeFrom'),
          value: value,
        ),
      if (record.envelopeTo case final value?)
        RmRow(
          label: tr(context, 'admin.dmarcreports.envelopeTo'),
          value: value,
        ),
      for (final reason in record.reasons)
        RmRow(
          label: tr(context, 'admin.dmarcreports.reason'),
          subtitle: reason.comment,
          value: reason.type,
        ),
      for (final check in record.dkimResults)
        RmRow(
          label: 'DKIM',
          subtitle: [
            check.domain,
            ?check.selector,
            ?check.humanResult,
          ].join(' · '),
          value: _result(context, check.result),
        ),
      for (final check in record.spfResults)
        RmRow(
          label: 'SPF',
          subtitle: [
            check.domain,
            ?check.scope,
            ?check.humanResult,
          ].join(' · '),
          value: _result(context, check.result),
        ),
    ],
  );
}
