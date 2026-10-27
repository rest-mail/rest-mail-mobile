// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RefreshRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RefreshRequest({this.refreshToken});

  factory RefreshRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'refresh_token'},
      listKeys: {},
      context: r'RefreshRequest',
    );
    return RefreshRequest(
      refreshToken: _$values[r'refresh_token'].decodeSimpleNullableString(
        context: r'RefreshRequest.refresh_token',
      ),
    );
  }

  factory RefreshRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RefreshRequest');
    return RefreshRequest(
      refreshToken: _$map[r'refresh_token'].decodeJsonNullableString(
        context: r'RefreshRequest.refresh_token',
      ),
    );
  }

  factory RefreshRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'refresh_token'},
      listKeys: {},
      context: r'RefreshRequest',
    );
    return RefreshRequest(
      refreshToken: _$values[r'refresh_token'].decodeFormNullableString(
        context: r'RefreshRequest.refresh_token',
      ),
    );
  }

  final _i3.String? refreshToken;

  @_i3.override
  _i3.Object? toJson() => {
    if (refreshToken != null) r'refresh_token': refreshToken,
  };

  $$RefreshRequestCopyWith<RefreshRequest> get copyWith =>
      _RefreshRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshRequest && other.refreshToken == this.refreshToken;
  }

  @_i3.override
  _i3.int get hashCode => refreshToken.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (refreshToken != null) {
      _$result[r'refresh_token'] = _i1.PropertyValue.scalar(refreshToken!);
    }
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
      r'Cannot uriEncode RefreshRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RefreshRequestCopyWith<$Res> {
  factory $$RefreshRequestCopyWith(RefreshRequest value) =
      _RefreshRequestCopyWith<$Res>;

  $Res call({_i3.String? refreshToken});
  _i3.String? get refreshToken;
}

class _RefreshRequestCopyWith<$Res> implements $$RefreshRequestCopyWith<$Res> {
  _RefreshRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RefreshRequest _value;

  @_i3.override
  _i3.String? get refreshToken => _value.refreshToken;

  @_i3.override
  $Res call({_i3.Object? refreshToken = _sentinel}) {
    return (RefreshRequest(
      refreshToken: _i3.identical(refreshToken, _sentinel)
          ? this.refreshToken
          : (refreshToken as _i3.String?),
    ) as $Res);
  }
}
