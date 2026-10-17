import 'package:restmail_api/restmail_api.dart';

/// A part of the server's administration, and the capabilities it takes: one
/// to see it, one to change what is in it, one to delete. This table is the
/// only place the app decides who sees what in Administration, by the
/// server's capability names. The screens ask [AdminAccess]; where the
/// capabilities come from (an admin user's sign-in today, a mailbox's grants
/// after rest-mail-server#347) does not matter to them.
///
/// Hiding is for comfort: the server checks every request, and the app shows
/// its 403 for what it is.
enum AdminSection {
  queue(
    'Outbound queue',
    'Mail waiting to go to other servers',
    read: Capability.queueRead,
    write: Capability.queueManage,
    delete: Capability.queueManage,
  ),
  domains(
    'Domains',
    'The domains this server holds mail for',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsDelete,
  ),
  mailboxes(
    'Mailboxes',
    'Who has mail here',
    read: Capability.mailboxesRead,
    write: Capability.mailboxesWrite,
    delete: Capability.mailboxesDelete,
  ),
  aliases(
    'Aliases',
    'Addresses that deliver to another',
    read: Capability.mailboxesRead,
    write: Capability.mailboxesWrite,
    delete: Capability.mailboxesDelete,
  ),
  users(
    'Administrators',
    'Who runs this server, and their roles',
    read: Capability.usersRead,
    write: Capability.usersWrite,
    delete: Capability.usersDelete,
  ),
  bans(
    'Bans',
    'Addresses kept out of SMTP, IMAP and POP3',
    read: Capability.bansRead,
    write: Capability.bansWrite,
    delete: Capability.bansDelete,
  );

  const AdminSection(
    this.title,
    this.subtitle, {
    required this.read,
    required this.write,
    required this.delete,
  });

  final String title;
  final String subtitle;

  /// To see the section at all.
  final String read;

  /// To add and change what is in it; for the queue, to retry and bounce.
  final String write;

  /// To delete what is in it.
  final String delete;
}

/// What a session's capabilities let it see and do in Administration.
class AdminAccess {
  const AdminAccess(this.capabilities);

  final Capabilities capabilities;

  bool canRead(AdminSection section) => capabilities.allows(section.read);
  bool canWrite(AdminSection section) => capabilities.allows(section.write);
  bool canDelete(AdminSection section) => capabilities.allows(section.delete);

  /// The sections to show, in the order a phone wants them.
  List<AdminSection> get sections => [
    for (final section in AdminSection.values)
      if (canRead(section)) section,
  ];

  /// Whether to show the way into Administration: only when there is
  /// something in it this session may see.
  bool get any => sections.isNotEmpty;
}
