import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  test(
    'dashboard fake reports the complete transport and activity contract',
    () async {
      final fake = FakeRestmail();
      final api = RestmailClient(
        server: Uri.parse('https://${FakeAccounts.host}'),
        httpClient: fake.client,
      );
      addTearDown(fake.close);
      addTearDown(api.close);
      await api.login(
        email: FakeAccounts.adminEmail,
        password: FakeAccounts.adminPassword,
        totpCode: FakeAccounts.totpCode,
      );
      final stats = await api.stats();
      expect(stats.queueProcessing, greaterThanOrEqualTo(0));
      expect(stats.inboundMx, 120);
      expect(stats.inboundOverTls, 114);
      expect(stats.inboundPlaintext, 6);
      expect(stats.inboundTlsPercent, 95.0);
      expect(stats.inboundPlaintextPercent, 5.0);
      expect((stats.plaintextAuthPass, stats.plaintextAuthFail), (2, 4));
      expect(
        stats.plaintextAuthPass + stats.plaintextAuthFail,
        stats.inboundPlaintext,
      );
      expect(stats.recent, isNotEmpty);
      expect(
        stats.recent.every(
          (event) =>
              event.id.isNotEmpty && event.type == 'bounce' && event.at != null,
        ),
        isTrue,
      );
    },
  );
}
