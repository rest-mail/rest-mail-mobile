import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'grant_text.dart';

/// What the screen shows: the grants, or what can be granted.
enum _Tab {
  grants('Grants'),
  roles('Roles'),
  capabilities('Capabilities');

  const _Tab(this.label);

  final String label;
}

/// Who holds which role, and where: the server's grants, the roles they
/// give and the capabilities those carry. Seeing them takes `users:read`;
/// granting and removing take `users:write`, a session signed in with a
/// second factor, and holding the role at a scope at least as wide.
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final _scopeFilter = TextEditingController();
  late final _list = AdminList<Grant>(
    (offset) => widget.account.client.grants(
      offset: offset,
      scope: _scopeFilter.text.trim().isEmpty ? null : _scopeFilter.text.trim(),
    ),
  );
  var _tab = _Tab.grants;

  /// Account addresses by id, when the session may read mailboxes.
  Map<int, String> _addresses = const {};
  Future<(List<AdminRole>, List<CapabilityDefinition>)>? _catalog;

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    final access = AdminAccess(widget.account.capabilities);
    if (access.canRead(AdminSection.permissions)) {
      unawaited(_list.reload());
    }
    if (access.canRead(AdminSection.mailboxes)) unawaited(_loadAddresses());
  }

  @override
  void dispose() {
    _list.dispose();
    _scopeFilter.dispose();
    super.dispose();
  }

  Future<(List<AdminRole>, List<CapabilityDefinition>)> _loadCatalog() async {
    final client = widget.account.client;
    return (await client.roles(), await client.capabilityDefinitions());
  }

  Future<void> _loadAddresses() async {
    try {
      final page = await widget.account.client.mailboxes(limit: 200);
      if (!mounted) return;
      setState(
        () => _addresses = {for (final m in page.items) m.id: m.address},
      );
    } on ApiException {
      // The rows fall back to the account's id.
    }
  }

  String _holder(GrantHolder holder) =>
      _addresses[holder.id] ?? 'Account #${holder.id}';

  Future<void> _add() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _GrantForm(account: widget.account, addresses: _addresses),
      ),
    );
    if (added ?? false) unawaited(_list.reload());
  }

  Future<void> _remove(Grant grant) async {
    final sure = await confirmAction(
      context,
      title: 'Remove ${grant.role} from ${_holder(grant.holder)}?',
      message:
          '${scopeLabel(grant.scope)}. They lose what it gives at once, '
          'in every session.',
      action: 'Remove',
    );
    if (!sure || !mounted) return;
    try {
      await widget.account.client.deleteGrant(grant.id);
    } on ApiException catch (e) {
      if (mounted) showToast(context, describeGrantError(e, host: _host));
      return;
    }
    if (!mounted) return;
    showToast(context, 'Removed ${grant.role} from ${_holder(grant.holder)}');
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.permissions,
    title: 'Permissions',
    body: (access) => Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RmSegmented<_Tab>(
              options: [for (final t in _Tab.values) (t, t.label)],
              value: _tab,
              onChanged: (tab) => setState(() {
                _tab = tab;
                if (tab != _Tab.grants) _catalog ??= _loadCatalog();
              }),
            ),
          ),
        ),
        Expanded(
          child: switch (_tab) {
            _Tab.grants => _grants(access),
            _Tab.roles => _CatalogView(
              catalog: _catalog,
              host: _host,
              roles: true,
              onRetry: () => setState(() => _catalog = _loadCatalog()),
            ),
            _Tab.capabilities => _CatalogView(
              catalog: _catalog,
              host: _host,
              roles: false,
              onRetry: () => setState(() => _catalog = _loadCatalog()),
            ),
          },
        ),
      ],
    ),
  );

  Widget _grants(AdminAccess access) {
    final c = context.rm;
    return AdminListView(
      list: _list,
      host: _host,
      empty: _scopeFilter.text.trim().isEmpty
          ? 'Nobody holds a role.'
          : 'Nobody holds a role at that scope.',
      header: [
        if (access.canWrite(AdminSection.permissions))
          AdminAddButton(label: 'Grant a role', onTap: () => unawaited(_add())),
        TextField(
          controller: _scopeFilter,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => unawaited(_list.reload()),
          style: rmText(15, color: c.ink),
          decoration: const InputDecoration(
            hintText: 'Only at a scope: *, domain:a.com, mailbox:x@a.com',
            prefixIcon: Icon(Icons.filter_list_rounded),
          ),
        ),
        const SizedBox(height: 14),
      ],
      row: (grant) => RmRow(
        label: '${grant.role} · ${scopeLabel(grant.scope)}',
        subtitle: [
          _holder(grant.holder),
          grantState(grant),
          grantEnds(grant),
          if (grant.grantedBy.id case final by?)
            'Granted by ${_holder(GrantHolder.account(by))}, '
                '${longDate(grant.grantedAt)}'
          else
            'Granted by the server, ${longDate(grant.grantedAt)}',
        ].join('\n'),
        trailing: access.canDelete(AdminSection.permissions)
            ? RmIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Remove ${grant.role} from ${_holder(grant.holder)}',
                color: c.ink3,
                onPressed: () => unawaited(_remove(grant)),
              )
            : null,
      ),
    );
  }
}

