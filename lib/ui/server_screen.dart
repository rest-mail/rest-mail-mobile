import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
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
        _result = (
          ok: false,
          text: switch (e) {
            ServerUrlFormatException(reason: ServerUrlReason.empty) => tr(
              context,
              'server.enterAddress',
            ),
            ServerUrlFormatException(reason: ServerUrlReason.httpsRequired) =>
              tr(context, 'server.httpsRequired'),
            _ => trArgs(context, 'server.invalidAddress', {
              'address': _address.text.trim(),
            }),
          },
        );
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
                text: trArgs(context, 'server.verified', {
                  'ms': '${watch.elapsedMilliseconds}',
                }),
              )
            : (
                ok: false,
                text: trArgs(context, 'server.unhealthy', {
                  'status': health.status,
                }),
              );
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(
        () => _result = (
          ok: false,
          text: describeError(context, e, host: server.host),
        ),
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
              title: tr(context, 'server.title'),
              onBack: () => Navigator.pop(context),
              trailingText: tr(context, 'server.test'),
              onTrailing: _checking ? null : () => unawaited(_test()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                children: [
                  SectionLabel(tr(context, 'server.section')),
                  const SizedBox(height: 10),
                  RmGroup(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Text(
                              tr(context, 'server.address'),
                              style: rmText(14, color: c.ink2),
                            ),
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
                      RmRow(
                        label: tr(context, 'server.protocol'),
                        value: 'HTTPS · REST',
                      ),
                      const RmRow(label: 'API', value: '/api/v1'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_checking)
                    _Status(color: null, text: tr(context, 'server.checking'))
                  else if (result != null)
                    _Status(
                      color: result.ok ? c.good : c.danger,
                      text: result.text,
                    ),
                  const SizedBox(height: 24),
                  RmPrimaryButton(
                    label: tr(context, 'server.use'),
                    onPressed: verified == null
                        ? null
                        : () => Navigator.pop(context, verified),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'server.httpsOnly'),
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
