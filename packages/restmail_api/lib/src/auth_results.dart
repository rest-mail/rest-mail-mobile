/// What a receiving server recorded about a message's sender, taken from its
/// `Authentication-Results` header.
///
/// The app must never claim more than the header says: an absent signature is
/// normal for forwards and mailing lists, and is not a failure.
library;

/// The states the UI can render.
enum TrustState {
  /// A valid DKIM signature was verified.
  signed,

  /// DMARC passed without a valid DKIM signature (SPF-aligned).
  aligned,

  /// Only the sending server was authorised; the message is not signed.
  spfOnly,

  /// No verified signature at all. Not evidence of anything.
  unsigned,

  /// DMARC failed, but a forwarder's ARC chain is intact.
  forwarded,

  /// DMARC failed and the domain does not align.
  mismatch,

  /// No header to read.
  unchecked,
}

/// One `method=result` clause of an `Authentication-Results` header.
class AuthCheck {
  const AuthCheck({
    required this.method,
    required this.result,
    required this.raw,
    this.identity,
    this.domain,
    this.reason,
  });

  /// `spf`, `dkim`, `arc` or `dmarc`.
  final String method;

  /// The RFC 8601 result, such as `pass`, `fail` or `none`.
  final String result;

  /// The identity that was checked, such as `header.d`.
  final String? identity;

  /// The domain that was checked.
  final String? domain;

  /// Why, when the header says.
  final String? reason;

  /// The clause as it appeared.
  final String raw;
}

/// A parsed `Authentication-Results` header.
class MailAuth {
  const MailAuth({required this.checks, this.authservId});

  final String? authservId;
  final List<AuthCheck> checks;
}

/// The single statement the UI makes about a message's sender.
class TrustVerdict {
  const TrustVerdict({
    required this.state,
    required this.label,
    required this.detail,
    this.signedBy,
    this.auth,
  });

  final TrustState state;
  final String label;
  final String detail;
  final String? signedBy;
  final MailAuth? auth;

  bool get isUnchecked => state == TrustState.unchecked;

  /// True when the reader should look at the receipt before trusting the
  /// from address.
  bool get isWarning =>
      state == TrustState.mismatch || state == TrustState.forwarded;
}

const _outcomes = {
  'pass',
  'fail',
  'softfail',
  'neutral',
  'none',
  'temperror',
  'permerror',
  'policy',
};

final _clauseRe = RegExp(r'^([A-Za-z0-9][\w.-]*)\s*=\s*([A-Za-z]+)\b(.*)$');
final _propertyRe = RegExp(
  r'(?:^|\s)(smtp\.mailfrom|smtp\.helo|header\.d|header\.i|header\.from)'
  r'=("[^"]*"|[^\s;]+)',
);
final _reasonRe = RegExp(r'(?:^|\s)reason=("[^"]*"|[^\s;]+)');

/// Reads a header by name, case-insensitively.
String? headerValue(Map<String, String>? headers, String name) {
  if (headers == null) return null;
  final wanted = name.toLowerCase();
  for (final entry in headers.entries) {
    if (entry.key.toLowerCase() == wanted) {
      final value = entry.value.trim();
      return value.isEmpty ? null : value;
    }
  }
  return null;
}

String _unquote(String value) => value.replaceAll(RegExp(r'^"|"$'), '');

AuthCheck? _parseClause(String clause) {
  final match = _clauseRe.firstMatch(clause.trim());
  if (match == null) return null;

  final method = match.group(1)!.toLowerCase();
  final rawResult = match.group(2)!.toLowerCase();
  final rest = match.group(3) ?? '';

  final property = _propertyRe.firstMatch(rest);
  final reason = _reasonRe.firstMatch(rest);

  String? identity;
  String? domain;
  if (property != null) {
    identity = property.group(1);
    final value = _unquote(property.group(2)!);
    if (identity == 'header.i') {
      domain = value.replaceFirst(RegExp('^@'), '');
    } else if (identity == 'smtp.mailfrom' && value.contains('@')) {
      domain = value.substring(value.lastIndexOf('@') + 1);
    } else {
      domain = value;
    }
  }

  return AuthCheck(
    method: method,
    result: _outcomes.contains(rawResult) ? rawResult : 'unknown',
    identity: identity,
    domain: domain,
    reason: reason == null ? null : _unquote(reason.group(1)!),
    raw: clause.trim(),
  );
}

