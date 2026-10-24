import 'dart:async';

import '../../l10n/voice.dart';

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
              title: Text(tr(context, 'admin.keys.keyRotation')),
              onTap: () => Navigator.pop(sheet, true),
            ),
            ListTile(
              leading: const Icon(Icons.key_rounded),
              title: Text(
                key.hasKey
                    ? tr(context, 'admin.keys.replaceTheKey')
                    : tr(context, 'admin.keys.setAKey'),
              ),
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
        title: trArgs(context, 'admin.keys.stopSigningMailFromDomain', {
          'domain': (key.domain).toString(),
        }),
        message: tr(context, 'admin.keys.itsKeyIsDeletedFromTheServer'),
        action: tr(context, 'admin.keys.removeKey'),
      ),
    );
    if (!ok || !mounted) return;
    showToast(
      context,
      trArgs(context, 'admin.keys.removedTheKeyForDomain', {
        'domain': (key.domain).toString(),
      }),
    );
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
                      : Text(
                          trArgs(context, 'admin.keys.signsAsDkimSelector', {
                            'dkimSelector': (d.dkimSelector).toString(),
                          }),
                        ),
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
        title: key?.hasKey ?? false
            ? tr(context, 'admin.keys.replaceTheKey')
            : tr(context, 'admin.keys.setAKey'),
        intro: trArgs(context, 'admin.keys.mailFromNameIsSignedWithThis', {
          'name': (name).toString(),
        }),
        fields: [
          AdminField(
            tr(context, 'admin.keys.selector'),
            hint: 'mail',
            initial: selector,
          ),
          AdminField(
            tr(context, 'admin.keys.privateKey'),
            hint: '-----BEGIN PRIVATE KEY-----',
            obscure: true,
            pasteOnly: true,
          ),
        ],
        action: key?.hasKey ?? false
            ? tr(context, 'admin.keys.replaceKey')
            : tr(context, 'admin.keys.setKey'),
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
          ? trArgs(context, 'admin.keys.setTheKeyForName', {
              'name': (name).toString(),
            })
          : trArgs(
              context,
              'admin.keys.signingDomainAsSelectorDomainkeyDomain',
              {
                'domain': (s.domain).toString(),
                'selector': (s.selector).toString(),
              },
            ),
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
        ? trArgs(context, 'admin.keys.rotatedEveryIntervalDaysDays', {
            'intervalDays': (current.intervalDays).toString(),
          })
        : tr(context, 'admin.keys.neverRotated');
    final canWrite = access.canWrite(AdminSection.domainDkim);
    if (!canWrite || current.state != DkimRotationState.stable) {
      final change = await _rotationStatus(key, current, now, canWrite);
      if (change != true || !mounted) return;
    }
    DkimRotation? saved;
    final sent = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'admin.keys.keyRotation'),
        intro: trArgs(context, 'admin.keys.nowHowManyDaysDomainKeepsIts', {
          'now': (now).toString(),
          'domain': (key.domain).toString(),
          'maxIntervalDays': (DkimRotation.maxIntervalDays).toString(),
        }),
        fields: [
          AdminField(
            tr(context, 'admin.keys.daysBetweenRotations'),
            hint: trArgs(context, 'ui.0ToMaxIntervalDays', {
              'maxIntervalDays': (DkimRotation.maxIntervalDays).toString(),
            }),
            initial: '${current.intervalDays}',
          ),
        ],
        action: tr(context, 'common.save'),
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
          ? trArgs(context, 'admin.keys.domainNeverRotated', {
              'domain': (key.domain).toString(),
            })
          : trArgs(context, 'admin.keys.domainRotatedEveryIntervalDaysDays', {
              'domain': (key.domain).toString(),
              'intervalDays': (s.intervalDays).toString(),
            }),
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
      DkimRotationState.awaitingPublication => trArgs(
        context,
        'admin.keys.aNewKeyValueIsReadyThe',
        {'value': (staged?.selector).toString()},
      ),
      DkimRotationState.waitingTtl => trArgs(
        context,
        'admin.keys.aNewKeyValueIsPublishedSigning',
        {
          'value': (staged?.selector).toString(),
          'value2': (_at(staged?.activatesAt)).toString(),
        },
      ),
      DkimRotationState.retiring => trArgs(
        context,
        'admin.keys.signingMovedToTheNewKeyThe',
        {
          'value': (previous?.selector).toString(),
          'value2': (_at(previous?.retireAfter)).toString(),
        },
      ),
    };
    final c = context.rm;
    return showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(tr(context, 'admin.keys.keyRotation')),
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
                showToast(dialog, tr(context, 'admin.keys.recordCopied'));
              },
              child: Text(tr(context, 'admin.keys.copyRecord')),
            ),
          if (canWrite)
            TextButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: Text(tr(context, 'admin.keys.changeInterval')),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(tr(context, 'common.done')),
          ),
        ],
      ),
    );
  }

  String _at(DateTime? time) => time == null
      ? tr(context, 'admin.keys.aTimeTheServerHasNotGiven')
      : DateFormat.yMMMd().add_jm().format(time.toLocal());

  String _age(DkimKey key) {
    final created = key.createdAt;
    if (created == null) return '';
    return trArgs(context, 'ui.setValueValue2', {
      'value': (DateFormat.yMMMd().format(created)).toString(),
      'value2':
          (key.ageSeconds == null
                  ? ''
                  : trArgs(context, 'ui.agesecondsSecondsOld', {
                      'ageSeconds': (key.ageSeconds).toString(),
                    }))
              .toString(),
    });
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: _section,
    scope: _scope,
    title: widget.domain == null
        ? tr(context, 'admin.section.dkim.title')
        : tr(context, 'admin.section.domainDkim.title'),
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: tr(context, 'admin.keys.noDomainSignsItsMail'),
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
                      ? tr(context, 'admin.keys.setAKeyForADomain')
                      : tr(context, 'admin.keys.installOrReplaceKey'),
                ),
                onPressed: () => unawaited(_setKey()),
              ),
            ),
          )
        else
          _addedElsewhere(
            context,
            tr(context, 'admin.keys.settingAKeyNeedsDomainsWrite'),
          ),
      ],
      row: (key) => RmRow(
        label: key.domain,
        subtitle: key.hasKey
            ? '${key.selector}._domainkey.${key.domain}${_age(key)}'
            : tr(context, 'admin.keys.noSigningSelectorIsConfigured'),
        onTap: () => unawaited(_rotationOrKey(key, _keyAccess(key))),
        trailing:
            key.hasKey && _keyAccess(key).canDelete(AdminSection.domainDkim)
            ? RmIconButton(
                icon: Icons.close_rounded,
                tooltip: trArgs(context, 'admin.keys.removeTheKeyForDomain', {
                  'domain': (key.domain).toString(),
                }),
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
        title: tr(context, 'admin.keys.addACertificate'),
        intro: tr(context, 'admin.keys.pasteTheCertificateAndItsPrivateKey'),
        host: _host,
        action: tr(context, 'admin.keys.addCertificate'),
        fields: [
          AdminField(
            tr(context, 'admin.aliases.domain'),
            hint: 'example.com',
            email: true,
          ),
          AdminField(
            tr(context, 'admin.keys.certificate'),
            hint: '-----BEGIN CERTIFICATE-----',
            multiline: true,
          ),
          AdminField(
            tr(context, 'admin.keys.privateKey'),
            hint: '-----BEGIN PRIVATE KEY-----',
            obscure: true,
            pasteOnly: true,
          ),
          AdminField(
            tr(context, 'admin.keys.renewsByItself'),
            initial: 'yes',
            choices: [
              ('', tr(context, 'admin.keys.serverDefault')),
              ('yes', tr(context, 'admin.keys.yes')),
              ('no', tr(context, 'admin.keys.no')),
            ],
          ),
        ],
        submit: (values) async {
          final invalidRenewal = tr(
            context,
            'admin.keys.renewsByItselfIsYesOrNo',
          );
          final invalidRenewalField = tr(context, 'admin.keys.isYesOrNo');
          final cert = await client.uploadCertificate(
            domainId: await _domainId(values[0]),
            certPem: values[1],
            keyPem: values[2],
            autoRenew: switch (values[3].toLowerCase()) {
              '' => null,
              'yes' || 'y' || 'true' => true,
              'no' || 'n' || 'false' => false,
              _ => throw ApiException(
                400,
                'bad_request',
                invalidRenewal,
                fields: {'renews_by_itself': invalidRenewalField},
              ),
            },
          );
          if (mounted) setState(() => _added = cert);
        },
      ),
    );
    if (!added || !mounted) return;
    final cert = _added!;
    showToast(
      context,
      trArgs(context, 'admin.keys.addedTheCertificateForValue', {
        'value': (_name(context, cert)).toString(),
      }),
    );
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
      throw ApiException(
        422,
        'validation_failed',
        tr(context, 'admin.keys.invalidDomain'),
        fields: {
          'domain': tr(context, 'admin.keys.mustBeAPositiveDomainNumber'),
        },
      );
    }
    final missingDomain = tr(context, 'admin.keys.domainNotFound');
    final missingDomainField = tr(context, 'admin.keys.isnTOneThisServerHolds');
    final names = await domainNames(widget.account);
    for (final MapEntry(:key, value: name) in names.entries) {
      if (name.toLowerCase() == value.toLowerCase()) return key;
    }
    throw ApiException(
      404,
      'not_found',
      missingDomain,
      fields: {'domain': missingDomainField},
    );
  }

  Future<void> _delete(TlsCertificate cert) async {
    final name = _name(context, cert);
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteCertificate(cert.id),
      confirm: (
        title: trArgs(context, 'admin.keys.deleteTheCertificateForName', {
          'name': (name).toString(),
        }),
        message: tr(context, 'admin.keys.theServerStopsUsingItAndForgets'),
        action: tr(context, 'message.delete'),
      ),
    );
    if (!ok || !mounted) return;
    showToast(
      context,
      trArgs(context, 'admin.keys.deletedTheCertificateForName', {
        'name': (name).toString(),
      }),
    );
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.certificates,
    title: tr(context, 'admin.section.certificates.title'),
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: tr(context, 'admin.keys.theServerHoldsNoCertificates'),
      header: [
        if (access.canWrite(AdminSection.certificates))
          AdminAddButton(
            label: tr(context, 'admin.keys.addACertificate'),
            onTap: () => unawaited(_upload()),
          ),
      ],
      row: (cert) => RmRow(
        label: _name(context, cert),
        onTap: () => pushScreen(
          context,
          CertificateScreen(account: widget.account, id: cert.id),
        ),
        subtitle: [
          _expiry(context, cert),
          if (cert.issuer.isNotEmpty)
            trArgs(context, 'admin.keys.fromValue', {
              'value': (_issuer(cert.issuer)).toString(),
            }),
          if (cert.autoRenew) tr(context, 'admin.keys.renewsByItself'),
        ].join('\n'),
        trailing: access.canDelete(AdminSection.certificates)
            ? RmIconButton(
                icon: Icons.close_rounded,
                tooltip: trArgs(
                  context,
                  'admin.keys.deleteTheCertificateForValue',
                  {'value': (_name(context, cert)).toString()},
                ),
                color: context.rm.ink3,
                onPressed: () => unawaited(_delete(cert)),
              )
            : null,
      ),
    ),
  );
}

