// More of the admin API against a real server (tool/ci/live_server.sh): a
// domain's mail policy, its keys and certificates, permissions, bans, the
// queue, the filters, the reports, and the session's own refresh.
@TestOn('vm')
library;

import 'dart:io';

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

Matcher refused(int status, [String? code]) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code ?? anything),
);

/// [args] run through openssl, in [dir]; its stdout.
Future<String> openssl(Directory dir, List<String> args) async {
  final result = await Process.run('openssl', args, workingDirectory: dir.path);
  if (result.exitCode != 0) throw StateError('openssl $args: ${result.stderr}');
  return result.stdout as String;
}

void main() {
  late LiveAdmin admin;
  late AdminDomain domain;
  late Directory tmp;
  RestmailClient client() => admin.client;

  setUpAll(() async {
    if (skipLive != null) return;
    admin = await LiveAdmin.setUp();
    domain = await admin.client.createDomain('three.live.test');
    tmp = await Directory.systemTemp.createTemp('restmail-live-');
  });
  tearDownAll(() async {
    if (skipLive != null) return;
    admin.client.close();
    await tmp.delete(recursive: true);
  });

  group('live admin API', skip: skipLive, () {
    test('MTA-STS: set, read, unpublished at zero, deleted', () async {
      expect(await client().mtaStsPolicy(domain.id), isNull);
      final set = await client().setMtaStsPolicy(
        domain.id,
        mode: MtaStsMode.testing,
        mxHosts: ['mx.three.live.test'],
        maxAgeSeconds: 86400,
        active: true,
      );
      expect(set.mode, MtaStsMode.testing);
      expect(set.mxHosts, ['mx.three.live.test']);
      expect(set.maxAgeSeconds, 86400);
      final paused = await client().setMtaStsPolicy(domain.id, active: false);
      expect(paused.active, isFalse);
      expect((await client().mtaStsPolicy(domain.id))!.active, isFalse);
      await client().deleteMtaStsPolicy(domain.id);
      expect(await client().mtaStsPolicy(domain.id), isNull);
      await expectLater(client().deleteMtaStsPolicy(domain.id), refused(404));
    });

    test('sender lists: the same sender on both, duplicates refused', () async {
      final blocked = await client().addSenderRule(
        domain.id,
        SenderList.block,
        pattern: '@spam.test',
        reason: 'reported',
      );
      expect(blocked.pattern, '@spam.test');
      expect(blocked.reason, 'reported');
      final allowed = await client().addSenderRule(
        domain.id,
        SenderList.allow,
        pattern: '@spam.test',
      );
      await expectLater(
        client().addSenderRule(
          domain.id,
          SenderList.block,
          pattern: '@spam.test',
        ),
        refused(409, 'already_exists'),
      );
      expect(
        (await client().senderRules(
          domain.id,
          SenderList.block,
        )).map((r) => r.id),
        [blocked.id],
      );
      await client().removeSenderRule(domain.id, SenderList.block, blocked.id);
      await client().removeSenderRule(domain.id, SenderList.allow, allowed.id);
      expect(await client().senderRules(domain.id, SenderList.allow), isEmpty);
    });

    test('relay, suppressions and the DNS check read back', () async {
      final relay = await client().domainRelay(domain.id);
      expect(relay.domainId, domain.id);
      expect(relay.transport, OutboundTransport.direct);
      expect(await client().suppressions(domain.id), isEmpty);
      final dns = await client().dnsCheck(domain.id);
      expect(dns.domain, 'three.live.test');
      expect(dns.records, isNotEmpty);
    });

    test('DKIM: a key installed, its rotation set, the key removed', () async {
      final key = await openssl(tmp, [
        'genpkey',
        '-algorithm',
        'RSA',
        '-pkeyopt',
        'rsa_keygen_bits:2048',
      ]);
      final installed = await client().setDkimKey(
        domain.id,
        selector: 'live',
        privateKey: key,
      );
      expect(installed.selector, 'live');
      expect(installed.hasKey, isTrue);
      expect(
        (await client().dkimKeys()).where((k) => k.domainId == domain.id),
        isNotEmpty,
      );
      expect((await client().setDkimRotation(domain.id, 90)).intervalDays, 90);
      expect((await client().dkimRotation(domain.id)).intervalDays, 90);
      await expectLater(
        client().setDkimKey(domain.id, selector: 'live', privateKey: 'nope'),
        refused(422, 'validation_failed'),
      );
      await client().deleteDkimKey(domain.id);
    });

    test('a certificate uploaded, read in full, deleted', () async {
      await openssl(tmp, [
        'req',
        '-x509',
        '-newkey',
        'rsa:2048',
        '-nodes',
        '-days',
        '2',
        '-subj',
        '/CN=three.live.test',
        '-addext',
        'subjectAltName=DNS:three.live.test',
        '-keyout',
        'key.pem',
        '-out',
        'cert.pem',
      ]);
      final certPem = await File('${tmp.path}/cert.pem').readAsString();
      final keyPem = await File('${tmp.path}/key.pem').readAsString();
      final cert = await client().uploadCertificate(
        domainId: domain.id,
        certPem: certPem,
        keyPem: keyPem,
      );
      expect(cert.domainId, domain.id);
      expect(cert.notAfter, isNotNull);
      final detail = await client().certificate(cert.id);
      expect(detail.certPem, contains('BEGIN CERTIFICATE'));
      expect(
        (await client().certificates()).items.map((c) => c.id),
        contains(cert.id),
      );
      // With a certificate of its own, the domain may go live.
      expect(
        (await client().updateDomain(domain.id, active: true)).active,
        isTrue,
      );
      await client().updateDomain(domain.id, active: false);
      await client().deleteCertificate(cert.id);
      await expectLater(client().certificate(cert.id), refused(404));
    });

    test(
      'superadmin switched on for a while, a scoped grant, switched off',
      () async {
        final roles = await client().roles();
        expect(roles.map((r) => r.name), containsAll(['admin', 'superadmin']));
        expect(await client().capabilityDefinitions(), isNotEmpty);

        // A fresh install's admin holds admin, and superadmin only eligible.
        final mine = await client().myGrants();
        final superadmin = mine.singleWhere((g) => g.role == 'superadmin');
        expect(superadmin.mode, GrantMode.eligible);
        expect(superadmin.activation, isNull);

        final account = await client().createAccount(
          address: 'ana@three.live.test',
          password: 'a mailbox password, long enough',
        );
        final role = roles.firstWhere((r) => r.name == 'admin');
        // Changing grants needs superadmin, switched on.
        await expectLater(
          client().createGrant(
            holder: GrantHolder.account(account.id),
            role: role.name,
            scope: 'domain:three.live.test',
          ),
          refused(403),
        );
        await expectLater(
          client().activateGrant(superadmin.id, reason: 'live test'),
          refused(403, 'totp_required'),
        );
        final on = await client().activateGrant(
          superadmin.id,
          reason: 'live test',
          minutes: 5,
          totpCode: await admin.freshCode(),
        );
        expect(on.grant.activation, isNotNull);
        expect(on.grant.activation!.reason, 'live test');
        expect(on.grant.activation!.secondsLeft, greaterThan(0));
        expect(on.capabilities, isNotNull);

        final grant = await client().createGrant(
          holder: GrantHolder.account(account.id),
          role: role.name,
          scope: 'domain:three.live.test',
        );
        expect(grant.holder.id, account.id);
        expect(grant.scope, 'domain:three.live.test');
        expect(grant.mode, GrantMode.active);
        final holder = GrantHolder.account(account.id);
        expect((await client().grants(holder: holder)).items.map((g) => g.id), [
          grant.id,
        ]);
        await client().deleteGrant(grant.id);
        expect((await client().grants(holder: holder)).items, isEmpty);

        final off = await client().deactivateGrant(superadmin.id);
        expect(off.grant.activation, isNull);
        await expectLater(
          client().deactivateGrant(superadmin.id),
          refused(409, 'not_active'),
        );

        final mailbox = (await client().mailboxes(
          domainId: domain.id,
        )).items.singleWhere((m) => m.address == 'ana@three.live.test');
        await client().deleteMailbox(mailbox.id);
      },
    );

    test('bans: an address banned, found, lifted by IP', () async {
      final ban = await client().createBan(
        ip: '192.0.2.77',
        createdBy: liveEmail,
        reason: 'live test',
        protocol: 'imap',
        duration: const Duration(hours: 1),
      );
      expect(ban.ip, '192.0.2.77');
      expect(ban.protocol, 'imap');
      expect(ban.expiresAt, isNotNull);
      expect((await client().bans(ip: '192.0.2.77')).items.map((b) => b.id), [
        ban.id,
      ]);
      await client().unbanIP('192.0.2.77');
      await expectLater(client().unbanIP('192.0.2.77'), refused(404));
    });

    test(
      'the queue: listed, counted, a bulk change that matches nothing',
      () async {
        final page = await client().queue();
        expect(page.items, isEmpty);
        final stats = await client().queueStats();
        expect(stats.total, 0);
        final none = await client().bulkRetryQueue(
          QueueSelection.filter(const QueueFilter(domain: 'nowhere.test')),
        );
        expect(none.affected, 0);
        await expectLater(client().queueEntry(999999), refused(404));
      },
    );

    test(
      'pipelines: the new domain has its two, and a filter tested',
      () async {
        final mine = (await client().pipelines()).items
            .where((p) => p.domainId == domain.id)
            .toList();
        expect(mine.map((p) => p.direction).toSet(), {'inbound', 'outbound'});
        final inbound = mine.firstWhere((p) => p.direction == 'inbound');
        final updated = await client().updatePipeline(
          inbound.id,
          active: false,
        );
        expect(updated.active, isFalse);
        await client().updatePipeline(inbound.id, active: true);
        expect(await client().customFilters(), isA<OffsetPage<CustomFilter>>());
      },
    );

    test(
      'reports: audit, its chain, logs, analytics and TLS reports',
      () async {
        final audit = await client().audit(limit: 10);
        expect(audit.items, isNotEmpty);
        final check = await client().verifyAudit();
        expect(check.ok, isTrue);
        expect(await client().deliveryLog(), isA<OffsetPage<QueueEntry>>());
        expect(await client().pipelineLog(), isA<OffsetPage<MessageTrace>>());
        expect(await client().tlsReports(), isA<OffsetPage<TlsReport>>());
        final analytics = await client().pipelineAnalytics(
          since: DateTime.now().subtract(const Duration(hours: 1)),
        );
        expect(analytics, isNotNull);
        await expectLater(client().messageTrace(999999), refused(404));
      },
    );

    test(
      'a refresh rotates the session, and the old refresh token is spent',
      () async {
        final before = client().tokens!;
        final after = await client().refresh();
        expect(after.refreshToken, isNot(before.refreshToken));
        expect(after.accessToken, isNot(before.accessToken));
        expect(await client().stats(), isNotNull);

        final stale = RestmailClient(server: liveServer, tokens: before);
        addTearDown(stale.close);
        await expectLater(stale.refresh(), throwsA(anything));
      },
    );
  });
}
