import 'dart:async';

import '../l10n/voice.dart';

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

String _keyError(BuildContext context, ApiException error, String host) {
  if (error.fields.isNotEmpty) {
    return error.fields.entries
        .map((field) => '${field.key.replaceAll('_', ' ')}: ${field.value}')
        .join('\n');
  }
  return switch (error.code) {
    _ when error.statusCode == 404 => tr(
      context,
      'apikeys.apiKeysAreNotAvailableForThis',
    ),
    'two_factor_required' => tr(
      context,
      'apikeys.enableTwoFactorAuthenticationThenSignIn',
    ),
    'reauth_required' || 'invalid_password' => tr(
      context,
      'apikeys.enterTheCurrentPasswordOfTheAccount',
    ),
    'forbidden' => tr(context, 'apikeys.thesePermissionsExceedWhatYouOrThis'),
    'session_required' => tr(context, 'apikeys.signInWithYourPasswordAndA'),
    _ => describeError(context, error, host: host),
  };
}

/// What a refused change to a key's permissions means, in the words of the
/// admin screen. `forbidden` is how the server refuses permissions over the
/// ceiling, but other checks answer with it too, so it keeps the server's own
/// message, which cannot name the wrong cause.
String _editKeyError(
  BuildContext context,
  ApiException error,
  String host,
) => switch (error.code) {
  _ when error.fields.isNotEmpty => _keyError(context, error, host),
  'recent_two_factor_required' => tr(
    context,
    'apikeys.yourTwoFactorSignInIsNo',
  ),
  'two_factor_required' => tr(context, 'apikeys.thisChangeNeedsASessionSigned'),
  'reauth_required' => tr(context, 'apikeys.enterYourCurrentPasswordToChange'),
  'invalid_password' => tr(context, 'apikeys.thatIsNotYourCurrentPassword'),
  'not_found' => tr(context, 'apikeys.thisAPIKeyNoLongerExists'),
  'forbidden' => error.message,
  _ => _keyError(context, error, host),
};

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
  var _loadRun = 0;

  RestAccount get _account => _currentSession(context, widget.account);

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    // Only the newest answer counts: one asked before a save may arrive after
    // it, and would put the old permissions back.
    final run = ++_loadRun;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _account.client.apiKeys(widget.mailbox.id);
      if (mounted && run == _loadRun) setState(() => _items = items);
    } on ApiException catch (error) {
      if (mounted && run == _loadRun) setState(() => _error = error);
    } finally {
      if (mounted && run == _loadRun) setState(() => _loading = false);
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

  Future<void> _edit(APIKey key) async {
    final saved = await Navigator.push<APIKey>(
      context,
      MaterialPageRoute(
        builder: (_) => EditAPIKeyScreen(
          account: _account,
          mailbox: widget.mailbox,
          apiKey: key,
        ),
      ),
    );
    if (!mounted) return;
    if (saved != null) {
      // What the server stored, at once, so a list that then fails to reload
      // is still right.
      setState(
        () => _items = [
          for (final item in _items ?? const <APIKey>[])
            item.id == saved.id ? saved : item,
        ],
      );
      showToast(
        context,
        trArgs(context, 'apikeys.savedThePermissionsOfName', {
          'name': saved.name,
        }),
      );
    }
    await _load();
  }

  Future<void> _revoke(APIKey key) async {
    final sure = await confirmAction(
      context,
      title: trArgs(context, 'apikeys.revokeName', {
        'name': (key.name).toString(),
      }),
      message: tr(context, 'apikeys.requestsUsingThisKeyWillBeRefused'),
      action: tr(context, 'apikeys.revoke'),
    );
    if (!sure || !mounted) return;
    setState(() => _revoking.add(key.id));
    try {
      await _account.client.revokeAPIKey(widget.mailbox.id, key.id);
      if (!mounted) return;
      setState(() => _items = [...?_items]..remove(key));
      showToast(
        context,
        trArgs(context, 'apikeys.revokedName', {'name': (key.name).toString()}),
      );
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
            RmTopBar(
              title: tr(context, 'apikeys.apiKeys'),
              onBack: () => Navigator.pop(context),
            ),
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
                            tr(
                              context,
                              'apikeys.giveAnAutomationNamedPermissionsOnSpecific',
                            ),
                            style: rmText(14, color: c.ink2, height: 1.45),
                          ),
                          const SizedBox(height: 18),
                          RmPrimaryButton(
                            label: tr(context, 'apikeys.createAnAPIKey'),
                            onPressed: () => unawaited(_create()),
                          ),
                          if (error != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _keyError(context, error, _account.host),
                              style: rmText(14, color: c.danger),
                            ),
                            if (error.code == 'two_factor_required')
                              TextButton(
                                onPressed: () =>
                                    unawaited(_signInAgain(context, _account)),
                                child: Text(
                                  tr(context, 'apikeys.signInWithACode'),
                                ),
                              )
                            else
                              TextButton(
                                onPressed: () => unawaited(_load()),
                                child: Text(tr(context, 'health.retry')),
                              ),
                          ],
                          const SizedBox(height: 22),
                          SectionLabel(widget.mailbox.address),
                          const SizedBox(height: 9),
                          if (items != null && items.isEmpty)
                            Text(
                              tr(context, 'apikeys.noAPIKeysYet'),
                              style: rmText(14, color: c.ink3),
                            ),
                          if (items != null && items.isNotEmpty)
                            RmGroup(
                              children: [
                                for (final key in items)
                                  RmRow(
                                    label: key.name,
                                    subtitle: [
                                      trArgs(context, 'apikeys.idPublicId', {
                                        'publicId': (key.publicId).toString(),
                                      }),
                                      trArgs(context, 'apikeys.createdValue', {
                                        'value': (_date(key.createdAt))
                                            .toString(),
                                      }),
                                      key.lastUsedAt == null
                                          ? tr(context, 'date.neverUsed')
                                          : trArgs(
                                              context,
                                              'apikeys.lastUsedValue',
                                              {
                                                'value': (_date(
                                                  key.lastUsedAt!,
                                                )).toString(),
                                              },
                                            ),
                                      key.expiresAt == null
                                          ? tr(context, 'apikeys.noExpiry')
                                          : '${key.isExpiredAt(DateTime.now()) ? tr(context, 'admin.logs.expired') : tr(context, 'admin.logs.expires')} ${_date(key.expiresAt!)}',
                                      for (final permission in key.permissions)
                                        '${permission.capability} · ${permission.scope}',
                                    ].join('\n'),
                                    onTap: _revoking.contains(key.id)
                                        ? null
                                        : () => unawaited(_edit(key)),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: _revoking.contains(key.id)
                                              ? null
                                              : () => unawaited(_edit(key)),
                                          child: Text(
                                            tr(context, 'folders.edit'),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: _revoking.contains(key.id)
                                              ? null
                                              : () => unawaited(_revoke(key)),
                                          child: Text(
                                            tr(context, 'apikeys.revoke'),
                                          ),
                                        ),
                                      ],
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
  mailbox('admin.permissions.aMailbox', 'mailbox:'),
  domain('admin.permissions.aDomain', 'domain:'),
  all('admin.granttext.everywhere', '');

  const _Scope(this.label, this.prefix);
  final String label;
  final String prefix;
}

class _PermissionInput {
  _PermissionInput(String address)
    : target = TextEditingController(text: address);

  /// A permission a key already holds. The server stores only these three
  /// forms. Anything else shows as a mailbox, which the server refuses if it is
  /// saved unchanged, and never as everywhere, which would widen the key.
  factory _PermissionInput.held(APIKeyPermission permission) {
    final stored = permission.scope;
    final scope = stored == '*'
        ? _Scope.all
        : stored.startsWith(_Scope.domain.prefix)
        ? _Scope.domain
        : _Scope.mailbox;
    final target = scope == _Scope.all
        ? ''
        : stored.startsWith(scope.prefix)
        ? stored.substring(scope.prefix.length)
        : stored;
    return _PermissionInput(target)
      ..capability = permission.capability
      ..scope = scope;
  }

  String capability = 'mail:read';
  _Scope scope = _Scope.mailbox;
  final TextEditingController target;

  APIKeyPermission get permission => APIKeyPermission(
    capability: capability,
    scope: scope == _Scope.all
        ? '*'
        : '${scope.prefix}${target.text.trim().toLowerCase()}',
  );

  bool get isComplete => scope == _Scope.all || target.text.trim().isNotEmpty;
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
      _permissions.every((item) => item.isComplete);

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
              title: tr(context, 'apikeys.newAPIKey'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  TextField(
                    controller: _name,
                    maxLength: 100,
                    decoration: InputDecoration(
                      labelText: tr(context, 'folders.name'),
                      hintText: tr(context, 'apikeys.mailboxProvisioning'),
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    tr(context, 'admin.section.permissions.title'),
                    style: rmText(16, color: c.ink, weight: FontWeight.w700),
                  ),
                  Text(
                    tr(context, 'apikeys.eachCapabilityAppliesOnlyAtTheScope'),
                    style: rmText(13, color: c.ink3),
                  ),
                  for (final (i, item) in _permissions.indexed)
                    _PermissionFields(
                      key: ObjectKey(item),
                      item: item,
                      index: i,
                      mailbox: widget.mailbox,
                      enabled: !_busy,
                      onChanged: () => setState(() => _error = null),
                      onRemove: _permissions.length > 1
                          ? () => setState(() {
                              _permissions.removeAt(i).target.dispose();
                            })
                          : null,
                    ),
                  TextButton.icon(
                    onPressed: _busy || _permissions.length >= 64
                        ? null
                        : () => setState(
                            () => _permissions.add(
                              _PermissionInput(widget.mailbox.address),
                            ),
                          ),
                    icon: const Icon(Icons.add),
                    label: Text(tr(context, 'apikeys.addPermission')),
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    initialValue: _days,
                    decoration: InputDecoration(
                      labelText: tr(context, 'admin.logs.expires'),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 30,
                        child: Text(tr(context, 'apikeys.in30Days')),
                      ),
                      DropdownMenuItem(
                        value: 90,
                        child: Text(tr(context, 'apikeys.in90Days')),
                      ),
                      DropdownMenuItem(
                        value: 365,
                        child: Text(tr(context, 'apikeys.inAYear')),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text(tr(context, 'apikeys.chooseDateAndTime')),
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
                            ? tr(context, 'apikeys.chooseAFutureExpiry')
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
                      labelText: tr(context, 'apikeys.currentPassword'),
                      helperText: widget.account.address,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr(context, 'apikeys.creatingAKeyRequiresASignIn'),
                    style: rmText(13, color: c.ink3),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _keyError(context, error, widget.account.host),
                      style: rmText(14, color: c.danger),
                    ),
                    if (error.code == 'two_factor_required')
                      TextButton(
                        onPressed: () =>
                            unawaited(_signInAgain(context, widget.account)),
                        child: Text(tr(context, 'apikeys.signInWithACode')),
                      ),
                  ],
                  const SizedBox(height: 24),
                  RmPrimaryButton(
                    label: tr(context, 'apikeys.createAPIKey'),
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
}

/// One permission's capability and scope, on the forms that make and change a
/// key.
class _PermissionFields extends StatelessWidget {
  const _PermissionFields({
    super.key,
    required this.item,
    required this.index,
    required this.mailbox,
    required this.enabled,
    required this.onChanged,
    required this.onRemove,
  });

  final _PermissionInput item;
  final int index;
  final Account mailbox;
  final bool enabled;
  final VoidCallback onChanged;

  /// Null when this is the only permission: a key needs at least one.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final remove = onRemove;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: item.capability,
            decoration: InputDecoration(
              labelText: trArgs(context, 'apikeys.capabilityValue', {
                'value': (index + 1).toString(),
              }),
            ),
            // A key can hold a capability this list doesn't name. It stays
            // on offer until it is changed.
            items: [
              for (final capability in {..._capabilities, item.capability})
                DropdownMenuItem(value: capability, child: Text(capability)),
            ],
            onChanged: enabled
                ? (value) {
                    if (value != null) item.capability = value;
                    onChanged();
                  }
                : null,
          ),
          DropdownButtonFormField<_Scope>(
            isExpanded: true,
            initialValue: item.scope,
            decoration: InputDecoration(
              labelText: tr(context, 'apikeys.appliesTo'),
            ),
            items: [
              for (final scope in _Scope.values)
                DropdownMenuItem(
                  value: scope,
                  child: Text(tr(context, scope.label)),
                ),
            ],
            onChanged: enabled
                ? (scope) {
                    if (scope == null) return;
                    item.scope = scope;
                    item.target.text = scope == _Scope.mailbox
                        ? mailbox.address
                        : scope == _Scope.domain
                        ? mailbox.address.split('@').last
                        : '';
                    onChanged();
                  }
                : null,
          ),
          if (item.scope != _Scope.all)
            TextField(
              controller: item.target,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: item.scope == _Scope.mailbox
                    ? tr(context, 'apikeys.mailboxAddress')
                    : tr(context, 'admin.tlsreports.domainName'),
              ),
              onChanged: (_) => onChanged(),
            ),
          if (remove != null)
            TextButton(
              onPressed: enabled ? remove : null,
              child: Text(tr(context, 'apikeys.removePermission')),
            ),
        ],
      ),
    );
  }
}

