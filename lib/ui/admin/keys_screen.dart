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
