import 'dart:async';

import 'package:flutter/material.dart';
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
/// published under. The keys themselves never leave the server. A key is
/// set in the admin webmail: pasting a private key on a phone would put it
/// on the clipboard, where other apps can read it.
class DkimScreen extends StatefulWidget {
  const DkimScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<DkimScreen> createState() => _DkimScreenState();
}

class _DkimScreenState extends State<DkimScreen> {
  late final _list = AdminList<DkimKey>((offset) async {
    final keys = await widget.account.client.dkimKeys();
    return OffsetPage(keys, offset: 0, total: keys.length);
  });

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.dkim)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
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
            'unsigned until a new key is set in the admin webmail. Servers '
            'that check DMARC may turn it away.',
        action: 'Remove key',
      ),
    );
    if (!ok || !mounted) return;
    showToast(context, 'Removed the key for ${key.domain}');
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.dkim,
    title: 'DKIM keys',
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: 'No domain signs its mail.',
      header: [
        _addedElsewhere(context, 'New keys are set in the admin webmail.'),
      ],
      row: (key) => RmRow(
        label: key.domain,
        subtitle: '${key.selector}._domainkey.${key.domain}',
        trailing: access.canDelete(AdminSection.dkim)
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
              snapshot.error!,
              host: widget.account.server.host,
            ),
            onRetry: () => setState(() => _cert = _load()),
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
            setState(() => _cert = next);
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
