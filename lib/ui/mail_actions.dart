import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/voice.dart';
import '../state/mailbox_state.dart';
import '../util/compose_seed.dart';
import 'compose_sheet.dart';
import 'widgets/common.dart';

/// Runs [action], which takes [message] out of the folder on screen, then
/// says [done] with an Undo, labelled [undoLabel], that puts it back where it
/// was. [others] are the rest of its conversation, taken out with it and put
/// back with it. Both words come in already translated: the screen that
/// asked may be gone by the time this speaks.
Future<void> removeWithUndo({
  required ScaffoldMessengerState messenger,
  required MailboxState mailbox,
  required Message message,
  required Future<void> Function() action,
  required String done,
  required String undoLabel,
  bool undoable = true,
  List<Message> others = const [],
}) async {
  try {
    await action();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(done),
          duration: Duration(milliseconds: undoable ? 4000 : 2200),
          action: undoable
              ? SnackBarAction(
                  label: undoLabel,
                  onPressed: () => unawaited(
                    _undo(messenger, mailbox, [message, ...others]),
                  ),
                )
              : null,
        ),
      );
  } on ApiException catch (e) {
    _failed(messenger, e);
  }
}

/// Says why a removal or its undo failed, in the messenger's own words: the
/// screen that asked may be gone, the messenger is not.
void _failed(ScaffoldMessengerState messenger, ApiException e) {
  final context = messenger.context;
  if (!context.mounted) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(describeError(context, e))));
}

Future<void> _undo(
  ScaffoldMessengerState messenger,
  MailboxState mailbox,
  List<Message> messages,
) async {
  try {
    for (final message in messages) {
      await mailbox.undoRemoval(message);
    }
  } on ApiException catch (e) {
    _failed(messenger, e);
  }
}

/// Deleting from Trash is for good, so that one asks first.
Future<bool> confirmPermanentDelete(
  BuildContext context,
  Message message,
) async =>
    message.folder != StandardFolder.trash ||
    await confirmAction(
      context,
      title: tr(context, 'message.deleteForever'),
      message: tr(context, 'message.deleteForeverBody'),
      action: tr(context, 'message.delete'),
    );

/// A link tapped in a message: mailto opens a new message here, anything
/// else goes to the system.
Future<void> openLink(
  BuildContext context,
  MailboxState mailbox,
  Uri uri,
) async {
  if (uri.scheme.toLowerCase() == 'mailto') {
    final to = Uri.decodeComponent(uri.path);
    await openCompose(
      context,
      mailbox: mailbox,
      seed: ComposeSeed(
        to: to.isEmpty ? const [] : to.split(','),
        subject: uri.queryParameters['subject'] ?? '',
        body: uri.queryParameters['body'] ?? '',
      ),
    );
    return;
  }
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    opened = false;
  }
  if (!opened && context.mounted) {
    showToast(context, tr(context, 'message.linkFailed'));
  }
}
