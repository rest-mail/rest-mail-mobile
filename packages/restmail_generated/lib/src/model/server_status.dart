// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServerStatus extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServerStatus({
    required this.builtAt,
    required this.commit,
    required this.startedAt,
    required this.version,
  });

  factory ServerStatus.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'built_at', r'commit', r'started_at', r'version'},
      listKeys: {},
      context: r'ServerStatus',
    );
    return ServerStatus(
      builtAt: _$values[r'built_at'].decodeSimpleString(
        context: r'ServerStatus.built_at',
      ),
      commit: _$values[r'commit'].decodeSimpleString(
        context: r'ServerStatus.commit',
      ),
      startedAt: _$values[r'started_at'].decodeSimpleDateTime(
        context: r'ServerStatus.started_at',
      ),
      version: _$values[r'version'].decodeSimpleString(
        context: r'ServerStatus.version',
      ),
    );
  }

  factory ServerStatus.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServerStatus');
    return ServerStatus(
      builtAt: _$map[r'built_at'].decodeJsonString(
        context: r'ServerStatus.built_at',
      ),
      commit: _$map[r'commit'].decodeJsonString(
        context: r'ServerStatus.commit',
      ),
      startedAt: _$map[r'started_at'].decodeJsonDateTime(
        context: r'ServerStatus.started_at',
      ),
      version: _$map[r'version'].decodeJsonString(
        context: r'ServerStatus.version',
      ),
    );
  }

  factory ServerStatus.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'built_at', r'commit', r'started_at', r'version'},
      listKeys: {},
      context: r'ServerStatus',
    );
    return ServerStatus(
      builtAt: _$values[r'built_at'].decodeFormString(
        context: r'ServerStatus.built_at',
      ),
      commit: _$values[r'commit'].decodeFormString(
        context: r'ServerStatus.commit',
      ),
      startedAt: _$values[r'started_at'].decodeFormDateTime(
        context: r'ServerStatus.started_at',
      ),
      version: _$values[r'version'].decodeFormString(
        context: r'ServerStatus.version',
      ),
    );
  }

  final _i3.String builtAt;

  final _i3.String commit;

  final _i3.DateTime startedAt;

  final _i3.String version;

  @_i3.override
  _i3.Object? toJson() => {
    r'built_at': builtAt,
    r'commit': commit,
    r'started_at': startedAt.toTimeZonedIso8601String(),
    r'version': version,
  };

  $$ServerStatusCopyWith<ServerStatus> get copyWith =>
      _ServerStatusCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServerStatus &&
        other.builtAt == this.builtAt &&
        other.commit == this.commit &&
        other.startedAt == this.startedAt &&
        other.version == this.version;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([builtAt, commit, startedAt, version]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'built_at'] = _i1.PropertyValue.scalar(builtAt);
    _$result[r'commit'] = _i1.PropertyValue.scalar(commit);
    _$result[r'started_at'] = _i1.PropertyValue.scalar(
      startedAt.toTimeZonedIso8601String(),
    );
    _$result[r'version'] = _i1.PropertyValue.scalar(version);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServerStatus: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ServerStatusCopyWith<$Res> {
  factory $$ServerStatusCopyWith(ServerStatus value) =
      _ServerStatusCopyWith<$Res>;

  $Res call({
    _i3.String? builtAt,
    _i3.String? commit,
    _i3.DateTime? startedAt,
    _i3.String? version,
  });
  _i3.String get builtAt;
  _i3.String get commit;
  _i3.DateTime get startedAt;
  _i3.String get version;
}

class _ServerStatusCopyWith<$Res> implements $$ServerStatusCopyWith<$Res> {
  _ServerStatusCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ServerStatus _value;

  @_i3.override
  _i3.String get builtAt => _value.builtAt;

  @_i3.override
  _i3.String get commit => _value.commit;

  @_i3.override
  _i3.DateTime get startedAt => _value.startedAt;

  @_i3.override
  _i3.String get version => _value.version;

  @_i3.override
  $Res call({
    _i3.Object? builtAt = _sentinel,
    _i3.Object? commit = _sentinel,
    _i3.Object? startedAt = _sentinel,
    _i3.Object? version = _sentinel,
  }) {
    return (ServerStatus(
      builtAt: _i3.identical(builtAt, _sentinel)
          ? this.builtAt
          : (builtAt as _i3.String),
      commit: _i3.identical(commit, _sentinel)
          ? this.commit
          : (commit as _i3.String),
      startedAt: _i3.identical(startedAt, _sentinel)
          ? this.startedAt
          : (startedAt as _i3.DateTime),
      version: _i3.identical(version, _sentinel)
          ? this.version
          : (version as _i3.String),
    ) as $Res);
  }
}
