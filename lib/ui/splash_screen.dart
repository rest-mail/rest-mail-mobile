import 'package:flutter/material.dart';

import '../l10n/voice.dart';
import '../theme/packs.dart';
import '../theme/tokens.dart';
import 'widgets/avatar.dart';

/// What the app shows while it opens: the mark on the pack's loud note, the
/// wordmark in the pack's typeface, and a bar that sweeps until the session
/// settles. `app.dart` keeps it on screen for at least a beat, so a fast boot
/// reads as an intention rather than a flicker.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.pack});

  /// Whose voice the tagline speaks in.
  final ThemePack pack;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _rise = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );
  late final AnimationController _sweep = AnimationController(
    duration: const Duration(milliseconds: 1100),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _rise.forward();
    _sweep.repeat();
  }

  @override
  void dispose() {
    _rise.dispose();
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final v = widget.pack.variants;
    final family = typefaceFamily(v.listType);
    final weight = switch (v.listType) {
      Typeface.serif => FontWeight.w500,
      Typeface.mono => FontWeight.w700,
      Typeface.sans => FontWeight.w800,
    };
    return Scaffold(
      backgroundColor: c.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _rise,
                curve: const Interval(0, 0.7, curve: Curves.easeOut),
              ),
              child: const LogoMark(size: 64),
            ),
            const SizedBox(height: 14),
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _rise,
                curve: const Interval(0.15, 0.85, curve: Curves.easeOut),
              ),
              child: Text(
                v.listType == Typeface.mono ? 'rest-mail' : 'REST MAIL',
                style: rmText(
                  22,
                  color: c.ink,
                  weight: weight,
                  tracking: v.listType == Typeface.serif ? 0 : -0.03,
                  family: family,
                ),
              ),
            ),
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _rise,
                curve: const Interval(0.3, 1, curve: Curves.easeOut),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  voiceLine(
                    widget.pack,
                    Localizations.localeOf(context),
                    'splash.tagline',
                  ),
                  style: rmText(
                    11,
                    color: c.ink3,
                    family: family,
                    italic: v.listType == Typeface.serif,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 112,
              height: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LayoutBuilder(
                  builder: (context, constraints) => AnimatedBuilder(
                    animation: _sweep,
                    builder: (context, _) {
                      final segment = constraints.maxWidth * 0.34;
                      final travel = constraints.maxWidth + segment;
                      final x =
                          -segment +
                          travel * Curves.easeInOut.transform(_sweep.value);
                      return Stack(
                        children: [
                          const Positioned.fill(child: _Track()),
                          Positioned(
                            left: x,
                            top: 0,
                            bottom: 0,
                            width: segment,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: c.accent,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Track extends StatelessWidget {
  const _Track();

  @override
  Widget build(BuildContext context) => ColoredBox(color: context.rm.line);
}
