import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../push/push_service.dart';
import '../state/admin_access.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/mailbox_state.dart';
import '../state/push_state.dart';
import '../state/settings.dart';
import '../theme/packs.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../version.dart';
import 'admin/admin_screen.dart';
import 'app_passwords_screen.dart';
import 'mail_rules_screen.dart';
import 'api_keys_screen.dart';
import 'two_factor_screen.dart';
import 'interface_customizer_screen.dart';
import 'my_permissions_screen.dart';
import 'whats_new_screen.dart';
import 'push_offer.dart';
import 'scheduled_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/painters.dart';

void _push(BuildContext context, Widget screen) => unawaited(
  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen)),
);

String _storage(BuildContext context, QuotaInfo quota) => quota.quotaBytes > 0
    ? trArgs(context, 'ui.valueOfValue2Used', {
        'value': (sizeLabel(quota.usedBytes)).toString(),
        'value2': (sizeLabel(quota.quotaBytes)).toString(),
      })
    : trArgs(context, 'ui.valueUsed', {
        'value': (sizeLabel(quota.usedBytes)).toString(),
      });

class MailboxSettingsScreen extends StatefulWidget {
  const MailboxSettingsScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<MailboxSettingsScreen> createState() => _MailboxSettingsScreenState();
}

class _MailboxSettingsScreenState extends State<MailboxSettingsScreen> {
  QuotaInfo? _quota;
  ServerDescription? _server;

  @override
  void initState() {
    super.initState();
    unawaited(_loadQuota());
    unawaited(_loadServer());
  }

  Future<void> _loadServer() async {
    try {
      final server = await widget.mailbox.backend.describeServer();
      if (mounted) setState(() => _server = server);
    } on ApiException {
      // The footer leaves the version out.
    }
  }

  Future<void> _loadQuota() async {
    final account = widget.mailbox.account;
    if (account == null) return;
    try {
      final quota = await widget.mailbox.backend.quota(account.id);
      if (mounted) setState(() => _quota = quota);
    } on ApiException {
      // The footer leaves storage out.
    }
  }

  bool _busy = false;