/// Changes what a key may do. The secret is never here: the list does not carry
/// it, and this form sends only the permissions and the current password.
/// Pops with the key as the server stored it.
class EditAPIKeyScreen extends StatefulWidget {
  const EditAPIKeyScreen({
    super.key,
    required this.account,
    required this.mailbox,
    required this.apiKey,
  });

  final RestAccount account;
  final Account mailbox;
  final APIKey apiKey;

  @override
  State<EditAPIKeyScreen> createState() => _EditAPIKeyScreenState();
}

class _EditAPIKeyScreenState extends State<EditAPIKeyScreen> {
  final _password = TextEditingController();
  late final _permissions = [
    for (final permission in widget.apiKey.permissions)
      _PermissionInput.held(permission),
  ];
  var _busy = false;
  ApiException? _error;

  bool get _ready =>
      !_busy &&
      _password.text.isNotEmpty &&
      _permissions.isNotEmpty &&
      _permissions.every((item) => item.isComplete);

  @override
  void dispose() {
    _password.clear();
    _password.dispose();
    for (final permission in _permissions) {
      permission.target.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_ready) return;
    final password = _password.text;
    _password.clear();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final account = _currentSession(context, widget.account);
      final saved = await account.client.updateAPIKey(
        widget.mailbox.id,
        widget.apiKey.id,
        password: password,
        permissions: [for (final item in _permissions) item.permission],
      );
      TextInput.finishAutofillContext(shouldSave: false);
      if (mounted) Navigator.pop(context, saved);
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
              title: trArgs(context, 'apikeys.permissionsOfName', {
                'name': widget.apiKey.name,
              }),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    trArgs(context, 'apikeys.ownerAddress', {
                      'address': widget.mailbox.address,
                    }),
                    style: rmText(14, color: c.ink, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr(context, 'apikeys.theNewPermissionsReplaceTheOnes'),
                    style: rmText(14, color: c.ink2, height: 1.45),
                  ),
                  for (final (i, item) in _permissions.indexed)
                    _PermissionFields(
                      key: ObjectKey(item),
                      item: item,
                      index: i,
                      mailbox: widget.mailbox,
                      enabled: !_busy,
                      onChanged: () => setState(() => _error = null),
                      onRemove: _permissions.length > 1
                          ? () => setState(() {
                              _permissions.removeAt(i).target.dispose();
                              _error = null;
                            })
                          : null,
                    ),
                  TextButton.icon(
                    onPressed: _busy || _permissions.length >= 64
                        ? null
                        : () => setState(() {
                            _permissions.add(
                              _PermissionInput(widget.mailbox.address),
                            );
                            _error = null;
                          }),
                    icon: const Icon(Icons.add),
                    label: Text(tr(context, 'apikeys.addPermission')),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr(context, 'apikeys.aKeyCanHoldOnlyWhatBoth'),
                    style: rmText(13, color: c.ink3),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: tr(context, 'apikeys.currentPassword'),
                      helperText: widget.account.address,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr(context, 'apikeys.changingAKeyRequiresARecentSignIn'),
                    style: rmText(13, color: c.ink3),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _editKeyError(context, error, widget.account.host),
                      style: rmText(14, color: c.danger),
                    ),
                    if (error.code == 'two_factor_required' ||
                        error.code == 'recent_two_factor_required')
                      TextButton(
                        onPressed: () =>
                            unawaited(_signInAgain(context, widget.account)),
                        child: Text(tr(context, 'twoFactor.signInAgain')),
                      ),
                  ],
                  const SizedBox(height: 24),
                  RmPrimaryButton(
                    label: tr(context, 'common.save'),
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_save()) : null,
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
        expires
            ? tr(context, 'apikeys.apiKeyCopiedForTwoMinutes')
            : tr(context, 'apikeys.apiKeyCopied'),
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
              title: tr(context, 'apikeys.apiKeyCreated'),
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
                  Text(tr(context, 'apikeys.copyThisKeyNowItWillNot')),
                  const SizedBox(height: 16),
                  if (_hidden || secret == null)
                    AdminMessage(tr(context, 'apikeys.apiKeyHidden'))
                  else ...[
                    SelectableText(secret, style: rmText(16, color: c.ink)),
                    const SizedBox(height: 18),
                    RmPrimaryButton(
                      label: tr(context, 'apikeys.copyAPIKey'),
                      onPressed: () => unawaited(_copy()),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Text(tr(context, 'apikeys.useThisKeyAsABearerCredential')),
                  for (final permission in widget.keyInfo.permissions)
                    Text('${permission.capability} · ${permission.scope}'),
                  const SizedBox(height: 18),
                  RmPrimaryButton(
                    label: tr(context, 'common.done'),
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
