import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';

void main() {
  testWidgets('an obscured paste field submits exact PEM text', (tester) async {
    const pem =
        '-----BEGIN PRIVATE KEY-----\nComment: keep this header\n\nYWJjZA==\n-----END PRIVATE KEY-----\n';
    String? submitted;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.getData'
          ? <String, Object>{'text': pem}
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
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
                    title: 'Key',
                    fields: const [
                      AdminField('Private key', obscure: true, pasteOnly: true),
                    ],
                    action: 'Save',
                    host: 'fixture.test',
                    submit: (values) async {
                      submitted = values.single;
                    },
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
    await tester.tap(find.text('Paste'));
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
    expect(field.readOnly, isTrue);
    expect(field.controller!.text, pem);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(submitted, pem);
  });
}
