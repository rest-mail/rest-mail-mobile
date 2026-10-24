import 'dart:typed_data';

import 'package:restmail_api/restmail_api.dart';

/// Where one signed-in account's mail comes from. [MailboxState] and the
/// screens see only this, so one app can show a rest-mail server's mail and,
/// an IMAP provider's ([ImapBackend], rest-mail-mobile#36).
///
/// The shapes are rest-mail's own models. A backend that is not rest-mail
/// maps its mail onto them, ids included, and reports failures as
/// [ApiException]s, so the screens handle every account the same way.
abstract interface class MailBackend {
  /// The host the mail comes from, for messages like "Can't reach …".
  String get host;

  /// What the server says it is and which version it runs, or null where
  /// it does not say (IMAP).
  Future<ServerDescription?> describeServer();

  /// The mailboxes this session can show. [Account.isPrimary] marks the one
  /// it signed in with; the others are the ones it created or linked.
  Future<List<Account>> accounts();

  /// Whether [linkAccount] can add more mailboxes to this session. A REST
  /// Mail session can; an IMAP account is one mailbox.
  bool get canLinkMailboxes;

  /// Adds another mailbox on the same server, proving access to it with its
  /// own password, and its code when it has two-factor authentication:
  /// without one that is needed, throws [TotpRequiredException].
  Future<Account> linkAccount({
    required String address,
    required String password,
    String? displayName,
    String? totpCode,
    String? recoveryCode,
  });

  /// Gives up a mailbox this session created or linked. The primary one
  /// cannot be.
  Future<void> unlinkAccount(int id);

  Future<List<Folder>> folders(int accountId);

  /// Whether folders can be made, renamed and deleted here (REST Mail).
  bool get canManageFolders;

  /// Makes an empty folder; the name it is stored under.
  Future<String> createFolder(int accountId, String name);

  /// Renames [folder], its messages with it; the new name.
  Future<String> renameFolder(int accountId, String folder, String name);

  /// Deletes [folder] and every message in it.
  Future<void> deleteFolder(int accountId, String folder);

  Future<QuotaInfo> quota(int accountId);

  /// One page of a folder, newest first. Pass the previous page's cursor to
  /// get the next.
  Future<Paged<Message>> messages(
    int accountId,
    String folder, {
    String? cursor,
  });

  /// A message with its body.
  Future<Message> message(int id);

  Future<Paged<Message>> search(
    int accountId,
    SearchQuery query, {
    String? cursor,
  });

  /// Changes flags, or moves the message by naming another [folder].
  Future<Message> updateMessage(
    int id, {
    bool? isRead,
    bool? isFlagged,
    String? folder,
  });

  /// Moves a message to Trash. Deleting one already in Trash removes it for
  /// good.
  Future<void> deleteMessage(int id);

  /// Whether messages carry labels, several each, rather than sit in one
  /// folder (Gmail). [Folder.isLabel] marks the folders that are labels.
  bool get hasLabels;

  /// Puts labels on a message and takes them off, by folder name.
  Future<Message> updateLabels(
    int id, {
    Set<String> add = const {},
    Set<String> remove = const {},
  });

  /// Whether a folder's messages are shown as conversations, grouped by
  /// [Message.threadId] (Gmail, by `X-GM-THRID`).
  bool get groupsThreads;

  /// Every message in [id]'s conversation, wherever it is filed, oldest
  /// first. [id] itself is among them under that id.
  Future<List<Message>> conversation(int id);

  Future<Message> send(OutgoingMessage message);

  /// Whether the server can hold a message and send it at a chosen time.
  bool get canScheduleSend;

  /// Whether a sent message can say where its recipients unsubscribe
  /// (List-Unsubscribe, RFC 2369 and RFC 8058).
  bool get canSetListUnsubscribe;

  /// Leaves [message] with the server to send at [at].
  Future<ScheduledSend> schedule(OutgoingMessage message, DateTime at);

  /// Messages still waiting to be sent, soonest first.
  Future<List<ScheduledSend>> scheduledSends();

  Future<void> cancelScheduledSend(int id);

  /// Whether the server holds back mail its filters doubt, for the account
  /// to release or delete (REST Mail).
  bool get hasQuarantine;

