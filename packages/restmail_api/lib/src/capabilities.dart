/// What a session may do on the admin API: the capability names its access
/// token was minted with. The server sends them with every sign-in and
/// refresh, and checks the same names on every admin request; `*` is a
/// superadmin's, and allows everything.
///
/// The names are the server's (rest-mail-server
/// `internal/api/middleware/capabilities.go`).
class Capabilities {
  const Capabilities(this.names);

  /// What an account holding no admin grant, or one still in setup, holds.
  static const none = Capabilities({});

  /// Reads the `capabilities` array of a sign-in or refresh. Missing means
  /// none: the server leaves it out when there are none to send.
  factory Capabilities.fromJson(Object? json) => json is List
      ? Capabilities({
          for (final name in json)
            if (name is String && name.isNotEmpty) name,
        })
      : none;

  final Set<String> names;

  static const all = '*';

  bool get isEmpty => names.isEmpty;

  /// Whether a request needing [capability] would be let through.
  bool allows(String capability) =>
      names.contains(all) || names.contains(capability);

  List<String> toJson() => [...names]..sort();

  @override
  bool operator ==(Object other) =>
      other is Capabilities &&
      other.names.length == names.length &&
      other.names.containsAll(names);

  @override
  int get hashCode => Object.hashAllUnordered(names);

  @override
  String toString() => 'Capabilities(${toJson().join(', ')})';
}

/// The capability names the admin API checks.
abstract final class Capability {
  static const domainsRead = 'domains:read';
  static const domainsWrite = 'domains:write';
  static const domainsDelete = 'domains:delete';
  static const mailboxesRead = 'mailboxes:read';
  static const mailboxesWrite = 'mailboxes:write';
  static const mailboxesDelete = 'mailboxes:delete';
  static const usersRead = 'users:read';
  static const usersWrite = 'users:write';
  static const usersDelete = 'users:delete';
  static const pipelinesRead = 'pipelines:read';
  static const pipelinesWrite = 'pipelines:write';
  static const pipelinesDelete = 'pipelines:delete';
  static const queueRead = 'queue:read';
  static const queueManage = 'queue:manage';
  static const bansRead = 'bans:read';
  static const bansWrite = 'bans:write';
  static const bansDelete = 'bans:delete';
  static const messagesRead = 'messages:read';
  static const observabilityRead = 'observability:read';
  static const auditRead = 'audit:read';
}
