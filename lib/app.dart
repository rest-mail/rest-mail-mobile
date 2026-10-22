import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/voice.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';
import 'theme/packs.dart';
import 'theme/theme.dart';
import 'ui/mailbox_screen.dart';
import 'ui/push_offer.dart';
import 'ui/setup_link_handler.dart';
import 'ui/splash_screen.dart';
import 'ui/welcome_screen.dart';
import 'ui/whats_new_screen.dart';
import 'version.dart';

class RestmailApp extends StatefulWidget {
  const RestmailApp({super.key, required this.state});

  final AppState state;

  @override
  State<RestmailApp> createState() => _RestmailAppState();
}

class _RestmailAppState extends State<RestmailApp> with WidgetsBindingObserver {
  late final StreamSubscription<String> _notices;

  /// A new one with each navigator, so a snackbar from the account going
  /// away (an Undo, say) isn't carried over to the next one.
  var _messenger = GlobalKey<ScaffoldMessengerState>();
  Object? _messengerSession;

  @override
  void initState() {
    super.initState();
    // Notifications leave out the inbox on screen, and the badge takes the
    // count the app last showed.
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null) didChangeAppLifecycleState(lifecycle);
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
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_notices.cancel());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) => widget
      .state
      .push
      .lifecycleChanged(onScreen: lifecycle == AppLifecycleState.resumed);

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
        // The pack lives in the settings, so read it inside the builder:
        // picking a theme in Settings must rebuild the MaterialApp.
        builder: (context, _) {
          final pack = ThemePack.byId(state.settings.packId);
          return MaterialApp(
            // A new session, or the end of one, starts a fresh navigator, so no
            // screen from the old session is left on the stack.
            key: ValueKey(state.sessionKey),
            scaffoldMessengerKey: _messengerFor(state.sessionKey),
            title: 'rest-mail',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(pack, Brightness.light),
            darkTheme: buildTheme(pack, Brightness.dark),
            themeMode: state.settings.themeMode,
            locale: state.settings.languageCode == 'system'
                ? null
                : Locale(state.settings.languageCode),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: supportedLocales,
            home: switch (state.phase) {
              AppPhase.starting => SplashScreen(pack: pack),
              AppPhase.signedOut => const SetupLinkHandler(
                child: WelcomeScreen(),
              ),
              AppPhase.signedIn => SetupLinkHandler(
                child: PushOffer(
                  child: state.mailbox != null
                      ? const _WhatsNewGate(child: MailboxScreen())
                      : SplashScreen(pack: pack),
                ),
              ),
            },
          );
        },
      ),
    );
  }
}

/// Release builds open What's New once for a new version. It sits inside the
/// navigator, so it needs no global key, and debug/test builds never push it
/// in front of what they are doing.
class _WhatsNewGate extends StatefulWidget {
  const _WhatsNewGate({required this.child});

  final Widget child;

  @override
  State<_WhatsNewGate> createState() => _WhatsNewGateState();
}

class _WhatsNewGateState extends State<_WhatsNewGate> {
  static const _announceUpdates = bool.fromEnvironment('dart.vm.product');
  bool _checked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_checked) return;
    _checked = true;
    final state = AppScope.read(context);
    if (!_announceUpdates ||
        appVersion == 'dev' ||
        state.settings.lastSeenVersion == appVersion) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const WhatsNewScreen(markSeen: true),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
