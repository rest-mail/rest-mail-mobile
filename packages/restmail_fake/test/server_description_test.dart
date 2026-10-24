import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  test('the fake says it is rest-mail, at the version it is set to', () async {
    final fake = FakeRestmail();
    final client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    addTearDown(() {
      client.close();
      fake.close();
    });
    final first = await client.describeServer();
    expect((first.product, first.version), ('rest-mail', '0.21.0'));
    fake.serverVersion = '0.22.0';
    expect((await client.describeServer()).version, '0.22.0');
  });
}
