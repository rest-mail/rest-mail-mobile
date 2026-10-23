import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../util/secret_clipboard.dart';
import 'add_account_screen.dart';
import 'admin/admin_widgets.dart' show AdminMessage;
import 'widgets/common.dart';

String _date(DateTime value) =>
    DateFormat.yMMMd().add_Hm().format(value.toLocal());

RestAccount _currentSession(BuildContext context, RestAccount original) =>
    AppScope.read(context).accounts.whereType<RestAccount>().firstWhere(
      (account) => account.key == original.key,
      orElse: () => original,
    );

String _keyError(ApiException error, String host) {
  if (error.fields.isNotEmpty) {
    return error.fields.entries
        .map((field) => '${field.key.replaceAll('_', ' ')}: ${field.value}')
        .join('\n');
  }
  return switch (error.code) {
    _ when error.statusCode == 404 =>
      'API keys are not available for this mailbox on this server.',
    'two_factor_required' =>
      'Enable two-factor authentication, then sign in with a code to create '
          'or revoke API keys.',
    'reauth_required' || 'invalid_password' =>
      'Enter the current password of the account you signed in with.',
    'forbidden' =>
      'These permissions exceed what you or this mailbox currently hold.',
    'session_required' => 'Sign in with your password and a second factor.',
    _ => describeError(error, host: host),
  };
}

Future<void> _signInAgain(BuildContext context, RestAccount account) =>
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddAccountScreen(server: account.server, email: account.address),
      ),
    );

/// Account credentials for automation, with explicit capabilities and scopes.
class APIKeysScreen extends StatefulWidget {
  const APIKeysScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final Account mailbox;

  @override
  State<APIKeysScreen> createState() => _APIKeysScreenState();
}

class _APIKeysScreenState extends State<APIKeysScreen> {
  List<APIKey>? _items;
  ApiException? _error;
  var _loading = true;
  final _revoking = <int>{};

