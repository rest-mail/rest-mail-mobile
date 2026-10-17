import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _nameOf(WebmailAccount account) => account.address.isNotEmpty
    ? account.address
    : 'Mailbox ${account.mailboxId}';

String _addressOf(LinkedMailbox link) =>
    link.address.isNotEmpty ? link.address : 'Mailbox ${link.mailboxId}';

/// A note above a list or below a card, in the quiet colour.
Widget _note(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: Text(text, style: rmText(13, color: context.rm.ink3, height: 1.4)),
);

/// What each mailbox signs in to webmail as, and the other mailboxes its
/// owner linked to it there. The server makes one at a mailbox's first
/// sign-in; its owner links and unlinks mailboxes, with each one's password.
class WebmailAccountsScreen extends StatefulWidget {
  const WebmailAccountsScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<WebmailAccountsScreen> createState() => _WebmailAccountsScreenState();
}

class _WebmailAccountsScreenState extends State<WebmailAccountsScreen> {
  late final _list = AdminList<WebmailAccount>(
    (offset) => widget.account.client.webmailAccounts(offset: offset),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.webmailAccounts)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final made = await Navigator.push<WebmailAccount>(
      context,
      MaterialPageRoute(
        builder: (_) => _MailboxPicker(
          account: widget.account,
          taken: {for (final a in _list.items) a.mailboxId},
        ),
      ),
    );
    if (made == null || !mounted) return;
    showToast(context, 'Made a webmail account for ${_nameOf(made)}');
    unawaited(_list.reload());
  }

  Future<void> _open(WebmailAccount webmail) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WebmailAccountScreen(account: widget.account, webmail: webmail),
      ),
    );
    if (!mounted) return;
    if (done != null) showToast(context, done);
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.webmailAccounts,
    title: 'Webmail accounts',
    body: (access) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: 'No mailbox has signed in to webmail yet.',
      header: [
        _note(context, 'A mailbox gets one when it first signs in to webmail.'),
        if (access.canWrite(AdminSection.webmailAccounts))
          AdminAddButton(
            label: 'Make one for a mailbox',
            onTap: () => unawaited(_add()),
          ),
      ],
      row: (webmail) => RmRow(
        label: _nameOf(webmail),
        subtitle: switch (webmail.linked) {
          [] => 'No other mailboxes',
          final linked => 'With ${linked.map(_addressOf).join(', ')}',
        },
        onTap: () => unawaited(_open(webmail)),
      ),
    ),
  );
}

/// One webmail account: its mailbox, the mailboxes linked to it, and with
/// `mailboxes:delete`, a way to delete it. Pops with what was done.
class WebmailAccountScreen extends StatefulWidget {
  const WebmailAccountScreen({
    super.key,
    required this.account,
    required this.webmail,
  });

  final RestAccount account;
  final WebmailAccount webmail;

  @override
  State<WebmailAccountScreen> createState() => _WebmailAccountScreenState();
}

class _WebmailAccountScreenState extends State<WebmailAccountScreen> {
  var _busy = false;

  Future<void> _delete() async {
    setState(() => _busy = true);
    final name = _nameOf(widget.webmail);
    final ok = await runAdminChange(
      context,
      host: widget.account.server.host,
      change: () =>
          widget.account.client.deleteWebmailAccount(widget.webmail.id),
      confirm: (
        title: 'Delete the webmail account for $name?',
        message:
            'Its mailbox and mail stay. Its next sign-in to webmail starts a '
            'new account, without the linked mailboxes.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'Deleted the webmail account for $name');
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final webmail = widget.webmail, since = webmail.createdAt;
    return AdminPage(
      account: widget.account,
      section: AdminSection.webmailAccounts,
      title: 'Webmail account',
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(label: 'Mailbox', value: _nameOf(webmail)),
              if (webmail.displayName.isNotEmpty)
                RmRow(label: 'Name', value: webmail.displayName),
              if (since != null) RmRow(label: 'Since', value: longDate(since)),
            ],
          ),
          const SizedBox(height: 22),
          const SectionLabel('Linked mailboxes'),
          const SizedBox(height: 9),
          if (webmail.linked.isEmpty)
            _note(context, 'No other mailboxes are linked to it.')
          else ...[
            RmGroup(
              children: [
                for (final link in webmail.linked)
                  RmRow(
                    label: _addressOf(link),
                    subtitle: [
                      if (link.displayName.isNotEmpty) link.displayName,
                      if (link.linkedAt case final at?)
                        'Linked ${timeLabel(at)}',
                    ].join('\n'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          _note(
            context,
            'Its owner links and unlinks mailboxes in webmail, with each '
            "one's password.",
          ),
          if (access.canDelete(AdminSection.webmailAccounts)) ...[
            const SizedBox(height: 8),
            RmGroup(
              children: [
                RmRow(
                  label: 'Delete webmail account',
                  danger: true,
                  onTap: _busy ? null : () => unawaited(_delete()),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Picks the mailbox to make a webmail account for, and makes it. Pops with
/// the account made.
class _MailboxPicker extends StatefulWidget {
  const _MailboxPicker({required this.account, required this.taken});

  final RestAccount account;

  /// The mailboxes known to have one already. The server refuses the rest.
  final Set<int> taken;

  @override
  State<_MailboxPicker> createState() => _MailboxPickerState();
}

class _MailboxPickerState extends State<_MailboxPicker> {
  late final _list = AdminList<AdminMailbox>(
    (offset) => widget.account.client.mailboxes(offset: offset),
  );
  var _busy = false;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canWrite(AdminSection.webmailAccounts)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _make(AdminMailbox box) async {
    setState(() => _busy = true);
    WebmailAccount? made;
    await runAdminChange(
      context,
      host: widget.account.server.host,
      change: () async =>
          made = await widget.account.client.createWebmailAccount(box.id),
    );
    if (!mounted) return;
    if (made case final webmail?) {
      Navigator.pop(context, webmail);
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.webmailAccounts,
    title: 'Pick a mailbox',
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: 'No mailboxes yet.',
      header: [
        _note(
          context,
          'It gets the webmail account it would get at its first sign-in.',
        ),
      ],
      row: (box) {
        final taken = widget.taken.contains(box.id);
        return RmRow(
          label: box.address,
          subtitle: taken ? 'Has one already' : null,
          onTap: taken || _busy ? null : () => unawaited(_make(box)),
        );
      },
    ),
  );
}
