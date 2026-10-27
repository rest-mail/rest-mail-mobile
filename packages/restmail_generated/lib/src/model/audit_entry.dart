// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/audit_entry_actor_kind_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/audit_entry_outcome_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AuditEntry extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AuditEntry({
    required this.action,
    required this.actorId,
    required this.actorKind,
    required this.actorName,
    required this.credentialId,
    required this.errorCode,
    required this.hash,
    required this.ip,
    required this.method,
    required this.occurredAt,
    required this.outcome,
    required this.prevHash,
    required this.requestId,
    required this.route,
    required this.seq,
    required this.sessionId,
    required this.status,
    required this.target,
    required this.userAgent,
  });

  factory AuditEntry.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for AuditEntry: contains complex types',
    );
  }

  factory AuditEntry.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AuditEntry');
    return AuditEntry(
      action: _$map[r'action'].decodeJsonString(context: r'AuditEntry.action'),
      actorId: _$map[r'actor_id'].decodeJsonNullableInt(
        context: r'AuditEntry.actor_id',
      ),
      actorKind: _i4.AuditEntryActorKindModel.fromJson(_$map[r'actor_kind']),
      actorName: _$map[r'actor_name'].decodeJsonString(
        context: r'AuditEntry.actor_name',
      ),
      credentialId: _$map[r'credential_id'].decodeJsonNullableInt(
        context: r'AuditEntry.credential_id',
      ),
      errorCode: _$map[r'error_code'].decodeJsonString(
        context: r'AuditEntry.error_code',
      ),
      hash: _$map[r'hash'].decodeJsonString(context: r'AuditEntry.hash'),
      ip: _$map[r'ip'].decodeJsonString(context: r'AuditEntry.ip'),
      method: _$map[r'method'].decodeJsonString(context: r'AuditEntry.method'),
      occurredAt: _$map[r'occurred_at'].decodeJsonDateTime(
        context: r'AuditEntry.occurred_at',
      ),
      outcome: _i5.AuditEntryOutcomeModel.fromJson(_$map[r'outcome']),
      prevHash: _$map[r'prev_hash'].decodeJsonString(
        context: r'AuditEntry.prev_hash',
      ),
      requestId: _$map[r'request_id'].decodeJsonString(
        context: r'AuditEntry.request_id',
      ),
      route: _$map[r'route'].decodeJsonString(context: r'AuditEntry.route'),
      seq: _$map[r'seq'].decodeJsonInt(context: r'AuditEntry.seq'),
      sessionId: _$map[r'session_id'].decodeJsonString(
        context: r'AuditEntry.session_id',
      ),
      status: _$map[r'status'].decodeJsonInt(context: r'AuditEntry.status'),
      target: _$map[r'target'].decodeJsonMap(
        (v) => v.decodeJsonString(context: r'AuditEntry.target'),
        context: r'AuditEntry.target',
      ),
      userAgent: _$map[r'user_agent'].decodeJsonString(
        context: r'AuditEntry.user_agent',
      ),
    );
  }

  factory AuditEntry.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for AuditEntry: contains complex types',
    );
  }

  final _i3.String action;

  final _i3.int? actorId;

  final _i4.AuditEntryActorKindModel actorKind;

  final _i3.String actorName;

  final _i3.int? credentialId;

  final _i3.String errorCode;

  final _i3.String hash;

  final _i3.String ip;

  final _i3.String method;

  final _i3.DateTime occurredAt;

  final _i5.AuditEntryOutcomeModel outcome;

  final _i3.String prevHash;

  final _i3.String requestId;

  final _i3.String route;

  final _i3.int seq;

  final _i3.String sessionId;

  final _i3.int status;

  final _i3.Map<_i3.String, _i3.String> target;

  final _i3.String userAgent;

  @_i3.override
  _i3.Object? toJson() => {
    r'action': action,
    r'actor_id': actorId,
    r'actor_kind': actorKind.toJson(),
    r'actor_name': actorName,
    r'credential_id': credentialId,
    r'error_code': errorCode,
    r'hash': hash,
    r'ip': ip,
    r'method': method,
    r'occurred_at': occurredAt.toTimeZonedIso8601String(),
    r'outcome': outcome.toJson(),
    r'prev_hash': prevHash,
    r'request_id': requestId,
    r'route': route,
    r'seq': seq,
    r'session_id': sessionId,
    r'status': status,
    r'target': target,
    r'user_agent': userAgent,
  };

  $$AuditEntryCopyWith<AuditEntry> get copyWith => _AuditEntryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is AuditEntry &&
        other.action == this.action &&
        other.actorId == this.actorId &&
        other.actorKind == this.actorKind &&
        other.actorName == this.actorName &&
        other.credentialId == this.credentialId &&
        other.errorCode == this.errorCode &&
        other.hash == this.hash &&
        other.ip == this.ip &&
        other.method == this.method &&
        other.occurredAt == this.occurredAt &&
        other.outcome == this.outcome &&
        other.prevHash == this.prevHash &&
        other.requestId == this.requestId &&
        other.route == this.route &&
        other.seq == this.seq &&
        other.sessionId == this.sessionId &&
        other.status == this.status &&
        _$deepEquals.equals(other.target, this.target) &&
        other.userAgent == this.userAgent;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      action,
      actorId,
      actorKind,
      actorName,
      credentialId,
      errorCode,
      hash,
      ip,
      method,
      occurredAt,
      outcome,
      prevHash,
      requestId,
      route,
      seq,
      sessionId,
      status,
      deepEquals.hash(target),
      userAgent,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for AuditEntry: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode AuditEntry: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AuditEntryCopyWith<$Res> {
  factory $$AuditEntryCopyWith(AuditEntry value) = _AuditEntryCopyWith<$Res>;

  $Res call({
    _i3.String? action,
    _i3.int? actorId,
    _i4.AuditEntryActorKindModel? actorKind,
    _i3.String? actorName,
    _i3.int? credentialId,
    _i3.String? errorCode,
    _i3.String? hash,
    _i3.String? ip,
    _i3.String? method,
    _i3.DateTime? occurredAt,
    _i5.AuditEntryOutcomeModel? outcome,
    _i3.String? prevHash,
    _i3.String? requestId,
    _i3.String? route,
    _i3.int? seq,
    _i3.String? sessionId,
    _i3.int? status,
    _i3.Map<_i3.String, _i3.String>? target,
    _i3.String? userAgent,
  });
  _i3.String get action;
  _i3.int? get actorId;
  _i4.AuditEntryActorKindModel get actorKind;
  _i3.String get actorName;
  _i3.int? get credentialId;
  _i3.String get errorCode;
  _i3.String get hash;
  _i3.String get ip;
  _i3.String get method;
  _i3.DateTime get occurredAt;
  _i5.AuditEntryOutcomeModel get outcome;
  _i3.String get prevHash;
  _i3.String get requestId;
  _i3.String get route;
  _i3.int get seq;
  _i3.String get sessionId;
  _i3.int get status;
  _i3.Map<_i3.String, _i3.String> get target;
  _i3.String get userAgent;
}

