import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Future<RestmailClient> _admin(FakeRestmail fake) async {
  final client = RestmailClient(
    server: Uri.parse('https://${fake.host}'),
    httpClient: fake.client,
  );
  await client.login(
    email: FakeAccounts.adminEmail,
    password: FakeAccounts.adminPassword,
    totpCode: FakeAccounts.totpCode,
  );
  return client;
}

void main() {
  test(
    'delivery filters before counting and paging, with inclusive dates',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _admin(fake);
      addTearDown(client.close);
      final first = fake.queue.first;
      final page = await client.deliveryLog(
        domain: first.domain,
        sender: first.sender.toUpperCase(),
        recipient: first.recipient.toUpperCase(),
        status: QueueStatus.parse(first.status),
        since: first.createdAt,
        until: first.createdAt,
        limit: 1,
      );
      expect(page.items.single.id, first.id);
      expect(page.total, 1);
      expect((await client.deliveryLog(domain: 'other.test')).total, 0);
      expect((await client.deliveryLog(sender: '%')).total, 0);
      expect(
        (await client.deliveryLog(
          since: first.createdAt.add(const Duration(days: 100)),
        )).total,
        0,
      );
      final initial = await client.deliveryLog(limit: 1);
      final next = await client.deliveryLog(limit: 1, offset: initial.next);
      expect(initial.hasMore, isTrue);
      expect(next.items.single.id, isNot(initial.items.single.id));
    },
  );

  test(
    'pipeline filters cover exact correlation, reason and terminal action',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _admin(fake);
      addTearDown(client.close);
      final entry = (await client.pipelineLog(outcome: 'rejected')).items.first;
      final filtered = await client.pipelineLog(
        pipelineId: entry.pipelineId,
        direction: entry.direction,
        action: entry.finalAction,
        rfcMessageId: entry.rfcMessageId,
        outcome: entry.outcome,
        reasonCode: entry.reasonCode,
      );
      expect(filtered.items.single.id, entry.id);
      expect(filtered.total, 1);
      expect(
        (await client.pipelineLog(
          rfcMessageId: entry.rfcMessageId.substring(1),
        )).total,
        0,
      );
      expect((await client.pipelineLog(pipelineId: 99999)).total, 0);
      expect((await client.pipelineLog(reasonCode: 'unknown')).total, 0);
      final stage = filtered.items.single.stages.first;
      expect(stage.filterType, 'action');
      expect(stage.durationMilliseconds, 18);
      expect(stage.log, isNotEmpty);
      expect(filtered.items.single.sampled, isTrue);
    },
  );

  test(
    'TLS filters use literal reporter matching and filtered totals',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _admin(fake);
      addTearDown(client.close);
      final report = (await client.tlsReports(
        reportingOrg: 'MICROSOFT',
      )).items.single;
      final filtered = await client.tlsReports(
        domainId: report.domainId,
        policyType: 'sts',
        reportingOrg: 'Corporation',
        limit: 1,
      );
      expect(filtered.total, 1);
      expect(filtered.items.single.id, report.id);
      expect(report.createdAt, isNotNull);
      expect(report.failureDetails, isNotEmpty);
      expect((await client.tlsReports(reportingOrg: '%')).total, 0);
      expect((await client.tlsReports(policyType: 'no-policy')).total, 0);
      expect((await client.tlsReports(domainId: 99999)).total, 0);
    },
  );

  test(
    'audit filters by actor identity, name, action, bounds and cursor',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _admin(fake);
      addTearDown(client.close);
      final actor = fake.auditLog.lastWhere((e) => e.actorId != null);
      final page = await client.audit(
        actorKind: actor.actorKind,
        actorId: actor.actorId,
        actor: actor.actorName.toUpperCase(),
        action: actor.action,
        outcome: actor.outcome,
        since: actor.occurredAt,
        until: actor.occurredAt,
        limit: 1,
      );
      expect(page.items.single.seq, actor.seq);
      expect((await client.audit(actor: '%')).items, isEmpty);
      expect((await client.audit(actorId: 99999)).items, isEmpty);
      expect((await client.audit(action: 'unknown')).items, isEmpty);
      final first = await client.audit(limit: 1);
      final next = await client.audit(limit: 1, before: first.cursor);
      expect(first.hasMore, isTrue);
      expect(next.items.single.seq, lessThan(first.items.single.seq));
    },
  );

  test(
    'anchor verifies saved history, rejects mismatches and missing anchors',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final client = await _admin(fake);
      addTearDown(client.close);
      final entry = (await client.audit()).items.last;
      final anchor = '${entry.seq}:${entry.hash.toUpperCase()}';
      final proof = await client.verifyAudit(anchor: anchor);
      expect(proof.ok, isTrue);
      expect(proof.anchor!.hash, entry.hash);
      final changed = await client.verifyAudit(
        anchor: '${entry.seq}:${'0' * 64}',
      );
      expect(changed.ok, isFalse);
      expect(changed.brokenAtSeq, entry.seq);
      final missing = await client.verifyAudit(anchor: '999999:${'0' * 64}');
      expect(missing.ok, isFalse);
      expect(missing.reason, contains('no longer'));
      await expectLater(
        client.verifyAudit(anchor: 'broken'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields,
            'fields',
            contains('anchor'),
          ),
        ),
      );
    },
  );

  test(
    'analytics supports precise duration, explicit start and cumulative totals',
    () async {
      final now = DateTime.now().toUtc();
      final fake = FakeRestmail(clock: () => now);
      addTearDown(fake.close);
      final client = await _admin(fake);
      addTearDown(client.close);
      final recent = await client.pipelineAnalytics(windowText: '1h30m0.5s');
      expect(
        recent.until.difference(recent.since),
        const Duration(minutes: 90, milliseconds: 500),
      );
      expect(recent.windowLabel, '1h30m0.5s');
      expect(recent.liveTotals, isNotNull);
      final since = now.subtract(const Duration(days: 3));
      final explicit = await client.pipelineAnalytics(
        since: since,
        windowText: '1s',
      );
      expect(explicit.since.toUtc(), since);
      expect(explicit.windowLabel, isEmpty);
      num total(PipelineFunnel funnel) =>
          funnel.outcomes.fold<num>(0, (sum, r) => sum + r.count);
      expect(total(recent.liveTotals!), greaterThanOrEqualTo(total(explicit)));
      expect(total(explicit), greaterThanOrEqualTo(total(recent)));
    },
  );

  test(
    'report enum refusals preserve session, and each report checks permission',
    () async {
      final fake = FakeRestmail();
      addTearDown(fake.close);
      final admin = await _admin(fake);
      addTearDown(admin.close);
      for (final call in [
        () => admin.pipelineLog(action: 'invalid'),
        () => admin.pipelineLog(direction: 'invalid'),
        () => admin.pipelineLog(outcome: 'invalid'),
        () => admin.tlsReports(policyType: 'invalid'),
      ]) {
        await expectLater(
          call(),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 422),
          ),
        );
      }
      final client = RestmailClient(
        server: Uri.parse('https://${fake.host}'),
        httpClient: fake.client,
      );
      addTearDown(client.close);
      await client.login(
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      final tokens = client.tokens;
      for (final call in [
        () => client.deliveryLog(),
        () => client.pipelineLog(),
        () => client.tlsReports(),
        () => client.audit(),
        () => client.verifyAudit(),
        () => client.pipelineAnalytics(),
      ]) {
        await expectLater(
          call(),
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 403),
          ),
        );
        expect(client.tokens, same(tokens));
      }
    },
  );
}