  /// One page of [accountId]'s held messages, newest first.
  Future<OffsetPage<QuarantinedMessage>> quarantine(
    int accountId, {
    int offset = 0,
  });

  /// Delivers a held message to the inbox; the id of the message it becomes.
  Future<int> releaseQuarantined(int accountId, int id);

  Future<void> deleteQuarantined(int accountId, int id);

  /// Whether the server keeps the account's contacts, which its filters
  /// trust or refuse mail by (REST Mail).
  bool get hasContacts;

  /// One page of [accountId]'s contacts, by address.
  Future<OffsetPage<Contact>> contacts(
    int accountId, {
    String? search,
    TrustLevel? trustLevel,
    int offset = 0,
  });

  Future<Contact> createContact(
    int accountId, {
    required String email,
    String? name,
    TrustLevel? trustLevel,
  });

  Future<Contact> updateContact(
    int accountId,
    int contactId, {
    String? name,
    TrustLevel? trustLevel,
  });

  Future<void> deleteContact(int accountId, int contactId);

  /// Refuses mail from [email] from now on.
  Future<Contact> blockSender(int accountId, String email);

  /// Whether the server reads calendar invitations out of mail and sends
  /// iTIP replies for them (REST Mail).
  bool get hasCalendar;

  /// The events [accountId] has invitations for, each once.
  Future<List<CalendarEventSummary>> calendarEvents(int accountId);

  /// Answers the invitation in message [messageId] from [from].
  Future<CalendarResponse> respondToCalendar(
    int messageId, {
    required CalendarResponse response,
    required String from,
  });

  /// Up to ten of [accountId]'s contacts whose address or name contains
  /// [query], blocked ones left out, for the address fields of a message.
  Future<List<Contact>> suggestContacts(int accountId, String query);

  Future<Message> saveDraft(OutgoingMessage draft);

  Future<Message> updateDraft(int id, OutgoingMessage draft);

  Future<Message> sendDraft(int id);

  Future<List<Attachment>> attachments(int messageId);

  Future<Uint8List> downloadAttachment(int id);

  /// Whether a message's source, as it arrived, can be read (REST Mail).
  bool get hasMessageSource;

  /// The message's RFC 5322 source, headers and all.
  Future<Uint8List> messageSource(int id);

  /// Changes to one mailbox for as long as the stream has a listener.
  /// [onLiveChanged] hears when the connection comes up and when it drops.
  Stream<MailEvent> events(
    int accountId, {
    void Function(bool live)? onLiveChanged,
  });
}

/// A rest-mail server, over its REST API.
class RestBackend implements MailBackend {
  RestBackend(this.client);

  final RestmailClient client;

  @override
  String get host => client.server.host;

  @override
  Future<ServerDescription?> describeServer() => client.describeServer();

  @override
  Future<List<Account>> accounts() => client.accounts();

  @override
  bool get canLinkMailboxes => true;

  @override
  Future<Account> linkAccount({
    required String address,
    required String password,
    String? displayName,
    String? totpCode,
    String? recoveryCode,
  }) => client.linkAccount(
    address: address,
    password: password,
    displayName: displayName,
    totpCode: totpCode,
    recoveryCode: recoveryCode,
  );

  @override
  Future<void> unlinkAccount(int id) => client.unlinkAccount(id);

  @override
  Future<List<Folder>> folders(int accountId) => client.folders(accountId);

  @override
  bool get canManageFolders => true;

  @override
  Future<String> createFolder(int accountId, String name) =>
      client.createFolder(accountId, name);

  @override
  Future<String> renameFolder(int accountId, String folder, String name) =>
      client.renameFolder(accountId, folder, name);

  @override
  Future<void> deleteFolder(int accountId, String folder) =>
      client.deleteFolder(accountId, folder);

  @override
  Future<QuotaInfo> quota(int accountId) => client.quota(accountId);

  @override
  Future<Paged<Message>> messages(
    int accountId,
    String folder, {
    String? cursor,
  }) => client.messages(accountId, folder, cursor: cursor);

  @override
  Future<Message> message(int id) => client.message(id);

  @override
  Future<Paged<Message>> search(
    int accountId,
    SearchQuery query, {
    String? cursor,
  }) => client.search(accountId, query, cursor: cursor);

