import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/admin_access.dart';
import 'package:restmail_api/restmail_api.dart';

Capabilities at(String scope, Set<String> names) => Capabilities.fromJson(
  [],
  scoped: [
    for (final name in names) {'capability': name, 'scope': scope},
  ],
);

void main() {
  test(
    'a domain administrator sees scoped core sections, not global reports',
    () {
      final caps = at('domain:a.test', {
        'domains:read',
        'domains:write',
        'domains:delete',
        'mailboxes:read',
        'mailboxes:write',
        'mailboxes:delete',
      });
      final root = AdminAccess(caps);
      expect(root.sections, [
        AdminSection.domains,
        AdminSection.mailboxes,
        AdminSection.aliases,
      ]);
      expect(root.any, isTrue);
      expect(root.canWrite(AdminSection.domains), isFalse);
      expect(root.canWrite(AdminSection.mailboxes), isTrue);
      expect(root.canWrite(AdminSection.aliases), isTrue);
      final domain = AdminAccess(caps, scope: 'domain:a.test');
      expect(domain.canRead(AdminSection.domains), isTrue);
      expect(domain.canWrite(AdminSection.domains), isTrue);
      expect(domain.canDelete(AdminSection.domains), isTrue);
      expect(domain.canRead(AdminSection.senderLists), isTrue);
      expect(domain.canWrite(AdminSection.senderLists), isTrue);
      expect(domain.canRead(AdminSection.relay), isTrue);
      expect(domain.canWrite(AdminSection.relay), isFalse);
      expect(domain.canList(AdminSection.mailboxes), isTrue);
      expect(
        AdminAccess(caps, scope: 'domain:b.test').canRead(AdminSection.domains),
        isFalse,
      );
      expect(
        AdminAccess(
          caps,
          scope: 'domain:b.test',
        ).canWrite(AdminSection.domains),
        isFalse,
      );
    },
  );

  test(
    'a mailbox admin gets no domain or alias access or creation actions',
    () {
      final caps = at('mailbox:x@a.test', {
        'mailboxes:read',
        'mailboxes:write',
        'mailboxes:delete',
      });
      final root = AdminAccess(caps);
      expect(root.sections, [AdminSection.mailboxes]);
      expect(root.canWrite(AdminSection.mailboxes), isFalse);
      expect(root.canWrite(AdminSection.aliases), isFalse);
      final box = AdminAccess(caps, scope: 'mailbox:x@a.test');
      expect(box.canRead(AdminSection.mailboxes), isTrue);
      expect(box.canWrite(AdminSection.mailboxes), isTrue);
      expect(box.canDelete(AdminSection.mailboxes), isTrue);
      final other = AdminAccess(caps, scope: 'mailbox:y@a.test');
      expect(other.canRead(AdminSection.mailboxes), isFalse);
      expect(other.canWrite(AdminSection.mailboxes), isFalse);
      final parent = AdminAccess(caps, scope: 'domain:a.test');
      expect(parent.canRead(AdminSection.domains), isFalse);
      expect(parent.canRead(AdminSection.aliases), isFalse);
      expect(parent.canList(AdminSection.aliases), isFalse);
      expect(parent.canList(AdminSection.mailboxes), isTrue);
      expect(
        AdminAccess(
          caps,
          scope: 'domain:b.test',
        ).canList(AdminSection.mailboxes),
        isFalse,
      );
    },
  );

  test('domain mailbox lists accept matching children without granting the container', () {
    final caps = at('mailbox:x@a.test', {'mailboxes:read'});
    final list = AdminAccess(caps, scope: 'domain:a.test', collection: true);
    expect(list.canRead(AdminSection.mailboxes), isTrue);
    expect(list.canWrite(AdminSection.mailboxes), isFalse);
    expect(list.canRead(AdminSection.aliases), isFalse);
  });

  test('a wildcard at one domain does not unlock any global-only section', () {
    final caps = at('domain:a.test', {'*'});
    final root = AdminAccess(caps);
    for (final section in [
      AdminSection.overview,
      AdminSection.certificates,
      AdminSection.dkim,
      AdminSection.permissions,
      AdminSection.audit,
      AdminSection.queue,
      AdminSection.bans,
      AdminSection.deliveryLog,
      AdminSection.pipelineLog,
      AdminSection.pipelines,
      AdminSection.customFilters,
      AdminSection.trace,
      AdminSection.tlsReports,
    ]) {
      expect(root.canRead(section), isFalse, reason: section.name);
    }
    final domain = AdminAccess(caps, scope: 'domain:a.test');
    expect(domain.canWrite(AdminSection.mtaSts), isTrue);
    expect(domain.canDelete(AdminSection.suppressions), isTrue);
    expect(domain.canWrite(AdminSection.relay), isFalse);
  });

  test('DKIM collection remains global while per-domain reads and writes are scoped', () {
    final scoped = at('domain:a.test', {'domains:read', 'domains:write'});
    expect(AdminAccess(scoped).canRead(AdminSection.dkim), isFalse);
    final target = AdminAccess(scoped, scope: 'domain:a.test');
    expect(target.domainSections, contains(AdminSection.domainDkim));
    expect(target.canRead(AdminSection.domainDkim), isTrue);
    expect(target.canWrite(AdminSection.domainDkim), isTrue);
    expect(target.canDelete(AdminSection.domainDkim), isTrue);
    final other = AdminAccess(scoped, scope: 'domain:b.test');
    expect(other.canRead(AdminSection.domainDkim), isFalse);
    expect(other.canWrite(AdminSection.domainDkim), isFalse);
    expect(other.canDelete(AdminSection.domainDkim), isFalse);
    final mixed = Capabilities.fromJson(
      ['domains:read'],
      scoped: [
        {'capability': 'domains:write', 'scope': 'domain:a.test'},
      ],
    );
    expect(AdminAccess(mixed).canRead(AdminSection.dkim), isTrue);
    expect(
      AdminAccess(
        mixed,
        scope: 'domain:a.test',
      ).canWrite(AdminSection.domainDkim),
      isTrue,
    );
    expect(
      AdminAccess(
        mixed,
        scope: 'domain:b.test',
      ).canWrite(AdminSection.domainDkim),
      isFalse,
    );
    expect(
      AdminAccess(
        at('mailbox:x@a.test', {'domains:read', 'domains:write'}),
        scope: 'domain:a.test',
      ).canRead(AdminSection.domainDkim),
      isFalse,
    );
  });

  test('mail owner capabilities alone do not expose administration', () {
    expect(
      AdminAccess(
        at('mailbox:x@a.test', {
          'mail:read',
          'mail:write',
          'mail:send',
          'mailbox:manage',
        }),
      ).any,
      isFalse,
    );
  });

  test('global access keeps the same sections and relay permissions', () {
    final caps = const Capabilities({'*'});
    final root = AdminAccess(caps);
    expect(
      root.sections.length,
      AdminSection.values.where((s) => s.group != AdminGroup.domain).length,
    );
    expect(
      AdminAccess(caps, scope: 'domain:a.test').canWrite(AdminSection.relay),
      isTrue,
    );
  });
}
