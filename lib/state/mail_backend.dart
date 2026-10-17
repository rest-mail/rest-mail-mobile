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

  /// The mailboxes this session can show. [Account.isPrimary] marks the one
  /// it signed in with.
  Future<List<Account>> accounts();

  /// Whether [linkAccount] can add more mailboxes to this session. A REST
  /// Mail session can; an IMAP account is one mailbox.
  bool get canLinkMailboxes;

  /// Adds another mailbox on the same server, proving access to it with its
  /// own password.
  Future<Account> linkAccount({
    required String address,
    required String password,
    String? displayName,
  });

  /// Removes a linked mailbox. The primary one cannot be.
  Future<void> unlinkAccount(int id);

  Future<List<Folder>> folders(int accountId);

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

  Future<Message> send(OutgoingMessage message);

  Future<Message> saveDraft(OutgoingMessage draft);

  Future<Message> updateDraft(int id, OutgoingMessage draft);

  Future<Message> sendDraft(int id);

  Future<List<Attachment>> attachments(int messageId);

  Future<Uint8List> downloadAttachment(int id);

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
  Future<List<Account>> accounts() => client.accounts();

  @override
  bool get canLinkMailboxes => true;

  @override
  Future<Account> linkAccount({
    required String address,
    required String password,
    String? displayName,
  }) => client.linkAccount(
    address: address,
    password: password,
    displayName: displayName,
  );

  @override
  Future<void> unlinkAccount(int id) => client.unlinkAccount(id);

  @override
  Future<List<Folder>> folders(int accountId) => client.folders(accountId);

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
  Future<Message> send(OutgoingMessage message) => client.send(message);

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
  Stream<MailEvent> events(
    int accountId, {
    void Function(bool live)? onLiveChanged,
  }) => client.events(accountId, onLiveChanged: onLiveChanged);
}
