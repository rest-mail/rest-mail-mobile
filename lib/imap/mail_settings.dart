import 'oauth.dart';

/// How the app sends over SMTP. There is deliberately no plaintext choice:
/// a server that offers neither is refused.
enum SmtpSecurity {
  /// TLS from the first byte, usually on 465.
  tls,

  /// A plain connection on 587 that must switch to TLS before anything else
  /// is said. If the server does not offer STARTTLS, nothing is sent.
  starttls;

  static SmtpSecurity forPort(int port) =>
      port == 587 ? SmtpSecurity.starttls : SmtpSecurity.tls;
}

/// Where an IMAP account's mail is read from and sent through. IMAP is
/// always TLS from the first byte; there is no STARTTLS or plaintext IMAP.
class MailServerSettings {
  const MailServerSettings({
    required this.imapHost,
    this.imapPort = 993,
    required this.smtpHost,
    this.smtpPort = 465,
    this.smtpSecurity = SmtpSecurity.tls,
    this.username,
    this.filesSentMail = false,
  });

  static MailServerSettings? fromJson(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final imapHost = raw['imap_host'], smtpHost = raw['smtp_host'];
    final imapPort = raw['imap_port'], smtpPort = raw['smtp_port'];
    final security = SmtpSecurity.values
        .where((s) => s.name == raw['smtp_security'])
        .firstOrNull;
    if (imapHost is! String ||
        smtpHost is! String ||
        imapPort is! int ||
        smtpPort is! int ||
        security == null) {
      return null;
    }
    return MailServerSettings(
      imapHost: imapHost,
      imapPort: imapPort,
      smtpHost: smtpHost,
      smtpPort: smtpPort,
      smtpSecurity: security,
      username: raw['username'] as String?,
      filesSentMail: raw['files_sent_mail'] as bool? ?? false,
    );
  }

  final String imapHost;
  final int imapPort;
  final String smtpHost;
  final int smtpPort;
  final SmtpSecurity smtpSecurity;

  /// What to sign in as, when it is not the address itself.
  final String? username;

  /// The provider puts what its SMTP server sends into Sent on its own
  /// (Gmail does), so the app must not add a second copy.
  final bool filesSentMail;

  String usernameFor(String address) =>
      username?.isNotEmpty == true ? username! : address;

  MailServerSettings copyWith({String? username}) => MailServerSettings(
    imapHost: imapHost,
    imapPort: imapPort,
    smtpHost: smtpHost,
    smtpPort: smtpPort,
    smtpSecurity: smtpSecurity,
    username: username ?? this.username,
    filesSentMail: filesSentMail,
  );

  Map<String, Object> toJson() => {
    'imap_host': imapHost,
    'imap_port': imapPort,
    'smtp_host': smtpHost,
    'smtp_port': smtpPort,
    'smtp_security': smtpSecurity.name,
    'username': ?username,
    'files_sent_mail': filesSentMail,
  };

  @override
  bool operator ==(Object other) =>
      other is MailServerSettings &&
      other.imapHost == imapHost &&
      other.imapPort == imapPort &&
      other.smtpHost == smtpHost &&
      other.smtpPort == smtpPort &&
      other.smtpSecurity == smtpSecurity &&
      other.username == username &&
      other.filesSentMail == filesSentMail;

  @override
  int get hashCode => Object.hash(
    imapHost,
    imapPort,
    smtpHost,
    smtpPort,
    smtpSecurity,
    username,
    filesSentMail,
  );

  @override
  String toString() =>
      'IMAP $imapHost:$imapPort, SMTP $smtpHost:$smtpPort (${smtpSecurity.name})';
}

/// A mail provider the app knows without looking anything up.
class MailProvider {
  const MailProvider({
    required this.id,
    required this.name,
    required this.domains,
    required this.settings,
    this.appPasswordUrl,
    this.needsMicrosoftSignIn = false,
  });

  final String id;
  final String name;
  final List<String> domains;
  final MailServerSettings settings;

  /// Where the provider explains making an app password, or makes one.
  final Uri? appPasswordUrl;

  /// Outlook.com turned password sign-in off for IMAP and SMTP on
  /// 2024-09-16; it waits for Sign in with Microsoft (#37).
  final bool needsMicrosoftSignIn;

