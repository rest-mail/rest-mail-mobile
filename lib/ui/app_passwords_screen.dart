import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../util/secret_clipboard.dart';
import 'add_account_screen.dart';
import 'admin/admin_widgets.dart' show AdminMessage;
import 'widgets/common.dart';

/// What a server from before app passwords (REST Mail 0.10.0) shows.
const _unsupported = "This server doesn't support app passwords yet.";

String _day(DateTime when) => DateFormat.yMMMd().format(when);

String _lastUsed(DateTime when, DateTime now) => DateUtils.isSameDay(when, now)
    ? 'Last used today at ${DateFormat.Hm().format(when)}'
    : 'Last used ${_day(when)}';

/// What a refused request says, its fields named as a person would.
String _describe(ApiException e, String host) {
  if (e.fields.entries.firstOrNull case final field?) {
    final name = field.key == 'expires_at' ? 'Expiry' : 'Name';
    return '$name ${field.value}.';
  }
  return describeError(e, host: host);
}

/// A mailbox's app passwords: what mail apps such as Thunderbird or the
/// iPhone's Mail, and automations, sign in with instead of its password. For
/// the session's own mailbox only, which [mailbox] is.
class AppPasswordsScreen extends StatefulWidget {
  const AppPasswordsScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final Account mailbox;

  @override
  State<AppPasswordsScreen> createState() => _AppPasswordsScreenState();
}

class _AppPasswordsScreenState extends State<AppPasswordsScreen> {
  List<AppPassword>? _items;
  ApiException? _error;
  bool _loading = true;
  final _revoking = <int>{};

