import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher _refused(int status, String code, [String? message]) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code)
      .having((e) => e.message, 'message', message ?? anything),
);

/// Folder create, rename and delete, as the server answers them since #758.
void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late int account;
  setUp(() async {
    fake = FakeRestmail();
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    account = (await client.accounts()).first.id;
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  Future<List<String>> names() async => [
    for (final folder in await client.folders(account)) folder.name,
  ];

  /// A message from outside, filed in [folder].
  void fileIn(String folder) =>
      fake
              .deliver(
                to: FakeAccounts.adminEmail,
                from: 'a@b.test',
                subject: 'Hi',
              )
              .folder =
          folder;

  Future<http.Response> send(String method, String path, Object body) {
    final request = http.Request(
      method,
      Uri.parse('https://${fake.host}/api/v1/accounts/$account/$path'),
    );
    request.headers['authorization'] = 'Bearer ${client.tokens!.accessToken}';
    request.headers['content-type'] = 'application/json';
    request.body = jsonEncode(body);
    return fake.client.send(request).then(http.Response.fromStream);
  }

  test('a folder is created empty, listed, renamed and deleted', () async {
    expect(await client.createFolder(account, 'Receipts'), 'Receipts');
    final made = (await client.folders(
      account,
    )).singleWhere((f) => f.name == 'Receipts');
    expect((made.total, made.unread), (0, 0));

    expect(
      await client.renameFolder(account, 'Receipts', 'Paid receipts'),
      'Paid receipts',
    );
    expect(await names(), contains('Paid receipts'));
    expect(await names(), isNot(contains('Receipts')));

    await client.deleteFolder(account, 'Paid receipts');
    expect(await names(), isNot(contains('Paid receipts')));
    await expectLater(
      client.deleteFolder(account, 'Paid receipts'),
      _refused(404, 'not_found'),
    );
  });

  test(
    'a rename takes the messages along, and a nested name is one folder',
    () async {
      fileIn('Work');
      fileIn('Work');
      expect(
        await client.renameFolder(account, 'Work', 'Work/2026'),
        'Work/2026',
      );
      expect(
        fake.messagesIn(FakeAccounts.adminEmail, 'Work/2026'),
        hasLength(2),
      );
      expect(fake.messagesIn(FakeAccounts.adminEmail, 'Work'), isEmpty);

      await client.deleteFolder(account, 'Work/2026');
      expect(fake.messagesIn(FakeAccounts.adminEmail, 'Work/2026'), isEmpty);
    },
  );

  test('a rename onto a folder that exists is refused, not merged', () async {
    fileIn('Work');
    fileIn('Personal');
    await expectLater(
      client.renameFolder(account, 'Work', 'Personal'),
      _refused(409, 'already_exists'),
    );
    expect(fake.messagesIn(FakeAccounts.adminEmail, 'Work'), hasLength(1));
    expect(fake.messagesIn(FakeAccounts.adminEmail, 'Personal'), hasLength(1));
    await expectLater(
      client.renameFolder(account, 'Ghost', 'Personal'),
      _refused(404, 'not_found'),
    );
  });

  test('standard folders are not renamed, renamed to, or deleted', () async {
    fileIn('Work');
    for (final folder in ['INBOX', 'inbox', 'Sent', 'Trash', 'Spam']) {
      await expectLater(
        client.renameFolder(account, folder, 'Old mail'),
        _refused(400, 'bad_request', 'Cannot rename standard folder'),
      );
      await expectLater(
        client.deleteFolder(account, folder),
        _refused(400, 'bad_request', 'Cannot delete standard folder'),
      );
    }
    for (final name in ['Inbox', 'Archive', 'Drafts']) {
      await expectLater(
        client.renameFolder(account, 'Work', name),
        _refused(
          400,
          'bad_request',
          'Cannot rename a folder to a standard folder',
        ),
      );
    }
  });

  test(
    'a folder the account has is not created again, INBOX in any case',
    () async {
      fileIn('Work');
      for (final name in ['INBOX', 'inbox', 'Trash', 'Work']) {
        await expectLater(
          client.createFolder(account, name),
          _refused(409, 'already_exists'),
        );
      }
    },
  );

  test('a bad name is refused on name, in the rule\'s words', () async {
    fileIn('Work');
    final cases = {
      '': 'required',
      '   ': 'required',
      ' Receipts': 'must not begin or end with a space',
      'a\u0000b': 'must not contain a control character',
      'Work/../Personal': 'must not contain ".."',
      'x' * 256: 'must be at most 255 bytes',
      'ä' * 128: 'must be at most 255 bytes',
    };
    for (final MapEntry(key: name, value: want) in cases.entries) {
      for (final response in [
        await send('POST', 'folders', {'name': name}),
        await send('PATCH', 'folders/Work', {'name': name}),
      ]) {
        expect(response.statusCode, 422, reason: name);
        expect(
          (jsonDecode(response.body)
              as Map<String, dynamic>)['error']['details']['fields'],
          {'name': want},
          reason: name,
        );
      }
    }
    // Binding first: a missing, null or mistyped name, or another field.
    for (final (body, field, want) in [
      (<String, Object?>{}, 'name', 'required'),
      ({'name': null}, 'name', 'must not be null'),
      ({'name': 12}, 'name', 'must be a string'),
      ({'name': 'A', 'colour': 'red'}, 'colour', 'not allowed'),
    ]) {
      final response = await send('POST', 'folders', body);
      expect(response.statusCode, 422, reason: '$body');
      expect(
        (jsonDecode(response.body)
            as Map<String, dynamic>)['error']['details']['fields'][field],
        want,
        reason: '$body',
      );
    }
    expect(fake.messagesIn(FakeAccounts.adminEmail, 'Work'), hasLength(1));
  });

  test('an account the session does not reach is 403', () async {
    final other = account + 1000;
    for (final call in [
      () => client.createFolder(other, 'Receipts'),
      () => client.renameFolder(other, 'Work', 'Receipts'),
      () => client.deleteFolder(other, 'Work'),
    ]) {
      await expectLater(call(), _refused(403, 'forbidden'));
    }
  });
}