String _name(BuildContext context, TlsCertificate cert) =>
    cert.domain.isNotEmpty
    ? cert.domain
    : trArgs(context, 'admin.keys.domainDomainId', {
        'domainId': (cert.domainId).toString(),
      });

String _expiry(
  BuildContext context,
  BuildContext context,
  TlsCertificate cert,
) {
  final date = DateFormat.yMMMd().format(cert.notAfter);
  final days = cert.notAfter.difference(DateTime.now()).inDays;
  if (days < 0) {
    return trArgs(context, 'admin.keys.ranOutDate', {
      'date': (date).toString(),
    });
  }
  if (days == 0) return tr(context, 'admin.keys.runsOutToday');
  return trArgs(context, 'admin.keys.runsOutDateInValue', {
    'date': (date).toString(),
    'value':
        (days == 1
                ? tr(context, 'ui.aDay')
                : trArgs(context, 'ui.daysDays', {'days': (days).toString()}))
            .toString(),
  });
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
      ? tr(context, 'admin.keys.notGiven')
      : DateFormat.yMMMd().add_jm().format(time.toLocal());

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.certificates,
    title: tr(context, 'admin.keys.certificate'),
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
                label: tr(context, 'admin.aliases.domain'),
                value: _name(context, cert),
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
              RmRow(
                label: tr(context, 'admin.granttext.expiry'),
                value: _expiry(context, cert),
              ),
              RmRow(
                label: tr(context, 'admin.keys.validFrom'),
                value: _when(cert.notBefore),
              ),
              RmRow(
                label: tr(context, 'admin.keys.validUntil'),
                value: _when(cert.notAfter),
              ),
              RmRow(
                label: tr(context, 'admin.keys.issuer'),
                value: cert.issuer.isEmpty
                    ? tr(context, 'admin.keys.notGiven')
                    : _issuer(cert.issuer),
                subtitle: cert.issuer.isEmpty ? null : cert.issuer,
              ),
              RmRow(
                label: tr(context, 'admin.keys.renewsByItself'),
                value: cert.autoRenew
                    ? tr(context, 'admin.keys.yes')
                    : tr(context, 'admin.keys.no'),
              ),
              RmRow(
                label: tr(context, 'admin.aliases.added'),
                value: _when(cert.createdAt),
              ),
              RmRow(
                label: tr(context, 'admin.domains.changed'),
                value: _when(cert.updatedAt),
              ),
              RmRow(
                label: tr(context, 'admin.keys.certificateNumber'),
                value: '${cert.id}',
              ),
              RmRow(
                label: tr(context, 'admin.keys.domainNumber'),
                value: '${cert.domainId}',
              ),
              if (cert.certPem.isNotEmpty) ...[
                const SizedBox(height: 18),
                SectionLabel(tr(context, 'admin.keys.certificate')),
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