  RestmailClient get _client => widget.account.client;
  String get _host => widget.account.host;

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
      final items = await _client.appPasswords(widget.mailbox.id);
      if (mounted) setState(() => _items = items);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CreateAppPasswordScreen(
          account: widget.account,
          mailbox: widget.mailbox,
        ),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _revoke(AppPassword item) async {
    final sure = await confirmAction(
      context,
      title: 'Revoke “${item.name}”?',
      message:
          'Whatever signs in with it stops working at once, mail apps '
          'that are connected included. This cannot be undone.',
      action: 'Revoke',
    );
    if (!sure || !mounted) return;
    setState(() => _revoking.add(item.id));
    try {
      await _client.revokeAppPassword(widget.mailbox.id, item.id);
      if (!mounted) return;
      setState(() => _items = [...?_items]..remove(item));
      showToast(context, 'Revoked “${item.name}”');
    } on ApiException catch (e) {
      if (!mounted) return;
      // Already gone (revoked elsewhere): the list catches up.
      if (e.statusCode == 404) {
        unawaited(_load());
      } else {
        showToast(context, describeError(e, host: _host));
      }
    } finally {
      if (mounted) setState(() => _revoking.remove(item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final items = _items;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'App passwords',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: switch ((error, items)) {
                (ApiException(statusCode: 404), _) => const AdminMessage(
                  _unsupported,
                ),
                (final error?, _) => AdminMessage(
                  describeError(error, host: _host),
                  onRetry: () => unawaited(_load()),
                ),
                (null, final items?) => RefreshIndicator(
                  onRefresh: _load,
                  child: _list(context, items),
                ),
                _ when _loading => const Center(
                  child: CircularProgressIndicator(),
                ),
                _ => const SizedBox(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context, List<AppPassword> items) {
    final c = context.rm;
    final now = DateTime.now();
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
      children: [
        Text(
          'An app password lets a mail app, such as Thunderbird or the '
          "iPhone's Mail, or an automation sign in to "
          '${widget.mailbox.address} without your password. Each one can '
          'be revoked on its own.',
          style: rmText(14, color: c.ink2, height: 1.45),
        ),
        const SizedBox(height: 18),
        RmPrimaryButton(
          label: 'Create an app password',
          onPressed: () => unawaited(_create()),
        ),
        const SizedBox(height: 22),
        const SectionLabel('App passwords'),
        const SizedBox(height: 9),
        if (items.isEmpty)
          Text('None yet.', style: rmText(14, color: c.ink3))
        else
          RmGroup(
            children: [
              for (final item in items)
                _AppPasswordRow(
                  item: item,
                  now: now,
                  busy: _revoking.contains(item.id),
                  onRevoke: () => unawaited(_revoke(item)),
                ),
            ],
          ),
      ],
    );
  }
}

class _AppPasswordRow extends StatelessWidget {
  const _AppPasswordRow({
    required this.item,
    required this.now,
    required this.busy,
    required this.onRevoke,
  });

  final AppPassword item;
  final DateTime now;
  final bool busy;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final lastUsed = item.lastUsedAt;
    final expires = item.expiresAt;
    final expired = item.isExpiredAt(now);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  'Created ${_day(item.createdAt)} · '
                  '${lastUsed == null ? 'Never used' : _lastUsed(lastUsed, now)}',
                  style: rmText(12.5, color: c.ink3, height: 1.35),
                ),
                Text(
                  switch (expires) {
                    null => 'Never expires',
                    _ when expired => 'Expired ${_day(expires)}',
                    _ => 'Expires ${_day(expires)}',
                  },
                  style: rmText(
                    12.5,
                    color: expired ? c.danger : c.ink3,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (busy)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Tooltip(
              message: 'Revoke ${item.name}',
              child: TextButton(
                onPressed: onRevoke,
                child: Text(
                  'Revoke',
                  style: rmText(14, color: c.danger, weight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _Expiry {
  never('Never', null),
  month('In 30 days', Duration(days: 30)),
  quarter('In 90 days', Duration(days: 90)),
  year('In a year', Duration(days: 365));

  const _Expiry(this.label, this.after);

  final String label;
  final Duration? after;
}

/// Makes an app password: a name, an expiry, and the mailbox's password
/// entered again, which the server asks for. The password goes as soon as it
/// is sent, and is never offered to save as a new one.
class CreateAppPasswordScreen extends StatefulWidget {
  const CreateAppPasswordScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final Account mailbox;

  @override
  State<CreateAppPasswordScreen> createState() =>
      _CreateAppPasswordScreenState();
}

class _CreateAppPasswordScreenState extends State<CreateAppPasswordScreen> {
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  _Expiry _expiry = _Expiry.never;
  bool _busy = false;
  String? _error;

  /// The session's sign-in didn't take the mailbox's second factor.
  bool _needsSignIn = false;

  bool get _ready =>
      !_busy && _name.text.trim().isNotEmpty && _password.text.isNotEmpty;

  @override
  void dispose() {
    _password.clear();
    _name.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_ready) return;
    final password = _password.text;
    // Not kept past the request: a refusal asks for it again.
    _password.clear();
    setState(() {
      _busy = true;
      _error = null;
      _needsSignIn = false;
    });
    final host = widget.account.host;
    try {
      final created = await widget.account.client.createAppPassword(
        widget.mailbox.id,
        name: _name.text.trim(),
        password: password,
        expiresAt: switch (_expiry.after) {
          final after? => DateTime.now().add(after),
          null => null,
        },
      );
      // The password field's autofill context ends without saving: it held
      // the current password, never a new one.
      TextInput.finishAutofillContext(shouldSave: false);
      if (!mounted) {
        created.forget();
        return;
      }
      unawaited(
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => NewAppPasswordScreen(
              created: created,
              address: widget.mailbox.address,
            ),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _needsSignIn = e.code == 'two_factor_required';
        _error = switch (e) {
          // The request's own refusal, never the session's: ask again.
          ApiException(code: 'reauth_required' || 'invalid_password') =>
            "That isn't the password of ${widget.mailbox.address}. "
                'Enter it again.',
          ApiException(code: 'two_factor_required') =>
            '${widget.mailbox.address} has two-factor authentication, and '
                'this session signed in without a code. Sign in again with '
                'your code to create an app password.',
          ApiException(statusCode: 429, :final retryAfter) =>
            'Too many attempts. Try again '
                '${retryAfter == null ? 'shortly' : 'in ${_wait(retryAfter)}'}.',
          _ => _describe(e, host),
        };
      });
      if (e.code == 'reauth_required' || e.code == 'invalid_password') {
        _passwordFocus.requestFocus();
      }
    }
  }

  static String _wait(Duration wait) => switch (wait.inSeconds) {
    <= 1 => 'a second',
    <= 90 => '${wait.inSeconds} seconds',
    _ => '${(wait.inSeconds / 60).ceil()} minutes',
  };

  void _signInAgain() => unawaited(
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AddAccountScreen(
          server: widget.account.server,
          email: widget.mailbox.address,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'New app password',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  const SectionLabel('Name'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    maxLength: 100,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() => _error = null),
                    style: rmText(16, color: c.ink),
                    decoration: const InputDecoration(
                      hintText: 'iPhone Mail',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'So you know which app uses it.',
                    style: rmText(13, color: c.ink3),
                  ),
                  const SizedBox(height: 22),
                  const SectionLabel('Expires'),
                  const SizedBox(height: 8),
                  RmGroup(
                    children: [
                      for (final expiry in _Expiry.values)
                        Semantics(
                          selected: expiry == _expiry,
                          child: RmRow(
                            label: expiry.label,
                            trailing: expiry == _expiry
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 20,
                                    color: c.accent,
                                  )
                                : const SizedBox(width: 20),
                            onTap: () => setState(() => _expiry = expiry),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const SectionLabel('Your password'),
                  const SizedBox(height: 8),
                  // Its own autofill context, ended without saving: a
                  // password manager may fill in the current password, and
                  // is never offered it as a new one.
                  AutofillGroup(
                    onDisposeAction: AutofillContextAction.cancel,
                    child: TextField(
                      controller: _password,
                      focusNode: _passwordFocus,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) => unawaited(_create()),
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'The password you sign in with',
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'REST Mail asks for the password of '
                    '${widget.mailbox.address} again before it makes an app '
                    'password.',
                    style: rmText(13, color: c.ink3, height: 1.4),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  if (_needsSignIn) ...[
                    const SizedBox(height: 10),
                    RmOutlineButton(
                      label: 'Sign in again',
                      onPressed: _signInAgain,
                    ),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: 'Create app password',
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

/// A new app password, shown this once. Nothing keeps it: when the screen
/// closes it is forgotten, and while the app is in the background it is
/// hidden, so the app switcher's snapshot doesn't hold it either.
class NewAppPasswordScreen extends StatefulWidget {
  const NewAppPasswordScreen({
    super.key,
    required this.created,
    required this.address,
  });

  final NewAppPassword created;

  /// The mailbox it signs in to.
  final String address;

  @override
  State<NewAppPasswordScreen> createState() => _NewAppPasswordScreenState();
}

class _NewAppPasswordScreenState extends State<NewAppPasswordScreen> {
  late final AppLifecycleListener _lifecycle;
  bool _hidden = false;

  /// Null until it is copied; then whether the copy goes by itself.
  bool? _copyExpires;

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
    widget.created.forget();
    super.dispose();
  }

  Future<void> _copy() async {
    final secret = widget.created.secret;
    if (secret == null) return;
    final expires = await const SecretClipboard().copy(secret);
    if (!mounted) return;
    setState(() => _copyExpires = expires);
    showToast(context, 'App password copied');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final secret = widget.created.secret;
    final name = widget.created.appPassword.name;
    final domain = widget.address.substring(widget.address.indexOf('@') + 1);
    final copyExpires = _copyExpires;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'App password',
              onBack: () => Navigator.pop(context),
              trailingText: 'Done',
              onTrailing: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
                children: [
                  Text(
                    'The app password for “$name”. Put it in your mail app '
                    "now: it won't be shown again.",
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border.all(color: c.line),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    // Plain text, not selectable: the copy button is the only
                    // way out, and its copy goes as soon as it can.
                    child: _hidden || secret == null
                        ? Text(
                            'Hidden while REST Mail is in the background',
                            style: rmText(14, color: c.ink3),
                          )
                        : Semantics(
                            label: 'App password',
                            child: Text(
                              secret,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 16,
                                height: 1.5,
                                color: c.ink,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 14),
                  RmPrimaryButton(
                    label: 'Copy app password',
                    onPressed: secret == null ? null : () => unawaited(_copy()),
                  ),
                  if (copyExpires != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      copyExpires
                          ? 'Copied to this phone only. It leaves the '
                                'clipboard in '
                                '${SecretClipboard.lifetime.inMinutes} minutes.'
                          : 'Other apps can read the clipboard. Paste it '
                                'into your mail app now, then copy something '
                                'else over it.',
                      style: rmText(
                        13,
                        color: copyExpires ? c.ink3 : c.danger,
                        weight: copyExpires ? FontWeight.w400 : FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 26),
                  const SectionLabel('Setting up a mail app'),
                  const SizedBox(height: 8),
                  Text(
                    'Thunderbird and most mail apps find these from your '
                    'address. On an iPhone, add an account of type Other in '
                    'Settings, under Mail, and type them in.',
                    style: rmText(13, color: c.ink3, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  // What the server's autoconfig gives mail clients: the
                  // domain itself, TLS from the first byte.
                  RmGroup(
                    children: [
                      RmRow(label: 'Email', value: widget.address),
                      RmRow(label: 'Username', value: widget.address),
                      const RmRow(
                        label: 'Password',
                        value: 'This app password',
                      ),
                      RmRow(
                        label: 'Incoming (IMAP)',
                        subtitle: 'Port 993, SSL/TLS',
                        value: domain,
                      ),
                      RmRow(
                        label: 'Outgoing (SMTP)',
                        subtitle: 'Port 465, SSL/TLS',
                        value: domain,
                      ),
                    ],
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
