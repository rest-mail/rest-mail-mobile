import 'dart:async';

import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../util/sign_in_link.dart';
import 'server_screen.dart';
import 'server_setup_screen.dart';

/// Starts setting a server up when the app is opened with a sign-in link, from
/// the QR code the installer showed: on the server the link names, or, when it
/// names none, the one the owner picks next. The sign-in is filled in.
class SetupLinkHandler extends StatefulWidget {
  const SetupLinkHandler({super.key, required this.child});

  final Widget child;

  @override
  State<SetupLinkHandler> createState() => _SetupLinkHandlerState();
}

class _SetupLinkHandlerState extends State<SetupLinkHandler> {
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (state.pendingSetup != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final scan = state.takePendingSetup();
        if (scan != null && mounted) unawaited(_start(scan));
      });
    }
    return widget.child;
  }

  Future<void> _start(SignInLink scan) async {
    final server =
        scan.server ??
        await Navigator.push<Uri>(
          context,
          MaterialPageRoute(builder: (_) => const ServerScreen()),
        );
    if (server == null || !mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ServerSetupScreen(
          server: server,
          address: scan.address,
          password: scan.password,
        ),
      ),
    );
  }
}
