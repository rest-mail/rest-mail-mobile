import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

const _granter = 'granter@${FakeAccounts.host}';
final _server = Uri.parse('https://${FakeAccounts.host}');

Future<RestmailClient> _signIn(FakeRestmail fake, String email) async {
  final client = RestmailClient(server: _server, httpClient: fake.client);
  await client.login(
    email: email,
    password: FakeAccounts.adminPassword,
    totpCode: FakeAccounts.totpCode,
  );
  return client;
}

Matcher _refused(String code) => isA<ApiException>()
    .having((e) => e.statusCode, 'status', 403)
    .having((e) => e.code, 'code', code);

Future<GrantHolder> _subject(RestmailClient admin) async => GrantHolder.account(
  (await admin.mailboxes(
    limit: 200,
  )).items.firstWhere((m) => m.address == FakeAccounts.email).id,
);

void main() {
  for (final (heldScope, targetScope, allowed) in [
    ('*', '*', true),
    ('domain:a.test', 'domain:a.test', true),
    ('domain:a.test', 'mailbox:x@a.test', true),
    ('domain:a.test', 'domain:b.test', false),
    ('domain:a.test', 'domain:evil-a.test', false),
    ('domain:a.test', '*', false),
    ('mailbox:x@a.test', 'mailbox:x@a.test', true),
    ('mailbox:x@a.test', 'mailbox:y@a.test', false),
    ('mailbox:x@a.test', 'domain:a.test', false),
    ('mailbox:x@a.test', '*', false),
  ]) {
    test('CanGrant admin at $heldScope -> $targetScope is $allowed', () async {
      final fake = FakeRestmail()
        ..addAccount(_granter, capabilities: {'users:read', 'users:write'});
      addTearDown(fake.close);
      fake.addGrant(_granter, 'admin', scope: heldScope);
      final admin = await _signIn(fake, FakeAccounts.adminEmail);
      final holder = await _subject(admin);
      final client = await _signIn(fake, _granter);
      final tokens = client.tokens!;
      if (allowed) {
        final grant = await client.createGrant(
          holder: holder,
          role: 'admin',
          scope: targetScope,
        );
        expect(grant.scope, targetScope);
        await client.deleteGrant(grant.id);
      } else {
        await expectLater(
          client.createGrant(holder: holder, role: 'admin', scope: targetScope),
          throwsA(_refused(GrantErrorCode.exceedsHeld)),
        );
      }
      expect(client.tokens, same(tokens));
      expect((await admin.grants(holder: holder)).items, isEmpty);
    });
  }

  test(
    'scoped wildcard may grant within that scope but cannot escape it',
    () async {
      final fake = FakeRestmail()
        ..addAccount(_granter, capabilities: {'users:read', 'users:write'});
      addTearDown(fake.close);
      fake.addGrant(_granter, 'superadmin', scope: 'domain:a.test');
      final admin = await _signIn(fake, FakeAccounts.adminEmail);
      final holder = await _subject(admin);
      final client = await _signIn(fake, _granter);
      final created = await client.createGrant(
        holder: holder,
        role: 'superadmin',
        scope: 'mailbox:x@a.test',
      );
      await client.deleteGrant(
        created.id,
      ); // Narrow wildcard is not the last global superadmin.
      for (final scope in ['*', 'domain:b.test']) {
        await expectLater(
          client.createGrant(holder: holder, role: 'superadmin', scope: scope),
          throwsA(_refused(GrantErrorCode.exceedsHeld)),
        );
      }
    },
  );

  test(
    'deleting a role uses its target scope and current granter holdings',
    () async {
      final fake = FakeRestmail()
        ..addAccount(_granter, capabilities: {'users:read', 'users:write'});
      addTearDown(fake.close);
      final heldId = fake.addGrant(_granter, 'admin', scope: 'domain:a.test');
      final admin = await _signIn(fake, FakeAccounts.adminEmail);
      final holder = await _subject(admin);
      final client = await _signIn(fake, _granter);
      final other = await admin.createGrant(
        holder: holder,
        role: 'admin',
        scope: 'domain:b.test',
      );
      await expectLater(
        client.deleteGrant(other.id),
        throwsA(_refused(GrantErrorCode.exceedsHeld)),
      );
      final own = await client.createGrant(
        holder: holder,
        role: 'admin',
        scope: 'domain:a.test',
      );
      await admin.deleteGrant(heldId);
      final tokens = client.tokens!;
      await expectLater(
        client.deleteGrant(own.id),
        throwsA(_refused(GrantErrorCode.exceedsHeld)),
      );
      expect(client.tokens, same(tokens));
      expect(
        (await admin.grants(holder: holder)).items.map((g) => g.id),
        containsAll([own.id, other.id]),
      );
    },
  );

  test(
    'eligible roles authorize only during activation and snapshots stay scoped',
    () async {
      final fake = FakeRestmail()
        ..addAccount(_granter, capabilities: {'users:read', 'users:write'});
      addTearDown(fake.close);
      final heldId = fake.addGrant(
        _granter,
        'admin',
        scope: 'domain:a.test',
        mode: 'eligible',
      );
      final admin = await _signIn(fake, FakeAccounts.adminEmail);
      final holder = await _subject(admin);
      final client = await _signIn(fake, _granter);
      await expectLater(
        client.createGrant(
          holder: holder,
          role: 'admin',
          scope: 'domain:a.test',
        ),
        throwsA(_refused(GrantErrorCode.exceedsHeld)),
      );
      final on = await client.activateGrant(
        heldId,
        reason: 'Manage this domain',
        totpCode: FakeAccounts.totpCode,
      );
      expect(on.capabilities.names, {'users:read', 'users:write'});
      expect(on.capabilities.allows(Capability.domainsWrite), isFalse);
      expect(
        on.capabilities.allows(Capability.domainsWrite, scope: 'domain:a.test'),
        isTrue,
      );
      final created = await client.createGrant(
        holder: holder,
        role: 'admin',
        scope: 'mailbox:x@a.test',
      );
      await client.deleteGrant(created.id);
      await client.deactivateGrant(heldId);
      expect(
        client.tokens!.capabilities.allows(
          Capability.domainsWrite,
          scope: 'domain:a.test',
        ),
        isFalse,
      );
      await expectLater(
        client.createGrant(
          holder: holder,
          role: 'admin',
          scope: 'domain:a.test',
        ),
        throwsA(_refused(GrantErrorCode.exceedsHeld)),
      );
    },
  );

  test('grantor expiry is enforced with an otherwise fresh token', () async {
    var now = DateTime.now();
    final fake = FakeRestmail(clock: () => now)
      ..addAccount(_granter, capabilities: {'users:read', 'users:write'});
    addTearDown(fake.close);
    fake.addGrant(
      _granter,
      'admin',
      scope: 'domain:a.test',
      expiresAt: now.add(const Duration(minutes: 1)),
    );
    final admin = await _signIn(fake, FakeAccounts.adminEmail);
    final holder = await _subject(admin);
    final client = await _signIn(fake, _granter);
    final tokens = client.tokens!;
    now = now.add(const Duration(minutes: 2));
    await expectLater(
      client.createGrant(holder: holder, role: 'admin', scope: 'domain:a.test'),
      throwsA(_refused(GrantErrorCode.exceedsHeld)),
    );
    expect(client.tokens, same(tokens));
    await client.refresh();
    expect(
      client.tokens!.capabilities.allows(
        Capability.domainsRead,
        scope: 'domain:a.test',
      ),
      isFalse,
    );
  });

  test(
    'owner role covers only the mailbox and scopes normalize and deduplicate',
    () async {
      final fake = FakeRestmail()
        ..addAccount(_granter, capabilities: {'users:read', 'users:write'});
      addTearDown(fake.close);
      final client = await _signIn(fake, _granter);
      final own = (await client.accounts()).firstWhere((a) => a.isPrimary);
      final created = await client.createGrant(
        holder: GrantHolder.account(own.id),
        role: 'owner',
        scope: '  MAILBOX:${_granter.toUpperCase()}  ',
      );
      expect(created.scope, 'mailbox:$_granter');
      final snapshot = (await client.refresh()).capabilities;
      expect(
        snapshot.scoped.where((e) => e.scope == 'mailbox:$_granter'),
        hasLength(4),
      );
      for (final scope in [
        'domain:${FakeAccounts.host}',
        'mailbox:other@${FakeAccounts.host}',
      ]) {
        await expectLater(
          client.createGrant(
            holder: GrantHolder.account(own.id),
            role: 'owner',
            scope: scope,
          ),
          throwsA(_refused(GrantErrorCode.exceedsHeld)),
        );
      }
      await client.deleteGrant(created.id);
    },
  );

  for (final (scope, allowed) in [
    ('domain:${FakeAccounts.host}', true),
    ('mailbox:$_granter', false),
  ]) {
    test(
      'account creation uses live role at $scope, allowed=$allowed',
      () async {
        final fake = FakeRestmail()..addAccount(_granter);
        addTearDown(fake.close);
        fake.addGrant(_granter, 'admin', scope: scope);
        final client = await _signIn(fake, _granter);
        final create = client.createAccount(
          address: 'new-person@${FakeAccounts.host}',
          password: 'new-account-password',
        );
        if (allowed) {
          final account = await create;
          expect(account.address, 'new-person@${FakeAccounts.host}');
          expect(
            (await client.accounts()).map((a) => a.address),
            contains(account.address),
          );
        } else {
          await expectLater(create, throwsA(_refused('forbidden')));
        }
      },
    );
  }

  test(
    'grant scope parsing matches server normalization and grammar',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final admin = await _signIn(fake, FakeAccounts.adminEmail);
      final holder = await _subject(admin);
      for (final value in [
        'domain:',
        'domain:a..test',
        'domain:bad_name.test',
        'mailbox:a@b@c.test',
        'mailbox:a b@c.test',
        'mailbox:@a.test',
      ]) {
        await expectLater(
          admin.createGrant(holder: holder, role: 'readonly', scope: value),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'status', 422)
                .having((e) => e.fields.keys, 'fields', contains('scope')),
          ),
        );
      }
      final created = await admin.createGrant(
        holder: holder,
        role: 'readonly',
        scope: ' DOMAIN:LOCAL ',
      );
      expect(created.scope, 'domain:local');
      await admin.deleteGrant(created.id);
    },
  );

  for (final spare in [
    'expired',
    'inactive',
    'eligible_without_factor',
    'narrow',
  ]) {
    test(
      '$spare wildcard does not count as a usable remaining global superadmin',
      () async {
        final fake = FakeRestmail()
          ..grant(FakeAccounts.adminEmail, {})
          ..addAccount(_granter, twoFactor: spare != 'eligible_without_factor');
        addTearDown(fake.close);
        final last = fake.addGrant(FakeAccounts.adminEmail, 'superadmin');
        fake.addGrant(
          _granter,
          'superadmin',
          scope: spare == 'narrow' ? 'domain:a.test' : '*',
          mode: spare == 'eligible_without_factor' ? 'eligible' : 'active',
          expiresAt: spare == 'expired'
              ? DateTime.now().subtract(const Duration(minutes: 1))
              : null,
        );
        final admin = await _signIn(fake, FakeAccounts.adminEmail);
        if (spare == 'inactive') {
          final boxes = await admin.mailboxes(limit: 200);
          final id = boxes.items
              .firstWhere((box) => box.address == _granter)
              .id;
          await admin.updateMailbox(id, active: false);
        }
        await expectLater(
          admin.deleteGrant(last),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              GrantErrorCode.lastSuperadmin,
            ),
          ),
        );
        expect((await admin.myGrants()).map((g) => g.id), contains(last));
      },
    );
  }

  test(
    'a usable remaining global superadmin allows the other to be removed',
    () async {
      final fake = FakeRestmail()
        ..grant(FakeAccounts.adminEmail, {})
        ..addAccount(_granter);
      addTearDown(fake.close);
      final removable = fake.addGrant(FakeAccounts.adminEmail, 'superadmin');
      fake.addGrant(_granter, 'superadmin');
      final admin = await _signIn(fake, FakeAccounts.adminEmail);
      await admin.deleteGrant(removable);
      expect((await admin.myGrants()), isEmpty);
      await expectLater(admin.roles(), throwsA(_refused('forbidden')));
    },
  );
}