/// The roles, each with what it gives, or every capability by name.
class _CatalogView extends StatelessWidget {
  const _CatalogView({
    required this.catalog,
    required this.host,
    required this.roles,
    required this.onRetry,
  });

  final Future<(List<AdminRole>, List<CapabilityDefinition>)>? catalog;
  final String host;
  final bool roles;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<(List<AdminRole>, List<CapabilityDefinition>)>(
        future: catalog,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AdminMessage(
              describeAdminError(snapshot.error!, host: host),
              onRetry: onRetry,
            );
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final (roleList, definitions) = data;
          final described = {
            for (final d in definitions) d.name: d.description,
          };
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
            children: [
              if (roles)
                RmGroup(
                  children: [
                    for (final role in roleList)
                      RmRow(
                        label: role.systemRole
                            ? role.name
                            : '${role.name} (made here)',
                        subtitle: [
                          if (role.description.isNotEmpty) role.description,
                          for (final name in role.capabilities)
                            name == Capabilities.all
                                ? '* · everything'
                                : switch (described[name]) {
                                    final d? when d.isNotEmpty => '$name · $d',
                                    _ => name,
                                  },
                        ].join('\n'),
                      ),
                  ],
                )
              else
                RmGroup(
                  children: [
                    for (final d in definitions)
                      RmRow(
                        label: d.name,
                        subtitle: d.description.isEmpty ? null : d.description,
                      ),
                  ],
                ),
            ],
          );
        },
      );
}

/// Where a new grant applies.
enum _ScopeKind {
  everywhere('Everywhere'),
  domain('A domain'),
  mailbox('A mailbox');

  const _ScopeKind(this.label);

  final String label;
}

/// How long a new grant lasts.
enum _Lasts {
  ever('Until removed', null),
  day('A day', Duration(days: 1)),
  week('A week', Duration(days: 7)),
  month('30 days', Duration(days: 30)),
  date('Until a date', null);

  const _Lasts(this.label, this.duration);

  final String label;
  final Duration? duration;
}

class _GrantForm extends StatefulWidget {
  const _GrantForm({required this.account, required this.addresses});

  final RestAccount account;
  final Map<int, String> addresses;

  @override
  State<_GrantForm> createState() => _GrantFormState();
}

