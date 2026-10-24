import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'domains_screen.dart';

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
  String? get _scope => widget.domain == null
      ? null
      : CapabilityScope.domain(widget.domain!.name);
  AdminAccess _keyAccess(DkimKey key) => AdminAccess(
    widget.account.capabilities,
    scope: CapabilityScope.domain(key.domain),
  );
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
    if (AdminAccess(
      widget.account.capabilities,
      scope: _scope,
    ).canRead(_section)) {
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
    if (!access.canWrite(AdminSection.domainDkim)) {
      return _rotation(key, access);
    }
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
          domains.addAll(
            page.items.where(
              (d) => widget.account.capabilities.allows(
                Capability.domainsWrite,
                scope: CapabilityScope.domain(d.name),
              ),
            ),
          );
          if (!page.hasMore || page.items.isEmpty) break;
          offset = page.next;
        }
      } on ApiException catch (e) {
        if (mounted) {
          showToast(context, describeAdminError(context, e, host: _host));
        }
        return;
      }
      if (!mounted) return;
      if (domains.isEmpty) {
        showToast(context, noPermission);
        return;
      }
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
      if (mounted) {
        showToast(context, describeAdminError(context, e, host: _host));
      }
      return;
    }
    if (!mounted) return;
    final now = current.enabled
        ? 'Rotated every ${current.intervalDays} days.'
        : 'Never rotated.';
    final canWrite = access.canWrite(AdminSection.domainDkim);
    if (!canWrite || current.state != DkimRotationState.stable) {
      final change = await _rotationStatus(key, current, now, canWrite);
      if (change != true || !mounted) return;
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

  /// Shows where [rotation] stands: the record a staged key waits for, when
  /// signing moves to it, or when the previous key goes. True asks to change
  /// the interval, which only [canWrite] offers.
  Future<bool?> _rotationStatus(
    DkimKey key,
    DkimRotation rotation,
    String now,
    bool canWrite,
  ) {
    final staged = rotation.staged;
    final previous = rotation.previous;
    final record =
        rotation.state == DkimRotationState.awaitingPublication &&
            staged != null &&
            staged.recordValue.isNotEmpty
        ? staged
        : null;
    final status = switch (rotation.state) {
      DkimRotationState.stable => null,
      DkimRotationState.awaitingPublication =>
        'A new key, ${staged?.selector}, is ready. The rotation goes on once '
            'its record is published:',
      DkimRotationState.waitingTtl =>
        'A new key, ${staged?.selector}, is published. Signing moves to it '
            '${_at(staged?.activatesAt)}.',
      DkimRotationState.retiring =>
        'Signing moved to the new key. The previous key, '
            '${previous?.selector}, stays published until '
            '${_at(previous?.retireAfter)}; then its record can go.',
    };
    final c = context.rm;
    return showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Key rotation'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${key.domain}: $now'),
              if (status != null) ...[const SizedBox(height: 12), Text(status)],
              if (record != null) ...[
                const SizedBox(height: 12),
                SelectableText(
                  '${record.recordName} TXT',
                  style: rmText(13, weight: FontWeight.w600, color: c.ink),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  record.recordValue,
                  style: rmText(12, color: c.ink2, height: 1.35),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (record != null)
            TextButton(
              onPressed: () {
                unawaited(
                  Clipboard.setData(ClipboardData(text: record.recordValue)),
                );
                showToast(dialog, 'Record copied');
              },
              child: const Text('Copy record'),
            ),
          if (canWrite)
            TextButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('Change interval'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _at(DateTime? time) => time == null
      ? 'a time the server has not given'
      : DateFormat.yMMMd().add_jm().format(time.toLocal());

  String _age(DkimKey key) {
    final created = key.createdAt;
    if (created == null) return '';
    return ' · set ${DateFormat.yMMMd().format(created)}${key.ageSeconds == null ? '' : ' · ${key.ageSeconds} seconds old'}';
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: _section,
    scope: _scope,
    title: widget.domain == null ? 'DKIM keys' : 'DKIM signing',
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: 'No domain signs its mail.',
      header: [
        if (widget.domain == null
            ? widget.account.capabilities.allowsSomewhere(
                Capability.domainsWrite,
                domainsOnly: true,
              )
            : access.canWrite(AdminSection.domainDkim))
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
        onTap: () => unawaited(_rotationOrKey(key, _keyAccess(key))),
        trailing:
            key.hasKey && _keyAccess(key).canDelete(AdminSection.domainDkim)
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
/// A new one is pasted in as PEM with its private key, which the server
/// never sends back.
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

  Future<void> _upload() async {
    final client = widget.account.client;
    final added = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Add a certificate',
        intro:
            'Paste the certificate and its private key as PEM. The server '
            'reads who issued it and when it runs out. Its private key '
            'is never returned.',
        host: _host,
        action: 'Add certificate',
        fields: const [
          AdminField('Domain', hint: 'example.com', email: true),
          AdminField(
            'Certificate',
            hint: '-----BEGIN CERTIFICATE-----',
            multiline: true,
          ),
          AdminField(
            'Private key',
            hint: '-----BEGIN PRIVATE KEY-----',
            obscure: true,
            pasteOnly: true,
          ),
          AdminField(
            'Renews by itself',
            initial: 'yes',
            choices: [('', 'Server default'), ('yes', 'Yes'), ('no', 'No')],
          ),
        ],
        submit: (values) async {
          final cert = await client.uploadCertificate(
            domainId: await _domainId(values[0]),
            certPem: values[1],
            keyPem: values[2],
            autoRenew: switch (values[3].toLowerCase()) {
              '' => null,
              'yes' || 'y' || 'true' => true,
              'no' || 'n' || 'false' => false,
              _ => throw const ApiException(
                400,
                'bad_request',
                'Renews by itself is yes or no',
                fields: {'renews_by_itself': 'is yes or no'},
              ),
            },
          );
          if (mounted) setState(() => _added = cert);
        },
      ),
    );
    if (!added || !mounted) return;
    final cert = _added!;
    showToast(context, 'Added the certificate for ${_name(cert)}');
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => CertificateScreen(account: widget.account, id: cert.id),
      ),
    );
    if (mounted) unawaited(_list.reload());
  }

  TlsCertificate? _added;

  /// The id of the domain called [value], or [value] itself when it is one.
  Future<int> _domainId(String value) async {
    if (int.tryParse(value) case final id?) {
      if (id > 0) return id;
      throw const ApiException(
        422,
        'validation_failed',
        'Invalid domain',
        fields: {'domain': 'must be a positive domain number'},
      );
    }
    final names = await domainNames(widget.account);
    for (final MapEntry(:key, value: name) in names.entries) {
      if (name.toLowerCase() == value.toLowerCase()) return key;
    }
    throw const ApiException(
      404,
      'not_found',
      'Domain not found',
      fields: {'domain': "isn't one this server holds"},
    );
  }

  Future<void> _delete(TlsCertificate cert) async {
    final name = _name(cert);
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteCertificate(cert.id),
      confirm: (
        title: 'Delete the certificate for $name?',
        message: 'The server stops using it, and forgets its private key.',
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
        if (access.canWrite(AdminSection.certificates))
          AdminAddButton(
            label: 'Add a certificate',
            onTap: () => unawaited(_upload()),
          ),
      ],
      row: (cert) => RmRow(
        label: _name(cert),
        onTap: () => pushScreen(
          context,
          CertificateScreen(account: widget.account, id: cert.id),
        ),
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

String _name(TlsCertificate cert) =>
    cert.domain.isNotEmpty ? cert.domain : 'Domain ${cert.domainId}';

String _expiry(TlsCertificate cert) {
  final date = DateFormat.yMMMd().format(cert.notAfter);
  final days = cert.notAfter.difference(DateTime.now()).inDays;
  if (days < 0) return 'Ran out $date';
  if (days == 0) return 'Runs out today';
  return 'Runs out $date, in ${days == 1 ? 'a day' : '$days days'}';
}

/// One certificate as the server holds it now, read fresh rather than from
/// the list: its domain, issuer, validity and the certificate itself. Never
/// its private key, which the server does not send.
class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key, required this.account, required this.id});

  final RestAccount account;
  final int id;

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  late Future<TlsCertificate> _cert = _load();

  Future<TlsCertificate> _load() =>
      widget.account.client.certificate(widget.id);

  String _when(DateTime? time) => time == null
      ? 'Not given'
      : DateFormat.yMMMd().add_jm().format(time.toLocal());

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.certificates,
    title: 'Certificate',
    body: (_) => FutureBuilder<TlsCertificate>(
      future: _cert,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return AdminMessage(
            describeAdminError(
              context,
              snapshot.error!,
              host: widget.account.server.host,
            ),
            onRetry: () {
              final next = _load();
              setState(() {
                _cert = next;
              });
            },
          );
        }
        final cert = snapshot.data;
        if (cert == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final c = context.rm;
        return RefreshIndicator(
          onRefresh: () async {
            final next = _load();
            setState(() {
              _cert = next;
            });
            try {
              await next;
            } on ApiException {
              // The FutureBuilder displays the refusal and its retry action.
            }
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
            children: [
              RmRow(
                label: 'Domain',
                value: _name(cert),
                onTap: cert.domainDetails == null
                    ? null
                    : () => pushScreen(
                        context,
                        DomainScreen(
                          account: widget.account,
                          domain: cert.domainDetails!,
                        ),
                      ),
              ),
              RmRow(label: 'Expiry', value: _expiry(cert)),
              RmRow(label: 'Valid from', value: _when(cert.notBefore)),
              RmRow(label: 'Valid until', value: _when(cert.notAfter)),
              RmRow(
                label: 'Issuer',
                value: cert.issuer.isEmpty ? 'Not given' : _issuer(cert.issuer),
                subtitle: cert.issuer.isEmpty ? null : cert.issuer,
              ),
              RmRow(
                label: 'Renews by itself',
                value: cert.autoRenew ? 'Yes' : 'No',
              ),
              RmRow(label: 'Added', value: _when(cert.createdAt)),
              RmRow(label: 'Changed', value: _when(cert.updatedAt)),
              RmRow(label: 'Certificate number', value: '${cert.id}'),
              RmRow(label: 'Domain number', value: '${cert.domainId}'),
              if (cert.certPem.isNotEmpty) ...[
                const SizedBox(height: 18),
                const SectionLabel('Certificate'),
                const SizedBox(height: 8),
                SelectableText(
                  cert.certPem.trim(),
                  style: rmText(12, color: c.ink2, height: 1.35),
                ),
              ],
            ],
          ),
        );
      },
    ),
  );
}
