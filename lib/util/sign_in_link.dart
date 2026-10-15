/// Where sign-in links point when they are ordinary web links, so that they
/// are tappable anywhere a link is. The path and host are matched against the
/// app's associated domains (ios/Runner/Runner.entitlements, and the files
/// under .well-known/ on the site).
const setupLinkHost = 'rest-mail.com';
const setupLinkPath = '/setup';

/// What the installer's QR code holds: the server it installed, and the first
/// admin's username and password, so that scanning it with a phone's camera
/// opens the app with the sign-in filled in.
///
/// Two forms, the same thing:
///
///   https://rest-mail.com/setup#server=URL&username=NAME&password=PASSWORD
///   rest-mail://setup?server=URL&username=NAME&password=PASSWORD
///
/// The installer draws the first, because a phone's own camera offers to open
/// a web link and a chat app makes one tappable. It carries its parameters
/// after the `#`, which browsers never send to a web server, so the site it
/// points at never sees the password. The password is the bootstrap one: it
/// stops working once the admin has chosen their own, and 72 hours after the
/// server first took it.
class SignInLink {
  const SignInLink({
    this.server,
    this.username = 'admin',
    required this.password,
  });

  final Uri? server;
  final String username;
  final String password;

  /// Reads a scanned QR code, or a link the app was opened with. Anything
  /// else — another site's link, or the setup code of a server from before
  /// rest-mail 0.7, which nothing redeems any more — is null.
  static SignInLink? parse(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    final link = Uri.tryParse(text);
    final parameters = link == null ? null : _parametersOf(link);
    final password = parameters?['password'] ?? '';
    if (parameters == null || password.isEmpty) return null;
    final server = Uri.tryParse(parameters['server'] ?? '');
    final username = parameters['username']?.trim() ?? '';
    return SignInLink(
      server: server != null && server.hasScheme && server.host.isNotEmpty
          ? server
          : null,
      username: username.isEmpty ? 'admin' : username,
      password: password,
    );
  }

  /// The parameters of a sign-in link, or null for a link that is not one.
  static Map<String, String>? _parametersOf(Uri link) {
    if (link.scheme == 'rest-mail') {
      return link.host == 'setup' ? link.queryParameters : null;
    }
    // A web link: only the site the app is associated with, so that scanning
    // some other site's QR code is not taken for a sign-in.
    final host = link.host.startsWith('www.')
        ? link.host.substring(4)
        : link.host;
    if (link.scheme != 'https' ||
        host != setupLinkHost ||
        (link.path != setupLinkPath && link.path != '$setupLinkPath/')) {
      return null;
    }
    // After the `#` is where these links carry their parameters; a link
    // written with ordinary query parameters is read too, rather than refused.
    final fragment = Uri.splitQueryString(link.fragment);
    return fragment.containsKey('password') ? fragment : link.queryParameters;
  }
}
