import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'add_account_screen.dart';
import 'server_screen.dart';
import 'server_setup_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 18),
                        // Each stat takes half the width and wraps inside it,
                        // so large text sizes cannot push the row off screen.
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _Stat(
                                value: 'Live',
                                label: 'pushed, never polled',
                              ),
                            ),
                            SizedBox(width: 22),
                            Expanded(
                              child: _Stat(
                                value: 'TLS',
                                label: 'or it will not connect',
                              ),
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
                      const SizedBox(height: 6),
                      Center(
                        child: TextButton(
                          onPressed: () => unawaited(_setUpServer(context)),
                          child: Text(
                            'Set up a new server',
                            style: rmText(
                              13.5,
                              color: c.accent,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
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

  /// A server just installed has one account, `admin@` its domain, which
  /// must choose its own password and enroll an authenticator before it
  /// reads its mail.
  Future<void> _setUpServer(BuildContext context) async {
    final server = await Navigator.push<Uri>(
      context,
      MaterialPageRoute(builder: (_) => const ServerScreen()),
    );
    if (server == null || !context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ServerSetupScreen(server: server),
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
