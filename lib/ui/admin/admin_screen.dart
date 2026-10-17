import 'dart:async';

import 'package:flutter/material.dart';

import '../../state/admin_access.dart';
import '../../state/app_scope.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../add_account_screen.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'aliases_screen.dart';
import 'bans_screen.dart';
import 'domains_screen.dart';
import 'mailboxes_screen.dart';
import 'overview_screen.dart';
import 'queue_screen.dart';
import 'users_screen.dart';

/// The server's administration: a row for each section this session may
/// see. An administrator, which has no mailbox, opens on it; a mailbox
/// session that holds capabilities reaches it from the drawer and Settings.
class AdministrationScreen extends StatelessWidget {
  const AdministrationScreen({
    super.key,
    required this.account,
    this.home = false,
  });

  final RestAccount account;

  /// The account's first screen: no way back, and its accounts below.
  final bool home;

  Widget _screenFor(AdminSection section) => switch (section) {
    AdminSection.queue => QueueScreen(account: account),
    AdminSection.domains => DomainsScreen(account: account),
    AdminSection.mailboxes => MailboxesScreen(account: account),
    AdminSection.aliases => AliasesScreen(account: account),
    AdminSection.users => UsersScreen(account: account),
    AdminSection.bans => BansScreen(account: account),
    AdminSection.overview => OverviewScreen(account: account),
  };

  Future<void> _signOut(BuildContext context) async {
    final app = AppScope.read(context);
    final sure = await confirmAction(
      context,
      title: 'Sign out?',
      message: [
        'The session for ${account.address} is removed from this device.',
        if (app.accounts.length > 1) 'Your other accounts stay signed in.',
      ].join(' '),
      action: 'Sign out',
    );
    if (sure) await app.signOut(account);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final sections = adminAccessOf(context, account).sections;
    final host = account.server.host;
    final others = app.accounts.where((a) => a != account);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Administration',
              onBack: home ? null : () => Navigator.pop(context),
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
                      "This account can't administer anything on $host.",
                    )
                  else
                    RmGroup(
                      children: [
                        for (final section in sections)
                          RmRow(
                            label: section.title,
                            subtitle: section.subtitle,
                            onTap: () =>
                                pushScreen(context, _screenFor(section)),
                          ),
                      ],
                    ),
                  if (home) ...[
                    const SizedBox(height: 22),
                    const SectionLabel('Accounts'),
                    const SizedBox(height: 9),
                    RmGroup(
                      children: [
                        for (final other in others)
                          RmRow(
                            label: other.address,
                            subtitle: 'Signed in · ${other.host}',
                            trailing: Icon(
                              Icons.swap_horiz_rounded,
                              size: 20,
                              color: c.ink3,
                            ),
                            onTap: () => unawaited(app.switchTo(other)),
                          ),
                        RmRow(
                          label: 'Add an account',
                          onTap: () =>
                              pushScreen(context, const AddAccountScreen()),
                        ),
                        RmRow(
                          label: 'Sign out',
                          danger: true,
                          onTap: () => unawaited(_signOut(context)),
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
