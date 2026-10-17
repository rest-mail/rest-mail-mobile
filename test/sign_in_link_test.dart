import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/util/sign_in_link.dart';

void main() {
  const password = 'kX9+mQ2/rT7=vL4_wN8&pZ1';
  final encoded = Uri.encodeQueryComponent(password);

  group('the web link the installer draws', () {
    test('its parameters ride after the #, where no web server sees them', () {
      final link = SignInLink.parse(
        'https://rest-mail.com/setup#server=https%3A%2F%2Fmail.example.com'
        '&address=admin%40example.com&password=$encoded',
      );
      expect(link?.server, Uri.parse('https://mail.example.com'));
      expect(link?.address, 'admin@example.com');
      expect(link?.password, password);
    });

    test('www, and a trailing slash, are the same page', () {
      final link = SignInLink.parse(
        'https://www.rest-mail.com/setup/#password=$encoded',
      );
      expect(link?.password, password);
    });

    test('written with ordinary query parameters, it is still read', () {
      final link = SignInLink.parse(
        'https://rest-mail.com/setup?address=owner@example.com'
        '&password=$encoded',
      );
      expect(link?.address, 'owner@example.com');
      expect(link?.password, password);
    });

    test('some other site, page or scheme is not a sign-in link', () {
      for (final raw in [
        'https://rest-mail.com.evil.test/setup#password=$encoded',
        'https://evil.test/setup#password=$encoded',
        'https://rest-mail.com/#password=$encoded',
        'https://rest-mail.com/reset#password=$encoded',
        'http://rest-mail.com/setup#password=$encoded',
      ]) {
        expect(SignInLink.parse(raw), isNull, reason: raw);
      }
    });
  });

  test("the app's own scheme", () {
    final link = SignInLink.parse(
      'rest-mail://setup?server=https%3A%2F%2Fmail.example.com'
      '&address=admin@example.com&password=$encoded',
    );
    expect(link?.server, Uri.parse('https://mail.example.com'));
    expect(link?.address, 'admin@example.com');
    expect(link?.password, password);
  });

  // rest-mail, as rest-mail.com: the scheme was restmail:// before the app
  // was released, and nothing made a sign-in link with it.
  test('the old restmail:// scheme is not ours', () {
    expect(SignInLink.parse('restmail://setup?password=x'), isNull);
  });

  test('a link naming no account leaves the address to be typed', () {
    expect(SignInLink.parse('rest-mail://setup?password=x')?.address, isNull);
  });

  // The account is named by its address; there is no username any more.
  test('a username is not an address', () {
    final link = SignInLink.parse(
      'rest-mail://setup?username=admin&password=x',
    );
    expect(link?.address, isNull);
    expect(
      SignInLink.parse('rest-mail://setup?address=admin&password=x')?.address,
      isNull,
    );
  });

  test('a link naming no server leaves the app to ask which', () {
    expect(SignInLink.parse('rest-mail://setup?password=x')?.server, isNull);
  });

  // Servers before rest-mail 0.7 printed a setup code; nothing redeems one.
  test('an old setup code is not a sign-in', () {
    const code = '7KQ2-M9XD-4TPA-HV3N-8RWC-ZB6E';
    for (final raw in [
      'rest-mail://setup?token=$code',
      'https://rest-mail.com/setup#token=$code',
      code,
    ]) {
      expect(SignInLink.parse(raw), isNull, reason: raw);
    }
  });

  test('anything else is not a sign-in link', () {
    for (final raw in [
      null,
      '',
      'https://example.com',
      'rest-mail://reset?token=abc&password=x',
      'rest-mail://setup',
      'rest-mail://setup?address=admin@example.com',
      'not a link at all, really not',
    ]) {
      expect(SignInLink.parse(raw), isNull, reason: raw);
    }
  });
}