class _AuditEntryCopyWith<$Res> implements $$AuditEntryCopyWith<$Res> {
  _AuditEntryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AuditEntry _value;

  @_i3.override
  _i3.String get action => _value.action;

  @_i3.override
  _i3.int? get actorId => _value.actorId;

  @_i3.override
  _i4.AuditEntryActorKindModel get actorKind => _value.actorKind;

  @_i3.override
  _i3.String get actorName => _value.actorName;

  @_i3.override
  _i3.int? get credentialId => _value.credentialId;

  @_i3.override
  _i3.String get errorCode => _value.errorCode;

  @_i3.override
  _i3.String get hash => _value.hash;

  @_i3.override
  _i3.String get ip => _value.ip;

  @_i3.override
  _i3.String get method => _value.method;

  @_i3.override
  _i3.DateTime get occurredAt => _value.occurredAt;

  @_i3.override
  _i5.AuditEntryOutcomeModel get outcome => _value.outcome;

  @_i3.override
  _i3.String get prevHash => _value.prevHash;

  @_i3.override
  _i3.String get requestId => _value.requestId;

  @_i3.override
  _i3.String get route => _value.route;

  @_i3.override
  _i3.int get seq => _value.seq;

  @_i3.override
  _i3.String get sessionId => _value.sessionId;