class _GrantFormState extends State<_GrantForm> {
  final _accountId = TextEditingController();
  final _scopeName = TextEditingController();
  late final Future<List<AdminRole>> _roles = widget.account.client.roles();
  int? _holder;
  String? _role;
  var _scope = _ScopeKind.everywhere;
  var _mode = GrantMode.active;
  var _lasts = _Lasts.ever;
  DateTime? _until;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _accountId.dispose();
    _scopeName.dispose();
    super.dispose();
  }

  int? get _holderId =>
      widget.addresses.isEmpty ? int.tryParse(_accountId.text.trim()) : _holder;

  String get _scopeValue => switch (_scope) {
    _ScopeKind.everywhere => '*',
    _ScopeKind.domain => 'domain:${_scopeName.text.trim().toLowerCase()}',
    _ScopeKind.mailbox => 'mailbox:${_scopeName.text.trim().toLowerCase()}',
  };

  /// What is wrong with the form before it is sent, or null.
  String? get _problem {
    final id = _holderId;
    if (id == null || id <= 0) return 'Choose the account to grant to.';
    if (_role == null) return 'Choose a role.';
    final name = _scopeName.text.trim();
    if (_scope == _ScopeKind.domain &&
        (!name.contains('.') || name.contains('@'))) {
      return 'Enter a domain name, like example.com.';
    }
    if (_scope == _ScopeKind.mailbox &&
        !RegExp(r'^[^@\s]+@[^@\s]+$').hasMatch(name)) {
      return 'Enter a mailbox address, like dana@example.com.';
    }
    if (_lasts == _Lasts.date && _until == null) return 'Pick the end date.';
    return null;
  }

  DateTime? get _expiresAt => switch (_lasts) {
    _Lasts.ever => null,
    _Lasts.date => _until,
    final l => DateTime.now().add(l.duration!),
  };

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _until ?? now.add(const Duration(days: 7)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (picked != null && mounted) {
      setState(() {
        // The end of the day picked, so it lasts through it.
        _until = DateTime(picked.year, picked.month, picked.day, 23, 59);
        _error = null;
      });
    }
  }

  Future<void> _send() async {
    final problem = _problem;
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.account.client.createGrant(
        holder: GrantHolder.account(_holderId!),
        role: _role!,
        scope: _scopeValue,
        mode: _mode,
        expiresAt: _expiresAt,
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = describeGrantError(e, host: widget.account.server.host);
      });
    }
  }

  void _changed() => setState(() => _error = null);

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error, until = _until;
    final addresses = widget.addresses.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Grant a role',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    'You can grant only a role you hold, at a scope at least '
                    'as wide. The change needs a session signed in with a '
                    'two-factor code.',
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  const SectionLabel('Account'),
                  const SizedBox(height: 8),
                  if (addresses.isEmpty)
                    TextField(
                      controller: _accountId,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _changed(),
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'Account number',
                      ),
                    )
                  else
                    DropdownButtonFormField<int>(
                      initialValue: _holder,
                      isExpanded: true,
                      hint: const Text('Choose an account'),
                      items: [
                        for (final entry in addresses)
                          DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                      ],
                      onChanged: (id) => setState(() {
                        _holder = id;
                        _error = null;
                      }),
                    ),
                  const SizedBox(height: 18),
                  const SectionLabel('Role'),
                  const SizedBox(height: 8),
                  FutureBuilder<List<AdminRole>>(
                    future: _roles,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return ErrorText(
                          describeAdminError(
                            snapshot.error!,
                            host: widget.account.server.host,
                          ),
                        );
                      }
                      final roles = snapshot.data;
                      if (roles == null) {
                        return const LinearProgressIndicator();
                      }
                      final chosen = roles
                          .where((r) => r.name == _role)
                          .firstOrNull;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _role,
                            isExpanded: true,
                            hint: const Text('Choose a role'),
                            items: [
                              for (final role in roles)
                                DropdownMenuItem(
                                  value: role.name,
                                  child: Text(role.name),
                                ),
                            ],
                            onChanged: (name) => setState(() {
                              _role = name;
                              _error = null;
                            }),
                          ),
                          if (chosen != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              [
                                if (chosen.description.isNotEmpty)
                                  chosen.description,
                                'Gives ${chosen.capabilities.join(', ')}',
                              ].join('. '),
                              style: rmText(13, color: c.ink3, height: 1.4),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  const SectionLabel('Where'),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RmSegmented<_ScopeKind>(
                      options: [
                        for (final s in _ScopeKind.values) (s, s.label),
                      ],
                      value: _scope,
                      onChanged: (scope) => setState(() {
                        _scope = scope;
                        _error = null;
                      }),
                    ),
                  ),
                  if (_scope != _ScopeKind.everywhere) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _scopeName,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: _scope == _ScopeKind.mailbox
                          ? TextInputType.emailAddress
                          : TextInputType.url,
                      onChanged: (_) => _changed(),
                      style: rmText(16, color: c.ink),
                      decoration: InputDecoration(
                        hintText: _scope == _ScopeKind.domain
                            ? 'example.com'
                            : 'dana@example.com',
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const SectionLabel('Mode'),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RmSegmented<GrantMode>(
                      options: const [
                        (GrantMode.active, 'Active'),
                        (GrantMode.eligible, 'Eligible'),
                      ],
                      value: _mode,
                      onChanged: (mode) => setState(() => _mode = mode),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _mode == GrantMode.active
                        ? 'It applies all the time.'
                        : 'It gives nothing until they switch it on for a '
                              'while, with a reason and a fresh code.',
                    style: rmText(13, color: c.ink3, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  const SectionLabel('For'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final l in _Lasts.values)
                        ChoiceChip(
                          label: Text(l.label),
                          selected: _lasts == l,
                          onSelected: (_) {
                            setState(() {
                              _lasts = l;
                              _error = null;
                            });
                            if (l == _Lasts.date) unawaited(_pickDate());
                          },
                        ),
                    ],
                  ),
                  if (_lasts == _Lasts.date && until != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Ends ${longDate(until)}',
                      style: rmText(13, color: c.ink3),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: 'Grant',
                    busy: _busy,
                    onPressed: _busy ? null : () => unawaited(_send()),
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
