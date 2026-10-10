/// What a fresh rest-mail server's setup QR code holds: the setup code, and
/// the server it is for when whoever made the code knew it.
///
/// The server prints `restmail://setup?token=CODE`; it does not know the
/// address it is reached at, so that names no server. `restmail setup
/// --server URL --code CODE` adds `&server=URL`.
class SetupCodeScan {
  const SetupCodeScan(this.code, {this.server});

  final String code;
  final Uri? server;

  /// Reads a scanned QR code: a setup link, or a bare setup code. Anything
  /// else is null.
  static SetupCodeScan? parse(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    final link = Uri.tryParse(text);
    if (link != null && link.scheme == 'restmail') {
      if (link.host != 'setup') return null;
      final code = link.queryParameters['token']?.trim() ?? '';
      if (!_looksLikeCode(code)) return null;
      final server = Uri.tryParse(link.queryParameters['server'] ?? '');
      return SetupCodeScan(
        code,
        server: server != null && server.hasScheme && server.host.isNotEmpty
            ? server
            : null,
      );
    }
    return _looksLikeCode(text) ? SetupCodeScan(text) : null;
  }

  /// 24 characters of Crockford base32 once dashes and spaces are gone; the
  /// server is lenient about case and look-alikes, and so is this.
  static bool _looksLikeCode(String code) =>
      RegExp(r'^[0-9A-Za-z]{24}$')
          .hasMatch(code.replaceAll(RegExp(r'[\s-]'), ''));
}
