import 'package:http/http.dart' as http;

import 'client.dart';
import 'errors.dart';
import 'session.dart';

/// Finds the rest-mail server behind an email address by asking the likely
/// hosts — the domain itself and `mail.<domain>` — whether they answer
/// rest-mail's health check. The domain wins when both do; null when
/// neither does.
///
/// The [httpClient] is shared, not closed: the caller owns it.
Future<Uri?> discoverServer(
  String email, {
  required http.Client httpClient,
  Duration timeout = const Duration(seconds: 6),
}) async {
  final at = email.lastIndexOf('@');
  if (at <= 0) return null;
  final domain = email.substring(at + 1).trim().toLowerCase();
  if (domain.isEmpty || domain.startsWith('.') || domain.endsWith('.')) {
    return null;
  }

  final candidates = <Uri>[];
  for (final host in [domain, 'mail.$domain']) {
    try {
      candidates.add(parseServerUrl(host));
    } on FormatException {
      // Not a host name; nothing to ask.
    }
  }
  final answers = await Future.wait([
    for (final server in candidates) _answers(server, httpClient, timeout),
  ]);
  for (var i = 0; i < candidates.length; i++) {
    if (answers[i]) return candidates[i];
  }
  return null;
}

Future<bool> _answers(
  Uri server,
  http.Client httpClient,
  Duration timeout,
) async {
  try {
    await RestmailClient(
      server: server,
      httpClient: httpClient,
      timeout: timeout,
    ).health();
    return true;
  } on ApiException {
    return false;
  }
}