  @override
  Future<Message> updateMessage(
    int id, {
    bool? isRead,
    bool? isFlagged,
    String? folder,
  }) => client.updateMessage(
    id,
    isRead: isRead,
    isFlagged: isFlagged,
    folder: folder,
  );

  @override
  Future<void> deleteMessage(int id) => client.deleteMessage(id);

  @override
  bool get hasLabels => false;

  @override
  Future<Message> updateLabels(
    int id, {
    Set<String> add = const {},
    Set<String> remove = const {},
  }) => throw const ApiException(
    400,
    'not_supported',
    'rest-mail has folders, not labels.',
  );

  @override
  bool get groupsThreads => false;

  @override
  Future<List<Message>> conversation(int id) async => [
    await client.message(id),
  ];

  @override
  Future<Message> send(OutgoingMessage message) => client.send(message);

  @override
  bool get canScheduleSend => true;

  @override
  bool get canSetListUnsubscribe => true;

  @override
  Future<ScheduledSend> schedule(OutgoingMessage message, DateTime at) =>
      client.schedule(message, at);

  @override
  Future<List<ScheduledSend>> scheduledSends() => client.scheduledSends();

  @override
  Future<void> cancelScheduledSend(int id) => client.cancelScheduledSend(id);

  @override
  bool get hasQuarantine => true;

  @override
  Future<OffsetPage<QuarantinedMessage>> quarantine(
    int accountId, {
    int offset = 0,
  }) => client.quarantine(accountId, offset: offset);

  @override
  Future<int> releaseQuarantined(int accountId, int id) =>
      client.releaseQuarantined(accountId, id);

  @override
  Future<void> deleteQuarantined(int accountId, int id) =>
      client.deleteQuarantined(accountId, id);

  @override
  bool get hasCalendar => true;

  @override
  Future<List<CalendarEventSummary>> calendarEvents(int accountId) =>
      client.calendarEvents(accountId);

  @override
  Future<CalendarResponse> respondToCalendar(
    int messageId, {
    required CalendarResponse response,
    required String from,
  }) => client.respondToCalendar(messageId, response: response, from: from);

  @override
  bool get hasContacts => true;

  @override
  Future<OffsetPage<Contact>> contacts(
    int accountId, {
    String? search,
    TrustLevel? trustLevel,
    int offset = 0,
  }) => client.contacts(
    accountId,
    search: search,
    trustLevel: trustLevel,
    offset: offset,
  );

  @override
  Future<Contact> createContact(
    int accountId, {
    required String email,
    String? name,
    TrustLevel? trustLevel,
  }) => client.createContact(
    accountId,
    email: email,
    name: name,
    trustLevel: trustLevel,
  );

  @override
  Future<Contact> updateContact(
    int accountId,
    int contactId, {
    String? name,
    TrustLevel? trustLevel,
  }) => client.updateContact(
    accountId,
    contactId,
    name: name,
    trustLevel: trustLevel,
  );

  @override
  Future<void> deleteContact(int accountId, int contactId) =>
      client.deleteContact(accountId, contactId);

  @override
  Future<Contact> blockSender(int accountId, String email) =>
      client.blockSender(accountId, email);

  @override
  Future<List<Contact>> suggestContacts(int accountId, String query) =>
      client.suggestContacts(accountId, query);

  @override
  Future<Message> saveDraft(OutgoingMessage draft) => client.saveDraft(draft);

  @override
  Future<Message> updateDraft(int id, OutgoingMessage draft) =>
      client.updateDraft(id, draft);

  @override
  Future<Message> sendDraft(int id) => client.sendDraft(id);

  @override
  Future<List<Attachment>> attachments(int messageId) =>
      client.attachments(messageId);

  @override
  Future<Uint8List> downloadAttachment(int id) => client.downloadAttachment(id);

  @override
  bool get hasMessageSource => true;

  @override
  Future<Uint8List> messageSource(int id) => client.rawMessage(id);

  @override
  Stream<MailEvent> events(
    int accountId, {
    void Function(bool live)? onLiveChanged,
  }) => client.events(accountId, onLiveChanged: onLiveChanged);
}
