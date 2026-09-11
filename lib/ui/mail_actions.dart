import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/mailbox_state.dart';
import '../util/compose_seed.dart';
import 'compose_sheet.dart';
import 'widgets/common.dart';

/// Runs [action], which takes [message] out of the folder on screen, then
/// says so with an Undo that puts it back where it was.
Future<void> removeWithUndo({
  required ScaffoldMessengerState messenger,
  required MailboxState mailbox,
  required Message message,
  required Future<void> Function() action,
  required String done,
  bool undoable = true,
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
                  label: 'Undo',
                  onPressed: () =>
                      unawaited(_undo(messenger, mailbox, message)),
                )
              : null,
        ),
      );
  } on ApiException catch (e) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(describeError(e))));
  }
}

Future<void> _undo(
  ScaffoldMessengerState messenger,
  MailboxState mailbox,
  Message message,
) async {
  try {
    await mailbox.undoRemoval(message);
  } on ApiException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
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
      title: 'Delete forever?',
      message: 'It is already in Trash, so this cannot be undone.',
      action: 'Delete',
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
    showToast(context, "Couldn't open that link.");
  }
}
