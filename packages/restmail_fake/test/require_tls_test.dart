import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

/// A send that requires TLS on every hop (REQUIRETLS, RFC 8689).
void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  setUp(() async {
    fake = FakeRestmail();
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  OutgoingMessage message({bool requireTls = false}) => OutgoingMessage(
    from: FakeAccounts.email,
    to: const ['nadia@oakline.test'],
    subject: 'Contract draft',
    bodyText: 'Attached.',
    requireTls: requireTls,
  );

  test('the send body asks for it only when it is wanted', () {
    expect(message().toSendJson().containsKey('require_tls'), isFalse);
    expect(message(requireTls: true).toSendJson()['require_tls'], isTrue);
    // The draft endpoints have no such field.
    expect(
      message(requireTls: true).toDraftJson().containsKey('require_tls'),
      isFalse,
    );
  });

  test('the sent copy keeps what the send asked for', () async {
    await client.send(message(requireTls: true));
    await client.send(message());
    final sent = fake.messagesIn(FakeAccounts.email, 'Sent');
    expect(sent.where((m) => m.requireTls), hasLength(1));
  });

  test('a value that is not a boolean is refused', () async {
    final request = http.Request(
      'POST',
      Uri.parse('https://${fake.host}/api/v1/messages/send'),
    );
    request.headers['authorization'] = 'Bearer ${client.tokens!.accessToken}';
    request.headers['content-type'] = 'application/json';
    request.body = jsonEncode({
      ...message().toSendJson(),
      'require_tls': 'yes',
    });
    final response = await fake.client
        .send(request)
        .then(http.Response.fromStream);
    expect(response.statusCode, 422);
    expect(
      (jsonDecode(response.body)
          as Map<String, dynamic>)['error']['details']['fields'],
      {'require_tls': 'must be a boolean'},
    );
  });
}
