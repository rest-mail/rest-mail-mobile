import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
import 'package:restmail/ui/widgets/common.dart';

void main() {
  const choices = [('', 'None'), ('bulk', 'Bulk')];
  Future<void> open(
    WidgetTester tester,
    List<AdminField> fields,
    Future<void> Function(List<String>) submit,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [RmColors.light]),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminFormScreen(
                    title: 'Options',
                    fields: fields,
                    action: 'Apply',
                    submit: submit,
                    host: 'fixture.test',
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  RmPrimaryButton action(WidgetTester tester) =>
      tester.widget<RmPrimaryButton>(find.byType(RmPrimaryButton));

  testWidgets(
    'a valid empty choice allows submission but required text still needs input',
    (tester) async {
      List<String>? submitted;
      await open(
        tester,
        const [
          AdminField('Domain'),
          AdminField('Sending policy', choices: choices),
          AdminField('Quota', optional: true),
        ],
        (values) async {
          submitted = values;
        },
      );
      expect(action(tester).onPressed, isNull);
      await tester.enterText(find.byType(TextField).first, 'new.test');
      await tester.pump();
      expect(action(tester).onPressed, isNotNull);
      await tester.ensureVisible(find.text('Apply'));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(submitted, ['new.test', '', '']);
    },
  );

  testWidgets(
    'changing a nonempty choice to None submits an explicit empty value',
    (tester) async {
      List<String>? submitted;
      await open(
        tester,
        const [AdminField('Sending policy', initial: 'bulk', choices: choices)],
        (values) async {
          submitted = values;
        },
      );
      await tester.tap(find.text('None'));
      await tester.pump();
      expect(action(tester).onPressed, isNotNull);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(submitted, ['']);
    },
  );

  testWidgets('a choice must match an allowed value', (tester) async {
    List<String>? submitted;
    await open(
      tester,
      const [
        AdminField('Sending policy', initial: 'unknown', choices: choices),
      ],
      (values) async {
        submitted = values;
      },
    );
    expect(action(tester).onPressed, isNull);
    await tester.tap(find.text('None'));
    await tester.pump();
    expect(action(tester).onPressed, isNotNull);
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(submitted, ['']);
  });
}
