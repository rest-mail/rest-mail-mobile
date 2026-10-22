import 'capabilities.dart';

// Roles, capabilities, grants and escalation, as rest-mail-server's
// `internal/api/handlers/grants.go` and `escalation.go` send them.

/// A role that can be granted, with the capabilities it gives.
class AdminRole {
  const AdminRole({
    required this.id,
    required this.name,
    this.description = '',
    this.systemRole = false,
    this.capabilities = const [],
  });

  factory AdminRole.fromJson(Map<String, dynamic> json) => AdminRole(
    id: _int(json['id']),
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    systemRole: json['system_role'] == true,
    capabilities: _names(json['capabilities']),
  );

  final int id;

  /// What a grant names it by: `superadmin`, `admin`, `domain-admin`…
  final String name;
  final String description;

  /// One the server ships with, rather than one an admin made.
  final bool systemRole;

  /// The capability names it gives; `*` for everything.
  final List<String> capabilities;
}

/// One capability the server checks, from `GET /admin/capabilities`.
class CapabilityDefinition {
  const CapabilityDefinition({
    required this.id,
    required this.name,
    this.description = '',
    this.resource = '',
    this.action = '',
  });

  factory CapabilityDefinition.fromJson(Map<String, dynamic> json) =>
      CapabilityDefinition(
        id: _int(json['id']),
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        resource: json['resource'] as String? ?? '',
        action: json['action'] as String? ?? '',
      );

  final int id;

  /// `resource:action`, as [Capability] lists them.
  final String name;
  final String description;
  final String resource;
  final String action;
}

/// Whether a grant gives its role all the time, or only once switched on.
enum GrantMode {
  active,
  eligible,
  unknown;

  static GrantMode parse(Object? value) => GrantMode.values.firstWhere(
    (m) => m != unknown && m.name == value,
    orElse: () => GrantMode.unknown,
  );
}

/// Who holds a grant. Only accounts can be granted roles yet.
class GrantHolder {
  const GrantHolder({required this.kind, required this.id});

  /// An account's: the only kind the server grants to yet.
  const GrantHolder.account(this.id) : kind = accountKind;

  factory GrantHolder.fromJson(Map<String, dynamic> json) =>
      GrantHolder(kind: json['kind'] as String? ?? '', id: _int(json['id']));

  static const accountKind = 'account';

  final String kind;
  final int id;

  Map<String, Object> toJson() => {'kind': kind, 'id': id};

  @override
  bool operator ==(Object other) =>
      other is GrantHolder && other.kind == kind && other.id == id;

  @override
  int get hashCode => Object.hash(kind, id);
}

/// Who made a grant: an account, or the server itself (no [id]).
class GrantActor {
  const GrantActor({required this.kind, this.id});

  factory GrantActor.fromJson(Map<String, dynamic> json) => GrantActor(
    kind: json['kind'] as String? ?? '',
    id: (json['id'] as num?)?.toInt(),
  );

  final String kind;
  final int? id;
}

/// An eligible grant switched on, for a while.
class GrantActivation {
  const GrantActivation({
    required this.id,
    required this.activatedAt,
    required this.expiresAt,
    this.reason = '',
    this.secondsLeft = 0,
  });

  factory GrantActivation.fromJson(Map<String, dynamic> json) =>
      GrantActivation(
        id: _int(json['id']),
        activatedAt: _time(json['activated_at']) ?? DateTime.now(),
        expiresAt: _time(json['expires_at']) ?? DateTime.now(),
        reason: json['reason'] as String? ?? '',
        secondsLeft: (json['seconds_left'] as num?)?.toInt() ?? 0,
      );

  final int id;
  final DateTime activatedAt;

  /// When it switches itself off.
  final DateTime expiresAt;

  /// Why the holder switched it on.
  final String reason;

  /// How long it had left when the server answered; never negative.
  final int secondsLeft;
}

