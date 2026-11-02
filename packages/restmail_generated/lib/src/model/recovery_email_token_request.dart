// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RecoveryEmailTokenRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RecoveryEmailTokenRequest({required this.token});

  factory RecoveryEmailTokenRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'token'},
      listKeys: {},
      context: r'RecoveryEmailTokenRequest',
    );
    return RecoveryEmailTokenRequest(
      token: _$values[r'token'].decodeSimpleString(
        context: r'RecoveryEmailTokenRequest.token',
      ),
    );
  }

  factory RecoveryEmailTokenRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RecoveryEmailTokenRequest');
    return RecoveryEmailTokenRequest(
      token: _$map[r'token'].decodeJsonString(
        context: r'RecoveryEmailTokenRequest.token',
      ),
    );
  }

  factory RecoveryEmailTokenRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'token'},
      listKeys: {},
      context: r'RecoveryEmailTokenRequest',
    );
    return RecoveryEmailTokenRequest(
      token: _$values[r'token'].decodeFormString(
        context: r'RecoveryEmailTokenRequest.token',
      ),
    );
  }

  final _i3.String token;

  @_i3.override
  _i3.Object? toJson() => {r'token': token};

  $$RecoveryEmailTokenRequestCopyWith<RecoveryEmailTokenRequest> get copyWith =>
      _RecoveryEmailTokenRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoveryEmailTokenRequest && other.token == this.token;
  }

  @_i3.override
  _i3.int get hashCode => token.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'token'] = _i1.PropertyValue.scalar(token);
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
      r'Cannot uriEncode RecoveryEmailTokenRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RecoveryEmailTokenRequestCopyWith<$Res> {
  factory $$RecoveryEmailTokenRequestCopyWith(RecoveryEmailTokenRequest value) =
      _RecoveryEmailTokenRequestCopyWith<$Res>;

  $Res call({_i3.String? token});
  _i3.String get token;
}

class _RecoveryEmailTokenRequestCopyWith<$Res>
    implements $$RecoveryEmailTokenRequestCopyWith<$Res> {
  _RecoveryEmailTokenRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RecoveryEmailTokenRequest _value;

  @_i3.override
  _i3.String get token => _value.token;

  @_i3.override
  $Res call({_i3.Object? token = _sentinel}) {
    return (RecoveryEmailTokenRequest(
      token: _i3.identical(token, _sentinel)
          ? this.token
          : (token as _i3.String),
    ) as $Res);
  }
}
