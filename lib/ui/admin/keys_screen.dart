import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

/// A note above a list whose things are added from a computer.
Widget _addedElsewhere(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: Text(text, style: rmText(13, color: context.rm.ink3, height: 1.4)),
);

/// The domains whose outgoing mail is signed, and the selector each key is
/// published under. The keys themselves never leave the server: one is
/// sent once, when it is set or replaced, and never shown again.
class DkimScreen extends StatefulWidget {
  const DkimScreen({super.key, required this.account, this.domain});

  /// No global key-list request is made when opened for one domain.
  final AdminDomain? domain;

  final RestAccount account;

  @override
  State<DkimScreen> createState() => _DkimScreenState();
}

class _DkimScreenState extends State<DkimScreen> {
  AdminSection get _section =>
      widget.domain == null ? AdminSection.dkim : AdminSection.domainDkim;
  late final _list = AdminList<DkimKey>((offset) async {
    if (widget.domain case final domain?) {
      final fresh = await widget.account.client.domain(domain.id);
      final key = DkimKey(
        domainId: fresh.id,
        domain: fresh.name,
        selector: fresh.dkimSelector,
        hasKey: fresh.dkimSelector.isNotEmpty,
      );
      return OffsetPage([key], offset: 0, total: 1);
    }
    final keys = await widget.account.client.dkimKeys();
    return OffsetPage(keys, offset: 0, total: keys.length);
  });

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(_section)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  /// Tapping a key: its rotation, or with `domains:write` the choice of
  /// rotation or a replacement key.
  Future<void> _rotationOrKey(DkimKey key, AdminAccess access) async {
    if (!access.canWrite(_section)) return _rotation(key, access);
    final choice = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.schedule_rounded),
              title: const Text('Key rotation'),
              onTap: () => Navigator.pop(sheet, true),
            ),
            ListTile(
              leading: const Icon(Icons.key_rounded),
              title: Text(key.hasKey ? 'Replace the key' : 'Set a key'),
              onTap: () => Navigator.pop(sheet, false),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    return choice ? _rotation(key, access) : _setKey(key: key);
  }

  Future<void> _remove(DkimKey key) async {
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteDkimKey(key.domainId),
      confirm: (
        title: 'Stop signing mail from ${key.domain}?',
        message:
            'Its key is deleted from the server, and its mail goes out '
            'unsigned until a new key is set. Servers '
            'that check DMARC may turn it away.',
        action: 'Remove key',
      ),
    );
    if (!ok || !mounted) return;
    showToast(context, 'Removed the key for ${key.domain}');
    unawaited(_list.reload());
  }

  /// Sets or replaces a domain's key. [domain] is null to pick one.
  Future<void> _setKey({AdminDomain? domain, DkimKey? key}) async {
    var target = domain ?? widget.domain;
    if (target == null && key == null) {
      final domains = <AdminDomain>[];
      try {
        var offset = 0;
        while (true) {
          final page = await widget.account.client.domains(
            offset: offset,
            limit: 200,
          );
          domains.addAll(page.items);
          if (!page.hasMore || page.items.isEmpty) break;
          offset = page.next;
        }
      } on ApiException catch (e) {
        if (mounted) showToast(context, describeAdminError(e, host: _host));
        return;
      }
      if (!mounted) return;
      target = await showModalBottomSheet<AdminDomain>(
        context: context,
        builder: (sheet) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final d in domains)
                ListTile(
                  title: Text(d.name),
                  subtitle: d.dkimSelector.isEmpty
                      ? null
                      : Text('Signs as ${d.dkimSelector}'),
                  onTap: () => Navigator.pop(sheet, d),
                ),
            ],
          ),
        ),
      );
      if (target == null || !mounted) return;
    }
    final domainId = key?.domainId ?? target!.id;
    final name = key?.domain ?? target!.name;
    final selector = key?.selector ?? target?.dkimSelector ?? '';
    DkimKey? saved;
    final sent = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: key?.hasKey ?? false ? 'Replace the key' : 'Set a key',
        intro:
            'Mail from $name is signed with this key. Publish its public '
            'key at <selector>._domainkey.$name first. The key is sent once '
            'and never shown again.',
        fields: [
          AdminField('Selector', hint: 'mail', initial: selector),
          const AdminField(
            'Private key',
            hint: '-----BEGIN PRIVATE KEY-----',
            obscure: true,
            pasteOnly: true,
          ),
        ],
        action: key?.hasKey ?? false ? 'Replace key' : 'Set key',
        host: _host,
        submit: (values) async {
          saved = await widget.account.client.setDkimKey(
            domainId,
            selector: values[0],
            privateKey: values[1],
          );
        },
      ),
    );
    if (!sent || !mounted) return;
    final s = saved;
    showToast(
      context,
      s == null
          ? 'Set the key for $name'
          : 'Signing ${s.domain} as ${s.selector}._domainkey.${s.domain}',
    );
    unawaited(_list.reload());
  }

  /// Reads a domain's rotation and, with `domains:write`, changes it.
  Future<void> _rotation(DkimKey key, AdminAccess access) async {
    final DkimRotation current;
    try {
      current = await widget.account.client.dkimRotation(key.domainId);
    } on ApiException catch (e) {
      if (mounted) showToast(context, describeAdminError(e, host: _host));
      return;
    }
    if (!mounted) return;
    final now = current.enabled
        ? 'Rotated every ${current.intervalDays} days.'
        : 'Never rotated.';
    if (!access.canWrite(_section)) {
      await showDialog<void>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text('Key rotation'),
          content: Text('${key.domain}: $now'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog),
              child: const Text('Done'),
            ),
          ],
        ),
      );
      return;
    }
    DkimRotation? saved;
    final sent = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Key rotation',
        intro:
            '$now How many days ${key.domain} keeps its key before a new '
            'one is due: 0 never rotates it, at most '
            '${DkimRotation.maxIntervalDays}.',
        fields: [
          AdminField(
            'Days between rotations',
            hint: '0 to ${DkimRotation.maxIntervalDays}',
            initial: '${current.intervalDays}',
          ),
        ],
        action: 'Save',
        host: _host,
        submit: (values) async {
          // Anything but a whole number goes as -1, which the server
          // refuses with the range it takes.
          saved = await widget.account.client.setDkimRotation(
            key.domainId,
            int.tryParse(values[0]) ?? -1,
          );
        },
      ),
    );
    if (!sent || !mounted) return;
    final s = saved;
    showToast(
      context,
      s == null || !s.enabled
          ? '${key.domain}: never rotated'
          : '${key.domain}: rotated every ${s.intervalDays} days',
    );
  }

  String _age(DkimKey key) {
    final created = key.createdAt;
    if (created == null) return '';
    return ' · set ${DateFormat.yMMMd().format(created)}${key.ageSeconds == null ? '' : ' · ${key.ageSeconds} seconds old'}';
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: _section,
    title: widget.domain == null ? 'DKIM keys' : 'DKIM signing',
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: 'No domain signs its mail.',
      header: [
        if (access.canWrite(_section))
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  widget.domain == null
                      ? 'Set a key for a domain'
                      : 'Install or replace key',
                ),
                onPressed: () => unawaited(_setKey()),
              ),
            ),
          )
        else
          _addedElsewhere(context, 'Setting a key needs domains:write.'),
      ],
      row: (key) => RmRow(
        label: key.domain,
        subtitle: key.hasKey
            ? '${key.selector}._domainkey.${key.domain}${_age(key)}'
            : 'No signing selector is configured',
        onTap: () => unawaited(_rotationOrKey(key, access)),
        trailing: key.hasKey && access.canDelete(_section)
            ? RmIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Remove the key for ${key.domain}',
                color: context.rm.ink3,
                onPressed: () => unawaited(_remove(key)),
              )
            : null,
      ),
    ),
  );
}

