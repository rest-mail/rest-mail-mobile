import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/common.dart';

/// How far a contact is trusted, in the current language.
String trustLevelLabel(BuildContext context, TrustLevel level) =>
    tr(context, switch (level) {
      TrustLevel.trusted => 'contacts.trusted',
      TrustLevel.auto => 'contacts.auto',
      TrustLevel.blocked => 'contacts.blocked',
    });

/// What a trust level does to the contact's mail.
String trustLevelHelp(BuildContext context, TrustLevel level) =>
    tr(context, switch (level) {
      TrustLevel.trusted => 'contacts.trustedHelp',
      TrustLevel.auto => 'contacts.autoHelp',
      TrustLevel.blocked => 'contacts.blockedHelp',
    });

/// The account's contacts: who its filters trust and who they refuse,
/// searched by address, and added, changed or deleted. REST Mail only.
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({
    super.key,
    required this.mailbox,
    required this.accountId,
  });

  final MailboxState mailbox;
  final int accountId;

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _search = TextEditingController();
  final _items = <Contact>[];
  TrustLevel? _filter;
  int _total = 0;
  bool _loaded = false;
  bool _loadingMore = false;
  Object? _error;
  Timer? _debounce;

  /// Each load's number: an answer to an older one is dropped.
  int _generation = 0;

  MailboxState get _mailbox => widget.mailbox;
  String get _host => _mailbox.backend.host;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final generation = ++_generation;
    try {
      final page = await _mailbox.backend.contacts(
        widget.accountId,
        search: _search.text.trim(),
        trustLevel: _filter,
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.items);
        _total = page.total;
        _loaded = true;
        _error = null;
      });
    } on ApiException catch (e) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _error = e;
        _loaded = true;
      });
    }
  }

  Future<void> _more() async {
    if (_loadingMore) return;
    final generation = _generation;
    setState(() => _loadingMore = true);
    try {
      final page = await _mailbox.backend.contacts(
        widget.accountId,
        search: _search.text.trim(),
        trustLevel: _filter,
        offset: _items.length,
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        final known = {for (final c in _items) c.id};
        _items.addAll(page.items.where((c) => !known.contains(c.id)));
        _total = page.total;
      });
    } on ApiException catch (e) {
      if (mounted) showToast(context, describeError(context, e, host: _host));
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _searchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => unawaited(_load()),
    );
  }

  void _filterBy(TrustLevel? level) {
    setState(() => _filter = level);
    unawaited(_load());
  }

  Future<void> _open([Contact? contact]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ContactScreen(
          mailbox: _mailbox,
          accountId: widget.accountId,
          contact: contact,
        ),
      ),
    );
    if (changed == true && mounted) unawaited(_load());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'mailboxes.contacts'),
              onBack: () => Navigator.pop(context),
              trailingText: tr(context, 'contacts.add'),
              onTrailing: () => unawaited(_open()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _search,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.search,
                    onChanged: _searchChanged,
                    style: rmText(15, color: c.ink),
                    decoration: InputDecoration(
                      hintText: tr(context, 'contacts.search'),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: c.ink3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RmSegmented<TrustLevel?>(
                    options: [
                      (null, tr(context, 'contacts.all')),
                      for (final level in const [
                        TrustLevel.trusted,
                        TrustLevel.auto,
                        TrustLevel.blocked,
                      ])
                        (level, trustLevelLabel(context, level)),
                    ],
                    value: _filter,
                    onChanged: _filterBy,
                  ),
                ],
              ),
            ),
            Expanded(child: _body(context)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final c = context.rm;
    if (!_loaded) {
      return Center(
        child: SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
        ),
      );
    }
    if (_error case final error?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                describeError(context, error, host: _host),
                textAlign: TextAlign.center,
                style: rmText(14, color: c.ink2, height: 1.4),
              ),
              const SizedBox(height: 14),
              RmOutlineButton(
                label: tr(context, 'contacts.retry'),
                height: 44,
                onPressed: () => unawaited(_load()),
              ),
            ],
          ),
        ),
      );
    }
    final filtered = _filter != null || _search.text.trim().isNotEmpty;
    if (_items.isEmpty) {
      return RefreshIndicator(
        color: c.accent,
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 100),
            Icon(Icons.contacts_outlined, size: 34, color: c.ink3),
            const SizedBox(height: 12),
            Text(
              tr(context, filtered ? 'contacts.noMatch' : 'contacts.empty'),
              textAlign: TextAlign.center,
              style: rmText(14.5, color: c.ink2, weight: FontWeight.w600),
            ),
            if (!filtered) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  tr(context, 'contacts.emptyNote'),
                  textAlign: TextAlign.center,
                  style: rmText(12.5, color: c.ink3, height: 1.4),
                ),
              ),
            ],
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: c.accent,
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        children: [
          SectionLabel(
            _total == 1
                ? tr(context, 'contacts.countOne')
                : trArgs(context, 'contacts.count', {
                    'count': countLabel(_total),
                  }),
          ),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              for (final contact in _items)
                RmRow(
                  label: contact.name.trim().isEmpty
                      ? contact.email
                      : contact.name,
                  subtitle: contact.name.trim().isEmpty
                      ? trustLevelLabel(context, contact.trustLevel)
                      : '${contact.email} · '
                            '${trustLevelLabel(context, contact.trustLevel)}',
                  danger: contact.trustLevel == TrustLevel.blocked,
                  onTap: () => unawaited(_open(contact)),
                ),
            ],
          ),
          if (_items.length < _total) ...[
            const SizedBox(height: 14),
            RmOutlineButton(
              label: tr(
                context,
                _loadingMore ? 'contacts.loading' : 'contacts.more',
              ),
              height: 44,
              onPressed: _loadingMore ? null : () => unawaited(_more()),
            ),
          ],
        ],
      ),
    );
  }
}