  Future<void> _remove() async {
    final account = widget.mailbox.account;
    if (account == null) return;
    final host = widget.mailbox.backend.host;
    final app = AppScope.read(context);
    if (account.isPrimary) {
      final signedIn = app.current;
      final sure = await confirmAction(
        context,
        title: tr(context, 'settings.signOut'),
        message: [
          trArgs(context, 'settings.theSessionForAddressEndsTheAccount', {
            'address': (account.address).toString(),
            'host': (host).toString(),
          }),
          if (app.accounts.length > 1)
            tr(context, 'settings.yourOtherAccountsStaySignedIn'),
        ].join(' '),
        action: tr(context, 'settings.signOut2'),
      );
      if (sure && signedIn != null) await app.signOut(signedIn);
      return;
    }
    final sure = await confirmAction(
      context,
      title: trArgs(context, 'settings.unlinkAddress', {
        'address': (account.address).toString(),
      }),
      message: tr(context, 'settings.thisAccountGivesUpItsAccessTo'),
      action: tr(context, 'settings.unlink'),
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.mailbox.backend.unlinkAccount(account.id);
      await widget.mailbox.reloadAccounts();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            trArgs(context, 'settings.unlinkedAddress', {
              'address': (account.address).toString(),
            }),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, describeError(context, e, host: host));
    }
  }

  Future<void> _removeFromPhone() async {
    final app = AppScope.read(context);
    final signedIn = app.current;
    if (signedIn == null) return;
    final sure = await confirmAction(
      context,
      title: trArgs(context, 'mailbox.removeAddress', {
        'address': (signedIn.address).toString(),
      }),
      message: trArgs(context, 'settings.theAccountAndItsSettingsAreRemoved', {
        'host': (signedIn.host).toString(),
      }),
      action: tr(context, 'common.remove'),
    );
    if (sure) await app.removeAccount(signedIn);
  }

  Future<void> _changeIcon({bool clear = false}) async {
    final app = AppScope.read(context);
    final signedIn = app.current;
    if (signedIn == null) return;
    File? picked;
    if (!clear) {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 90,
      );
      if (image == null) return;
      picked = File(image.path);
    }
    final saved = await app.setAccountIcon(signedIn, picked);
    if (!mounted) return;
    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'settings.iconCouldNotBeSaved'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final m = widget.mailbox;
    final host = m.backend.host;
    final quota = _quota;
    final current = app.current;
    final session = switch (app.current) {
      final RestAccount rest when identical(rest.backend, m.backend) => rest,
      _ => null,
    };
    final administers =
        current is RestAccount &&
        current.signedOut == null &&
        AdminAccess(current.capabilities).any;
    // Creating takes mailboxes:write; the server checks it covers the
    // domain asked for.
    final creates =
        current is RestAccount &&
        identical(current.backend, m.backend) &&
        AdminAccess(current.capabilities).canWrite(AdminSection.mailboxes);
    // The custom icon belongs to the signed-in account, so the row only
    // appears for the account this phone is on, not for a linked mailbox.
    final iconAccount =
        current != null &&
            m.account != null &&
            current.address.toLowerCase() == m.account!.address.toLowerCase()
        ? current
        : null;
    return ListenableBuilder(
      listenable: m,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              RmTopBar(
                title: tr(context, 'settings.mailboxTitle'),
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                  children: [
                    Text(
                      '${tr(context, 'settings.storedOn')} $host',
                      style: rmText(12, color: c.ink3, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    SectionLabel(tr(context, 'settings.thisMailbox')),
                    const SizedBox(height: 9),
                    RmGroup(
                      children: [
                        if (current case final out? when out.signedOut != null)
                          _AccountRow(
                            label: out.label,
                            address: out.address,
                            subtitle: trArgs(
                              context,
                              'settings.signedOutHost',
                              {'host': (out.host).toString()},
                            ),
                            primary: true,
                            onTap: () => Navigator.pop(context),
                          )
                        else if (m.account case final account?) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                            child: Row(
                              children: [
                                RmAvatar(
                                  name: account.label,
                                  seed: account.address,
                                  size: 40,
                                  color: account.isPrimary ? c.accent : null,
                                  iconFileName: iconAccount == null
                                      ? null
                                      : app.iconFileNameOf(iconAccount),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        account.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: rmText(
                                          15,
                                          color: c.ink,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        account.isPrimary
                                            ? '${tr(context, 'settings.primaryMailbox')} · $host'
                                            : '${tr(context, 'settings.mailboxOfAccount')} · $host',
                                        style: rmText(12, color: c.ink3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RmRow(
                            label: tr(context, 'settings.displayName'),
                            value: account.displayName.isEmpty
                                ? '—'
                                : account.displayName,
                          ),
                          if (iconAccount != null) ...[
                            RmRow(
                              label: tr(context, 'settings.accountIcon'),
                              value: app.iconFileNameOf(iconAccount) == null
                                  ? tr(context, 'settings.restMailMark')
                                  : tr(context, 'settings.customPhoto'),
                              onTap: _busy
                                  ? null
                                  : () => unawaited(_changeIcon()),
                            ),
                            if (app.iconFileNameOf(iconAccount) != null)
                              RmRow(
                                label: tr(context, 'settings.removeIcon'),
                                danger: true,
                                onTap: _busy
                                    ? null
                                    : () => unawaited(_changeIcon(clear: true)),
                              ),
                          ],
                          RmRow(
                            label: tr(context, 'settings.server'),
                            value: host,
                          ),
                          if (quota != null)
                            RmRow(
                              label: tr(context, 'mailboxes.storage'),
                              value: _storage(context, quota),
                            ),
                          RmRow(
                            label: tr(context, 'settings.updates'),
                            value: m.backend.canLinkMailboxes
                                ? tr(context, 'settings.pushedLiveByTheServer')
                                : tr(context, 'settings.liveWhileTheAppIsOpen'),
                          ),
                          if (session != null &&
                              session.signedOut == null &&
                              account.isPrimary)
                            RmRow(
                              label: tr(context, 'twoFactor.title'),
                              subtitle: tr(
                                context,
                                'settings.authenticatorAndRecoveryCodes',
                              ),
                              onTap: () => _push(
                                context,
                                TwoFactorScreen(account: session),
                              ),
                            ),
                          if (session != null)
                            RmRow(
                              label: tr(context, 'apppasswords.appPasswords'),
                              subtitle: tr(
                                context,
                                'settings.forMailAppsAndAutomations',
                              ),
                              onTap: () => _push(
                                context,
                                AppPasswordsScreen(
                                  account: session,
                                  mailbox: account,
                                ),
                              ),
                            ),
                          if (session != null)
                            RmRow(
                              label: tr(context, 'apikeys.apiKeys'),
                              subtitle: tr(
                                context,
                                'settings.scopedPermissionsForAutomations',
                              ),
                              onTap: () => _push(
                                context,
                                APIKeysScreen(
                                  account: session,
                                  mailbox: account,
                                ),
                              ),
                            ),
                          if (current is RestAccount &&
                              current.signedOut == null) ...[
                            if (creates)
                              _AddRow(
                                label: tr(context, 'settings.createMailbox'),
                                onTap: () => _push(
                                  context,
                                  CreateMailboxScreen(
                                    account: current,
                                    mailbox: m,
                                  ),
                                ),
                              ),
                            if (m.backend.canLinkMailboxes)
                              _AddRow(
                                label: tr(context, 'settings.linkMailbox'),
                                onTap: () => _push(
                                  context,
                                  LinkAccountScreen(mailbox: m),
                                ),
                              ),
                          ],
                          RmRow(
                            label: account.isPrimary
                                ? tr(context, 'settings.signOut2')
                                : tr(context, 'settings.unlinkFromThisAccount'),
                            danger: true,
                            onTap: _busy ? null : () => unawaited(_remove()),
                          ),
                          if (account.isPrimary)
                            RmRow(
                              label: tr(context, 'mailbox.removeFromThisPhone'),
                              danger: true,
                              onTap: _busy
                                  ? null
                                  : () => unawaited(_removeFromPhone()),
                            ),
                        ],
                      ],
                    ),
                    // Every signed-in REST session reaches its own grants:
                    // one whose roles are all eligible holds nothing that
                    // shows Administration until it switches one on there.
                    if (current is RestAccount &&
                        current.signedOut == null) ...[
                      const SizedBox(height: 22),
                      SectionLabel(tr(context, 'settings.server')),
                      const SizedBox(height: 9),
                      RmGroup(
                        children: [
                          if (administers)
                            RmRow(
                              label: tr(context, 'settings.administration'),
                              subtitle: trArgs(
                                context,
                                'settings.whatThisSessionMayRunOnHost',
                                {'host': (host).toString()},
                              ),
                              onTap: () => _push(
                                context,
                                AdministrationScreen(account: current),
                              ),
                            ),
                          RmRow(
                            label: tr(context, 'settings.myPermissions'),
                            subtitle: tr(
                              context,
                              'settings.myPermissionsSubtitle',
                            ),
                            onTap: () => _push(
                              context,
                              MyPermissionsScreen(account: current),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (m.backend.canScheduleSend) ...[
                      const SizedBox(height: 22),
                      SectionLabel(tr(context, 'settings.sending')),
                      const SizedBox(height: 9),
                      RmGroup(
                        children: [
                          RmRow(
                            label: tr(context, 'settings.scheduled'),
                            subtitle: tr(context, 'settings.scheduledSubtitle'),
                            onTap: () =>
                                _push(context, ScheduledScreen(mailbox: m)),
                          ),
                        ],
                      ),
                    ],
                    // Last, so the sections above stay where they were.
                    if (session != null && m.account != null) ...[
                      const SizedBox(height: 22),
                      SectionLabel(tr(context, 'settings.mailRules')),
                      const SizedBox(height: 9),
                      RmGroup(
                        children: [
                          RmRow(
                            label: tr(context, 'mailrules.vacationReply'),
                            subtitle: tr(
                              context,
                              'settings.anAutomaticAnswerWhileYouAreAway',
                            ),
                            onTap: () => _push(
                              context,
                              VacationReplyScreen(
                                account: session,
                                mailbox: m.account!,
                              ),
                            ),
                          ),
                          RmRow(
                            label: tr(context, 'mailrules.mailFilters'),
                            subtitle: tr(
                              context,
                              'settings.aSieveScriptThatFilesForwardsOr',
                            ),
                            onTap: () => _push(
                              context,
                              MailFiltersScreen(
                                account: session,
                                mailbox: m.account!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 22),
                    Text(
                      [
                        switch (_server) {
                          final server? => '$host · ${productLabel(server)}',
                          null => host,
                        },
                        if (quota != null)
                          trArgs(context, 'ui.valueMessagesValue2', {
                            'value': (countLabel(quota.messageCount))
                                .toString(),
                            'value2': (_storage(context, quota)).toString(),
                          }),
                      ].join('\n'),
                      textAlign: TextAlign.center,
                      style: rmText(11.5, color: c.ink3, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The product a server runs and its version, by the product's name: REST
/// Mail for rest-mail.
String productLabel(ServerDescription server) =>
    '${server.product == 'rest-mail' ? 'REST Mail' : server.product} '
    '${server.version}';

/// What belongs to this phone rather than a mailbox: language, theme, the
/// interface, notifications and the signature.
class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final settings = app.settings;
    final signature = settings.signature.trim();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.appTitle'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                children: [
                  SectionLabel(tr(context, 'settings.thisPhone')),
                  const SizedBox(height: 9),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.language'),
                        value: languageLabel(
                          settings.languageCode,
                          context: context,
                        ),
                        onTap: () => _push(context, const LanguageScreen()),
                      ),
                      RmRow(
                        label: tr(context, 'settings.signature'),
                        value: signature.isEmpty
                            ? tr(context, 'interface.none')
                            : signature.split('\n').first,
                        onTap: () => _push(context, const SignatureScreen()),
                      ),
                      RmRow(
                        label: tr(context, 'settings.mailCheck'),
                        subtitle: tr(context, 'settings.mailCheckSubtitle'),
                        value: settings.mailCheckLive
                            ? tr(context, 'settings.mailCheckLive')
                            : trArgs(context, 'settings.everyMinutes', {
                                'minutes':
                                    '${settings.mailCheckInterval.inMinutes}',
                              }),
                        onTap: () => _push(context, const MailCheckScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _NotificationsSection(app: app),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'settings.interface')),
                  const SizedBox(height: 9),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.customizeScreens'),
                        subtitle: tr(context, 'settings.customizeSubtitle'),
                        onTap: () =>
                            _push(context, const InterfaceCustomizerScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'settings.appearance')),
                  const SizedBox(height: 9),
                  RmGroup(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tr(context, 'settings.brightness'),
                                style: rmText(
                                  14.5,
                                  color: c.ink,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (ThemePack.byId(settings.packId).followsSystem)
                              RmSegmented<ThemeMode>(
                                options: [
                                  (
                                    ThemeMode.system,
                                    tr(context, 'settings.system'),
                                  ),
                                  (
                                    ThemeMode.light,
                                    tr(context, 'settings.light'),
                                  ),
                                  (
                                    ThemeMode.dark,
                                    tr(context, 'settings.dark'),
                                  ),
                                ],
                                value: settings.themeMode,
                                onChanged: (mode) => unawaited(
                                  app.updateSettings(
                                    settings.copyWith(themeMode: mode),
                                  ),
                                ),
                              )
                            else
                              Text(
                                tr(context, 'settings.setsItsOwn'),
                                style: rmText(12, color: c.ink3),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                        child: Column(
                          children: [
                            for (final pack in ThemePack.all)
                              _PackTile(
                                pack: pack,
                                selected: pack.id == settings.packId,
                                onTap: () => unawaited(
                                  app.updateSettings(
                                    settings.copyWith(packId: pack.id),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.whatsNew'),
                        subtitle: tr(context, 'settings.whatsNewSubtitle'),
                        onTap: () => _push(context, const WhatsNewScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    trArgs(context, 'settings.restMailForMobileAppVersion', {
                      'appVersion': (appVersion).toString(),
                    }),
                    textAlign: TextAlign.center,
                    style: rmText(11.5, color: c.ink3, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The language the app speaks.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final selected = app.settings.languageCode;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.language'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                children: [
                  RmGroup(
                    children: [
                      for (final entry in languageNames.entries)
                        RmRow(
                          label: entry.key == 'system'
                              ? tr(context, 'settings.system')
                              : entry.value,
                          trailing: entry.key == selected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: c.accent,
                                )
                              : const SizedBox(width: 20),
                          onTap: () {
                            unawaited(
                              app.updateSettings(
                                app.settings.copyWith(languageCode: entry.key),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// How often accounts without live updates check for new mail.
class MailCheckScreen extends StatelessWidget {
  const MailCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final settings = app.settings;
    final selected = settings.mailCheckInterval.inMinutes;
    final live = settings.mailCheckLive;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.mailCheck'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                children: [
                  Text(
                    tr(context, 'settings.mailCheckNote'),
                    style: rmText(12.5, color: c.ink3, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.mailCheckLive'),
                        subtitle: tr(context, 'settings.mailCheckLiveSubtitle'),
                        trailing: live
                            ? Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: c.accent,
                              )
                            : const SizedBox(width: 20),
                        onTap: () {
                          unawaited(
                            app.updateSettings(
                              settings.copyWith(mailCheckLive: true),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                      for (final minutes in AppSettings.mailCheckMinutes)
                        RmRow(
                          label: trArgs(context, 'settings.everyMinutes', {
                            'minutes': '$minutes',
                          }),
                          trailing: !live && minutes == selected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: c.accent,
                                )
                              : const SizedBox(width: 20),
                          onTap: () {
                            unawaited(
                              app.updateSettings(
                                settings.copyWith(
                                  mailCheckLive: false,
                                  mailCheckInterval: Duration(minutes: minutes),
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// New mail notifications, once this phone can have them and a server can
/// send them; until then, not a word.
class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: app.push,
    builder: (context, _) {
      final c = context.rm;
      final push = app.push;
      if (!push.available) return const SizedBox.shrink();
      final notes = [
        for (final account in app.accounts)
          if (account is RestAccount &&
              push.statusOf(account) == PushStatus.unsupported)
            trArgs(
              context,
              'settings.addressItsServerDoesnTSendNotifications',
              {'address': (account.address).toString()},
            ),
        if (app.accounts.any((a) => a is ImapAccount))
          tr(context, notificationsImapNote),
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(tr(context, 'settings.notifications')),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              RmRow(
                label: tr(context, 'settings.newMail'),
                subtitle: push.permission == NotificationPermission.denied
                    ? tr(context, 'settings.turnedOffForRESTMailInThe')
                    : tr(context, 'settings.onlyASignalGoesThroughAppleThe'),
                trailing: RmSwitch(
                  key: const Key('notifications-switch'),
                  label: tr(context, 'settings.newMailNotifications'),
                  value: push.enabled,
                  onChanged: (on) =>
                      unawaited(on ? push.enable() : push.disable()),
                ),
              ),
            ],
          ),
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: Text(note, style: rmText(12, color: c.ink3, height: 1.4)),
            ),
          const SizedBox(height: 22),
        ],
      );
    },
  );
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.label,
    required this.address,
    required this.subtitle,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final String address;
  final String subtitle;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            RmAvatar(
              name: label,
              seed: address,
              size: 32,
              color: primary ? c.accent : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
                  ),
                  Text(subtitle, style: rmText(12, color: c.ink3)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: c.ink3),
          ],
        ),
      ),
    );
  }
}

class _AddRow extends StatelessWidget {
  const _AddRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            DashedCircle(
              color: c.ink3,
              size: 32,
              child: Icon(Icons.add_rounded, size: 16, color: c.accent),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: rmText(14.5, color: c.accent, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late final TextEditingController _text;
  late bool _signReplies;

  @override
  void initState() {
    super.initState();
    final settings = AppScope.read(context).settings;
    _text = TextEditingController(text: settings.signature);
    _signReplies = settings.signReplies;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final app = AppScope.read(context);
    await app.updateSettings(
      app.settings.copyWith(
        signature: _text.text.trimRight(),
        signReplies: _signReplies,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final preview = _text.text.trim();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.signature'),
              onBack: () => Navigator.pop(context),
              trailingText: tr(context, 'common.save'),
              onTrailing: () => unawaited(_save()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                children: [
                  TextField(
                    controller: _text,
                    minLines: 6,
                    maxLines: 12,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    style: rmText(15, color: c.ink, height: 1.55),
                    decoration: InputDecoration(
                      hintText: tr(context, 'settings.yourNameWhatYouDo'),
                      hintMaxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionLabel(tr(context, 'quarantine.preview')),
                  const SizedBox(height: 9),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border.all(color: c.line),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(context, 'settings.thanksForTheQuickTurnaround'),
                          style: rmText(15, color: c.ink2, height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        DashedLine(color: c.line),
                        const SizedBox(height: 12),
                        Text(
                          preview.isEmpty
                              ? tr(context, 'settings.noSignature')
                              : preview,
                          style: rmText(
                            14,
                            color: preview.isEmpty ? c.ink3 : c.ink,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.appendOnReplies'),
                        subtitle: tr(
                          context,
                          'settings.newMessagesAlwaysGetIt',
                        ),
                        trailing: RmSwitch(
                          value: _signReplies,
                          label: tr(context, 'settings.appendOnReplies'),
                          onChanged: (value) =>
                              setState(() => _signReplies = value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Links another account on the same server to this one, proving its
/// password, and its code when it has two-factor authentication.
class LinkAccountScreen extends StatefulWidget {
  const LinkAccountScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  final _codeFocus = FocusNode();
  bool _needsCode = false;
  bool _busy = false;
  String? _error;

  bool get _ready =>
      !_busy &&
      _email.text.contains('@') &&
      _password.text.isNotEmpty &&
      (!_needsCode || _code.text.trim().isNotEmpty);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _code.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> _link() async {
    final host = widget.mailbox.backend.host;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final linked = await widget.mailbox.backend.linkAccount(
        address: _email.text.trim(),
        password: _password.text,
        totpCode: _needsCode ? _code.text.trim() : null,
      );
      await widget.mailbox.reloadAccounts();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            trArgs(context, 'settings.linkedAddress', {
              'address': (linked.address).toString(),
            }),
          ),
        ),
      );
    } on TotpRequiredException {
      if (!mounted) return;
      setState(() {
        _needsCode = true;
        _busy = false;
      });
      _codeFocus.requestFocus();
    } on ApiException catch (e) {
      if (!mounted) return;
      // A refused link is 403 with its reason; this session is still good.
      if (e.code == 'invalid_totp') {
        _code.clear();
        _codeFocus.requestFocus();
      }
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(code: 'invalid_credentials') => tr(
            context,
            'signIn.badPassword',
          ),
          ApiException(code: 'invalid_totp') => tr(context, 'signIn.badCode'),
          ApiException(code: 'setup_required') => tr(
            context,
            'settings.thatAccountHasToSignInAnd',
          ),
          ApiException(statusCode: 409) => tr(
            context,
            'settings.thatMailboxIsAlreadyLinkedOrIs',
          ),
          _ => describeError(context, e, host: host),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final host = widget.mailbox.backend.host;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.linkAMailbox'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    trArgs(context, 'settings.addAnotherMailboxOnHostToThis', {
                      'host': (host).toString(),
                    }),
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'signIn.email')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() => _error = null),
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(hintText: 'someone@$host'),
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'signIn.password')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) {
                      if (_ready) unawaited(_link());
                    },
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(
                      hintText: tr(context, 'settings.itsPassword'),
                    ),
                  ),
                  if (_needsCode) ...[
                    const SizedBox(height: 22),
                    SectionLabel(tr(context, 'signIn.twoFactorCode')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _code,
                      focusNode: _codeFocus,
                      keyboardType: TextInputType.number,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      autocorrect: false,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) {
                        if (_ready) unawaited(_link());
                      },
                      style: rmText(16, color: c.ink, tracking: 0.08),
                      decoration: InputDecoration(
                        hintText: tr(context, 'settings.fromItsAuthenticator'),
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: tr(context, 'settings.linkMailboxAction'),
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_link()) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Creates a mailbox owned by this account, with no password of its own: it
/// is reached by signing in as this account, which can read it, send as it
/// and make its app passwords. Shown to a session holding `mailboxes:write`.
class CreateMailboxScreen extends StatefulWidget {
  const CreateMailboxScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final MailboxState mailbox;

  @override
  State<CreateMailboxScreen> createState() => _CreateMailboxScreenState();
}

class _CreateMailboxScreenState extends State<CreateMailboxScreen> {
  final _localPart = TextEditingController();
  final _displayName = TextEditingController();

  /// Known writable domains include explicit scoped grants even when the
  /// account cannot list domain configuration.
  late List<String> _domains = _initialDomains();
  late String _domain = _domains.first;
  bool _busy = false;
  String? _error;

  String get _ownDomain {
    final address = widget.account.address;
    return address.substring(address.indexOf('@') + 1).toLowerCase();
  }

  String get _address => '${_localPart.text.trim().toLowerCase()}@$_domain';

  List<String> _initialDomains() {
    final caps = widget.account.capabilities;
    final names = <String>{
      if (caps.allows(
        Capability.mailboxesWrite,
        scope: CapabilityScope.domain(_ownDomain),
      ))
        _ownDomain,
      for (final entry in caps.scoped)
        if (entry.scope.startsWith('domain:') &&
            caps.allows(Capability.mailboxesWrite, scope: entry.scope))
          entry.scope.substring(7),
    }.toList();
    return names.isEmpty ? [_ownDomain] : names;
  }

  bool get _ready =>
      !_busy &&
      widget.account.capabilities.allows(
        Capability.mailboxesWrite,
        scope: CapabilityScope.domain(_domain),
      ) &&
      _localPart.text.trim().isNotEmpty &&
      !_localPart.text.contains('@');

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.domains)) {
      unawaited(_loadDomains());
    }
  }

  @override
  void dispose() {
    _localPart.dispose();
    _displayName.dispose();
    super.dispose();
  }

  Future<void> _loadDomains() async {
    try {
      final names = <String>{..._initialDomains()};
      var offset = 0;
      while (true) {
        final page = await widget.account.client.domains(
          offset: offset,
          limit: 200,
        );
        for (final domain in page.items) {
          if (widget.account.capabilities.allows(
            Capability.mailboxesWrite,
            scope: CapabilityScope.domain(domain.name),
          )) {
            names.add(domain.name.toLowerCase());
          }
        }
        if (!page.hasMore || page.items.isEmpty) break;
        offset = page.next;
      }
      if (!mounted) return;
      setState(() => _domains = names.toList());
    } on ApiException {
      // The account's own domain is still there to choose.
    }
  }

  Future<void> _create() async {
    final host = widget.account.host;
    final address = _address;
    final name = _displayName.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final created = await widget.account.client.createAccount(
        address: address,
        displayName: name.isEmpty ? null : name,
      );
      await widget.mailbox.reloadAccounts();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            trArgs(context, 'settings.createdAddress', {
              'address': (created.address).toString(),
            }),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(statusCode: 403) => trArgs(
            context,
            'settings.addressCanTCreateMailboxesOnDomain',
            {
              'address': (widget.account.address).toString(),
              'domain': (_domain).toString(),
            },
          ),
          ApiException(statusCode: 409) => trArgs(
            context,
            'settings.addressAlreadyExists',
            {'address': (address).toString()},
          ),
          ApiException(statusCode: 422, :final fields, :final message) =>
            fields.values.firstOrNull ?? message,
          ApiException(statusCode: 404) => trArgs(
            context,
            'settings.hostCanTCreateMailboxesItsREST',
            {'host': (host).toString()},
          ),
          _ => describeError(context, e, host: host),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.createMailbox'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    trArgs(context, 'settings.aNewMailboxOwnedByAddressIt', {
                      'address': (widget.account.address).toString(),
                    }),
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'contacts.address')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _localPart,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() => _error = null),
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(
                      hintText: 'name',
                      suffixText: _domains.length > 1 ? null : '@$_domain',
                    ),
                  ),
                  if (_domains.length > 1) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _domain,
                      items: [
                        for (final domain in _domains)
                          DropdownMenuItem(
                            value: domain,
                            child: Text(
                              '@$domain',
                              style: rmText(16, color: c.ink),
                            ),
                          ),
                      ],
                      onChanged: (domain) => setState(() {
                        _domain = domain ?? _domain;
                        _error = null;
                      }),
                    ),
                  ],
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'settings.displayName')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _displayName,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) {
                      if (_ready) unawaited(_create());
                    },
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(
                      hintText: tr(context, 'contacts.nameHint'),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: tr(context, 'settings.createMailboxAction'),
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_create()) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One theme pack in the picker: its two loudest colours, its name, what it
/// is for, and a tick when it is the one in force.
class _PackTile extends StatelessWidget {
  const _PackTile({
    required this.pack,
    required this.selected,
    required this.onTap,
  });

  final ThemePack pack;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.line),
              ),
              child: ClipOval(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: Row(
                    children: [
                      Container(width: 13, height: 26, color: pack.colors.bg),
                      Container(width: 13, height: 26, color: pack.colors.mark),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(context, pack.nameKey),
                    style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    tr(context, pack.taglineKey),
                    style: rmText(12, color: c.ink3, height: 1.35),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_rounded, size: 18, color: c.accent),
          ],
        ),
      ),
    );
  }
}