  bool get isGmail => id == 'gmail';

  /// Who can sign it in instead of a password, given a client for them.
  OAuthKind? get signsInWith => switch (id) {
    'outlook' => OAuthKind.microsoft,
    'gmail' => OAuthKind.google,
    _ => null,
  };

  /// Sign-in takes an app password rather than the account's own.
  bool get usesAppPassword => appPasswordUrl != null;
}

abstract final class MailProviders {
  static final gmail = MailProvider(
    id: 'gmail',
    name: 'Gmail',
    domains: const ['gmail.com', 'googlemail.com'],
    settings: const MailServerSettings(
      imapHost: 'imap.gmail.com',
      smtpHost: 'smtp.gmail.com',
      filesSentMail: true,
    ),
    appPasswordUrl: Uri.parse('https://myaccount.google.com/apppasswords'),
  );

  static final icloud = MailProvider(
    id: 'icloud',
    name: 'iCloud Mail',
    domains: const ['icloud.com', 'me.com', 'mac.com'],
    settings: const MailServerSettings(
      imapHost: 'imap.mail.me.com',
      smtpHost: 'smtp.mail.me.com',
      smtpPort: 587,
      smtpSecurity: SmtpSecurity.starttls,
    ),
    appPasswordUrl: Uri.parse('https://support.apple.com/en-us/102654'),
  );

  static final yahoo = MailProvider(
    id: 'yahoo',
    name: 'Yahoo Mail',
    domains: const [
      'yahoo.com',
      'ymail.com',
      'rocketmail.com',
      'yahoo.co.uk',
      'yahoo.fr',
      'yahoo.de',
    ],
    settings: const MailServerSettings(
      imapHost: 'imap.mail.yahoo.com',
      smtpHost: 'smtp.mail.yahoo.com',
    ),
    appPasswordUrl: Uri.parse('https://help.yahoo.com/kb/SLN15241.html'),
  );

  static final fastmail = MailProvider(
    id: 'fastmail',
    name: 'Fastmail',
    domains: const ['fastmail.com', 'fastmail.fm', 'fastmail.net'],
    settings: const MailServerSettings(
      imapHost: 'imap.fastmail.com',
      smtpHost: 'smtp.fastmail.com',
    ),
    appPasswordUrl: Uri.parse(
      'https://www.fastmail.help/hc/en-us/articles/360058752854-App-passwords',
    ),
  );

  static const outlook = MailProvider(
    id: 'outlook',
    name: 'Outlook.com',
    domains: [
      'outlook.com',
      'hotmail.com',
      'live.com',
      'msn.com',
      'hotmail.co.uk',
      'outlook.co.uk',
      'live.co.uk',
    ],
    settings: MailServerSettings(
      imapHost: 'outlook.office365.com',
      smtpHost: 'smtp-mail.outlook.com',
      smtpPort: 587,
      smtpSecurity: SmtpSecurity.starttls,
    ),
    needsMicrosoftSignIn: true,
  );

  static final all = [gmail, icloud, yahoo, fastmail, outlook];

  static MailProvider? byId(String? id) =>
      all.where((p) => p.id == id).firstOrNull;

  /// The provider an address belongs to, judged by its domain alone.
  static MailProvider? forAddress(String address) {
    final domain = domainOf(address);
    if (domain == null) return null;
    return all.where((p) => p.domains.contains(domain)).firstOrNull;
  }
}

/// Who can sign an account in instead of a password: its provider's, or
/// for an address at a domain of its own, the one whose servers it uses,
/// such as a work account on Microsoft 365 or Google Workspace.
OAuthKind? oauthKindFor(MailProvider? provider, MailServerSettings? settings) {
  final known = provider?.signsInWith;
  if (known != null) return known;
  return switch (settings?.imapHost.toLowerCase()) {
    'outlook.office365.com' => OAuthKind.microsoft,
    'imap.gmail.com' => OAuthKind.google,
    _ => null,
  };
}

/// The lower-cased domain of an address, or null if it isn't one yet.
String? domainOf(String address) {
  final text = address.trim();
  final at = text.lastIndexOf('@');
  if (at <= 0 || at == text.length - 1) return null;
  final domain = text.substring(at + 1).toLowerCase();
  return domain.contains('.') && !domain.endsWith('.') ? domain : null;
}
