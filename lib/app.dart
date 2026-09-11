import 'package:flutter/material.dart';

import 'state/app_scope.dart';
import 'state/app_state.dart';
import 'theme/theme.dart';
import 'theme/tokens.dart';
import 'ui/mailbox_screen.dart';
import 'ui/welcome_screen.dart';
import 'ui/widgets/avatar.dart';

class RestmailApp extends StatelessWidget {
  const RestmailApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => MaterialApp(
          // A new session, or the end of one, starts a fresh navigator, so no
          // screen from the old session is left on the stack.
          key: ValueKey(state.sessionKey),
          title: 'rest-mail',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: state.settings.themeMode,
          home: switch (state.phase) {
            AppPhase.starting => const _Launch(),
            AppPhase.signedOut => const WelcomeScreen(),
            AppPhase.signedIn => MailboxScreen(mailbox: state.mailbox!),
          },
        ),
      ),
    );
  }
}

class _Launch extends StatelessWidget {
  const _Launch();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.rm.bg,
    body: const Center(child: LogoMark(size: 44)),
  );
}
