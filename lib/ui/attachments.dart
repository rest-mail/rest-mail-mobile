import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/common.dart';
import 'widgets/painters.dart';

/// Downloads an attachment into the app's temporary folder and hands it to
/// the system share sheet, which offers to open, save or send it.
Future<void> openAttachment(
  BuildContext context,
  RestmailClient client,
  Attachment attachment,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final box = context.findRenderObject();
  // iPad anchors the share sheet to the thing that was tapped.
  final origin = box is RenderBox && box.hasSize
      ? box.localToGlobal(Offset.zero) & box.size
      : null;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('Opening ${attachment.filename}…'),
        duration: const Duration(seconds: 30),
      ),
    );
  try {
    final bytes = await client.downloadAttachment(attachment.id);
    final folder = Directory(
      '${(await getTemporaryDirectory()).path}/attachments/${attachment.id}',
    );
    await folder.create(recursive: true);
    final file = File('${folder.path}/${safeFileName(attachment.filename)}');
    await file.writeAsBytes(bytes, flush: true);
    messenger.hideCurrentSnackBar();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: attachment.contentType)],
        sharePositionOrigin: origin,
      ),
    );
  } on ApiException catch (e) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(describeError(e))));
  } on FileSystemException {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Could not save the file to open it.')),
      );
  }
}

/// A sender's filename, made safe to write: no path separators or control
/// characters, and never empty, `.` or `..`.
String safeFileName(String name) {
  final cleaned = name.replaceAll(RegExp(r'[/\\:\x00-\x1f]'), '_').trim();
  return cleaned.isEmpty || cleaned == '.' || cleaned == '..'
      ? 'attachment'
      : cleaned;
}

/// Under a message: a card for its one attachment, or one card leading to
/// all of them.
class AttachmentSummary extends StatelessWidget {
  const AttachmentSummary({
    super.key,
    required this.client,
    required this.attachments,
  });

  final RestmailClient client;
  final List<Attachment> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.length == 1) {
      final attachment = attachments.single;
      return _AttachmentCard(
        title: attachment.filename,
        meta:
            '${kindLabel(attachment.contentType)} · ${sizeLabel(attachment.sizeBytes)}',
        onTap: (context) => openAttachment(context, client, attachment),
      );
    }
    return _AttachmentCard(
      title: '${attachments.length} attachments',
      meta: attachments.map((a) => a.filename).join(', '),
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) =>
              AttachmentsScreen(client: client, attachments: attachments),
        ),
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    required this.title,
    required this.meta,
    required this.onTap,
  });

  final String title;
  final String meta;
  final Future<void> Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: BorderSide(color: c.line),
      ),
      child: InkWell(
        onTap: () => unawaited(onTap(context)),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 44,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: c.line),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Hatch(color: c.line),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(14, color: c.ink, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(12, color: c.ink3),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 18, color: c.ink3),
            ],
          ),
        ),
      ),
    );
  }
}

/// Every attachment on a message, as tiles.
class AttachmentsScreen extends StatelessWidget {
  const AttachmentsScreen({
    super.key,
    required this.client,
    required this.attachments,
  });

  final RestmailClient client;
  final List<Attachment> attachments;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          RmTopBar(title: 'Attachments', onBack: () => Navigator.pop(context)),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 164,
              ),
              itemCount: attachments.length,
              itemBuilder: (context, index) => _AttachmentTile(
                client: client,
                attachment: attachments[index],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({required this.client, required this.attachment});

  final RestmailClient client;
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: BorderSide(color: c.line),
      ),
      child: InkWell(
        onTap: () => unawaited(openAttachment(context, client, attachment)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 104,
              child: Hatch(
                color: c.line,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: c.bg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fileKind(attachment.filename),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: c.ink3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment.filename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: rmText(13, color: c.ink, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${kindLabel(attachment.contentType)} · ${sizeLabel(attachment.sizeBytes)}',
                    style: rmText(11.5, color: c.ink3),
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
