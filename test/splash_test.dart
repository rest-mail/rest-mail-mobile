import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/theme/theme.dart';
import 'package:restmail/ui/splash_screen.dart';

void main() {
  for (final pack in ThemePack.all) {
    testWidgets('the splash speaks ${pack.name}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(pack, Brightness.light),
          home: const SplashScreen(),
        ),
      );
      // Let the rise finish so every faded-in piece is present.
      await tester.pump(const Duration(milliseconds: 700));

      expect(
        find.text(
          pack.variants.listType == Typeface.mono ? 'rest-mail' : 'REST MAIL',
        ),
        findsOneWidget,
      );
      expect(find.text('// opening_your_mail'), findsOneWidget);
    });
  }

  testWidgets('the sweep keeps moving', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(ThemePack.classic, Brightness.light),
        home: const SplashScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));
    final segment = find.byType(DecoratedBox).last;
    final before = tester.getTopLeft(segment);
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getTopLeft(segment), isNot(before));
  });
}
