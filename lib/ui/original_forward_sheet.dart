import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/app_scope.dart';
import '../state/mail_backend.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import 'widgets/common.dart';

Future<void> openOriginalForward(
  BuildContext context, {
  required MailboxState mailbox,
  required OriginalForwardBackend backend,
  required Message original,
}) {
  final settings = AppScope.read(context).settings;
  final signature = settings.signature.trim();
  final note = settings.signReplies && signature.isNotEmpty
      ? '\n\n-- \n$signature'
      : '';
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.9,
      child: OriginalForwardSheet(
        mailbox: mailbox,
        backend: backend,
        original: original,
        initialNote: note,
      ),
    ),
  );
}

/// The server supplies the original body and parts. The editable text is only
/// the new note; it cannot accidentally replace or duplicate the original.
class OriginalForwardSheet extends StatefulWidget {
  const OriginalForwardSheet({
    super.key,
    required this.mailbox,
    required this.backend,
    required this.original,
    this.initialNote = '',
  });

  final MailboxState mailbox;
  final OriginalForwardBackend backend;
  final Message original;
  final String initialNote;

  @override
  State<OriginalForwardSheet> createState() => _OriginalForwardSheetState();
}

class _OriginalForwardSheetState extends State<OriginalForwardSheet> {
  final _to = TextEditingController();
  late final _note = TextEditingController(text: widget.initialNote);
  late final _initialFrom =
      widget.mailbox.account?.address ?? widget.mailbox.accounts.first.address;
  late String _from = _initialFrom;
  Timer? _timer;
  List<String> _pendingTo = const [];
  int _remaining = 0;
  bool _sending = false;
  String? _error;

  bool get _busy => _sending || _remaining > 0;
  bool get _dirty =>
      _to.text.isNotEmpty ||
      _note.text != widget.initialNote ||
      _from != _initialFrom;

  @override
  void dispose() {
    _timer?.cancel();
    _to.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    if (_busy) return;
    if (_dirty &&
        !await confirmAction(
          context,
          title: tr(context, 'compose.discard'),
          message: tr(context, 'compose.discardForward'),
          action: tr(context, 'compose.discard'),
        )) {
      return;
    }
    if (mounted) Navigator.pop(context);
  }

  void _send() {
    if (_busy) return;
    final addresses = parseAddresses(_to.text);
    if (addresses.invalid.isNotEmpty) {
      setState(
        () => _error = trArgs(context, 'compose.notAnAddress', {
          'address': addresses.invalid.first,
        }),
      );
      return;
    }
    if (addresses.valid.isEmpty) {
      setState(() => _error = tr(context, 'compose.noRecipients'));
      return;
    }
    setState(() {
      _error = null;
      _pendingTo = addresses.valid;
      _remaining = 5;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining == 1) {
        timer.cancel();
        unawaited(_commit());
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _undo() {
    _timer?.cancel();
    setState(() => _remaining = 0);
  }

  Future<void> _commit() async {
    setState(() {
      _remaining = 0;
      _sending = true;
    });
    try {
      final result = await widget.backend.forwardMessage(
        widget.original.id,
        from: _from,
        to: _pendingTo,
        bodyText: _note.text,
      );
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final message = tr(
        context,
        result is ForwardDiscarded
            ? 'compose.forwardDiscarded'
            : 'compose.sent',
      );
      Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text(message)));
      unawaited(widget.mailbox.refresh());
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = describeError(context, e, host: widget.mailbox.backend.host);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final original = widget.original;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_close());
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'compose.title.forward'),
              actions: [
                RmIconButton(
                  icon: Icons.close_rounded,
                  tooltip: tr(context, 'compose.close'),
                  onPressed: _busy ? null : () => unawaited(_close()),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _from,
                      decoration: InputDecoration(
                        labelText: tr(context, 'compose.from'),
                      ),
                      items: [
                        for (final account in widget.mailbox.accounts)
                          DropdownMenuItem(
                            value: account.address,
                            child: Text(account.address),
                          ),
                      ],
                      onChanged: _busy
                          ? null
                          : (value) {
                              if (value != null) setState(() => _from = value);
                            },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('forward-to'),
                      controller: _to,
                      enabled: !_busy,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: tr(context, 'message.forwardTo'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('forward-note'),
                      controller: _note,
                      enabled: !_busy,
                      minLines: 4,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: tr(context, 'compose.write'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SectionLabel(tr(context, 'message.forwardOriginal')),
                    const SizedBox(height: 8),
                    Text(
                      original.subject,
                      style: rmText(16, color: c.ink, weight: FontWeight.w600),
                    ),
                    Text(
                      senderLine(original),
                      style: rmText(13, color: c.ink2),
                    ),
                    if (original.hasAttachments)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.attach_file_rounded,
                              size: 18,
                              color: c.ink2,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              tr(context, 'attachments.title'),
                              style: rmText(13, color: c.ink2),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      plainBodyOf(original),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(14, color: c.ink2),
                    ),
                    if (_error case final error?)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ErrorText(error),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _remaining > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trArgs(context, 'compose.sendingIn', {
                            'seconds': '$_remaining',
                          }),
                        ),
                        TextButton(
                          onPressed: _undo,
                          child: Text(tr(context, 'compose.undo')),
                        ),
                      ],
                    )
                  : RmPrimaryButton(
                      key: const ValueKey('forward-send'),
                      label: tr(context, 'message.forward'),
                      busy: _sending,
                      onPressed: _busy ? null : _send,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
