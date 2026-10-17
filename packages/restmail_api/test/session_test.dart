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
    expect(restored.capabilities, Capabilities.none);
  });

  test('and keep their capabilities', () {
    final tokens = SessionTokens(
      accessToken: 'a',
      refreshToken: 'r',
      accessExpiresAt: DateTime.utc(2026, 9, 10, 22),
      capabilities: const Capabilities({'queue:read', 'domains:read'}),
    );
    final restored = SessionTokens.fromJson(tokens.toJson());
    expect(restored.capabilities, tokens.capabilities);
    expect(restored.capabilities.allows(Capability.queueRead), isTrue);
    expect(restored.capabilities.allows(Capability.queueManage), isFalse);
  });

  test('* allows every capability; none allows nothing', () {
    expect(const Capabilities({'*'}).allows(Capability.bansDelete), isTrue);
    expect(Capabilities.none.allows(Capability.queueRead), isFalse);
    expect(Capabilities.fromJson(null), Capabilities.none);
    expect(Capabilities.fromJson(['users:read', 7]).names, {'users:read'});
  });
}
