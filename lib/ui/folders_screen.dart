import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/common.dart';

/// Whether [folder] is the account's own, to rename and delete: not one of
/// the standard folders, nor a Gmail label.
bool isOwnFolder(Folder folder) =>
    !folder.isLabel && !StandardFolder.ordered.contains(folder.name);

/// The account's folders: its own, made, renamed and deleted here, and the
/// standard ones, which stay as they are. REST Mail only.
class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  MailboxState get _mailbox => widget.mailbox;

  @override
  void initState() {
    super.initState();
    unawaited(_mailbox.refreshFolders());
  }

  Future<void> _open([Folder? folder]) => Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (_) => FolderScreen(mailbox: _mailbox, folder: folder),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'mailboxes.folders'),
              onBack: () => Navigator.pop(context),
              trailingText: tr(context, 'folders.new'),
              onTrailing: () => unawaited(_open()),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _mailbox,
                builder: (context, _) {
                  final folders = _mailbox.folders;
                  final own = folders.where(isOwnFolder).toList();
                  final standard = folders
                      .where((f) => !isOwnFolder(f))
                      .toList();
                  return RefreshIndicator(
                    color: c.accent,
                    onRefresh: _mailbox.refreshFolders,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                      children: [
                        SectionLabel(tr(context, 'folders.yours')),
                        const SizedBox(height: 9),
                        if (own.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: c.surface,
                              border: Border.all(color: c.line),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              tr(context, 'folders.none'),
                              style: rmText(12.5, color: c.ink3),
                            ),
                          )
                        else
                          RmGroup(
                            children: [
                              for (final folder in own)
                                RmRow(
                                  label: folder.name,
                                  value: countLabel(folder.total),
                                  onTap: () => unawaited(_open(folder)),
                                ),
                            ],
                          ),
                        const SizedBox(height: 22),
                        SectionLabel(tr(context, 'folders.standard')),
                        const SizedBox(height: 9),
                        RmGroup(
                          children: [
                            for (final folder in standard)
                              RmRow(
                                label: folderLabelOf(context, folder.name),
                                value: countLabel(folder.total),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(context, 'folders.standardNote'),
                          style: rmText(12.5, color: c.ink3, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the account's own folders, to rename or delete, or a new one when
/// [folder] is null.
class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key, required this.mailbox, this.folder});

  final MailboxState mailbox;
  final Folder? folder;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  late final _name = TextEditingController(text: widget.folder?.name ?? '');
  bool _busy = false;
  String? _error;

  MailboxState get _mailbox => widget.mailbox;

  bool get _ready {
    final name = _name.text.trim();
    return !_busy && name.isNotEmpty && name != widget.folder?.name;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_ready) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final name = _name.text.trim();
    try {
      if (widget.folder case final folder?) {
        await _mailbox.renameFolder(folder.name, name);
      } else {
        await _mailbox.createFolder(name);
      }
      if (!mounted) return;
      showToast(
        context,
        tr(
          context,
          widget.folder == null ? 'folders.created' : 'folders.renamed',
        ),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(code: 'already_exists') => tr(context, 'folders.exists'),
          ApiException(statusCode: 400, code: 'bad_request') => tr(
            context,
            'folders.reserved',
          ),
          ApiException(statusCode: 422) when e.fields.containsKey('name') => tr(
            context,
            'folders.badName',
          ),
          _ => describeError(context, e, host: _mailbox.backend.host),
        };
      });
    }
  }

  Future<void> _delete() async {
    final folder = widget.folder;
    if (folder == null || _busy) return;
    final sure = await confirmAction(
      context,
      title: trArgs(context, 'folders.deleteTitle', {'name': folder.name}),
      message: tr(context, 'folders.deleteBody'),
      action: tr(context, 'folders.deleteAction'),
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await _mailbox.deleteFolder(folder.name);
      if (!mounted) return;
      showToast(context, tr(context, 'folders.deleted'));
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(
        context,
        describeError(context, e, host: _mailbox.backend.host),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final folder = widget.folder, error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(
                context,
                folder == null ? 'folders.newTitle' : 'folders.editTitle',
              ),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  SectionLabel(tr(context, 'folders.name')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    autofocus: folder == null,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) => unawaited(_save()),
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(
                      hintText: tr(context, 'folders.nameHint'),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: tr(context, 'folders.save'),
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_save()) : null,
                  ),
                  if (folder != null) ...[
                    const SizedBox(height: 12),
                    RmOutlineButton(
                      label: tr(context, 'folders.delete'),
                      color: c.danger,
                      onPressed: _busy ? null : () => unawaited(_delete()),
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
