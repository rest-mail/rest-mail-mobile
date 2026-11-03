import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

class QuietHoursGate extends http.BaseClient {
  QuietHoursGate(this.inner);

  final http.Client inner;
  Completer<void>? hold;
  int gets = 0;
  int puts = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/quiet-hours')) {
      if (request.method == 'GET') gets++;
      if (request.method == 'PUT') puts++;
      await hold?.future;
    }
    return inner.send(request);
  }
}

class QuietHoursFixture {
  final fake = FakeRestmail();
  late final gate = QuietHoursGate(fake.client);
  late final client = RestmailClient(
    server: Uri.parse('https://${fake.host}'),
    httpClient: gate,
  );
  late int accountId;
  late int otherId;

  Future<void> start() async {
    final other = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await other.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    otherId = (await other.accounts()).first.id;
    other.close();
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    accountId = (await client.accounts()).first.id;
  }

  void close() {
    client.close();
    fake.close();
  }
}
