import 'package:flutter/material.dart';

import '../../l10n/voice.dart';
import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'aliases_screen.dart';
import 'audit_screen.dart';
import 'bans_screen.dart';
import 'domains_screen.dart';
import 'keys_screen.dart';
import 'logs_screen.dart';
import 'mailboxes_screen.dart';
import 'overview_screen.dart';
import 'permissions_screen.dart';
import 'pipeline_log_screen.dart';
import 'pipelines_screen.dart';
import 'queue_screen.dart';
import 'tls_reports_screen.dart';
import 'trace_screen.dart';

/// The server's administration: a row for each section this session may
/// see. An account whose session holds capabilities reaches it from the
/// drawer and Settings.
class AdministrationScreen extends StatelessWidget {
  const AdministrationScreen({super.key, required this.account});

  final RestAccount account;

  Widget _screenFor(AdminSection section) => switch (section) {
    AdminSection.queue => QueueScreen(account: account),
    AdminSection.domains => DomainsScreen(account: account),
    AdminSection.mailboxes => MailboxesScreen(account: account),
    AdminSection.aliases => AliasesScreen(account: account),
    AdminSection.bans => BansScreen(account: account),
    AdminSection.permissions => PermissionsScreen(account: account),
    AdminSection.overview => OverviewScreen(account: account),
    AdminSection.deliveryLog => DeliveryLogScreen(account: account),
    AdminSection.activity => ActivityScreen(account: account),
    AdminSection.trace => TraceLookupScreen(account: account),
    AdminSection.pipelineLog => PipelineLogScreen(account: account),
    AdminSection.pipelineAnalytics => PipelineAnalyticsScreen(account: account),
    AdminSection.tlsReports => TlsReportsScreen(account: account),
    AdminSection.audit => AuditScreen(account: account),
    AdminSection.dkim => DkimScreen(account: account),
    AdminSection.certificates => CertificatesScreen(account: account),
    AdminSection.pipelines => PipelinesScreen(account: account),
    AdminSection.customFilters => CustomFiltersScreen(account: account),
    // Each about one domain, so opened from it, and never listed here.
    AdminSection.dnsCheck ||
    AdminSection.senderLists ||
    AdminSection.mtaSts => DomainsScreen(account: account),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final sections = adminAccessOf(context, account).sections;
    final host = account.server.host;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'admin.title'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                children: [
                  Text(
                    '${account.address} · $host',
                    style: rmText(13, color: c.ink3),
                  ),
                  const SizedBox(height: 14),
                  if (sections.isEmpty)
                    AdminMessage(
                      trArgs(context, 'admin.empty', {'host': host}),
                    ),
                  for (final group in AdminGroup.values)
                    if (sections.where((s) => s.group == group).toList()
                        case final inGroup when inGroup.isNotEmpty) ...[
                      if (group.title != null) ...[
                        const SizedBox(height: 22),
                        SectionLabel(tr(context, 'admin.group.${group.name}')),
                        const SizedBox(height: 9),
                      ],
                      RmGroup(
                        children: [
                          for (final section in inGroup)
                            RmRow(
                              label: tr(
                                context,
                                'admin.section.${section.name}.title',
                              ),
                              subtitle: tr(
                                context,
                                'admin.section.${section.name}.subtitle',
                              ),
                              onTap: () =>
                                  pushScreen(context, _screenFor(section)),
                            ),
                        ],
                      ),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
