import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_scope.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// Choosing a server by hand: an address, checked against rest-mail's health
/// endpoint before it can be used. Pops with the server's base URL.
class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key, this.initial});

  final Uri? initial;

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  late final _address = TextEditingController(text: _display(widget.initial));
  bool _checking = false;
  Uri? _verified;
  ({bool ok, String text})? _result;

  static String _display(Uri? server) {
    if (server == null) return '';
    final text = server.toString();
    return text.startsWith('https://')
        ? text.substring('https://'.length)
        : text;
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    final Uri server;
    try {
      server = parseServerUrl(_address.text);
    } on FormatException catch (e) {
      setState(() {
        _verified = null;
        _result = (ok: false, text: e.message);
      });
      return;
    }
    setState(() {
      _checking = true;
      _result = null;
      _verified = null;
    });
    final probe = AppScope.read(context).probe(server);
    final watch = Stopwatch()..start();
    try {
      final health = await probe.health();
      if (!mounted) return;
      setState(() {
        _verified = health.isHealthy ? server : null;
        _result = health.isHealthy
            ? (
                ok: true,
                text:
                    'Connection verified — ${watch.elapsedMilliseconds} ms, rest-mail is healthy.',
              )
            : (
                ok: false,
                text: 'rest-mail answered but reports "${health.status}".',
              );
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(
        () => _result = (ok: false, text: describeError(e, host: server.host)),
      );
    } finally {
      probe.close();
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final result = _result, verified = _verified;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Server',
              onBack: () => Navigator.pop(context),
              trailingText: 'Test',
              onTrailing: _checking ? null : () => unawaited(_test()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                children: [
                  const SectionLabel('rest-mail server'),
                  const SizedBox(height: 10),
                  RmGroup(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Text('Address', style: rmText(14, color: c.ink2)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _address,
                                autofocus: widget.initial == null,
                                keyboardType: TextInputType.url,
                                autocorrect: false,
                                enableSuggestions: false,
                                textAlign: TextAlign.end,
                                textInputAction: TextInputAction.go,
                                onChanged: (_) => setState(() {
                                  _verified = null;
                                  _result = null;
                                }),
                                onSubmitted: (_) => unawaited(_test()),
                                style: rmText(
                                  14,
                                  color: c.ink,
                                  weight: FontWeight.w600,
                                ),
                                decoration: bareInput(
                                  context,
                                  'mail.example.com',
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const RmRow(label: 'Protocol', value: 'HTTPS · REST'),
                      const RmRow(label: 'API', value: '/api/v1'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_checking)
                    const _Status(color: null, text: 'Checking…')
                  else if (result != null)
                    _Status(
                      color: result.ok ? c.good : c.danger,
                      text: result.text,
                    ),
                  const SizedBox(height: 24),
                  RmPrimaryButton(
                    label: 'Use this server',
                    onPressed: verified == null
                        ? null
                        : () => Navigator.pop(context, verified),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The app only talks to servers over HTTPS; a plain http:// address is refused.',
                    textAlign: TextAlign.center,
                    style: rmText(12.5, color: c.ink3, height: 1.4),
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

class _Status extends StatelessWidget {
  const _Status({required this.color, required this.text});

  /// Null while the check is running.
  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final color = this.color;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: color == null
                ? SizedBox.square(
                    dimension: 8,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: c.ink3,
                    ),
                  )
                : Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: rmText(13, color: c.ink2, height: 1.45)),
          ),
        ],
      ),
    );
  }
}
