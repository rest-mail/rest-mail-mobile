import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/widgets/common.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('segmented choices fit width $width at text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        var selected = 0;
        const options = [(0, 'Authenticator'), (1, 'Recovery code')];
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: const [RmColors.light]),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(22),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: StatefulBuilder(
                    builder: (context, setState) => RmSegmented<int>(
                      options: options,
                      value: selected,
                      onChanged: (value) => setState(() => selected = value),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        for (final (value, label) in options) {
          final rect = tester.getRect(find.text(label));
          expect(rect.left, greaterThanOrEqualTo(22));
          expect(rect.right, lessThanOrEqualTo(width - 22));
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          expect(selected, value);
          expect(tester.takeException(), isNull);
        }
      });
    }
  }

  testWidgets('segmented choices share a row when there is room', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [RmColors.light]),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RmSegmented<int>(
              options: const [(0, 'Authenticator'), (1, 'Recovery code')],
              value: 0,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getRect(find.text('Authenticator')).top,
      tester.getRect(find.text('Recovery code')).top,
    );
    expect(tester.takeException(), isNull);
  });
}
