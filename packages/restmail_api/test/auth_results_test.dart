import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  group('trustFromHeaders', () {
    test('a valid dkim signature is signed', () {
      final verdict = trustFromHeaders({
        'Authentication-Results':
            'mx.restmail.dev; spf=pass smtp.mailfrom=dana@restmail.dev; '
            'dkim=pass header.d=restmail.dev; '
            'dmarc=pass header.from=restmail.dev',
      });
      expect(verdict.state, TrustState.signed);
      expect(verdict.signedBy, 'restmail.dev');
    });

    test('dmarc pass without a signature is aligned, not signed', () {
      final verdict = trustFromHeaders({
        'Authentication-Results':
            'mx.restmail.dev; spf=pass smtp.mailfrom=restmail.dev; '
            'dmarc=pass header.from=restmail.dev',
      });
      expect(verdict.state, TrustState.aligned);
    });

    test('spf alone is spf only', () {
      final verdict = trustFromHeaders({
        'Authentication-Results':
            'mx.restmail.dev; spf=pass smtp.mailfrom=restmail.dev',
      });
      expect(verdict.state, TrustState.spfOnly);
    });

    test('dmarc fail with an intact arc chain is forwarded', () {
      final verdict = trustFromHeaders({
        'Authentication-Results':
            'mx.restmail.dev; dmarc=fail header.from=restmail.dev; arc=pass',
      });
      expect(verdict.state, TrustState.forwarded);
    });

    test('dmarc fail without arc is a mismatch', () {
      final verdict = trustFromHeaders({
        'Authentication-Results':
            'mx.restmail.dev; dmarc=fail header.from=restmail.dev; '
            'dkim=fail header.d=evil.example',
      });
      expect(verdict.state, TrustState.mismatch);
    });

    test('no header is unchecked, never a verdict', () {
      expect(trustFromHeaders(null).state, TrustState.unchecked);
      expect(trustFromHeaders(const {}).state, TrustState.unchecked);
    });

    test('a pass at any hop wins over a fail at another', () {
      final verdict = trustFromHeaders({
        'authentication-results':
            'mx.other; dkim=fail header.d=restmail.dev\n'
            'mx.restmail.dev; dkim=pass header.d=restmail.dev; '
            'dmarc=pass header.from=restmail.dev',
      });
      expect(verdict.state, TrustState.signed);
    });
  });

  test('headerValue is case insensitive', () {
    expect(
      headerValue(
        {'Authentication-Results': 'x; spf=pass'},
        'authentication-results',
      ),
      'x; spf=pass',
    );
  });
}
