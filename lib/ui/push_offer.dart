import 'dart:async';

import '../l10n/voice.dart';

import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/push_state.dart';
import '../theme/tokens.dart';

/// What new mail notifications are, said once, after sign-in, before iOS's
/// own prompt. Shown only when this phone can have them and the server of
/// a signed-in account can send them, and only until the user has chosen.
class PushOffer extends StatefulWidget {
  const PushOffer({super.key, required this.child});

  final Widget child;

  @override
  State<PushOffer> createState() => _PushOfferState();
}

class _PushOfferState extends State<PushOffer> {
  PushNotifications? _push;
  bool _showing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final push = AppScope.read(context).push;
    if (identical(push, _push)) return;
    _push?.removeListener(_check);
    _push = push..addListener(_check);
    _check();
  }

  @override
  void dispose() {
    _push?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_showing || !(_push?.shouldOffer ?? false)) return;
    _showing = true;
    // After the frame, so the inbox is on screen beneath it.
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_offer()));
  }

  Future<void> _offer() async {
    final app = AppScope.read(context);
    final push = app.push;
    if (!mounted || !push.shouldOffer) {
      _showing = false;
      return;
    }
    final hasImap = app.accounts.any((a) => a is ImapAccount);
    final yes = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _OfferDialog(hasImap: hasImap),
    );
    if (yes ?? false) {
      await push.enable();
    } else {
      await push.decline();
    }
    _showing = false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _OfferDialog extends StatelessWidget {
  const _OfferDialog({required this.hasImap});

  final bool hasImap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return AlertDialog(
      title: Text(tr(context, 'pushoffer.getNotifiedOfNewMail')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr(context, 'pushoffer.restMailCanTellYouWhenMail')),
          const SizedBox(height: 10),
          Text(
            tr(context, 'pushoffer.yourServerSendsAppleOnlyASignal'),
            style: rmText(13.5, color: c.ink2, height: 1.4),
          ),
          if (hasImap) ...[
            const SizedBox(height: 10),
            Text(
              tr(context, notificationsImapNote),
              style: rmText(13.5, color: c.ink2, height: 1.4),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            tr(context, 'pushoffer.notNow'),
            style: rmText(14.5, color: c.ink2, weight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            tr(context, 'pushoffer.turnOn'),
            style: rmText(14.5, color: c.accent, weight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

/// Why Gmail and other IMAP accounts get no notifications.
const notificationsImapNote = 'pushoffer.gmailAndOtherIMAPAccountsGetNo';
