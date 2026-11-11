import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

const _invited = 'new@restmail.test';
const _password = 'a brand new passphrase';

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

void main() {
  late FakeRestmail fake;
  setUp(() {
    fake = FakeRestmail();
    fake.addAccount(_invited, password: null, twoFactor: false);
  });
  tearDown(() => fake.close());

  RestmailClient client() {
    final made = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    addTearDown(made.close);
    return made;
  }

  Future<RestmailClient> admin({bool withCode = true}) async {
    final made = client();
    await made.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: withCode ? FakeAccounts.totpCode : null,
    );
    return made;
  }

  Future<AdminMailbox> mailbox(RestmailClient admin, String address) async =>
      (await admin.mailboxes(
        limit: 500,
      )).items.firstWhere((box) => box.address == address);

  test(
    'an invitation is redeemed once, and its session owes two-factor setup',
    () async {
      final adm = await admin();
      final box = await mailbox(adm, _invited);
      final invitation = await adm.inviteAccount(box.id);
      expect(invitation.token, isNotEmpty);

      final result = await client().acceptInvitation(
        token: invitation.token,
        password: _password,
      );
      expect(result.user.email, _invited);
      expect(result.setupRequired, contains(SetupStep.twoFactor));
      expect(fake.passwordOf(_invited), _password);

      await expectLater(
        client().acceptInvitation(token: invitation.token, password: _password),
        _refused(401, 'invalid_token'),
      );
    },
  );

  test('a new invitation replaces the previous one', () async {
    final adm = await admin();
    final box = await mailbox(adm, _invited);
    final first = await adm.inviteAccount(box.id);
    final second = await adm.inviteAccount(box.id);
    await expectLater(
      client().acceptInvitation(token: first.token, password: _password),
      _refused(401, 'invalid_token'),
    );
    await client().acceptInvitation(token: second.token, password: _password);
  });

  test('an account that has held credentials cannot be invited', () async {
    final adm = await admin();
    final box = await mailbox(adm, FakeAccounts.email);
    await expectLater(
      adm.inviteAccount(box.id),
      _refused(409, 'account_not_invitable'),
    );
  });

  test('issuing takes a second factor', () async {
    fake.addAccount(
      'helper@restmail.test',
      capabilities: {'mailboxes:read', 'accounts:write'},
      twoFactor: false,
    );
    final helper = client();
    await helper.login(
      email: 'helper@restmail.test',
      password: FakeAccounts.adminPassword,
    );
    final box = await mailbox(helper, _invited);
    await expectLater(
      helper.inviteAccount(box.id),
      _refused(403, 'two_factor_required'),
    );
  });

  test('a short password is a field error and spends nothing', () async {
    final adm = await admin();
    final box = await mailbox(adm, _invited);
    final invitation = await adm.inviteAccount(box.id);
    await expectLater(
      client().acceptInvitation(token: invitation.token, password: 'short'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 422)
            .having((e) => e.fields.keys, 'fields', contains('password')),
      ),
    );
    await client().acceptInvitation(
      token: invitation.token,
      password: _password,
    );
  });
}
