import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/util/setup_code.dart';

void main() {
  const code = '7KQ2-M9XD-4TPA-HV3N-8RWC-ZB6E';

  test('the link a server prints: the code, no server', () {
    final scan = SetupCodeScan.parse('restmail://setup?token=$code');
    expect(scan?.code, code);
    expect(scan?.server, isNull);
  });

  test('the link the CLI draws: the code and the server', () {
    final scan = SetupCodeScan.parse(
      'restmail://setup?server=https%3A%2F%2Fmail.example.com&token=$code',
    );
    expect(scan?.code, code);
    expect(scan?.server, Uri.parse('https://mail.example.com'));
  });

  test('a bare code, as typed or printed', () {
    expect(SetupCodeScan.parse(' $code ')?.code, code);
    expect(
      SetupCodeScan.parse(code.toLowerCase().replaceAll('-', ''))?.code,
      isNotNull,
    );
  });

  group('the web link, tappable anywhere', () {
    test('its parameters ride after the #, where no web server sees them', () {
      final scan = SetupCodeScan.parse(
        'https://rest-mail.com/setup#server=https%3A%2F%2Fmail.example.com&token=$code',
      );
      expect(scan?.code, code);
      expect(scan?.server, Uri.parse('https://mail.example.com'));
    });

    test('a link from a server, which names no server', () {
      expect(
        SetupCodeScan.parse('https://rest-mail.com/setup#token=$code')?.code,
        code,
      );
      expect(
        SetupCodeScan.parse('https://www.rest-mail.com/setup/#token=$code')
            ?.code,
        code,
      );
    });

    test('written with ordinary query parameters, it is still read', () {
      expect(
        SetupCodeScan.parse('https://rest-mail.com/setup?token=$code')?.code,
        code,
      );
    });

    test('some other site, page or scheme is not a setup link', () {
      for (final raw in [
        'https://rest-mail.com.evil.test/setup#token=$code',
        'https://evil.test/setup#token=$code',
        'https://rest-mail.com/#token=$code',
        'https://rest-mail.com/reset#token=$code',
        'http://rest-mail.com/setup#token=$code',
      ]) {
        expect(SetupCodeScan.parse(raw), isNull, reason: raw);
      }
    });
  });

  test('anything else is not a setup code', () {
    for (final raw in [
      null,
      '',
      'https://example.com',
      'restmail://reset?token=$code',
      'restmail://setup?token=short',
      'restmail://setup',
      'not a code at all, really not',
    ]) {
      expect(SetupCodeScan.parse(raw), isNull, reason: raw);
    }
  });
}
