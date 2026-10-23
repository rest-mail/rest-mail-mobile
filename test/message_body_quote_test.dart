import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/widgets/message_body.dart';
import 'package:restmail_api/restmail_api.dart';

Message _message({String? text, String? html}) => Message.fromJson({
  'id': 9,
  'mailbox_id': 1,
  'folder': 'INBOX',
  'sender': 'bob@example.test',
  'recipients_to': ['ada@example.test'],
  'subject': 'Lunch',
  'body_text': ?text,
  'body_html': ?html,
  'received_at': '2026-09-10T10:00:00Z',
});

Future<void> _show(WidgetTester tester, Message message) => tester.pumpWidget(
  MaterialApp(
    theme: ThemeData(extensions: const [RmColors.light, RmVariants()]),
    home: Scaffold(
      body: SingleChildScrollView(
        child: MessageBody(message: message, onOpenLink: (_) {}),
      ),
    ),
  ),
);

bool _shows(String text) => find
    .byWidgetPredicate(
      (w) =>
          (w is SelectableText && (w.data ?? '').contains(text)) ||
          (w is RichText && w.text.toPlainText().contains(text)),
    )
    .evaluate()
    .isNotEmpty;

void main() {
  testWidgets('a plain reply folds its quote, and shows it again', (
    tester,
  ) async {
    await _show(
      tester,
      _message(
        text:
            'See you at noon.\n\nOn Mon, Ann wrote:\n> Shall we meet?\n> Ann\n',
      ),
    );
    expect(_shows('See you at noon.'), isTrue);
    expect(_shows('Shall we meet?'), isFalse);
    await tester.tap(find.text('Show quoted text'));
    await tester.pumpAndSettle();
    expect(_shows('Shall we meet?'), isTrue);
    expect(_shows('See you at noon.'), isTrue);
    await tester.tap(find.text('Hide quoted text'));
    await tester.pumpAndSettle();
    expect(_shows('Shall we meet?'), isFalse);
  });

  testWidgets('a top-posted HTML reply folds the message under it', (
    tester,
  ) async {
    await _show(
      tester,
      _message(
        html:
            '<div>Approved.</div><div id="appendonsend"></div><hr>'
            '<div id="divRplyFwdMsg"><b>From:</b> Ann</div>'
            '<div>Please approve the invoice.</div>',
      ),
    );
    await tester.pumpAndSettle();
    expect(_shows('Approved.'), isTrue);
    expect(_shows('Please approve the invoice.'), isFalse);
    await tester.tap(find.text('Show quoted text'));
    await tester.pumpAndSettle();
    expect(_shows('Please approve the invoice.'), isTrue);
  });

  testWidgets('a message with no quote has nothing to fold', (tester) async {
    await _show(tester, _message(text: 'Hello,\n\nNo quoting here.'));
    expect(_shows('No quoting here.'), isTrue);
    expect(find.text('Show quoted text'), findsNothing);
  });
}