  @_i3.override
  _i3.int get status => _value.status;

  @_i3.override
  _i3.Map<_i3.String, _i3.String> get target => _value.target;

  @_i3.override
  _i3.String get userAgent => _value.userAgent;

  @_i3.override
  $Res call({
    _i3.Object? action = _sentinel,
    _i3.Object? actorId = _sentinel,
    _i3.Object? actorKind = _sentinel,
    _i3.Object? actorName = _sentinel,
    _i3.Object? credentialId = _sentinel,
    _i3.Object? errorCode = _sentinel,
    _i3.Object? hash = _sentinel,
    _i3.Object? ip = _sentinel,
    _i3.Object? method = _sentinel,
    _i3.Object? occurredAt = _sentinel,
    _i3.Object? outcome = _sentinel,
    _i3.Object? prevHash = _sentinel,
    _i3.Object? requestId = _sentinel,
    _i3.Object? route = _sentinel,
    _i3.Object? seq = _sentinel,
    _i3.Object? sessionId = _sentinel,
    _i3.Object? status = _sentinel,
    _i3.Object? target = _sentinel,
    _i3.Object? userAgent = _sentinel,
  }) {
    return (AuditEntry(
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action as _i3.String),
      actorId: _i3.identical(actorId, _sentinel)
          ? this.actorId
          : (actorId as _i3.int?),
      actorKind: _i3.identical(actorKind, _sentinel)
          ? this.actorKind
          : (actorKind as _i4.AuditEntryActorKindModel),
      actorName: _i3.identical(actorName, _sentinel)
          ? this.actorName
          : (actorName as _i3.String),
      credentialId: _i3.identical(credentialId, _sentinel)
          ? this.credentialId
          : (credentialId as _i3.int?),
      errorCode: _i3.identical(errorCode, _sentinel)
          ? this.errorCode
          : (errorCode as _i3.String),
      hash: _i3.identical(hash, _sentinel) ? this.hash : (hash as _i3.String),
      ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String),
      method: _i3.identical(method, _sentinel)
          ? this.method
          : (method as _i3.String),
      occurredAt: _i3.identical(occurredAt, _sentinel)
          ? this.occurredAt
          : (occurredAt as _i3.DateTime),
      outcome: _i3.identical(outcome, _sentinel)
          ? this.outcome
          : (outcome as _i5.AuditEntryOutcomeModel),
      prevHash: _i3.identical(prevHash, _sentinel)
          ? this.prevHash
          : (prevHash as _i3.String),
      requestId: _i3.identical(requestId, _sentinel)
          ? this.requestId
          : (requestId as _i3.String),
      route: _i3.identical(route, _sentinel)
          ? this.route
          : (route as _i3.String),
      seq: _i3.identical(seq, _sentinel) ? this.seq : (seq as _i3.int),
      sessionId: _i3.identical(sessionId, _sentinel)
          ? this.sessionId
          : (sessionId as _i3.String),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i3.int),
      target: _i3.identical(target, _sentinel)
          ? this.target
          : (target as _i3.Map<_i3.String, _i3.String>),
      userAgent: _i3.identical(userAgent, _sentinel)
          ? this.userAgent
          : (userAgent as _i3.String),
    ) as $Res);
  }
}
