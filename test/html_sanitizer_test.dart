import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/util/html_sanitizer.dart';

void main() {
  test('drops scripts, styles and forms along with what is in them', () {
    expect(
      sanitizeHtml(
        '<style>p{color:red}</style><p>Hi</p><script>alert(1)</script><form><input name=x>go</form>',
      ).html,
      '<p>Hi</p>',
    );
  });

  test('unwraps tags it does not allow, keeping their text', () {
    expect(
      sanitizeHtml('<center><font color="red">Sale</font></center>').html,
      'Sale',
    );
  });

  test('strips event handlers, styles and classes', () {
    expect(
      sanitizeHtml(
        '<p onclick="x()" style="color:red" class="c" title="t">Hi</p>',
      ).html,
      '<p title="t">Hi</p>',
    );
  });

  test('keeps web and mail links and drops script links', () {
    expect(
      sanitizeHtml(
        '<a href="https://example.test/a">a</a>'
        '<a href="mailto:ada@example.test">b</a>'
        '<a href="javascript:alert(1)">c</a>',
      ).html,
      '<a href="https://example.test/a">a</a><a href="mailto:ada@example.test">b</a><a>c</a>',
    );
  });

  test('blocks remote images until allowed, then fetches them over https', () {
    const html =
        '<img src="http://tracker.test/p.gif" alt="x"><img src="https://cdn.test/logo.png">';

    final blocked = sanitizeHtml(html);
    expect(blocked.blockedImages, 2);
    expect(blocked.html, isEmpty);

    final allowed = sanitizeHtml(html, allowRemoteImages: true);
    expect(allowed.blockedImages, 0);
    expect(
      allowed.html,
      '<img src="https://tracker.test/p.gif" alt="x"><img src="https://cdn.test/logo.png">',
    );
  });

  test('keeps inline images and drops cid: references', () {
    const pixel = 'data:image/png;base64,iVBORw0KGgo=';
    expect(
      sanitizeHtml('<img src="$pixel"><img src="cid:logo@x">').html,
      '<img src="$pixel">',
    );
  });

  test('turns HTML into text with its paragraphs and line breaks', () {
    expect(
      htmlToPlainText(
        '<p>Hello<br>there</p><div>Second   paragraph</div><style>x{}</style>',
      ),
      'Hello\nthere\n\nSecond paragraph',
    );
  });
}
