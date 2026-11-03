import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/recovery_email_state.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// The signed-in account's external recovery email: its state, and adding or
/// changing it with the current password. Verification finishes at the link
/// the server sends, which opens in a browser, so this screen reads the state
/// again when the app comes back. The server has no way to remove an address,
/// so neither has this screen.
class RecoveryEmailScreen extends StatefulWidget {
  const RecoveryEmailScreen({super.key, required this.client});

  final RestmailClient client;

  @override
  State<RecoveryEmailScreen> createState() => _RecoveryEmailScreenState();
}

class _RecoveryEmailScreenState extends State<RecoveryEmailScreen>
    with WidgetsBindingObserver {
  late final _state = RecoveryEmailState(client: widget.client);
  final _address = TextEditingController();
  final _password = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _state.addListener(_changed);
    unawaited(_state.load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _state.dispose();
    _address.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (lifecycle == AppLifecycleState.resumed &&
        _state.status?.stage == RecoveryEmailStage.pending) {
      unawaited(_state.load());
    }
  }

  void _changed() => setState(() {});

  void _edit(String address) => setState(() {
    _editing = true;
    _address.text = address;
    _password.clear();
    _state.clearSaveError();
  });

  void _edited(String _) => setState(_state.clearSaveError);

  void _cancel() => setState(() {
    _editing = false;
    _address.clear();
    _password.clear();
    _state.clearSaveError();
  });

  bool get _ready =>
      !_state.saving &&
      _address.text.trim().isNotEmpty &&
      _password.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_ready) return;
    final done = await _state.register(
      email: _address.text.trim(),
      currentPassword: _password.text,
    );
    if (!done || !mounted) return;
    setState(() {
      _editing = false;
      _address.clear();
      _password.clear();
    });
  }

  /// What the server refused that belongs to no field on this screen.
  String? _refusal(ApiException? error) => switch (error) {
    null => null,
    ApiException(code: 'invalid_password') => null,
    ApiException(code: 'recovery_method_frozen') => tr(
      context,
      'recoveryEmail.frozen',
    ),
    ApiException(statusCode: 429, :final retryAfter?) => trArgs(
      context,
      'recoveryEmail.tooMany',
      {'minutes': '${(retryAfter.inSeconds / 60).ceil()}'},
    ),
    ApiException(:final fields)
        when fields.keys.any(
          (name) => name != 'email' && name != 'current_password',
        ) =>
      fields.values.first,
    ApiException(:final fields) when fields.isNotEmpty => null,
    _ => describeError(context, error, host: widget.client.server.host),
  };

  Widget _form(BuildContext context, RecoveryEmailStage stage) {
    final error = _state.saveError;
    final fields = error?.fields ?? const <String, String>{};
    final refusal = _refusal(error);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (stage == RecoveryEmailStage.verified) ...[
          Text(
            tr(context, 'recoveryEmail.changeNote'),
            style: rmText(14, color: context.rm.ink2, height: 1.45),
          ),
          const SizedBox(height: 18),
        ],
        TextField(
          key: const ValueKey('recoveryEmail.address'),
          controller: _address,
          enabled: !_state.saving,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.email],
          onChanged: _edited,
          decoration: InputDecoration(
            labelText: tr(context, 'recoveryEmail.address'),
            errorText: fields['email'],
            errorMaxLines: 3,
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          key: const ValueKey('recoveryEmail.currentPassword'),
          controller: _password,
          enabled: !_state.saving,
          obscureText: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onChanged: _edited,
          onSubmitted: (_) => unawaited(_submit()),
          decoration: InputDecoration(
            labelText: tr(context, 'recoveryEmail.currentPassword'),
            errorText: error?.code == 'invalid_password'
                ? tr(context, 'recoveryEmail.wrongPassword')
                : fields['current_password'],
            errorMaxLines: 3,
          ),
        ),
        if (refusal != null) ...[
          const SizedBox(height: 12),
          ErrorText(refusal),
        ],
        const SizedBox(height: 22),
        RmPrimaryButton(
          label: tr(context, 'recoveryEmail.send'),
          busy: _state.saving,
          onPressed: _ready ? () => unawaited(_submit()) : null,
        ),
        if (stage != RecoveryEmailStage.none)
          TextButton(
            onPressed: _state.saving ? null : _cancel,
            child: Text(tr(context, 'common.cancel')),
          ),
      ],
    );
  }

  Widget _loaded(BuildContext context, RecoveryEmailStatus status) {
    final c = context.rm;
    final stage = status.stage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RmGroup(
          children: [
            RmRow(
              label: tr(context, 'recoveryEmail.state'),
              value: tr(context, switch (stage) {
                RecoveryEmailStage.none => 'recoveryEmail.stateNone',
                RecoveryEmailStage.pending => 'recoveryEmail.statePending',
                RecoveryEmailStage.verified => 'recoveryEmail.stateVerified',
              }),
            ),
            if (stage != RecoveryEmailStage.none)
              RmRow(
                label: tr(context, 'recoveryEmail.address'),
                subtitle: status.email,
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (stage == RecoveryEmailStage.pending)
          Text(
            trArgs(context, 'recoveryEmail.pendingHelp', {
              'address': status.email,
            }),
            style: rmText(14, color: c.ink2, height: 1.45),
          ),
        if (stage == RecoveryEmailStage.verified)
          Text(
            tr(context, 'recoveryEmail.verifiedHelp'),
            style: rmText(14, color: c.ink2, height: 1.45),
          ),
        if (_state.linkSent) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              tr(context, 'recoveryEmail.sent'),
              style: rmText(14, color: c.ink, height: 1.45),
            ),
          ),
        ],
        const SizedBox(height: 18),
        if (stage == RecoveryEmailStage.none || _editing)
          _form(context, stage)
        else ...[
          if (stage == RecoveryEmailStage.pending)
            TextButton(
              onPressed: _state.loading ? null : () => unawaited(_state.load()),
              child: Text(tr(context, 'recoveryEmail.check')),
            ),
          TextButton(
            onPressed: () =>
                _edit(stage == RecoveryEmailStage.pending ? status.email : ''),
            child: Text(
              tr(
                context,
                stage == RecoveryEmailStage.pending
                    ? 'recoveryEmail.resend'
                    : 'recoveryEmail.change',
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _state.status;
    final loadError = _state.loadError;
    // A server without this route answers 404: there is nothing to retry.
    final unsupported = loadError?.statusCode == 404;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'recoveryEmail.title'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    tr(context, 'recoveryEmail.help'),
                    style: rmText(15, color: context.rm.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  if (status != null && !unsupported) _loaded(context, status),
                  if (status == null && _state.loading)
                    Semantics(
                      liveRegion: true,
                      child: Text(tr(context, 'recoveryEmail.loading')),
                    ),
                  if (unsupported)
                    ErrorText(tr(context, 'recoveryEmail.unsupported'))
                  else if (loadError != null) ...[
                    const SizedBox(height: 12),
                    ErrorText(tr(context, 'recoveryEmail.loadFailed')),
                    ErrorText(
                      describeError(
                        context,
                        loadError,
                        host: widget.client.server.host,
                      ),
                    ),
                    TextButton(
                      onPressed: _state.loading
                          ? null
                          : () => unawaited(_state.load()),
                      child: Text(tr(context, 'recoveryEmail.retry')),
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
