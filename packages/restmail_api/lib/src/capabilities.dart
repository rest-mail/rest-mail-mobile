/// One capability at a domain or mailbox scope in the live session snapshot.
class ScopedCapability {
  const ScopedCapability({required this.capability, required this.scope});

  final String capability;
  final String scope;

  Map<String, String> toJson() => {'capability': capability, 'scope': scope};

  @override
  bool operator ==(Object other) =>
      other is ScopedCapability &&
      capability == other.capability &&
      scope == other.scope;
  @override
  int get hashCode => Object.hash(capability, scope);
}

/// The server's scope hierarchy. A mailbox never covers its parent domain,
/// an alias at the same address or a sibling account.
abstract final class CapabilityScope {
  static const all = '*';
  static String domain(String name) => 'domain:${name.toLowerCase()}';
  static String mailbox(String address) => 'mailbox:${address.toLowerCase()}';

  static String? parse(Object? value) {
    if (value is! String) return null;
    final scope = value.trim().toLowerCase();
    if (scope == all) return scope;
    if (scope.startsWith('domain:') && _domain(scope.substring(7))) {
      return scope;
    }
    if (scope.startsWith('mailbox:')) {
      final address = scope.substring(8);
      final at = address.indexOf('@');
      if (at > 0 &&
          at == address.lastIndexOf('@') &&
          !RegExp(r'[\s]').hasMatch(address.substring(0, at)) &&
          _domain(address.substring(at + 1))) {
        return scope;
      }
    }
    return null;
  }

  static bool _domain(String value) =>
      value.isNotEmpty &&
      value.length <= 253 &&
      value
          .split('.')
          .every(
            (label) =>
                label.isNotEmpty &&
                label.length <= 63 &&
                RegExp(r'^[a-z0-9-]+$').hasMatch(label),
          );

  static bool covers(String scope, String target) {
    final a = parse(scope), b = parse(target);
    if (a == null || b == null) return false;
    if (a == all || a == b) return true;
    if (!a.startsWith('domain:') || !b.startsWith('mailbox:')) return false;
    final address = b.substring(8);
    return address.substring(address.lastIndexOf('@') + 1) == a.substring(7);
  }
}

/// UI metadata from the server's live grants. The legacy names apply only to
/// the whole installation; scoped entries are kept separate and persisted.
/// The server checks live grants on every request and remains authoritative.
class Capabilities {
  const Capabilities(this.names, {this.scoped = const {}});

  static const none = Capabilities({});
  static const all = '*';

  factory Capabilities.fromJson(Object? json, {Object? scoped}) => Capabilities(
    {
      if (json is List)
        for (final name in json)
          if (name is String && name.isNotEmpty) name,
    },
    scoped: {
      if (scoped is List)
        for (final entry in scoped)
          if (entry is Map &&
              entry['capability'] is String &&
              (entry['capability'] as String).isNotEmpty)
            if (CapabilityScope.parse(entry['scope']) case final scope?)
              ScopedCapability(
                capability: entry['capability'] as String,
                scope: scope,
              ),
    },
  );

  final Set<String> names;
  final Set<ScopedCapability> scoped;
  bool get isEmpty => names.isEmpty && scoped.isEmpty;

  /// Default is global access. Narrower entries never satisfy that default.
  bool allows(String capability, {String scope = CapabilityScope.all}) =>
      CapabilityScope.parse(scope) != null &&
      (names.contains(all) ||
          names.contains(capability) ||
          scoped.any(
            (entry) =>
                (entry.capability == all || entry.capability == capability) &&
                CapabilityScope.covers(entry.scope, scope),
          ));

  /// Any overlap with [within], for filtered collections. This does not grant
  /// permission to read or change the container itself.
  bool allowsSomewhere(
    String capability, {
    String? within,
    bool domainsOnly = false,
  }) {
    if (within != null && CapabilityScope.parse(within) == null) return false;
    if (allows(capability)) return true;
    return scoped.any(
      (entry) =>
          CapabilityScope.parse(entry.scope) != null &&
          (entry.capability == all || entry.capability == capability) &&
          (!domainsOnly ||
              entry.scope == all ||
              entry.scope.startsWith('domain:')) &&
          (within == null ||
              CapabilityScope.covers(entry.scope, within) ||
              CapabilityScope.covers(within, entry.scope)),
    );
  }

  List<String> toJson() => [...names]..sort();
  List<Map<String, String>> scopedToJson() => [
    for (final entry
        in (scoped.toList()..sort((a, b) {
          final byScope = a.scope.compareTo(b.scope);
          return byScope == 0 ? a.capability.compareTo(b.capability) : byScope;
        })))
      entry.toJson(),
  ];

  @override
  bool operator ==(Object other) =>
      other is Capabilities &&
      other.names.length == names.length &&
      other.names.containsAll(names) &&
      other.scoped.length == scoped.length &&
      other.scoped.containsAll(scoped);
  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(names),
    Object.hashAllUnordered(scoped),
  );
  @override
  String toString() =>
      'Capabilities(${toJson().join(', ')}, scoped: ${scoped.length})';
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
