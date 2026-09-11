import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  group('parseServerUrl', () {
    String parse(String input) => parseServerUrl(input).toString();

    test('gives a bare host https', () {
      expect(parse('mail.example.test'), 'https://mail.example.test');
    });

    test('keeps a port', () {
      expect(parse('mail.example.test:8443'), 'https://mail.example.test:8443');
    });

    test('refuses plain http', () {
      expect(
        () => parseServerUrl('http://mail.example.test'),
        throwsFormatException,
      );
    });

    test('refuses an empty address', () {
      expect(() => parseServerUrl('   '), throwsFormatException);
    });

    test('trims a pasted webmail address back to the server', () {
      expect(
        parse('https://mail.example.test/webmail/'),
        'https://mail.example.test',
      );
    });

    test('trims a pasted API address back to the server', () {
      expect(
        parse('https://mail.example.test/api/v1'),
        'https://mail.example.test',
      );
    });

    test('keeps a reverse-proxy prefix', () {
      expect(parse('https://example.test/mail/'), 'https://example.test/mail');
    });
  });

  group('parseSetCookies', () {
    test('reads each cookie and ignores its attributes', () {
      expect(
        parseSetCookies([
          'restmail_access=a.b.c; Path=/; Expires=Thu, 10 Sep 2026 22:15:00 GMT; HttpOnly',
          'restmail_refresh="r.s.t"; Path=/api/v1/auth; HttpOnly',
        ]),
        {'restmail_access': 'a.b.c', 'restmail_refresh': 'r.s.t'},
      );
    });

    test('leaves out a cookie being cleared', () {
      expect(parseSetCookies(['restmail_access=; Max-Age=0']), isEmpty);
    });
  });

  test('SessionTokens survive a round trip through JSON', () {
    final tokens = SessionTokens(
      accessToken: 'a',
      refreshToken: 'r',
      accessExpiresAt: DateTime.utc(2026, 9, 10, 22),
    );
    final restored = SessionTokens.fromJson(tokens.toJson());
    expect(restored.accessToken, 'a');
    expect(restored.refreshToken, 'r');
    expect(restored.accessExpiresAt, tokens.accessExpiresAt);
  });
}
