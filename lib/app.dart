import 'dart:async';

import 'package:flutter/material.dart';

import 'state/app_scope.dart';
import 'state/app_state.dart';
import 'theme/theme.dart';
import 'theme/tokens.dart';
import 'ui/mailbox_screen.dart';
import 'ui/setup_link_handler.dart';
import 'ui/welcome_screen.dart';
import 'ui/widgets/avatar.dart';

class RestmailApp extends StatefulWidget {
  const RestmailApp({super.key, required this.state});

  final AppState state;

  @override
  State<RestmailApp> createState() => _RestmailAppState();
}

class _RestmailAppState extends State<RestmailApp> {
  late final StreamSubscription<String> _notices;

  /// A new one with each navigator, so a snackbar from the account going
  /// away (an Undo, say) isn't carried over to the next one.
  var _messenger = GlobalKey<ScaffoldMessengerState>();
  Object? _messengerSession;

  @override
  void initState() {
    super.initState();
    // After the frame, so a notice that came with a change of account lands
    // on the new account's screen rather than the one going away.
    _notices = widget.state.notices.listen((notice) {
      WidgetsBinding.instance
        ..addPostFrameCallback(
          (_) => _messenger.currentState?.showSnackBar(
            SnackBar(content: Text(notice)),
          ),
        )
        ..ensureVisualUpdate();
    });
  }

  @override
  void dispose() {
    unawaited(_notices.cancel());
    super.dispose();
  }

  GlobalKey<ScaffoldMessengerState> _messengerFor(Object session) {
    if (session != _messengerSession) {
      _messengerSession = session;
      _messenger = GlobalKey<ScaffoldMessengerState>();
    }
    return _messenger;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return AppScope(
      state: state,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => MaterialApp(
          // A new session, or the end of one, starts a fresh navigator, so no
          // screen from the old session is left on the stack.
          key: ValueKey(state.sessionKey),
          scaffoldMessengerKey: _messengerFor(state.sessionKey),
          title: 'rest-mail',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: state.settings.themeMode,
          home: switch (state.phase) {
            AppPhase.starting => const _Launch(),
            AppPhase.signedOut => const SetupLinkHandler(
              child: WelcomeScreen(),
            ),
            AppPhase.signedIn => SetupLinkHandler(
              child: MailboxScreen(mailbox: state.mailbox!),
            ),
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
