/// Client for the rest-mail REST API.
///
/// Covers what a mail app needs: signing in (two-factor included), reading
/// and changing mail, sending, drafts, search, attachments, the live event
/// stream, registering a phone for push, and the parts of the admin API the
/// app administers the server with. It speaks HTTPS only and needs
/// `dart:io`, so it runs on iOS, Android and desktop but not the web.
library;

export 'src/admin_models.dart';
export 'src/capabilities.dart';
export 'src/auth_results.dart';
export 'src/calendar.dart';
export 'src/client.dart'
    show RestmailClient, ServerDescription, ServerHealth, TokensChanged;
export 'src/discovery.dart';
export 'src/dmarc_reports.dart';
export 'src/errors.dart';
export 'src/events.dart';
export 'src/filter_models.dart';
export 'src/forward.dart';
export 'src/grants_models.dart';
export 'src/models.dart';
export 'src/message_seal.dart';
export 'src/push.dart';
export 'src/session.dart';
export 'src/thread_due.dart';
export 'src/thread_snooze.dart';
