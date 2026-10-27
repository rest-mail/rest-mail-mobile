// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TwoFactorStatusResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TwoFactorStatusResponse({required this.enabled, required this.pending});

  factory TwoFactorStatusResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'enabled', r'pending'},
      listKeys: {},
      context: r'TwoFactorStatusResponse',
    );
    return TwoFactorStatusResponse(
      enabled: _$values[r'enabled'].decodeSimpleBool(
        context: r'TwoFactorStatusResponse.enabled',
      ),
      pending: _$values[r'pending'].decodeSimpleBool(
        context: r'TwoFactorStatusResponse.pending',
      ),
    );
  }

  factory TwoFactorStatusResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TwoFactorStatusResponse');
    return TwoFactorStatusResponse(
      enabled: _$map[r'enabled'].decodeJsonBool(
        context: r'TwoFactorStatusResponse.enabled',
      ),
      pending: _$map[r'pending'].decodeJsonBool(
        context: r'TwoFactorStatusResponse.pending',
      ),
    );
  }

  factory TwoFactorStatusResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'enabled', r'pending'},
      listKeys: {},
      context: r'TwoFactorStatusResponse',
    );
    return TwoFactorStatusResponse(
      enabled: _$values[r'enabled'].decodeFormBool(
        context: r'TwoFactorStatusResponse.enabled',
      ),
      pending: _$values[r'pending'].decodeFormBool(
        context: r'TwoFactorStatusResponse.pending',
      ),
    );
  }

  final _i3.bool enabled;

  final _i3.bool pending;

  @_i3.override
  _i3.Object? toJson() => {r'enabled': enabled, r'pending': pending};

  $$TwoFactorStatusResponseCopyWith<TwoFactorStatusResponse> get copyWith =>
      _TwoFactorStatusResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TwoFactorStatusResponse &&
        other.enabled == this.enabled &&
        other.pending == this.pending;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([enabled, pending]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'enabled'] = _i1.PropertyValue.scalar(enabled.toString());
    _$result[r'pending'] = _i1.PropertyValue.scalar(pending.toString());
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
      r'Cannot uriEncode TwoFactorStatusResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TwoFactorStatusResponseCopyWith<$Res> {
  factory $$TwoFactorStatusResponseCopyWith(TwoFactorStatusResponse value) =
      _TwoFactorStatusResponseCopyWith<$Res>;

  $Res call({_i3.bool? enabled, _i3.bool? pending});
  _i3.bool get enabled;
  _i3.bool get pending;
}

class _TwoFactorStatusResponseCopyWith<$Res>
    implements $$TwoFactorStatusResponseCopyWith<$Res> {
  _TwoFactorStatusResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TwoFactorStatusResponse _value;

  @_i3.override
  _i3.bool get enabled => _value.enabled;

  @_i3.override
  _i3.bool get pending => _value.pending;

  @_i3.override
  $Res call({
    _i3.Object? enabled = _sentinel,
    _i3.Object? pending = _sentinel,
  }) {
    return (TwoFactorStatusResponse(
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i3.bool),
      pending: _i3.identical(pending, _sentinel)
          ? this.pending
          : (pending as _i3.bool),
    ) as $Res);
  }
}