/// A role held at a scope.
class Grant {
  const Grant({
    required this.id,
    required this.holder,
    required this.role,
    required this.roleId,
    required this.scope,
    required this.mode,
    required this.grantedBy,
    required this.grantedAt,
    this.expiresAt,
    this.activation,
  });

  factory Grant.fromJson(Map<String, dynamic> json) => Grant(
    id: _int(json['id']),
    holder: GrantHolder.fromJson(
      json['holder'] as Map<String, dynamic>? ?? const {'id': 0},
    ),
    role: json['role'] as String? ?? '',
    roleId: (json['role_id'] as num?)?.toInt() ?? 0,
    scope: json['scope'] as String? ?? '',
    mode: GrantMode.parse(json['mode']),
    grantedBy: GrantActor.fromJson(
      json['granted_by'] as Map<String, dynamic>? ?? const {},
    ),
    grantedAt: _time(json['granted_at']) ?? DateTime.now(),
    expiresAt: _time(json['expires_at']),
    activation: switch (json['activation']) {
      final Map<String, dynamic> a => GrantActivation.fromJson(a),
      _ => null,
    },
  );

  final int id;
  final GrantHolder holder;

  /// The role's name, as [AdminRole.name].
  final String role;
  final int roleId;

  /// `*`, `domain:<name>` or `mailbox:<address>`.
  final String scope;
  final GrantMode mode;
  final GrantActor grantedBy;
  final DateTime grantedAt;

  /// When the grant itself ends; none for one that lasts until removed.
  final DateTime? expiresAt;

  /// The activation running now, of an eligible grant switched on.
  final GrantActivation? activation;

  /// Whether it gives its role now: an active grant always does, an eligible
  /// one while switched on.
  bool get isInForce =>
      mode == GrantMode.active ||
      (mode == GrantMode.eligible && activation != null);
}

/// A grant after a step of escalation, and what its holder now holds.
class Escalation {
  const Escalation({required this.grant, required this.capabilities});

  factory Escalation.fromJson(Map<String, dynamic> json) => Escalation(
    grant: Grant.fromJson(json['grant'] as Map<String, dynamic>),
    capabilities: Capabilities.fromJson(json['capabilities']),
  );

  final Grant grant;

  /// Everything the holder holds at `*` after the step, as sign-in lists it.
  final Capabilities capabilities;
}

/// The `ApiException.code`s the grant and escalation routes answer with,
/// beyond `validation_failed`, `not_found` and `forbidden`.
abstract final class GrantErrorCode {
  /// Changing grants, or escalating, needs a session signed in with a second
  /// factor (grants), or an enrolled authenticator (escalation). 403.
  static const twoFactorRequired = 'two_factor_required';

  /// Switching on or making eligible needs a fresh `totp_code` or
  /// `recovery_code`: thrown as `TotpRequiredException`. 403.
  static const totpRequired = 'totp_required';

  /// The fresh code was wrong. 403, and not a sign-out.
  static const invalidTotp = 'invalid_totp';

  /// The granter does not hold the role, or not at a scope that wide. 403.
  static const exceedsHeld = 'grant_exceeds_held';

  /// The holder already has that role at that scope. 409.
  static const conflict = 'conflict';

  /// Removing it would leave nobody who holds superadmin. 409.
  static const lastSuperadmin = 'last_superadmin';

  /// Only an eligible grant can be switched on. 409.
  static const notEligible = 'not_eligible';
  static const alreadyActive = 'already_active';
  static const notActive = 'not_active';
  static const grantExpired = 'grant_expired';
  static const alreadyEligible = 'already_eligible';
}

int _int(Object? value) => (value as num).toInt();

List<String> _names(Object? value) => [
  if (value is List)
    for (final name in value)
      if (name is String) name,
];

/// A timestamp, or null for none. Go writes an unset time as year 1.
DateTime? _time(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null || parsed.year < 1971) return null;
  return parsed.toLocal();
}
