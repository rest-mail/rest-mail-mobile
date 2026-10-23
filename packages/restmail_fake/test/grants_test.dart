import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

Future<RestmailClient> _signIn(
  FakeRestmail fake,
  String email, {
  String password = FakeAccounts.adminPassword,
  String? totpCode = FakeAccounts.totpCode,
}) async {
  final client = RestmailClient(server: _server, httpClient: fake.client);
  await client.login(email: email, password: password, totpCode: totpCode);
  return client;
}

Matcher _refused(int status, String code) => isA<ApiException>()
    .having((e) => e.statusCode, 'statusCode', status)
    .having((e) => e.code, 'code', code);

/// Grants and escalation in the fake, through the real client: the checks
/// `grants.go` and `escalation.go` make, as far as the fake knows them.
void main() {
  test('an admin lists roles and capabilities, grants and removes', () async {
    final fake = FakeRestmail();
    final admin = await _signIn(fake, FakeAccounts.adminEmail);

    final roles = await admin.roles();
    expect(roles.map((r) => r.name), ['superadmin', 'admin']);
    final definitions = await admin.capabilityDefinitions();
    expect(definitions.map((d) => d.name), contains('users:write'));

    final dana = (await admin.mailboxes(
      limit: 200,
    )).items.firstWhere((m) => m.address == FakeAccounts.email);
    final grant = await admin.createGrant(
      holder: GrantHolder.account(dana.id),
      role: 'admin',
      scope: 'domain:${FakeAccounts.host}',
      mode: GrantMode.eligible,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    expect(grant.mode, GrantMode.eligible);
    expect(grant.expiresAt, isNotNull);

    final page = await admin.grants(holder: GrantHolder.account(dana.id));
    expect(page.items.single.scope, 'domain:${FakeAccounts.host}');

    await expectLater(
      admin.createGrant(
        holder: GrantHolder.account(dana.id),
        role: 'admin',
        scope: 'domain:${FakeAccounts.host}',
      ),
      throwsA(_refused(409, GrantErrorCode.conflict)),
    );
    await expectLater(
      admin.createGrant(
        holder: GrantHolder.account(dana.id),
        role: 'admin',
        scope: 'nowhere',
      ),
      throwsA(
        isA<ApiException>().having((e) => e.fields.keys, 'fields', ['scope']),
      ),
    );

    await admin.deleteGrant(grant.id);
    expect((await admin.grants()).items, isEmpty);
  });

  test('a session without users:write, or without 2FA, cannot grant', () async {
    final fake = FakeRestmail()
      ..addAccount(
        'nofactor@${FakeAccounts.host}',
        capabilities: {'*'},
        twoFactor: false,
      );
    final watcher = await _signIn(fake, FakeAccounts.queueWatcher);
    await expectLater(watcher.roles(), throwsA(_refused(403, 'forbidden')));

    final noFactor = await _signIn(
      fake,
      'nofactor@${FakeAccounts.host}',
      totpCode: null,
    );
    await expectLater(
      noFactor.createGrant(
        holder: const GrantHolder.account(1),
        role: 'admin',
        scope: '*',
      ),
      throwsA(_refused(403, GrantErrorCode.twoFactorRequired)),
    );
  });

  test('the holder switches an eligible grant on with a fresh code, and '
      'off again', () async {
    final fake = FakeRestmail()
      ..addAccount('eve@${FakeAccounts.host}')
      ..addGrant('eve@${FakeAccounts.host}', 'admin', mode: 'eligible');
    final eve = await _signIn(fake, 'eve@${FakeAccounts.host}');
    expect(eve.tokens!.capabilities.isEmpty, isTrue);

    final mine = await eve.myGrants();
    expect(mine.single.mode, GrantMode.eligible);
    expect(mine.single.activation, isNull);

    // Nothing in Administration yet: the grant gives nothing until on.
    await expectLater(eve.queue(), throwsA(_refused(403, 'forbidden')));

    await expectLater(
      eve.activateGrant(mine.single.id, reason: 'Clearing the queue'),
      throwsA(isA<TotpRequiredException>()),
    );
    await expectLater(
      eve.activateGrant(
        mine.single.id,
        reason: 'Clearing the queue',
        totpCode: '000000',
      ),
      throwsA(_refused(403, GrantErrorCode.invalidTotp)),
    );
    await expectLater(
      eve.activateGrant(
        mine.single.id,
        reason: ' ',
        totpCode: FakeAccounts.totpCode,
      ),
      throwsA(
        isA<ApiException>().having((e) => e.fields.keys, 'fields', ['reason']),
      ),
    );

    final on = await eve.activateGrant(
      mine.single.id,
      reason: 'Clearing the queue',
      minutes: 30,
      totpCode: FakeAccounts.totpCode,
    );
    expect(on.grant.activation?.reason, 'Clearing the queue');
    expect(on.capabilities.allows(Capability.queueRead), isTrue);
    expect(eve.tokens!.capabilities.allows(Capability.queueRead), isTrue);
    await eve.queue();

    final off = await eve.deactivateGrant(mine.single.id);
    expect(off.grant.activation, isNull);
    expect(off.capabilities.isEmpty, isTrue);
    expect(eve.tokens!.capabilities.isEmpty, isTrue);
    await expectLater(
      eve.deactivateGrant(mine.single.id),
      throwsA(_refused(409, GrantErrorCode.notActive)),
    );
  });

  test('the holder makes an active grant eligible with a recovery code, '
      'and nobody reaches anyone else\'s grant', () async {
    final fake = FakeRestmail()
      ..addAccount('eve@${FakeAccounts.host}')
      ..addAccount('fay@${FakeAccounts.host}');
    final evesGrant = fake.addGrant('eve@${FakeAccounts.host}', 'admin');
    final eve = await _signIn(fake, 'eve@${FakeAccounts.host}');
    final fay = await _signIn(fake, 'fay@${FakeAccounts.host}');
    expect(eve.tokens!.capabilities.allows(Capability.queueRead), isTrue);

    await expectLater(
      fay.deactivateGrant(evesGrant),
      throwsA(_refused(404, 'not_found')),
    );

    final step = await eve.makeGrantEligible(
      evesGrant,
      recoveryCode: FakeAccounts.recoveryCode,
    );
    expect(step.grant.mode, GrantMode.eligible);
    expect(step.capabilities.isEmpty, isTrue);
    await expectLater(
      eve.makeGrantEligible(evesGrant, recoveryCode: FakeAccounts.recoveryCode),
      throwsA(_refused(403, GrantErrorCode.invalidTotp)),
    );
  });
}
