// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ActivationResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ActivationResponse({
    required this.activatedAt,
    required this.expiresAt,
    required this.id,
    required this.reason,
    required this.secondsLeft,
  });

  factory ActivationResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'activated_at',
        r'expires_at',
        r'id',
        r'reason',
        r'seconds_left',
      },
      listKeys: {},
      context: r'ActivationResponse',
    );
    return ActivationResponse(
      activatedAt: _$values[r'activated_at'].decodeSimpleDateTime(
        context: r'ActivationResponse.activated_at',
      ),
      expiresAt: _$values[r'expires_at'].decodeSimpleDateTime(
        context: r'ActivationResponse.expires_at',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'ActivationResponse.id'),
      reason: _$values[r'reason'].decodeSimpleString(
        context: r'ActivationResponse.reason',
      ),
      secondsLeft: _$values[r'seconds_left'].decodeSimpleInt(
        context: r'ActivationResponse.seconds_left',
      ),
    );
  }

  factory ActivationResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ActivationResponse');
    return ActivationResponse(
      activatedAt: _$map[r'activated_at'].decodeJsonDateTime(
        context: r'ActivationResponse.activated_at',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonDateTime(
        context: r'ActivationResponse.expires_at',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'ActivationResponse.id'),
      reason: _$map[r'reason'].decodeJsonString(
        context: r'ActivationResponse.reason',
      ),
      secondsLeft: _$map[r'seconds_left'].decodeJsonInt(
        context: r'ActivationResponse.seconds_left',
      ),
    );
  }

  factory ActivationResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'activated_at',
        r'expires_at',
        r'id',
        r'reason',
        r'seconds_left',
      },
      listKeys: {},
      context: r'ActivationResponse',
    );
    return ActivationResponse(
      activatedAt: _$values[r'activated_at'].decodeFormDateTime(
        context: r'ActivationResponse.activated_at',
      ),
      expiresAt: _$values[r'expires_at'].decodeFormDateTime(
        context: r'ActivationResponse.expires_at',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'ActivationResponse.id'),
      reason: _$values[r'reason'].decodeFormString(
        context: r'ActivationResponse.reason',
      ),
      secondsLeft: _$values[r'seconds_left'].decodeFormInt(
        context: r'ActivationResponse.seconds_left',
      ),
    );
  }

  final _i3.DateTime activatedAt;

  final _i3.DateTime expiresAt;

  final _i3.int id;

  final _i3.String reason;

  final _i3.int secondsLeft;

  @_i3.override
  _i3.Object? toJson() => {
    r'activated_at': activatedAt.toTimeZonedIso8601String(),
    r'expires_at': expiresAt.toTimeZonedIso8601String(),
    r'id': id,
    r'reason': reason,
    r'seconds_left': secondsLeft,
  };

  $$ActivationResponseCopyWith<ActivationResponse> get copyWith =>
      _ActivationResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ActivationResponse &&
        other.activatedAt == this.activatedAt &&
        other.expiresAt == this.expiresAt &&
        other.id == this.id &&
        other.reason == this.reason &&
        other.secondsLeft == this.secondsLeft;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      activatedAt,
      expiresAt,
      id,
      reason,
      secondsLeft,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'activated_at'] = _i1.PropertyValue.scalar(
      activatedAt.toTimeZonedIso8601String(),
    );
    _$result[r'expires_at'] = _i1.PropertyValue.scalar(
      expiresAt.toTimeZonedIso8601String(),
    );
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'reason'] = _i1.PropertyValue.scalar(reason);
    _$result[r'seconds_left'] = _i1.PropertyValue.scalar(
      secondsLeft.toString(),
    );
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
      r'Cannot uriEncode ActivationResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ActivationResponseCopyWith<$Res> {
  factory $$ActivationResponseCopyWith(ActivationResponse value) =
      _ActivationResponseCopyWith<$Res>;

  $Res call({
    _i3.DateTime? activatedAt,
    _i3.DateTime? expiresAt,
    _i3.int? id,
    _i3.String? reason,
    _i3.int? secondsLeft,
  });
  _i3.DateTime get activatedAt;
  _i3.DateTime get expiresAt;
  _i3.int get id;
  _i3.String get reason;
  _i3.int get secondsLeft;
}

class _ActivationResponseCopyWith<$Res>
    implements $$ActivationResponseCopyWith<$Res> {
  _ActivationResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ActivationResponse _value;

  @_i3.override
  _i3.DateTime get activatedAt => _value.activatedAt;

  @_i3.override
  _i3.DateTime get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get reason => _value.reason;

  @_i3.override
  _i3.int get secondsLeft => _value.secondsLeft;

  @_i3.override
  $Res call({
    _i3.Object? activatedAt = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? reason = _sentinel,
    _i3.Object? secondsLeft = _sentinel,
  }) {
    return (ActivationResponse(
      activatedAt: _i3.identical(activatedAt, _sentinel)
          ? this.activatedAt
          : (activatedAt as _i3.DateTime),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i3.String),
      secondsLeft: _i3.identical(secondsLeft, _sentinel)
          ? this.secondsLeft
          : (secondsLeft as _i3.int),
    ) as $Res);
  }
}
