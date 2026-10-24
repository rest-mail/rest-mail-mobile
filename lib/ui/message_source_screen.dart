import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/voice.dart';
import '../state/mail_backend.dart';
import '../theme/tokens.dart';
import 'attachments.dart';
import 'widgets/common.dart';

/// A message's source as it arrived, headers and all, to read, select and
/// share as an .eml file.
class MessageSourceScreen extends StatefulWidget {
  const MessageSourceScreen({
    super.key,
    required this.backend,
    required this.message,
  });

  final MailBackend backend;
  final Message message;

  @override
  State<MessageSourceScreen> createState() => _MessageSourceScreenState();
}

class _MessageSourceScreenState extends State<MessageSourceScreen> {
  Uint8List? _bytes;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final bytes = await widget.backend.messageSource(widget.message.id);
      if (mounted) setState(() => _bytes = bytes);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  /// Writes the source to the app's temporary folder and hands it to the
  /// system share sheet, which offers to save or send it.
  Future<void> _share(Uint8List bytes) async {
    final box = context.findRenderObject();
    final origin = box is RenderBox && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    try {
      final folder = Directory(
        '${(await getTemporaryDirectory()).path}/source/${widget.message.id}',
      );
      await folder.create(recursive: true);
      final subject = widget.message.subject.trim();
      final file = File(
        '${folder.path}/${safeFileName(subject.isEmpty ? 'message' : subject)}.eml',
      );
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'message/rfc822')],
          sharePositionOrigin: origin,
        ),
      );
    } on FileSystemException {
      if (mounted) showToast(context, tr(context, 'attachments.saveFailed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final bytes = _bytes, error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'source.title'),
              onBack: () => Navigator.pop(context),
              trailingText: bytes == null ? null : tr(context, 'source.share'),
              onTrailing: bytes == null ? null : () => unawaited(_share(bytes)),
            ),
            Expanded(
              child: switch ((bytes, error)) {
                (_, final ApiException e) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.statusCode == 404 && e.code == 'not_found'
                              ? tr(context, 'source.unavailable')
                              : describeError(
                                  context,
                                  e,
                                  host: widget.backend.host,
                                ),
                          textAlign: TextAlign.center,
                          style: rmText(14, color: c.ink2, height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        RmOutlineButton(
                          label: tr(context, 'source.retry'),
                          height: 44,
                          onPressed: () => unawaited(_load()),
                        ),
                      ],
                    ),
                  ),
                ),
                (final Uint8List source, _) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                  child: SelectableText(
                    utf8.decode(source, allowMalformed: true),
                    style: rmText(
                      12.5,
                      color: c.ink,
                      height: 1.45,
                      family: 'monospace',
                    ),
                  ),
                ),
                _ => Center(
                  child: SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: c.accent,
                    ),
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