/// Parses one or more `Authentication-Results` headers, in the order a map
/// offered them.
MailAuth parseAuthenticationResults(String raw) {
  final lines = raw
      .split(RegExp(r'\r?\n'))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty);

  String? authservId;
  final checks = <AuthCheck>[];

  for (final line in lines) {
    final clauses = line.split(';');
    final head = clauses.isEmpty ? '' : clauses.removeAt(0).trim();
    if (authservId == null && head.isNotEmpty) {
      authservId = head.replaceFirst(RegExp(r'\s+\d+$'), '');
    }
    for (final clause in clauses) {
      final check = _parseClause(clause);
      if (check != null) checks.add(check);
    }
  }

  return MailAuth(authservId: authservId, checks: checks);
}

/// The auth on a message, or null when it carries no usable header.
MailAuth? mailAuthFromHeaders(Map<String, String>? headers) {
  final raw = headerValue(headers, 'authentication-results');
  if (raw == null) return null;
  final auth = parseAuthenticationResults(raw);
  return auth.checks.isEmpty ? null : auth;
}

String? _outcomeFor(MailAuth auth, String method) {
  final matching = auth.checks.where((check) => check.method == method);
  if (matching.isEmpty) return null;
  for (final check in matching) {
    if (check.result == 'pass') return 'pass';
  }
  for (final check in matching) {
    if (check.result == 'fail') return 'fail';
  }
  return matching.first.result;
}

String? _domainFor(MailAuth auth, String method) {
  final matching = auth.checks.where(
    (check) => check.method == method && check.domain != null,
  );
  if (matching.isEmpty) return null;
  for (final check in matching) {
    if (check.result == 'pass') return check.domain;
  }
  return matching.first.domain;
}

/// Turns the header into the one sentence the reader sees.
TrustVerdict verdictFromAuth(MailAuth? auth) {
  if (auth == null || auth.checks.isEmpty) {
    return const TrustVerdict(
      state: TrustState.unchecked,
      label: 'not checked',
      detail:
          'This message carries no Authentication-Results header, so no '
          'sender checks are available.',
    );
  }

  final spf = _outcomeFor(auth, 'spf');
  final dkim = _outcomeFor(auth, 'dkim');
  final dmarc = _outcomeFor(auth, 'dmarc');
  final arc = _outcomeFor(auth, 'arc');

  if (dmarc == 'fail') {
    if (arc == 'pass') {
      return TrustVerdict(
        state: TrustState.forwarded,
        label: 'forwarded',
        detail:
            'DMARC failed for the from address, but a forwarder\'s ARC chain '
            'is intact. Common for mailing lists and redirects.',
        signedBy: _domainFor(auth, 'arc'),
        auth: auth,
      );
    }
    return TrustVerdict(
      state: TrustState.mismatch,
      label: 'unverified sender',
      detail:
          'DMARC failed and the sending domain does not align with the from '
          'address. Treat the from address as unverified.',
      auth: auth,
    );
  }

  if (dkim == 'pass') {
    final domain = _domainFor(auth, 'dkim');
    return TrustVerdict(
      state: TrustState.signed,
      label: 'signed',
      detail:
          'The message carries a valid DKIM signature for '
          '${domain ?? 'the sending domain'}.',
      signedBy: domain,
      auth: auth,
    );
  }

  if (dmarc == 'pass') {
    final domain = _domainFor(auth, 'dmarc');
    return TrustVerdict(
      state: TrustState.aligned,
      label: 'aligned',
      detail:
          'DMARC passed for ${domain ?? 'the from domain'}, but no valid DKIM '
          'signature was found. The sending server was authorised, not the '
          'message signed.',
      signedBy: domain,
      auth: auth,
    );
  }

  if (spf == 'pass') {
    final domain = _domainFor(auth, 'spf');
    return TrustVerdict(
      state: TrustState.spfOnly,
      label: 'SPF only',
      detail:
          'The sending server (${domain ?? 'the envelope domain'}) is '
          'authorised for the domain, but the message itself is not signed.',
      auth: auth,
    );
  }

  return TrustVerdict(
    state: TrustState.unsigned,
    label: 'no signature',
    detail:
        'No sender signature was verified. This is normal for forwarded mail '
        'and some mailing lists, and it says nothing about the content.',
    auth: auth,
  );
}

/// The verdict for a message's headers.
TrustVerdict trustFromHeaders(Map<String, String>? headers) =>
    verdictFromAuth(mailAuthFromHeaders(headers));
