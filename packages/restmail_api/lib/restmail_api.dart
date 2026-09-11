/// Client for the rest-mail REST API.
///
/// Covers what a mail app needs: signing in (two-factor included), reading
/// and changing mail, sending, drafts, search, attachments, and the live
/// event stream. It speaks HTTPS only and needs `dart:io`, so it runs on iOS,
/// Android and desktop but not the web.
library;

export 'src/client.dart' show RestmailClient, ServerHealth, TokensChanged;
export 'src/discovery.dart';
export 'src/errors.dart';
export 'src/events.dart';
export 'src/models.dart';
export 'src/session.dart';
