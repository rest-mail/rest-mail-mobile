import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../l10n/voice.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';

/// Issues a secret on demand and keeps it only while this screen is foreground.
class InvitationScreen extends StatefulWidget {
  const InvitationScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final AdminMailbox mailbox;

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen>
    with WidgetsBindingObserver {
  AccountInvitation? _invitation;
  Timer? _expiry;
  bool _busy = false;
  bool _revealed = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _clearClipboard(String token) async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboard?.text == token)
      await Clipboard.setData(const ClipboardData(text: ''));
  }

  void _forget() {
    final token = _invitation?.token;
    _expiry?.cancel();
    _invitation = null;
    _revealed = false;
    if (token != null) unawaited(_clearClipboard(token));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      if (mounted) setState(_forget);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _forget();
    super.dispose();
  }

  Future<void> _issue() async {
    setState(() {
      _busy = true;
      _error = null;
      _forget();
    });
    try {
      final invitation = await widget.account.client.inviteAccount(
        widget.mailbox.id,
      );
      if (!mounted) return;
      setState(() => _invitation = invitation);
      _expiry = Timer(invitation.expiresAt.difference(DateTime.now()), () {
        if (mounted) setState(_forget);
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(
        () => _error = error.code == 'account_not_invitable'
            ? tr(context, 'invitation.notInvitable')
            : describeError(context, error, host: widget.account.server.host),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final invitation = _invitation;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'invitation.issueTitle'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    widget.mailbox.address,
                    style: rmText(18, color: c.ink, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tr(context, 'invitation.issueIntro'),
                    style: rmText(15, color: c.ink2),
                  ),
                  if (invitation != null) ...[
                    const SizedBox(height: 22),
                    Text(
                      trArgs(context, 'invitation.expires', {
                        'date': longDate(invitation.expiresAt),
                      }),
                      style: rmText(14, color: c.ink2),
                    ),
                    const SizedBox(height: 16),
                    if (_revealed)
                      SelectableText(
                        invitation.token,
                        style: rmText(15, color: c.ink),
                      )
                    else
                      TextButton(
                        onPressed: () => setState(() => _revealed = true),
                        child: Text(tr(context, 'invitation.show')),
                      ),
                    TextButton(
                      onPressed: () async {
                        if (!invitation.expiresAt.isAfter(DateTime.now())) {
                          setState(_forget);
                          return;
                        }
                        await Clipboard.setData(
                          ClipboardData(text: invitation.token),
                        );
                        if (context.mounted)
                          showToast(context, tr(context, 'invitation.copied'));
                      },
                      child: Text(tr(context, 'invitation.copy')),
                    ),
                  ],
                  if (_error case final error?) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 22),
                  RmPrimaryButton(
                    label: tr(context, 'invitation.generate'),
                    busy: _busy,
                    onPressed: _busy ? null : () => unawaited(_issue()),
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
