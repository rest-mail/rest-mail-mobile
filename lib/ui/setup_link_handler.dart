import 'dart:async';

import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../util/setup_code.dart';
import 'server_screen.dart';
import 'server_setup_screen.dart';

/// Starts setting a server up when the app is opened with a setup link: on
/// the server the link names, or, when it names none (the link a server
/// prints does not know its own address), the one the owner picks next.
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

  Future<void> _start(SetupCodeScan scan) async {
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
        builder: (_) => ServerSetupScreen(server: server, setupCode: scan.code),
      ),
    );
  }
}
