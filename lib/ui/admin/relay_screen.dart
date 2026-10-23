import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _tlsLabel(RelayTlsMode mode) => switch (mode) {
  RelayTlsMode.starttls => 'STARTTLS',
  RelayTlsMode.implicit => 'TLS',
};

/// How a domain's outgoing mail leaves the server: straight to each
/// recipient's mail servers, or through an SMTP relay. The relay password
/// is never shown; the server only says whether it holds one.
class RelayScreen extends StatefulWidget {
  const RelayScreen({super.key, required this.account, required this.domain});

  final RestAccount account;
  final AdminDomain domain;

  @override
  State<RelayScreen> createState() => _RelayScreenState();
}

class _RelayScreenState extends State<RelayScreen> {
  DomainRelay? _relay;
  ApiException? _loadError;
  String? _error;
  var _busy = false;

  var _transport = OutboundTransport.direct;
  var _tls = RelayTlsMode.starttls;
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  String get _server => widget.account.server.host;
  String get _name => widget.domain.name;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.relay)) {
      unawaited(_load());
    }
  }

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _show(DomainRelay relay) {
    _relay = relay;
    _transport = relay.transport;
    _tls = relay.tlsMode ?? RelayTlsMode.starttls;
    _host.text = relay.host;
    _port.text = relay.port?.toString() ?? '';
    _username.text = relay.username;
    _password.clear();
  }

  Future<void> _load() async {
    try {
      final relay = await widget.account.client.domainRelay(widget.domain.id);
      if (mounted) {
        setState(() {
          _show(relay);
          _loadError = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e);
    }
  }

  /// The password to send: left out keeps the saved one, empty clears it.
  String? get _passwordToSend {
    final username = _username.text.trim();
    if (username.isEmpty) return '';
    if (_password.text.isNotEmpty) return _password.text;
    return null;
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final relay = _transport == OutboundTransport.relay;
      final saved = await widget.account.client.setDomainRelay(
        widget.domain.id,
        transport: _transport,
        host: relay ? _host.text.trim() : '',
        port: relay ? int.tryParse(_port.text.trim()) : null,
        tlsMode: relay ? _tls : null,
        username: relay ? _username.text.trim() : '',
        password: relay ? _passwordToSend : null,
      );
      if (!mounted) return;
      setState(() {
        _busy = false;
        _show(saved);
      });
      showToast(context, 'Saved outgoing mail for $_name');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = describeAdminError(e, host: _server);
      });
    }
  }

  Widget _field(
    TextEditingController controller, {
    String? hint,
    TextInputType? keyboard,
    bool obscure = false,
  }) {
    final c = context.rm;
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: (_) => setState(() => _error = null),
      style: rmText(16, color: c.ink),
      decoration: InputDecoration(hintText: hint),
    );
  }

  Widget _readOnly(DomainRelay relay) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
    children: [
      RmGroup(
        children: [
          RmRow(
            label: 'Sent',
            value: relay.transport == OutboundTransport.relay
                ? 'Through a relay'
                : 'Straight to other servers',
          ),
          if (relay.transport == OutboundTransport.relay) ...[
            RmRow(label: 'Relay', value: relay.host),
            if (relay.port case final port?)
              RmRow(label: 'Port', value: '$port'),
            if (relay.tlsMode case final tls?)
              RmRow(label: 'Security', value: _tlsLabel(tls)),
            RmRow(
              label: 'Signs in as',
              value: relay.username.isEmpty ? 'Nobody' : relay.username,
            ),
            if (relay.username.isNotEmpty)
              RmRow(
                label: 'Password',
                value: relay.passwordSet ? 'Saved' : 'None',
              ),
          ],
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final relay = _relay, loadError = _loadError, error = _error;
    return AdminPage(
      account: widget.account,
      section: AdminSection.relay,
      title: 'Outgoing mail',
      body: (access) {
        if (loadError != null) {
          return AdminMessage(
            describeAdminError(loadError, host: _server),
            onRetry: () => unawaited(_load()),
          );
        }
        if (relay == null) {
          return const Center(
            child: SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (!access.canWrite(AdminSection.relay)) return _readOnly(relay);
        final viaRelay = _transport == OutboundTransport.relay;
        return ListView(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
          children: [
            Text(
              'How mail from $_name leaves the server.',
              style: rmText(15, color: c.ink2, height: 1.45),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: RmSegmented<OutboundTransport>(
                options: const [
                  (OutboundTransport.direct, 'Direct'),
                  (OutboundTransport.relay, 'Relay'),
                ],
                value: _transport,
                onChanged: (transport) => setState(() {
                  _transport = transport;
                  _error = null;
                }),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viaRelay
                  ? 'Handed to an SMTP relay, which delivers it.'
                  : "Sent straight to each recipient's mail servers.",
              style: rmText(13, color: c.ink3, height: 1.4),
            ),
            if (viaRelay) ...[
              const SizedBox(height: 18),
              const SectionLabel('Relay'),
              const SizedBox(height: 8),
              _field(
                _host,
                hint: 'smtp.example.com',
                keyboard: TextInputType.url,
              ),
              const SizedBox(height: 18),
              const SectionLabel('Port'),
              const SizedBox(height: 8),
              _field(_port, hint: '587', keyboard: TextInputType.number),
              const SizedBox(height: 18),
              const SectionLabel('Security'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: RmSegmented<RelayTlsMode>(
                  options: [
                    for (final mode in RelayTlsMode.values)
                      (mode, _tlsLabel(mode)),
                  ],
                  value: _tls,
                  onChanged: (mode) => setState(() => _tls = mode),
                ),
              ),
              const SizedBox(height: 18),
              const SectionLabel('Username'),
              const SizedBox(height: 8),
              _field(_username, hint: 'Optional'),
              const SizedBox(height: 18),
              const SectionLabel('Password'),
              const SizedBox(height: 8),
              _field(
                _password,
                hint: relay.passwordSet
                    ? 'Saved. Leave empty to keep it'
                    : 'Needed with a username',
                obscure: true,
              ),
              const SizedBox(height: 8),
              Text(
                'A username and a password go together. Clear the username to '
                'remove both.',
                style: rmText(13, color: c.ink3, height: 1.4),
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 16),
              ErrorText(error),
            ],
            const SizedBox(height: 26),
            RmPrimaryButton(
              label: 'Save',
              busy: _busy,
              onPressed: _busy ? null : () => unawaited(_save()),
            ),
          ],
        );
      },
    );
  }
}