  RestAccount get _account => _currentSession(context, widget.account);

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _account.client.apiKeys(widget.mailbox.id);
      if (mounted) setState(() => _items = items);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateAPIKeyScreen(account: _account, mailbox: widget.mailbox),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _revoke(APIKey key) async {
    final sure = await confirmAction(
      context,
      title: 'Revoke “${key.name}”?',
      message: 'Requests using this key will be refused immediately.',
      action: 'Revoke',
    );
    if (!sure || !mounted) return;
    setState(() => _revoking.add(key.id));
    try {
      await _account.client.revokeAPIKey(widget.mailbox.id, key.id);
      if (!mounted) return;
      setState(() => _items = [...?_items]..remove(key));
      showToast(context, 'Revoked “${key.name}”');
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 404) {
        await _load();
      } else {
        setState(() => _error = error);
      }
    } finally {
      if (mounted) setState(() => _revoking.remove(key.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final items = _items;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(title: 'API keys', onBack: () => Navigator.pop(context)),
            Expanded(
              child: _loading && items == null
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                        children: [
                          Text(
                            'Give an automation named permissions on specific '
                            'domains or mailboxes. A key can never do more '
                            'than its owner currently may.',
                            style: rmText(14, color: c.ink2, height: 1.45),
                          ),
                          const SizedBox(height: 18),
                          RmPrimaryButton(
                            label: 'Create an API key',
                            onPressed: () => unawaited(_create()),
                          ),
                          if (error != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _keyError(error, _account.host),
                              style: rmText(14, color: c.danger),
                            ),
                            if (error.code == 'two_factor_required')
                              TextButton(
                                onPressed: () =>
                                    unawaited(_signInAgain(context, _account)),
                                child: const Text('Sign in with a code'),
                              )
                            else
                              TextButton(
                                onPressed: () => unawaited(_load()),
                                child: const Text('Try again'),
                              ),
                          ],
                          const SizedBox(height: 22),
                          SectionLabel(widget.mailbox.address),
                          const SizedBox(height: 9),
                          if (items != null && items.isEmpty)
                            Text(
                              'No API keys yet.',
                              style: rmText(14, color: c.ink3),
                            ),
                          if (items != null && items.isNotEmpty)
                            RmGroup(
                              children: [
                                for (final key in items)
                                  RmRow(
                                    label: key.name,
                                    subtitle: [
                                      'ID ${key.publicId}',
                                      'Created ${_date(key.createdAt)}',
                                      key.lastUsedAt == null
                                          ? 'Never used'
                                          : 'Last used ${_date(key.lastUsedAt!)}',
                                      key.expiresAt == null
                                          ? 'No expiry'
                                          : '${key.isExpiredAt(DateTime.now()) ? 'Expired' : 'Expires'} ${_date(key.expiresAt!)}',
                                      for (final permission in key.permissions)
                                        '${permission.capability} · ${permission.scope}',
                                    ].join('\n'),
                                    trailing: TextButton(
                                      onPressed: _revoking.contains(key.id)
                                          ? null
                                          : () => unawaited(_revoke(key)),
                                      child: const Text('Revoke'),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

const _capabilities = [
  'mail:read',
  'mail:write',
  'mail:send',
  'mailbox:manage',
  Capability.domainsRead,
  Capability.domainsWrite,
  Capability.domainsDelete,
  Capability.mailboxesRead,
  Capability.mailboxesWrite,
  Capability.mailboxesDelete,
  Capability.usersRead,
  Capability.usersWrite,
  Capability.usersDelete,
  Capability.pipelinesRead,
  Capability.pipelinesWrite,
  Capability.pipelinesDelete,
  Capability.queueRead,
  Capability.queueManage,
  Capability.bansRead,
  Capability.bansWrite,
  Capability.bansDelete,
  Capability.messagesRead,
  Capability.observabilityRead,
  Capability.auditRead,
];

enum _Scope {
  mailbox('A mailbox', 'mailbox:'),
  domain('A domain', 'domain:'),
  all('Everywhere', '');

  const _Scope(this.label, this.prefix);
  final String label;
  final String prefix;
}

class _PermissionInput {
  _PermissionInput(String address)
    : target = TextEditingController(text: address);

  String capability = 'mail:read';
  _Scope scope = _Scope.mailbox;
  final TextEditingController target;

  APIKeyPermission get permission => APIKeyPermission(
    capability: capability,
    scope: scope == _Scope.all
        ? '*'
        : '${scope.prefix}${target.text.trim().toLowerCase()}',
  );
}

class CreateAPIKeyScreen extends StatefulWidget {
  const CreateAPIKeyScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final Account mailbox;

  @override
  State<CreateAPIKeyScreen> createState() => _CreateAPIKeyScreenState();
}

class _CreateAPIKeyScreenState extends State<CreateAPIKeyScreen> {
  final _name = TextEditingController();
  final _password = TextEditingController();
  late final _permissions = [_PermissionInput(widget.mailbox.address)];
  int _days = 90;
  DateTime? _customExpiry;
  var _busy = false;
  ApiException? _error;

  bool get _ready =>
      !_busy &&
      _name.text.trim().isNotEmpty &&
      _password.text.isNotEmpty &&
      (_days != 0 || _customExpiry != null) &&
      _permissions.every(
        (item) =>
            item.scope == _Scope.all || item.target.text.trim().isNotEmpty,
      );

  @override
  void dispose() {
    _name.dispose();
    _password.clear();
    _password.dispose();
    for (final permission in _permissions) {
      permission.target.dispose();
    }
    super.dispose();
  }

  Future<void> _expiry(int days) async {
    setState(() {
      _days = days;
      _error = null;
    });
    if (days != 0) return;
    final now = DateTime.now();
    final day = await showDatePicker(
      context: context,
      initialDate: _customExpiry ?? now.add(const Duration(days: 90)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_customExpiry ?? now),
    );
    if (time == null || !mounted) return;
    final expiry = DateTime(
      day.year,
      day.month,
      day.day,
      time.hour,
      time.minute,
    );
    setState(
      () => _customExpiry = expiry.isAfter(DateTime.now()) ? expiry : null,
    );
  }

  Future<void> _create() async {
    if (!_ready) return;
    final password = _password.text;
    _password.clear();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final account = _currentSession(context, widget.account);
      final created = await account.client.createAPIKey(
        widget.mailbox.id,
        name: _name.text.trim(),
        password: password,
        permissions: [for (final item in _permissions) item.permission],
        expiresAt: _days == 0
            ? _customExpiry
            : _days == 90
            ? null
            : DateTime.now().add(Duration(days: _days)),
      );
      TextInput.finishAutofillContext(shouldSave: false);
      if (!mounted) return;
      final secret = _NewSecret(created.token);
      final keyInfo = created.key;
      unawaited(
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute(
            builder: (_) => _CreatedKeyScreen(keyInfo: keyInfo, secret: secret),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'New API key',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  TextField(
                    controller: _name,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Mailbox provisioning',
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Permissions',
                    style: rmText(16, color: c.ink, weight: FontWeight.w700),
                  ),
                  Text(
                    'Each capability applies only at the scope you choose. Your current '
                    'grants must cover every permission.',
                    style: rmText(13, color: c.ink3),
                  ),
                  for (var i = 0; i < _permissions.length; i++) _permission(i),
                  TextButton.icon(
                    onPressed: _busy || _permissions.length >= 64
                        ? null
                        : () => setState(
                            () => _permissions.add(
                              _PermissionInput(widget.mailbox.address),
                            ),
                          ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add permission'),
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    initialValue: _days,
                    decoration: const InputDecoration(labelText: 'Expires'),
                    items: const [
                      DropdownMenuItem(value: 30, child: Text('In 30 days')),
                      DropdownMenuItem(value: 90, child: Text('In 90 days')),
                      DropdownMenuItem(value: 365, child: Text('In a year')),
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Choose date and time'),
                      ),
                    ],
                    onChanged: _busy
                        ? null
                        : (value) {
                            if (value != null) unawaited(_expiry(value));
                          },
                  ),
                  if (_days == 0)
                    TextButton(
                      onPressed: _busy ? null : () => unawaited(_expiry(0)),
                      child: Text(
                        _customExpiry == null
                            ? 'Choose a future expiry'
                            : _date(_customExpiry!),
                      ),
                    ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Current password',
                      helperText: widget.account.address,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Creating a key requires a sign-in with a second factor.',
                    style: rmText(13, color: c.ink3),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _keyError(error, widget.account.host),
                      style: rmText(14, color: c.danger),
                    ),
                    if (error.code == 'two_factor_required')
                      TextButton(
                        onPressed: () =>
                            unawaited(_signInAgain(context, widget.account)),
                        child: const Text('Sign in with a code'),
                      ),
                  ],
                  const SizedBox(height: 24),
                  RmPrimaryButton(
                    label: 'Create API key',
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_create()) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permission(int index) {
    final item = _permissions[index];
    return Padding(
      key: ObjectKey(item),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: item.capability,
            decoration: InputDecoration(labelText: 'Capability ${index + 1}'),
            items: [
              for (final capability in _capabilities)
                DropdownMenuItem(value: capability, child: Text(capability)),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() {
                    if (value != null) item.capability = value;
                    _error = null;
                  }),
          ),
          DropdownButtonFormField<_Scope>(
            isExpanded: true,
            initialValue: item.scope,
            decoration: const InputDecoration(labelText: 'Applies to'),
            items: [
              for (final scope in _Scope.values)
                DropdownMenuItem(value: scope, child: Text(scope.label)),
            ],
            onChanged: _busy
                ? null
                : (scope) => setState(() {
                    if (scope == null) return;
                    item.scope = scope;
                    item.target.text = scope == _Scope.mailbox
                        ? widget.mailbox.address
                        : scope == _Scope.domain
                        ? widget.mailbox.address.split('@').last
                        : '';
                    _error = null;
                  }),
          ),
          if (item.scope != _Scope.all)
            TextField(
              controller: item.target,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: item.scope == _Scope.mailbox
                    ? 'Mailbox address'
                    : 'Domain name',
              ),
              onChanged: (_) => setState(() => _error = null),
            ),
          if (_permissions.length > 1)
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() {
                      _permissions.removeAt(index).target.dispose();
                    }),
              child: const Text('Remove permission'),
            ),
        ],
      ),
    );
  }
}

class _NewSecret {
  _NewSecret(this.value);
  String? value;
}

/// Nothing persists this secret. The list cannot display it again.
class _CreatedKeyScreen extends StatefulWidget {
  const _CreatedKeyScreen({required this.keyInfo, required this.secret});

  final APIKey keyInfo;
  final _NewSecret secret;

  @override
  State<_CreatedKeyScreen> createState() => _CreatedKeyScreenState();
}

class _CreatedKeyScreenState extends State<_CreatedKeyScreen> {
  late final AppLifecycleListener _lifecycle;
  var _hidden = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onInactive: () => setState(() => _hidden = true),
      onResume: () => setState(() => _hidden = false),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    widget.secret.value = null;
    super.dispose();
  }

  Future<void> _copy() async {
    final value = widget.secret.value;
    if (value == null) return;
    final expires = await const SecretClipboard().copy(value);
    if (mounted) {
      showToast(
        context,
        expires ? 'API key copied for two minutes' : 'API key copied',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final secret = widget.secret.value;
    final c = context.rm;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'API key created',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    widget.keyInfo.name,
                    style: rmText(20, color: c.ink, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  const Text('Copy this key now. It will not be shown again.'),
                  const SizedBox(height: 16),
                  if (_hidden || secret == null)
                    const AdminMessage('API key hidden')
                  else ...[
                    SelectableText(secret, style: rmText(16, color: c.ink)),
                    const SizedBox(height: 18),
                    RmPrimaryButton(
                      label: 'Copy API key',
                      onPressed: () => unawaited(_copy()),
                    ),
                  ],
                  const SizedBox(height: 22),
                  const Text(
                    'Use this key as a Bearer credential in the Authorization header.',
                  ),
                  for (final permission in widget.keyInfo.permissions)
                    Text('${permission.capability} · ${permission.scope}'),
                  const SizedBox(height: 18),
                  RmPrimaryButton(
                    label: 'Done',
                    onPressed: () => Navigator.pop(context),
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
