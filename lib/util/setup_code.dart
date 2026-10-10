/// Where setup links point when they are ordinary web links, so that they are
/// tappable anywhere a link is. The path and host are matched against the
/// app's associated domains (ios/Runner/Runner.entitlements, and the files
/// under .well-known/ on the site).
const setupLinkHost = 'rest-mail.com';
const setupLinkPath = '/setup';

/// What a fresh rest-mail server's setup QR code or link holds: the setup
/// code, and the server it is for when whoever made the link knew it.
///
/// Three forms, all the same thing:
///
///   restmail://setup?token=CODE[&server=URL]
///   https://rest-mail.com/setup#token=CODE[&server=URL]
///   CODE
///
/// A server prints the first: it does not know the address it is reached at,
/// so it names no server. `restmail setup --server URL --code CODE` adds the
/// server. The web form carries its parameters after the `#`, which browsers
/// never send to a web server, so the site this link points at never sees a
/// code that would claim someone's mail server.
class SetupCodeScan {
  const SetupCodeScan(this.code, {this.server});

  final String code;
  final Uri? server;

  /// Reads a scanned QR code, a link the app was opened with, or a bare setup
  /// code. Anything else is null.
  static SetupCodeScan? parse(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    final link = Uri.tryParse(text);
    final parameters = link == null ? null : _parametersOf(link);
    if (parameters != null) {
      final code = parameters['token']?.trim() ?? '';
      if (!_looksLikeCode(code)) return null;
      final server = Uri.tryParse(parameters['server'] ?? '');
      return SetupCodeScan(
        code,
        server: server != null && server.hasScheme && server.host.isNotEmpty
            ? server
            : null,
      );
    }
    return _looksLikeCode(text) ? SetupCodeScan(text) : null;
  }

  /// The parameters of a setup link, or null for a link that is not one.
  static Map<String, String>? _parametersOf(Uri link) {
    if (link.scheme == 'restmail') {
      return link.host == 'setup' ? link.queryParameters : null;
    }
    // A web link: only the site the app is associated with, so that scanning
    // some other site's QR code is not taken for a setup.
    final host = link.host.startsWith('www.')
        ? link.host.substring(4)
        : link.host;
    if (link.scheme != 'https' ||
        host != setupLinkHost ||
        (link.path != setupLinkPath && link.path != '$setupLinkPath/')) {
      return null;
    }
    // After the `#` is where these links carry a code; a link written with
    // ordinary query parameters is read too, rather than refused.
    final fragment = Uri.splitQueryString(link.fragment);
    return fragment.containsKey('token') ? fragment : link.queryParameters;
  }

  /// 24 characters of Crockford base32 once dashes and spaces are gone; the
  /// server is lenient about case and look-alikes, and so is this.
  static bool _looksLikeCode(String code) =>
      RegExp(r'^[0-9A-Za-z]{24}$')
          .hasMatch(code.replaceAll(RegExp(r'[\s-]'), ''));
}