/// One contact, or a new one when [contact] is null: its address, name and
/// trust level, and a way to delete it. Pops `true` once anything changed.
class ContactScreen extends StatefulWidget {
  const ContactScreen({
    super.key,
    required this.mailbox,
    required this.accountId,
    this.contact,
  });

  final MailboxState mailbox;
  final int accountId;
  final Contact? contact;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late final _email = TextEditingController();
  late final _name = TextEditingController(text: widget.contact?.name ?? '');
  late TrustLevel _trust = widget.contact?.trustLevel ?? TrustLevel.trusted;
  bool _busy = false;
  String? _error;

  bool get _creating => widget.contact == null;
  MailboxState get _mailbox => widget.mailbox;

  bool get _ready => !_busy && (!_creating || _email.text.trim().isNotEmpty);

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_ready) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final backend = _mailbox.backend;
    try {
      if (widget.contact case final contact?) {
        await backend.updateContact(
          widget.accountId,
          contact.id,
          name: _name.text.trim(),
          trustLevel: _trust,
        );
      } else {
        await backend.createContact(
          widget.accountId,
          email: _email.text.trim(),
          name: _name.text.trim(),
          trustLevel: _trust,
        );
      }
      if (!mounted) return;
      showToast(context, tr(context, 'contacts.saved'));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(code: 'already_exists') => tr(
            context,
            'contacts.exists',
          ),
          ApiException(statusCode: 422) when e.fields.containsKey('email') =>
            tr(context, 'contacts.badAddress'),
          _ => describeError(context, e, host: backend.host),
        };
      });
    }
  }

  Future<void> _delete() async {
    final contact = widget.contact;
    if (contact == null || _busy) return;
    final sure = await confirmAction(
      context,
      title: tr(context, 'contacts.deleteTitle'),
      message: tr(context, 'contacts.deleteBody'),
      action: tr(context, 'contacts.deleteAction'),
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await _mailbox.backend.deleteContact(widget.accountId, contact.id);
      if (!mounted) return;
      showToast(context, tr(context, 'contacts.deleted'));
      Navigator.pop(context, true);
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
    final contact = widget.contact, error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, _creating ? 'contacts.new' : 'contacts.edit'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  SectionLabel(tr(context, 'contacts.address')),
                  const SizedBox(height: 8),
                  if (contact == null)
                    TextField(
                      controller: _email,
                      autofocus: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() => _error = null),
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'name@example.com',
                      ),
                    )
                  else
                    SelectableText(
                      contact.email,
                      style: rmText(16, color: c.ink, weight: FontWeight.w600),
                    ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'contacts.name')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    maxLength: 255,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() => _error = null),
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(
                      hintText: tr(context, 'contacts.nameHint'),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'contacts.trust')),
                  const SizedBox(height: 8),
                  RmGroup(
                    children: [
                      for (final level in const [
                        TrustLevel.trusted,
                        TrustLevel.auto,
                        TrustLevel.blocked,
                      ])
                        Semantics(
                          selected: level == _trust,
                          child: RmRow(
                            label: trustLevelLabel(context, level),
                            subtitle: trustLevelHelp(context, level),
                            trailing: level == _trust
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 20,
                                    color: c.accent,
                                  )
                                : const SizedBox(width: 20),
                            onTap: _busy
                                ? null
                                : () => setState(() => _trust = level),
                          ),
                        ),
                    ],
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: tr(context, 'contacts.save'),
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_save()) : null,
                  ),
                  if (contact != null) ...[
                    const SizedBox(height: 12),
                    RmOutlineButton(
                      label: tr(context, 'contacts.delete'),
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