/// The issuing organisation from a certificate's issuer name, or all of it.
String _issuer(String name) =>
    RegExp(r'(?:^|,)\s*O=([^,]+)').firstMatch(name)?.group(1)?.trim() ?? name;

/// The TLS certificates each domain is served with, and when they run out.
/// As with DKIM keys, new ones are added in the admin webmail, which takes
/// their private key.
class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  late final _list = AdminList<TlsCertificate>(
    (offset) => widget.account.client.certificates(offset: offset),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.certificates)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  String _name(TlsCertificate cert) =>
      cert.domain.isNotEmpty ? cert.domain : 'Domain ${cert.domainId}';

  String _expiry(TlsCertificate cert) {
    final date = DateFormat.yMMMd().format(cert.notAfter);
    final days = cert.notAfter.difference(DateTime.now()).inDays;
    if (days < 0) return 'Ran out $date';
    if (days == 0) return 'Runs out today';
    return 'Runs out $date, in ${days == 1 ? 'a day' : '$days days'}';
  }

  Future<void> _delete(TlsCertificate cert) async {
    final name = _name(cert);
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteCertificate(cert.id),
      confirm: (
        title: 'Delete the certificate for $name?',
        message:
            'The server stops using it. A new one is added in the admin '
            'webmail.',
        action: 'Delete',
      ),
    );
    if (!ok || !mounted) return;
    showToast(context, 'Deleted the certificate for $name');
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.certificates,
    title: 'Certificates',
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: 'The server holds no certificates.',
      header: [
        _addedElsewhere(
          context,
          'New certificates are added in the admin webmail.',
        ),
      ],
      row: (cert) => RmRow(
        label: _name(cert),
        subtitle: [
          _expiry(cert),
          if (cert.issuer.isNotEmpty) 'From ${_issuer(cert.issuer)}',
          if (cert.autoRenew) 'Renews by itself',
        ].join('\n'),
        trailing: access.canDelete(AdminSection.certificates)
            ? RmIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Delete the certificate for ${_name(cert)}',
                color: context.rm.ink3,
                onPressed: () => unawaited(_delete(cert)),
              )
            : null,
      ),
    ),
  );
}
