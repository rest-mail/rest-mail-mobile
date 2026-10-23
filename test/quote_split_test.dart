import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/util/quote_split.dart';

void main() {
  group('plain text', () {
    test('a reply above its quote folds the quote and its attribution', () {
      const text =
          'Sounds good, see you then.\n'
          '\n'
          'On Mon, 3 Oct 2026 at 10:00, Ann <ann@example.com> wrote:\n'
          '> Shall we meet at noon?\n'
          '> \n'
          '> Ann\n';
      final split = splitPlainQuote(text);
      expect(split.body, 'Sounds good, see you then.');
      expect(
        split.quote,
        'On Mon, 3 Oct 2026 at 10:00, Ann <ann@example.com> wrote:\n'
        '> Shall we meet at noon?\n'
        '> \n'
        '> Ann',
      );
    });

    test('an attribution wrapped onto a second line goes with it', () {
      const text =
          'Yes.\n'
          '\n'
          'On Mon, 3 Oct 2026 at 10:00, Ann Longname <ann@example.com>\n'
          'wrote:\n'
          '> Shall we?\n';
      final split = splitPlainQuote(text);
      expect(split.body, 'Yes.');
      expect(split.quote!.startsWith('On Mon'), isTrue);
    });

    test('a top-posted reply above Outlook\'s separator folds the rest', () {
      const text =
          'Approved.\n'
          '\n'
          '-----Original Message-----\n'
          'From: Ann <ann@example.com>\n'
          'Sent: Monday\n'
          '\n'
          'Please approve the invoice.\n';
      final split = splitPlainQuote(text);
      expect(split.body, 'Approved.');
      expect(split.quote!.startsWith('-----Original Message-----'), isTrue);
      expect(split.quote, contains('Please approve the invoice.'));
    });

    test('a message with no quote is left whole', () {
      const text = 'Hello,\n\nNo quoting here.\n';
      final split = splitPlainQuote(text);
      expect(split.body, text);
      expect(split.quote, isNull);
    });

    test('an inline reply, new text after the quote, is left whole', () {
      const text =
          '> Shall we meet at noon?\n'
          'Yes, noon works.\n'
          '> And lunch after?\n'
          'Sure.\n';
      expect(splitPlainQuote(text).quote, isNull);
    });

    test('a message that is only a quote is not folded away', () {
      const text = '> Shall we meet at noon?\n> Ann\n';
      final split = splitPlainQuote(text);
      expect(split.quote, isNull);
      expect(split.body, text);
    });

    test('nothing is lost: body and quote together are the message', () {
      const text = 'Thanks!\n\nOn Tue, Bo wrote:\n> first\n> second\n';
      final split = splitPlainQuote(text);
      expect('${split.body}\n\n${split.quote}', text.trimRight());
    });
  });

  group('HTML', () {
    test("Gmail's gmail_quote, attribution inside, folds", () {
      const html =
          '<div dir="ltr">See you then.</div><br>'
          '<div class="gmail_quote"><div class="gmail_attr">On Mon, Ann '
          'wrote:<br></div><blockquote class="gmail_quote">Noon?'
          '</blockquote></div>';
      final split = splitHtmlQuote(html);
      expect(split.body, contains('See you then.'));
      expect(split.body, isNot(contains('Noon?')));
      expect(split.quote, contains('Noon?'));
      expect(split.quote, contains('On Mon, Ann wrote:'));
    });

    test('a trailing blockquote takes the attribution above it', () {
      const html =
          '<p>Yes.</p><p>On Mon, Ann wrote:</p>'
          '<blockquote><p>Noon?</p></blockquote>';
      final split = splitHtmlQuote(html);
      expect(split.body, '<p>Yes.</p>');
      expect(split.quote, startsWith('<p>On Mon, Ann wrote:</p>'));
    });

    test("Apple Mail's wrapped cite folds", () {
      const html =
          '<div>Sure.</div><div><br>'
          '<blockquote type="cite"><div>On Mon, Ann wrote:</div>'
          '<div>Noon?</div></blockquote></div>';
      final split = splitHtmlQuote(html);
      expect(split.body, '<div>Sure.</div>');
      expect(split.quote, contains('Noon?'));
    });

    test('a top-posted Outlook reply folds from its rule and header on', () {
      const html =
          '<div>Approved.</div><div id="appendonsend"></div><hr>'
          '<div id="divRplyFwdMsg"><b>From:</b> Ann</div>'
          '<div>Please approve the invoice.</div>';
      final split = splitHtmlQuote(html);
      expect(split.body, '<div>Approved.</div>');
      expect(split.quote, contains('Please approve the invoice.'));
      expect(split.quote, contains('divRplyFwdMsg'));
    });

    test('a quote in the middle, with new text after it, is left whole', () {
      const html =
          '<blockquote>Noon?</blockquote><p>Yes.</p>'
          '<blockquote>Lunch?</blockquote><p>Sure.</p>';
      expect(splitHtmlQuote(html).quote, isNull);
    });

    test('no quote, or only a quote: left whole', () {
      expect(splitHtmlQuote('<p>Hello</p>').quote, isNull);
      expect(splitHtmlQuote('<blockquote>Noon?</blockquote>').quote, isNull);
    });
  });
}
