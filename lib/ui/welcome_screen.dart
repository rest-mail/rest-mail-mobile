import 'dart:async';

import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/tokens.dart';
import 'add_account_screen.dart';
import 'server_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final reason = AppScope.of(context).signedOutReason;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(26, 44, 26, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const LogoMark(),
                          const SizedBox(width: 10),
                          Text(
                            'rest-mail',
                            style: rmText(
                              19,
                              color: c.ink,
                              weight: FontWeight.w800,
                              tracking: -0.03,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 290),
                          child: Text(
                            'Mail that keeps up with you.',
                            style: rmText(
                              40,
                              color: c.ink,
                              weight: FontWeight.w800,
                              height: 1.02,
                              tracking: -0.045,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(
                            'A native client for your rest-mail server. New mail shows up the moment it lands.',
                            style: rmText(16, color: c.ink2, height: 1.45),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (reason != null) ...[
                        _Notice(reason),
                        const SizedBox(height: 18),
                      ],
                      const Padding(
                        padding: EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            _Stat(value: 'Live', label: 'pushed, never polled'),
                            SizedBox(width: 22),
                            _Stat(
                              value: 'TLS',
                              label: 'or it will not connect',
                            ),
                          ],
                        ),
                      ),
                      RmPrimaryButton(
                        label: 'Add an account',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const AddAccountScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RmOutlineButton(
                        label: 'Enter a server address',
                        onPressed: () => unawaited(_chooseServerFirst(context)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _chooseServerFirst(BuildContext context) async {
    final server = await Navigator.push<Uri>(
      context,
      MaterialPageRoute(builder: (_) => const ServerScreen()),
    );
    if (server == null || !context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => AddAccountScreen(server: server)),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: rmText(
            22,
            color: c.ink,
            weight: FontWeight.w800,
            tracking: -0.03,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: rmText(12, color: c.ink3)),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: c.tintAmber,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: rmText(13.5, color: c.ink2, height: 1.45)),
          ),
        ],
      ),
    );
  }
}
