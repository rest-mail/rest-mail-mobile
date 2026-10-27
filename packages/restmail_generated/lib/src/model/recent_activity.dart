// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RecentActivity extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RecentActivity({
    required this.description,
    required this.id,
    required this.timestamp,
    required this.$type,
  });

  factory RecentActivity.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'description', r'id', r'timestamp', r'type'},
      listKeys: {},
      context: r'RecentActivity',
    );
    return RecentActivity(
      description: _$values[r'description'].decodeSimpleString(
        context: r'RecentActivity.description',
      ),
      id: _$values[r'id'].decodeSimpleString(context: r'RecentActivity.id'),
      timestamp: _$values[r'timestamp'].decodeSimpleDateTime(
        context: r'RecentActivity.timestamp',
      ),
      $type: _$values[r'type'].decodeSimpleString(
        context: r'RecentActivity.type',
      ),
    );
  }

  factory RecentActivity.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RecentActivity');
    return RecentActivity(
      description: _$map[r'description'].decodeJsonString(
        context: r'RecentActivity.description',
      ),
      id: _$map[r'id'].decodeJsonString(context: r'RecentActivity.id'),
      timestamp: _$map[r'timestamp'].decodeJsonDateTime(
        context: r'RecentActivity.timestamp',
      ),
      $type: _$map[r'type'].decodeJsonString(context: r'RecentActivity.type'),
    );
  }

  factory RecentActivity.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'description', r'id', r'timestamp', r'type'},
      listKeys: {},
      context: r'RecentActivity',
    );
    return RecentActivity(
      description: _$values[r'description'].decodeFormString(
        context: r'RecentActivity.description',
      ),
      id: _$values[r'id'].decodeFormString(context: r'RecentActivity.id'),
      timestamp: _$values[r'timestamp'].decodeFormDateTime(
        context: r'RecentActivity.timestamp',
      ),
      $type: _$values[r'type'].decodeFormString(
        context: r'RecentActivity.type',
      ),
    );
  }

  final _i3.String description;

  final _i3.String id;

  final _i3.DateTime timestamp;

  final _i3.String $type;

  @_i3.override
  _i3.Object? toJson() => {
    r'description': description,
    r'id': id,
    r'timestamp': timestamp.toTimeZonedIso8601String(),
    r'type': $type,
  };

  $$RecentActivityCopyWith<RecentActivity> get copyWith =>
      _RecentActivityCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecentActivity &&
        other.description == this.description &&
        other.id == this.id &&
        other.timestamp == this.timestamp &&
        other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([description, id, timestamp, $type]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'description'] = _i1.PropertyValue.scalar(description);
    _$result[r'id'] = _i1.PropertyValue.scalar(id);
    _$result[r'timestamp'] = _i1.PropertyValue.scalar(
      timestamp.toTimeZonedIso8601String(),
    );
    _$result[r'type'] = _i1.PropertyValue.scalar($type);
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
      r'Cannot uriEncode RecentActivity: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RecentActivityCopyWith<$Res> {
  factory $$RecentActivityCopyWith(RecentActivity value) =
      _RecentActivityCopyWith<$Res>;

  $Res call({
    _i3.String? description,
    _i3.String? id,
    _i3.DateTime? timestamp,
    _i3.String? $type,
  });
  _i3.String get description;
  _i3.String get id;
  _i3.DateTime get timestamp;
  _i3.String get $type;
}

class _RecentActivityCopyWith<$Res> implements $$RecentActivityCopyWith<$Res> {
  _RecentActivityCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RecentActivity _value;

  @_i3.override
  _i3.String get description => _value.description;

  @_i3.override
  _i3.String get id => _value.id;

  @_i3.override
  _i3.DateTime get timestamp => _value.timestamp;

  @_i3.override
  _i3.String get $type => _value.$type;

  @_i3.override
  $Res call({
    _i3.Object? description = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? timestamp = _sentinel,
    _i3.Object? $type = _sentinel,
  }) {
    return (RecentActivity(
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.String),
      timestamp: _i3.identical(timestamp, _sentinel)
          ? this.timestamp
          : (timestamp as _i3.DateTime),
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i3.String),
    ) as $Res);
  }
}
